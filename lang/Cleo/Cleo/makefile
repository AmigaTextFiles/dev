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

    OBJ = $(PROJET)/obj
    SRC = $(PROJET)/source
    INC = $(PROJET)/include

    FLG = -fa -bs -wn -qv -mcd

all:    $(PROJET)/bin/cleo

$(OBJ)/io.o: $(SRC)/io.c
    cc $(SRC)/io.c $(FLG) -o $(OBJ)/io.o

$(OBJ)/libs.o: $(SRC)/libs.c
    cc $(SRC)/libs.c $(FLG) -o $(OBJ)/libs.o

$(OBJ)/paslib.o: $(SRC)/paslib.c
    cc $(SRC)/paslib.c $(FLG) -o $(OBJ)/paslib.o

$(OBJ)/vars.o: $(SRC)/vars.c
    cc $(SRC)/vars.c $(FLG) -o $(OBJ)/vars.o

$(OBJ)/lexfct.o: $(SRC)/lexfct.c
    cc $(SRC)/lexfct.c $(FLG) -o $(OBJ)/lexfct.o

$(OBJ)/fct.o: $(SRC)/fct.c
    cc $(SRC)/fct.c $(FLG) -o $(OBJ)/fct.o

$(OBJ)/math.o: $(SRC)/math.c
    cc $(SRC)/math.c $(FLG) -o $(OBJ)/math.o

$(OBJ)/convert.o: $(SRC)/convert.c
    cc $(SRC)/convert.c $(FLG) -o $(OBJ)/convert.o

$(OBJ)/syntax.o: $(SRC)/syntax.c
    cc $(SRC)/syntax.c $(FLG) -o $(OBJ)/syntax.o

$(OBJ)/function.o: $(SRC)/function.c
    cc $(SRC)/function.c $(FLG) -o $(OBJ)/function.o

$(OBJ)/cleo.o: $(SRC)/cleo.c $(INC)/cleobis.h $(INC)/globals.h
    cc $(SRC)/cleo.c $(FLG) -o $(OBJ)/cleo.o

$(PROJET)/bin/cleo:    $(OBJ)/paslib.o $(OBJ)/vars.o $(OBJ)/lexfct.o $(OBJ)/syntax.o $(OBJ)/math.o $(OBJ)/io.o $(OBJ)/fct.o $(OBJ)/cleo.o  $(OBJ)/convert.o $(OBJ)/function.o $(OBJ)/libs.o $(INC)/cleobis.h $(INC)/globals.h
    ln  $(OBJ)/paslib.o $(OBJ)/vars.o $(OBJ)/lexfct.o $(OBJ)/io.o $(OBJ)/math.o $(OBJ)/syntax.o $(OBJ)/fct.o $(OBJ)/cleo.o $(OBJ)/convert.o $(OBJ)/function.o $(OBJ)/libs.o -lma -g -lc -o $(PROJET)/bin/cleo
