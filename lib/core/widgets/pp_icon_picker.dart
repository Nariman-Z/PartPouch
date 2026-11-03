import 'package:flutter/material.dart';
import '../theme/theme_provider.dart';

/// Representation of an icon option with descriptive metadata for search and categorization.
class IconChoice {
  final IconData icon;
  final String label;
  final String categoryKey;
  final List<String> tags;

  const IconChoice({
    required this.icon,
    required this.label,
    required this.categoryKey,
    this.tags = const [],
  });
}

/// Comprehensive icon picker designed for electronics, hardware, and maker projects,
/// following the Ambinet design system modal bottom sheet.
class PpIconPicker {
  /// Default quick-pick icons shown in compact rows
  static const List<IconData> defaultQuickIcons = [
    Icons.build_rounded,
    Icons.memory_rounded,
    Icons.developer_board_rounded,
    Icons.sensors_rounded,
    Icons.electric_bolt_rounded,
  ];

  /// Comprehensive list of icons tailored for electronics and engineering projects
  static const List<IconChoice> allIcons = [
    // --- ELECTRONICS & COMPUTING ---
    IconChoice(
      icon: Icons.memory_rounded,
      label: 'Microchip / IC',
      categoryKey: 'category_electronics',
      tags: ['chip', 'ic', 'processor', 'soc', 'mcu', 'integrated circuit'],
    ),
    IconChoice(
      icon: Icons.developer_board_rounded,
      label: 'Dev Board / PCB',
      categoryKey: 'category_electronics',
      tags: ['pcb', 'board', 'arduino', 'esp32', 'raspberry', 'stm32'],
    ),
    IconChoice(
      icon: Icons.hub_rounded,
      label: 'Circuit Hub',
      categoryKey: 'category_electronics',
      tags: ['hub', 'bus', 'i2c', 'spi', 'can', 'network'],
    ),
    IconChoice(
      icon: Icons.cable_rounded,
      label: 'Cables & Harness',
      categoryKey: 'category_electronics',
      tags: ['wire', 'cable', 'connector', 'jumper', 'ribbon'],
    ),
    IconChoice(
      icon: Icons.usb_rounded,
      label: 'USB Interface',
      categoryKey: 'category_electronics',
      tags: ['usb', 'serial', 'uart', 'dongle', 'port'],
    ),
    IconChoice(
      icon: Icons.sd_card_rounded,
      label: 'SD Card / Storage',
      categoryKey: 'category_electronics',
      tags: ['sd', 'microsd', 'storage', 'flash', 'eeprom', 'memory'],
    ),
    IconChoice(
      icon: Icons.sim_card_rounded,
      label: 'SIM / Modem',
      categoryKey: 'category_electronics',
      tags: ['sim', 'cellular', 'gsm', 'lte', '4g', '5g', 'modem'],
    ),
    IconChoice(
      icon: Icons.terminal_rounded,
      label: 'Firmware & CLI',
      categoryKey: 'category_electronics',
      tags: ['firmware', 'terminal', 'code', 'cli', 'console', 'bootloader'],
    ),
    IconChoice(
      icon: Icons.integration_instructions_rounded,
      label: 'Logic / FPGA',
      categoryKey: 'category_electronics',
      tags: ['fpga', 'cpld', 'logic', 'gate', 'verilog', 'vhdl'],
    ),
    IconChoice(
      icon: Icons.schema_rounded,
      label: 'Schematic / Topology',
      categoryKey: 'category_electronics',
      tags: ['schematic', 'architecture', 'diagram', 'netlist', 'circuit'],
    ),
    IconChoice(
      icon: Icons.layers_rounded,
      label: 'PCB Layers',
      categoryKey: 'category_electronics',
      tags: ['layers', 'stackup', 'gerber', 'copper', 'fr4'],
    ),
    IconChoice(
      icon: Icons.widgets_rounded,
      label: 'Subsystem Module',
      categoryKey: 'category_electronics',
      tags: ['module', 'widget', 'breakout', 'daughterboard'],
    ),
    IconChoice(
      icon: Icons.extension_rounded,
      label: 'Shield & HAT',
      categoryKey: 'category_electronics',
      tags: ['shield', 'hat', 'addon', 'expansion', 'cape'],
    ),
    IconChoice(
      icon: Icons.smart_toy_rounded,
      label: 'Robotics & MCU',
      categoryKey: 'category_electronics',
      tags: ['robot', 'bot', 'actuator', 'servo', 'automation'],
    ),
    IconChoice(
      icon: Icons.precision_manufacturing_rounded,
      label: 'CNC & Manufacturing',
      categoryKey: 'category_electronics',
      tags: ['cnc', 'mill', 'pcb fab', 'smd', 'pick and place', 'fab'],
    ),

    // --- POWER & ENERGY ---
    IconChoice(
      icon: Icons.electric_bolt_rounded,
      label: 'High Voltage',
      categoryKey: 'category_power',
      tags: ['voltage', 'high voltage', 'zap', 'shock', 'spark', 'electric'],
    ),
    IconChoice(
      icon: Icons.bolt_rounded,
      label: 'Lightning / Pulse',
      categoryKey: 'category_power',
      tags: ['bolt', 'pulse', 'transient', 'esd', 'surge'],
    ),
    IconChoice(
      icon: Icons.power_rounded,
      label: 'Power Supply',
      categoryKey: 'category_power',
      tags: ['power', 'psu', 'smps', 'mains', 'dc', 'ac', 'converter'],
    ),
    IconChoice(
      icon: Icons.power_settings_new_rounded,
      label: 'Power Switch',
      categoryKey: 'category_power',
      tags: ['switch', 'power on', 'toggle', 'relay', 'mosfet'],
    ),
    IconChoice(
      icon: Icons.battery_charging_full_rounded,
      label: 'Battery Charger / BMS',
      categoryKey: 'category_power',
      tags: ['charger', 'bms', 'charging', 'lipo', 'li-ion', '18650'],
    ),
    IconChoice(
      icon: Icons.battery_full_rounded,
      label: 'Battery Pack',
      categoryKey: 'category_power',
      tags: ['battery', 'cell', 'accumulator', 'pack', 'energy'],
    ),
    IconChoice(
      icon: Icons.solar_power_rounded,
      label: 'Solar & Harvesting',
      categoryKey: 'category_power',
      tags: ['solar', 'photovoltaic', 'pv', 'energy harvesting', 'green'],
    ),
    IconChoice(
      icon: Icons.electrical_services_rounded,
      label: 'Mains & Wiring',
      categoryKey: 'category_power',
      tags: ['mains', 'outlet', 'plug', 'wiring', 'grid', '220v', '110v'],
    ),
    IconChoice(
      icon: Icons.flash_on_rounded,
      label: 'Strobe / High Flash',
      categoryKey: 'category_power',
      tags: ['flash', 'strobe', 'driver', 'pulsed'],
    ),
    IconChoice(
      icon: Icons.lightbulb_rounded,
      label: 'LED Indicator',
      categoryKey: 'category_power',
      tags: ['led', 'indicator', 'diode', 'light', 'neopixel', 'ws2812'],
    ),
    IconChoice(
      icon: Icons.lightbulb_outline_rounded,
      label: 'Lighting / Illumination',
      categoryKey: 'category_power',
      tags: ['light', 'lamp', 'illumination', 'bulb', 'driver'],
    ),

    // --- WIRELESS & CONNECTIVITY ---
    IconChoice(
      icon: Icons.wifi_rounded,
      label: 'Wi-Fi / WLAN',
      categoryKey: 'category_wireless',
      tags: ['wifi', 'wireless', '802.11', 'wlan', 'internet', 'esp8266'],
    ),
    IconChoice(
      icon: Icons.bluetooth_rounded,
      label: 'Bluetooth / BLE',
      categoryKey: 'category_wireless',
      tags: ['bluetooth', 'ble', 'beacon', 'nordic', 'nrf52'],
    ),
    IconChoice(
      icon: Icons.sensors_rounded,
      label: 'Sensors & Telemetry',
      categoryKey: 'category_wireless',
      tags: ['sensor', 'telemetry', 'signal', 'node', 'iot', 'data'],
    ),
    IconChoice(
      icon: Icons.radar_rounded,
      label: 'Radar / mmWave',
      categoryKey: 'category_wireless',
      tags: ['radar', 'rf', 'mmwave', 'doppler', 'microwave', 'chirp'],
    ),
    IconChoice(
      icon: Icons.radio_rounded,
      label: 'Radio / RF Transceiver',
      categoryKey: 'category_wireless',
      tags: ['radio', 'rf', 'lora', 'transceiver', 'ham', 'sub-ghz', '433mhz'],
    ),
    IconChoice(
      icon: Icons.router_rounded,
      label: 'Router / Gateway',
      categoryKey: 'category_wireless',
      tags: ['router', 'gateway', 'mesh', 'ethernet', 'switch', 'network'],
    ),
    IconChoice(
      icon: Icons.satellite_alt_rounded,
      label: 'GPS & Satellite',
      categoryKey: 'category_wireless',
      tags: ['gps', 'gnss', 'satellite', 'glonass', 'galileo', 'location'],
    ),
    IconChoice(
      icon: Icons.cell_tower_rounded,
      label: 'Cell Tower / Base',
      categoryKey: 'category_wireless',
      tags: ['antenna', 'tower', 'telecom', 'transmission', 'broadcast'],
    ),
    IconChoice(
      icon: Icons.settings_remote_rounded,
      label: 'Remote Control',
      categoryKey: 'category_wireless',
      tags: ['remote', 'ir', 'infrared', 'controller', 'transmitter'],
    ),
    IconChoice(
      icon: Icons.settings_input_component_rounded,
      label: 'Component I/O',
      categoryKey: 'category_wireless',
      tags: ['io', 'gpio', 'analog', 'dac', 'adc', 'interface'],
    ),
    IconChoice(
      icon: Icons.cast_rounded,
      label: 'Broadcast / Cast',
      categoryKey: 'category_wireless',
      tags: ['cast', 'stream', 'broadcast', 'airplay'],
    ),
    IconChoice(
      icon: Icons.nfc_rounded,
      label: 'NFC / RFID',
      categoryKey: 'category_wireless',
      tags: ['nfc', 'rfid', 'tag', 'contactless', 'reader', '13.56mhz'],
    ),

    // --- AUDIO & DISPLAY ---
    IconChoice(
      icon: Icons.speaker_rounded,
      label: 'Speaker / Transducer',
      categoryKey: 'category_audio_display',
      tags: ['speaker', 'audio', 'sound', 'driver', 'piezo', 'buzzer'],
    ),
    IconChoice(
      icon: Icons.volume_up_rounded,
      label: 'Audio Amplifier',
      categoryKey: 'category_audio_display',
      tags: ['amp', 'amplifier', 'gain', 'class-d', 'audio', 'volume'],
    ),
    IconChoice(
      icon: Icons.graphic_eq_rounded,
      label: 'Equalizer / DSP',
      categoryKey: 'category_audio_display',
      tags: ['dsp', 'eq', 'filter', 'waveform', 'fft', 'audio processing'],
    ),
    IconChoice(
      icon: Icons.mic_rounded,
      label: 'Microphone / MEMS',
      categoryKey: 'category_audio_display',
      tags: ['mic', 'mems', 'acoustic', 'i2s', 'recording', 'voice'],
    ),
    IconChoice(
      icon: Icons.headphones_rounded,
      label: 'Headphones / DAC',
      categoryKey: 'category_audio_display',
      tags: ['headphones', 'dac', 'iem', 'audio jack', 'stereo'],
    ),
    IconChoice(
      icon: Icons.music_note_rounded,
      label: 'Synth / Tone Generator',
      categoryKey: 'category_audio_display',
      tags: ['music', 'synth', 'midi', 'oscillator', 'polyphony'],
    ),
    IconChoice(
      icon: Icons.tv_rounded,
      label: 'Display / OLED / TFT',
      categoryKey: 'category_audio_display',
      tags: ['display', 'screen', 'oled', 'lcd', 'tft', 'epaper', 'hdmi'],
    ),
    IconChoice(
      icon: Icons.videocam_rounded,
      label: 'Camera / Video',
      categoryKey: 'category_audio_display',
      tags: ['camera', 'video', 'ov2640', 'csi', 'mipi', 'stream'],
    ),
    IconChoice(
      icon: Icons.camera_alt_rounded,
      label: 'Computer Vision',
      categoryKey: 'category_audio_display',
      tags: ['vision', 'optics', 'lens', 'imaging', 'ai vision'],
    ),
    IconChoice(
      icon: Icons.remove_red_eye_rounded,
      label: 'Optical / ToF',
      categoryKey: 'category_audio_display',
      tags: ['optical', 'photodiode', 'tof', 'distance', 'light sensor'],
    ),

    // --- SENSORS & ENVIRONMENT ---
    IconChoice(
      icon: Icons.thermostat_rounded,
      label: 'Temperature / Thermal',
      categoryKey: 'category_sensors',
      tags: ['temp', 'thermistor', 'dht22', 'ds18b20', 'thermocouple', 'heat'],
    ),
    IconChoice(
      icon: Icons.device_thermostat_rounded,
      label: 'HVAC / Climate',
      categoryKey: 'category_sensors',
      tags: ['climate', 'thermostat', 'cooling', 'hvac', 'pid'],
    ),
    IconChoice(
      icon: Icons.air_rounded,
      label: 'Fan & Airflow',
      categoryKey: 'category_sensors',
      tags: ['fan', 'blower', 'cooling', 'airflow', 'pwm fan', 'anemometer'],
    ),
    IconChoice(
      icon: Icons.water_drop_rounded,
      label: 'Humidity / Fluidics',
      categoryKey: 'category_sensors',
      tags: ['humidity', 'water', 'moisture', 'leak', 'soil', 'valve'],
    ),
    IconChoice(
      icon: Icons.water_rounded,
      label: 'Flow & Pump',
      categoryKey: 'category_sensors',
      tags: ['pump', 'flow', 'water flow', 'hydraulic', 'irrigation'],
    ),
    IconChoice(
      icon: Icons.speed_rounded,
      label: 'Tachometer / Speed',
      categoryKey: 'category_sensors',
      tags: ['speed', 'rpm', 'encoder', 'motor', 'hall effect', 'odometer'],
    ),
    IconChoice(
      icon: Icons.compress_rounded,
      label: 'Pressure / Barometer',
      categoryKey: 'category_sensors',
      tags: ['pressure', 'barometer', 'bmp280', 'altitude', 'pascal'],
    ),
    IconChoice(
      icon: Icons.timer_rounded,
      label: 'Timer & RTC Clock',
      categoryKey: 'category_sensors',
      tags: ['rtc', 'clock', 'crystal', 'timer', 'ds3231', 'stopwatch'],
    ),
    IconChoice(
      icon: Icons.alarm_rounded,
      label: 'Alarm & Alert',
      categoryKey: 'category_sensors',
      tags: ['alarm', 'buzzer', 'siren', 'warning', 'watchdog'],
    ),
    IconChoice(
      icon: Icons.lock_rounded,
      label: 'Electronic Lock',
      categoryKey: 'category_sensors',
      tags: ['lock', 'solenoid', 'keypad', 'access', 'security', 'relay'],
    ),
    IconChoice(
      icon: Icons.security_rounded,
      label: 'Security System',
      categoryKey: 'category_sensors',
      tags: ['security', 'safeguard', 'tamper', 'pir', 'motion'],
    ),
    IconChoice(
      icon: Icons.shield_rounded,
      label: 'Hardware Shield',
      categoryKey: 'category_sensors',
      tags: ['protection', 'fuse', 'tvs', 'polyfuse', 'varistor'],
    ),
    IconChoice(
      icon: Icons.science_rounded,
      label: 'Lab Instrumentation',
      categoryKey: 'category_sensors',
      tags: ['lab', 'chemistry', 'ph', 'spectroscopy', 'sensor', 'probe'],
    ),
    IconChoice(
      icon: Icons.biotech_rounded,
      label: 'Biomedical / ECG',
      categoryKey: 'category_sensors',
      tags: ['ecg', 'heart', 'pulse', 'spo2', 'emg', 'bio', 'biomedical'],
    ),

    // --- TOOLS & MECHANICAL ---
    IconChoice(
      icon: Icons.build_rounded,
      label: 'Assembly Tools',
      categoryKey: 'category_tools',
      tags: ['wrench', 'tool', 'assembly', 'pliers', 'iron', 'soldering'],
    ),
    IconChoice(
      icon: Icons.build_outlined,
      label: 'Hardware Project (Default)',
      categoryKey: 'category_tools',
      tags: ['default', 'project', 'build', 'maker'],
    ),
    IconChoice(
      icon: Icons.handyman_rounded,
      label: 'Repair & Rework',
      categoryKey: 'category_tools',
      tags: ['repair', 'rework', 'hot air', 'maintenance', 'fix'],
    ),
    IconChoice(
      icon: Icons.construction_rounded,
      label: 'Hardware Prototype',
      categoryKey: 'category_tools',
      tags: ['prototype', 'breadboard', 'stripboard', 'construction'],
    ),
    IconChoice(
      icon: Icons.hardware_rounded,
      label: 'Fasteners & Standoffs',
      categoryKey: 'category_tools',
      tags: ['screws', 'nuts', 'standoffs', 'bolts', 'hardware', 'm3', 'm2'],
    ),
    IconChoice(
      icon: Icons.tune_rounded,
      label: 'Oscilloscope / Tuning',
      categoryKey: 'category_tools',
      tags: ['scope', 'oscilloscope', 'probe', 'tuning', 'calibration'],
    ),
    IconChoice(
      icon: Icons.print_rounded,
      label: '3D Printer / Enclosure',
      categoryKey: 'category_tools',
      tags: ['3d print', 'enclosure', 'case', 'stl', 'filament', 'resin'],
    ),
    IconChoice(
      icon: Icons.architecture_rounded,
      label: 'CAD & Drafting',
      categoryKey: 'category_tools',
      tags: ['cad', 'drafting', 'kicad', 'altium', 'eagle', 'mechanical'],
    ),
    IconChoice(
      icon: Icons.square_foot_rounded,
      label: 'Measurement / Layout',
      categoryKey: 'category_tools',
      tags: ['measure', 'ruler', 'pitch', 'clearance', 'dimensions'],
    ),
    IconChoice(
      icon: Icons.straighten_rounded,
      label: 'Digital Caliper',
      categoryKey: 'category_tools',
      tags: ['caliper', 'micrometer', 'precision', 'gauge', 'vernier'],
    ),

    // --- HARDWARE & HOBBY ---
    IconChoice(
      icon: Icons.rocket_launch_rounded,
      label: 'Aerospace / Avionics',
      categoryKey: 'category_applications',
      tags: ['aerospace', 'rocket', 'avionics', 'space', 'sat'],
    ),
    IconChoice(
      icon: Icons.flight_rounded,
      label: 'Drone / Flight Controller',
      categoryKey: 'category_applications',
      tags: ['drone', 'quadcopter', 'flight', 'esc', 'fpv', 'betaflight'],
    ),
    IconChoice(
      icon: Icons.directions_car_rounded,
      label: 'Automotive / ECU',
      categoryKey: 'category_applications',
      tags: ['car', 'automotive', 'ecu', 'obd2', 'telematics', 'vehicle'],
    ),
    IconChoice(
      icon: Icons.two_wheeler_rounded,
      label: 'E-Bike / Motor Controller',
      categoryKey: 'category_applications',
      tags: ['ebike', 'motor controller', 'vesc', 'bldc', 'bldc motor'],
    ),
    IconChoice(
      icon: Icons.watch_rounded,
      label: 'Wearable Tech',
      categoryKey: 'category_applications',
      tags: ['wearable', 'smartwatch', 'fitness', 'wrist', 'tiny'],
    ),
    IconChoice(
      icon: Icons.gamepad_rounded,
      label: 'Gaming & Arcade',
      categoryKey: 'category_applications',
      tags: ['game', 'arcade', 'joystick', 'console', 'buttons', 'retro'],
    ),
    IconChoice(
      icon: Icons.home_repair_service_rounded,
      label: 'Field Service Kit',
      categoryKey: 'category_applications',
      tags: ['kit', 'toolbox', 'field', 'portable', 'rugged'],
    ),
    IconChoice(
      icon: Icons.work_outline_rounded,
      label: 'Commercial Product',
      categoryKey: 'category_applications',
      tags: ['product', 'device', 'commercial', 'enclosed', 'appliance'],
    ),
    IconChoice(
      icon: Icons.auto_mode_rounded,
      label: 'Autonomous Controller',
      categoryKey: 'category_applications',
      tags: ['auto', 'pid', 'feedback', 'state machine', 'plc'],
    ),
    IconChoice(
      icon: Icons.grade_rounded,
      label: 'Flagship Project',
      categoryKey: 'category_applications',
      tags: ['star', 'favorite', 'featured', 'flagship'],
    ),
  ];

  static final Map<int, IconData> _iconMap = {
    for (final choice in allIcons) choice.icon.codePoint: choice.icon,
    for (final icon in defaultQuickIcons) icon.codePoint: icon,
    Icons.build_outlined.codePoint: Icons.build_outlined,
  };

  /// Resolves an [IconData] from a persisted [codePoint].
  ///
  /// Uses a constant lookup table to ensure all resolved icons are compile-time constants,
  /// preserving full Flutter icon font tree-shaking support without runtime non-const failures.
  static IconData getIcon(int? codePoint, {IconData fallback = Icons.build_outlined}) {
    if (codePoint == null) return fallback;
    return _iconMap[codePoint] ?? fallback;
  }

  /// Opens the Ambinet-styled modal bottom sheet for choosing an icon
  static void show({
    required BuildContext context,
    required ThemeProvider theme,
    required IconData selectedIcon,
    required ValueChanged<IconData> onSelect,
  }) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (modalContext) {
        return _IconPickerSheet(
          theme: theme,
          selectedIcon: selectedIcon,
          onSelect: (chosenIcon) {
            onSelect(chosenIcon);
            Navigator.of(modalContext).pop();
          },
        );
      },
    );
  }
}

class _IconPickerSheet extends StatefulWidget {
  final ThemeProvider theme;
  final IconData selectedIcon;
  final ValueChanged<IconData> onSelect;

  const _IconPickerSheet({
    required this.theme,
    required this.selectedIcon,
    required this.onSelect,
  });

  @override
  State<_IconPickerSheet> createState() => _IconPickerSheetState();
}

class _IconPickerSheetState extends State<_IconPickerSheet> {
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';
  String _selectedCategory = 'all_icons';

  final List<String> _categories = [
    'all_icons',
    'category_electronics',
    'category_power',
    'category_wireless',
    'category_audio_display',
    'category_sensors',
    'category_tools',
    'category_applications',
  ];

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  List<IconChoice> _getFilteredIcons() {
    final query = _searchQuery.trim().toLowerCase();

    return PpIconPicker.allIcons.where((item) {
      // Category filter
      if (_selectedCategory != 'all_icons' &&
          item.categoryKey != _selectedCategory) {
        return false;
      }

      // Search query filter
      if (query.isNotEmpty) {
        final matchesLabel = item.label.toLowerCase().contains(query);
        final matchesTags = item.tags.any((t) => t.toLowerCase().contains(query));
        return matchesLabel || matchesTags;
      }

      return true;
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    final theme = widget.theme;
    final sheetBg = theme.isDark ? const Color(0xFF1E2126) : Colors.white;
    final filteredIcons = _getFilteredIcons();

    return Container(
      height: MediaQuery.of(context).size.height * 0.78,
      decoration: BoxDecoration(
        color: sheetBg,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(28)),
        border: Border(
          top: BorderSide(color: theme.borderColor, width: 1),
          left: BorderSide(color: theme.borderColor, width: 1),
          right: BorderSide(color: theme.borderColor, width: 1),
        ),
      ),
      child: Column(
        children: [
          const SizedBox(height: 12),
          // Drag handle pill
          Container(
            width: 44,
            height: 4,
            decoration: BoxDecoration(
              color: theme.subTextColor.withValues(alpha: 0.3),
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          const SizedBox(height: 14),

          // Header Row
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    theme.translate('choose_icon'),
                    style: theme.textStyle(
                      fontSize: 17,
                      fontWeight: FontWeight.bold,
                      color: theme.textColor,
                    ),
                  ),
                ),
                IconButton(
                  icon: Icon(
                    Icons.close_rounded,
                    color: theme.subTextColor,
                    size: 20,
                  ),
                  onPressed: () => Navigator.of(context).pop(),
                  tooltip: theme.translate('close'),
                ),
              ],
            ),
          ),
          const SizedBox(height: 10),

          // Search Field
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Container(
              height: 44,
              decoration: BoxDecoration(
                color: theme.isDark
                    ? Colors.white.withValues(alpha: 0.05)
                    : Colors.black.withValues(alpha: 0.04),
                borderRadius: BorderRadius.circular(14),
                border: Border.all(color: theme.borderColor, width: 1),
              ),
              child: TextField(
                controller: _searchController,
                cursorColor: theme.activeColor,
                style: theme.textStyle(fontSize: 13, color: theme.textColor),
                decoration: InputDecoration(
                  hintText: theme.translate('search_icons_hint'),
                  hintStyle: theme.textStyle(
                    fontSize: 12,
                    color: theme.subTextColor,
                  ),
                  prefixIcon: Icon(
                    Icons.search_rounded,
                    color: theme.subTextColor,
                    size: 18,
                  ),
                  suffixIcon: _searchQuery.isNotEmpty
                      ? IconButton(
                          icon: Icon(
                            Icons.clear_rounded,
                            color: theme.subTextColor,
                            size: 16,
                          ),
                          onPressed: () {
                            setState(() {
                              _searchController.clear();
                              _searchQuery = '';
                            });
                          },
                        )
                      : null,
                  border: InputBorder.none,
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 10,
                  ),
                ),
                onChanged: (val) => setState(() => _searchQuery = val),
              ),
            ),
          ),
          const SizedBox(height: 10),

          // Category Chips Bar
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              children: _categories.map((catKey) {
                final isSelected = _selectedCategory == catKey;
                return Padding(
                  padding: const EdgeInsets.only(right: 6),
                  child: ChoiceChip(
                    label: Text(
                      theme.translate(catKey),
                      style: theme.textStyle(
                        fontSize: 11,
                        color: isSelected ? Colors.white : theme.textColor,
                        fontWeight:
                            isSelected ? FontWeight.bold : FontWeight.normal,
                      ),
                    ),
                    selected: isSelected,
                    selectedColor: theme.activeColor,
                    backgroundColor: theme.isDark
                        ? Colors.white.withValues(alpha: 0.05)
                        : Colors.black.withValues(alpha: 0.03),
                    side: BorderSide(
                      color: isSelected ? theme.activeColor : theme.borderColor,
                      width: 1,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                    showCheckmark: false,
                    onSelected: (selected) {
                      if (selected) {
                        setState(() => _selectedCategory = catKey);
                      }
                    },
                  ),
                );
              }).toList(),
            ),
          ),
          const SizedBox(height: 12),

          // Icons Grid
          Expanded(
            child: filteredIcons.isEmpty
                ? Center(
                    child: Text(
                      theme.translate('no_results_found'),
                      style: theme.textStyle(
                        fontSize: 13,
                        color: theme.subTextColor,
                      ),
                    ),
                  )
                : GridView.builder(
                    padding: const EdgeInsets.fromLTRB(16, 4, 16, 32),
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 5,
                      mainAxisSpacing: 12,
                      crossAxisSpacing: 12,
                    ),
                    itemCount: filteredIcons.length,
                    itemBuilder: (context, index) {
                      final item = filteredIcons[index];
                      final isSelected =
                          widget.selectedIcon.codePoint == item.icon.codePoint;

                      return Tooltip(
                        message: item.label,
                        child: GestureDetector(
                          onTap: () => widget.onSelect(item.icon),
                          child: AnimatedContainer(
                            duration: const Duration(milliseconds: 150),
                            decoration: BoxDecoration(
                              color: isSelected
                                  ? theme.activeColor.withValues(alpha: 0.15)
                                  : (theme.isDark
                                      ? Colors.white.withValues(alpha: 0.04)
                                      : Colors.black.withValues(alpha: 0.03)),
                              borderRadius: BorderRadius.circular(16),
                              border: Border.all(
                                color: isSelected
                                    ? theme.activeColor
                                    : theme.borderColor,
                                width: isSelected ? 2.0 : 1.0,
                              ),
                            ),
                            child: Icon(
                              item.icon,
                              color: isSelected
                                  ? theme.activeColor
                                  : theme.textColor.withValues(alpha: 0.8),
                              size: 26,
                            ),
                          ),
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }
}

/// A compact horizontal quick-picker row for dialogs and forms.
/// Shows 5 quick icons and a 6th slot for custom icon or opening the modal picker.
class PpProjectIconSelector extends StatelessWidget {
  final IconData selectedIcon;
  final ValueChanged<IconData> onChanged;
  final ThemeProvider theme;

  const PpProjectIconSelector({
    super.key,
    required this.selectedIcon,
    required this.onChanged,
    required this.theme,
  });

  @override
  Widget build(BuildContext context) {
    final quickIcons = PpIconPicker.defaultQuickIcons;
    final isQuickIconSelected =
        quickIcons.any((icon) => icon.codePoint == selectedIcon.codePoint);

    // 6th slot shows the selected custom icon, or Icons.more_horiz_rounded
    final customSlotIcon =
        isQuickIconSelected ? Icons.more_horiz_rounded : selectedIcon;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              theme.translate('project_icon'),
              style: theme.textStyle(
                fontSize: 13,
                fontWeight: FontWeight.w600,
                color: theme.textColor,
              ),
            ),
            GestureDetector(
              onTap: () => PpIconPicker.show(
                context: context,
                theme: theme,
                selectedIcon: selectedIcon,
                onSelect: onChanged,
              ),
              child: Text(
                theme.translate('browse_all_icons'),
                style: theme.textStyle(
                  fontSize: 11,
                  color: theme.activeColor,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        Row(
          children: List.generate(6, (index) {
            final bool isSlot6 = index == 5;
            final IconData slotIcon =
                isSlot6 ? customSlotIcon : quickIcons[index];
            final bool isSelected =
                slotIcon.codePoint == selectedIcon.codePoint;

            return Expanded(
              child: GestureDetector(
                onTap: () {
                  if (isSlot6) {
                    PpIconPicker.show(
                      context: context,
                      theme: theme,
                      selectedIcon: selectedIcon,
                      onSelect: onChanged,
                    );
                  } else {
                    onChanged(slotIcon);
                  }
                },
                child: Container(
                  margin: EdgeInsets.only(right: index == 5 ? 0 : 6),
                  height: 48,
                  decoration: BoxDecoration(
                    color: isSelected
                        ? theme.activeColor.withValues(alpha: 0.15)
                        : (theme.isDark
                            ? Colors.white.withValues(alpha: 0.04)
                            : Colors.black.withValues(alpha: 0.03)),
                    borderRadius: BorderRadius.circular(14),
                    border: Border.all(
                      color: isSelected ? theme.activeColor : theme.borderColor,
                      width: isSelected ? 2.0 : 1.0,
                    ),
                  ),
                  child: Icon(
                    slotIcon,
                    color: isSelected
                        ? theme.activeColor
                        : theme.textColor.withValues(alpha: 0.75),
                    size: 22,
                  ),
                ),
              ),
            );
          }),
        ),
      ],
    );
  }
}
