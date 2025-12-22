Covert Bitops C64 tools collection, now all (except GoatTracker) in one
package!

The graphical tools use now SDL and all utilities have been verified to compile
both under MinGW (Win32) and Linux. For filesize reasons, precompiled binaries
exist only for Win32.

Use makefile to recompile for Linux
and makefile.win to recompile for MinGW

Note that for Linux, you need to recompile the BME library 
(http://covertbitops.c64.org/misc/bme.zip) from source. Place the resulting
libbme.a into linux subdirectory before compiling the tools.

