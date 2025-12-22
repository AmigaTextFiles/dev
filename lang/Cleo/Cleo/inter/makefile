#/***************************************************************************
#*   Ce fichier, ainsi que tous les  modules  l'accompagnant, peut et  doit *
#* etre  copié et  distribué  GRATUITEMENT à la seule condition expresse de *
#* conserver  l'INTEGRALITE  du  Code Source, de  la documentation, et  des *
#* fichiers annexes du package.                                             *
#*                                                                          *
#* Toute modification est INTERDITE sans l'autorisation écrite de l'auteur. *
#*            Tous droits réservés à M. DIALLO Barrou, Juillet 1992.        *
#***************************************************************************/


#                           AZTEC 5.01 Amiga makefile

    PROJET = dh0:cleobis

    PARENT = $(PROJET)/inter
    OBJ = $(PARENT)/obj
    SRC = $(PARENT)/source
    INC = $(PARENT)/include

    FLG = -fa -bs -wn -qv -mcd

all:    $(PROJET)/bin/inter

$(OBJ)/inter.o: $(SRC)/inter.c $(INC)/glob.h $(INC)/inter.h
    cc $(SRC)/inter.c $(FLG) -o $(OBJ)/inter.o

$(OBJ)/exec.o: $(SRC)/exec.c
    cc $(SRC)/exec.c $(FLG) -o $(OBJ)/exec.o

$(OBJ)/alloc.o: $(SRC)/alloc.c
    cc $(SRC)/alloc.c $(FLG) -o $(OBJ)/alloc.o

$(OBJ)/dis.o: $(SRC)/dis.c
    cc $(SRC)/dis.c $(FLG) -o $(OBJ)/dis.o

$(OBJ)/stack.o: $(SRC)/stack.c
    cc $(SRC)/stack.c $(FLG) -o $(OBJ)/stack.o

$(PROJET)/bin/inter: $(OBJ)/stack.o $(OBJ)/dis.o $(OBJ)/inter.o $(OBJ)/exec.o $(OBJ)/alloc.o $(INC)/glob.h $(INC)/inter.h
    ln  $(OBJ)/stack.o $(OBJ)/dis.o $(OBJ)/alloc.o $(OBJ)/inter.o $(OBJ)/exec.o -lma -g -lc -o $(PROJET)/bin/inter
