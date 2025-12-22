LIB		= libauto.a

OBJS		= asl.o bullet.o commodities.o diskfont.o expansion.o \
		  gadtools.o graphics.o icon.o iffparse.o intuition.o \
		  layers.o locale.o mathffp.o mathtrans.o mathieeedoubbas.o \
		  mathieeedoubtrans.o mathieeesingbas.o mathieeesingtrans.o \
		  rexxsyslib.o translator.o utility.o wb.o amigaguide.o \
		  keymap.o lowlevel.o realtime.o datatypes.o nv.o

OBJS_VERS	= asl_vers.o bullet_vers.o commodities_vers.o diskfont_vers.o expansion_vers.o \
		  gadtools_vers.o graphics_vers.o icon_vers.o iffparse_vers.o intuition_vers.o \
		  layers_vers.o locale_vers.o mathffp_vers.o mathtrans_vers.o mathieeedoubbas_vers.o \
		  mathieeedoubtrans_vers.o mathieeesingbas_vers.o mathieeesingtrans_vers.o \
		  rexxsyslib_vers.o translator_vers.o utility_vers.o wb_vers.o amigaguide_vers.o \
		  keymap_vers.o lowlevel_vers.o realtime_vers.o datatypes_vers.o nv_vers.o

$(LIB):		$(OBJS) $(OBJS_VERS) generic_vers.o
		-rm $@
		ar qc $@ $?
		ranlib $@

depmake:	bases
		echo $(OBJS) | gawk -f gendep.awk bases - > depmake

bases:
		fgrep "##base" fd:* > bases

# generated automatically

##############################################################################
asl.o:	base.c
	$(CC) $(CFLAGS) -c base.c -o asl.o -DLIBRARY_NAME=\"asl.library\" \
	  -DLIBRARY_BASE=AslBase -DLIBRARY_VERS=__auto_asl_vers
asl_vers.o:	vers.c
	$(CC) $(CFLAGS) -c vers.c -o asl_vers.o -DLIBRARY_VERS=__auto_asl_vers
##############################################################################
bullet.o:	base.c
	$(CC) $(CFLAGS) -c base.c -o bullet.o -DLIBRARY_NAME=\"bullet.library\" \
	  -DLIBRARY_BASE=BulletBase -DLIBRARY_VERS=__auto_bullet_vers
bullet_vers.o:	vers.c
	$(CC) $(CFLAGS) -c vers.c -o bullet_vers.o -DLIBRARY_VERS=__auto_bullet_vers
##############################################################################
commodities.o:	base.c
	$(CC) $(CFLAGS) -c base.c -o commodities.o -DLIBRARY_NAME=\"commodities.library\" \
	  -DLIBRARY_BASE=CxBase -DLIBRARY_VERS=__auto_commodities_vers
commodities_vers.o:	vers.c
	$(CC) $(CFLAGS) -c vers.c -o commodities_vers.o -DLIBRARY_VERS=__auto_commodities_vers
##############################################################################
diskfont.o:	base.c
	$(CC) $(CFLAGS) -c base.c -o diskfont.o -DLIBRARY_NAME=\"diskfont.library\" \
	  -DLIBRARY_BASE=DiskfontBase -DLIBRARY_VERS=__auto_diskfont_vers
diskfont_vers.o:	vers.c
	$(CC) $(CFLAGS) -c vers.c -o diskfont_vers.o -DLIBRARY_VERS=__auto_diskfont_vers
##############################################################################
expansion.o:	base.c
	$(CC) $(CFLAGS) -c base.c -o expansion.o -DLIBRARY_NAME=\"expansion.library\" \
	  -DLIBRARY_BASE=ExpansionBase -DLIBRARY_VERS=__auto_expansion_vers
expansion_vers.o:	vers.c
	$(CC) $(CFLAGS) -c vers.c -o expansion_vers.o -DLIBRARY_VERS=__auto_expansion_vers
##############################################################################
gadtools.o:	base.c
	$(CC) $(CFLAGS) -c base.c -o gadtools.o -DLIBRARY_NAME=\"gadtools.library\" \
	  -DLIBRARY_BASE=GadToolsBase -DLIBRARY_VERS=__auto_gadtools_vers
gadtools_vers.o:	vers.c
	$(CC) $(CFLAGS) -c vers.c -o gadtools_vers.o -DLIBRARY_VERS=__auto_gadtools_vers
##############################################################################
graphics.o:	base.c
	$(CC) $(CFLAGS) -c base.c -o graphics.o -DLIBRARY_NAME=\"graphics.library\" \
	  -DLIBRARY_BASE=GfxBase -DLIBRARY_VERS=__auto_graphics_vers
graphics_vers.o:	vers.c
	$(CC) $(CFLAGS) -c vers.c -o graphics_vers.o -DLIBRARY_VERS=__auto_graphics_vers
##############################################################################
icon.o:	base.c
	$(CC) $(CFLAGS) -c base.c -o icon.o -DLIBRARY_NAME=\"icon.library\" \
	  -DLIBRARY_BASE=IconBase -DLIBRARY_VERS=__auto_icon_vers
icon_vers.o:	vers.c
	$(CC) $(CFLAGS) -c vers.c -o icon_vers.o -DLIBRARY_VERS=__auto_icon_vers
##############################################################################
iffparse.o:	base.c
	$(CC) $(CFLAGS) -c base.c -o iffparse.o -DLIBRARY_NAME=\"iffparse.library\" \
	  -DLIBRARY_BASE=IFFParseBase -DLIBRARY_VERS=__auto_iffparse_vers
iffparse_vers.o:	vers.c
	$(CC) $(CFLAGS) -c vers.c -o iffparse_vers.o -DLIBRARY_VERS=__auto_iffparse_vers
##############################################################################
intuition.o:	base.c
	$(CC) $(CFLAGS) -c base.c -o intuition.o -DLIBRARY_NAME=\"intuition.library\" \
	  -DLIBRARY_BASE=IntuitionBase -DLIBRARY_VERS=__auto_intuition_vers
intuition_vers.o:	vers.c
	$(CC) $(CFLAGS) -c vers.c -o intuition_vers.o -DLIBRARY_VERS=__auto_intuition_vers
##############################################################################
layers.o:	base.c
	$(CC) $(CFLAGS) -c base.c -o layers.o -DLIBRARY_NAME=\"layers.library\" \
	  -DLIBRARY_BASE=LayersBase -DLIBRARY_VERS=__auto_layers_vers
layers_vers.o:	vers.c
	$(CC) $(CFLAGS) -c vers.c -o layers_vers.o -DLIBRARY_VERS=__auto_layers_vers
##############################################################################
## AJGG: changed in order to use the especial baseLocale.c   ##
###############################################################
locale.o:	baseLocale.c
	$(CC) $(CFLAGS) -c baseLocale.c -o locale.o -DLIBRARY_NAME=\"locale.library\" \
	  -DLIBRARY_BASE=LocaleBase -DLIBRARY_VERS=__auto_locale_vers
locale_vers.o:	vers.c
	$(CC) $(CFLAGS) -c vers.c -o locale_vers.o -DLIBRARY_VERS=__auto_locale_vers
##############################################################################
mathffp.o:	base.c
	$(CC) $(CFLAGS) -c base.c -o mathffp.o -DLIBRARY_NAME=\"mathffp.library\" \
	  -DLIBRARY_BASE=MathBase -DLIBRARY_VERS=__auto_mathffp_vers
mathffp_vers.o:	vers.c
	$(CC) $(CFLAGS) -c vers.c -o mathffp_vers.o -DLIBRARY_VERS=__auto_mathffp_vers
##############################################################################
mathieeedoubbas.o:	base.c
	$(CC) $(CFLAGS) -c base.c -o mathieeedoubbas.o -DLIBRARY_NAME=\"mathieeedoubbas.library\" \
	  -DLIBRARY_BASE=MathIeeeDoubBasBase -DLIBRARY_VERS=__auto_mathieeedoubbas_vers
mathieeedoubbas_vers.o:	vers.c
	$(CC) $(CFLAGS) -c vers.c -o mathieeedoubbas_vers.o -DLIBRARY_VERS=__auto_mathieeedoubbas_vers
##############################################################################
mathieeedoubtrans.o:	base.c
	$(CC) $(CFLAGS) -c base.c -o mathieeedoubtrans.o -DLIBRARY_NAME=\"mathieeedoubtrans.library\" \
	  -DLIBRARY_BASE=MathIeeeDoubTransBase -DLIBRARY_VERS=__auto_mathieeedoubtrans_vers
mathieeedoubtrans_vers.o:	vers.c
	$(CC) $(CFLAGS) -c vers.c -o mathieeedoubtrans_vers.o -DLIBRARY_VERS=__auto_mathieeedoubtrans_vers
##############################################################################
mathieeesingbas.o:	base.c
	$(CC) $(CFLAGS) -c base.c -o mathieeesingbas.o -DLIBRARY_NAME=\"mathieeesingbas.library\" \
	  -DLIBRARY_BASE=MathIeeeSingBasBase -DLIBRARY_VERS=__auto_mathieeesingbas_vers
mathieeesingbas_vers.o:	vers.c
	$(CC) $(CFLAGS) -c vers.c -o mathieeesingbas_vers.o -DLIBRARY_VERS=__auto_mathieeesingbas_vers
##############################################################################
mathieeesingtrans.o:	base.c
	$(CC) $(CFLAGS) -c base.c -o mathieeesingtrans.o -DLIBRARY_NAME=\"mathieeesingtrans.library\" \
	  -DLIBRARY_BASE=MathIeeeSingTransBase -DLIBRARY_VERS=__auto_mathieeesingtrans_vers
mathieeesingtrans_vers.o:	vers.c
	$(CC) $(CFLAGS) -c vers.c -o mathieeesingtrans_vers.o -DLIBRARY_VERS=__auto_mathieeesingtrans_vers
##############################################################################
mathtrans.o:	base.c
	$(CC) $(CFLAGS) -c base.c -o mathtrans.o -DLIBRARY_NAME=\"mathtrans.library\" \
	  -DLIBRARY_BASE=MathTransBase -DLIBRARY_VERS=__auto_mathtrans_vers
mathtrans_vers.o:	vers.c
	$(CC) $(CFLAGS) -c vers.c -o mathtrans_vers.o -DLIBRARY_VERS=__auto_mathtrans_vers
##############################################################################
rexxsyslib.o:	base.c
	$(CC) $(CFLAGS) -c base.c -o rexxsyslib.o -DLIBRARY_NAME=\"rexxsyslib.library\" \
	  -DLIBRARY_BASE=RexxSysBase -DLIBRARY_VERS=__auto_rexxsyslib_vers
rexxsyslib_vers.o:	vers.c
	$(CC) $(CFLAGS) -c vers.c -o rexxsyslib_vers.o -DLIBRARY_VERS=__auto_rexxsyslib_vers
##############################################################################
translator.o:	base.c
	$(CC) $(CFLAGS) -c base.c -o translator.o -DLIBRARY_NAME=\"translator.library\" \
	  -DLIBRARY_BASE=TranslatorBase -DLIBRARY_VERS=__auto_translator_vers
translator_vers.o:	vers.c
	$(CC) $(CFLAGS) -c vers.c -o translator_vers.o -DLIBRARY_VERS=__auto_translator_vers
##############################################################################
utility.o:	base.c
	$(CC) $(CFLAGS) -c base.c -o utility.o -DLIBRARY_NAME=\"utility.library\" \
	  -DLIBRARY_BASE=UtilityBase -DLIBRARY_VERS=__auto_utility_vers
utility_vers.o:	vers.c
	$(CC) $(CFLAGS) -c vers.c -o utility_vers.o -DLIBRARY_VERS=__auto_utility_vers
##############################################################################
wb.o:	base.c
	$(CC) $(CFLAGS) -c base.c -o wb.o -DLIBRARY_NAME=\"wb.library\" \
	  -DLIBRARY_BASE=WorkbenchBase -DLIBRARY_VERS=__auto_wb_vers
wb_vers.o:	vers.c
	$(CC) $(CFLAGS) -c vers.c -o wb_vers.o -DLIBRARY_VERS=__auto_wb_vers
##############################################################################
## AJGG: generated manually.  ##
################################
amigaguide.o:	base.c
	$(CC) $(CFLAGS) -c base.c -o amigaguide.o -DLIBRARY_NAME=\"amigaguide.library\" \
	  -DLIBRARY_BASE=AmigaGuideBase -DLIBRARY_VERS=__auto_amigaguide_vers
amigaguide_vers.o:	vers.c
	$(CC) $(CFLAGS) -c vers.c -o amigaguide_vers.o -DLIBRARY_VERS=__auto_amigaguide_vers
##############################################################################
keymap.o:	base.c
	$(CC) $(CFLAGS) -c base.c -o keymap.o -DLIBRARY_NAME=\"keymap.library\" \
	  -DLIBRARY_BASE=KeymapBase -DLIBRARY_VERS=__auto_keymap_vers
keymap_vers.o:	vers.c
	$(CC) $(CFLAGS) -c vers.c -o keymap_vers.o -DLIBRARY_VERS=__auto_keymap_vers
##############################################################################
lowlevel.o:	base.c
	$(CC) $(CFLAGS) -c base.c -o lowlevel.o -DLIBRARY_NAME=\"lowlevel.library\" \
	  -DLIBRARY_BASE=LowLevelBase -DLIBRARY_VERS=__auto_lowlevel_vers
lowlevel_vers.o:	vers.c
	$(CC) $(CFLAGS) -c vers.c -o lowlevel_vers.o -DLIBRARY_VERS=__auto_lowlevel_vers
##############################################################################
realtime.o:	base.c
	$(CC) $(CFLAGS) -c base.c -o realtime.o -DLIBRARY_NAME=\"realtime.library\" \
	  -DLIBRARY_BASE=RealTimeBase -DLIBRARY_VERS=__auto_realtime_vers
realtime_vers.o:	vers.c
	$(CC) $(CFLAGS) -c vers.c -o realtime_vers.o -DLIBRARY_VERS=__auto_realtime_vers
##############################################################################
datatypes.o:	base.c
	$(CC) $(CFLAGS) -c base.c -o datatypes.o -DLIBRARY_NAME=\"datatypes.library\" \
	  -DLIBRARY_BASE=DataTypesBase -DLIBRARY_VERS=__auto_datatypes_vers
datatypes_vers.o:	vers.c
	$(CC) $(CFLAGS) -c vers.c -o datatypes_vers.o -DLIBRARY_VERS=__auto_datatypes_vers
##############################################################################
nv.o:		base.c
	$(CC) $(CFLAGS) -c base.c -o nv.o -DLIBRARY_NAME=\"nonvolatile.library\" \
	  -DLIBRARY_BASE=NVBase -DLIBRARY_VERS=__auto_nv_vers
nv_vers.o:	vers.c
	$(CC) $(CFLAGS) -c vers.c -o nv_vers.o -DLIBRARY_VERS=__auto_nv_vers
##############################################################################
