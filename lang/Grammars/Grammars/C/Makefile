SRC     = gram.c scan.c main.c

C       : $(SRC)
        -delete C
        lc -L -b0 -cw $(SRC)
        mv gram C

scan.c  : gram.tab.h scan.l
        -delete scan.c
        flex scan.l
        mv lex.yy.c scan.c

gram.c gram.tab.h  : gram.y
        -delete gram.c
        bison -dv gram.y
        mv gram.tab.c gram.c

clean   :
        rm -f a.out y.tab.h y.output *.o
