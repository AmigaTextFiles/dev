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
 * This is a short demo of the js_tools.library listview gadget.
 * It opens a window on workbench and draws some listviews.
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
 */

#define lvwidth     260
#define lvheight    80


/* Uhhh, global variables, my prof would kill me, */
/* but theres is no better/easier way - and there will be no more! */

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
void genSPText(struct List *ls,int nr)
{
    struct tnode *n;
    int i;

    for (i=0;i<100;i++)
    {
        if (n=AllocVec(sizeof(struct tnode),MEMF_CLEAR))
        {
            sprintf(n->txt,"Line %d - SuperListView gadget no. %d",i,nr);
            n->n.ln_Name=n->txt;
            AddTail(ls,(struct Node*)n);
        }
    }
}
void genCDText(struct List *ls,int nr)
{
    struct tcnode *n;
    int i,j;

    for (i=0;i<100;i++)
    {
        if (n=AllocVec(sizeof(struct tcnode),MEMF_CLEAR))
        {
            j=(ULONG)n/(i+1);
            sprintf(n->txt1,"Line %d",i);
            sprintf(n->txt2,"in ListView %d",nr);
            sprintf(n->txt3,"%d",j);
            n->n.ln_Name=n->txt1;
                /* this is only if we would have a string gadget */
            AddTail(ls,(struct Node*)n);
        }
    }
}

struct Gadget *gen1(struct Gadget *gad,struct Window *win,APTR vi,struct List *ls)
{
    /* this is a 100% identical gadtools listview! */
    /* but you better use a 100% js_tools listview! */

    struct NewGadget    ng;
    struct TagItem      ti[]={
        {lv_Labels,0},
        {lv_ScrollWidth,20},
        {lv_ShowSelected,0},
        {lv_NewSelectMode,NSM_NoLine},  /* default is NSM_ExtraLine */
        {TAG_DONE,0}
        };

    ti[0].ti_Data=(ULONG)ls;
    genText(ls,1);

    ng.ng_LeftEdge      =win->BorderLeft+5;
    ng.ng_TopEdge       =win->TopEdge+3;
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
struct Gadget *gen2(struct Gadget *gad,struct Window *win,APTR vi,struct List *ls)
{
    /* this is a multiselection gadget with cursor key support! */

    struct NewGadget    ng;
    struct TagItem      ti[]={
        {lv_Labels,0},
        {lv_ScrollWidth,20},
        {lv_ShowSelected,0},
        {lv_NewSelectMode,NSM_FreeLine},
        {lv_NewSelectLines,3},
        {lv_MarkOn,TRUE},
        {TAG_DONE,0}
        };

    ti[0].ti_Data=(ULONG)ls;
    genText(ls,2);

    ng.ng_LeftEdge      =win->BorderLeft+5+5+lvwidth;
    ng.ng_TopEdge       =win->TopEdge+3;
    ng.ng_Width         =lvwidth;
    ng.ng_Height        =lvheight;
    ng.ng_GadgetText    =NULL; /* Currently not supported. Set to NULL! */
    ng.ng_TextAttr      =&ta;
    ng.ng_GadgetID      =2;
    ng.ng_Flags         =0;
    ng.ng_VisualInfo    =vi;
    ng.ng_UserData      =NULL;
    return LV_CreateListViewA(LISTVIEW1_KIND,gad,&ng,&ti[0]);
}
struct Gadget *gen3(struct Gadget *gad,struct Window *win,APTR vi,struct List *ls)
{
    /* this is a superlistview gadget */

    struct NewGadget    ng;
    struct TagItem      ti[]={
        {lv_Labels,0},
        {lv_ScrollWidth,20},
        {lv_ShowSelected,0},
        {lv_SuperListView,TRUE},
        {TAG_DONE,0}
        };

    ti[0].ti_Data=(ULONG)ls;
    genSPText(ls,3);

    ng.ng_LeftEdge      =win->BorderLeft+5;
    ng.ng_TopEdge       =win->TopEdge+3+5+lvheight;
    ng.ng_Width         =lvwidth;
    ng.ng_Height        =lvheight;
    ng.ng_GadgetText    =NULL; /* Currently not supported. Set to NULL! */
    ng.ng_TextAttr      =&ta;
    ng.ng_GadgetID      =3;
    ng.ng_Flags         =0;
    ng.ng_VisualInfo    =vi;
    ng.ng_UserData      =NULL;
    return LV_CreateListViewA(LISTVIEW1_KIND,gad,&ng,&ti[0]);
}
struct Gadget *gen4(struct Gadget *gad,struct Window *win,APTR vi,struct List *ls,struct ColumnData (*cd)[])
{
    /* this is a columned listview gadget, always marked when clicked */
    /* but with other colours! */

    struct NewGadget    ng;
    struct TagItem      ti[]={
        {lv_Labels,0},
        {lv_ColumnData,0},
        {lv_ScrollWidth,20},
        {lv_ShowSelected,0},
        {lv_AlwaysMark,TRUE},
        {lv_MarkOn,TRUE},
        {TAG_DONE,0}
        };

    ti[0].ti_Data=(ULONG)ls;
    ti[1].ti_Data=(ULONG)cd;
    genCDText(ls,4);

    /* first column, starts left, 60 pixels width */
    (*cd)[0].cd_Offset  =(APTR)offsetof(struct tcnode,txt1);
    (*cd)[0].cd_LeftEdge=0;
    (*cd)[0].cd_Width   =60;
    (*cd)[0].cd_Flags   =0;

    /* 2nd column, starts at pixel 65, 120 pixels width, text is centered */
    (*cd)[1].cd_Offset  =(APTR)offsetof(struct tcnode,txt2);
    (*cd)[1].cd_LeftEdge=65;
    (*cd)[1].cd_Width   =120;
    (*cd)[1].cd_Flags   =cdf_AdjustMid;
    (*cd)[2].cd_Offset  =(APTR)offsetof(struct tcnode,txt3);

    /* 3rd column, starts at pixel 190, 50 pixels width, text is right adjusted */
    (*cd)[2].cd_LeftEdge=190;
    (*cd)[2].cd_Width   =50;
    (*cd)[2].cd_Flags   =cdf_AdjustRight;

    /* end of ColumnData array marked with a NULL element */
    (*cd)[3].cd_Offset  =NULL;
    (*cd)[3].cd_LeftEdge=0;
    (*cd)[3].cd_Width   =0;
    (*cd)[3].cd_Flags   =0;

    ng.ng_LeftEdge      =win->BorderLeft+5+5+lvwidth;
    ng.ng_TopEdge       =win->TopEdge+3+5+lvheight;
    ng.ng_Width         =lvwidth;
    ng.ng_Height        =lvheight;
    ng.ng_GadgetText    =NULL; /* Currently not supported. Set to NULL! */
    ng.ng_TextAttr      =&ta;
    ng.ng_GadgetID      =4;
    ng.ng_Flags         =0;
    ng.ng_VisualInfo    =vi;
    ng.ng_UserData      =NULL;
    return LV_CreateListViewA(LISTVIEW2_KIND,gad,&ng,&ti[0]);
}
struct Gadget *genB(struct Gadget *gad,struct Window *win,APTR vi,char *txt,int x,int width,int nr)
{
    /* make a button */

    struct NewGadget    ng;

    ng.ng_LeftEdge      =win->BorderLeft+5+x;
    ng.ng_TopEdge       =win->TopEdge+3+5+lvheight*2+4;
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
    ng.ng_TopEdge       =win->TopEdge+3+5+lvheight*2+4;
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
    struct List ls1,ls2,ls3,ls4;
    struct ColumnData cd[4];

    struct Gadget       *glp=NULL,*gad;
    APTR                vi=NULL;
    struct Window       *win;
    struct Screen       *scr;
    struct Gadget       *lv1,*lv2,*lv3,*lv4,*txtgg;
    struct IntuiMessage *my_MSG;
    BOOL                ende=FALSE;
    char                buffer[60];

    NewList(&ls1);
    NewList(&ls2);
    NewList(&ls3);
    NewList(&ls4);

    /* well, because we have no own screen and I don't have the time */
    /* to use this PublicScreen things, I open the window and read its */
    /* WScreen. */

    if (win=OpenWindowTags(NULL,WA_Activate,TRUE,
                                WA_CloseGadget,TRUE,
                                WA_DepthGadget,TRUE,
                                WA_DragBar,TRUE,
                                WA_SmartRefresh,TRUE, /* it's a Demo, sorry :-) */
                                WA_IDCMP,LISTVIEWIDCMP|IDCMP_CLOSEWINDOW|IDCMP_RAWKEY,
                                WA_InnerWidth,lvwidth*2+5+5+5,
                                WA_InnerHeight,lvheight*2+3+3+5+12+4,
                                WA_Title,"js_tools Listview Demo",
                                TAG_DONE))
    {
        /* ah, our window is open! */
        scr=win->WScreen;
        if (vi=GetVisualInfoA(scr,NULL))
        {
            gad=CreateContext(&glp);
            if (lv1=gen1(gad,win,vi,&ls1))
            {
                gad=lv1;
            }
            if (lv2=gen2(gad,win,vi,&ls2))
            {
                gad=lv2;
            }
            if (lv3=gen3(gad,win,vi,&ls3))
            {
                gad=lv3;
            }
            if (lv4=gen4(gad,win,vi,&ls4,&cd))
            {
                gad=lv4;
            }
            /* and finally we make 3 gadtools buttons */
            gad=genB(gad,win,vi,"Quit",0,100,10);
            gad=genB(gad,win,vi,"Lock",105,100,11);
            gad=genB(gad,win,vi,"Unlock",210,100,12);
            gad=genT(gad,win,vi,"by J.Schmitz",315,lvwidth*2+5+5-320);
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
                            ende=TRUE;
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
                             * result for lv2. lv4 has to be handled the same way.
                             *
                             */
                            gad=(struct Gadget*)my_MSG->IAddress;
                            switch (gad->GadgetID)
                            {
                                case 10:
                                    ende=TRUE;
                                    break;
                                case 11:
                                    {
                                        /* lock all listviews */
                                        struct TagItem ti[]={
                                            {lv_Disabled,TRUE},
                                            {TAG_DONE,0},
                                            };
                                        LV_SetListViewAttrsA(lv1,win,NULL,&ti[0]);
                                        LV_SetListViewAttrsA(lv2,win,NULL,&ti[0]);
                                        LV_SetListViewAttrsA(lv3,win,NULL,&ti[0]);
                                        LV_SetListViewAttrsA(lv4,win,NULL,&ti[0]);
                                    }
                                    break;
                                case 12:
                                    {
                                        /* unlock all listviews */
                                        struct TagItem ti[]={
                                            {lv_Disabled,FALSE},
                                            {TAG_DONE,0},
                                            };
                                        LV_SetListViewAttrsA(lv1,win,NULL,&ti[0]);
                                        LV_SetListViewAttrsA(lv2,win,NULL,&ti[0]);
                                        LV_SetListViewAttrsA(lv3,win,NULL,&ti[0]);
                                        LV_SetListViewAttrsA(lv4,win,NULL,&ti[0]);
                                    }
                                    break;
                                case 1:
                                    sprintf(buffer,"Listview 1: %d",my_MSG->Code);
                                    textOut(txtgg,win,buffer);
                                    break;
                                case 2:
                                    sprintf(buffer,"Listview 2: %d",my_MSG->Code,my_MSG->MouseY);
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
                                    /* OK, currently this seams to be a useless double way of checking bits */
                                    /* but maybe in later releases of js_tools there would be more qualifiers! */
                                    break;
                                case 3:
                                    sprintf(buffer,"Listview 3: %d",my_MSG->Code);
                                    textOut(txtgg,win,buffer);
                                    break;
                                case 4:
                                    if (my_MSG->Qualifier & MARK_QUALIFIER_SET)
                                    {
                                        /* aha, user made multiselection */
                                        /* in a real program we have to look in */
                                        /* my_MSG->MouseX for the top line of the marked block */
                                        /* and in my_MSG->MouseY for the bottom line. */
                                        /* Well, DEMO... ;-) */

                                        sprintf(buffer,"LV4 ON: %d - %d (Sel: %d)",my_MSG->MouseX,my_MSG->MouseY,my_MSG->Code);
                                        textOut(txtgg,win,buffer);
                                    }
                                    if (my_MSG->Qualifier & MARK_QUALIFIER_CLEAR)
                                    {
                                        /* aha, user made multiOFFselection */
                                        /* in a real program we have to look in */
                                        /* my_MSG->MouseX for the top line of the marked block */
                                        /* and in my_MSG->MouseY for the bottom line. */
                                        /* This is a DEMO! */

                                        sprintf(buffer,"LV4 OFF: %d - %d (Sel: %d)",my_MSG->MouseX,my_MSG->MouseY,my_MSG->Code);
                                        textOut(txtgg,win,buffer);
                                    }
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
                                    /* rawkey is used for listview */
                                    /* now we can find the new selected item */
                                    /* in sel */
                                    /* well, lv2 is a multiselection listview */
                                    /* so we have to check with lv_AskMarkNr if sel */
                                    /* has been marked. */
                                    /* But because this is a DEMO there is no real code */
                                    /* for this!! */

                                    sprintf(buffer,"LV2: %d",sel);
                                    textOut(txtgg,win,buffer);
                                }
                                else
                                {
                                    /* key contains the ASCII value of the pressed key */
                                    /* or 0 if no ASCII value is available. */

                                    sprintf(buffer,"Key pressed: %c (#%d)",key,key);
                                    textOut(txtgg,win,buffer);
                                    if (key==27)
                                    {
                                        ende=TRUE;
                                    }
                                }
                            }
                            break;
                    }
                    LV_ReplyIMsg(my_MSG);
                }
            }
            while (!ende);

            RemoveGList(win,glp,~0);
            LV_FreeListViews(glp);  /* this removed all listviews in this gadget list */
                /* ATTENTION! There is also a LV_FreeListView() without "s" to remove 1 listview */
                /*            But this should only be used for lvExtraWindow or for all listviews in a window */
                /*            e.g. if (lv4) LV_FreeListView(lv4); */
                /*                 if (lv3) LV_FreeListView(lv3); */
                /*             and so on */
            FreeGadgets(glp);
            FreeVisualInfo(vi);
        }
        CloseWindow(win);
    }
    FreeList(&ls4);
    FreeList(&ls3);
    FreeList(&ls2);
    FreeList(&ls1);
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

