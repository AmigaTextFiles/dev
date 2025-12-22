/*
** $VER: GMExample_My.c 1.006 (25.02.96) © Gian Maria Calzolari
**
**
**  FUNCTION:
**      Generic IEditor test with many gadgets
**
** $HISTORY:
**
** 25 Feb 1996 : 001.006 : Final release for v2.25!
** 17 Feb 1996 : 001.005 : Corrected error in NULL pointed ARexx strings
** 07 Feb 1996 : 001.004 : Changed and adapted to IE 2.25
** 01 Jan 1996 : 001.003 : Adapted to use the IE generated main!
** 23 Dec 1995 : 001.002 : Added AREXX header :-(
** 17 Dec 1995 : 001.002 : The ARexx interface now works, DICE doesn't open
**                          RexxSysLib without declaring the RexxSysBase
**                          library struct! :-(
** 08 Dec 1995 : 001.001 : Added an ARexx test cmd
** 12 Nov 1995 : 001.000 : Updated with IE 2.19, added texts and ver string.
**                          First /real/ public release! :-)
** 29 Oct 1995 : 000.002 : Adapted to IE v2.17 and translated to English!
** 12 Oct 1995 : 000.001 : ...first version...
**
*/

#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <errno.h>
#include <rexx/storage.h>

#define INTUI_V36_NAMES_ONLY
#define ASL_V38_NAMES_ONLY

#include <clib/dos_protos.h>

#include "GMExample.h"
#include "GMExample_rev.h"

const char ver[]       = VERSTAG " by Gian Maria Calzolari";
const char version[]   = VSTRING " by Gian Maria Calzolari FidoNet 2:332/502.11";

void    MySetup(void);
int     HandleCtrlC(void);

extern struct Library  *SysBase;
extern                  Ok_to_Run;

UWORD   Scelta = 0;     // MX ChooseMe current value
#define SCELTA_MAX 2    // MX ChooseMe max value

void MySetup()
{
    if (SysBase->lib_Version < 37)
        Error("You need at least KickStart", ">= 37 (2.04)");

    onbreak(HandleCtrlC);

    // Put my version into the text gadget
    GT_SetGadgetAttrs(MiaFinGadgets[GD_Text], MiaFinWnd, NULL,
            GTTX_Text, version,
            TAG_END);
}


/* -------------------------------- HandleCtrlC --------------------------------

 Comment:

 CTRL + C management (this works ONLY with the DICE's onbreak function)

*/

int HandleCtrlC(void)
{
    End(RETURN_WARN);
    return TRUE;
}


/*
    C/E source code created by Interface Editor
    Copyright © 1994-95 by Simone Tellini Software

    Copy registered to :  Gian Maria Calzolari - Beta Tester 2
    Serial Number      : #2
*/

/*
   In this file you'll find empty template routines
   referenced in the GUI source.  You can fill this
   routines with your code or use them as a reference
   to create yor main program.
*/

BOOL SubItem1Menued( void )
{
    printf("Routine for menu *Menù1/Item1/SubItem1*\n");
    return TRUE;
}

BOOL SubItem2aMenued( void )
{
    printf("Routine for menu *Menù1/Item2/SubItem2a*\n");
    return TRUE;
}

BOOL SubItem2bMenued( void )
{
    printf("Routine for menu *Menù1/Item2/SubItem2b*\n");
    return TRUE;
}

LONG GetTheStringRexxed( ULONG *ArgArray, struct RexxMsg *Msg )
{
    TEXT buffer[11];

    printf("Routine for the *GetTheString* ARexx command\n");

    strcpy(buffer, GetString(MiaFinGadgets[GD_Stringa]) );

    Msg->rm_Result2 = CreateArgstring(buffer, strlen(buffer) );

    return(0L);
}

LONG PutTheStringRexxed( ULONG *ArgArray, struct RexxMsg *Msg )
{
    printf("Routine for the *PutTheString* ARexx command\n");

    GT_SetGadgetAttrs(MiaFinGadgets[GD_Stringa], MiaFinWnd, NULL,
            GTST_String, ArgArray[0],
            TAG_END);

    return(0L);
}

LONG QuitRexxed( ULONG *ArgArray, struct RexxMsg *Msg )
{
    printf("Routine for the *QUIT* ARexx command\n");

    Ok_to_Run = MiaFinCloseWindow();
    return(0L);
}

LONG Gimme5Rexxed( ULONG *ArgArray, struct RexxMsg *Msg )
{
    printf("Routine for the *GIMMEFIVE* ARexx command\n");

    printf("All Right, [");

    if ( (STRPTR)ArgArray[0] )
        printf("%s", (STRPTR)ArgArray[0] );

    printf("] [");

    if ( (STRPTR)ArgArray[1] )
        printf("%s", (STRPTR)ArgArray[1] );

    printf("]!\n");

    return(0L);
}

BOOL MiaFinCloseWindow( void )
{
    printf("Routine for IDCMP_CLOSEWINDOW\n");
    return FALSE;
}

BOOL BottoneClicked( void )
{
    printf("Routine when *_Button!* clicked\n");
    return TRUE;
}

BOOL BottoneKeyPressed( void )
{
    printf("Routine when *_Button!*'s activation key is pressed\n");

    /*  ...or return TRUE not to call the gadget function  */
    return BottoneClicked();
}

BOOL PaletteClicked( void )
{
    printf("Routine when *Palette* clicked\n");
    return TRUE;
}

BOOL SceglimiClicked( void )
{
    printf("Routine when *_Choose me!* clicked\n");

    Scelta = MiaFinMsg.Code;

    printf("You chose <%s>\n", SceglimiLabels[Scelta] );

    return TRUE;
}

BOOL SceglimiKeyPressed( void )
{
    printf("Routine when *_Choose me!*'s activation key is pressed\n");

    if (Scelta < SCELTA_MAX)
        Scelta++;
      else
        Scelta = 0;

    GT_SetGadgetAttrs(MiaFinGadgets[GD_Sceglimi], MiaFinWnd, NULL,
        GTMX_Active, Scelta,
        TAG_END);

    MiaFinMsg.Code = Scelta;

    /*  ...or return TRUE not to call the gadget function  */
    return SceglimiClicked();
}

BOOL NumeroClicked( void )
{
    LONG numero;

    printf("Routine when *Key in a _number* clicked\n");

    numero = GetNumber( MiaFinGadgets[GD_Numero] );
    printf("Gadget value: <%d>\n", numero);

    return TRUE;
}

BOOL StringaClicked( void )
{
    TEXT stringa[11];

    printf("Routine when *Key in a _string* clicked\n");

    strcpy(stringa, GetString( MiaFinGadgets[GD_Stringa] ) );
    printf("Gadget value: <%s>\n", stringa);

    return TRUE;
}

BOOL ProvaImgClicked( void )
{
    printf("Routine when *BooleanGadget* clicked\n");
    return TRUE;
}

BOOL MiaFinVanillaKey( void )
{
    printf("Routine for not a gadget related key pressed!\n");

    printf("...you pressed <%c>\n", MiaFinMsg.Code);

    return TRUE;
}

