XAMOS (Cross-AMOS) alpha 0.241

Cross-platform AMOS BASIC reimplementation

(C) 2012 Mequa Innovations


This project is a complete re-write of jAMOS in C++ using SDL libraries and Boost headers.
This release is alpha 0.24, based on the corresponding jAMOS version number.

This initial release is run-only and does not feature an editor at this stage. However, it is compatible with almost all programs created with the latest jAMOS editor. All jAMOS examples (without AMAL) are running in XAMOS, often with a serious speed boost over the Java original, particularly on low-end platforms.

AMAL is now fully implemented in line with jAMOS 0.24. The AMAL subsystem for XAMOS is called XAMAL.

Source is buildable on Win32 (MinGW) and on Linux, and Makefiles are included for both. Boost headers and SDL libraries (SDL, SDL_image, SDL_mixer and SDL_gfx) are required to build this project. Windows DLLs are included for convenience; on Linux the SDL libraries need to be installed separately.

Binaries are included for Win32 (tested on Windows XP, Windows 7 and Windows 8 Consumer Preview) and Linux (tested on Ubuntu 12.10).

Enjoy the latest AMOS BASIC reimplementation.


Changes:

XAMOS alpha 0.23:
- Initial release, based on jAMOS 0.23.

XAMOS alpha 0.24:
- AMAL is now implemented in line with jAMOS 0.24, including AMAL Environment Generator. All AMAL examples from jAMOS are added and runnable in XAMOS.
- Can translate AMAL (and EnvGen) code into both C++ and Java.
- Much code refactoring and debugging.
- Removed default startup sound for run-only version.
- A console-based launcher is added for launching all 40 included examples, along with a batch file.

XAMOS alpha 0.241:
- Removed the dependency on Boost (now available as a compiler option by editing the Makefile). Fallback to deprecated hash_map type is supported without Boost.
- Added the ability to build a minimal text-only build without SDL, for cross-platform testing (tested on AROS/x86 and MorphOS/PPC).
- Improved compatibility with 64-bit systems (e.g. Linux/x64).

