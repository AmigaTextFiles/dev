;/* execute me to make with SAS 6.x
sc NOSTKCHK CSRC aguidexrefv39.c OPT IGNORE=73
slink lib:c.o aguidexrefv39.o //Goodies/extrdargs/extrdargs.o TO /c/aguidexrefv39 SMALLDATA SMALLCODE NOICONS LIB lib:amiga.lib lib:sc.lib /lib/xrefsupport.lib
quit
*/

/*
** $PROJECT: XRef-Tools
**
** $VER: aguidexrefv39.c 1.20 (02.11.94)
**
** by
**
** Stefan Ruppert , Windthorststraße 5 , 65439 Flörsheim , GERMANY
**
** (C) Copyright 1994
** All Rights Reserved !
**
** $HISTORY:
**
** 02.11.94 : 001.020 :  ReplyMsg() was wrong, now uses the GT_ReplyIMsg
** 22.09.94 : 001.019 :  now uses the real nodename ENTRYA_NodeName
** 08.09.94 : 001.018 :  workbench support added (FinalReadArgs())
** 03.09.94 : 001.017 :  now uses ENTRYA_NodeName to generate the amigaguide node path
** 27.08.94 : 001.016 :  use now GM_LAYOUT method after font selection
** 27.08.94 : 001.015 :  bumped to version 1
** 23.08.94 : 000.014 :  screen font bug (propotional) fixed,
**                       if a found xref is in the middle of a document
**                       the line offset is now set correct
** 10.08.94 : 000.013 :  added file,font requester
** 07.08.94 : 000.012 :  v37,v39 splitted into two files
** 29.07.94 : 000.011 :  major changes to v39 version
** 12.06.94 : 000.010 :  font support for v39 version
** 10.06.94 : 000.009 :  file highlight added
** 05.06.94 : 000.008 :  now different tmpfiles and v39 datatype skeleton added
** 28.05.94 : 000.007 :  now uses the tags function
** 18.05.94 : 000.006 :  file support added
** 18.05.94 : 000.005 :  cachedir option added
** 14.05.94 : 000.004 :  XRefAddDynamicHost added
** 09.05.94 : 000.003 :  support of diffrent main pages (categories)
** 06.05.94 : 000.002 :  column support added
** 02.05.94 : 000.001 :  initial
*/

/* ------------------------------- includes ------------------------------- */

#include "aguidexref.h"

#include <datatypes/datatypes.h>
#include <datatypes/datatypesclass.h>

#include <clib/datatypes_protos.h>
#include <pragmas/datatypes_pragmas.h>

#include "aguidexrefv39_rev.h"

#include "/lib/xrefsupport.h"

#include "strings.c"

/* ------------------------------- defines -------------------------------- */

/*FS*/ /*"Defines"*/

#define GADID_Category             1
#define GADID_String               2
#define GADID_Mode                 3
#define GADID_AmigaGuide           4

#define GADID_LeftButton           5
#define GADID_UpButton             6
#define GADID_RightButton          7
#define GADID_DownButton           8
#define GADID_HorizProp            9
#define GADID_VertProp            10

/* default values for gadget layout */
#define CYCLEGADGET_WIDTH         30
#define DEFAULT_FONTHEIGHT         8
#define FREEPIXELHEIGHT            9

/* rawkey */
#define SHIFT_TAB                 66

/* ascii */
#define CTRL_C                    3
#define ESCAPE                    27
#define TABULATOR                 '\t'
#define RETURN                    13
#define BROWSE_LEFT              '<'
#define BROWSE_RIGHT             '>'
#define SLASH                    '/'
#define EOS                      '\0'

#define IDCMP_FLAGS              (IDCMP_IDCMPUPDATE | IDCMP_CLOSEWINDOW | IDCMP_VANILLAKEY | IDCMP_RAWKEY | IDCMP_GADGETUP | IDCMP_GADGETDOWN | IDCMP_NEWSIZE | IDCMP_MENUPICK | IDCMP_CHANGEWINDOW | IDCMP_REFRESHWINDOW)
#define WINDOW_FLAGS             (WFLG_CLOSEGADGET | WFLG_DEPTHGADGET | WFLG_SIZEGADGET | WFLG_DRAGBAR | WFLG_ACTIVATE | WFLG_SIZEBBOTTOM | WFLG_SIZEBRIGHT | WFLG_REPORTMOUSE)

#define GAD_STRING(gad)          (((struct StringInfo * ) (gad)->SpecialInfo)->Buffer)

#define AMIGAGUIDECLASS          "amigaguide.datatype"

#define IEQUALIFIER_ALT          (IEQUALIFIER_LALT   | IEQUALIFIER_RALT)
#define IEQUALIFIER_SHIFT        (IEQUALIFIER_LSHIFT | IEQUALIFIER_RSHIFT)

#define USE_TAG(tag,x)           ((x) ? tag : TAG_IGNORE)

enum {
   MYCMD_NOTHING,
   MYCMD_OPEN,
   MYCMD_SAVEAS,
   MYCMD_PRINT,
   MYCMD_ABOUT,
   MYCMD_QUIT,
   MYCMD_MARK,
   MYCMD_COPY,
   MYCMD_SELECTALL,
   MYCMD_CLEARSELECTED,
   MYCMD_MINIMIZE,
   MYCMD_NORMAL,
   MYCMD_MAXIMIZE,
   MYCMD_FONTS,
   MYCMD_SAVEDEFAULT,
};

/*FE*/

/* ------------------------------- AutoDoc -------------------------------- */

/*FS*/ /*"AutoDoc"*/
/*GB*** XRef-Tools/AGuideXRefV39 *********************************************

$VER: AGuideXRefV39.doc

NAME
    AGuideXRefV39 - searches the xref-lists for a given string/pattern and
                    shows a amigaguide text for the found entries

TEMPLATE
    STRING,CATEGORY,FILE/K,CACHEDIR/K,LINELENGTH/N/K,COLUMNS/N/K,LIMIT/N/K,
    NOPATTERN/S,NOCASE/S,PUBSCREEN/K,PORTNAME/K,FONTNAME/K,FONTSIZE/N/K

FORMAT
    AGuideXRefV39 [[STRING (strg|pat)] [[CATEGORY] category] [FILE xreffile]
               [CACHEDIR dir] [LINELENGTH numchars] [COLUMNS numcolumns]
               [LIMIT maxentries] [NOPATTERN] [NOCASE] [PUBSCREEN pubname]
               [PORTNAME agarexxport] [FONTNAME name.font] [FONTSIZE ysize]

FUNCTION
    this command gives an CLI interface to the xref.library, which uses the
    AmigaGuide system to display some found xref entries and have a link to
    its real documentation.
    If you specify the CACHEDIR, this directory will be used to save the
    AmigaGuide files, if there are more the one entries for the given string
    or pattern. Any next call with this CACHEDIR and the given string/pattern,
    it will no longer call the xref.library function, but uses this file.
    If you do not specify a CATEGORY all xreffiles in the xref.library are
    parsed.From xref.library 1.8 the categorystring can be a pattern !

    New Gadgets
    -----------

    AGuideXRefV39 has three additional gadgets, which allow direct access to
    the xref.library.
    
    Category-Gadget :
        The first string gadget is the category gadget. You can specify here
        the category (pattern), you would search for.
    String-Gadget :
        The next string gadget is the string/pattern gadget. Enter here the
        string/pattern you search for and press return to start the search.
    SearchMode-Gadget:
        The last gadget is a cycle gadget, which you can use to adjust the
        search mode.

    Keycontrol
    ----------

    The window has full keycontrol :
        - Cursor keys work like in AmigaGuide (scroll through the document)
        - Slash '/' key retrace to the last document
        - '>' browse to the next document
        - '<' browse to the previous document
        - Tab select next field
        - Shift Tab select previous field
        - Return activate selected field document
        - Space ' ' activate Table of Contents
        - 'I','i' activate Index document
        - 'P','p','S','s' activate string/pattern gadget
        - 'C','c' activate category gadget

INPUTS
    STRING (STRING) - string|pattern to search for

    CATEGORY (STRING) - category to parse (no specified category matches
        all categories). Can be a pattern !

    FILE (STRING) - file to parse, this argument overrides the CATEGORY
        argument

    CACHEDIR (STRING) - if you want to save all generated AmigaGuide files
        to have a fast access to it, just specify here the directory, in which
        these files will saved

    LIMIT (NUMBER) - specifies the maximal number of entries to match
        (default : xref.library default (XREFBA_DefaultLimit))

    LINELENGTH (NUMBER) - specifies the number of chars for a line
        (default : xref.library default (XREFBA_LineLength))

    COLUMNS (NUMBER) - specifies the number of columns, which will be used
        if more than one entry matches
        (default : xref.library default (XREFBA_Columns))

    NOPATTERN (BOOLEAN) - interprets the given string as a normal string
        instead of a pattern

    NOCASE (BOOLEAN) - makes the search case-insensitive

    PUBSCREEN (STRING) - specifies the screen, on which the AmigaGuide winodw
        should be opened

    PORTNAME (STRING) - arexxportname for the amigaguide.datatype process

    FONTNAME (STRING) - font to use for the document

    FONTSIZE (NUMBER) - font ysize to use for the document

EXAMPLES
    The following example searches all xreffiles of the AutoDoc category for
    xrefentries with the word "Window" inside and tries to open a window on the
    GoldEd Screen, if it has found some entry matches this pattern :

        AGuideXRefV39 #?Window#? #?AutoDoc#? PUBSCREEN=GOLDED.1

SEE ALSO
    LoadXRef, ExpungeXRef, MakeXRef, ParseXRef, dos.library/ParsePattern()

COPYRIGHT
    by Stefan Ruppert (C) 1994

HISTORY
    AGuideXRefV39 1.12 (2.11.94) :
        - used ReplyMsg() instead of GT_ReplyIMsg(). This is now fixed !

    AGuideXRefV39 1.11 (22.9.94) :
        - ENTRYA_NodeName wasn't used for opening the guide. This is fixed !

    AGuideXRefV39 1.10 (8.9.94) :
        - workbench support added

    AGuideXRefV39 1.9 (3.9.94) :
        - some changes to reflect the xref.library v1.13 changes
        - insertbyname() insertion order fixed

    AGuideXRefV39 1.8 (27.8.94) :
        - line offsets are handled right
        - screenfont usage changes (don't worded before with proportional
          fonts ! Found and fixed by Marius Gröger)
        - now use GM_LAYOUT method after new font selection

    AGuideXRefV39 1.7 (10.8.94) :
        - now V37 and V39 are two programs
        - menu added
        - ' ' - key shows Table of Contents
        - 'I' - key shows Index
        - prefs file

    AGuideXRef 1.6 (29.7.94) :
        - major changes for V39 version
        - entries now sorted to files

    AGuideXRef 1.5 (10.6.94) :
        - File highlighted added

    AGuideXRef 1.4 (5.6.94) :
        - now unique tempfiles
        - V39 datatype skeleton
        - V39 datatype entry with the FORCEV39 switch

    AGuideXRef 1.3 (28.5.94) :
        - CACHEDIR and PORTNAME options added

    AGuideXRef 1.2 (20.5.94) :
        - LINELENGTH and COLUMNS options added

    AGuideXRef 1.1 (10.5.94) :
        - first beta release

*****************************************************************************/
/*FE*/

/* ------------------------------ Prototypes ------------------------------ */

/*FS*/ /*"Prototypes"*/

LibCall ULONG dispatchmyguideclass(REGA0 Class *cl,REGA2 Object *obj,REGA1 Msg msg);

Class *initmyguideclass(struct GlobalData *gd);
void freemyguideclass(struct GlobalData *gd,Class *cl);

void openamigaguide(struct GlobalData *gd);

void openfile(struct GlobalData *gd);
void triggermethod(struct GlobalData *gd,ULONG triggermethod);

void changedttop(struct GlobalData *gd,UWORD code,UWORD qual);
void addmygadgets(struct GlobalData *gd);
void createmenu(struct GlobalData *gd);
void createpropgadgets(struct GlobalData *gd);
void drawmyline(struct GlobalData *gd);
void setprops(struct GlobalData *gd);

void handlebuttons(struct GlobalData *gd,struct Gadget *mgad,WORD add);
void handleprops(struct GlobalData *gd,struct Gadget *gad);

void executecmd(struct GlobalData *gd,UWORD cmd);

void easyrequest(struct GlobalData *gd,ULONG textid,ULONG gadid,APTR args,...);
BOOL getpubscreenname(struct Screen *screen,STRPTR name);
void saveprefs(struct GlobalData *gd,STRPTR path);
void loadprefs(struct GlobalData *gd,STRPTR path);
BOOL filerequest(struct GlobalData *gd,ULONG titleid,ULONG flags);
void fontrequest(struct GlobalData *gd,ULONG titleid);
void setwindowpointer(struct GlobalData *gd,BOOL busy);
UWORD calctexts(struct GlobalData *gd, struct RastPort *rp, UBYTE **texts);

/*FE*/

/* ---------------------------- version string ---------------------------- */

/*FS*/ /*"Constants"*/

char *prgname = "AGuideXRefV39";

static char *vstring = VERS " (" DATE ")";
static char *envpath = "Env:AGuideXRef";
static char *arcpath = "EnvArc:AGuideXRef";

static char *search_modes[] = {
   "Pattern",
   "PatternNoCase",
   "Compare",
   "CompareNoCase",
   "CompareNum",
   "CompareNumNoCase",
   NULL};

static struct MenuDef menudef[] = {
   {NM_TITLE,TXT_MENUTITLE_PROJECT     ,              0,MYCMD_NOTHING},
   {NM_ITEM ,TXT_MENUITEM_OPEN         ,              0,MYCMD_OPEN},
   {NM_ITEM ,(ULONG) NM_BARLABEL       ,              0,MYCMD_NOTHING},
   {NM_ITEM ,TXT_MENUITEM_SAVEAS       ,              0,MYCMD_SAVEAS},
   {NM_ITEM ,TXT_MENUITEM_PRINT        ,NM_ITEMDISABLED,MYCMD_PRINT},
   {NM_ITEM ,(ULONG) NM_BARLABEL       ,              0,MYCMD_NOTHING},
   {NM_ITEM ,TXT_MENUITEM_ABOUT        ,              0,MYCMD_ABOUT},
   {NM_ITEM ,(ULONG) NM_BARLABEL       ,              0,MYCMD_NOTHING},
   {NM_ITEM ,TXT_MENUITEM_QUIT         ,              0,MYCMD_QUIT},
   {NM_TITLE,TXT_MENUTITLE_EDIT        ,              0,MYCMD_NOTHING},
   {NM_ITEM ,TXT_MENUITEM_MARK         ,NM_ITEMDISABLED,MYCMD_MARK},
   {NM_ITEM ,TXT_MENUITEM_COPY         ,              0,MYCMD_COPY},
   {NM_ITEM ,(ULONG) NM_BARLABEL       ,              0,MYCMD_NOTHING},
   {NM_ITEM ,TXT_MENUITEM_SELECTALL    ,NM_ITEMDISABLED,MYCMD_SELECTALL},
   {NM_ITEM ,TXT_MENUITEM_CLEARALL     ,              0,MYCMD_CLEARSELECTED},
   {NM_TITLE,TXT_MENUTITLE_WINDOW      ,              0,MYCMD_NOTHING},
   {NM_ITEM ,TXT_MENUITEM_MINIMIZE     ,              0,MYCMD_MINIMIZE},
   {NM_ITEM ,TXT_MENUITEM_NORMAL       ,              0,MYCMD_NORMAL},
   {NM_ITEM ,TXT_MENUITEM_MAXIMIZE     ,              0,MYCMD_MAXIMIZE},
   {NM_TITLE,TXT_MENUTITLE_PREFS       ,              0,MYCMD_NOTHING},
   {NM_ITEM ,TXT_MENUITEM_FONTS        ,              0,MYCMD_FONTS},
   {NM_ITEM ,(ULONG) NM_BARLABEL       ,              0,MYCMD_NOTHING},
   {NM_ITEM ,TXT_MENUITEM_SAVEDEFAULT  ,              0,MYCMD_SAVEDEFAULT}};

static const struct IBox abox[] =
{
    {-49, -9, 16, 10},     /* Left */
    {-17, -31, 18, 10},    /* Up */
    {-33, -9, 16, 10},     /* Right */
    {-17, -20, 18, 10},    /* Down */
};

/*FE*/

/* ------------------------- template definition -------------------------- */

/*FS*/ /*"Template Definition"*/
#define template "STRING,CATEGORY,FILE/K,CACHEDIR/K,LINELENGTH/N/K," \
                 "COLUMNS/N/K,LIMIT/N/K,NOPATTERN/S,NOCASE/S," \
                 "PUBSCREEN/K,PORTNAME/K,FONTNAME/K,FONTSIZE/N/K,"

enum {
   ARG_STRING,     /* string to parse for */
   ARG_CATEGORY,   /* category to parse \  mutual   */
   ARG_FILE,       /* file to parse     / exclusive */
   ARG_CACHEDIR,   /* diretory to hold amigaguide files for a specified STRING */
   ARG_LINELENGTH, /* line length of the amigaguide file */
   ARG_COLUMNS,    /* number of columns */
   ARG_LIMIT,      /* number of maximal entries */
   ARG_NOPATTERN,  /* just a string instead of a pattern-string */
   ARG_NOCASE,     /* ignore letter-case */
   ARG_PUBSCREEN,  /* pubscreen to open the amigaguide window */
   ARG_PORTNAME,   /* arexx port to assign the amigaguide window to */
   ARG_FONTNAME,   /* font to use for the v39 datatype */
   ARG_FONTSIZE,   /* fontsize to use */
   ARG_MAX};
/*FE*/

/* ------------------------ include generic parts ------------------------- */

#include "aguidexref.c"

/* ---------------------------- myguide class ----------------------------- */

/*FS*//*"LibCall ULONG dispatchmyguideclass(REGA0 Class *cl,REGA2 Object *obj,REGA1 Msg msg)"*/
LibCall ULONG dispatchmyguideclass(REGA0 Class *cl,REGA2 Object *obj,REGA1 Msg msg)
{
   struct GlobalData *gd  = (struct GlobalData *) cl->cl_UserData;
   ULONG retval;

   switch(msg->MethodID)
   {
   case OM_SET:
   case OM_UPDATE:
      if((retval = DoSuperMethodA(cl,obj,msg)) && OCLASS(obj) == cl && (!(gd->gd_Flags & GDF_SYNC)))
      {
         struct opUpdate *upd = (struct opUpdate *) msg;
         struct RastPort *rp;

         if(rp = ObtainGIRPort(upd->opu_GInfo))
         {
            DoSuperMethod(cl,obj,GM_RENDER,upd->opu_GInfo,rp,GREDRAW_UPDATE);
            ReleaseGIRPort(rp);
         }
      }
      break;
   case OM_NOTIFY:
      msg->MethodID = OM_UPDATE;
      DoMethodA(obj,msg);
      msg->MethodID = OM_NOTIFY;
      retval = DoSuperMethodA(cl,obj,msg);
      break;
   case DTM_GOTO:
      DB(("goto : %s\n",((struct dtGoto *) msg)->dtg_NodeName));
   case OM_NEW:
      retval = DoSuperMethodA(cl,obj,msg);
      break;
   case OM_GET:
      DB(("get attribute : %lx\n",((struct opGet *) msg)->opg_AttrID));
   default:
      DB(("method : %lx\n",msg->MethodID));
      retval = DoSuperMethodA(cl,obj,msg);
   }

   return(retval);
}
/*FE*/

/*FS*//*"Class *initmyguideclass(struct GlobalData *gd)"*/
Class *initmyguideclass(struct GlobalData *gd)
{
   Class *cl;

   if((cl = MakeClass(NULL,AMIGAGUIDECLASS,NULL,0,0)))
   {
      cl->cl_Dispatcher.h_Entry = (HOOKFUNC) dispatchmyguideclass;
      cl->cl_UserData = (ULONG) gd;
   }
   DB(("myguideclass : %lx\n",cl));

   return(cl);
}
/*FE*/
/*FS*//*"void freemyguideclass(struct GlobalData *gd,Class *cl)"*/
void freemyguideclass(struct GlobalData *gd,Class *cl)
{
   while(!FreeClass(cl))
      Delay(5);
}
/*FE*/

/* ----------------------------- open window ------------------------------ */

/*FS*//*"void openamigaguide(struct GlobalData *gd)"*/
void openamigaguide(struct GlobalData *gd)
{
   struct IBox     *winbox     = &gd->gd_WindowRect;

   struct IntuiMessage *msg;
   struct Window *win;
   struct Gadget *gad;
   struct Gadget *mgad = NULL;
   Object *agobj;

   STRPTR nodename = "main";

   ULONG i;

   if(gd->gd_Num == 0)
      nodename = "xref.library_xreffile@main";
   else if(gd->gd_Num == 1)
   {
      sprintf(gd->gd_FileBuffer,"%s%s",gd->gd_LastEntry.e_Path,gd->gd_LastEntry.e_File);
      nodename = gd->gd_LastEntry.e_NodeName;
   }

   /* open the amiga datatype library */
   if((DataTypesBase = OpenLibrary ("datatypes.library", 39)))
   {
      GadToolsBase = OpenLibrary("gadtools.library",39);
      AslBase      = OpenLibrary("asl.library",39);

      /* get localized strings */
      if((LocaleBase   = OpenLibrary("locale.library",38)))
      {
         if((gd->gd_Catalog = OpenCatalog(NULL,
                                          "xref-tools.catalog",
                                          OC_BuiltInLanguage,"english",
                                          TAG_DONE)))
         {
            for(i = 0 ; i < (sizeof(appStrings)/sizeof(STRPTR)) ; i++)
               appStrings[i] = GetCatalogStr(gd->gd_Catalog,i,appStrings[i]);
         }
      }

      /* get public screen */
      if((gd->gd_Screen = LockPubScreen((STRPTR) gd->gd_Para[ARG_PUBSCREEN])))
      {
         Class *myclass;

         /* set window dimensions default */
         winbox->Left   = 0;
         winbox->Top    = gd->gd_Screen->BarHeight + 1;
         winbox->Width  = gd->gd_Screen->Width;
         winbox->Height = gd->gd_Screen->Height - winbox->Top;

         gd->gd_WindowAltRect = gd->gd_WindowRect;

         loadprefs(gd,envpath);

         if(DiskFontBase = OpenLibrary("diskfont.library",39))
         {
            DB(("diskfont.library %lx\n",DiskFontBase));
            gd->gd_TextFont = OpenDiskFont(&gd->gd_TextAttr);
            DB(("textfont %lx\n",gd->gd_TextFont));
         }

         DB(("fontname : %s\n",gd->gd_TextAttr.ta_Name));
         DB(("fontsize : %ld\n",gd->gd_TextAttr.ta_YSize));

         gd->gd_InitialRect   = gd->gd_WindowRect;

         if((myclass = initmyguideclass(gd)))
         if((gd->gd_VisualInfo = GetVisualInfoA(gd->gd_Screen,NULL)))
         if((gd->gd_DrawInfo = GetScreenDrawInfo(gd->gd_Screen)))
         {
            gd->gd_NewGadget.ng_VisualInfo = gd->gd_VisualInfo;

            createmenu(gd);

            DB(("file : %s\n",gd->gd_FileBuffer));

            /* load the an object from the file in gd_FileBuffer */
            if(agobj =  NewObject(myclass,NULL,
                                  DTA_Name          ,gd->gd_FileBuffer,
                                  DTA_NodeName      ,nodename,

                                  DTA_GroupID       ,GID_DOCUMENT,
                                  DTA_ARexxPortName ,"AGUIDEXREF",
                                  DTA_TextAttr      ,&gd->gd_TextAttr,

                                  GA_Immediate      ,TRUE,
                                  GA_RelVerify      ,TRUE,
                                  GA_ID             ,GADID_AmigaGuide,
                                  /* set notify attributes for the window */
                                  ICA_TARGET        ,ICTARGET_IDCMP,
                                  TAG_DONE))
            {
               DB(("after newobject\n"));
               gd->gd_AGObject = agobj;

               /* open the window and display the object */
               if(win = OpenWindowTags(NULL,WA_Title        ,prgname,
                                            WA_Left         ,winbox->Left,
                                            WA_Top          ,winbox->Top,
                                            WA_Width        ,winbox->Width,
                                            WA_Height       ,winbox->Height,
                                            WA_MinWidth     ,220,
                                            WA_MinHeight    ,100,
                                            WA_MaxWidth     , -1,
                                            WA_MaxHeight    , -1,
                                            WA_NewLookMenus ,TRUE,
                                            WA_PubScreen    , gd->gd_Screen,
                                            WA_Flags        , WINDOW_FLAGS,
                                            WA_IDCMP        , IDCMP_FLAGS ,
                                            WA_Zoom         , &gd->gd_WindowAltRect,
                                            TAG_DONE))
               {
                  ULONG mticks   = 0;
                  ULONG rcvd;

                  gd->gd_Window  = win;
                  gd->gd_Flags  |= GDF_SYNC;

                  if(gd->gd_Menu)
                     SetMenuStrip(win,gd->gd_Menu);

                  DB(("before propgadgets\n"));

                  createpropgadgets(gd);

                  addmygadgets(gd);

                  SetDTAttrs(agobj,NULL,NULL,
                             GA_Left      ,gd->gd_ObjectBox.Left,
                             GA_Top       ,gd->gd_ObjectBox.Top,
                             GA_RelWidth  ,gd->gd_ObjectBox.Width,
                             GA_RelHeight ,gd->gd_ObjectBox.Height,
                             TAG_DONE);

                  AddDTObject(win,NULL,agobj,0);

                  setprops(gd);

                  DB(("getdtAttrs : %ld , nodename %lx \n",GetDTAttrs(agobj,DTA_Handle,&nodename,TAG_DONE),
                                                            nodename));

                  drawmyline(gd);

                  gd->gd_Running = TRUE;

                  while(gd->gd_Running)
                  {
                     rcvd = Wait((1<<win->UserPort->mp_SigBit) | SIGBREAKF_CTRL_C);

                     if(rcvd & SIGBREAKF_CTRL_C)
                        gd->gd_Running = FALSE;

                     while((msg = GT_GetIMsg(win->UserPort)))
                     {
                        switch(msg->Class)
                        {
                        case IDCMP_MENUPICK: {
                              struct MenuItem *item;
                              UWORD code = msg->Code;

                              while(code != MENUNULL)
                              {
                                 if((item = ItemAddress(gd->gd_Menu,code)))
                                 {
                                    executecmd(gd,(UWORD) GTMENUITEM_USERDATA(item));
                                    code = item->NextSelect;
                                 } else
                                    break;
                              }
                           }
                           break;
                        case IDCMP_RAWKEY:
                           DB(("rawkey : %ld\n",msg->Code));
                           switch(msg->Code)
                           {
                           case SHIFT_TAB:
                              triggermethod(gd,STM_PREV_FIELD);
                              break;
                           default:
                              changedttop(gd,msg->Code,msg->Qualifier);
                           }
                           break;
                        case IDCMP_VANILLAKEY:
                           DB(("ascii : %ld\n",msg->Code));
                           switch(msg->Code)
                           {
                           case CTRL_C:
                           case ESCAPE:
                              gd->gd_Running = FALSE;
                              break;
                           case TABULATOR:
                              triggermethod(gd,STM_NEXT_FIELD);
                              break;
                           case SLASH:
                              triggermethod(gd,STM_RETRACE);
                              break;
                           case BROWSE_LEFT:
                              triggermethod(gd,STM_BROWSE_PREV);
                              break;
                           case RETURN:
                              triggermethod(gd,STM_ACTIVATE_FIELD);
                              break;
                           case BROWSE_RIGHT:
                              triggermethod(gd,STM_BROWSE_NEXT);
                              break;
                           case 'I':
                           case 'i':
                              triggermethod(gd,STM_INDEX);
                              break;
                           case ' ':
                              triggermethod(gd,STM_CONTENTS);
                              break;
                           case 'P':
                           case 'p':
                           case 'S':
                           case 's':
                              ActivateGadget(gd->gd_StringGad,win,NULL);
                              break;
                           case 'C':
                           case 'c':
                              ActivateGadget(gd->gd_CategoryGad,win,NULL);
                              break;
                           }
                           break;
                        case IDCMP_MOUSEMOVE:
                           DB(("mousemove\n"));
                           if(mgad && (mgad->GadgetID == GADID_HorizProp ||
                                       mgad->GadgetID == GADID_VertProp))
                              handleprops(gd,mgad);
                           break;
                        case IDCMP_INTUITICKS:
                           DB(("intuitick\n"));
                           if((mgad) && (mticks > 6))
                              if(mgad->Flags & GFLG_SELECTED)
                                 handlebuttons(gd,mgad,(mticks/3));
                              else
                                 mticks = 6;

                           mticks++;
                           break;
                        case IDCMP_GADGETDOWN:
                           mticks = 0;
                           mgad = (struct Gadget *) msg->IAddress;

                           switch(mgad->GadgetID)
                           {
                           case GADID_HorizProp:
                           case GADID_VertProp:
                              ModifyIDCMP(win,win->IDCMPFlags | IDCMP_MOUSEMOVE);
                              handleprops(gd,mgad);
                              break;
                           default:
                              ModifyIDCMP(win,win->IDCMPFlags | IDCMP_INTUITICKS);
                              handlebuttons(gd,mgad,1);
                           }
                           break;
                        case IDCMP_GADGETUP:
                           mgad   = NULL;

                           gad = msg->IAddress;
                           switch(gad->GadgetID)
                           {
                           case GADID_String:
                              strcpy(gd->gd_String   ,GAD_STRING(gad));
                              strcpy(gd->gd_Category ,GAD_STRING(gd->gd_CategoryGad));

                              setwindowpointer(gd,TRUE);
                              if(parsexref(gd) && gd->gd_Num > 0)
                                 openfile(gd);

                              setwindowpointer(gd,FALSE);
                              break;
                           case GADID_Mode:
                              gd->gd_Matching = msg->Code;
                              break;
                           case GADID_HorizProp:
                           case GADID_VertProp:
                              ModifyIDCMP(win,win->IDCMPFlags & ~IDCMP_MOUSEMOVE);
                              handleprops(gd,gad);
                              break;
                           default:
                              ModifyIDCMP(win,win->IDCMPFlags & ~IDCMP_INTUITICKS);
                           }
                           break;
                        case IDCMP_MOUSEBUTTONS:
                           ModifyIDCMP(win,win->IDCMPFlags & ~IDCMP_INTUITICKS);
                           break;
                        case IDCMP_NEWSIZE:
                           addmygadgets(gd);
                           break;
                        case IDCMP_IDCMPUPDATE:
                           {
                              struct TagItem *tstate = (struct TagItem *) msg->IAddress;
                              struct TagItem *tag;

                              D({
                                 struct TagItem *tags = tstate;
                                 bug("idcmpudate\n");
                                 while((tag = NextTagItem(&tags)))
                                    bug("{0x%08lx,0x%08lx}\n",tag->ti_Tag,tag->ti_Data);
                                });

                              while((tag = NextTagItem(&tstate)))
                              {
                                 switch(tag->ti_Tag)
                                 {
                                 case DTA_Busy:
                                    setwindowpointer(gd,tag->ti_Data);
                                    break;
                                 case DTA_Title:
                                    DB(("new title : %s\n",tag->ti_Data));
                                    SetWindowTitles(win,(STRPTR) tag->ti_Data,(STRPTR) -1);
                                    break;
                                 case DTA_ErrorString:
                                    sprintf(gd->gd_TempBuffer,GetDTString(GetTagData(DTA_ErrorNumber,0,(struct TagItem *) msg->IAddress)),tag->ti_Data);
                                    SetWindowTitles(win,(STRPTR) gd->gd_TempBuffer,(STRPTR) -1);
                                    break;
                                 case DTA_Sync:
                                    if(gd->gd_Flags & GDF_SYNC)
                                    {
                                       SetDTAttrs(gd->gd_AGObject,gd->gd_Window,NULL,
                                                  DTA_TopVert,gd->gd_LastEntry.e_Line - 1,
                                                  TAG_DONE);
                                       RefreshDTObjectA(agobj,win,NULL,NULL);
                                       gd->gd_Flags &= ~GDF_SYNC;
                                    }
                                    break;
                                 }
                              }

                              setprops(gd);
                           }
                           break;
                        case IDCMP_CLOSEWINDOW:
                           /* user cancels the program */
                           gd->gd_Running = FALSE;
                           break;
                        case IDCMP_CHANGEWINDOW:
                           if(msg->Code == CWCODE_MOVESIZE)
                           {
                              if(win->Flags & WFLG_ZOOMED)
                                 gd->gd_WindowAltRect = *((struct IBox *) &win->LeftEdge);
                              else
                                 gd->gd_WindowRect    = *((struct IBox *) &win->LeftEdge);
                           }
                           break;
                        case IDCMP_REFRESHWINDOW:
                           drawmyline(gd);
                           break;
                        }

                        GT_ReplyIMsg(msg);
                     }
                  }

                  RemoveDTObject(win,agobj);

                  CloseWindow(win);
               }
               DB(("before disposeobject\n"));
               DisposeObject(agobj);
               DB(("after disposeobject\n"));
            } else
            {
               PrintFault(IoErr(),"AGuideXRef:");
               if(GetDTString(IoErr()))
                  Printf (GetDTString(IoErr()),gd->gd_FileBuffer);
            }

            for(i = 0 ; i < 4 ; i++)
            {
               if(gd->gd_Buttons[i])
                  DisposeObject(gd->gd_Buttons[i]);

               if(gd->gd_Images[i])
                  DisposeObject(gd->gd_Images[i]);
            }

            if(gd->gd_HorizProp)
               DisposeObject(gd->gd_HorizProp);

            if(gd->gd_VertProp)
               DisposeObject(gd->gd_VertProp);

            if(gd->gd_Menu)
               FreeMenus(gd->gd_Menu);

            if(gd->gd_NewMenu)
               FreeVec(gd->gd_NewMenu);

            FreeScreenDrawInfo(gd->gd_Screen,gd->gd_DrawInfo);
         }

         if(gd->gd_VisualInfo);
            FreeVisualInfo(gd->gd_VisualInfo);

         if(myclass)
            freemyguideclass(gd,myclass);

         UnlockPubScreen(NULL,gd->gd_Screen);
      }

      if(LocaleBase)
      {
         if(gd->gd_Catalog)
            CloseCatalog(gd->gd_Catalog);

         CloseLibrary(LocaleBase);
      }

      if(gd->gd_TextFont)
         CloseFont(gd->gd_TextFont);

      /* close diskbase libraries */
      if(DiskFontBase)
         CloseLibrary(DiskFontBase);
      if(AslBase)
         CloseLibrary(AslBase);

      CloseLibrary(DataTypesBase);

      /* close rom libraries */
      CloseLibrary(GadToolsBase);
   }
}
/*FE*/

/*FS*//*"void changedttop(struct GlobalData *gd,UWORD code,UWORD qual)"*/
void changedttop(struct GlobalData *gd,UWORD code,UWORD qual)
{
   LONG direct = 1;
   LONG num = 0;
   LONG top;
   LONG add;
   LONG visible;
   LONG total;

   if(code == CURSORDOWN || code == CURSORUP)
   {
      if(code == CURSORUP)
         direct = -1;

      num = GetDTAttrs(gd->gd_AGObject,DTA_TopVert      ,&top,
                                       DTA_VertUnit     ,&add,
                                       DTA_VisibleVert  ,&visible,
                                       DTA_TotalVert    ,&total,
                                       TAG_DONE);
   } else if(code == CURSORLEFT || code == CURSORRIGHT)
   {
      if(code == CURSORLEFT)
         direct = -1;

      num = GetDTAttrs(gd->gd_AGObject,DTA_TopHoriz     ,&top,
                                       DTA_HorizUnit    ,&add,
                                       DTA_VisibleHoriz ,&visible,
                                       DTA_TotalHoriz   ,&total,
                                       TAG_DONE);
   }

   if(num == 4)
   {
      if(qual & IEQUALIFIER_ALT)
      {
         if(direct == -1)
            top = 0;
         else
            top = total;
      } else if(qual & IEQUALIFIER_SHIFT)
      {
         if(direct == -1)
            top -= visible;
         else             
            top += visible;
      } else
      {
         if(direct == -1)
            top--;
         else
            top++;
      }

      if(top < 0)
         top = 0;

      if(code == CURSORDOWN || code == CURSORUP)
      {
         SetDTAttrs(gd->gd_AGObject,gd->gd_Window,NULL,DTA_TopVert ,top,TAG_DONE);
         SetGadgetAttrs(gd->gd_VertProp,gd->gd_Window,NULL,PGA_Top ,top,TAG_DONE);
      } else
      {
         SetDTAttrs(gd->gd_AGObject,gd->gd_Window,NULL,DTA_TopHoriz,top,TAG_DONE);
         SetGadgetAttrs(gd->gd_HorizProp,gd->gd_Window,NULL,PGA_Top ,top,TAG_DONE);
      }
   }
}
/*FE*/

/*FS*//*"void addmygadgets(struct GlobalData *gd)"*/
void addmygadgets(struct GlobalData *gd)
{
   struct Window *win = gd->gd_Window;
   struct NewGadget *ng = &gd->gd_NewGadget;
   struct TextFont *tf;

   struct Gadget *gad;

   if(gd->gd_FirstGadget)
   {
      if(gd->gd_StringGad)
         strcpy(gd->gd_String  ,GAD_STRING(gd->gd_StringGad));

      if(gd->gd_CategoryGad)
         strcpy(gd->gd_Category,GAD_STRING(gd->gd_CategoryGad));

      RemoveGList(win,gd->gd_FirstGadget,-1);

      DB(("eraserect\n"));
      EraseRect(win->RPort,win->BorderLeft,ng->ng_TopEdge - 3,
                           win->Width - win->BorderRight - 1,ng->ng_TopEdge + gd->gd_OldFHeight + FREEPIXELHEIGHT);
      FreeGadgets(gd->gd_FirstGadget);
      gd->gd_FirstGadget = NULL;
   }

   /* calculate the amigaguide object rectangle */
   gd->gd_ObjectBox.Left   = win->BorderLeft + 2;
   gd->gd_ObjectBox.Top    = win->BorderTop  + 1;
   gd->gd_ObjectBox.Width  = - win->BorderRight  - win->BorderLeft - 3;
   gd->gd_ObjectBox.Height = - win->BorderBottom - win->BorderTop - DEFAULT_FONTHEIGHT - FREEPIXELHEIGHT;

   gd->gd_NumGadgets = 0;

   ng->ng_TextAttr = gd->gd_Screen->Font;

   if (tf = OpenFont(ng->ng_TextAttr))
   {
      UWORD fheight = tf->tf_YSize;
      struct RastPort rp;
      UWORD cycle_width;

      gd->gd_OldFHeight = fheight;

      gd->gd_ObjectBox.Height = - win->BorderBottom - win->BorderTop - fheight - 9;

      InitRastPort(&rp);
      SetFont(&rp, tf);

      cycle_width = calctexts(gd, &rp, search_modes) + CYCLEGADGET_WIDTH;

      gd->gd_CategoryGad = NULL;
      gd->gd_StringGad   = NULL;

      if((gad = CreateContext(&gd->gd_FirstGadget)))
      {
         UWORD width = win->Width - (win->BorderLeft + win->BorderRight + 3 * INTERWIDTH) - cycle_width;

         DB(("width : %ld\n",width));

         /* create category string gadget */
         ng->ng_LeftEdge = win->BorderLeft + (INTERWIDTH / 2);
         ng->ng_TopEdge  = win->Height - win->BorderBottom - fheight - 5;
         ng->ng_Height   = fheight + 4;

         if((width / 3) > 40)
         {
            ng->ng_Width    = width / 3;
            ng->ng_GadgetID = GADID_Category;

            if((gad = CreateGadget(STRING_KIND,gad,ng,
                                   GTST_String   ,gd->gd_Category,
                                   GTST_MaxChars ,40,
                                   TAG_DONE)))
            {
               gd->gd_CategoryGad = gad;
               gd->gd_NumGadgets++;

               DB(("category gad : %lx\n",gad));

               ng->ng_LeftEdge += ng->ng_Width + INTERWIDTH;
               ng->ng_Width     = ng->ng_Width * 2;
            }
         } else
            ng->ng_Width = width + INTERWIDTH;

         /* create search string gadget */
         ng->ng_GadgetID  = GADID_String;

         if((gad = CreateGadget(STRING_KIND,gad,ng,
                                GTST_String   ,gd->gd_String,
                                GTST_MaxChars ,256,
                                TAG_DONE)))
         {
            gd->gd_StringGad = gad;
            gd->gd_NumGadgets++;

            ng->ng_LeftEdge += ng->ng_Width + INTERWIDTH;
            ng->ng_Width     = cycle_width;

            ng->ng_GadgetID  = GADID_Mode;

            if((gad = CreateGadget(CYCLE_KIND,gad,ng,GTCY_Labels,search_modes,
                                                     GTCY_Active,gd->gd_Matching,
                                                     TAG_DONE)))
               gd->gd_NumGadgets++;

            DB(("create cycle : %lx\n",gad));

         }
      }

      if(!gad)
      {
         FreeGadgets(gd->gd_FirstGadget);
         gd->gd_FirstGadget = NULL;
      }else
      {
         AddGList(win,gd->gd_FirstGadget,-1,-1,NULL);
         RefreshGList(gd->gd_FirstGadget,win,NULL,gd->gd_NumGadgets);
         GT_RefreshWindow(gd->gd_Window,NULL);
      }
      
      RefreshWindowFrame(win);

      CloseFont(tf);
   }
}
/*FE*/
/*FS*/ /*"void createmenu(struct GlobalData *gd) "*/
void createmenu(struct GlobalData *gd)
{
   ULONG num = (sizeof(menudef)/sizeof(struct MenuDef));

   if((gd->gd_NewMenu = AllocVec(sizeof(struct NewMenu) * (num+1),MEMF_CLEAR)))
   {
      struct NewMenu *ptr = gd->gd_NewMenu;
      struct MenuDef *md  = menudef;

      while(num)
      {
         ptr->nm_Type = md->md_MenuType;
         if(ptr->nm_Type == NM_TITLE)
            ptr->nm_Label = appStrings[md->md_MenuTextID];
         else if(md->md_MenuTextID != (ULONG) NM_BARLABEL)
         {
            ptr->nm_CommKey = appStrings[md->md_MenuTextID];
            ptr->nm_Label   = ptr->nm_CommKey + 2;
            if(*ptr->nm_CommKey == ' ')
               ptr->nm_CommKey = NULL;
         } else
            ptr->nm_Label   = (STRPTR) NM_BARLABEL;

         ptr->nm_Flags = md->md_MenuFlags;
         ptr->nm_UserData = (APTR) md->md_MenuCmd;
         ptr++;
         md++;
         num--;
      }

      if((gd->gd_Menu = CreateMenus(gd->gd_NewMenu,GTMN_FullMenu,TRUE,TAG_DONE)))
         if(!LayoutMenus(gd->gd_Menu,gd->gd_VisualInfo,GTMN_NewLookMenus,TRUE,TAG_DONE))
         {
            FreeVec(gd->gd_NewMenu);
            gd->gd_NewMenu = NULL;
            FreeMenus(gd->gd_Menu);
            gd->gd_Menu = NULL;
         }
   }
}
/*FE*/
/*FS*/ /*"void createpropgadgets(struct GlobalData *gd) "*/
void createpropgadgets(struct GlobalData *gd)
{
   struct Gadget *tmpgad = NULL;
   struct Window *win    = gd->gd_Window;
   ULONG i;

   for(i = 0 ; i < 4 ; i++)
   {
      if((gd->gd_Images[i] = (struct Image *) NewObject(NULL,SYSICLASS,
                                                        SYSIA_DrawInfo,  gd->gd_DrawInfo,
                                                        SYSIA_Which,     i + LEFTIMAGE,
                                                        SYSIA_Size,      SYSISIZE_MEDRES,
                                                        TAG_DONE)))
      {
         if(gd->gd_Buttons[i] = (struct Gadget *) NewObject(NULL,BUTTONGCLASS,
                                                  GA_ID,          GADID_LeftButton + i,
                                                  GA_Immediate,   TRUE,
                                                  GA_RelVerify,   TRUE,
                                                  GA_RelRight,    abox[i].Left,
                                                  GA_RelBottom,   abox[i].Top,
                                                  GA_Width,       abox[i].Width,
                                                  GA_Height,      abox[i].Height,
                                                  GA_Image,       gd->gd_Images[i],
                                                  GA_BottomBorder,(i % 2) == 0,
                                                  GA_RightBorder, (i % 2) == 1,
                                                  USE_TAG(GA_Previous,(tmpgad)),    tmpgad,
                                                  TAG_END))
         {
            tmpgad = gd->gd_Buttons[i];
         }
      } else
         break;
   }

   if(i == 4)
   {
      if(gd->gd_HorizProp = (struct Gadget *) NewObject(NULL,PROPGCLASS,
                                               GA_ID,          GADID_HorizProp,
                                               GA_Immediate,   TRUE,
                                               GA_RelVerify,   TRUE,
                                               PGA_Freedom,    FREEHORIZ,
                                               PGA_Borderless, TRUE,
                                               PGA_NewLook,    TRUE,
                                               GA_RelBottom,   -win->BorderBottom+3,
                                               GA_Left,        win->BorderLeft+2,
                                               GA_Height,      win->BorderBottom-4,
                                               GA_RelWidth,    -win->BorderLeft-win->BorderRight- 2 * 16 - 4,
                                               GA_BottomBorder,TRUE,
                                               GA_FollowMouse, TRUE,
                                               GA_Previous,    tmpgad,
                                               TAG_END))
      if(gd->gd_VertProp = (struct Gadget *) NewObject(NULL,PROPGCLASS,
                                               GA_ID,          GADID_VertProp,
                                               GA_Immediate,   TRUE,
                                               GA_RelVerify,   TRUE,
                                               PGA_Freedom,    FREEVERT,
                                               PGA_Borderless, TRUE,
                                               PGA_NewLook,    TRUE,
                                               GA_RelRight,    -win->BorderRight+5,
                                               GA_Top,          win->BorderTop+1,
                                               GA_Width,        win->BorderRight-8,
                                               GA_RelHeight,   -win->BorderBottom - win->BorderTop- 2 * 10 - 4,
                                               GA_RightBorder, TRUE,
                                               GA_FollowMouse, TRUE,
                                               GA_Previous,    tmpgad,
                                               TAG_END))
      {
         AddGList(win,gd->gd_Buttons[0],-1,-1,NULL);
         RefreshGList(gd->gd_Buttons[0],win,NULL,-1);
      }
   }
}
/*FE*/
/*FS*/ /*"void setprops(struct GlobalData *gd) "*/
void setprops(struct GlobalData *gd)
{
   ULONG ytop,yvisible,ytotal;
   ULONG xtop,xvisible,xtotal;

   if(GetDTAttrs(gd->gd_AGObject,DTA_TopVert      ,&ytop,
                                 DTA_VisibleVert  ,&yvisible,
                                 DTA_TotalVert    ,&ytotal,
                                 DTA_TopHoriz     ,&xtop,
                                 DTA_VisibleHoriz ,&xvisible,
                                 DTA_TotalHoriz   ,&xtotal,
                                 TAG_DONE) == 6)
   {
      SetGadgetAttrs(gd->gd_HorizProp,gd->gd_Window,NULL,
                     PGA_Top      ,xtop,
                     PGA_Visible  ,xvisible,
                     PGA_Total    ,xtotal,
                     TAG_DONE);

      SetGadgetAttrs(gd->gd_VertProp,gd->gd_Window,NULL,
                     PGA_Top      ,ytop,
                     PGA_Visible  ,yvisible,
                     PGA_Total    ,ytotal,
                     TAG_DONE);
   }
}
/*FE*/
/*FS*/ /*"void drawmyline(struct GlobalData *gd) "*/
void drawmyline(struct GlobalData *gd)
{
   struct Window   *win = gd->gd_Window;
   struct RastPort *rp  = win->RPort;
   UWORD y = gd->gd_NewGadget.ng_TopEdge - 3;

   SetDrMd(rp,JAM1);
   SetAPen(rp,gd->gd_DrawInfo->dri_Pens[SHINEPEN]);

   Move(rp,win->BorderLeft + 2,y);
   Draw(rp,win->Width - win->BorderRight - 2,y);
   SetAPen(rp,gd->gd_DrawInfo->dri_Pens[SHADOWPEN]);
   Move(rp,win->BorderLeft + 2,y + 1);
   Draw(rp,win->Width - win->BorderRight - 2,y + 1);
}
/*FE*/

/*FS*/ /*"void handlebuttons(struct GlobalData *gd,struct Gadget *mgad,UWORD add) "*/
void handlebuttons(struct GlobalData *gd,struct Gadget *mgad,WORD add)
{
   struct Window *win   = gd->gd_Window;
   LONG top;

   switch(mgad->GadgetID)
   {
   case GADID_LeftButton:
   case GADID_RightButton:
      if(mgad->GadgetID == GADID_LeftButton)
         add *= -1;

      if(GetAttr(PGA_Top,gd->gd_HorizProp,(ULONG *) &top))
      {
         top += add;

         if(top < 0)
            top = 0;

         SetGadgetAttrs(gd->gd_HorizProp,win,NULL,PGA_Top,top,TAG_DONE);
         SetDTAttrs(gd->gd_AGObject,win,NULL,DTA_TopHoriz,top,TAG_DONE);
      }
      break;
   case GADID_UpButton:
   case GADID_DownButton:
      /* vertical scroll a little bit slower */
      add /= 2;
      if(add == 0)
         add = 1;

      if(mgad->GadgetID == GADID_UpButton)
         add *= -1;

      if(GetAttr(PGA_Top,gd->gd_VertProp,(ULONG *) &top))
      {
         top += add;

         if(top < 0)
            top = 0;

         SetGadgetAttrs(gd->gd_VertProp,win,NULL,PGA_Top,top,TAG_DONE);
         SetDTAttrs(gd->gd_AGObject,win,NULL,DTA_TopVert,top,TAG_DONE);
      }
      break;
   }
}
/*FE*/
/*FS*/ /*"void handleprops(struct GlobalData *gd,struct Gadget *gad) "*/
void handleprops(struct GlobalData *gd,struct Gadget *gad)
{
   LONG top;

   if(GetAttr(PGA_Top,gad, (ULONG *) &top))
   {
      if(gad->GadgetID == GADID_HorizProp)
         SetDTAttrs(gd->gd_AGObject,gd->gd_Window,NULL,DTA_TopHoriz,top,TAG_DONE);
      else
         SetDTAttrs(gd->gd_AGObject,gd->gd_Window,NULL,DTA_TopVert,top,TAG_DONE);
   }
}
/*FE*/

/*FS*/ /*"void saveprefs(struct GlobalData *gd,STRPTR path) "*/
void saveprefs(struct GlobalData *gd,STRPTR path)
{
   UBYTE name[MAXPUBSCREENNAME];
   BPTR fh;
   
   if(getpubscreenname(gd->gd_Screen,name))
   {
      BPTR lock;

      if(!(lock = Lock(path,SHARED_LOCK)))
         lock = CreateDir(path);
      UnLock(lock);

      strcpy(gd->gd_TempBuffer,path);
      if(AddPart(gd->gd_TempBuffer,name,sizeof(gd->gd_TempBuffer)))
         if((fh = Open(gd->gd_TempBuffer,MODE_NEWFILE)))
         {
            UWORD fontlen = strlen(gd->gd_FontName) + 1;

            /* write window dimensions */
            Write(fh,&gd->gd_WindowRect   ,sizeof(gd->gd_WindowRect));
            Write(fh,&gd->gd_WindowAltRect,sizeof(gd->gd_WindowAltRect));

            /* write actual font */
            Write(fh,&gd->gd_TextAttr.ta_YSize,sizeof(gd->gd_TextAttr.ta_YSize));
            Write(fh,&fontlen,sizeof(fontlen));
            Write(fh,gd->gd_FontName,fontlen);
            Close(fh);
         }
   }
}
/*FE*/
/*FS*/ /*"void loadprefs(struct GlobalData *gd,STRPTR path) "*/
void loadprefs(struct GlobalData *gd,STRPTR path)
{
   UBYTE name[MAXPUBSCREENNAME];
   BPTR fh;
   
   if(getpubscreenname(gd->gd_Screen,name))
   {
      strcpy(gd->gd_TempBuffer,path);
      if(AddPart(gd->gd_TempBuffer,name,sizeof(gd->gd_TempBuffer)))
         if((fh = Open(gd->gd_TempBuffer,MODE_OLDFILE)))
         {
            UWORD fontlen = 0;

            /* read window dimensions */
            Read(fh,&gd->gd_WindowRect   ,sizeof(gd->gd_WindowRect));
            Read(fh,&gd->gd_WindowAltRect,sizeof(gd->gd_WindowAltRect));

            /* read font setting */
            Read(fh,&gd->gd_TextAttr.ta_YSize,sizeof(gd->gd_TextAttr.ta_YSize));
            Read(fh,&fontlen,sizeof(fontlen));
            Read(fh,gd->gd_FontName,fontlen);

            Close(fh);
         }
   }
}
/*FE*/

/*FS*/ /*"void openfile(struct GlobalData *gd) "*/
void openfile(struct GlobalData *gd)
{
   struct TagItem tags[2] = {
      {DTA_TopVert,0},
      {TAG_DONE,}};

   if(gd->gd_Num == 0)
      strcpy(gd->gd_FileBuffer,"xref.library_xreffile@main");
   else if(gd->gd_Num > 1)
      strcat(gd->gd_FileBuffer,"/main");
   else
   {
      sprintf(gd->gd_FileBuffer,"%s%s/%s",gd->gd_LastEntry.e_Path,
                                          gd->gd_LastEntry.e_File,
                                          gd->gd_LastEntry.e_NodeName);
   }

   tags[0].ti_Data = gd->gd_LastEntry.e_Line;

   DB(("node : %s\n"
         "line : %ld\n",gd->gd_FileBuffer,gd->gd_LastEntry.e_Line));

   gd->gd_Flags |= GDF_SYNC;
   DoDTMethod(gd->gd_AGObject,gd->gd_Window,NULL,DTM_GOTO,
                                                 NULL,
                                                 gd->gd_FileBuffer,
                                                 tags);
}
/*FE*/
/*FS*/ /*"void triggermethod(struct GlobalData *gd,ULONG triggermethod) "*/
void triggermethod(struct GlobalData *gd,ULONG triggermethod)
{
   DoDTMethod(gd->gd_AGObject,gd->gd_Window,NULL,
              DTM_TRIGGER,
              NULL,
              triggermethod,
              NULL);
}
/*FE*/

/*FS*/ /*"void executecmd(struct GlobalData *gd,UWORD cmd) "*/
void executecmd(struct GlobalData *gd,UWORD cmd)
{
   struct Window *win = gd->gd_Window;
   Object *obj        = gd->gd_AGObject;

   switch(cmd)
   {
   case MYCMD_OPEN:
      if(filerequest(gd,TXT_OPEN_TITLE,0))
      {
         strcat(gd->gd_FileBuffer,"/main");
         openfile(gd);
      }
      break;
   case MYCMD_SAVEAS:
      {
         BPTR fh;
         if(filerequest(gd,TXT_SAVEAS_TITLE,FRF_DOSAVEMODE))
            if((fh = Open(gd->gd_FileBuffer,MODE_NEWFILE)))
            {
               DoDTMethod(obj,win,NULL,DTM_WRITE,
                                       NULL,
                                       fh,
                                       DTWM_RAW,
                                       NULL);
               Close(fh);
            }
      }
      break;
   case MYCMD_PRINT:
      break;
   case MYCMD_ABOUT:
      easyrequest(gd,TXT_ABOUTTEXT,TXT_CONTINUE,vstring);
      break;
   case MYCMD_QUIT:
      gd->gd_Running = FALSE;
      break;
   case MYCMD_COPY:
      DoDTMethod(obj,win,NULL,DTM_COPY,NULL);
      break;
   case MYCMD_CLEARSELECTED:
      DoDTMethod(obj,win,NULL,DTM_CLEARSELECTED,NULL);
      break;
   case MYCMD_MINIMIZE:
      ChangeWindowBox(win,win->LeftEdge ,win->TopEdge,
                          win->MinWidth ,win->MinHeight);
      break;
   case MYCMD_NORMAL:
      ChangeWindowBox(win,gd->gd_InitialRect.Left  ,gd->gd_InitialRect.Top,
                          gd->gd_InitialRect.Width ,gd->gd_InitialRect.Height);
      break;
   case MYCMD_MAXIMIZE:
      ChangeWindowBox(win,0                  ,win->WScreen->BarHeight + 1,
                          win->WScreen->Width,win->WScreen->Height - win->WScreen->BarHeight - 1);
      break;
   case MYCMD_FONTS:
      fontrequest(gd,TXT_FONT_TITLE);
      break;
   case MYCMD_SAVEDEFAULT:
      saveprefs(gd,arcpath);
      saveprefs(gd,envpath);
      break;
   }
}
/*FE*/

/* -------------------------- support functions --------------------------- */

/*FS*/ /*"void easyrequest(struct GlobalData *gd,ULONG textid,ULONG gadid,APTR args,...) "*/
void easyrequest(struct GlobalData *gd,ULONG textid,ULONG gadid,APTR args,...)
{
   struct EasyStruct easy;

   easy.es_StructSize   = sizeof(struct EasyStruct);
   easy.es_Flags        = 0;
   easy.es_Title        = prgname;
   easy.es_TextFormat   = appStrings[textid];
   easy.es_GadgetFormat = appStrings[gadid];

   EasyRequestArgs(gd->gd_Window,&easy,NULL,&args);
}
/*FE*/
/*FS*/ /*"BOOL getpubscreenname(struct Screen *screen,STRPTR name) "*/
BOOL getpubscreenname(struct Screen *screen,STRPTR name)
{
   struct PubScreenNode *screennode;
   struct List *list;
   BOOL retval = FALSE;

   if(list = LockPubScreenList())
      for(screennode = (struct PubScreenNode *) list->lh_Head ;
          screennode ;
          screennode = (struct PubScreenNode *) screennode->psn_Node.ln_Succ)
      {
         if(screennode->psn_Screen == screen)
         {
            strcpy(name,screennode->psn_Node.ln_Name);
            retval = TRUE;
            break;
         }
      }

   UnlockPubScreenList();

   return(retval);
}
/*FE*/
/*FS*/ /*"BOOL filerequest(struct GlobalData *gd,ULONG titleid,ULONG flags) "*/
BOOL filerequest(struct GlobalData *gd,ULONG titleid,ULONG flags)
{
   struct FileRequester *filereq;
   BOOL retval = FALSE;

   if(AslBase)
      if(filereq=AllocAslRequestTags(ASL_FileRequest,
                                     ASLFR_Flags1,          flags | FRF_DOPATTERNS,
                                     ASLFR_Window,          gd->gd_Window,
                                     ASLFR_TitleText,       appStrings[titleid],
                                     ASLFR_InitialDrawer,   gd->gd_Directory,
                                     ASLFR_InitialFile,     FilePart(gd->gd_FileBuffer),
                                     ASLFR_InitialHeight,   gd->gd_Screen->Height - 50,
                                     TAG_DONE))
      {
         if(retval = AslRequest(filereq,NULL))
         {
            strcpy(gd->gd_Directory,filereq->rf_Dir);
            strcpy(gd->gd_FileBuffer,filereq->rf_Dir);
            if(!AddPart(gd->gd_FileBuffer,filereq->rf_File,sizeof(gd->gd_FileBuffer)))
               retval = FALSE;

         }
         FreeAslRequest(filereq);
      }
   return(retval);
}
/*FE*/
/*FS*/ /*"void fontrequest(struct GlobalData *gd,ULONG titleid) "*/
void fontrequest(struct GlobalData *gd,ULONG titleid)
{
   struct FontRequester *fontreq;

   if(AslBase)
      if(fontreq = AllocAslRequestTags(ASL_FontRequest,
                                       ASLFO_Window         ,gd->gd_Window,
                                       ASLFO_TitleText      ,appStrings[titleid],
                                       ASLFO_InitialName    ,gd->gd_TextAttr.ta_Name,
                                       ASLFO_InitialSize    ,gd->gd_TextAttr.ta_YSize,
                                       ASLFO_InitialStyle   ,gd->gd_TextAttr.ta_Style,
                                       ASLFO_InitialHeight  ,gd->gd_Screen->Height - 50,
                                       TAG_DONE))
      {
         if(AslRequest(fontreq,NULL))
         {
            strcpy(gd->gd_FontName,fontreq->fo_Attr.ta_Name);
            gd->gd_TextAttr.ta_YSize = fontreq->fo_Attr.ta_YSize;

            if(gd->gd_TextFont)
               CloseFont(gd->gd_TextFont);

            gd->gd_TextFont = NULL;

            if((gd->gd_TextFont = OpenFont(&gd->gd_TextAttr)))
            {
               DB(("set new font\n"));
               SetDTAttrs(gd->gd_AGObject,gd->gd_Window,NULL,DTA_TextAttr,&gd->gd_TextAttr,TAG_DONE);

               DoDTMethod(gd->gd_AGObject,gd->gd_Window,NULL,GM_LAYOUT,NULL,0);
            }

         }
         FreeAslRequest(fontreq);
      }
}
/*FE*/
/*FS*/ /*"void setwindowpointer(struct GlobalData *gd,BOOL busy) "*/
void setwindowpointer(struct GlobalData *gd,BOOL busy)
{
   if(busy)
      SetWindowPointer(gd->gd_Window,WA_BusyPointer,TRUE,TAG_DONE);
   else
      SetWindowPointer(gd->gd_Window,TAG_DONE);
}
/*FE*/
/*FS*//*"UWORD calctexts(struct GlobalData *gd, struct RastPort *rp, UBYTE **texts)"*/
UWORD calctexts(struct GlobalData *gd, struct RastPort *rp, UBYTE **texts)
{
   USHORT i,max,x;

   for(i=0,max=0;texts[i];i++)
   {
      x = TextLength(rp,texts[i],strlen((char*)texts[i]));
      if (x>max) max=x;
   }
   return(max);
}
/*FE*/

/* ---------------------------- main function ----------------------------- */

/*FS*/ /*"int main(int ac,char *av[]) "*/
int main(int ac,char *av[])
{
   struct ExtRDArgs eargs = {NULL};
   struct GlobalData *gd;

   ULONG para[ARG_MAX];
   STRPTR obj = prgname;
   LONG err;

   LONG i;

   /* clear args buffer */
   for(i = 0 ; i < ARG_MAX ; i++)
      para[i] = 0;

   eargs.erda_Template      = template;
   eargs.erda_Parameter     = para;
   eargs.erda_FileParameter = ARG_FILE;

   if((err = ExtReadArgs(ac,av,&eargs)) == 0)
   {
      if(gd = AllocMem(sizeof(struct GlobalData) , MEMF_CLEAR))
      {
         if((GfxBase = OpenLibrary("graphics.library",39)))
         {
            obj = "xref.library";
            if(XRefBase = OpenLibrary(obj,0))
            {
               GetCurrentDirName(gd->gd_Directory,sizeof(gd->gd_Directory));

               getstdargs(gd,para);

               /* use cache dir as default asl dir */
               if(para[ARG_CACHEDIR])
                  strcpy(gd->gd_Directory,(STRPTR) para[ARG_CACHEDIR]);

               /* get system defautl font */
               #undef  GfxBase
               gd->gd_TextFont = ((struct GfxBase *) gd->gd_GfxBase)->DefaultFont;
               #define GfxBase gd->gd_GfxBase

               strcpy(gd->gd_FontName,gd->gd_TextFont->tf_Message.mn_Node.ln_Name);

               gd->gd_TextAttr.ta_Name  = gd->gd_FontName;
               gd->gd_TextAttr.ta_YSize = gd->gd_TextFont->tf_YSize;
               gd->gd_TextAttr.ta_Style = gd->gd_TextFont->tf_Style;
               gd->gd_TextAttr.ta_Flags = gd->gd_TextFont->tf_Flags;

               /* get user defined font */
               if(para[ARG_FONTNAME])
               {
                  gd->gd_Flags |= GDF_FORCEFONT;

                  strcpy(gd->gd_FontName,(STRPTR) para[ARG_FONTNAME]);
                  gd->gd_TextAttr.ta_Style = FS_NORMAL;
                  gd->gd_TextAttr.ta_Flags = 0;
               }

               if(para[ARG_FONTSIZE])
                  gd->gd_TextAttr.ta_YSize = *((LONG *) para[ARG_FONTSIZE]);

               parsexref(gd);

               openamigaguide(gd);

               /* last object that caused an error */
               obj = gd->gd_Object;
               err = gd->gd_Error;

               /* delete all tempory files */
               while(gd->gd_TempCount > 0)
               {
                  gd->gd_TempCount--;
                  DeleteFile(tmpname(gd));
                  gd->gd_TempCount--;
               }
               CloseLibrary(XRefBase);
            }
            CloseLibrary(GfxBase);
         }
         FreeMem(gd,sizeof(struct GlobalData));
      } else
         err = ERROR_NO_FREE_STORE;
   }
   ExtFreeArgs(&eargs);

   if(!err)
      err = IoErr();

   if(err)
   {
      if(ac == 0)
         showerror(prgname,obj,err);
      else
         PrintFault(err,obj);
      return(RETURN_ERROR);
   }

   return(RETURN_OK);
}
/*FE*/

