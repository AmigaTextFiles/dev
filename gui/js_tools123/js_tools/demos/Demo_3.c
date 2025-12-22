#include <exec/types.h>
#include <proto/exec.h>
#include <exec/memory.h>
#include <proto/js_tools.h>
#include <js_tools.h>
#include <proto/intuition.h>
#include <intuition/intuition.h>
#include <proto/gadtools.h>
#include <libraries/gadtools.h>
#include <stdlib.h>
#include <stdio.h>
#include <stddef.h>

/*
 * This is a short demo of the js_tools.library lvExtraWindow gadget.
 * It opens a window on workbench and draws some listviews and opens
 * a lvExtraWindow
 * This in no realy good code, its a DEMO CODE!
 *
 * js_tools.library is copyright (c) by J.Schmitz in 1995
 * and may be free copied and used as freeware
 *
 * This Demo is copyright (c) by J.Schmitz in 1995
 * and may be free copied and used with the js_tools.library distribution.
 * Parts of the code may be used in own programs.
 * Military use of js_tools.library or this demo if not allowed!
 *
 * First parts are only a copy of Demo_2.
 *
 */

#define lvwidth     260
#define lvheight    80

struct Library  *JS_ToolsBase;
struct Library  *GadtoolsBase;
struct IntuitionBase *IntuitionBase;

/* hm, a contant variable.... */
/* I use topaz 8 because it's easier to do in a demo! */
struct TextAttr ta={"topaz.font",8,0,0};


/* here a struct for our texts */
struct tnode {
    struct Node n;
    char        txt[60];
};

/* here a struct for our multi column texts */
struct tcnode {
    struct Node n;
    char        txt1[20];
    char        txt2[20];
    char        txt3[10];
};

void FreeList(struct List *ls)
{
    struct Node *n;

    while (n=RemTail(ls))
    {
        FreeVec(n);
    }
}

void genText(struct List *ls,int nr)
{
    struct tnode *n;
    int i;

    for (i=0;i<100;i++)
    {
        if (n=AllocVec(sizeof(struct tnode),MEMF_CLEAR))
        {
            sprintf(n->txt,"Line %d - LV %d",i,nr);
            n->n.ln_Name=n->txt;
            AddTail(ls,(struct Node*)n);
        }
    }
}

struct Gadget *gen1(struct Gadget *gad,struct Window *win,APTR vi,char *txt)
{
    /* A listview for our window: READONLY with FormatText freature */
    /* This listview should have key "r" as keyboard shortcut. */
    /* But currently js_tools listview doesn't support GadgetText, */
    /* so we make a tick with a gadtools TEXT_KIND gadget. */

    struct NewGadget    ng;
    struct TagItem      ti[]={
        {lv_FormatText,0},
        {lv_ScrollWidth,20},
        {lv_ReadOnly,TRUE},
        {TAG_DONE,0}
        };
    struct TagItem      ti2[]={
        {GTTX_Border,FALSE},
        {GT_Underscore,'_'},
        {TAG_DONE,0}
        };

    ti[0].ti_Data=(ULONG)txt;

    ng.ng_LeftEdge      =win->BorderLeft+5;
    ng.ng_TopEdge       =win->TopEdge+3+12;
    ng.ng_Width         =lvwidth;
    ng.ng_Height        =0;
    ng.ng_GadgetText    ="_readonly";
    ng.ng_TextAttr      =&ta;
    ng.ng_GadgetID      =0;
    ng.ng_Flags         =PLACETEXT_ABOVE;
    ng.ng_VisualInfo    =vi;
    ng.ng_UserData      =NULL;
    gad=CreateGadgetA(TEXT_KIND,gad,&ng,&ti2[0]);

    ng.ng_LeftEdge      =win->BorderLeft+5;
    ng.ng_TopEdge       =win->TopEdge+3+12;
    ng.ng_Width         =lvwidth;
    ng.ng_Height        =lvheight;
    ng.ng_GadgetText    =NULL; /* Currently not supported. Set to NULL! */
    ng.ng_TextAttr      =&ta;
    ng.ng_GadgetID      =1;
    ng.ng_Flags         =0;
    ng.ng_VisualInfo    =vi;
    ng.ng_UserData      =NULL;
    return LV_CreateListViewA(LISTVIEW1_KIND,gad,&ng,&ti[0]);
}
struct Gadget *genLX(struct Window *win,APTR vi,struct List *ls)
{
    /* this is our lvExtraWindow gadget! */
    /* it has mark mode active */

    struct lvExtraWindow    lvew;
    struct TagItem      ti[]={
        {lv_Labels,0},
        {lv_ScrollWidth,20},
        {lv_ShowSelected,0},
        {lv_MarkOn,TRUE},
        {TAG_DONE,0}
        };

    ti[0].ti_Data=(ULONG)ls;
    genText(ls,2);

    lvew.lvx_win    =win;
    lvew.lvx_vi     =vi;
    lvew.lvx_TextAttr   =&ta;
    lvew.lvx_LeftEdge   =win->LeftEdge+win->Width;
    lvew.lvx_TopEdge    =win->TopEdge+win->BorderTop;
    lvew.lvx_Width      =200;
    lvew.lvx_Height     =100;
    lvew.lvx_MaxWidth   =0;             /* no limit */
    lvew.lvx_MaxHeight  =0;
    lvew.lvx_GadgetID   =2;
    lvew.lvx_UserData   =NULL;
    lvew.lvx_Title      ="lvExtraWindow Title";
    lvew.lvx_Flags      =LVXF_RAWKEY | LVXF_CLOSEGADGET | LVXF_DRAGGADGET | LVXF_SIZEGADGET;
                /* we want IDCMP_RAWKEY and a CLOSEGADGET with IDCMP_CLOSEWINDOW */

    return LV_CreateExtraListViewA(&lvew,&ti[0]);
}

struct Gadget *genB(struct Gadget *gad,struct Window *win,APTR vi,char *txt,int x,int width,int nr)
{
    /* make a button */

    struct NewGadget    ng;

    ng.ng_LeftEdge      =win->BorderLeft+5+x;
    ng.ng_TopEdge       =win->TopEdge+3+lvheight+4+12;
    ng.ng_Width         =width;
    ng.ng_Height        =12;
    ng.ng_GadgetText    =txt;
    ng.ng_TextAttr      =&ta;
    ng.ng_GadgetID      =nr;
    ng.ng_Flags         =PLACETEXT_IN;
    ng.ng_VisualInfo    =vi;
    ng.ng_UserData      =NULL;
    return CreateGadgetA(BUTTON_KIND,gad,&ng,NULL);
}
struct Gadget *genT(struct Gadget *gad,struct Window *win,APTR vi,char *txt,int x,int width)
{
    /* make a button */

    struct NewGadget    ng;
    struct TagItem      ti[]={
        {GTTX_Text,0},
        {GTTX_Border,TRUE},
        {TAG_DONE,0}
        };

    ti[0].ti_Data=(ULONG)txt;

    ng.ng_LeftEdge      =win->BorderLeft+5+x;
    ng.ng_TopEdge       =win->TopEdge+3+lvheight+4+12;
    ng.ng_Width         =width;
    ng.ng_Height        =12;
    ng.ng_GadgetText    =NULL;
    ng.ng_TextAttr      =&ta;
    ng.ng_GadgetID      =0;
    ng.ng_Flags         =PLACETEXT_LEFT;
    ng.ng_VisualInfo    =vi;
    ng.ng_UserData      =NULL;
    return CreateGadgetA(TEXT_KIND,gad,&ng,&ti[0]);
}
void textOut(struct Gadget *gad,struct Window *win,char *txt)
{
    struct TagItem ti[]={
        {GTTX_Text,0},
        {TAG_DONE,0},
        };
    ti[0].ti_Data=(ULONG)txt;
    GT_SetGadgetAttrsA(gad,win,NULL,&ti[0]);
}

void TheDemo(void)
{
    /* first, we need some (struct List) or (struct MinList) */
    /* I take (struct List) in this demo because then I have so write */
    /* no so much casts! */
    struct List ls2;

    struct Gadget       *glp=NULL,*gad;
    APTR                vi=NULL;
    struct Window       *win;
    struct Screen       *scr;
    struct Gadget       *lv1,*lv2,*txtgg;
    struct IntuiMessage *my_MSG;
    BOOL                ende=FALSE;
    char                buffer[60];
    char                gg1txt[]=   /* the text for our readonly listview */
       "This is a Demo of the lvExtraWindow and the FormatText function.\n\nClick and feel!\n\\
       The text here is formated automatically for this listview.\nYou may move up und down with\\
       R and SHIFT R. ALT R and SHIFT ALT R moves to top or bottom.\n\n\n\\
       The lvExtraWindow listview can be handled with the cursor keys and SPACE.\n\n\\
       Try it....";

    NewList(&ls2);

    /* well, because we have no own screen and I don't have the time */
    /* to use this PublicScreen things, I open the window and read its */
    /* WScreen. */

    if (win=OpenWindowTags(NULL,WA_Activate,TRUE,
                                WA_CloseGadget,TRUE,
                                WA_DepthGadget,TRUE,
                                WA_DragBar,TRUE,
                                WA_SmartRefresh,TRUE, /* it's a Demo, sorry :-) */
                                WA_IDCMP,LISTVIEWIDCMP|IDCMP_CLOSEWINDOW|IDCMP_RAWKEY,
                                WA_InnerWidth,lvwidth+5+5,
                                WA_InnerHeight,lvheight+3+3+12+4+12,
                                WA_Title,"js_tools Listview Demo",
                                TAG_DONE))
    {
        /* ah, our window is open! */
        scr=win->WScreen;
        if (vi=GetVisualInfoA(scr,NULL))
        {
            gad=CreateContext(&glp);
            if (lv1=gen1(gad,win,vi,gg1txt))
            {
                gad=lv1;
            }
            lv2=genLX(win,vi,&ls2);
              /* this is no gadget of our gadget list */
              /* so we MUST NOT apply it to this! */

            /* and finally we make QUIT gadtools button */
            gad=genB(gad,win,vi,"Quit",0,100,10);
            gad=genT(gad,win,vi,"by J.Schmitz",105,lvwidth+5+5-110);
            txtgg=gad;

            AddGList(win,glp,~0,~0,NULL);
            RefreshGList(glp,win,NULL,-1);
            LV_RefreshWindow(win,NULL);

            do
            {
                my_MSG=(struct IntuiMessage*)WaitPort(win->UserPort);
                my_MSG=LV_GetIMsg(win->UserPort);
                if (my_MSG)
                {
                    switch (my_MSG->Class)
                    {
                        case IDCMP_CLOSEWINDOW:
                            /* well, CLOSEWINDOW could also be send from the lvExtraWindow! */
                            /* so we have to check this! */
                            if (my_MSG->IDCMPWindow==win)
                            {
                                /* this is our window */
                                ende=TRUE;
                            }
                            else
                            {
                                /* aha, from a lvExtraWindow */
                                /* to see which of them (well, we have only one, */
                                /* but if we had more....) */
                                if (my_MSG->IAddress==lv2)
                                {
                                    textOut(txtgg,win,"Close lvExtraWindow.");

                                    /* OK, this is from our lvExtraWindow 1 (if we had more) */
                                    /* The user told use to close it, so we close it */
                                    /* BUT BEFORE WE MUST REPLY THE MESSAGE WE GOT!!! */
                                    /* (or intuiton will crash. */
                                                                        LV_ReplyIMsg(my_MSG);
                                    LV_FreeListView(lv2);

                                    /* to remember that is has been close we set the pointer to NULL */
                                    /* you MUST NOT use this pointer again - the window is closed and gone! */
                                    lv2=NULL;
                                    /* and the same trick for the IntuiMessage */
                                    /* as it is save to give LV_ReplyIMsg() a NULL pointer there no problem! */
                                    my_MSG=NULL;
                                }
                            }
                            break;
                        case IDCMP_GADGETUP:
                        case IDCMP_GADGETDOWN:
                            /*
                             * the user selected something
                             * we can find the number in my_MSG->Code
                             * and the gadget in my_MSG->IAddress
                             *
                             * we have a DEMO, so I don't write here some
                             * usefull code!
                             * Only a example to show you the multiselection-
                             * result for lv2 - like Demo 2.
                             *
                             */
                            gad=(struct Gadget*)my_MSG->IAddress;
                            switch (gad->GadgetID)
                            {
                                case 10:
                                    ende=TRUE;
                                    break;
                                case 1:
                                    /* well, this is really impossible! */
                                    /* we have a readonly listview here. */
                                    break;
                                case 2:
                                    sprintf(buffer,"lvExtraWindow: %d",my_MSG->Code,my_MSG->MouseY);
                                    textOut(txtgg,win,buffer);

                                    if (my_MSG->Qualifier & MARK_QUALIFIER_SET)
                                    {
                                        /* aha, user made multiselection */
                                        /* in a real program we have to look in */
                                        /* my_MSG->MouseX for the top line of the marked block */
                                        /* and in my_MSG->MouseY for the bottom line. */
                                        /* Well, this is a DEMO, and you know... ;-) */

                                        sprintf(buffer,"Multi ON: %d - %d (Sel: %d)",my_MSG->MouseX,my_MSG->MouseY,my_MSG->Code);
                                        textOut(txtgg,win,buffer);
                                    }
                                    if (my_MSG->Qualifier & MARK_QUALIFIER_CLEAR)
                                    {
                                        /* aha, user made multiOFFselection */
                                        /* in a real program we have to look in */
                                        /* my_MSG->MouseX for the top line of the marked block */
                                        /* and in my_MSG->MouseY for the bottom line. */
                                        /* Only a DEMO. */

                                        sprintf(buffer,"Multi OFF: %d - %d (Sel: %d)",my_MSG->MouseX,my_MSG->MouseY,my_MSG->Code);
                                        textOut(txtgg,win,buffer);
                                    }
                                    /* this lvExtraWindow is handles the same way as any other listview */
                                    break;
                            }
                            break;
                        case IDCMP_RAWKEY:
                            {
                                struct TagItem ti[2];
                                ULONG sel;
                                int key;
                                ti[0].ti_Tag =lv_Selected;
                                ti[0].ti_Data=(ULONG)&sel;
                                ti[1].ti_Tag =TAG_DONE;
                                if ((key=LV_KeyHandler(lv2,my_MSG,0,&ti[0]))<0)
                                {
                                    /* rawkey is used for listview - here lvExtraWindow */
                                    /* same like Demo 2 ! */

                                    sprintf(buffer,"lvExtraWindow: %d",sel);
                                    textOut(txtgg,win,buffer);
                                }
                                else
                                {
                                    /* OK, once again with the "r" key for our readonly listview */
                                    /* Readonly need no taglist here, so we give it a NULL */
                                    if ((key=LV_KeyHandler(lv1,my_MSG,'r',NULL))>=0)
                                    {
                                        /* key contains the ASCII value of the pressed key */
                                        /* or 0 if no ASCII value is available. */

                                        sprintf(buffer,"Key: %c (#%d)",key,key);
                                        textOut(txtgg,win,buffer);
                                        if (key==27)
                                        {
                                            ende=TRUE;
                                        }
                                    }
                                }
                                /* aha, lvExtraWindows are handled as a normal part of the window. */
                            }
                            break;
                    }
                    LV_ReplyIMsg(my_MSG);
                }
            }
            while (!ende);

            RemoveGList(win,glp,~0);
            if (lv2)
            {   
                LV_FreeListView(lv2);   /* this removes and closes the lvExtraWindow */
            }
            LV_FreeListViews(glp);  /* this removed all listviews in this gadget list */

            FreeGadgets(glp);
            FreeVisualInfo(vi);
        }
        CloseWindow(win);
    }
    FreeList(&ls2);
}

void main(void)
{
    if (JS_ToolsBase=OpenLibrary("js_tools.library",37))
    {
        /* yea, we got it! */
        if (GadtoolsBase=OpenLibrary("gadtools.library",37))
        {
            if (IntuitionBase=(struct IntuitionBase*)OpenLibrary("intuition.library",37))
            {
                /* everything is fine, now, let's start! */

                TheDemo();

                CloseLibrary((struct Library*)IntuitionBase);
            }
            CloseLibrary(GadtoolsBase);
        }
        CloseLibrary(JS_ToolsBase);
    }
}

