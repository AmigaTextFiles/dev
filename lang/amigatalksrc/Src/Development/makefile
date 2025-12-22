#; ---------------------- MakeFile for DisplayLogo ----------------------
# -----------------------------------------------------------------------
#
MAKE  = SDK:c/make
#
SMAKE = SC:c/smake
#
# need structequivalence = streq flag for proper MsgPort operation! 
#
#
SCOpts = dbg=symbol streq saveds nostkchk cpu=68040 strmer nover\
 ignore=62,100,225,304,161,85 data=far idir=INCLUDE: idir=Headers/
#
#
LIBS = LIB:scm.lib,LIB:sc.lib,LIB:Amiga.lib
#
help :
	@echo "Available targets are:"
	@echo "   DisplayLogoPPC"
	@echo "   DisplayLogoPPCDBG"
	@echo "   DisplayLogo"
	@echo "   DisplayLogoDBG"
	@echo "   ATalkGUIPPCDBG"
#
all : 
	$(MAKE)  DisplayLogoPPC
	$(MAKE)  DisplayLogoPPCDBG
	$(SMAKE) DisplayLogo
	$(SMAKE) DisplayLogoDBG
#
ppcTargets :
	$(MAKE)  DisplayLogoPPC
	$(MAKE)  DisplayLogoPPCDBG
#
# ---------------- 68040 Targets: --------------------------------------
#
DisplayLogo: DisplayLogo.o
	SLink LIB:c.o,DisplayLogo.o TO DisplayLogo LIB $(LIBS) STRIPDEBUG
	Copy   DisplayLogo AmigaTalk:c/DisplayLogo
	Delete DisplayLogo.o
	Delete DisplayLogo
#
DisplayLogo.o: DisplayLogo.c
	SC $(SCOpts) DisplayLogo.c
#
# ----------------- 68040 Debug version: -------------------------------
#
DisplayLogoDBG: DisplayLogo.o
	SLink LIB:c.o,DisplayLogo.o TO DisplayLogoDBG LIB $(LIBS) ADDSYM
#
# ----------------- PPC (AmigaOS4) Targets: ----------------------------
#
CC       = GCC:bin/gcc
#
PPCLIBS  = -lm -lamiga -lauto
#
CFLAGS   = -c -ISDK:Local/Include 
#
DBGFLAGS = -c -ggdb -gdwarf-2 -ISDK:Local/Include -DDEBUG=1 
#
DisplayLogoPPC : DisplayLogoPPC.o
	$(CC) $< -o $@ $(PPCLIBS) -lnet -lz
	Copy  $@  AmigaTalk:c/$@
	Delete $<
#	Delete $@
#
DisplayLogoPPC.o: DisplayLogo.c
	EnsureASCII $<     RAM:$<
	Copy        RAM:$< $<
	Delete      RAM:$<
	$(CC) $(CFLAGS) -o $@ $<
#
# ----------------- PPC Debug version: ---------------------------------
#
DisplayLogoPPCDBG: DisplayLogoPPCD.o
	$(CC) $< -o $@ $(PPCLIBS)
#
DisplayLogoPPCD.o: DisplayLogo.c
	EnsureASCII $<     RAM:$<
	Copy        RAM:$< $<
	Delete      RAM:$<
	$(CC) $(DBGFLAGS) -o $@ $<
#
ATalkGUIPPCDBG: ATalkGUIPPCD.o
	$(CC) $< -o $@ $(PPCLIBS)
#
ATalkGUIPPCD.o: ATalkGUI.c
	EnsureASCII $<     RAM:$<
	Copy        RAM:$< $<
	Delete      RAM:$<
	$(CC) $(DBGFLAGS) -o $@ $<
#
# ----------------------------------------------------------------------
#
JoyTester : JoyStick.o
	SLink LIB:c.o,JoyStick.o TO JoyTester LIB $(LIBS) ADDSYM
#
JoyStick.o: JoyStick.c
	SC $(SCOpts) define DEBUG=1 JoyStick.c
#
PicViewer: PicViewer.o $(GLOB)
	SLink LIB:c.o,$(GLOB),PicViewer.o TO PicViewer LIB $(LIBS) ADDSYM
#
PicViewer.o : PicViewer.c
	SC $(SCOpts) PicViewer.c
#
