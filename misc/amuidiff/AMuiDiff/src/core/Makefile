#############################################################################
#      Projet                    :
#      Fichier                   :  $RCSfile: Makefile,v $
#
#      Nom Prog                  :
#      Version                   :  $Revision: 1.24 $
#      Date de conception        :  1er Novembre 2002
#      Dernière modification     :  $Date: 2004/03/13 12:19:45 $
#
#      Description               :  Makefile du projet AMuiDiff
#
#      Auteurs                   :  Stephane SARAGAGLIA
#
#      Plateforme                :  A1200 Mc68060/PPC603e
#      Systeme                   :  AmigaOS 3.5
#
#      Programming language      :  C/C++
#
#          Copyright (C) Stephane SARAGAGLIA - (All rights reserved)
#
#############################################################################

#############################################################################
# MACROs
#############################################################################


INCLUDES = -I/gg/os-include.extensions -I../libs/SSCToolLib -I../libs/SSAmigaToolLib
LIBS_MOS = -lm
LIBS_AOS = -lm -lamiga #-ldebug -lmui

MAIN_SRC = AMD_Main.cpp
SRC = AMD_Gui.cpp
C_SRC = AMD_CHooks.c AMD_DiffCmdWrapping.c ss_lib_tools.c ss_amiga_lib_tools.c ../libs/SSCToolLib/SSIoLib.c ../libs/SSCToolLib/SSListLib.c \
		../libs/SSCToolLib/SSStrLib.c ../libs/SSCToolLib/SSDateLib.c ../libs/SSAmigaToolLib/SSProcLib.c AMD_CatStrings.c
OBJS = $(SRC:.cpp=.o)
C_OBJS = $(C_SRC:.c=.o)
MAIN_OBJ = $(MAIN_SRC:.cpp=.o)
EXEC_MOS = AMuiDiff.mos
EXEC_AOS = AMuiDiff.aos

CC = gcc
CFLAGS_DEBUG = -Wall #-g -DDEBUG

CFLAGS_CORE = $(INCLUDES) -noixemul -DAMIGAOSLIKE $(CFLAGS_DEBUG) -O2
CFLAGS_MOS = $(CFLAGS_CORE) #-D_NO_PPCINLINE -D_NO_INLINE
CPPFLAGS_MOS = $(CFLAGS_CORE) #-D_NO_PPCINLINE -D_NO_INLINE
CFLAGS_AOS = $(CFLAGS_CORE)# -mstackcheck
CPPFLAGS_AOS = $(CFLAGS_CORE)# -mstackcheck

#############################################################################
# RULEs
#############################################################################
default : morphos   # The default rule

morphos :
	make exec EXEC="$(EXEC_MOS)" CFLAGS="$(CFLAGS_MOS)" CPPFLAGS="$(CPPFLAGS_MOS)" LIBS="$(LIBS_MOS)"
	@exit 0

amigaos :
	make exec EXEC="$(EXEC_AOS)" CFLAGS="$(CFLAGS_AOS)" CPPFLAGS="$(CPPFLAGS_AOS)" LIBS="$(LIBS_AOS)"
	@exit 0

exec : $(MAIN_OBJ) libmuidiff.a
	$(CC) $(CFLAGS) $(MAIN_OBJ)  -L. -lmuidiff $(LIBS) -o $(EXEC).unstripped
	strip --strip-unneeded --remove-section .comment $(EXEC).unstripped -o $(EXEC)
	protect $(EXEC) +E

dump :
	objdump --section-headers --all-headers --reloc --syms --disassemble-all $(EXEC_MOS).unstripped > $(EXEC_MOS).unstripped.dump

libmuidiff.a : $(OBJS) $(C_OBJS)
	ar cru libmuidiff.a $(OBJS) $(C_OBJS)
	ranlib libmuidiff.a

clean :
	echo $(OBJS) $(C_OBJS) $(MAIN_OBJ) $(EXEC) libmuidiff.a
	@rm	$(OBJS) $(C_OBJS) $(MAIN_OBJ) $(EXEC) libmuidiff.a

all : force
force :
	make clean
	make

install :
	copy AMuiDiff.mos c:AMuiDiff
	copy //catalogs/français/amuidiff.catalog LOCALE:catalogs/français/

catalogs :
	FlexCat AMD_CatStrings.cd //catalogs/français/amuidiff.ct CATALOG //catalogs/français/amuidiff.catalog

