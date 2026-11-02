# Developer Guidelines & Engineering Principles

## 1. Mandatory Compilation & Build Verification
- Always make sure all code created or modified compiles and builds successfully without errors.
- Run project-wide diagnostics (`analyze_files` across the workspace root) on every change before completing a turn.
- Ensure all imports, variables, getters, and dependencies are fully resolved and error-free.

## 2. Senior-Level Pragmatism & Simplicity ("Senior-Level Lazy")
- Write clean, disciplined, professional code without over-engineering simple tasks.
- Avoid introducing unnecessary abstraction layers, overly complex helpers, or verbose boilerplate when straightforward, idiomatic solutions are cleaner.
- Prefer direct Flutter / Dart primitives and standard patterns. Keep changes minimal, robust, and focused directly on user requirements.
