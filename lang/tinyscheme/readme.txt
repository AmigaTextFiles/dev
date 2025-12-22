Short:        TinyScheme Embeddable Interpreter
Uploader:     michal@butterweck.pl (Michal Butterweck)
Author:       Dimitrios Souflis, Kevin Cozens, Jonathan S. Shapiro
Type:         dev/lang
Version:      1.41
Architecture: m68k-amigaos
Distribution: Aminet

This is port of the TinyScheme interpreter v1.41. The interpreter was designed
to be easily embedded into another C application. There is standalone m68k
interpreter also included. The R5RS scheme standard is supported with some
small exceptions.

More information on TS:
http://tinyscheme.sourceforge.net

Amiga port:
Only few changes were needed to compile. Most of them are lacking functions
(access(), stricmp() and isascii()). The malloc was changed to calloc as the
implementation was relying on cleaned buffer for storing strings. No makefile
just one-liner script for vbcc. When compiling with gcc or other compiler,
please define AMIGA (eg. -DAMIGA).
