head	1.3;
access;
symbols;
locks
	dlorre:1.3; strict;
comment	@ * @;


1.3
date	97.07.14.04.26.02;	author dlorre;	state Exp;
branches;
next	1.2;

1.2
date	96.08.28.20.07.42;	author dlorre;	state Exp;
branches;
next	1.1;

1.1
date	96.08.22.02.05.49;	author dlorre;	state Exp;
branches;
next	;


desc
@Oui.lib -- Object User Interface
Projet créé en 1994
Auteur: Dominique Lorre
@


1.3
log
@now more used
@
text
@#include <exec/types.h>
#include <exec/io.h>
#include <exec/memory.h>
#include <dos/dos.h>
#include <dos/dosextens.h>
#include <dos/exall.h>
#include <graphics/gfx.h>
#include <graphics/gfxbase.h>
#include <intuition/intuition.h>
#include <intuition/classes.h>
#include <intuition/gadgetclass.h>
#include <intuition/icclass.h>
#include <libraries/gadtools.h>
#include <workbench/workbench.h>
#include <string.h>
#include <stdio.h>
#include <stdlib.h>

#include <proto/exec.h>
#include <proto/dos.h>
#include <proto/graphics.h>
#include <proto/layers.h>
#include <proto/intuition.h>
#include <proto/gadtools.h>
#include <proto/icon.h>
#include <proto/console.h>
#include <proto/utility.h>
#include <clib/macros.h>
#include <clib/alib_protos.h>
#include <mydebug.h>

#include "screen.h"
#include "window.h"
#include "gadgetlist.h"
#include "gadgets/string.h"
#include "gadgets/cstring.h"
#include "gadgets/eprop.h"
#include "gadgets/fbutton.h"
#include "slist.h"
#include "locale.h"

#define FILE    gfile->curstring
#define DRAWER  gdrawer->curstring
#define COMMENT gcom->curstring

#define DISPLAY_FILES   0
#define DISPLAY_DIRS    1
#define MAXLEN          255
#define MAXENTRIES      100

static WORD TOT_DISPLAY ;

static WORD FONTHEIGHT ;
static WORD LEFTBOX ;
static WORD TOPDBOX ;
static WORD TOPFBOX ;
static WORD WIDTHBOX ;
static WORD HEIGHTBOX ;

static WORD LEFTSEL ;
static WORD TOPSEL ;
static WORD WIDTHSEL ;
static WORD HEIGHTSEL ;

struct DClick {
    ULONG s;
    ULONG m;
} ;

class filesel : public window
{
public:
    void fparent(gadget *g, unsigned long classe, unsigned short code) ;
    void fdrawer(gadget *g, unsigned long classe, unsigned short code) ;
    void fprop(gadget *g, unsigned long classe, unsigned short code) ;
    char title[80] ;
    BOOL clipok ;
    filesel(short l, short t, short w, short h) : window(l, t, w, h) {}
    void open(screen *) ;
    void simpleevent(IntuiMessage *msg) ;
    void handlevkey(USHORT code) ;
};

static IntuiMessage     *message;       // the message the IDCMP sends us
static BPTR             clef, oldkey;

static UWORD            code;       // IDCMP stuff
static ULONG            classe;

static APTR             object;
static List             *RepList;
static Node             *RepNode, *Garage = NULL;
static ULONG            nbfics = 0;
static LONG             topentry = 0;
static char             chemin[MAXLEN];
static char             DTEMP[MAXLEN] = "";
static TextAttr         **Style;
static char             stemp[MAXLEN], stemp2[MAXLEN], tmp[MAXLEN];
static FileInfoBlock    *bloc;
static WORD             indsel, numsel ;
static char             pat[MAXLEN] ;
static char             RexxCmd[MAXLEN] ;
static DClick           declic = {0, 0};
static Region           *clipregion ;
static Rectangle        cliprect ;
static char             comstring[80] = "" ;

static LONG             lm ;

static char name[MAXLEN];
static BOOL Mode = DISPLAY_FILES;
static BOOL clickon ;

static TextAttr ITALIC80 = {
        (STRPTR)"topaz.font",
        TOPAZ_EIGHTY,FSF_ITALIC,0
};

static struct TextAttr Plain, Italic ;

static BOOL Saver ;
static IntuiText *listetext ;

IMPORT ULONG rexxsig ;
IMPORT MsgPort *RexxPort ;

static string   *gdrawer ;      // Répertoire
static string   *gfile ;        // Nom du fichier
static eprop    *gprop ;        // Scroller
static string   *gcom ;         // Commentaire Lecture/Ecriture
static cstring  *cgcom ;        // Commentaire Lecture Seule

static UBYTE    fpen ;
static UBYTE    bpen ;

IMPORT lstring  ok ;
IMPORT lstring  cancel ;
IMPORT lstring  parent ;
IMPORT lstring  drawer ;
IMPORT lstring  file ;
IMPORT lstring  comment ;
@


1.2
log
@*** empty log message ***
@
text
@d19 12
a30 47
#include <cxxproto/exec.h>
#include <cxxproto/dos.h>
#include <cxxproto/graphics.h>
#include <cxxproto/intuition.h>
#include <cclib/macros.h>
#include <cclib/debug_protos.h>

extern "C" {
extern struct Library *LayersBase ;
struct Region *InstallClipRegion( struct Layer *layer,
        struct Region *region );
#include <pragmas/layers_pragmas.h>

extern struct Library *GadToolsBase ;
struct IntuiMessage *GT_GetIMsg( struct MsgPort *iport );
void GT_ReplyIMsg( struct IntuiMessage *imsg );
void GT_RefreshWindow( struct Window *win, struct Requester *req );
void GT_SetGadgetAttrs( struct Gadget *gad, struct Window *win,
        struct Requester *req, Tag tag1, ... );
struct Gadget *CreateGadget( unsigned long kind, struct Gadget *gad,
        struct NewGadget *ng, Tag tag1, ... );
void FreeGadgets( struct Gadget *gad );
struct Gadget *CreateContext( struct Gadget **glistptr );
void DrawBevelBox( struct RastPort *rport, long left, long top, long width,
        long height, Tag tag1, ... );
APTR GetVisualInfo( struct Screen *screen, Tag tag1, ... );
void FreeVisualInfo( APTR vi );
#include <pragmas/gadtools_pragmas.h>

extern struct Library *IconBase ;
struct DiskObject *GetDiskObject( STRPTR name );
void FreeDiskObject( struct DiskObject *diskobj );
struct DiskObject *GetDefDiskObject( long type );
#include <pragmas/icon_pragmas.h>

extern struct Library *ConsoleDevice ;
LONG RawKeyConvert( struct InputEvent *events, UBYTE *buffer, long length,
        struct KeyMap *keyMap );
#include <pragmas/console_pragmas.h>

extern struct Library *UtilityBase ;
struct TagItem *FindTagItem( Tag tagVal, struct TagItem *tagList );
ULONG GetTagData( Tag tagValue, unsigned long defaultVal,
        struct TagItem *tagList );
#include <pragmas/utility_pragmas.h>
void NewList( struct List *list );
}
d77 1
@


1.1
log
@Initial revision
@
text
@d69 1
@
