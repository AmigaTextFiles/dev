/*
 * dockwindow.c  V2.1
 *
 * dock edit window handling
 *
 * (c) 1990-1993 Stefan Becker
 */

#include "ToolManagerConf.h"

struct DockNode {
                 struct Node      dn_Node;
                 ULONG            dn_Flags;
                 char            *dn_HotKey;
                 char            *dn_PubScreen;
                 char            *dn_Title;
                 struct TextAttr  dn_Font;
                 char            *dn_FontDesc;
                 LONG             dn_XPos;
                 LONG             dn_YPos;
                 ULONG            dn_Columns;
                 struct List     *dn_ToolsList;
                };

/* Window data */
static struct Gadget *gl;             /* Gadget list */
static struct Window *w;              /* Window */
static struct MsgPort *wp;            /* Window user port */
static UWORD ww,wh;                   /* Window size */
static struct DockNode *CurrentNode;
static ULONG CurrentGadgetNum;
static BOOL ReqOpen;
static struct Requester DummyReq;
#define WINDOW_IDCMP (IDCMP_CLOSEWINDOW|IDCMP_REFRESHWINDOW|BUTTONIDCMP|\
                      CHECKBOXIDCMP|STRINGIDCMP|IDCMP_VANILLAKEY)

/* Gadget data */
#define GAD_NAME_STR     0 /* Gadgets with labels (left side) */
#define GAD_TITLE_STR    1
#define GAD_HOTKEY_STR   2
#define GAD_XPOS_INT     3
#define GAD_YPOS_INT     4
#define GAD_COLUMNS_INT  5

#define GAD_POSITION     6 /* Cycle gadget */

#define GAD_PSCREEN_BUT  7 /* Gadgets with labels (right side) */
#define GAD_PSCREEN_TXT  8
#define GAD_FONT_BUT     9

#define GAD_PSCREEN_STR 10
#define GAD_FONT_TXT    11

#define GAD_TOOLS       12 /* Button gadget */

#define GAD_ACTIVATED   13 /* Checkbox gadgets */
#define GAD_BACKDROP    14
#define GAD_CENTERED    15
#define GAD_FRONTMOST   16
#define GAD_MENU        17
#define GAD_PATTERN     18
#define GAD_POPUP       19
#define GAD_STICKY      20
#define GAD_TEXT        21
#define GAD_VERTICAL    22

#define GAD_OK          23 /* Button gadgets */
#define GAD_CANCEL      24
#define GADGETS         25
static struct GadgetData gdata[GADGETS];

/* Gadget tags */
static struct TagItem nametags[]={GTST_String,   NULL,
                                  GTST_MaxChars, SGBUFLEN,
                                  TAG_DONE};

static struct TagItem hotktags[]={GTST_String,   NULL,
                                  GTST_MaxChars, SGBUFLEN,
                                  TAG_DONE};

static struct TagItem pbsctags[]={GTST_String,   NULL,
                                  GTST_MaxChars, SGBUFLEN,
                                  TAG_DONE};

static struct TagItem fonttags[]={GTTX_Text,   NULL,
                                  GTTX_Border, TRUE,
                                  TAG_DONE};

static struct TagItem titletags[]={GTST_String,   NULL,
                                   GTST_MaxChars, SGBUFLEN,
                                   TAG_DONE};

static struct TagItem xpostags[]={GTIN_Number,   0,
                                  GTIN_MaxChars, 10,
                                  TAG_DONE};

static struct TagItem ypostags[]={GTIN_Number,   0,
                                  GTIN_MaxChars, 10,
                                  TAG_DONE};

static char *cyclelabels[3]={NULL, NULL, NULL};
static struct TagItem cycletags[]={GTCY_Labels, (ULONG) cyclelabels,
                                   GTCY_Active, 0,
                                   TAG_DONE};

static struct TagItem colstags[]={GTIN_Number,   0,
                                  GTIN_MaxChars, 10,
                                  TAG_DONE};

static struct TagItem actitags[]={GTCB_Checked, FALSE,
                                  GTCB_Scaled,  TRUE,
                                  TAG_DONE};

static struct TagItem backdtags[]={GTCB_Checked, FALSE,
                                   GTCB_Scaled,  TRUE,
                                   TAG_DONE};

static struct TagItem centtags[]={GTCB_Checked, FALSE,
                                  GTCB_Scaled,  TRUE,
                                  TAG_DONE};

static struct TagItem fronttags[]={GTCB_Checked, FALSE,
                                   GTCB_Scaled,  TRUE,
                                   TAG_DONE};

static struct TagItem menutags[]={GTCB_Checked, FALSE,
                                  GTCB_Scaled,  TRUE,
                                  TAG_DONE};

static struct TagItem patttags[]={GTCB_Checked, FALSE,
                                  GTCB_Scaled,  TRUE,
                                  TAG_DONE};

static struct TagItem popuptags[]={GTCB_Checked, FALSE,
                                   GTCB_Scaled,  TRUE,
                                   TAG_DONE};

static struct TagItem stickytags[]={GTCB_Checked, FALSE,
                                    GTCB_Scaled,  TRUE,
                                    TAG_DONE};

static struct TagItem texttags[]={GTCB_Checked, FALSE,
                                  GTCB_Scaled,  TRUE,
                                  TAG_DONE};

static struct TagItem verttags[]={GTCB_Checked, FALSE,
                                  GTCB_Scaled,  TRUE,
                                  TAG_DONE};

/* Gadget vanilla key data */
#define KEY_NAME     0
#define KEY_TITLE    1
#define KEY_HOTKEY   2
#define KEY_XPOS     3
#define KEY_YPOS     4
#define KEY_COLS     5
#define KEY_FONT     6
#define KEY_PSCREEN  7
#define KEY_EDIT     8
#define KEY_ACTIVE   9
#define KEY_BDROP   10
#define KEY_CENTER  11
#define KEY_FRONT   12
#define KEY_MENU    13
#define KEY_PATT    14
#define KEY_POPUP   15
#define KEY_STICKY  16
#define KEY_TEXT    17
#define KEY_VERT    18
#define KEY_OK      19
#define KEY_CANCEL  20
static char KeyArray[KEY_CANCEL+1];

/* Init dock edit window */
void InitDockEditWindow(UWORD left, UWORD fheight)
{
 ULONG llabwidth,lgadwidth,rlabwidth,rgadwidth;
 ULONG cycwidth,cbwidth,butwidth,minstringwidth;
 ULONG strheight=fheight+2;
 ULONG i,tmp,yadd;
 struct GadgetData *gd;

 /* Init strings */
 gdata[GAD_NAME_STR].name    =AppStrings[MSG_WINDOW_NAME_GAD];
 gdata[GAD_TITLE_STR].name   =AppStrings[MSG_DOCKWIN_TITLE_GAD];
 gdata[GAD_HOTKEY_STR].name  =AppStrings[MSG_WINDOW_HOTKEY_GAD];
 gdata[GAD_XPOS_INT].name    =AppStrings[MSG_WINDOW_LEFTEDGE_GAD];
 gdata[GAD_YPOS_INT].name    =AppStrings[MSG_WINDOW_TOPEDGE_GAD];
 gdata[GAD_COLUMNS_INT].name =AppStrings[MSG_DOCKWIN_COLUMNS_GAD];
 cyclelabels[0]              =AppStrings[MSG_WINDOW_POSITION_OPEN_LABEL];
 cyclelabels[1]              =AppStrings[MSG_WINDOW_POSITION_CLOSE_LABEL];
 gdata[GAD_PSCREEN_TXT].name =AppStrings[MSG_WINDOW_PUBSCREEN_GAD];
 gdata[GAD_FONT_BUT].name    =AppStrings[MSG_DOCKWIN_FONT_GAD];
 gdata[GAD_TOOLS].name       =AppStrings[MSG_DOCKWIN_EDITTOOLS_GAD];
 gdata[GAD_ACTIVATED].name   =AppStrings[MSG_DOCKWIN_ACTIVATED_GAD];
 gdata[GAD_BACKDROP].name    =AppStrings[MSG_DOCKWIN_BACKDROP_GAD];
 gdata[GAD_CENTERED].name    =AppStrings[MSG_DOCKWIN_CENTERED_GAD];
 gdata[GAD_FRONTMOST].name   =AppStrings[MSG_DOCKWIN_FRONTMOST_GAD];
 gdata[GAD_MENU].name        =AppStrings[MSG_DOCKWIN_MENU_GAD];
 gdata[GAD_PATTERN].name     =AppStrings[MSG_DOCKWIN_PATTERN_GAD];
 gdata[GAD_POPUP].name       =AppStrings[MSG_DOCKWIN_POPUP_GAD];
 gdata[GAD_STICKY].name      =AppStrings[MSG_DOCKWIN_STICKY_GAD];
 gdata[GAD_TEXT].name        =AppStrings[MSG_DOCKWIN_TEXT_GAD];
 gdata[GAD_VERTICAL].name    =AppStrings[MSG_DOCKWIN_VERTICAL_GAD];
 gdata[GAD_OK].name          =AppStrings[MSG_WINDOW_OK_GAD];
 gdata[GAD_CANCEL].name      =AppStrings[MSG_WINDOW_CANCEL_GAD];

 /* Calculate maximum label width (left side) */
 llabwidth=0;
 gd=&gdata[GAD_NAME_STR];
 for (i=GAD_NAME_STR; i<=GAD_COLUMNS_INT; i++, gd++)
  if ((tmp=TextLength(&TmpRastPort,gd->name,strlen(gd->name))) > llabwidth)
   llabwidth=tmp;
 llabwidth+=INTERWIDTH;

 /* Calculate maximum gadget width (left side) */
 minstringwidth=TextLength(&TmpRastPort,AppStrings[MSG_DOCKWIN_NEWNAME],
                           strlen(AppStrings[MSG_DOCKWIN_NEWNAME]))
                +2*INTERWIDTH;
 lgadwidth=minstringwidth;

 /* Calculate maximum cyclegadget width */
 {
  char **s;

  cycwidth=0;
  s=cyclelabels;
  for (i=0; i<=1; i++, s++)
   if ((tmp=TextLength(&TmpRastPort,*s,strlen(*s))) > cycwidth)
    cycwidth=tmp;
  cycwidth+=5*INTERWIDTH;
 }
 if ((llabwidth+lgadwidth+INTERWIDTH) < cycwidth)
  lgadwidth=cycwidth-llabwidth-INTERWIDTH;

 /* Calculate maximum label width (right side) */
 gd=&gdata[GAD_PSCREEN_TXT];
 rlabwidth=TextLength(&TmpRastPort,gd->name,strlen(gd->name))+INTERWIDTH;
 gd++;
 if ((tmp=TextLength(&TmpRastPort,gd->name,strlen(gd->name))+2*INTERWIDTH)
      > rlabwidth)
  rlabwidth=tmp;

 /* Calculate maximum gadget width (right side) */
 rgadwidth=minstringwidth+REQBUTTONWIDTH;

 /* Calculate maximum button gadget width */
 gd=&gdata[GAD_TOOLS];
 butwidth=TextLength(&TmpRastPort,gd->name,strlen(gd->name))+2*INTERWIDTH;
 if ((rlabwidth+rgadwidth+INTERWIDTH) < butwidth)
  rgadwidth=butwidth-rlabwidth-INTERWIDTH;

 /* Calculate maximum checkbox gadget width */
 cbwidth=0;
 gd=&gdata[GAD_ACTIVATED];
 for (i=GAD_ACTIVATED; i<=GAD_VERTICAL; i++, gd++)
  if ((tmp=TextLength(&TmpRastPort,gd->name,strlen(gd->name))) > cbwidth)
   cbwidth=tmp;
 cbwidth+=CHECKBOX_WIDTH+INTERWIDTH;
 if ((rlabwidth+rgadwidth) < 2*cbwidth)
  rgadwidth=2*cbwidth-rlabwidth;

 /* Calculate minimum window width */
 ww=llabwidth+lgadwidth+rlabwidth+rgadwidth+4*INTERWIDTH;

 /* Calculate button gadgets width */
 gd=&gdata[GAD_OK];
 butwidth=TextLength(&TmpRastPort,gd->name,strlen(gd->name));
 gd++;
 if ((tmp=TextLength(&TmpRastPort,gd->name,strlen(gd->name))) > butwidth)
  butwidth=tmp;
 butwidth+=2*INTERWIDTH;
 if ((tmp=2*(butwidth+INTERWIDTH)) > ww) ww=tmp;

 /* Calculate minimum window height */
 wh=9*fheight+10*INTERHEIGHT+16;

 /* Init gadgets */
 gd=gdata;
 tmp=(ww-llabwidth-lgadwidth-rlabwidth-rgadwidth-4*INTERWIDTH)/2;
 lgadwidth+=tmp; /* String gadget length (left) */
 rgadwidth+=tmp; /* String gadget length (right) */
 llabwidth+=left+INTERWIDTH;
 tmp=WindowTop+INTERHEIGHT;
 yadd=strheight+INTERHEIGHT;

 /* Name string gadget */
 gd->type=STRING_KIND;
 gd->flags=PLACETEXT_LEFT;
 gd->tags=nametags;
 gd->left=llabwidth;
 gd->top=tmp;
 gd->width=lgadwidth;
 gd->height=strheight;
 tmp+=yadd;

 /* Title string gadget */
 gd++;
 gd->type=STRING_KIND;
 gd->flags=PLACETEXT_LEFT;
 gd->tags=titletags;
 gd->left=llabwidth;
 gd->top=tmp;
 gd->width=lgadwidth;
 gd->height=strheight;
 tmp+=yadd;

 /* HotKey string gadget */
 gd++;
 gd->type=STRING_KIND;
 gd->flags=PLACETEXT_LEFT;
 gd->tags=hotktags;
 gd->left=llabwidth;
 gd->top=tmp;
 gd->width=lgadwidth;
 gd->height=strheight;
 tmp+=2*yadd;

 /* LeftEdge integer gadget */
 gd++;
 gd->type=INTEGER_KIND;
 gd->flags=PLACETEXT_LEFT;
 gd->tags=xpostags;
 gd->left=llabwidth;
 gd->top=tmp;
 gd->width=lgadwidth;
 gd->height=strheight;
 tmp+=yadd;

 /* TopEdge integer gadget */
 gd++;
 gd->type=INTEGER_KIND;
 gd->flags=PLACETEXT_LEFT;
 gd->tags=ypostags;
 gd->left=llabwidth;
 gd->top=tmp;
 gd->width=lgadwidth;
 gd->height=strheight;
 tmp+=yadd;

 /* Columns integer gadget */
 gd++;
 gd->type=INTEGER_KIND;
 gd->flags=PLACETEXT_LEFT;
 gd->tags=colstags;
 gd->left=llabwidth;
 gd->top=tmp;
 gd->width=lgadwidth;
 gd->height=strheight;

 /* Position cycle gadget */
 tmp=WindowTop+3*yadd+INTERHEIGHT;
 gd++;
 gd->type=CYCLE_KIND;
 gd->flags=PLACETEXT_IN;
 gd->tags=cycletags;
 gd->left=left;
 gd->top=tmp;
 gd->width=lgadwidth+llabwidth-left;
 gd->height=strheight;

 /* PubScreen button gadget */
 tmp=WindowTop+INTERHEIGHT;
 llabwidth=ww-rgadwidth-INTERWIDTH+left;
 gd++;
 gd->type=GENERIC_KIND;
 gd->flags=0;
 gd->left=llabwidth;
 gd->top=tmp;
 gd->width=REQBUTTONWIDTH;
 gd->height=strheight;

 /* PubScreen txt gadget */
 gd++;
 gd->type=TEXT_KIND;
 gd->flags=PLACETEXT_LEFT;
 gd->left=llabwidth;
 gd->top=tmp+strheight/2;
 gd->width=0;
 gd->height=0;
 tmp+=yadd;

 /* Font button gadget */
 gd++;
 gd->type=BUTTON_KIND;
 gd->flags=PLACETEXT_IN;
 gd->left=llabwidth-rlabwidth-INTERWIDTH;
 gd->top=tmp;
 gd->width=rlabwidth;
 gd->height=strheight;

 /* PubScreen string gadget */
 tmp=WindowTop+INTERHEIGHT;
 gd++;
 gd->type=STRING_KIND;
 gd->tags=pbsctags;
 gd->left=llabwidth+REQBUTTONWIDTH;
 gd->top=tmp;
 gd->width=rgadwidth-REQBUTTONWIDTH;
 gd->height=strheight;
 tmp+=yadd;

 /* Font text gadget */
 gd++;
 gd->type=TEXT_KIND;
 gd->tags=fonttags;
 gd->left=llabwidth;
 gd->top=tmp;
 gd->width=rgadwidth;
 gd->height=strheight;
 tmp+=yadd;

 /* Tools button gadget */
 llabwidth-=rlabwidth+INTERWIDTH;
 gd++;
 gd->type=BUTTON_KIND;
 gd->flags=PLACETEXT_IN;
 gd->left=llabwidth;
 gd->top=tmp;
 gd->width=ww-llabwidth-INTERWIDTH+left;
 gd->height=strheight;
 tmp+=yadd+1;
 if (OSV39) tmp+=INTERHEIGHT/2;

 /* Activated checkbox gadget */
 rlabwidth=(ww-llabwidth-INTERWIDTH+left-2*cbwidth)/3;
 llabwidth+=rlabwidth;
 cbwidth+=llabwidth+rlabwidth;
 strheight=fheight-INTERHEIGHT;

 gd++;
 gd->type=CHECKBOX_KIND;
 gd->flags=PLACETEXT_RIGHT;
 gd->tags=actitags;
 gd->left=llabwidth;
 gd->top=tmp;
 gd->width=CHECKBOX_WIDTH;
 gd->height=strheight;

 /* Backdrop checkbox gadget */
 gd++;
 gd->type=CHECKBOX_KIND;
 gd->flags=PLACETEXT_RIGHT;
 gd->tags=backdtags;
 gd->left=cbwidth;
 gd->top=tmp;
 gd->width=CHECKBOX_WIDTH;
 gd->height=strheight;
 tmp+=yadd;

 /* Centered checkbox gadget */
 gd++;
 gd->type=CHECKBOX_KIND;
 gd->flags=PLACETEXT_RIGHT;
 gd->tags=centtags;
 gd->left=llabwidth;
 gd->top=tmp;
 gd->width=CHECKBOX_WIDTH;
 gd->height=strheight;

 /* Frontmost checkbox gadget */
 gd++;
 gd->type=CHECKBOX_KIND;
 gd->flags=PLACETEXT_RIGHT;
 gd->tags=fronttags;
 gd->left=cbwidth;
 gd->top=tmp;
 gd->width=CHECKBOX_WIDTH;
 gd->height=strheight;
 tmp+=yadd;

 /* Menu checkbox gadget */
 gd++;
 gd->type=CHECKBOX_KIND;
 gd->flags=PLACETEXT_RIGHT;
 gd->tags=menutags;
 gd->left=llabwidth;
 gd->top=tmp;
 gd->width=CHECKBOX_WIDTH;
 gd->height=strheight;

 /* Pattern checkbox gadget */
 gd++;
 gd->type=CHECKBOX_KIND;
 gd->flags=PLACETEXT_RIGHT;
 gd->tags=patttags;
 gd->left=cbwidth;
 gd->top=tmp;
 gd->width=CHECKBOX_WIDTH;
 gd->height=strheight;
 tmp+=yadd;

 /* PopUp checkbox gadget */
 gd++;
 gd->type=CHECKBOX_KIND;
 gd->flags=PLACETEXT_RIGHT;
 gd->tags=popuptags;
 gd->left=llabwidth;
 gd->top=tmp;
 gd->width=CHECKBOX_WIDTH;
 gd->height=strheight;

 /* Sticky checkbox gadget */
 gd++;
 gd->type=CHECKBOX_KIND;
 gd->flags=PLACETEXT_RIGHT;
 gd->tags=stickytags;
 gd->left=cbwidth;
 gd->top=tmp;
 gd->width=CHECKBOX_WIDTH;
 gd->height=strheight;
 tmp+=yadd;

 /* Text checkbox gadget */
 gd++;
 gd->type=CHECKBOX_KIND;
 gd->flags=PLACETEXT_RIGHT;
 gd->tags=texttags;
 gd->left=llabwidth;
 gd->top=tmp;
 gd->width=CHECKBOX_WIDTH;
 gd->height=strheight;

 /* Vertical checkbox gadget */
 gd++;
 gd->type=CHECKBOX_KIND;
 gd->flags=PLACETEXT_RIGHT;
 gd->tags=verttags;
 gd->left=cbwidth;
 gd->top=tmp;
 gd->width=CHECKBOX_WIDTH;
 gd->height=strheight;
 tmp+=yadd-1;
 if (OSV39) tmp-=INTERHEIGHT/2;

 /* OK button gadget */
 gd++;
 gd->type=BUTTON_KIND;
 gd->flags=PLACETEXT_IN;
 gd->left=left;
 gd->top=tmp;
 gd->width=butwidth;
 gd->height=fheight;

 /* Cancel button gadget */
 gd++;
 gd->type=BUTTON_KIND;
 gd->flags=PLACETEXT_IN;
 gd->left=ww-butwidth-INTERWIDTH+left;
 gd->top=tmp;
 gd->width=butwidth;
 gd->height=fheight;

 /* Init vanilla key array */
 KeyArray[KEY_NAME]   =FindVanillaKey(gdata[GAD_NAME_STR].name);
 KeyArray[KEY_TITLE]  =FindVanillaKey(gdata[GAD_TITLE_STR].name);
 KeyArray[KEY_HOTKEY] =FindVanillaKey(gdata[GAD_HOTKEY_STR].name);
 KeyArray[KEY_XPOS]   =FindVanillaKey(gdata[GAD_XPOS_INT].name);
 KeyArray[KEY_YPOS]   =FindVanillaKey(gdata[GAD_YPOS_INT].name);
 KeyArray[KEY_COLS]   =FindVanillaKey(gdata[GAD_COLUMNS_INT].name);
 KeyArray[KEY_FONT]   =FindVanillaKey(gdata[GAD_FONT_BUT].name);
 KeyArray[KEY_PSCREEN]=FindVanillaKey(gdata[GAD_PSCREEN_TXT].name);
 KeyArray[KEY_EDIT]   =FindVanillaKey(gdata[GAD_TOOLS].name);
 KeyArray[KEY_ACTIVE] =FindVanillaKey(gdata[GAD_ACTIVATED].name);
 KeyArray[KEY_BDROP]  =FindVanillaKey(gdata[GAD_BACKDROP].name);
 KeyArray[KEY_CENTER] =FindVanillaKey(gdata[GAD_CENTERED].name);
 KeyArray[KEY_FRONT]  =FindVanillaKey(gdata[GAD_FRONTMOST].name);
 KeyArray[KEY_MENU]   =FindVanillaKey(gdata[GAD_MENU].name);
 KeyArray[KEY_PATT]   =FindVanillaKey(gdata[GAD_PATTERN].name);
 KeyArray[KEY_POPUP]  =FindVanillaKey(gdata[GAD_POPUP].name);
 KeyArray[KEY_TEXT]   =FindVanillaKey(gdata[GAD_TEXT].name);
 KeyArray[KEY_STICKY] =FindVanillaKey(gdata[GAD_STICKY].name);
 KeyArray[KEY_VERT]   =FindVanillaKey(gdata[GAD_VERTICAL].name);
 KeyArray[KEY_OK]     =FindVanillaKey(gdata[GAD_OK].name);
 KeyArray[KEY_CANCEL] =FindVanillaKey(gdata[GAD_CANCEL].name);

 /* Init dummy requester structure */
 InitRequester(&DummyReq);
}

/* Free dock node */
void FreeDockNode(struct Node *node)
{
 struct DockNode *dn=(struct DockNode *) node;
 char *s;

 if (s=dn->dn_Node.ln_Name) free(s);
 if (s=dn->dn_HotKey) free(s);
 if (s=dn->dn_PubScreen) free(s);
 if (s=dn->dn_Title) free(s);
 if (s=dn->dn_Font.ta_Name) free(s);
 if (s=dn->dn_FontDesc) free(s);

 /* Free tool list */
 if (dn->dn_ToolsList) FreeToolsList(dn->dn_ToolsList);

 /* Free node */
 FreeMem(dn,sizeof(struct DockNode));
}

/* Build font descriptor string */
static char *BuildFontDesc(struct TextAttr *ta)
{
 char *name;

 if (name=strdup(ta->ta_Name)) {
  ULONG len=strlen(name);
  UWORD size=ta->ta_YSize%10000; /* Safety hack... */
  UWORD div=1000;
  char *s=&name[len-5];
  BOOL InNumber=FALSE;

  /* Overwrite ".font" */
  *s++='/';
  while (div) {
   char c=size/div+'0';

   if ((c!='0') || InNumber) {
    *s++=c;
    InNumber=TRUE;
   }
   size%=div;
   div/=10;
  }
  *s++='\0';
 }
 return(name);
}

/* Copy dock node */
struct Node *CopyDockNode(struct Node *node)
{
 struct DockNode *dn,*orignode=(struct DockNode *) node;

 /* Alloc memory for dock node */
 if (dn=AllocMem(sizeof(struct DockNode),MEMF_PUBLIC|MEMF_CLEAR)) {
  /* Got an old node? */
  if (orignode) {
   /* Yes, copy it */
   if ((!orignode->dn_Node.ln_Name || (dn->dn_Node.ln_Name=
                                        strdup(orignode->dn_Node.ln_Name))) &&
       (!orignode->dn_HotKey || (dn->dn_HotKey=strdup(orignode->dn_HotKey))) &&
       (!orignode->dn_PubScreen || (dn->dn_PubScreen=
                                     strdup(orignode->dn_PubScreen))) &&
       (!orignode->dn_Title || (dn->dn_Title=strdup(orignode->dn_Title))) &&
       (!orignode->dn_Font.ta_Name ||
        ((dn->dn_Font.ta_Name=strdup(orignode->dn_Font.ta_Name)) &&
         (dn->dn_FontDesc=BuildFontDesc(&orignode->dn_Font)))) &&
       (!orignode->dn_ToolsList || (dn->dn_ToolsList=
                                     CopyToolsList(orignode->dn_ToolsList)))) {
    /* Copy flags & numbers */
    dn->dn_XPos=orignode->dn_XPos;
    dn->dn_YPos=orignode->dn_YPos;
    dn->dn_Columns=orignode->dn_Columns;
    dn->dn_Font.ta_YSize=orignode->dn_Font.ta_YSize;
    dn->dn_Font.ta_Style=orignode->dn_Font.ta_Style;
    dn->dn_Font.ta_Flags=orignode->dn_Font.ta_Flags;
    dn->dn_Flags=orignode->dn_Flags;

    /* Return pointer to new node */
    return(dn);
   }
  } else {
   /* No, set defaults */
   if (dn->dn_Node.ln_Name=strdup(AppStrings[MSG_DOCKWIN_NEWNAME])) {
    dn->dn_Columns=1;
    dn->dn_Flags=DOPOF_ACTIVATED;

    /* Return pointer to new node */
    return(dn);
   }
  }

  FreeDockNode((struct Node *) dn);
 }
 /* Call failed */
 return(NULL);
}

/* Activate gadget and save pointer to it */
static void MyActivateGadget(ULONG num)
{
 ActivateGadget(gdata[num].gadget,w,NULL);
}

/* Open dock edit window */
BOOL OpenDockEditWindow(struct Node *node, struct Window *parent)
{
 /* Copy node */
 if (CurrentNode=(struct DockNode *) CopyDockNode(node)) {
  /* Set tags */
  nametags[0].ti_Data=(ULONG) CurrentNode->dn_Node.ln_Name;
  titletags[0].ti_Data=(ULONG) CurrentNode->dn_Title;
  hotktags[0].ti_Data=(ULONG) CurrentNode->dn_HotKey;
  xpostags[0].ti_Data=CurrentNode->dn_XPos;
  ypostags[0].ti_Data=CurrentNode->dn_YPos;
  colstags[0].ti_Data=CurrentNode->dn_Columns;
  pbsctags[0].ti_Data=(ULONG) CurrentNode->dn_PubScreen;
  fonttags[0].ti_Data=(ULONG) CurrentNode->dn_FontDesc;
  actitags[0].ti_Data=(CurrentNode->dn_Flags & DOPOF_ACTIVATED)!=0;
  backdtags[0].ti_Data=(CurrentNode->dn_Flags & DOPOF_BACKDROP)!=0;
  centtags[0].ti_Data=(CurrentNode->dn_Flags & DOPOF_CENTERED)!=0;
  fronttags[0].ti_Data=(CurrentNode->dn_Flags & DOPOF_FRONTMOST)!=0;
  menutags[0].ti_Data=(CurrentNode->dn_Flags & DOPOF_MENU)!=0;
  patttags[0].ti_Data=(CurrentNode->dn_Flags & DOPOF_PATTERN)!=0;
  popuptags[0].ti_Data=(CurrentNode->dn_Flags & DOPOF_POPUP)!=0;
  stickytags[0].ti_Data=(CurrentNode->dn_Flags & DOPOF_STICKY)!=0;
  texttags[0].ti_Data=(CurrentNode->dn_Flags & DOPOF_TEXT)!=0;
  verttags[0].ti_Data=(CurrentNode->dn_Flags & DOPOF_VERTICAL)!=0;

  /* Create gadgets */
  if (gl=CreateGadgetList(gdata,GADGETS)) {
   /* Open window */
   if (w=OpenWindowTags(NULL,WA_Left,        parent->LeftEdge,
                             WA_Top,         parent->TopEdge+WindowTop,
                             WA_InnerWidth,  ww,
                             WA_InnerHeight, wh,
                             WA_AutoAdjust,  TRUE,
                             WA_Title,       AppStrings[MSG_DOCKWIN_TITLE],
                             WA_PubScreen,   PublicScreen,
                             WA_Flags,       WFLG_CLOSEGADGET|WFLG_DRAGBAR|
                                             WFLG_DEPTHGADGET|WFLG_RMBTRAP|
                                             WFLG_ACTIVATE,
                             TAG_DONE)) {
    /* Init requester button gadgets */
    InitReqButtonGadget(gdata[GAD_PSCREEN_BUT].gadget);

    /* Add gadgets to window */
    AddGList(w,gl,(UWORD) -1,(UWORD) -1,NULL);
    RefreshGList(gl,w,NULL,(UWORD) -1);
    GT_RefreshWindow(w,NULL);

    /* Activate name string gadget */
    MyActivateGadget(GAD_NAME_STR);

    /* Set local variables */
    w->UserPort=IDCMPPort;
    w->UserData=(BYTE *) HandleDockEditWindowIDCMP;
    ModifyIDCMP(w,WINDOW_IDCMP);
    CurrentWindow=w;
    ReqOpen=FALSE;

    /* All OK. */
    return(TRUE);
   }
   FreeGadgets(gl);
  }
  FreeDockNode((struct Node *) CurrentNode);
 }
 /* Call failed */
 return(FALSE);
}

/* Close dock edit window */
static void CloseDockEditWindow(void)
{
 /* Free resources */
 if (MoveWindowPtr) CloseMoveWindow();
 RemoveGList(w,gl,(UWORD) -1);
 CloseWindowSafely(w);
 FreeGadgets(gl);
}

/* If move window open, move it to new position */
static void MoveMoveWindow(void)
{
 /* Move window open? */
 if (MoveWindowPtr) {
  ULONG x,y;

  /* Read current position */
  x=((struct StringInfo *) gdata[GAD_XPOS_INT].gadget->SpecialInfo)->LongInt;
  y=((struct StringInfo *) gdata[GAD_YPOS_INT].gadget->SpecialInfo)->LongInt;

  /* Move move window */
  MoveWindow(MoveWindowPtr,x-MoveWindowPtr->LeftEdge,y-MoveWindowPtr->TopEdge);
 }
}

/* Public screen gadget function */
static void PubScreenGadgetFunc(void)
{
 if (!ReqOpen) {
  /* Save current gadget number */
  CurrentGadgetNum=GAD_PSCREEN_BUT;

  /* Open list requester */
  if (OpenListRequester(LISTREQ_PUBSC,w)) {
   /* Disable window */
   DisableWindow(w,&DummyReq);

   /* Set update function */
   UpdateWindow=UpdateDockEditWindow;
   ReqOpen=TRUE;
  }
 }
}

/* Font gadget function */
static void FontGadgetFunc(void)
{
 struct TextAttr *newta;

 /* Set old font */
 newta=(CurrentNode->dn_FontDesc) ? &CurrentNode->dn_Font : NULL;

 /* Open font requester */
 if (newta=OpenFontRequester(w,&DummyReq,newta)) {
  /* Font specified? */
  if (newta->ta_Name) {
   char *fontdesc;

   /* Build font descriptor */
   if (fontdesc=BuildFontDesc(newta)) {
    /* All OK. Set new font */
    GT_SetGadgetAttrs(gdata[GAD_FONT_TXT].gadget,w,NULL,GTTX_Text,fontdesc,
                                                        TAG_DONE);

    /* Throw away old font */
    if (CurrentNode->dn_FontDesc) {
     free(CurrentNode->dn_Font.ta_Name);
     free(CurrentNode->dn_FontDesc);
    }

    /* Set new font */
    CurrentNode->dn_Font=*(newta);
    CurrentNode->dn_FontDesc=fontdesc;
   }
  } else
   /* User selected NO font, delete old one */
   if (CurrentNode->dn_FontDesc) {
    GT_SetGadgetAttrs(gdata[GAD_FONT_TXT].gadget,w,NULL,GTTX_Text,NULL,
                                                        TAG_DONE);

    /* Free strings */
    free(CurrentNode->dn_Font.ta_Name);
    CurrentNode->dn_Font.ta_Name=NULL;
    free(CurrentNode->dn_FontDesc);
    CurrentNode->dn_FontDesc=NULL;
   }
 }
}

/* Edit gadget function */
static void EditGadgetFunc(void)
{
 if (!ReqOpen) {
  /* Save current gadget number */
  CurrentGadgetNum=GAD_TOOLS;

  /* Open edit window */
  if (OpenDockListEditWindow(CurrentNode->dn_ToolsList,w)) {
   /* Disable window */
   DisableWindow(w,&DummyReq);

   /* Set update function */
   UpdateWindow=UpdateDockEditWindow;
   ReqOpen=TRUE;
  } else
   DisplayBeep(NULL);
 }
}

/* OK gadget function */
static struct Node *OKGadgetFunc(void)
{
 struct Node *rc;
 char *s;

 /* Free old string */
 if (s=CurrentNode->dn_Node.ln_Name) free(s);
 CurrentNode->dn_Node.ln_Name=NULL;
 if (s=CurrentNode->dn_HotKey) free(s);
 CurrentNode->dn_HotKey=NULL;
 if (s=CurrentNode->dn_PubScreen) free(s);
 CurrentNode->dn_PubScreen=NULL;
 if (s=CurrentNode->dn_Title) free(s);
 CurrentNode->dn_Title=NULL;

 /* Duplicate new string */
 if (((CurrentNode->dn_Node.ln_Name=
        DuplicateBuffer(gdata[GAD_NAME_STR].gadget)) != (char *) -1) &&
     ((CurrentNode->dn_HotKey=
        DuplicateBuffer(gdata[GAD_HOTKEY_STR].gadget)) != (char *) -1) &&
     ((CurrentNode->dn_PubScreen=
        DuplicateBuffer(gdata[GAD_PSCREEN_STR].gadget)) != (char *) -1) &&
     ((CurrentNode->dn_Title=
        DuplicateBuffer(gdata[GAD_TITLE_STR].gadget)) != (char *) -1)) {
  /* Copy integer gadget values */
  CurrentNode->dn_XPos=
   ((struct StringInfo *) gdata[GAD_XPOS_INT].gadget->SpecialInfo)->LongInt;
  CurrentNode->dn_YPos=
   ((struct StringInfo *) gdata[GAD_YPOS_INT].gadget->SpecialInfo)->LongInt;
  CurrentNode->dn_Columns=
   ((struct StringInfo *) gdata[GAD_COLUMNS_INT].gadget->SpecialInfo)->LongInt;

  rc=(struct Node *) CurrentNode;
 } else {
  /* Couldn't copy strings */
  rc=(struct Node *) -1;
  FreeDockNode((struct Node *) CurrentNode);
 }
 return(rc);
}

/* Handle dock edit window IDCMP events */
void *HandleDockEditWindowIDCMP(struct IntuiMessage *msg)
{
 struct Node *NewNode=NULL;

 /* Which IDCMP class? */
 switch (msg->Class) {
  case IDCMP_CLOSEWINDOW:   NewNode=(struct Node *) -1;
                            FreeDockNode((struct Node *) CurrentNode);
                            break;
  case IDCMP_REFRESHWINDOW: GT_BeginRefresh(w);
                            GT_EndRefresh(w,TRUE);
                            break;
  case IDCMP_GADGETUP:
   switch (((struct Gadget *) msg->IAddress)->GadgetID) {
    case GAD_XPOS_INT:    MoveMoveWindow();
                          break;
    case GAD_YPOS_INT:    MoveMoveWindow();
                          break;
    case GAD_POSITION:    /* Move window open? */
                          if (MoveWindowPtr)
                           /* Yes, close move window */
                           CloseMoveWindow();
                          else {
                           /* No. Open it! */
                           MoveWindowOffX=0;
                           MoveWindowOffY=0;

                           /* Open move window */
                           OpenMoveWindow(w,gdata[GAD_XPOS_INT].gadget,
                                            gdata[GAD_YPOS_INT].gadget);
                          }
                          break;
    case GAD_PSCREEN_BUT: PubScreenGadgetFunc();
                          break;
    case GAD_FONT_BUT:    FontGadgetFunc();
                          break;
    case GAD_ACTIVATED:   /* Toggle flag */
                          CurrentNode->dn_Flags^=DOPOF_ACTIVATED;
                          break;
    case GAD_BACKDROP:    /* Toggle flag */
                          CurrentNode->dn_Flags^=DOPOF_BACKDROP;
                          break;
    case GAD_CENTERED:    /* Toggle flag */
                          CurrentNode->dn_Flags^=DOPOF_CENTERED;
                          break;
    case GAD_FRONTMOST:   /* Toggle flag */
                          CurrentNode->dn_Flags^=DOPOF_FRONTMOST;
                          break;
    case GAD_MENU:        /* Toggle flag */
                          CurrentNode->dn_Flags^=DOPOF_MENU;
                          break;
    case GAD_PATTERN:     /* Toggle flag */
                          CurrentNode->dn_Flags^=DOPOF_PATTERN;
                          break;
    case GAD_POPUP:       /* Toggle flag */
                          CurrentNode->dn_Flags^=DOPOF_POPUP;
                          break;
    case GAD_STICKY:      /* Toggle flag */
                          CurrentNode->dn_Flags^=DOPOF_STICKY;
                          break;
    case GAD_TEXT:        /* Toggle flag */
                          CurrentNode->dn_Flags^=DOPOF_TEXT;
                          break;
    case GAD_VERTICAL:    /* Toggle flag */
                          CurrentNode->dn_Flags^=DOPOF_VERTICAL;
                          break;
    case GAD_TOOLS:       EditGadgetFunc();
                          break;
    case GAD_OK:          NewNode=OKGadgetFunc();
                          break;
    case GAD_CANCEL:      NewNode=(struct Node *) -1;
                          FreeDockNode((struct Node *) CurrentNode);
                          break;
   }
   break;
  case IDCMP_VANILLAKEY:
   switch (MatchVanillaKey(msg->Code,KeyArray)) {
    case KEY_NAME:    MyActivateGadget(GAD_NAME_STR);
                      break;
    case KEY_TITLE:   MyActivateGadget(GAD_TITLE_STR);
                      break;
    case KEY_HOTKEY:  MyActivateGadget(GAD_HOTKEY_STR);
                      break;
    case KEY_XPOS:    MyActivateGadget(GAD_XPOS_INT);
                      break;
    case KEY_YPOS:    MyActivateGadget(GAD_YPOS_INT);
                      break;
    case KEY_COLS:    MyActivateGadget(GAD_COLUMNS_INT);
                      break;
    case KEY_PSCREEN: PubScreenGadgetFunc();
                      break;
    case KEY_FONT:    FontGadgetFunc();
                      break;
    case KEY_EDIT:    EditGadgetFunc();
                      break;
    case KEY_ACTIVE:  /* Toggle flag */
                      CurrentNode->dn_Flags^=DOPOF_ACTIVATED;

                      /* Set check box gadget */
                      GT_SetGadgetAttrs(gdata[GAD_ACTIVATED].gadget,w,NULL,
                       GTCB_Checked, (CurrentNode->dn_Flags & DOPOF_ACTIVATED),
                       TAG_DONE);

                      break;
    case KEY_BDROP:  /* Toggle flag */
                     CurrentNode->dn_Flags^=DOPOF_BACKDROP;

                     /* Set check box gadget */
                     GT_SetGadgetAttrs(gdata[GAD_BACKDROP].gadget,w,NULL,
                      GTCB_Checked, (CurrentNode->dn_Flags & DOPOF_BACKDROP),
                      TAG_DONE);

                     break;
    case KEY_CENTER: /* Toggle flag */
                     CurrentNode->dn_Flags^=DOPOF_CENTERED;

                     /* Set check box gadget */
                     GT_SetGadgetAttrs(gdata[GAD_CENTERED].gadget,w,NULL,
                      GTCB_Checked, (CurrentNode->dn_Flags & DOPOF_CENTERED),
                      TAG_DONE);

                     break;
    case KEY_FRONT:  /* Toggle flag */
                     CurrentNode->dn_Flags^=DOPOF_FRONTMOST;

                     /* Set check box gadget */
                     GT_SetGadgetAttrs(gdata[GAD_FRONTMOST].gadget,w,NULL,
                      GTCB_Checked, (CurrentNode->dn_Flags & DOPOF_FRONTMOST),
                      TAG_DONE);

                     break;
    case KEY_MENU:   /* Toggle flag */
                     CurrentNode->dn_Flags^=DOPOF_MENU;

                     /* Set check box gadget */
                     GT_SetGadgetAttrs(gdata[GAD_MENU].gadget,w,NULL,
                      GTCB_Checked, (CurrentNode->dn_Flags & DOPOF_MENU),
                      TAG_DONE);

                     break;
    case KEY_PATT:   /* Toggle flag */
                     CurrentNode->dn_Flags^=DOPOF_PATTERN;

                     /* Set check box gadget */
                     GT_SetGadgetAttrs(gdata[GAD_PATTERN].gadget,w,NULL,
                      GTCB_Checked, (CurrentNode->dn_Flags & DOPOF_PATTERN),
                      TAG_DONE);

                     break;
    case KEY_POPUP:  /* Toggle flag */
                     CurrentNode->dn_Flags^=DOPOF_POPUP;

                     /* Set check box gadget */
                     GT_SetGadgetAttrs(gdata[GAD_POPUP].gadget,w,NULL,
                      GTCB_Checked, (CurrentNode->dn_Flags & DOPOF_POPUP),
                      TAG_DONE);

                     break;
    case KEY_STICKY: /* Toggle flag */
                     CurrentNode->dn_Flags^=DOPOF_STICKY;

                     /* Set check box gadget */
                     GT_SetGadgetAttrs(gdata[GAD_STICKY].gadget,w,NULL,
                      GTCB_Checked, (CurrentNode->dn_Flags & DOPOF_STICKY),
                      TAG_DONE);

                     break;
    case KEY_TEXT:   /* Toggle flag */
                     CurrentNode->dn_Flags^=DOPOF_TEXT;

                     /* Set check box gadget */
                     GT_SetGadgetAttrs(gdata[GAD_TEXT].gadget,w,NULL,
                      GTCB_Checked, (CurrentNode->dn_Flags & DOPOF_TEXT),
                      TAG_DONE);

                     break;
    case KEY_VERT:   /* Toggle flag */
                     CurrentNode->dn_Flags^=DOPOF_VERTICAL;

                     /* Set check box gadget */
                     GT_SetGadgetAttrs(gdata[GAD_VERTICAL].gadget,w,NULL,
                      GTCB_Checked, (CurrentNode->dn_Flags & DOPOF_VERTICAL),
                      TAG_DONE);

                     break;
    case KEY_OK:     NewNode=OKGadgetFunc();
                     break;
    case KEY_CANCEL: NewNode=(struct Node *) -1;
                     FreeDockNode((struct Node *) CurrentNode);
                     break;
   }
   break;
 }

 /* Close window? */
 if (NewNode) {
  /* Yes. But first reply message!!! */
  GT_ReplyIMsg(msg);
  CloseDockEditWindow();
 }

 return(NewNode);
}

/* Update dock edit window */
void UpdateDockEditWindow(void *data)
{
 /* Which data? */
 switch (CurrentGadgetNum) {
  case GAD_PSCREEN_BUT: /* Got data? */
                        if (data != LREQRET_CANCEL) {
                         char *new;

                         /* Selected something? */
                         new=(data == LREQRET_NOSELECT) ?
                              NULL : ((struct Node *) data)->ln_Name;

                         /* set new public screen name */
                         GT_SetGadgetAttrs(gdata[GAD_PSCREEN_STR].gadget,w,
                                           NULL,GTST_String,new,TAG_DONE);
                        }
                        break;
  case GAD_TOOLS:       /* Got data? */
                        if (data != (void *) -1) {
                         /* Free old tools list */
                         if (CurrentNode->dn_ToolsList)
                          FreeToolsList(CurrentNode->dn_ToolsList);

                         /* Set new tools list */
                         CurrentNode->dn_ToolsList=data;
                        }
                        break;
 }

 /* Enable window */
 EnableWindow(w,&DummyReq,WINDOW_IDCMP);

 /* Restore update function pointer */
 UpdateWindow=UpdateMainWindow;
 CurrentWindow=w;
 ReqOpen=FALSE;
}

/* Read TMDO IFF chunk into Dock node */
struct Node *ReadDockNode(UBYTE *buf)
{
 struct DockNode *dn;

 /* Allocate memory for node */
 if (dn=AllocMem(sizeof(struct DockNode),MEMF_PUBLIC|MEMF_CLEAR)) {
  struct DockPrefsObject *dpo=(struct DockPrefsObject *) buf;
  ULONG sbits=dpo->dpo_StringBits;
  UBYTE *ptr=(UBYTE *) &dpo[1];
  struct List *toolslist;

  if ((!(sbits & DOPO_NAME) || (dn->dn_Node.ln_Name=GetConfigStr(&ptr))) &&
      (!(sbits & DOPO_HOTKEY) || (dn->dn_HotKey=GetConfigStr(&ptr))) &&
      (!(sbits & DOPO_PSCREEN) || (dn->dn_PubScreen=GetConfigStr(&ptr))) &&
      (!(sbits & DOPO_TITLE) || (dn->dn_Title=GetConfigStr(&ptr))) &&
      (!(sbits & DOPO_FONTNAME) || (dn->dn_Font.ta_Name=GetConfigStr(&ptr))) &&
      (toolslist=malloc(sizeof(struct List)))) {
   LONG tools=0;
   UBYTE tlflags;

   /* Init list */
   NewList(toolslist);
   dn->dn_ToolsList=toolslist;

   /* Get tools */
   while ((tlflags=*ptr++) & DOPOT_CONTINUE) {
    struct ToolNode *tn;

    if (tn=AllocMem(sizeof(struct ToolNode),MEMF_PUBLIC|MEMF_CLEAR)) {
     /* Add tool to list */
     AddTail(toolslist,(struct Node *) tn);

     if ((!(tlflags & DOPOT_EXEC) || (tn->tn_Node.ln_Name=
                                       GetConfigStr(&ptr))) &&
         (!(tlflags & DOPOT_IMAGE) || (tn->tn_Image=GetConfigStr(&ptr))) &&
         (!(tlflags & DOPOT_SOUND) || (tn->tn_Sound=GetConfigStr(&ptr))))
      /* All OK. */
      tools++;
     else {
      /* Error */
      tools=-1;
      break;
     }
    } else {
     /* No memory. */
     tools=-1;
     break;
    }
   }

   /* Error? */
   if (tools!=-1) {
    /* Got tools? */
    if (tools==0) {
     /* No, free list structure */
     free(toolslist);
     dn->dn_ToolsList=NULL;
    }

    /* Copy flags & values */
    dn->dn_Flags=dpo->dpo_Flags;
    dn->dn_XPos=dpo->dpo_XPos;
    dn->dn_YPos=dpo->dpo_YPos;
    dn->dn_Columns=dpo->dpo_Columns;
    dn->dn_Font.ta_YSize=dpo->dpo_Font.ta_YSize;
    dn->dn_Font.ta_Style=dpo->dpo_Font.ta_Style;
    dn->dn_Font.ta_Flags=dpo->dpo_Font.ta_Flags;

    /* All OK. */
    return(dn);
   }
  }

  /* Call failed */
  FreeDockNode((struct Node *) dn);
 }
 return(NULL);
}

/* Write Dock node to TMDO IFF chunk */
BOOL WriteDockNode(struct IFFHandle *iff, UBYTE *buf, struct Node *node)
{
 struct DockNode *dn=(struct DockNode *) node;
 struct DockPrefsObject *dpo=(struct DockPrefsObject *) buf;
 ULONG sbits=0;
 UBYTE *ptr=(UBYTE *) &dpo[1];

 /* Copy strings */
 if (PutConfigStr(dn->dn_Node.ln_Name,&ptr)) sbits|=DOPO_NAME;
 if (PutConfigStr(dn->dn_HotKey,&ptr)) sbits|=DOPO_HOTKEY;
 if (PutConfigStr(dn->dn_PubScreen,&ptr)) sbits|=DOPO_PSCREEN;
 if (PutConfigStr(dn->dn_Title,&ptr)) sbits|=DOPO_TITLE;
 if (PutConfigStr(dn->dn_Font.ta_Name,&ptr)) sbits|=DOPO_FONTNAME;

 /* set string bits */
 dpo->dpo_StringBits=sbits;

 /* Write tool list */
 if (dn->dn_ToolsList) {
  struct ToolNode *tn=GetHead(dn->dn_ToolsList);

  while (tn) {
   UBYTE *flptr=ptr++;
   UBYTE tfl=DOPOT_CONTINUE;

   if (PutConfigStr(tn->tn_Node.ln_Name,&ptr)) tfl|=DOPOT_EXEC;
   if (PutConfigStr(tn->tn_Image,&ptr)) tfl|=DOPOT_IMAGE;
   if (PutConfigStr(tn->tn_Sound,&ptr)) tfl|=DOPOT_SOUND;

   /* Put flags */
   *flptr=tfl;

   /* Get next node */
   tn=GetSucc(tn);
  }
 }

 /* Append terminator */
 *ptr++=0;

 /* Copy flags & values */
 dpo->dpo_Flags=dn->dn_Flags;
 dpo->dpo_XPos=dn->dn_XPos;
 dpo->dpo_YPos=dn->dn_YPos;
 dpo->dpo_Columns=dn->dn_Columns;
 dpo->dpo_Font.ta_YSize=dn->dn_Font.ta_YSize;
 dpo->dpo_Font.ta_Style=dn->dn_Font.ta_Style;
 dpo->dpo_Font.ta_Flags=dn->dn_Font.ta_Flags;

 /* calculate length */
 sbits=ptr-buf;

 DEBUG_PRINTF("chunk size %ld\n",sbits);

 /* Open chunk */
 if (PushChunk(iff,0,ID_TMDO,sbits)) return(FALSE);

 /* Write chunk */
 if (WriteChunkBytes(iff,buf,sbits)!=sbits) return(FALSE);

 /* Close chunk */
 if (PopChunk(iff)) return(FALSE);

 /* All OK. */
 return(TRUE);
}
