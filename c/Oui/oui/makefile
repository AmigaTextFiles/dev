

I = include
IG =include/gadgets

OBJS =  $(O)new.o $(O)screen.o $(O)gadgetlist.o $(O)gadget.o $(O)rectangle.o\
        $(O)slist.o $(O)button.o $(O)radio.o $(O)listview.o $(O)eprop.o $(O)string.o $(O)number.o\
        $(O)cnumber.o $(O)cstring.o $(O)cycle.o $(O)slider.o $(O)scroller.o $(O)palette.o\
        $(O)imgbut.o $(O)eslide.o $(O)checkbox.o $(O)eroll.o $(O)fbutton.o


.cc.o:
    sc CPU=$(CPU) MATH=$(MATH) ObjName=$(O) $<
.c.o:
    sc $<
.h.h:
    @setdate $@

$(OUILIB): $(OBJS) $(O)locale.o $(O)locale2.o $(O)window.o $(O)window2.o
    Join $(OBJS) $(O)locale.o $(O)window.o AS $(OUILIB)
    Join $(OBJS) $(O)locale2.o $(O)window2.o AS $(OUILOCALISELIB)
    Copy $(OUILIB) TO ULib:
    Copy $(OUILOCALISELIB) TO ULib:


$(O)eprop.o: eprop.cc $(IG)/eprop.h $(IG)/eclass.h $(I)/gadgetlist.h \
         $(I)/screen.h $(I)/window.h

$(O)gadgetlist.o: gadgetlist.cc $(I)/screen.h $(I)/window.h $(I)/gadgetlist.h \
          $(IG)/gadget.h

$(O)window.o: window.cc $(I)/screen.h $(I)/window.h $(I)/gadgetlist.h \
          $(IG)/gadget.h $(IG)/string.h $(IG)/fbutton.h $(I)/locale.h

$(O)window2.o: window.cc $(I)/screen.h $(I)/window.h $(I)/gadgetlist.h \
          $(IG)/gadget.h $(IG)/string.h $(IG)/fbutton.h $(I)/locale.h
    sc window.cc CPU=$(CPU) MATH=$(MATH) DEFINE LOCALISE ObjectName=$(O)window2.o


$(O)eslide.o: eslide.cc $(IG)/eslide.h $(I)/gadgetlist.h $(I)/window.h \
          $(I)/screen.h $(IG)/eclass.h $(IG)/gadget.h

$(O)cnumber.o: cnumber.cc $(I)/screen.h $(I)/window.h $(IG)/cnumber.h \
           $(IG)/eclass.h $(I)/gadgetlist.h $(IG)/gadget.h

$(O)cstring.o: cstring.cc $(I)/screen.h $(I)/window.h $(IG)/cstring.h $(IG)/eclass.h \
           $(I)/gadgetlist.h $(IG)/gadget.h

$(O)filesel.o: filesel.cc $(I)/filesel.h

$(O)listview.o: listview.cc $(IG)/listview.h $(I)/gadgetlist.h $(I)/slist.h \
            $(IG)/gadget.h

$(O)button.o: button.cc $(IG)/button.h $(I)/gadgetlist.h $(IG)/gadget.h

$(O)checkbox.o: checkbox.cc $(IG)/checkbox.h $(I)/gadgetlist.h $(IG)/gadget.h

$(O)cycle.o: cycle.cc $(IG)/cycle.h $(I)/gadgetlist.h $(IG)/gadget.h

$(O)eroll.o: eroll.cc $(IG)/eroll.h $(IG)/eclass.h $(I)/gadgetlist.h $(I)/window.h \
         $(I)/screen.h $(IG)/gadget.h

$(O)fbutton.o: fbutton.cc $(IG)/fbutton.h $(IG)/eclass.h $(I)/gadgetlist.h \
            $(IG)/gadget.h

$(O)gadget.o: gadget.cc $(IG)/gadget.h $(I)/gadgetlist.h

$(O)imgbut.o: imgbut.cc $(IG)/imgbut.h $(I)/gadgetlist.h $(I)/renderim.h \
            $(IG)/gadget.h

$(O)locale2.o: locale.cc $(I)/locale.h
    sc locale.cc CPU=$(CPU) MATH=$(MATH) ObjName=$(O)locale2.o DEFINE LOCALISE

$(O)locale.o: locale.cc $(I)/locale.h
    sc locale.cc CPU=$(CPU) MATH=$(MATH) ObjName=$(O)

$(O)new.o: new.cc

$(O)number.o: number.cc $(IG)/number.h $(I)/gadgetlist.h $(I)/window.h \
            $(I)/screen.h $(IG)/gadget.h

$(O)palette.o: palette.cc $(IG)/palette.h $(I)/gadgetlist.h $(IG)/gadget.h

$(O)radio.o: radio.cc $(IG)/radio.h $(I)/gadgetlist.h $(IG)/gadget.h

$(O)rectangle.o: rectangle.cc $(I)/rectangle.h

$(O)screen.o: screen.cc $(I)/screen.h

$(O)scroller.o: scroller.cc $(IG)/scroller.h $(I)/gadgetlist.h $(IG)/gadget.h

$(O)slider.o: slider.cc $(IG)/slider.h $(I)/gadgetlist.h $(IG)/gadget.h

$(O)slist.o: slist.cc $(I)/slist.h

$(O)string.o: string.cc $(IG)/string.h $(I)/gadgetlist.h $(I)/window.h \
            $(I)/screen.h $(IG)/gadget.h
