import 'dart:async';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/theme/theme_provider.dart';
import '../../../core/utils/qr_payload_parser.dart';
import '../../../core/widgets/pp_button.dart';
import '../../../core/widgets/pp_text_field.dart';
import '../../inventory/data/inventory_repository.dart';

/// Ambinet-style high-performance QR and Barcode scanner for PartPouch.
/// Features a dark vignette overlay, smooth corner brackets, animated laser line,
/// circular quick controls (close, torch, browse media / gallery), and seamless part lookup.
class QrScannerScreen extends ConsumerStatefulWidget {
  const QrScannerScreen({super.key});

  @override
  ConsumerState<QrScannerScreen> createState() => _QrScannerScreenState();
}

class _QrScannerScreenState extends ConsumerState<QrScannerScreen>
    with WidgetsBindingObserver, SingleTickerProviderStateMixin {
  late MobileScannerController _controller;
  StreamSubscription<BarcodeCapture>? _subscription;
  late AnimationController _scanLineController;
  final Key _scannerKey = UniqueKey();

  bool _isProcessing = false;
  bool _flashOn = false;
  String? _errorText;

  // Viewfinder sizing
  static const double _frameSize = 260.0;
  static const double _cutOutSize = 300.0;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);

    _controller = MobileScannerController(
      autoStart: false,
      facing: CameraFacing.back,
      detectionSpeed: DetectionSpeed.normal,
      torchEnabled: false,
      autoZoom: true,
    );

    _subscription = _controller.barcodes.listen(_handleBarcode);

    _scanLineController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1600),
    )..repeat(reverse: true);

    _startCamera();
  }

  Future<void> _startCamera() async {
    try {
      await _controller.start();
    } catch (e) {
      debugPrint('Failed to start scanner camera: $e');
    }
  }

  Future<void> _handleBarcode(BarcodeCapture capture) async {
    if (_isProcessing) return;
    final raw = capture.barcodes.firstOrNull?.rawValue?.trim();
    if (raw == null || raw.isEmpty) return;

    _isProcessing = true;
    HapticFeedback.mediumImpact();

    // Pause stream while resolving part
    _subscription?.cancel();
    _subscription = null;
    await _controller.stop();

    await _processPayload(raw);
  }

  Future<void> _processPayload(String raw) async {
    final theme = ThemeProvider();
    final payload = QrPayload.parse(raw);

    // 1. Direct Component ID lookup
    if (payload.type == QrTargetType.component) {
      final comp = await ref
          .read(inventoryRepositoryProvider)
          .getComponentById(payload.id);
      if (mounted && comp != null) {
        context.pushReplacement('/component/${comp.id}');
        return;
      }
    }

    // 2. Direct Location ID lookup
    if (payload.type == QrTargetType.location) {
      if (mounted) {
        context.pushReplacement('/locations');
        return;
      }
    }

    // 3. Match by SKU, MPN, or component name
    final components = await ref
        .read(inventoryRepositoryProvider)
        .watchComponentsWithStock(query: payload.id)
        .first;

    if (mounted) {
      if (components.isNotEmpty) {
        context.pushReplacement('/component/${components.first.component.id}');
        return;
      }

      // Unrecognized code — show feedback and resume scanner
      HapticFeedback.heavyImpact();
      setState(() {
        _errorText = '${theme.translate('unrecognized_code')}: "$raw"';
      });

      Future.delayed(const Duration(milliseconds: 2200), () {
        if (mounted) {
          setState(() {
            _errorText = null;
            _isProcessing = false;
          });
          _subscription = _controller.barcodes.listen(_handleBarcode);
          _controller.start();
        }
      });
    }
  }

  Future<void> _toggleFlash() async {
    HapticFeedback.selectionClick();
    await _controller.toggleTorch();
    setState(() => _flashOn = !_flashOn);
  }

  Future<void> _pickImageFromGallery() async {
    HapticFeedback.selectionClick();
    final theme = ThemeProvider();

    try {
      final files = await FilePicker.pickFiles(
        type: FileType.image,
      );

      if (files.isEmpty) return;

      final path = files.first.xFile.path;
      if (path.isEmpty) return;

      setState(() => _isProcessing = true);

      // Analyze image file using MobileScannerController
      final capture = await _controller.analyzeImage(path);
      final raw = capture?.barcodes.firstOrNull?.rawValue?.trim();

      if (raw != null && raw.isNotEmpty) {
        HapticFeedback.mediumImpact();
        await _processPayload(raw);
      } else {
        HapticFeedback.heavyImpact();
        if (mounted) {
          setState(() {
            _errorText = theme.translate('no_qr_found_in_image');
            _isProcessing = false;
          });

          Future.delayed(const Duration(milliseconds: 2500), () {
            if (mounted) {
              setState(() => _errorText = null);
            }
          });
        }
      }
    } catch (e) {
      debugPrint('Error analyzing image from gallery: $e');
      if (mounted) {
        setState(() {
          _errorText = theme.translate('error_scanning_image');
          _isProcessing = false;
        });

        Future.delayed(const Duration(milliseconds: 2500), () {
          if (mounted) {
            setState(() => _errorText = null);
          }
        });
      }
    }
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (!_controller.value.hasCameraPermission) return;

    if (state == AppLifecycleState.resumed) {
      _subscription?.cancel();
      _subscription = _controller.barcodes.listen(_handleBarcode);
      _startCamera();
    } else if (state == AppLifecycleState.inactive ||
        state == AppLifecycleState.paused) {
      _subscription?.cancel();
      _subscription = null;
      _controller.stop();
    }
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _subscription?.cancel();
    _controller.dispose();
    _scanLineController.dispose();
    super.dispose();
  }

  void _showManualEntryDialog() {
    final theme = ThemeProvider();
    final textController = TextEditingController();

    showDialog(
      context: context,
      builder: (dialogCtx) => AlertDialog(
        backgroundColor: theme.secondaryColor,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
        title: Text(
          theme.translate('manual_lookup'),
          style: theme.textStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: theme.textColor,
          ),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              theme.translate('manual_lookup_hint'),
              style: theme.textStyle(
                fontSize: 13,
                color: theme.subTextColor,
              ),
            ),
            const SizedBox(height: 14),
            PpTextField(
              controller: textController,
              hint: 'e.g. ESP32-WROOM, 10k-0805, CMP-001',
              autofocus: true,
            ),
          ],
        ),
        actionsPadding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
        actions: [
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              TextButton(
                onPressed: () => Navigator.pop(dialogCtx),
                child: Text(
                  theme.translate('cancel'),
                  style: theme.textStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: theme.subTextColor,
                  ),
                ),
              ),
              const SizedBox(width: 8),
              ElevatedButton(
                onPressed: () {
                  final text = textController.text.trim();
                  Navigator.pop(dialogCtx);
                  if (text.isNotEmpty) {
                    _processPayload(text);
                  }
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: theme.activeColor,
                  foregroundColor: Colors.white,
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: Text(
                  theme.translate('search'),
                  style: theme.textStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = ThemeProvider();
    final topPadding = MediaQuery.of(context).padding.top;
    final bottomPadding = MediaQuery.of(context).padding.bottom;

    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          // 1. Camera Feed with scan window constraint
          MobileScanner(
            key: _scannerKey,
            controller: _controller,
            scanWindow: Rect.fromCenter(
              center: Offset(
                MediaQuery.of(context).size.width / 2,
                MediaQuery.of(context).size.height / 2,
              ),
              width: _frameSize,
              height: _frameSize,
            ),
            errorBuilder: (context, error) => Center(
              child: Padding(
                padding: const EdgeInsets.all(28),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(
                      Icons.camera_alt_outlined,
                      color: Colors.white54,
                      size: 52,
                    ),
                    const SizedBox(height: 16),
                    Text(
                      theme.translate('camera_unavailable'),
                      style: theme.textStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      error.errorDetails?.message ??
                          theme.translate('camera_permission_hint'),
                      style: theme.textStyle(
                        fontSize: 13,
                        color: Colors.white70,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 24),
                    PpButton(
                      label: theme.translate('manual_lookup'),
                      fullWidth: false,
                      variant: PpButtonVariant.secondary,
                      onPressed: _showManualEntryDialog,
                    ),
                  ],
                ),
              ),
            ),
          ),

          // 2. Dark Vignette Cutout Overlay
          _buildOverlay(),

          // 3. Smooth Neumorphic Corner Frame
          _buildCornerFrame(theme.activeColor),

          // 4. Sweeping Laser Scan Line
          _buildScanLine(theme.activeColor),

          // 5. Floating Top Action Controls (Close, Torch, Browse Media / Gallery)
          Positioned(
            top: topPadding + 14,
            left: 20,
            right: 20,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _circleButton(
                  icon: Icons.close_rounded,
                  tooltip: theme.translate('cancel'),
                  onTap: () => Navigator.of(context).pop(),
                ),
                Row(
                  children: [
                    _circleButton(
                      icon: _flashOn
                          ? Icons.flash_on_rounded
                          : Icons.flash_off_rounded,
                      iconColor: _flashOn ? theme.activeColor : Colors.white,
                      tooltip: _flashOn ? 'Turn off flash' : 'Turn on flash',
                      onTap: _toggleFlash,
                    ),
                    const SizedBox(width: 12),
                    _circleButton(
                      icon: Icons.photo_library_rounded,
                      tooltip: theme.translate('browse_media'),
                      onTap: _pickImageFromGallery,
                    ),
                  ],
                ),
              ],
            ),
          ),

          // 6. Bottom Floating Instruction Panel & Manual Entry
          Positioned(
            left: 24,
            right: 24,
            bottom: bottomPadding + 36,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                if (_errorText != null) ...[
                  Container(
                    margin: const EdgeInsets.only(bottom: 14),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 18,
                      vertical: 10,
                    ),
                    decoration: BoxDecoration(
                      color: AppColors.error.withValues(alpha: 0.9),
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.3),
                          blurRadius: 8,
                          offset: const Offset(0, 3),
                        ),
                      ],
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(
                          Icons.error_outline_rounded,
                          color: Colors.white,
                          size: 18,
                        ),
                        const SizedBox(width: 8),
                        Flexible(
                          child: Text(
                            _errorText!,
                            textAlign: TextAlign.center,
                            style: theme.textStyle(
                              color: Colors.white,
                              fontSize: 13,
                              fontWeight: FontWeight.w600,
                            ),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
                Text(
                  theme.translate('qr_align_hint'),
                  textAlign: TextAlign.center,
                  style: theme.textStyle(
                    color: Colors.white.withValues(alpha: 0.92),
                    fontSize: 13,
                    fontWeight: FontWeight.w500,
                  ).copyWith(
                    shadows: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.7),
                        blurRadius: 4,
                        offset: const Offset(0, 1),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 16),
                InkWell(
                  onTap: _showManualEntryDialog,
                  borderRadius: BorderRadius.circular(20),
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 18,
                      vertical: 9,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.black.withValues(alpha: 0.45),
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(
                        color: Colors.white.withValues(alpha: 0.15),
                        width: 1,
                      ),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(
                          Icons.keyboard_outlined,
                          size: 18,
                          color: Colors.white,
                        ),
                        const SizedBox(width: 8),
                        Text(
                          theme.translate('manual_lookup'),
                          style: theme.textStyle(
                            color: Colors.white,
                            fontSize: 13,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),

          // 7. Processing indicator for gallery scanning
          if (_isProcessing && _errorText == null)
            Positioned.fill(
              child: Container(
                color: Colors.black54,
                child: Center(
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 24,
                      vertical: 16,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.black.withValues(alpha: 0.85),
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(
                        color: Colors.white.withValues(alpha: 0.18),
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.5),
                          blurRadius: 16,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        SizedBox(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator(
                            strokeWidth: 2.5,
                            color: theme.activeColor,
                          ),
                        ),
                        const SizedBox(width: 14),
                        Text(
                          theme.currentLanguage == 'Persian'
                              ? 'در حال اسکن کد...'
                              : 'Scanning code...',
                          style: theme.textStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                            color: Colors.white,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildOverlay() {
    return Container(
      decoration: const ShapeDecoration(
        shape: _ScannerOverlayShape(
          cutOutSize: _cutOutSize,
          borderRadius: 40,
        ),
      ),
    );
  }

  Widget _buildCornerFrame(Color activeColor) {
    return Center(
      child: CustomPaint(
        size: const Size(_frameSize, _frameSize),
        painter: _CornerPainter(
          color: activeColor,
          strokeWidth: 4,
          cornerLength: 30,
          radius: 24,
        ),
      ),
    );
  }

  Widget _buildScanLine(Color activeColor) {
    return Center(
      child: SizedBox(
        width: _frameSize,
        height: _frameSize,
        child: AnimatedBuilder(
          animation: _scanLineController,
          builder: (context, child) {
            return Align(
              alignment: Alignment(0, _scanLineController.value * 2 - 1),
              child: Container(
                height: 2.5,
                width: _frameSize * 0.9,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      activeColor.withValues(alpha: 0.0),
                      activeColor,
                      Colors.white,
                      activeColor,
                      activeColor.withValues(alpha: 0.0),
                    ],
                    stops: const [0.0, 0.2, 0.5, 0.8, 1.0],
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _circleButton({
    required IconData icon,
    required VoidCallback onTap,
    Color iconColor = Colors.white,
    String? tooltip,
  }) {
    final button = Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(30),
        child: Container(
          width: 48,
          height: 48,
          decoration: BoxDecoration(
            color: Colors.black.withValues(alpha: 0.5),
            shape: BoxShape.circle,
            border: Border.all(
              color: Colors.white.withValues(alpha: 0.2),
              width: 1,
            ),
          ),
          child: Icon(icon, color: iconColor, size: 22),
        ),
      ),
    );

    if (tooltip != null) {
      return Tooltip(message: tooltip, child: button);
    }
    return button;
  }
}

class _ScannerOverlayShape extends ShapeBorder {
  final double cutOutSize;
  final double borderRadius;

  const _ScannerOverlayShape({
    required this.cutOutSize,
    this.borderRadius = 0,
  });

  @override
  EdgeInsetsGeometry get dimensions => EdgeInsets.zero;

  @override
  Path getInnerPath(Rect rect, {TextDirection? textDirection}) => Path();

  @override
  Path getOuterPath(Rect rect, {TextDirection? textDirection}) =>
      Path()..addRect(rect);

  @override
  void paint(Canvas canvas, Rect rect, {TextDirection? textDirection}) {
    final cutOutRect = Rect.fromCenter(
      center: rect.center,
      width: cutOutSize,
      height: cutOutSize,
    );

    canvas.drawPath(
      Path.combine(
        PathOperation.difference,
        Path()..addRect(rect),
        Path()..addRRect(
          RRect.fromRectAndRadius(cutOutRect, Radius.circular(borderRadius)),
        ),
      ),
      Paint()..color = AppColors.scannerOverlay,
    );
  }

  @override
  ShapeBorder scale(double t) => this;
}

class _CornerPainter extends CustomPainter {
  final Color color;
  final double strokeWidth;
  final double cornerLength;
  final double radius;

  _CornerPainter({
    required this.color,
    required this.strokeWidth,
    required this.cornerLength,
    required this.radius,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth
      ..strokeCap = StrokeCap.round;

    final rect = Offset.zero & size;
    final rrect = RRect.fromRectAndRadius(rect, Radius.circular(radius));

    // Top-left
    canvas.drawPath(
      Path()
        ..moveTo(rrect.left, rrect.top + cornerLength)
        ..lineTo(rrect.left, rrect.top + radius)
        ..arcToPoint(
          Offset(rrect.left + radius, rrect.top),
          radius: Radius.circular(radius),
        )
        ..lineTo(rrect.left + cornerLength, rrect.top),
      paint,
    );

    // Top-right
    canvas.drawPath(
      Path()
        ..moveTo(rrect.right - cornerLength, rrect.top)
        ..lineTo(rrect.right - radius, rrect.top)
        ..arcToPoint(
          Offset(rrect.right, rrect.top + radius),
          radius: Radius.circular(radius),
        )
        ..lineTo(rrect.right, rrect.top + cornerLength),
      paint,
    );

    // Bottom-left
    canvas.drawPath(
      Path()
        ..moveTo(rrect.left, rrect.bottom - cornerLength)
        ..lineTo(rrect.left, rrect.bottom - radius)
        ..arcToPoint(
          Offset(rrect.left + radius, rrect.bottom),
          radius: Radius.circular(radius),
          clockwise: false,
        )
        ..lineTo(rrect.left + cornerLength, rrect.bottom),
      paint,
    );

    // Bottom-right
    canvas.drawPath(
      Path()
        ..moveTo(rrect.right - cornerLength, rrect.bottom)
        ..lineTo(rrect.right - radius, rrect.bottom)
        ..arcToPoint(
          Offset(rrect.right, rrect.bottom - radius),
          radius: Radius.circular(radius),
          clockwise: false,
        )
        ..lineTo(rrect.right, rrect.bottom - cornerLength),
      paint,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
