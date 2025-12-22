/**************************************************
 *
 * ASCIImui 0.0.7 written by IKE 2/28/03
 *
 * Compiled with gcc 2.95.3-4
 *
 ** IMPORTANT: compile with the "-noixemul" flag **
 *
 * You are free to use this code for any of your
 * projects, if you find this code useful or it
 * helps you, please send me an email! I'd like
 * to hear from you.  This code is EMAILWARE.
 *
 * ikepgh@yahoo.com
 *
 **************************************************/

#include <stdio.h>
#include <string.h>
#include <proto/dos.h>
#include <proto/intuition.h>
#include <proto/graphics.h>
#include <proto/exec.h>
#include <proto/muimaster.h>
#include <libraries/mui.h>
#include <clib/gadtools_protos.h>
#include <MUI/Urltext_mcc.h>

struct GfxBase *GfxBase;
struct IntuitionBase *IntuitionBase;
struct Library *MUIMasterBase;

#define MAKE_ID(a,b,c,d) ((ULONG) (a)<<24 | (ULONG) (b)<<16 | (ULONG) (c)<<8 | (ULONG) (d))

#define TextList(ftxt)  ListviewObject, MUIA_Weight, 50, MUIA_Listview_Input, FALSE, MUIA_Listview_List, FloattextObject, MUIA_Frame, MUIV_Frame_ReadList, MUIA_Background, MUII_ReadListBack, MUIA_Floattext_Text, ftxt, MUIA_Floattext_TabSize, 4, MUIA_Floattext_Justify, TRUE, End, End

#define CONVERT     44
#define CLEAR       45

enum {
    ADD_METHOD=1,

    MEN_PROJECT,MEN_ABOUT,MEN_QUIT,
};

static struct NewMenu MenuData1[]=
{
    {NM_TITLE, "Project",                      0 , 0, 0,  (APTR)MEN_PROJECT },
    {NM_ITEM,  "About ASCIImui",              "?", 0, 0,  (APTR)MEN_ABOUT   },
    {NM_ITEM,  NM_BARLABEL,                    0 , 0, 0,  (APTR)0           },
    {NM_ITEM,  "Quit",                        "Q", 0, 0,  (APTR)MEN_QUIT    },
    {NM_END,   NULL,                           0 , 0, 0,  (APTR)0           },
};

char about_text[] =
"\33cWelcome to ASCIImui Key Converter!\n
© 2003 IKE\n
version 0.0.7 (2/28/03)\n
This program is Emailware.\n
If you use it or the code, please send me an email!\n
Urltext.mcc is © Alfonso Ranieri \n
OpenURL is © Troels Walsted Hansen";

Object *urlTextObject(struct Library *MUIMasterBase,STRPTR url,STRPTR text,ULONG font)
{
    return UrltextObject,
        MUIA_Font,          font,
        MUIA_Urltext_Text,  text,
        MUIA_Urltext_Url,   url,
    End;
}

Object *app, *STR_in, *STR_out;

BOOL running = TRUE;
char *contents;

BOOL Open_Libs(void ){

    if ( !(IntuitionBase=(struct IntuitionBase *) OpenLibrary("intuition.library",39)) )
      return(0);

    if ( !(GfxBase=(struct GfxBase *) OpenLibrary("graphics.library",0)) ){

       CloseLibrary((struct Library *)IntuitionBase);
       return(0);
    }

    if ( !(MUIMasterBase=OpenLibrary(MUIMASTER_NAME,19)) ){

       CloseLibrary((struct Library *)GfxBase);
       CloseLibrary((struct Library *)IntuitionBase);
       return(0);
    }

    return(1);
}

void Close_Libs(void ){

  if ( IntuitionBase )
    CloseLibrary((struct Library *)IntuitionBase);

  if ( GfxBase )
    CloseLibrary((struct Library *)GfxBase);

  if ( MUIMasterBase )
    CloseLibrary(MUIMasterBase);
}

do_ascii() {

     get(STR_in, MUIA_String_Contents, &contents);
     set(STR_out, MUIA_String_Integer, *contents);
                                            
     return(0);
}

do_clear() {

    set(STR_in, MUIA_String_Contents,0);
    set(STR_out, MUIA_String_Contents,0);

    return(0);
}

int main(int argc,char *argv[]) {

  APTR app, window, convert_gad, clear_gad, u1,u3,t0; 

  if ( ! Open_Libs() ){

    printf("Cannot open libs\n");
    return(0);
  }

  app = ApplicationObject,
      MUIA_Application_Title  , "ASCIImui",
      MUIA_Application_Version , "$VER: ASCIImui-0.0.7 (2/28/03)",
      MUIA_Application_Copyright , "©2003, IKE",
      MUIA_Application_Author  , "IKE",
      MUIA_Application_Description, "A MUI program to convert ASCII keys",
      MUIA_Application_Base  , "IKE",

      SubWindow, window = WindowObject,
          MUIA_Window_Title, "ASCIImui",
          MUIA_Window_ID , MAKE_ID('I','K','E','M'),
          MUIA_Window_Menustrip,      MUI_MakeObject(MUIO_MenustripNM,MenuData1,0),

          WindowContents, VGroup,

              Child, TextObject,
                TextFrame,
                MUIA_Background, MUII_TextBack,
                MUIA_Text_Contents, "\33cPlease enter a character\nand then press 'Convert'",
              End,

              Child, ColGroup(2),
                Child, Label2("Enter character you wish to convert:     "),
                Child, STR_in = String("",2),
              End,

              Child, ColGroup(2),
                Child, Label2("The ASCII Code for this character is:  "),
                Child, STR_out = String("",4),
              End,

              Child, HGroup,GroupFrameT("Control Panel"),
                Child, HGroup, GroupFrame,
                MUIA_Group_SameSize, TRUE,
                Child, clear_gad = KeyButton("Clear",'l'),
                Child, convert_gad = KeyButton("Convert",'c'),
                End,
              End,

              Child, VGroup,GroupFrame,
              MUIA_Background, MUII_GroupBack,
              Child, VSpace(0),
              Child, HGroup,
              Child, HSpace(0),
              Child, ColGroup(2),
              Child, HSpace(0),
                Child, u1 = urlTextObject(MUIMasterBase,"http://www.ezcyberspace.com","EZcyberSpace",MUIV_Font_Normal),
              Child, HSpace(0),
                Child, u3 = urlTextObject(MUIMasterBase,"mailto:ikepgh@yahoo.com","send IKE an email!",MUIV_Font_Normal),
              End,
              Child, HSpace(0),
              End,
              Child, VSpace(0),
              End,

              Child, t0 = TextObject,
                MUIA_Frame,         MUIV_Frame_Text,
                MUIA_Background,    MUII_TextBack,
                MUIA_Text_PreParse, (ULONG)"\33c",
              End,
          End,
      End,
  End;

  if (!app){

    printf("Cannot create application!\n");
    return(0);
  }

  DoMethod(window,MUIM_Notify,MUIA_Window_CloseRequest,TRUE,
    app,2,MUIM_Application_ReturnID,MUIV_Application_ReturnID_Quit);

  DoMethod(clear_gad,MUIM_Notify,MUIA_Pressed,FALSE,
    app,2,MUIM_Application_ReturnID,CLEAR);

  DoMethod(convert_gad,MUIM_Notify,MUIA_Pressed,FALSE,
    app,2,MUIM_Application_ReturnID,CONVERT);

  DoMethod(u1,MUIM_Notify,MUIA_Urltext_Url,MUIV_EveryTime,
    t0,3,MUIM_Set,MUIA_Text_Contents,MUIV_TriggerValue);
  DoMethod(u3,MUIM_Notify,MUIA_Urltext_Url,MUIV_EveryTime,
    t0,3,MUIM_Set,MUIA_Text_Contents,MUIV_TriggerValue);

  set(window,MUIA_Window_Open,TRUE);

    while (running) {

         ULONG sigs = 0;
         LONG result;

        switch (DoMethod(app,MUIM_Application_Input,&sigs)) {

                case MUIV_Application_ReturnID_Quit:
                     running = FALSE;
                     break;

                case CONVERT:
                     do_ascii();
                     break;

                case CLEAR:
                     do_clear();
                     break;

                case MEN_ABOUT:
                     MUI_RequestA(app,window,0,"About ASCIImui","*OK",about_text,NULL);
                     break;

                case MEN_QUIT:
                     result=MUI_RequestA(app,0,0,"Quit","_Quit|_Cancel","\33cAre you sure you want\nto quit ASCIImui?",0);
                        if(result==1)
                           running=FALSE;
                     break;
        }

        if (running && sigs) Wait(sigs);
    }

  set(window,MUIA_Window_Open,FALSE);

  MUI_DisposeObject(app);

  Close_Libs();
}

