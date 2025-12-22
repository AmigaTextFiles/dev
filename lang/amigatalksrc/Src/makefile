# ################################################################
# #               MakeFile for AmigaTalk3.0+.                    #
# ################################################################
#
#CROSS   = ppc-amigaos-
#CC       = GCC:bin/$(CROSS)gcc
#
CC       = GCC:bin/gcc
#
MAKE     = SDK:c/make
#
HEADERS  = Headers/
#
CFLAGS = -c -ISDK:Local/Include -I$(HEADERS)
#
AFLAGS = -c -S -fverbose-asm -ISDK:Local/Include -I$(HEADERS)
#
ASM    = -c -x assembler -ISDK:Local/Include -I$(HEADERS)
#
#print-%: ; @echo $* is $($*)
#
# --------------------------------------------------------------------
#
DBGFLAGS = -c -ggdb -gdwarf-2 -ISDK:Local/Include -I$(HEADERS)
#
# --------------------------------------------------------------------
#
# need structequivalence = streq flag for proper MsgPort operation! 
# This is going to be a problem for gcc!!
#
MsgOpts = $(DBGFLAGS)
# streq saveds
#
OD   = OBJ/
#
GLOB = CPGM:GlobalObjects/CommonFuncsPPC.o CPGM:GlobalObjects/AllocStructPPC.o \
	CPGM:GLobalObjects/IniFuncsPPC.o
#
COMMON = GlobalObjects/CommonFuncsPPC.o
#
# $(OD)ATHB.o $(OD)Narrator.o 
#
OBJS = $(GLOB) $(OD)main.o $(OD)byte.o $(OD)symbol.o \
	$(OD)cldict.o $(OD)interp.o $(OD)drive.o $(OD)lex.o $(OD)lexcmd.o \
	$(OD)line.o $(OD)courier.o $(OD)object.o $(OD)number.o \
	$(OD)process.o $(OD)array.o $(OD)file.o $(OD)block.o   \
	$(OD)string.o $(OD)class.o $(OD)CurPrims.o \
	$(OD)Primitive.o $(OD)PrimFuncs.o $(OD)Screen.o $(OD)Window.o\
	$(OD)ATMenus.o $(OD)ATGadgets.o $(OD)Setup.o $(OD)Console.o \
	$(OD)Global.o $(OD)APrintf.o $(OD)ATAbout.o\
	$(OD)ITextFont.o $(OD)Library.o $(OD)SGraphs.o $(OD)Gadget.o \
	$(OD)Border.o $(OD)Menus.o $(OD)Colors.o $(OD)Requester.o \
	$(OD)GamePort.o $(OD)Timer.o $(OD)PlotFuncs.o $(OD)ATHelper.o \
	$(OD)ATalkBrowser.o $(OD)ATalkBrowserAddReq.o $(OD)ATalkBrowserDelReq.o \
	$(OD)MsgPort.o $(OD)Serial.o $(OD)Disk.o $(OD)Disk2.o $(OD)Tools.o \
	$(OD)IO.o $(OD)System.o $(OD)ClipBoard.o $(OD)Tracer.o $(OD)Tracer2.o \
	$(OD)Parallel.o $(OD)Icon.o $(OD)IconDsp.o \
	$(OD)DTInterface.o $(OD)TagFuncs.o $(OD)Printer.o $(OD)ADOS1.o \
	$(OD)ADOS2.o $(OD)ADOS3.o $(OD)ADOS4.o $(OD)IFF.o $(OD)GadTools.o \
	$(OD)Boopsi.o $(OD)GrabMem.o $(OD)AGuide.o $(OD)WBench.o $(OD)UtilityLib.o \
	$(OD)Exec.o $(OD)ExecAlloc.o $(OD)Audio.o $(OD)Keyboard.o \
	$(OD)SCSI.o $(OD)DBase.o $(OD)Layers.o $(OD)Rexx.o $(OD)ReportErrs.o $(OD)CDROM.o \
	$(OD)UserScriptReq.o $(OD)ATalkTracer.o $(OD)SDict.o $(OD)Address.o \
	$(OD)ATPalette.o $(OD)CatFuncs1.o $(OD)CatFuncs2.o $(OD)CatFuncs3.o
#
clean:
	Delete $(OD)*.s
	Delete *.s
#
LIBS = -lm -lamiga -lstringfuncs -lcurses -ldbc3 -lauto
#
.c.o:
	EnsureASCII $<     RAM:$<
	Copy        RAM:$< $<
	Delete      RAM:$<
	$(CC) $(CFLAGS) $<
#
# -------------- Final Target: ------------------------------------------
# $(OD)Alert.o
# 
AmigaTalkPPC : % :	$(OBJS)
	$(CC) $(OBJS) -o AmigaTalk:AmigaTalkPPC $(LIBS)
#
# -------------- Debug Target: ------------------------------------------
# $(OD)Alert.o 
#
AmigaTalkPPCDBG : % :	$(OBJS)
	$(CC) $(OBJS) -o AmigaTalk:$@ $(LIBS)
	Copy     AmigaTalk:$@ TO AmigaTalk:AmigaTalkPPC QUIET
#	WAIT 2
#	FileNote AmigaTalk:AmigaTalkPPC       "DEBUG Version of AmigaTalk!"
#
# AmigaTalkPPCDBG has to be named AmigaTalkPPC so that TheBrowser can find it.
# This is why the Copy & FileNote steps are placed here.   
# -----------------------------------------------------------------------
#
#           ST.ln contains all dependencies & libraries.
#
#
$(HEADERS)ATalkLocale.h : amigatalk.cd
	CatComp $<     CFILE  RAM:ATalkLocale.h NOCODE NOARRAY NOBLOCK
	CatComp $<     CTFILE RAM:amigatalk.ct
	Copy   RAM:ATalkLocale.h $@
	Copy   RAM:amigatalk.ct  Amigatalk:Locale/Catalogs/amigatalk.ct
	Copy   $<                Amigatalk:Locale/Catalogs/$<
	Delete RAM:ATalkLocale.h RAM:amigatalk.ct QUIET
#   
$(HEADERS)ATalkEnvironLocale.h : ATalkEnviron.cd
	CatComp $<     CFILE  RAM:ATalkEnvironLocale.h NOCODE NOARRAY NOBLOCK
	CatComp $<     CTFILE RAM:atalkenviron.ct
	Copy   RAM:ATalkEnvironLocale.h $@
	Copy   RAM:atalkenviron.ct  Amigatalk:Locale/Catalogs/atalkenviron.ct
	Copy   $<                   Amigatalk:Locale/Catalogs/$<
	Delete RAM:ATalkEnvironLocale.h RAM:atalkenviron.ct QUIET
#   
# ------------------ Files with Amiga parts: ---------------------------
#
$(OD)Main.o : Main.c $(HEADERS)ATStructs.h
	EnsureASCII $<     RAM:$<
	Copy        RAM:$< $<
	Delete      RAM:$<
	$(CC) $(MsgOpts) -DRDARGS=1 -DDEBUG=1 -o $@ $<
#
$(OD)ATalkTracer.o : ATalkTracer.c $(HEADERS)ATStructs.h
	EnsureASCII $<     RAM:$<
	Copy        RAM:$< $<
	Delete      RAM:$<
	$(CC) $(DBGFLAGS) -o $@ $<
#
$(OD)CatFuncs1.o : CatFuncs1.c $(HEADERS)ATalkLocale.h $(HEADERS)ATalkEnvironLocale.h $(HEADERS)StringIndexes.h
	EnsureASCII $<     RAM:$<
	Copy        RAM:$< $<
	Delete      RAM:$<
	$(CC) $(CFLAGS) -o $@ $<
#
$(OD)CatFuncs2.o : CatFuncs2.c $(HEADERS)ATalkLocale.h $(HEADERS)StringIndexes.h
	EnsureASCII $<     RAM:$<
	Copy        RAM:$< $<
	Delete      RAM:$<
	$(CC) $(CFLAGS) -o $@ $<
#
$(OD)CatFuncs3.o : CatFuncs3.c $(HEADERS)ATalkLocale.h $(HEADERS)StringIndexes.h
	EnsureASCII $<     RAM:$<
	Copy        RAM:$< $<
	Delete      RAM:$<
	$(CC) $(CFLAGS) -o $@ $<
#
# ---------- Users of IniFuncsPPC.o: --------------------------------------------
#
$(OD)Setup.o : Setup.c ATMenus.c ATGadgets.c
	EnsureASCII $<     RAM:$<
	Copy        RAM:$< $<
	Delete      RAM:$<
	$(CC) $(DBGFLAGS) -DDEBUG=1 -o $@ $<
#
$(OD)ATPalette.o : ATPalette.c $(HEADERS)ATalkEnvironLocale.h
	EnsureASCII $<     RAM:$<
	Copy        RAM:$< $<
	Delete      RAM:$<
	$(CC) $(CFLAGS) -DDEBUG=1 -o $@ $<
#
$(OD)ATalkEnviron.o : ATalkEnviron.c $(HEADERS)ATalkEnvironLocale.h
	EnsureASCII $<     RAM:$<
	Copy        RAM:$< $<
	Delete      RAM:$<
	$(CC) $(CFLAGS) -o $@ $<
#
GLOBA  = CPGM:GlobalObjects/CommonFuncsPPC.o CPGM:GlobalObjects/IniFuncsPPC.o
#
EELIBS = -lm -lamiga -lstringfuncs -lauto
#
ATalkEnvEditorPPC : ATalkEnvironPPC.o $(OD)CatFuncs1.o
	$(CC) ATalkEnvironPPC.o $(GLOBA) $(OD)CatFuncs1.o -o $@ $(EELIBS)
	COPY $@ Amigatalk:c/$@
#
ATalkEnvironPPC.o : ATalkEnviron.c
	EnsureASCII $<     RAM:$<
	Copy        RAM:$< $<
	Delete      RAM:$<
	$(CC) $(CFLAGS) -DSTANDALONE=1 -o $@ $<
#
# -------------------------------------------------------------------------------
#
$(OD)Address.o : Address.c $(HEADERS)ATStructs.h
	EnsureASCII $<     RAM:$<
	Copy        RAM:$< $<
	Delete      RAM:$<
	$(CC) $(DBGFLAGS) -o $@ $<
#
# -------------------- Primitive 209 files: ----------------------------
# $(GLOB)
$(OD)GrabMem.o : GrabMem.c
	EnsureASCII $<     RAM:$<
	Copy        RAM:$< $<
	Delete      RAM:$<
	$(CC) $(CFLAGS) -o $@ $<
#
$(OD)AGuide.o : AGuide.c
	EnsureASCII $<     RAM:$<
	Copy        RAM:$< $<
	Delete      RAM:$<
	$(CC) $(CFLAGS) -o $@ $<
#
$(OD)WBench.o : WBench.c
	EnsureASCII $<     RAM:$<
	Copy        RAM:$< $<
	Delete      RAM:$<
	$(CC) $(CFLAGS) -o $@ $<
#
$(OD)UtilityLib.o : UtilityLib.c
	EnsureASCII $<     RAM:$<
	Copy        RAM:$< $<
	Delete      RAM:$<
	$(CC) $(CFLAGS) -o $@ $<
#
#$(OD)asmUtilLib.o : asmUtilLib.asm
#	CASM -a asmUtilLib.asm $(AOPTS) -o $(OD)asmUtilLib.o
#
$(OD)Exec.o : Exec.c
	EnsureASCII $<     RAM:$<
	Copy        RAM:$< $<
	Delete      RAM:$<
	$(CC) $(CFLAGS) -o $@ $<
#
$(OD)ExecAlloc.o : ExecAlloc.c
	EnsureASCII $<     RAM:$<
	Copy        RAM:$< $<
	Delete      RAM:$<
	$(CC) $(CFLAGS) -o $@ $<
#
$(OD)DBase.o : DBase.c
	EnsureASCII $<     RAM:$<
	Copy        RAM:$< $<
	Delete      RAM:$<
	$(CC) $(CFLAGS) -o $@ $<
#
# ----------------------------------------------------------------------
#
$(OD)SDict.o : SDict.c
	EnsureASCII $<     RAM:$<
	Copy        RAM:$< $<
	Delete      RAM:$<
	$(CC) $(DBGFLAGS) -o $@ $<
#
#
# -------------------- Trace window support: ---------------------------
# $(GLOB)
$(OD)Tracer.o : Tracer.c $(HEADERS)ATStructs.h
	EnsureASCII $<     RAM:$<
	Copy        RAM:$< $<
	Delete      RAM:$<
	$(CC) $(DBGFLAGS) -o $@ $<
#
# $(GLOB)
$(OD)Tracer2.o : Tracer2.c $(HEADERS)ATStructs.h
	EnsureASCII $<     RAM:$<
	Copy        RAM:$< $<
	Delete      RAM:$<
	$(CC) $(DBGFLAGS) -o $@ $<
#
# -------------------- IFF-related functions: --------------------------
#
$(OD)IFF.o : IFF.c
	EnsureASCII $<     RAM:$<
	Copy        RAM:$< $<
	Delete      RAM:$<
	$(CC) $(CFLAGS) -o $@ $<
#
# -------------------- GadTools-related functions: ---------------------
#
$(OD)GadTools.o : GadTools.c
	EnsureASCII $<     RAM:$<
	Copy        RAM:$< $<
	Delete      RAM:$<
	$(CC) $(DBGFLAGS) -o $@ $<
#
# -------------------- AmigaDOS-related functions: ---------------------
#
$(OD)ADOS1.o : ADOS1.c # SAFE
	EnsureASCII $<     RAM:$<
	Copy        RAM:$< $<
	Delete      RAM:$<
	$(CC) $(CFLAGS) -o $@ $<
#
$(OD)ADOS2.o : ADOS2.c  # UNSAFE 
	EnsureASCII $<     RAM:$<
	Copy        RAM:$< $<
	Delete      RAM:$<
	$(CC) $(CFLAGS) -o $@ $<
#
$(OD)ADOS3.o : ADOS3.c  # DANGEROUS
	EnsureASCII $<     RAM:$<
	Copy        RAM:$< $<
	Delete      RAM:$<
	$(CC) $(CFLAGS) -o $@ $<
#
$(OD)ADOS4.o : ADOS4.c  # VERY DANGEROUS
	EnsureASCII $<     RAM:$<
	Copy        RAM:$< $<
	Delete      RAM:$<
	$(CC) $(CFLAGS) -o $@ $<
#
# -------------------- CDROM-related<218 0 ??> functions: --------------
#
$(OD)CDROM.o : CDROM.c
	EnsureASCII $<     RAM:$<
	Copy        RAM:$< $<
	Delete      RAM:$<
	$(CC) $(CFLAGS) -o $@ $<
#
# -------------------- MsgPort-related functions: ----------------------
# Place streq in CFLAGS somehow
#
$(OD)MsgPort.o : MsgPort.c
	EnsureASCII $<     RAM:$<
	Copy        RAM:$< $<
	Delete      RAM:$<
	$(CC) $(CFLAGS) -o $@ $<
#
# -------------------- ARexxPort-related functions: --------------------
# Place streq in CFLAGS somehow
#
$(OD)Rexx.o : Rexx.c
	EnsureASCII $<     RAM:$<
	Copy        RAM:$< $<
	Delete      RAM:$<
	$(CC) $(CFLAGS) -o $@ $<
#
# -------------------- Boopsi-related functions: -----------------------
#
$(OD)Boopsi.o : Boopsi.c
	EnsureASCII $<     RAM:$<
	Copy        RAM:$< $<
	Delete      RAM:$<
	$(CC) $(CFLAGS) -o $@ $<
#
# ----------------- System Access-related functions: -------------------
#
$(OD)System.o : System.c
	EnsureASCII $<     RAM:$<
	Copy        RAM:$< $<
	Delete      RAM:$<
	$(CC) $(DBGFLAGS) -o $@ $<
#
# -------------------- ToolType-related functions & data: --------------
#
$(OD)Tools.o : Tools.c
	EnsureASCII $<     RAM:$<
	Copy        RAM:$< $<
	Delete      RAM:$<
	$(CC) $(CFLAGS) -o $@ $<
#
# -------------------- DataType-related functions & data: --------------
#
$(OD)DTInterface.o : DTInterface.c
	EnsureASCII $<     RAM:$<
	Copy        RAM:$< $<
	Delete      RAM:$<
	$(CC) $(CFLAGS) -o $@ $<
#
$(OD)TagFuncs.o : TagFuncs.c
	EnsureASCII $<     RAM:$<
	Copy        RAM:$< $<
	Delete      RAM:$<
	$(CC) $(DBGFLAGS) -o $@ $<
#
# -------------------- Icon-related functions & data: ------------------
#
$(OD)Icon.o : Icon.c
	EnsureASCII $<     RAM:$<
	Copy        RAM:$< $<
	Delete      RAM:$<
	$(CC) $(CFLAGS) -o $@ $<
#
$(OD)IconDsp.o : IconDsp.c
	EnsureASCII $<     RAM:$<
	Copy        RAM:$< $<
	Delete      RAM:$<
	$(CC) $(CFLAGS) -o $@ $<
#
# -------------------- SCSI-related targets: ---------------------------
#
$(OD)SCSI.o : SCSI.c
	EnsureASCII $<     RAM:$<
	Copy        RAM:$< $<
	Delete      RAM:$<
	$(CC) $(CFLAGS) -o $@ $<
#
# -------------------- TrackDisk-related functions: --------------------
#
$(OD)Disk2.o : Disk2.c
	EnsureASCII $<     RAM:$<
	Copy        RAM:$< $<
	Delete      RAM:$<
	$(CC) $(CFLAGS) -o $@ $<
#
$(OD)Disk.o : Disk.c
	EnsureASCII $<     RAM:$<
	Copy        RAM:$< $<
	Delete      RAM:$<
	$(CC) $(CFLAGS) -o $@ $<
#
# -------------------- Audio-related functions: ------------------------
#
$(OD)Audio.o : Audio.c
	EnsureASCII $<     RAM:$<
	Copy        RAM:$< $<
	Delete      RAM:$<
	$(CC) $(CFLAGS) -o $@ $<
#
# -------------------- Keyboard-related functions: ---------------------
#
$(OD)Keyboard.o : Keyboard.c
	EnsureASCII $<     RAM:$<
	Copy        RAM:$< $<
	Delete      RAM:$<
	$(CC) $(CFLAGS) -o $@ $<
#
# -------------------- Serial-related functions: -----------------------
#
$(OD)Serial.o : Serial.c
	EnsureASCII $<     RAM:$<
	Copy        RAM:$< $<
	Delete      RAM:$<
	$(CC) $(CFLAGS) -o $@ $<
#
# -------------------- Printer-related functions: ----------------------
#
$(OD)Printer.o : Printer.c
	EnsureASCII $<     RAM:$<
	Copy        RAM:$< $<
	Delete      RAM:$<
	$(CC) $(CFLAGS) -o $@ $<
#
# -------------------- Parallel-related functions: ---------------------
#
$(OD)Parallel.o : Parallel.c
	EnsureASCII $<     RAM:$<
	Copy        RAM:$< $<
	Delete      RAM:$<
	$(CC) $(CFLAGS) -o $@ $<
#
# -------------------- Layers-related functions: -----------------------
#
$(OD)Layers.o :   Layers.c
	EnsureASCII $<     RAM:$<
	Copy        RAM:$< $<
	Delete      RAM:$<
	$(CC) $(CFLAGS) -o $@ $<
#
# -------------------- Narrator-related functions : ---------------------
#
$(OD)Narrator.o : Narrator.c
	EnsureASCII $<     RAM:$<
	Copy        RAM:$< $<
	Delete      RAM:$<
	$(CC) $(CFLAGS) -o $@ $<
#
# -------------------- Clipboard-related functions: --------------------
#
$(OD)ClipBoard.o : ClipBoard.c
	EnsureASCII $<     RAM:$<
	Copy        RAM:$< $<
	Delete      RAM:$<
	$(CC) $(CFLAGS) -o $@ $<
#
# -------------------- HelpSystem-related functions: -------------------
#
$(OD)ATHelper.o  : ATHelper.c
	EnsureASCII $<     RAM:$<
	Copy        RAM:$< $<
	Delete      RAM:$<
	$(CC) $(CFLAGS) -o $@ $<
#
# -------------------- Curses-related functions: -----------------------
#
$(OD)CurPrims.o : CurPrims.c
	EnsureASCII $<     RAM:$<
	Copy        RAM:$< $<
	Delete      RAM:$<
	$(CC) $(CFLAGS) -DDEBUG=1 -o $@ $<
#
# -------------------- Command Menu-related functions: -----------------
#
$(OD)ATMenus.o : ATMenus.c
	EnsureASCII $<     RAM:$<
	Copy        RAM:$< $<
	Delete      RAM:$<
	$(CC) $(DBGFLAGS) -o $@ $<
#
$(OD)UserScriptReq.o : UserScriptReq.c
	EnsureASCII $<     RAM:$<
	Copy        RAM:$< $<
	Delete      RAM:$<
	$(CC) $(CFLAGS) -o $@ $<
#
# -------------------- Command Gadget-related functions: ---------------
#
$(OD)ATGadgets.o : ATGadgets.c
	EnsureASCII $<     RAM:$<
	Copy        RAM:$< $<
	Delete      RAM:$<
	$(CC) $(CFLAGS) -o $@ $<
#
# -------------------- AmigaPrintf-related functions: ------------------
#
$(OD)APrintf.o :   APrintf.c
	EnsureASCII $<     RAM:$<
	Copy        RAM:$< $<
	Delete      RAM:$<
	$(CC) $(CFLAGS) -o $@ $<
#
# -------------------- Simple Requester-related functions: -------------
#
$(OD)IO.o : IO.c
	EnsureASCII $<     RAM:$<
	Copy        RAM:$< $<
	Delete      RAM:$<
	$(CC) $(DBGFLAGS) -o $@ $<
#
# -------------------- Smalltalk Primitives-related functions: ---------
#
$(OD)Primitive.o : Primitive.c $(HEADERS)ATStructs.h
	EnsureASCII $<     RAM:$<
	Copy        RAM:$< $<
	Delete      RAM:$<
	$(CC) $(CFLAGS) -o $@ $<
#
$(OD)PrimFuncs.o : PrimFuncs.c $(HEADERS)ATStructs.h
	EnsureASCII $<     RAM:$<
	Copy        RAM:$< $<
	Delete      RAM:$<
	$(CC) $(CFLAGS) -o $@ $<
#
$(OD)PlotFuncs.o : PlotFuncs.c $(HEADERS)ATStructs.h
	EnsureASCII $<     RAM:$<
	Copy        RAM:$< $<
	Delete      RAM:$<
	$(CC) $(CFLAGS) -o $@ $<
#
# -------------------- Program Info Requester: -------------------------
#
$(OD)ATAbout.o : ATAbout.c
	EnsureASCII $<     RAM:$<
	Copy        RAM:$< $<
	Delete      RAM:$<
	$(CC) $(CFLAGS) -o $@ $<
#
# -------------------- Browser Requester: ------------------------------
#
$(OD)ATHB.o : ATHB.c
	EnsureASCII $<     RAM:$<
	Copy        RAM:$< $<
	Delete      RAM:$<
	$(CC) $(CFLAGS) -o $@ $<
#
# -------------------- Global functions & data: ------------------------
# define MEMDEBUG=1
#
$(OD)Global.o : Global.c $(HEADERS)ATStructs.h
	EnsureASCII $<     RAM:$<
	Copy        RAM:$< $<
	Delete      RAM:$<
	$(CC) $(DBGFLAGS) -o $@ $<
#
$(OD)ReportErrs.o : ReportErrs.c
	EnsureASCII $<     RAM:$<
	Copy        RAM:$< $<
	Delete      RAM:$<
	$(CC) $(CFLAGS) -DDEBUG=1 -o $@ $<
#
# -------------------- Browser-related functions: ------------------------
#
$(HEADERS)ATBrowserLocale.h : atalkbrowser.cd
	EnsureASCII $<     RAM:$<
	Copy        RAM:$< $<
	Delete      RAM:$<
	CatComp $< CFILE  RAM:ATBrowserLocale.h NOBLOCK NOARRAY NOCODE
	CatComp $< CTFILE RAM:atalkbrowser.ct
	Copy   RAM:ATBrowserLocale.h $@
	Copy   RAM:atalkbrowser.ct   Amigatalk:Locale/Catalogs/atalkbrowser.ct
	Copy   atalkbrowser.cd       Amigatalk:Locale/Catalogs/atalkbrowser.cd
	Delete RAM:ATBrowserLocale.h RAM:atalkbrowser.ct QUIET
#
$(OD)ATalkBrowser.o : ATalkBrowser.c $(HEADERS)ATBrowserLocale.h
	EnsureASCII $<     RAM:$<
	Copy        RAM:$< $<
	Delete      RAM:$<
	$(CC) $(DBGFLAGS) -DDEBUG=1 -o $@ $<
#
$(OD)ATalkBrowserAddReq.o : ATalkBrowserAddReq.c $(HEADERS)ATBrowserLocale.h
	EnsureASCII $<     RAM:$<
	Copy        RAM:$< $<
	Delete      RAM:$<
	$(CC) $(DBGFLAGS) -o $@ $<
#
# --------------------- Check ATalkBrowserAddReq code: -------------------------
#
RAFLAGS = -lm -lamiga -lauto
#
ATalkBrowserAddReqDBG : ATalkBrowserAddReqD.o
	$(CC) CPGM:$(COMMON) $< -o $@ $(RAFLAGS)
#
ATalkBrowserAddReqD.o : ATalkBrowserAddReq.c $(HEADERS)ATBrowserLocale.h 
	EnsureASCII $<     RAM:$<
	Copy        RAM:$< $<
	Delete      RAM:$<
	$(CC) -DDEBUG=1 $(DBGFLAGS) -o $@ $<
#
# -------------------------------------------------------------------
#
$(OD)ATalkBrowserDelReq.o : ATalkBrowserDelReq.c $(HEADERS)ATBrowserLocale.h
	EnsureASCII $<     RAM:$<
	Copy        RAM:$< $<
	Delete      RAM:$<
	$(CC) $(DBGFLAGS) -o $@ $<
#
#$(OD)ARexxFuncs.o : ARexxFuncs.c
#	$(CC) $(CFLAGS) -o $@ $<
#
# -------------------- Console-related functions: ----------------------
#
$(OD)Console.o :  Console.c
	EnsureASCII $<     RAM:$<
	Copy        RAM:$< $<
	Delete      RAM:$<
	$(CC) $(CFLAGS) -o $@ $<
#
# -------------------- Screen-related functions: -----------------------
#
$(OD)Screen.o : Screen.c
	EnsureASCII $<     RAM:$<
	Copy        RAM:$< $<
	Delete      RAM:$<
	$(CC) $(DBGFLAGS) -DDEBUG=1 -o $@ $<
#
# -------------------- Window-related functions: -----------------------
#
$(OD)Window.o : Window.c
	EnsureASCII $<     RAM:$<
	Copy        RAM:$< $<
	Delete      RAM:$<
	$(CC) $(CFLAGS) -DDEBUG=1 -o $@ $<
#
# -------------------- Color Register-related functions: ---------------
#
$(OD)Colors.o :  Colors.c
	EnsureASCII $<     RAM:$<
	Copy        RAM:$< $<
	Delete      RAM:$<
	$(CC) $(CFLAGS) -o $@ $<
#
# -------------------- Library-related functions: ----------------------
#
$(OD)Library.o :  Library.c
	EnsureASCII $<     RAM:$<
	Copy        RAM:$< $<
	Delete      RAM:$<
	$(CC) $(CFLAGS) -o $@ $<
#
# -------------------- Gadget-related functions: -----------------------
#
$(OD)Gadget.o :  Gadget.c
	EnsureASCII $<     RAM:$<
	Copy        RAM:$< $<
	Delete      RAM:$<
	$(CC) $(CFLAGS) -DDEBUG=1 -o $@ $<
#
# -------------------- Border-related functions: -----------------------
#
$(OD)Border.o :  Border.c
	EnsureASCII $<     RAM:$<
	Copy        RAM:$< $<
	Delete      RAM:$<
	$(CC) $(CFLAGS) -o $@ $<
#
# -------------------- Menu-related functions: -------------------------
#
$(OD)Menus.o :  Menus.c
	EnsureASCII $<     RAM:$<
	Copy        RAM:$< $<
	Delete      RAM:$<
	$(CC) $(CFLAGS) -o $@ $<
#
# -------------------- Requester-related functions: --------------------
#
$(OD)Requester.o :  Requester.c
	EnsureASCII $<     RAM:$<
	Copy        RAM:$< $<
	Delete      RAM:$<
	$(CC) $(CFLAGS) -o $@ $<
#
#$(OD)Alert.o :  Alert.c
#	$(CC) $(CFLAGS) -o $@ $<
#
# -------------------- Primitive Graphics-related functions: -------------
#
$(OD)SGraphs.o :  SGraphs.c
	EnsureASCII $<     RAM:$<
	Copy        RAM:$< $<
	Delete      RAM:$<
	$(CC) $(DBGFLAGS) -DDEBUG=1 -o $@ $<
#
# -------------------- GamePort-related functions: -----------------------
#
$(OD)GamePort.o :  GamePort.c
	EnsureASCII $<     RAM:$<
	Copy        RAM:$< $<
	Delete      RAM:$<
	$(CC) $(CFLAGS) -DDEBUG=1 -o $@ $<
#
# -------------------- Timer-related functions: --------------------------
#
$(OD)Timer.o :     Timer.c 
	EnsureASCII $<     RAM:$<
	Copy        RAM:$< $<
	Delete      RAM:$<
	$(CC) $(CFLAGS) -DDEBUG=1 -o $@ $<
#
# ------------IntuiText & Font-related functions: ------------------------
#
$(OD)ITextFont.o :  ITextFont.c
	EnsureASCII $<     RAM:$<
	Copy        RAM:$< $<
	Delete      RAM:$<
	$(CC) $(CFLAGS) -o $@ $<
#
# -------------------- UserInput-related function: -----------------------
#
$(OD)line.o :    line.c $(HEADERS)ATStructs.h
	EnsureASCII $<     RAM:$<
	Copy        RAM:$< $<
	Delete      RAM:$<
	$(CC) $(CFLAGS) -o $@ $<
#
# ----------------- Pure SmallTalk files: --------------------------------
#
$(OD)byte.o :    byte.c $(HEADERS)ATStructs.h
	EnsureASCII $<     RAM:$<
	Copy        RAM:$< $<
	Delete      RAM:$<
	$(CC) $(DBGFLAGS) -o $@ $<
#
$(OD)symbol.o :  symbol.c $(HEADERS)ATStructs.h
	EnsureASCII $<     RAM:$<
	Copy        RAM:$< $<
	Delete      RAM:$<
	$(CC) $(DBGFLAGS) -o $@ $<
#
$(OD)cldict.o :  cldict.c $(HEADERS)ATStructs.h
	EnsureASCII $<     RAM:$<
	Copy        RAM:$< $<
	Delete      RAM:$<
	$(CC) $(DBGFLAGS) -o $@ $<
#
$(OD)interp.o :   interp.c $(HEADERS)ATStructs.h
	EnsureASCII $<     RAM:$<
	Copy        RAM:$< $<
	Delete      RAM:$<
	$(CC) $(DBGFLAGS) -o $@ $<
#
$(OD)drive.o :    drive.c $(HEADERS)ATStructs.h
	EnsureASCII $<     RAM:$<
	Copy        RAM:$< $<
	Delete      RAM:$<
	$(CC) -DTRACE=1 $(CFLAGS) -o $@ $<
#
$(OD)lex.o :      lex.c $(HEADERS)ATStructs.h
	EnsureASCII $<     RAM:$<
	Copy        RAM:$< $<
	Delete      RAM:$<
	$(CC) $(CFLAGS) -o $@ $<
#
$(OD)lexcmd.o :  lexcmd.c
	EnsureASCII $<     RAM:$<
	Copy        RAM:$< $<
	Delete      RAM:$<
	$(CC) $(CFLAGS) -o $@ $<
#
$(OD)courier.o : courier.c $(HEADERS)ATStructs.h
	EnsureASCII $<     RAM:$<
	Copy        RAM:$< $<
	Delete      RAM:$<
	$(CC) $(DBGFLAGS) -o $@ $<
#
$(OD)object.o :   object.c $(HEADERS)ATStructs.h
	EnsureASCII $<     RAM:$<
	Copy        RAM:$< $<
	Delete      RAM:$<
	$(CC) $(DBGFLAGS) -o $@ $<
#
$(OD)number.o :  number.c $(HEADERS)ATStructs.h
	EnsureASCII $<     RAM:$<
	Copy        RAM:$< $<
	Delete      RAM:$<
	$(CC) $(CFLAGS) -o $@ $<
#
# for process.o, stackextend flag is what in gcc???
#
$(OD)process.o : process.c $(HEADERS)ATStructs.h
	EnsureASCII $<     RAM:$<
	Copy        RAM:$< $<
	Delete      RAM:$<
	$(CC) $(DBGFLAGS) -o $@ $<
#
$(OD)array.o :   array.c $(HEADERS)ATStructs.h
	EnsureASCII $<     RAM:$<
	Copy        RAM:$< $<
	Delete      RAM:$<
	$(CC) $(CFLAGS) -o $@ $<
#
$(OD)file.o :    file.c $(HEADERS)ATStructs.h
	EnsureASCII $<     RAM:$<
	Copy        RAM:$< $<
	Delete      RAM:$<
	$(CC) $(CFLAGS) -o $@ $<
#
$(OD)block.o :   block.c $(HEADERS)ATStructs.h
	EnsureASCII $<     RAM:$<
	Copy        RAM:$< $<
	Delete      RAM:$<
	$(CC) $(DBGFLAGS) -o $@ $<
#
$(OD)string.o :  string.c $(HEADERS)ATStructs.h
	EnsureASCII $<     RAM:$<
	Copy        RAM:$< $<
	Delete      RAM:$<
	$(CC) $(CFLAGS) -o $@ $<
#
$(OD)class.o :    class.c $(HEADERS)ATStructs.h
	EnsureASCII $<     RAM:$<
	Copy        RAM:$< $<
	Delete      RAM:$<
	$(CC) $(DBGFLAGS) -o $@ $<
#
# -------- Test files: -----------------------------------------------
#
TestMemFuncs :  TestMemFuncs.o $(OD)asmUtilLib.o
	$(CC) TestMemFuncs.o $< -o $@ $(LIBS)
#
TestMemFuncs.o :  TestMemFuncs.c
	EnsureASCII $<     RAM:$<
	Copy        RAM:$< $<
	Delete      RAM:$<
	$(CC) $(DBGFLAGS) -o $@ $<
#
TestBrowser : % :  TestBrowser.o $(OD)ATalkBrowser.o $(GLOB)
	$(CC) $(GLOB) TestBrowser.o $(OD)ATalkBrowser.o -o $@ $(LIBS)
#
TestBrowser.o :  TestBrowser.c
	EnsureASCII $<     RAM:$<
	Copy        RAM:$< $<
	Delete      RAM:$<
	$(CC) $(DBGFLAGS) -o $@ $<
#
# $(GLOB)
MsgPortTesterPPC : MsgPortTesterPPC.o
	$(CC) CPGM:$(COMMON) $< -o $@ $(LIBS)
	Copy $@ AmigaTalk:C/$@
	Delete $< $@
#
MsgPortTesterPPC.o : MsgPortTester.c
	EnsureASCII $<     RAM:$<
	Copy        RAM:$< $<
	Delete      RAM:$<
	$(CC) $(CFLAGS) -o $@ $<
#
TestAllocMisc : TestAllocMisc.o Allocate_Misc.o
	$(CC) Allocate_Misc.o TestAllocMisc.o -o $@ $(LIBS)
#
TestAllocMisc.o : TestAllocMisc.c
	EnsureASCII $<     RAM:$<
	Copy        RAM:$< $<
	Delete      RAM:$<
	$(CC) $(DBGFLAGS) -DDEBUG=1 -o $@ $<
#
Allocate_Misc.o : Allocate_Misc.c
	EnsureASCII $<     RAM:$<
	Copy        RAM:$< $<
	Delete      RAM:$<
	$(CC) $(DBGFLAGS) -DDEBUG=1 -o $@ $<
#
TestConsole :   TestConsole.o
	$(CC) $< -o $@ $(LIBS)
#
TestConsole.o :  Console.c
	EnsureASCII $<     RAM:$<
	Copy        RAM:$< $<
	Delete      RAM:$<
	$(CC) $(DBGFLAGS) -DTEST_CONSOLE=1 -o $@ $<
#
TestClipboard :   TestClipboard.o Clipboard.o
	$(CC) Clipboard.o TestClipboard.o -o $@ $(LIBS)
#
TestClipboard.o :  Console.c
	EnsureASCII $<     RAM:$<
	Copy        RAM:$< $<
	Delete      RAM:$<
	$(CC) $(DBGFLAGS) -DDEBUG=1 -o $@ $<
#
# use "sprof testsymbol Amigatalk:prelude/Symbols" to check the functions:
#
TestSymbol : % :  TestSymbol.o $(GLOB)
	$(CC) $(GLOB) TestSymbol.o -o $@ $(LIBS)
#
TestSymbol.o :  TestSymbol.c
	EnsureASCII $<     RAM:$<
	Copy        RAM:$< $<
	Delete      RAM:$<
	$(CC) $(DBGFLAGS) -o $@ $<
#
