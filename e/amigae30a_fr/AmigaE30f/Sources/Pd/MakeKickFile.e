;/* MakeKickFile.e - Executez moi pour compilation avec Amiga E v2.1
ec MakeKickFile
quit
*/
/*
**      $Filename: MakeKickFile.e $
**      $Release: 1.1 $
**
**      (C) Droits de copie 1991-1993 Jaba Development.
**          Écrit par Jan van den Baard
**
**      Crée un fichier rom-kick de la machine où il tourne.
**      Il peut créer des fichier de ROM 256K et 512K.
**
**      C'est la traduction littérale de mon propre original en code C
**      et la première chose que j'écris en miga E. Toute fois, il ne
**      doit pas utiliser l'E a fond toutes ses possibilités.
**      Pardonnez moi s'il vous plait.
**
**      L'utilisation est simple. Vous passez à ce programme un nom de
**      fichier et, si la ROM est connue, il écrira la ROM de la machine
**      dans le fichier. Il écrit la ROM, *PAS* la soft-kicked* ROM.
**
**      Le fichier puet ensuite être utilisé par SETCPU ou SKICK pour
**      booter une machine avec le fichier ROM.
**
**      Je l'ai testé avec succès avec une ROM de l'A1200 sur un A2500.
**
**      Aucun test n'a été fait avec un fichier ROM 1.2/1.3
**      Je n'ai pas accès à des machines 1.2/1.3.
**
**      C'est vraiment un hack...mais un hack qui marche !
**
** Traduction : Olivier ANH (BUGSS)
**/

MODULE  'dos/dos'

/* constantes de taille de la ROM et les cookies magiques */
CONST   SMALLROM = $00040000, SMALLMAGIC = $11114EF9,
        BIGROM   = $00080000, BIGMAGIC   = $11144EF9

/* structure RomFileHeader de C= */
OBJECT  romfileheader
    alwaysnil :  LONG       /* sans commentaire -: toujours NIL */
    romsize   :  LONG       /* la taille de la ROM */
ENDOBJECT

/* seulement 3 erreurs d'exception... */
ENUM    ER_USAGE=1, ER_UNKNOWN, ER_IO

/* Vas-y, Simone... */
PROC main() HANDLE
    DEF outfile = NIL,
        base    = NIL : PTR TO LONG,
        size    = NIL,
        len     = NIL,
        rk, rfh       : romfileheader

    WriteF( '\e[1mMakeKickFile version 1.1 - (C) 1991-1993 Jaba Development\e[0m\n' );

    /* pas d'argument ou "?", alors imprime l'utilisation */
    IF StrCmp( arg, '', 1 ) OR StrCmp( arg, '?', 2 ) THEN Raise( ER_USAGE )

    /* d'abord essaye avec une ROM de 512 KB */
    base := $00F80000

    /* si le cookie magique n'est pas un BIGMAGIC alors ça doit être une ROM de 256 KB */
    IF ( base[ 0 ] <> BIGMAGIC ) THEN base := $00FC0000

    /* voyons voir avec quelle ROM on a affaire */
    rk := base[ 0 ]

    SELECT rk
        CASE    SMALLMAGIC; size := SMALLROM        /* 256 KB */
        CASE    BIGMAGIC;   size := BIGROM          /* 512 KB */
        DEFAULT;            Raise( ER_UNKNOWN )     /* inconnu... */
    ENDSELECT

    /* montre la taille de la ROM */
    WriteF( 'Taille de la ROM = \dKoctets.\n', size / 1024 )

    /* ouvre le fichier kick */
    IF ( outfile := Open( arg, MODE_NEWFILE ))
        WriteF( 'écrit le fichier image Kick...\n' )

        rfh.alwaysnil := NIL        /* met ça à NIL */
        rfh.romsize   := size       /* met ici la taille de la ROM */

        len := Write( outfile, rfh, 8 ) /* écrit le romfileheader */
        len := len + Write( outfile, base, size )   /* écrit la rom */

        Close( outfile ) /* close the kick-file */

        /* tout a été bien écrit ? */
        IF ( ( len <> ( size + 8 )) OR IoErr() ) THEN Raise( ER_IO )
    ELSE
        /* ne peut pas ouvrir le fichier! */
        WriteF( 'Impossible d'ouvrir le fichier de sortie !\n' )
    ENDIF
EXCEPT
    /* procédure d'exception quand aucun argument n'est donné
       ou la ROM n'est pas reconnue ou il y a une erreur d'entrée/sortie. */
    SELECT exception
        CASE    ER_USAGE;   WriteF( 'Usage: MakeKickFile <romfilename>\n' )
        CASE    ER_UNKNOWN; WriteF( 'ROM inconue !\n' )
        DEFAULT;            PrintFault( IoErr(), 'Erreur -' )
    ENDSELECT
ENDPROC IoErr()
