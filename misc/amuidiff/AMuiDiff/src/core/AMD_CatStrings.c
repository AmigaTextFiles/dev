/****************************************************************
   This file was created automatically by `FlexCat 2.6'
   from "AMD_CatStrings.cd".

   Do NOT edit by hand!
****************************************************************/

/****************************************************************
    This file uses the auto initialization possibilities of
    Dice, gcc and SAS/C, respectively.

    Dice does this by using the keywords __autoinit and
    __autoexit, SAS uses names beginning with _STI or
    _STD, respectively. gcc uses the asm() instruction,
    to emulate C++ constructors and destructors.

    Using this file you don't have *all* possibilities of
    the locale.library. (No Locale or Language arguments are
    supported when opening the catalog. However, these are
    *very* rarely used, so this should be sufficient for most
    applications.
****************************************************************/


/*
    Include files and compiler specific stuff
*/
#include <exec/memory.h>
#include <libraries/locale.h>
#include <libraries/iffparse.h>

#include <proto/exec.h>
#include <proto/dos.h>
#include <proto/locale.h>
#include <proto/utility.h>
#include <proto/iffparse.h>

#include <stdlib.h>
#include <string.h>



#include "AMD_CatStrings.h"


/*
    Variables
*/
struct FC_String AMD_CatStrings_Strings[CAT_NB_ENTRIES] = {
	{ (STRPTR) "MUI Diff Tool for Amiga-like system", 0 },                                                       //Diff graphique sous MUI pour Amiga-like
	{ (STRPTR) "Differencies", 1 },                                                       //Différences
	{ (STRPTR) "File", 2 },                                                       //Fichier
	{ (STRPTR) "\33c0 Differences", 3 },                                                       //\033c0 Différences
	{ (STRPTR) "differences", 4 },                                                       //différences
	{ (STRPTR) "difference", 5 },                                                       //différence
	{ (STRPTR) "\33c\33p[6]Added lines", 6 },                                                       //\033c\033p[6]Lignes ajoutées
	{ (STRPTR) "\33c\33p[7]Removed lines", 7 },                                                       //\033c\033p[7]Lignes effacees
	{ (STRPTR) "\33c\33p[2]Changed lines", 8 },                                                       //\033c\033p[2]Lignes modifiées
	{ (STRPTR) "Project", 9 },                                                       //Projet
	{ (STRPTR) "Open File 1", 10 },                                                      //Ouvrir Fichier 1
	{ (STRPTR) "Open File 2", 11 },                                                      //Ouvrir Fichier 2
	{ (STRPTR) "About...", 12 },                                                      //A Propos...
	{ (STRPTR) "Exit", 13 },                                                      //Quitter
	{ (STRPTR) "Diff !", 14 },                                                      //Diff !
	{ (STRPTR) "AMuiDiff : About...", 15 },                                                      //AMuiDiff : A propos
	{ (STRPTR) "This application uses the following tools :", 16 },                                                      //Cette application utilise les outils suivants :
	{ (STRPTR) "Add : line", 17 },                                                      //Ajout : ligne
	{ (STRPTR) "Change : line", 18 },                                                      //Modification : ligne
	{ (STRPTR) "Remove : line", 19 },                                                      //Suppression : ligne
	{ (STRPTR) "An error occured when comparing files... :(", 20 },                                                      //Erreur à la comparaison des fichiers... :(
	{ (STRPTR) "Author", 21 },                                                      //Auteur
	{ (STRPTR) "Version", 22 },                                                      //Version
	{ (STRPTR) "Compilation Date", 23 },                                                      //Date de compilation
	{ (STRPTR) "State : A file need to be opened", 24 },                                                      //Etat : Ouvrir un fichier
	{ (STRPTR) "Select a file to compare", 25 },                                                      //Choisir un fichier à comparer
	{ (STRPTR) "\0338A \"diff\" command in your \"PATH\" !!", 26 },                                                       //\0338Une commande \"diff\" accessible dans \"PATH\"

	{ (STRPTR) "Open", 27 },
	{ (STRPTR) "Edit", 28 },
	{ (STRPTR) "Save", 29 },
	{ (STRPTR) "Reload", 30 },

	{ (STRPTR) "Reload File 1", 31 },
	{ (STRPTR) "Reload File 2", 32 },
	{ (STRPTR) "Edit File 1", 33 },
	{ (STRPTR) "Edit File 2", 34 }
};

STATIC struct Catalog *AMD_CatStringsCatalog = NULL;
STATIC STRPTR AMD_CatStringsStrings = NULL;
STATIC ULONG AMD_CatStringsStringsSize;


VOID CloseAMD_CatStringsCatalog(VOID)

{
    if (AMD_CatStringsCatalog) {
	CloseCatalog(AMD_CatStringsCatalog);
    }
    if (AMD_CatStringsStrings) {
	FreeMem(AMD_CatStringsStrings, AMD_CatStringsStringsSize);
    }
}


VOID OpenAMD_CatStringsCatalog(VOID)

{
	if (LocaleBase) {
	if ((AMD_CatStringsCatalog = OpenCatalog(NULL, (STRPTR) "amuidiff.catalog",
					 OC_BuiltInLanguage, "english",
				     OC_Version, 0,
				     TAG_DONE))) {
	    struct FC_String *fc;
	    int i;

		for (i = 0, fc = AMD_CatStrings_Strings;  i < CAT_NB_ENTRIES;  i++, fc++) {
		 fc->msg = GetCatalogStr(AMD_CatStringsCatalog, fc->id, (STRPTR) fc->msg);
	    }
	}
    }
}
    
