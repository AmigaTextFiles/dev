@echo off

REM ------------------------------------------------------------------
REM  CONFIG.BAT -- configuration script for A6 for MS-DOS
REM   This is free software, please see the file
REM   "COPYING" for copyright and licence details
REM ------------------------------------------------------------------

REM ******************************************************************
REM  Note: don't edit this with MS-DOS edit if you're using GNU make.
REM  MS-DOS edit isn't clean about tab characters, and GNU make needs
REM  them.
REM ******************************************************************

echo A6 configure script for DOS v0.0.1, by Simon Collis
echo.
echo (C) The A6 Development Team 1997
echo.
echo This is free software, please see the file
echo "COPYING" for copyright and licence details
echo.
echo Attempting to configure A6...
echo.

REM ------------------------------------------------------------------
REM MAKEFILE
REM ------------------------------------------------------------------
echo Building makefile...

echo # ------------------------------------------------------------------ >makefile 
echo #  Makefile for A6 >>makefile
echo #   This is free software, please see the file >>makefile
echo #   'COPYING' for copyright and licence details >>makefile
echo # ------------------------------------------------------------------ >>makefile
echo. >>makefile

echo # This file has been automatically generated; >>makefile
echo # please make any necessary changes to config.bat >>makefile
echo. >>makefile

REM Standard definitions
echo # Standard definitions >>makefile
echo PROG=A6 >>makefile
echo DEFD=NODEBUG >>makefile
echo. >>makefile

REM Objects and etc
echo # Objects >>makefile
echo OBJS1=$(PROG).o asmfile.o assemble.o error.o >>makefile
echo OBJS2=global.o label.o outf.o psexpr.o >>makefile
echo OBJS3=psop.o pspop.o pstext.o treefind.o ustring.o >>makefile
echo. >>makefile
echo OBJS=$(OBJS1) $(OBJS2) $(OBJS3) >>makefile
echo. >>makefile

REM ------------------------------------------------------------------
REM Compilers
REM ------------------------------------------------------------------
echo Checking for compiler...

REM *** Clean up compiler file
del conf.* >config.tmp

REM *** DJGPP
IF EXIST conf.cc GOTO END_COMPILERS
 echo Checking for DJGPP...
 IF NOT EXIST c:\djgpp\bin\gcc.exe GOTO END_DJGPP
 echo. >conf.gnu
 echo. >conf.cc
 echo Found DJGPP...

 echo # Configuration for DJGPP >>makefile 
 echo CC=gcc >>makefile
 echo LN=gcc >>makefile
 echo CFLAGS=-O6 -x c -ansi -pedantic-errors -fno-writable-strings -Wall -Wstrict-prototypes -m386 >>makefile
 echo AUX_CFLAGS=-DMSDOS -D$(DEFD) >>makefile
 echo LFLAGS=-L./ -lm >>makefile
 echo FROM= >>makefile
 echo TO=-o >>makefile
 echo EXTRA_LIBS= >>makefile
 echo LOBJS=$(OBJS) >>makefile
:END_DJGPP

:END_COMPILERS

IF EXIST conf.cc GOTO GOT_COMPILER
 echo No supported C compilers found...  A6 configuration stopped.
 del makefile
 del conf.h
 GOTO END

:GOT_COMPILER
 echo. >>makefile
 IF EXIST conf.cc del conf.cc
 IF EXIST config.tmp del config.tmp

REM ------------------------------------------------------------------
REM Targets
REM ------------------------------------------------------------------

REM Standard targets
echo # Targets >>makefile
echo all: $(PROG) compare >>makefile
echo. >>makefile
echo test: >>makefile
echo 	cd test >>makefile
echo 	..\a6 -fp -o test.prg test.asm >>makefile
echo 	cd .. >>makefile
echo 	compare test\test.prg test\good.prg >>makefile
echo. >>makefile
echo clean: >>makefile
echo 	del a6 >>makefile
echo 	del a6.exe >>makefile
echo 	del compare >>makefile
echo 	del *.o >>makefile
echo 	del *.obj >>makefile
echo. >>makefile
echo distclean: >>makefile
echo 	del a6 >>makefile
echo 	del a6.exe >>makefile
echo 	del conf.h >>makefile
echo 	del compare >>makefile
echo 	del compare.exe >>makefile
echo 	del *.o >>makefile
echo 	del *.obj >>makefile
echo 	del test\test.prg >>makefile
echo 	del makefile >>makefile
echo. >>makefile
echo install: >>makefile
echo 	IF NOT EXIST C:\A6 MKDIR C:\A6 >>makefile
echo 	copy $(PROG).exe C:\A6 >>makefile
echo. >>makefile

REM ------------------------------------------------------------------
REM Explicit rules
REM ------------------------------------------------------------------

IF NOT EXIST conf.gnu GOTO NO_GNU
 echo $(PROG): $(OBJS) >>makefile
 echo 	$(LN) $(LFLAGS) $(AUX_LFLAGS) $(TO) $(PROG) $(FROM) $(LOBJS) $(EXTRA_LIBS) $(AUX_LIBS) >>makefile
 echo. >>makefile
 echo compare: compare.o >>makefile
 echo 	$(LN) $(LFLAGS) $(AUX_LFLAGS) $(TO) $(PROG) $(FROM) $(LOBJS) $(EXTRA_LIBS) $(AUX_LIBS) >>makefile
 echo. >>makefile
 echo .c.o: >>makefile
 echo 	$(CC) -c -D$(DEFD) $(CFLAGS) $(AUX_CFLAGS) $*.c >>makefile
:NO_GNU

REM ------------------------------------------------------------------
REM CONF.H
REM ------------------------------------------------------------------

echo Building conf.h...

echo /* ------------------------------------------------------------------ >conf.h 
echo     CONF.H -- configuration details for the A6 cross-assembler >>conf.h
echo      This is free software, please see the file >>conf.h
echo      'COPYING' for copyright and licence details >>conf.h
echo    ------------------------------------------------------------------ */ >>conf.h
echo. >>conf.h

echo /* This file has been automatically generated;     * >>conf.h
echo  * please make any necessary changes to config.bat */ >>conf.h
echo. >>conf.h

echo #ifndef _CONF_H >>conf.h
echo #define _CONF_H >>conf.h
echo. >>conf.h

echo #define PATH_SEPARATOR ';' >>conf.h
echo #define PATH_SLASH '\\' >>conf.h
echo. >>conf.h

echo #endif >>conf.h

echo.
echo The configuration of A6 succeeded, to make A6 type

 echo     make all
 echo     make test
 echo     make install

IF EXIST conf.gnu del conf.gnu
IF EXIST config.tmp del config.tmp

:END
