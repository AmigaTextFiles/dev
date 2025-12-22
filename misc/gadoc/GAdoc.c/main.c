
/****h* gadoc.c/TheNameOfTheGame ***
*
*  NAME
*    gadoc
*
*  COPYRIGHT
*    Gerhard Leibrock
*    This software is subject to the ``Standard Amiga FD-Software Copyright Note''
*    It is Cardware as defined in paragraph 4.c.
*    If you like it and use it regularly please send a postcard to the
*    author. For more information please read ``AFD-COPYRIGHT''
*    (Version 1 or higher).
*
*  FUNCTION
*    This program will be of great use for any programmer, since it
*    makes it possible to extract the so called autodocs from source
*    codes and generates a texinfo file out of them.
*    (The autodoc format is explained in detail in the manual.)
*
*  AUTHOR
*    Gerhard Leibrock
*    Neuhäuselerstr. 12       InterNET:
*    66459 Kirkel                      leibrock@@fsinfo.cs.uni-sb.de
*    T.: 06849/6134                    fach5@@cipsol.cs.uni-sb.de   
*    Germany
*
*  VERSION
*    1.2 (27-March-1995)
*
*  NOTES
*    Started 10-Feb-1995
*    Read the english manual.
*
***/

/* Deutscher Header // German Header */

/*DE*h* gadoc.c/UmWasGehtsHier ***
*
*  NAME
*    gadoc
*
*  COPYRIGHT
*    Gerhard Leibrock
*    Diese Software unterliegt der "Standard Amiga FD-Software Copyright Note"
*    Sie ist Cardware, wie definiert in Absatz 4c. Falls du sie magst und
*    regelmäßig benutzt, sende bitte eine Postkarte an den Autor. Für mehr
*    Informationen lies bitte "AFD-COPYRIGHT" (Version 1 oder höher).
*
*  FUNCTION
*    Dieses Programm ist eine riesige Hilfe für alle Programmierer, die mit
*    der Dokumentation zu Ihren Produkten auf dem Kriegsfuß stehen.
*    GAdoc unterstützt Autdocs (Siehe englisches Handbuch), die direkt in
*    den Quellcode eingefügt werden. Somit haben Sie doppelten Nutzen:
*    Sie können diese Dokumentation während Ihrer Arbeit am Bildschirm
*    lesen und verändern oder Sie mittels gadoc in eine texinfo Datei
*    umwandeln und dann weiterverarbeiten.
*
*  AUTHOR
*    Gerhard Leibrock
*    Neuhäuselerstr. 12       InterNET:
*    66459 Kirkel                      leibrock@@fsinfo.cs.uni-sb.de
*    T.: 06849/6134                    fach5@@cipsol.cs.uni-sb.de   
*    Deutschland
*
*  VERSION
*    1.2 (27-März-1995)
*
*  NOTES
*    Angefangen 10-Feb-1995
*    Lesen Sie unbedingt das (englische) Handbuch.
*
***/

char *VER = "$VER: GAdoc 1.2 (c) Gerhard Leibrock (27.03.95)";


#include <stdio.h>
#include <string.h>
#include <stdlib.h>
#include <time.h>

/* Include the information for creating an amiga icon */
#include "IconData.h"

typedef enum{FALSE, TRUE} BOOL;


/****i* gadoc.c/WriteTexinfo() ********
*
*  NAME
*    WriteTexinfo -- Write the header of the generated output file
*
*  SYNOPSIS
*    WriteTexinfo(fptr, filename, author, project, version, copyright,
*                  amiga_support)
*
*    void WriteTexinfo
*       (FILE *fptr, char *filename, char *author,
*       char *project, char *version, char *copyright, BOOL amiga_support)
*
*  FUNCTION
*    This function writes the header for the .menu file, in which the
*    titlepage gets specified and some layout flags like dina4 paper.
*
*  INPUTS
*    fptr          - Pointer to the output file
*    filename      - name of the hypertext file, that could be generated
*    author        - Name ot the programs author (specified in *h* section)
*    project       - Name of the project this file belongs to
*    version       - Version
*    copyright     - Who holds the copyright?
*    amiga_support - Include the line \\input amigatexinfo?
*
*  RESULT
*    None
*
*  EXAMPLE
*    FILE *out;
*    char *filename, author, project, version, copyright;
*    BOOL amiga_support;
*
*    ...
*
*    WriteTexinfo(fptr, filename, author, project, version, copyright,
*                  amiga_support);
*
*  NOTES
*
*  BUGS
*    None
*
*  SEE ALSO
*    
***/

void WriteTexinfo
	(FILE *fptr, char *filename, char *author,
	 char *project, char *version, char *copyright, BOOL amiga_support)
{
  /* To obtain the system-time -> Included as the date of extraction */
  time_t t;

  /* To eliminate path-symbols like `:' or `/'; */
  int i;

  time(&t);


  for(i=strlen(filename)-1; i>=0; i--)
    if(filename[i] == ':' || filename[i]=='/') break;

  if(amiga_support) fputs("\\input amigatexinfo\n", fptr);
  fputs("\\input texinfo @c -*-Texinfo-*-\n\n",	fptr);
  fprintf(fptr,
	"@setfilename %s.guide\n"
	"@settitle Autodocs for %s\n"
	"@finalout\n@setchapternewpage on\n\n"
	"@titlepage\n@title Autodocs for %s\n"
	"@subtitle Documentation taken from source code\n"
	"@subtitle\n"
	"@subtitle Version %s\n"
	"@subtitle\n"
	"@subtitle Printed version\n"
	"@subtitle\n"
	"@subtitle Extracted %s\n"
	"@subtitle \n"
	"@author %s\n\n"
	"@page\n@vskip 0pt plus 1filll\n"
	"Copyright @copyright{} by %s\n"
	"@end titlepage\n\n"
	"@ifinfo\n@node Top\n@top\n@unnumbered\n\n"
	"@center Autodocs for %s\n"
	"Written by %s\n"
	"@copyright{} Copyright by %s\n"
	"Documentation taken directly from source code\n\n"
	"Extracted %s\n\n"
#if 0
	"Docs generated using GAdoc, (c) by Gerhard Leibrock, Feb 1995\n\n"
#endif
	"@end ifinfo\n\n\n"
	"@menu\n",
	&filename[i+1], project, project, version,
	ctime(&t),  author, copyright,
	project, author, copyright, ctime(&t));
}


/****i* gadoc.c/OpenOutputFiles() ********
*
*  NAME
*    OpenOutputFiles -- Open the needed output files
*
*  SYNOPSIS
*    OpenOutputFiles(fname, menu, data)
*
*    void OpenOutputFiles(char *fname, FILE **menu, FILE **data)
*
*  FUNCTION
*    Open two files named <fname>.data and <fname>.menu. These two files
*    are needed for the generated texinfo output. <fname>.menu is the
*    main part, which includes <fname>.data.
*
*  INPUTS
*   fname - Main part of the name for the file to open
*   menu  - Adress of file pointer for <fname>.menu.
*   data  - Adress of file pointer for <fname>.data.
*
*  RESULT
*    None
*
*  EXAMPLE
*    FILE *menu, *data;
*    char *fname = "myfile";
*
*    ...
*
*    OpenOutputFiles(fname, &menu, &data);
*
*  NOTES
*    MUST be called before WriteTexinfo().
*
*  BUGS
*    None
*
*  SEE ALSO
*    
***/
void OpenOutputFiles(char *fname, FILE **menu, FILE **data)
{
  char buf[80];
  /* Open the output file, which contains the document description and
     toc */
  strcpy(buf, fname); strcat(buf, ".menu");
  if(!(*menu=fopen(buf, "w")))
  {
    printf("Could not open file %s.\n", buf);
    exit(0);
  }

  /* Open the file, which will contain the function descriptions,
     ``fname'' will be used later agin and contains the filename */
  strcpy(buf, fname); strcat(buf, ".data");
  if(!(*data=fopen(buf, "w")))
  {
    printf("Could not open file %s!\n", buf);
    exit(0);
  }
}


int main(int argc, char *argv[])
{
  FILE *ein;
  FILE *aus_menue, *aus_daten;

  int i, j;

  #define MAX_LINE_LENGTH 80
  char zk[MAX_LINE_LENGTH], zk1[MAX_LINE_LENGTH], zk2[MAX_LINE_LENGTH];

  /* Name des Programmautors */
  char author[50];
  /* Wie heisst dass Projekt? */
  char project[50];
  /* Welche Version hat es? */
  char version[50];
  /* Wer hat das Copyright? */
  char copyright[50];

  unsigned int zeile = NULL;

  BOOL autodoc_mode=FALSE;

  /* Schluesselworte fuer Auto-DOCS */
  char *keywords[] = {"NAME", "SYNOPSIS", "FUNCTION", "INPUTS", "RESULT",
  "EXAMPLE", "NOTES", "BUGS"};
  BOOL autodoc = FALSE;
  BOOL first_key = FALSE;
  BOOL see_also = FALSE;	/* Im @ref{} Modus */
  BOOL see_also_found = FALSE;	/* SEE ALSO schon vorgekommen */
  BOOL key_found = FALSE;
  BOOL key[sizeof(keywords) / sizeof(char**)];

  /* Programminteren Schluesselwoerter */
  char *internal_keywords[] = {"NAME", "COPYRIGHT", "FUNCTION", "AUTHOR",
  "NOTES", "VERSION"};
  BOOL internal_key[sizeof(internal_keywords) / sizeof(char**)];
  BOOL internal = FALSE; /* Internal schon mal aufgerufen? */
  BOOL internal_mode = FALSE;
  /* Zum Aussteigen beim Einlesen der Datei bei Endkennung */
  BOOL internal_ende = FALSE;

  /* */
  BOOL first_internal = FALSE;
  /* Zuletzt aktives Schluesselwort */
  int last_key = -1;

  /* Extrahieren der als intern deklarierten Docs? */
  BOOL extract_internal = FALSE;
  /* Include amiga support? */
  BOOL amiga_support = FALSE;

  /* Extract only docs with specific ID */
  BOOL extract_flag = FALSE;

  char *token; /* Zum Aufsplitten der Eingabe-Datei */

  /* Flag for the -c option */
  BOOL convert_comment = FALSE;

  /* Flag for the -aicon option */
  BOOL amiga_icon = FALSE;


  /* Strings, which signal the beginning of an autodoc entry */     
  char generic_marker[]  = "****** ";
  char internal_marker[] = "****i* ";
  char author_marker[]   = "****h* ";
  /* Length of the strings: IMPORTANT for checking */
  #define MARKER_LENGTH 7

  /* String, that signals the end of the autodoc entry (First char gets
     NOT ignored) */
  char autodoc_end_marker[] = "***";
  /* String length of the end marker */
  #define END_LENGTH 3

  if(argc<3 || argc>8)
  {
    puts("This prgram extracts the AutoDOCs from your source-files\n"
         "and produces two TeXinfo-files out of it:\n"
         "<texinfo_file>.menu AND <texinfo_file>.data\n"
         "The *.menu file is the main part, use it with makeinfo.");
    printf("Syntax:\n"
           "\t%s <source> <texinfo_file> [-i] [-c] [-s<id>] [-amiga] [-aicon]\n"
           "\t -i:     Also extract internal documentation\n"
           "\t -c:     Convert \\* to /* and *\\ to */\n"
           "\t -s<id>  Only extract docs with <id> ID\n"
           "\t -amiga: Include amiga support for texinfo\n"
           "\t -aicon: Create an Amiga icon that can be used for the guide file\n"
           "(c) Gerhard Leibrock, 1995\n", argv[0]);
    printf("Warning: Lines are limited to %ld chars!\n", sizeof(zk));
    exit(0);
  }

  /* Testen, ob der Benutzer AUCH die als INTERN deklarierten Autodocs
     erhalten moechte */
  if(argc>=4)
    for(i=3; i<argc; i++)
    {
      if(!strcmp(argv[i], "-i"))
      {
        if(extract_internal)
        {
	  printf("%s: Specified twice (See argument #%d)\n", argv[i], i+1);
	  exit(0);
        }
        else
          extract_internal = TRUE;
      }
      else if(!strcmp(argv[i], "-amiga"))
      {
        if(amiga_support)
        {
	  printf("%s: Specified twice (See argument #%d)\n", argv[i], i+1);
	  exit(0);
        }
        else
          amiga_support = TRUE;
      }
      else if(!strcmp(argv[i], "-aicon"))
      {
        if(amiga_icon)
        {
	  printf("%s: Specified twice (See argument #%d)\n", argv[i], i+1);
	  exit(0);
        }
        else
          amiga_icon = TRUE;
      }
      else if(!strcmp(argv[i], "-c"))
      {
        if(convert_comment)
        {
	  printf("%s: Specified twice (See argument #%d)\n", argv[i], i+1);
	  exit(0);
        }
        else
          convert_comment = TRUE;
      }
      else if(!strncmp(argv[i], "-s", 2))
      {
        if(extract_flag)
        {
	  printf("%s: Specified twice (See argument #%d)\n", argv[i], i+1);
	  exit(0);
        }
        else
        {
          if(strlen(&(argv[i][2])) != 2)
          {
            printf("-s: \"%s\" is invalid, I need exactly 2 chars.\n",
                   &(argv[i][2]));
            exit(0);
          }
          /* Now adjust the tokens, that signal the beginning of an autodoc */
	  generic_marker[1] = internal_marker[1] =
				author_marker[1] = argv[i][2];
	  generic_marker[2] = internal_marker[2] =
				author_marker[2] = argv[i][3];
          extract_flag = TRUE;
        }
      }
      else
      {
        printf("Unknown argument: %s\n", argv[i]);
        exit(0);
      }
    } /* Schleife ueber die Argumente beim Aufruf */

   if(amiga_icon)
   {
     strcpy(zk, argv[2]);
     strcat(zk, ".guide.info");
     printf("Writing AmigaDOS icon data \"%s\"\n", zk);
     ein = fopen(zk, "wb");
     if(!ein)
     {
       printf("Error: Could not open \"%s\" for writing.\n", zk);
       exit(0);
     }
     fwrite(data, sizeof(data), 1, ein);
     fclose(ein);
   }


  /* Open the source-file */
  if(!(ein=fopen(argv[1], "r")))
  {
    printf("Could not open file ``%s''.\n", argv[1]);
    exit(0);
  }

  printf("Extracting autodocs from file \"%s\" to \"%s.menu\" and \"%s.data\".\n",
	  argv[1], argv[2], argv[2]);

  for(i=0; i<sizeof(keywords) / sizeof(char**); i++) key[i]=FALSE;
  for(i=0; i<sizeof(internal_keywords) / sizeof(char**); i++)
	internal_key[i]=FALSE;


  /* Vorbelegen der Variablen */
  strncpy(author, "Unknown", 50);
  strncpy(project, argv[1], 50);
  strcpy(version, "0.0");


  while ( fgets(zk, sizeof(zk), ein) )
  {
    zeile++;

    /* Wir sind im Autodoc-Modus */
    if(autodoc_mode)
    {
      if( !strncmp(zk, autodoc_end_marker, END_LENGTH) )
      {/* Endkennung erreicht */
	/* Testen, ob es Schluesselwoerter gibt, zu denen nichts
	   geschrieben wurde und zuruecksetzen */
	for(i=0; i<sizeof(keywords) / sizeof(char**); i++)
	{
	  if(!key[i]) fprintf(aus_daten, "\n@code{%s}\n", keywords[i]);
	  key[i]=FALSE;
	}

	/* SEE ALSO schon aufgetaucht? */
	if(!see_also_found) fputs("\n@code{SEE ALSO}\n", aus_daten);

	key_found = FALSE;
	first_key=FALSE;
	autodoc_mode = FALSE;
	if(!see_also) fputs("@end example\n", aus_daten);
	see_also = FALSE; see_also_found = FALSE;
	fputs("\n\n\n", aus_daten);
	/* Testen, ob es Schluesselwoerter gibt, zu denen nichts
	   geschrieben wurde. */
     }
      else /* Teste, auf Anfang fuer Autodoc-Modus */
      {
        key_found = FALSE;
	/* Keine Endkennung, vielleicht aber ein neues Schlüsselwort? */

	/* Ueberlese erstes Zeichen und alle TABs, Leerzeichen */
	strcpy(zk1, zk);
	token = strtok(&zk[1], " \t\n");

        if(token)
        {
	  if(!strcmp(token, "SEE"))
	  {
	    token = strtok(NULL," \t\n");
	    if(!strcmp(token, "ALSO"))
	    {
	      if(see_also_found)
	      {
		printf( "Error Line %u: Either keyword SEE ALSO used twice"
			"or in wrong order.\n", zeile);
		exit(0);
	      }
	      /* Nun setzen wir alle Kennungen fuer Schluesselwoerter auf
	         gefunden, falls diese noch nicht gefunden worden sind, da
	         SEE ALSO das letzte zu akzeptierende Schluesselwort ist.
		 Ausserdem schreiben wir die Schluesselworte, da alle
		 vorkommen sollen */
	      for(i=0; i<sizeof(keywords) / sizeof(char**); i++)
	      {
		if(!key[i]) fprintf(aus_daten, "\n@code{%s}\n", keywords[i]);
		key[i]=TRUE;
	      }

	      /* Schluesselwort "SEE ALSO" */
	      if(first_key) fputs("@end example\n", aus_daten);
	      first_key=TRUE;
	      key_found=TRUE;
	      see_also = TRUE; see_also_found = TRUE;
	      strcpy(zk1, "SEE ALSO");
	    }
	  }
	  else {
	    for(i=0; i< sizeof(keywords) / sizeof(char**); i++)
	    {
	      if(!strcmp(token, keywords[i]))
	      {
	        if(key[i] == TRUE)
	        {
		  printf("Error Line %u: Either keyword %s used twice"
			 "               or in wrong order\n",
		    zeile, keywords[i]);
		  exit(0);
	        }
	        /* Alle Schluesselwoerter, die vor diesem in der Reihenfolge
	           stehen, werden als belegt gekennzeichnet */
		for(j=0; j<i; j++)
		{
		  if(!key[j]) fprintf(aus_daten, "\n@code{%s}\n", keywords[j]);
		  key[j]=TRUE;
		}
		key[i]=TRUE;
	        if(first_key) fputs("@end example\n", aus_daten);
	        first_key=TRUE;
	        key_found=TRUE;
	        see_also = FALSE;
	        strcpy(zk1, keywords[i]);
	        break;
	      }
	    } /* Suche nach Keyword */
	  } /* ELSE */
	}
	if(!key_found) {
	  if(see_also)
	  {
	    token = strtok(&zk[1], " ,\t\n");
	    if(token) strcpy(zk1, token);
	    else      zk1[0] = '\0';
	    while(token != NULL)
	    {
	      /* Ueberlesen des Textes vor ``/'' */
	      for(i=0; i<strlen(token); i++)
	      {
	        if(token[i]=='/') {
	          zk1[i]=NULL;
	          strcpy(zk2, &token[i+1]);
	          break; }
	      }

	      /* Ist zk1 != Dateiname, dann wird ein Objekt ausserhalb
	         referenziert, sonst koennen wir den Dateinamen weglassen */
	      if(!strcmp(zk1, argv[1]))
	      {
	        fprintf(aus_daten, "@ref{%s}.\n", zk2);
	      }
	      else
	      {
		/* Nun referenzieren in eine andere Datei:
			zk2: Name der Referenz
			zk1: Datei, in der die Referenz ist */
		fprintf(aus_daten, "@xref{%s, , %s, %s, Autodoc-file %s}.\n",
			zk2, zk2, zk1, zk1);
	      }

	      token = strtok(NULL," ,\t\n");
	    }
	  }
	  else
	  {
	    if(convert_comment)
	    {
	      for(i=0; i<strlen(zk1); i++)
	        if(zk1[i] == '\\') zk1[i] = '/';

	    }
	    fputs(&zk1[1], aus_daten);
	  }
	}
	  /* Wir ignorieren das erste Zeichen links */
	else
	{
	  fprintf(aus_daten, "\n@code{%s}\n", zk1);
	  if(!see_also)  fputs("\n@example\n", aus_daten);
	  key_found = FALSE;
	}
      } /* keine Endkennung */
    }
    else /* Nicht im Autodoc-Modus */
    { /* Autodoc-Modus startet mit einer Zeile, bei der das erste Zeichen
	 keine Rolle spielt, dann aber 6 '*' folgen, dann durch ein
	 Leerzeichen getrennt der Name der Funktion und dann durch ein
	 Leerzeichen getrennt beliebige Zeichen.
         Es kann aber auch so sein, daß eine Kennung mitunterschieden
         werden soll, wenn nur spezielle Teile extrahiert werden sollen,
         z.B. die Docs in einer bestimmten Sprache. Dann wird nicht auf
         6 '*' getestet, sondern auf "*ID***".
         
      */
      if(! strncmp(&zk[1], generic_marker, MARKER_LENGTH) )
      {
        for(i=MARKER_LENGTH+1; i<strlen(zk); i++)
        {
          zk1[i-MARKER_LENGTH-1] = zk[i];
          if(zk[i] == ' ')
	  {
	    zk1[i-MARKER_LENGTH-1]='\0';
	    break;
	  }
        }
        /* zk1: Name der Funktion, zk2 -> Beliebiger Rest */
	if(!autodoc) /* Erster Eintrag? */
	{
	  autodoc = TRUE;

          /* Now open the output files */
          OpenOutputFiles(argv[2], &aus_menue, &aus_daten);
	  WriteTexinfo(
		aus_menue, argv[2], author, project, version,
		copyright, amiga_support);
	}
	autodoc_mode = TRUE;

        /* Ueberlese den Teil vor ``/'' */
        token = strtok(zk1, "/");
        token = strtok(NULL, " \n\t");

	/* Menue-Datei */
	fprintf(aus_menue, "* %s::\n", token);
	fprintf(aus_daten, "@node %s\n"
			   "@chapter %s\n"
			   "@findex %s\n\n",
			    token, token, token);
	
      }

      /* Modus fuer die internen Funktionen */
      if(! strncmp(&zk[1], internal_marker, MARKER_LENGTH) )
      {
        for(i=MARKER_LENGTH+1; i<strlen(zk); i++)
        {
          zk1[i-MARKER_LENGTH-1] = zk[i];
          if(zk[i] == ' ')
	  {
	    zk1[i-MARKER_LENGTH-1]='\0';
	    break;
	  }
        }

	/* Wir sollen auch die internen Docs extrahieren? */
	if(extract_internal) 
	{
	  if(!autodoc)	/* Erster Eintrag ueberhaupt? */
	  {
	    autodoc = TRUE;
	    /* Now open the output files */
	    OpenOutputFiles(argv[2], &aus_menue, &aus_daten);

	    WriteTexinfo(
		aus_menue, argv[2], author, project, version,
		copyright, amiga_support);
	  }
	  autodoc_mode = TRUE;

	  /* Ueberlese den Teil vor ``/'' */
	  token = strtok(zk1, "/");
	  token = strtok(NULL, " \n\t");

	  /* Menue-Datei */
	  fprintf(aus_menue, "* %s:: Internal function\n", token);
	  fprintf(aus_daten, "@node %s\n"
			   "@chapter %s\n"
			   "@findex %s (Internal function)\n\n"
			   "@center ONLY FOR INTERNAL USE: @b{%s}\n\n",
			    token, token, token, token);
	}
	else /* ueberlesen der INTERNEN Funktionsdokumentation */
	{
	  BOOL haben_ende = FALSE;
	  while ( fgets(zk, sizeof(zk), ein) && !haben_ende )
	  {
	    zeile++;
            if( !strncmp(zk, autodoc_end_marker, END_LENGTH) )
	     {
		haben_ende = TRUE;
		break;
	     }
	  } /* fgets() */
	  if(!haben_ende)
	  {
	    printf("Error: End of file occured during internal docs.\n");
	    exit(0);
	  }
	} /* Ueberlesen der internen Dokumentation */
      } /* BLOCK zum Lesen der internen Dokumentation */

      /* Ausfuellen der Slots (Fuer AUTHOR, etc): */
      if(! strncmp(&zk[1], author_marker, MARKER_LENGTH) )
      {
        for(i=MARKER_LENGTH+1; i<strlen(zk); i++)
        {
          zk1[i-MARKER_LENGTH-1] = zk[i];
          if(zk[i] == ' ')
	  {
	    zk1[i-MARKER_LENGTH-1]='\0';
	    break;
	  }
        }
        /* zk1: Name der Funktion */

	internal_ende = FALSE;

	if(autodoc) {
	  printf("Error Line %u: Header specified after autodocs.\n",
		zeile);
	  exit(0); }

        if(internal) {
	  printf("Error Line %u: Second time header gets specified.\n", zeile);
	  exit(0); }
	  
        /* Ueberlese den Teil vor ``/'' */
        token = strtok(zk1, "/");
        token = strtok(NULL, " \n\t");

        /* Now open the output files */
        OpenOutputFiles(argv[2], &aus_menue, &aus_daten);

	/* Menue-Datei */
	fprintf(aus_daten, "@node About_%s\n"
			   "@chapter About_%s\n"
			   "@findex About_%s\n\n",
			    token, token, token);

        strcpy(zk2, token);
	/* Nun solange lesen, bis wir die internal-Sachen abgearbeitet haben */
	while ( fgets(zk, sizeof(zk), ein) && !internal_ende )
	{
	  zeile++;
          if( !strncmp(zk, autodoc_end_marker, END_LENGTH) )
          {/* Endkennung erreicht */
	    for(i=0; i<sizeof(internal_keywords) / sizeof(char**); i++)
		internal_key[i]=FALSE;

	    internal_mode = FALSE;
	    internal = TRUE;
	    if(!see_also) fputs("@end example\n", aus_daten);
	    fputs("\n\n\n", aus_daten);
	    internal_ende = TRUE;
          }
          else /* Teste, auf Anfang fuer Internal-Modus */
          {
	    /* Ueberlese erstes Zeichen und alle TABs, Leerzeichen */
	    strcpy(zk1, zk);
	    token = strtok(&zk[1], " \t\n");

	    /* Schleifenvariable i dient spaeter als Indikator fuer
	       das Auffinden eines Schluesselwortes. Mit dem Setzen auf
	       einen Wert ausserhalb des Schluesselwort-Bereichs setzen
	       wir den Test fuers Finden auf FALSE */
	    i=sizeof(internal_keywords) / sizeof(char**);

            if(token)
            {
	      for(i=0; i< sizeof(internal_keywords) / sizeof(char**); i++)
	      {
	        if(!strcmp(token, internal_keywords[i]))
	        {
		  last_key = i;
	          if(internal_key[i] == TRUE)
	          {
		    printf("Error Line %u: Keyword %s used twice.\n",
		      zeile, keywords[i]);
		    exit(0);
	          }
	          if(first_internal) fputs("@end example\n", aus_daten);
	          first_internal=TRUE;
	          internal_key[i] = TRUE;
	          strcpy(zk1, internal_keywords[i]);
	          break;
	        }
	      } /* Suche nach Keyword */
	    }

	    /* Keyword? */
	    if(i!=sizeof(internal_keywords) / sizeof(char**))
	    {
	      fprintf(aus_daten, "\n@code{%s}\n", zk1);
	      fputs("\n@example\n", aus_daten);
	    }
	    else /* Wir haben kein Schluesselwort */
	    {
	      if(convert_comment)
	      {
	        for(i=0; i<strlen(zk1); i++)
	          if(zk1[i] == '\\') zk1[i] = '/';
	      }
	      strcpy(zk, zk1);
	      token = zk;
	      token = strpbrk(zk," \t");
	      switch(last_key)
	      {
	        case 3:	/* AUTHOR */
		  strncpy(author, token, 50);
	        break;

	        case 0:	/* NAME */
		  strncpy(project, token, 50);
	        break;

	        case 5:	/* VERSION */
		  strncpy(version, token, 50);
	        break;

	        case 1:	/* COPYRIGHT*/
		  strncpy(copyright, token, 50);
	        break;
	      }
	      last_key = -1;
	      fputs(&zk1[1], aus_daten);
	    }
          } /* keine Endkennung */
	} /* fgets() */
	/* Ende mit einlesen -> Kein Fehler, wenn internal == TRUE */
	if(!internal) {
	  printf("Error: End of file occured during internal block.\n");
	  exit(0);
	}

	WriteTexinfo(aus_menue, argv[2], author, project, version,
			copyright, amiga_support);
	fprintf(aus_menue, "* About_%s::\n", zk2);

        internal_mode = TRUE;
        autodoc = TRUE;
      } /* Internal-Kennung (AUTHOR, etc.) */

    }/* Nicht im Autodoc_modus */
      
  } /* fgets() */

  if(autodoc_mode) puts("Error: End of file during autodoc mode!");
  else
  {
    /* Did we obtain something at all? */
    if(autodoc)
    {
      /* Eliminate path specifiers like "/" and ":" */
      for(i=strlen(argv[2])-1; i>=0; i--)
        if(argv[2][i] == ':' || argv[2][i]=='/') break;
      fprintf(aus_menue, "* Function Index::\n@end menu\n\n@include %s.data\n\n",
			&argv[2][i+1]);
      fprintf(aus_menue,  "@page\n@node Function Index\n\n"
			"@unnumbered Function Index\n\n"
			"@printindex fn\n@contents\n@bye\n");
      fputs("\n\n", aus_daten);
      printf("\"%s.menu\" is the main part.\n", argv[2]);
    }
    else
      puts("-> No autodocs found, so no files were created.");
  }

} /* main() */


/* Eine Extrawurst f"ur den DICE Compiler, der den Start von der WB
   eigenwillig handhabt.  */
#ifdef _DCC
void wbmain(void)
{
  main();
}
#endif





