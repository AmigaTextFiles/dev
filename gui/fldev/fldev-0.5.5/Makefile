# Standard defines:

CC	=	g++
LD	=	g++
CCOMP	=	gcc
oDir	=	
Bin	=	
libDirs	=	-L/SDK/Local/clib2/lib/
incDirs	=	-I/SDK/Include/include_h/
LD_FLAGS	=	
LIBS	=	-lfltk_images -lm -lfltk_forms -lfltk -lpng -lz -ljpeg -lauto -lnet -lunix
C_FLAGS	=	-O2
SRCS	=	editor.cpp pref_form.cpp proj_form.cpp proj_wiz_form.cpp extras.cpp My_Text_Display.cpp My_Text_Editor.cpp strsep.c strtok_r.c
EXOBJS	=	$(oDir)editor.o $(oDir)pref_form.o $(oDir)proj_form.o $(oDir)proj_wiz_form.o $(oDir)extras.o $(oDir)My_Text_Display.o $(oDir)My_Text_Editor.o $(oDir)strsep.o $(oDir)strtok_r.o 
ALLOBJS	=	$(EXOBJS)
ALLBIN	=	$(Bin)fldev
ALLTGT	=	$(Bin)fldev

#@# Targets follow ---------------------------------
all:	$(ALLTGT)
objs:	$(ALLOBJS)
cleanobjs:
	delete all $(ALLOBJS)
cleanbin:
	delete all $(ALLBIN)
clean:	cleanobjs cleanbin
cleanall:	cleanobjs cleanbin

#@# Dependency rules follow -----------------------------
$(Bin)fldev: $(EXOBJS)
	$(LD) -o $(Bin)fldev $(EXOBJS) $(incDirs) $(libDirs) $(LD_FLAGS) $(LIBS)

$(oDir)editor.o: editor.cpp pref_form.h proj_form.h proj_wiz_form.h extras.h fldevicon.xpm icon_pixmaps.h My_Text_Display.h My_Text_Editor.h
	$(CC) $(C_FLAGS) $(incDirs) -c -o $@ $<

$(oDir)pref_form.o: pref_form.cpp pref_form.h proj_form.h proj_wiz_form.h extras.h fldevicon.xpm icon_pixmaps.h My_Text_Display.h My_Text_Editor.h
	$(CC) $(C_FLAGS) $(incDirs) -c -o $@ $<

$(oDir)proj_form.o: proj_form.cpp pref_form.h proj_form.h proj_wiz_form.h extras.h fldevicon.xpm icon_pixmaps.h My_Text_Display.h My_Text_Editor.h
	$(CC) $(C_FLAGS) $(incDirs) -c -o $@ $<

$(oDir)proj_wiz_form.o: proj_wiz_form.cpp pref_form.h proj_form.h proj_wiz_form.h extras.h fldevicon.xpm icon_pixmaps.h My_Text_Display.h My_Text_Editor.h
	$(CC) $(C_FLAGS) $(incDirs) -c -o $@ $<

$(oDir)extras.o: extras.cpp pref_form.h proj_form.h proj_wiz_form.h extras.h fldevicon.xpm icon_pixmaps.h My_Text_Display.h My_Text_Editor.h
	$(CC) $(C_FLAGS) $(incDirs) -c -o $@ $<

$(oDir)My_Text_Display.o: My_Text_Display.cpp pref_form.h proj_form.h proj_wiz_form.h extras.h fldevicon.xpm icon_pixmaps.h My_Text_Display.h My_Text_Editor.h
	$(CC) $(C_FLAGS) $(incDirs) -c -o $@ $<

$(oDir)My_Text_Editor.o: My_Text_Editor.cpp pref_form.h proj_form.h proj_wiz_form.h extras.h fldevicon.xpm icon_pixmaps.h My_Text_Display.h My_Text_Editor.h
	$(CC) $(C_FLAGS) $(incDirs) -c -o $@ $<

$(oDir)strsep.o: strsep.c pref_form.h proj_form.h proj_wiz_form.h extras.h fldevicon.xpm icon_pixmaps.h My_Text_Display.h My_Text_Editor.h
	$(CC) $(C_FLAGS) $(incDirs) -c -o $@ $<

$(oDir)strtok_r.o: strtok_r.c pref_form.h proj_form.h proj_wiz_form.h extras.h fldevicon.xpm icon_pixmaps.h My_Text_Display.h My_Text_Editor.h
	$(CC) $(C_FLAGS) $(incDirs) -c -o $@ $<
