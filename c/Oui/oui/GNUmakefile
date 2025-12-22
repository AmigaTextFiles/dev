O = GNU/mc68000/
I = include
IG =include/gadgets
CXX = g++
CXXFLAGS = -c -s
CPPFLAGS = -I include
OBJS = $(O)new.o $(O)screen.o $(O)gadgetlist.o $(O)gadget.o $(O)rectangle.o\
	   $(O)slist.o $(O)button.o $(O)radio.o $(O)listview.o $(O)eprop.o\
	   $(O)string.o $(O)number.o $(O)cnumber.o $(O)cstring.o $(O)cycle.o\
	   $(O)slider.o $(O)scroller.o $(O)palette.o $(O)imgbut.o $(O)eslide.o\
	   $(O)checkbox.o $(O)eroll.o $(O)fbutton.o

all: liboui.a

liboui.a: $(OBJS) $(O)locale.o $(O)window.o
	-rm $@
	ar -q /tmp/$@ $(OBJS) $(O)locale.o $(O)window.o
	ranlib /tmp/$@
	echo "\$$$(V)" >>/tmp/$@
	cp /tmp/$@ .
	rm /tmp/$@
	cp $@ GNU:lib


liboui_localise.a: $(OBJS) $(O)locale2.o $(O)window2.o
	-rm $@
	ar -q /tmp/$@ $(OBJS) $(O)locale2.o $(O)window2.o
	ranlib /tmp/$@
	echo "\$$$(V)" >>/tmp/$@
	cp /tmp/$@ .
	rm /tmp/$@
	cp $@ GNU:lib

$(O)new.o: new.cc
	$(CXX) $(CXXFLAGS) $(CPPFLAGS) -o $@ $<

$(O)screen.o: screen.cc $(I)/screen.h
	$(CXX) $(CXXFLAGS) $(CPPFLAGS) -o $@ $<

$(O)gadgetlist.o: gadgetlist.cc $(I)/screen.h $(I)/window.h $(I)/gadgetlist.h \
	$(IG)/gadget.h
	$(CXX) $(CXXFLAGS) $(CPPFLAGS) -o $@ $<

$(O)gadget.o: gadget.cc $(IG)/gadget.h $(I)/gadgetlist.h
	$(CXX) $(CXXFLAGS) $(CPPFLAGS) -o $@ $<

$(O)rectangle.o: rectangle.cc $(I)/rectangle.h
	$(CXX) $(CXXFLAGS) $(CPPFLAGS) -o $@ $<

$(O)slist.o: slist.cc $(I)/slist.h
	$(CXX) $(CXXFLAGS) $(CPPFLAGS) -o $@ $<

$(O)button.o: button.cc $(IG)/button.h $(I)/gadgetlist.h
	$(CXX) $(CXXFLAGS) $(CPPFLAGS) -o $@ $<

$(O)radio.o: radio.cc $(IG)/radio.h $(I)/gadgetlist.h
	$(CXX) $(CXXFLAGS) $(CPPFLAGS) -o $@ $<

$(O)listview.o: listview.cc $(IG)/listview.h $(I)/gadgetlist.h $(I)/slist.h
	$(CXX) $(CXXFLAGS) $(CPPFLAGS) -o $@ $<

$(O)eprop.o: eprop.cc $(IG)/eprop.h $(IG)/eclass.h $(I)/gadgetlist.h \
		  $(I)/screen.h $(I)/window.h
	$(CXX) $(CXXFLAGS) $(CPPFLAGS) -o $@ $<

$(O)string.o: string.cc $(IG)/string.h $(I)/gadgetlist.h $(I)/window.h $(I)/screen.h
	$(CXX) $(CXXFLAGS) $(CPPFLAGS) -o $@ $<

$(O)number.o: number.cc $(IG)/number.h $(I)/gadgetlist.h $(I)/window.h $(I)/screen.h
	$(CXX) $(CXXFLAGS) $(CPPFLAGS) -o $@ $<

$(O)cnumber.o: cnumber.cc $(I)/screen.h $(I)/window.h $(IG)/cnumber.h \
		   $(IG)/eclass.h $(I)/gadgetlist.h
	$(CXX) $(CXXFLAGS) $(CPPFLAGS) -o $@ $<

$(O)cstring.o: cstring.cc $(I)/screen.h $(I)/window.h $(IG)/cstring.h $(IG)/eclass.h \
			$(I)/gadgetlist.h
	$(CXX) $(CXXFLAGS) $(CPPFLAGS) -o $@ $<

$(O)cycle.o: cycle.cc $(IG)/cycle.h $(I)/gadgetlist.h
	$(CXX) $(CXXFLAGS) $(CPPFLAGS) -o $@ $<

$(O)slider.o: slider.cc $(IG)/slider.h $(I)/gadgetlist.h
	$(CXX) $(CXXFLAGS) $(CPPFLAGS) -o $@ $<

$(O)scroller.o: scroller.cc $(IG)/scroller.h $(I)/gadgetlist.h
	$(CXX) $(CXXFLAGS) $(CPPFLAGS) -o $@ $<

$(O)palette.o: palette.cc $(IG)/palette.h $(I)/gadgetlist.h
	$(CXX) $(CXXFLAGS) $(CPPFLAGS) -o $@ $<

$(O)imgbut.o: imgbut.cc $(IG)/imgbut.h $(I)/gadgetlist.h $(I)/renderim.h
	$(CXX) $(CXXFLAGS) $(CPPFLAGS) -o $@ $<

$(O)eslide.o: eslide.cc $(IG)/eslide.h $(I)/gadgetlist.h $(I)/window.h \
		   $(I)/screen.h $(IG)/eclass.h
	$(CXX) $(CXXFLAGS) $(CPPFLAGS) -o $@ $<

$(O)checkbox.o: checkbox.cc $(IG)/checkbox.h $(I)/gadgetlist.h
	$(CXX) $(CXXFLAGS) $(CPPFLAGS) -o $@ $<

$(O)eroll.o: eroll.cc $(IG)/eroll.h $(IG)/eclass.h $(I)/gadgetlist.h $(I)/window.h \
		 $(I)/screen.h
	$(CXX) $(CXXFLAGS) $(CPPFLAGS) -o $@ $<

$(O)fbutton.o: fbutton.cc $(IG)/fbutton.h $(IG)/eclass.h $(I)/gadgetlist.h
	$(CXX) $(CXXFLAGS) $(CPPFLAGS) -o $@ $<

$(O)locale2.o: locale.cc $(I)/locale.h
	$(CXX) $(CXXFLAGS) $(CPPFLAGS) -D LOCALISE -o $@ $<

$(O)locale.o: locale.cc $(I)/locale.h
	$(CXX) $(CXXFLAGS) $(CPPFLAGS) -o $@ $<

$(O)window.o: window.cc $(I)/screen.h $(I)/window.h $(I)/gadgetlist.h \
		   $(IG)/gadget.h $(IG)/string.h $(IG)/fbutton.h $(I)/locale.h
	$(CXX) $(CXXFLAGS) $(CPPFLAGS) -o $@ $<

$(O)window2.o: window.cc $(I)/screen.h $(I)/window.h $(I)/gadgetlist.h \
		   $(IG)/gadget.h $(IG)/string.h $(IG)/fbutton.h $(I)/locale.h
	$(CXX) $(CXXFLAGS) $(CPPFLAGS) -D LOCALISE -o $@ $<

# OBJS =  new.o screen.o gadgetlist.o gadget.o rectangle.o\
#		  slist.o button.o radio.o listview.o eprop.o string.o number.o\
#		  cnumber.o cstring.o cycle.o slider.o scroller.o palette.o\
#		  imgbut.o eslide.o checkbox.o eroll.o fbutton.o
#
#
# .cc.o:
#	  sc $< srcis=$>.cc
# .c.o:
#	  sc $<
# .h.h:
#	  @setdate $@
#
# oui.lib: $(OBJS) locale.o locale2.o window.o window2.o
#	  Join $(OBJS) locale.o window.o AS oui.lib
#	  Join $(OBJS) locale2.o window2.o AS oui_localise.lib
#	  Copy oui.lib TO ULib:
#	  Copy oui_localise.lib TO ULib:
#
#
#
##
#
#
# filesel.o: filesel.cc $(I)/filesel.h
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
