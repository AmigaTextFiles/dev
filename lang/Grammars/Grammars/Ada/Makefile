Ada: ada_tab.c yy.lex.c main.h
    lc -cw -b0 -L ada_tab.c
    copy ada_tab Ada
    delete ada_tab

ada_tab.c: ada.y
    bison ada.y
    copy ada.tab.c ada_tab.c
    delete ada.tab.c

yy.lex.c: ada.l
    flex ada.l

clean:
    delete lex.yy.c ada_tab.c ada_tab.lnk ada_tab.map ada_tab.o

test:
    Ada < dump_routines_body.a

