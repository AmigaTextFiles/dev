/*
** Preferences.c
** 05.09.92 - 24.03.93
*/

#include <clib/macros.h>
#include <pragma/exec_lib.h>
#include <intuition/intuition.h>
#include <pragma/intuition_lib.h>
#include <libraries/Gadget.h>
#include <pragma/Gadget_lib.h>

#define RETURN 13    /* Return key code */
#define ESC 27       /* Escape key code */

#define PREF_SAVE 1
#define PREF_USE 2
#define PREF_LOAD 3
#define PREF_CANCEL 0

static void deftaskpri(struct Gadget *, struct Window *, struct Requester *),
            alttaskpri(struct Gadget *, struct Window *, struct Requester *),
            saveprefs(struct Gadget *, struct Window *, struct Requester *),
            useprefs(struct Gadget *, struct Window *, struct Requester *),
            loadprefs(struct Gadget *, struct Window *, struct Requester *),
            cancelprefs(struct Gadget *, struct Window *, struct Requester *);

void main(void);
void Error(char *);
void CloseAll(void);

int Insert1=TRUE, Insert2=FALSE, Keypad=TRUE, AutoIndent=TRUE,
    Backup=TRUE, ImmediateScroll=TRUE, NormalPri=TRUE, Pri_Alternative=1,
    datahyphen=13, varhyphen=9, memohyphen=0, quotes=TRUE;

struct NewWindow NewWindow =
{
   10, 10, 300, 200,
   AUTOFRONTPEN, AUTOBACKPEN,
   GAD_IDCMPFlags,
   WFLG_DRAGBAR | WFLG_DEPTHGADGET | WFLG_ACTIVATE,
   NULL,
   NULL,
   (UBYTE *)"Preferences (Example)",
   NULL,
   NULL,
   100, 50, -1, -1,
   WBENCHSCREEN,
};

struct IntuitionBase *IntuitionBase = NULL;
struct Library *GadgetBase = NULL;

struct Window *window = NULL;
struct IntuiMessage *imsg;
int ready;

/*
** Main
*/

void main()
{
   LONG  editw = 28*8, edith = 6*14,
         genw = editw, genh = 4*14,
         taskw = 36*8, taskh = 4*14,
         impw = taskw, imph = 6*14,
         mainw = 16+editw+8+taskw+16,
         mainh = 8 + MAX(edith+genh, taskh+imph) + 8;
   LONG  mainx = 8, mainy = 10,
         editx = mainx+16, edity = mainy+8,
         genx = editx, geny = edity+edith,
         taskx = editx+editw+8, tasky=edity,
         impx = taskx, impy = tasky+taskh;
   struct Gadget  *main, *edit, *gen, *task, *imp,
                  *ins1, *ins2, *key, *aut,
                  *back, *imme,
                  *def, *alt, *pri,
                  *data, *fiel, *memo, *quot,
                  *save, *use, *load, *cancel,
                  *gadptr[3];
   LONG x, y, w, h, ende, prefresult;
   ULONG storage;

   if(!(IntuitionBase = (struct IntuitionBase *)
   OpenLibrary((UBYTE *)"intuition.library", 0L)))
      Error("No intuition.library V36!");
   if(!(GadgetBase = OpenLibrary((UBYTE *)"gadget.library", 38L)))
      Error("No gadget.library V38");

   if(!(main = gadAllocGadget(GAD_BEVELBOX_KIND,
      GA_Left,       mainx,
      GA_Top,        mainy,
      GA_Width,      mainw,
      GA_Height,     mainh,
      GADBB_Recessed,   0L,
      GA_Previous,   &NewWindow.FirstGadget,
      TAG_DONE)) ||
   !(edit = gadAllocGadget(GAD_BEVELBOX_KIND,
      GA_Left,       editx,
      GA_Top,        edity,
      GA_Width,      editw,
      GA_Height,     edith,
      GA_Text,       "Edit",
      GA_Previous,   &main->NextGadget,
      TAG_DONE)) ||
   !(gen = gadAllocGadget(GAD_BEVELBOX_KIND,
      GA_Left,       genx,
      GA_Top,        geny,
      GA_Width,      genw,
      GA_Height,     genh,
      GA_Text,       "General",
      GA_Previous,   &edit->NextGadget,
      TAG_DONE)) ||
   !(task = gadAllocGadget(GAD_BEVELBOX_KIND,
      GA_Left,       taskx,
      GA_Top,        tasky,
      GA_Width,      taskw,
      GA_Height,     taskh,
      GA_Text,       "Taskpriority",
      GA_Previous,   &gen->NextGadget,
      TAG_DONE)) ||
   !(imp = gadAllocGadget(GAD_BEVELBOX_KIND,
      GA_Left,       impx,
      GA_Top,        impy,
      GA_Width,      impw,
      GA_Height,     imph,
      GA_Text,       "Import/Export",
      GA_Previous,   &task->NextGadget,
      TAG_DONE)) ||
   !(ins1 = gadAllocGadget(GAD_CHECKBOX_KIND,
      GA_Left,       x = editx+editw-50,
      GA_Top,        y = edity+14,
      GA_Text,       "_Insert Mode?",
      GA_Previous,   &imp->NextGadget,
      TAG_DONE)) ||
   !(ins2 = gadAllocGadget(GAD_CHECKBOX_KIND,
      GA_Left,       x,
      GA_Top,        y+=14,
      GA_Text,       "I_nsert Mode (Memo)?",
      GA_Previous,   &ins1->NextGadget,
      TAG_DONE)) ||
   !(key = gadAllocGadget(GAD_CHECKBOX_KIND,
      GA_Left,       x,
      GA_Top,        y+=14,
      GA_Text,       "_Keypad = Special?",
      GA_Previous,   &ins2->NextGadget,
      TAG_DONE)) ||
   !(aut = gadAllocGadget(GAD_CHECKBOX_KIND,
      GA_Left,       x,
      GA_Top,        y+=14,
      GA_Text,       "_AutoIndent (Memo)?",
      GA_Previous,   &key->NextGadget,
      TAG_DONE)) ||
   !(back = gadAllocGadget(GAD_CHECKBOX_KIND,
      GA_Left,       x,
      GA_Top,        y=geny+14,
      GA_Text,       "_Backup in *.BAK?",
      GA_Previous,   &aut->NextGadget,
      TAG_DONE)) ||
   !(imme = gadAllocGadget(GAD_CHECKBOX_KIND,
      GA_Left,       x,
      GA_Top,        y+=14,
      GA_Text,       "Immediate _Scrolling?",
      GA_Previous,   &back->NextGadget,
      TAG_DONE)) ||
   !(def = gadptr[0] = gadAllocGadget(GAD_RADIOBUTTON_KIND,
      GA_Left,       taskx+taskw/2-50,
      GA_Top,        y=tasky+14,
      GA_Text,       "D_efault",
      GA_Previous,   &imme->NextGadget,
      GA_UserData,   gadptr,
      GAD_CallBack,  deftaskpri,
      TAG_DONE)) ||
   !(alt = gadptr[1] = gadAllocGadget(GAD_RADIOBUTTON_KIND,
      GA_Left,       x=taskx+taskw-50,
      GA_Top,        y,
      GA_Text,       "Al_ternative",
      GA_Previous,   &def->NextGadget,
      GA_UserData,   gadptr,
      GAD_CallBack,  alttaskpri,
      GA_UserData,   def,
      TAG_DONE)) ||
   !(pri = gadptr[2] = gadAllocGadget(GAD_INTEGER_KIND,
      GA_Left,       x,
      GA_Top,        y+=14,
      GA_Text,       "Alternative _Priority:",
      GA_Previous,   &alt->NextGadget,
      GADSTR_Min,    -9L,
      GADSTR_Max,    9L,
      TAG_DONE)) ||
   !(data = gadAllocGadget(GAD_INTEGER_KIND,
      GA_Left,       x,
      GA_Top,        y=impy+14,
      GA_Text,       "Hyphen between _Datasets:",
      GA_Previous,   &pri->NextGadget,
      GADSTR_Min,    0L,
      GADSTR_Max,    255L,
      TAG_DONE)) ||
   !(fiel = gadAllocGadget(GAD_INTEGER_KIND,
      GA_Left,       x,
      GA_Top,        y+=14,
      GA_Text,       "Hyphen between _Fields:",
      GA_Previous,   &data->NextGadget,
      GADSTR_Min,    0L,
      GADSTR_Max,    255L,
      TAG_DONE)) ||
   !(memo = gadAllocGadget(GAD_INTEGER_KIND,
      GA_Left,       x,
      GA_Top,        y+=14,
      GA_Text,       "Hyphen between _Memolines:",
      GA_Previous,   &fiel->NextGadget,
      GADSTR_Min,    0L,
      GADSTR_Max,    255L,
      GADSTR_EndGadget, TRUE,
      TAG_DONE)) ||
   !(quot = gadAllocGadget(GAD_CHECKBOX_KIND,
      GA_Left,       x,
      GA_Top,        y+=14,
      GA_Text,       "Use Double _Quotes?",
      GA_Previous,   &memo->NextGadget,
      TAG_DONE)) ||
   !(save = gadAllocGadget(GAD_BUTTON_KIND,
      GA_Left,       x=mainx+4,
      GA_Top,        y=mainy+mainh,
      GA_Width,      w=88,
      GA_Height,     h=14,
      GA_Text,       "Save",
      GA_Previous,   &quot->NextGadget,
      GAD_CallBack,  saveprefs,
      GA_UserData,   &prefresult,
      GAD_ShortCut,   (LONG)RETURN,
      TAG_DONE)) ||
   !(use = gadAllocGadget(GAD_BUTTON_KIND,
      GA_Left,       x+=(mainw-mainx-w)/3,
      GA_Top,        y,
      GA_Width,      w,
      GA_Height,     h,
      GA_Text,       "_Use",
      GA_Previous,   &save->NextGadget,
      GAD_CallBack,  useprefs,
      GA_UserData,   &prefresult,
      TAG_DONE)) ||
   !(load = gadAllocGadget(GAD_BUTTON_KIND,
      GA_Left,       x+=(mainw-mainx-w)/3,
      GA_Top,        y,
      GA_Width,      w,
      GA_Height,     h,
      GA_Text,       "_Load",
      GA_Previous,   &use->NextGadget,
      GAD_CallBack,  loadprefs,
      GA_UserData,   &prefresult,
      TAG_DONE)) ||
   !(cancel = gadAllocGadget(GAD_BUTTON_KIND,
      GA_Left,       x+=(mainw-mainx-w)/3,
      GA_Top,        y,
      GA_Width,      w,
      GA_Height,     h,
      GA_Text,       "Cancel",
      GA_Previous,   &load->NextGadget,
      GAD_CallBack,  cancelprefs,
      GA_UserData,   &prefresult,
      GAD_ShortCut,  (LONG)ESC,
      TAG_DONE)))
         Error("create gadgets");

   NewWindow.Width = mainx + mainw + mainx;
   NewWindow.Height = mainy + mainh + 20;
   if(!(window = OpenWindow(&NewWindow)))
      Error("No Window");

   do
   {
      gadSetSelectedFlag(ins1, window, NULL, Insert1);
      gadSetSelectedFlag(ins2, window, NULL, Insert2);
      gadSetSelectedFlag(key, window, NULL, Keypad);
      gadSetSelectedFlag(aut, window, NULL, AutoIndent);
      gadSetSelectedFlag(back, window, NULL, Backup);
      gadSetSelectedFlag(imme, window, NULL, ImmediateScroll);
      if(NormalPri)
         deftaskpri(def, window, NULL);
      else
         alttaskpri(alt, window, NULL);
      gadSetGadgetAttrs(pri,  window, NULL,
         GADSTR_LongVal, Pri_Alternative,
         TAG_DONE);
      gadSetGadgetAttrs(data, window, NULL,
         GADSTR_LongVal, datahyphen,
         TAG_DONE);
      gadSetGadgetAttrs(fiel, window, NULL,
         GADSTR_LongVal, varhyphen,
         TAG_DONE);
      gadSetGadgetAttrs(memo, window, NULL,
         GADSTR_LongVal, memohyphen,
         TAG_DONE);
      gadSetSelectedFlag(quot, window, NULL, quotes);

      ready=FALSE;
      while(!ready)
      {
         if(!(imsg = (struct IntuiMessage *)GetMsg(window->UserPort)))
         {
            Wait(1L << window->UserPort->mp_SigBit);
            continue;
         }
         gadFilterMessage(imsg, 0);    /* let gadget.library examine the
                                          message */
         ReplyMsg((struct Message *)imsg);
      }

      switch(prefresult)
      {
         case  PREF_SAVE:
         case  PREF_USE:

            Insert1 = (ins1->Flags & SELECTED) != 0;
            Insert2 = (ins2->Flags & SELECTED) != 0;
            Keypad = (key->Flags & SELECTED) != 0;
            AutoIndent = (aut->Flags & SELECTED) != 0;
            Backup = (back->Flags & SELECTED) != 0;
            ImmediateScroll = (imme->Flags & SELECTED) != 0;
            NormalPri = (def->Flags & SELECTED) != 0;

            gadGetGadgetAttr(GADSTR_LongVal, pri, &storage);
            Pri_Alternative = storage;

            gadGetGadgetAttr(GADSTR_LongVal, data, &storage);
            datahyphen = storage;

            gadGetGadgetAttr(GADSTR_LongVal, fiel, &storage);
            varhyphen = storage;

            gadGetGadgetAttr(GADSTR_LongVal, memo, &storage);
            memohyphen = storage;

            quotes = (quot->Flags & SELECTED) != 0;

            if(prefresult == PREF_SAVE)
               printf("SAVE\n\n");
            else
               printf("USE\n\n");

            printf("Insert1:     %d\n", Insert1);
            printf("Insert2:     %d\n", Insert2);
            printf("Keypad:      %d\n", Keypad);
            printf("AutoIndent:  %d\n", AutoIndent);
            printf("Backup:      %d\n", Backup);
            printf("ImmediateScroll: %d\n", ImmediateScroll);
            printf("NormalPri:   %d\n", NormalPri);
            printf("Pri_Alternative: %d\n", Pri_Alternative);
            printf("datahyphen   %d\n", datahyphen);
            printf("varhyphen:   %d\n", varhyphen);
            printf("memohyphen:  %d\n", memohyphen);
            printf("quotes:      %d\n", quotes);
            ende = TRUE;
            break;

         case  PREF_LOAD:

            printf("LOAD\n\n");
            ende = FALSE;
            break;

         case  PREF_CANCEL:

            printf("CANCEL\n\n");
            ende = TRUE;
            break;
      }
   }while(!ende);

   CloseAll();
   exit(0);
}

void Error(char *text)
{
   puts(text);
   CloseAll();
   exit(1);
}

void CloseAll(void)
{
	if(window)
		CloseWindow(window);
   if(NewWindow.FirstGadget)
      gadFreeGadgetList(NewWindow.FirstGadget);

   if(GadgetBase)
      CloseLibrary(GadgetBase);
   if(IntuitionBase)
      CloseLibrary((struct Library *)IntuitionBase);
}

static void deftaskpri(struct Gadget *def, struct Window *w, struct Requester *req)
{
   struct Gadget **gadptr = (struct Gadget **)def->UserData;

   gadSetSelectedFlag(gadptr[0], w, req, 1);
   gadSetSelectedFlag(gadptr[1], w, req, 0);
   gadSetDisabledFlag(gadptr[2], w, req, 1);
}

static void alttaskpri(struct Gadget *alt, struct Window *w, struct Requester *req)
{
   struct Gadget **gadptr = (struct Gadget **)alt->UserData;

   gadSetSelectedFlag(gadptr[0], w, req, 0);
   gadSetSelectedFlag(gadptr[1], w, req, 1);
   gadSetDisabledFlag(gadptr[2], w, req, 0);
}

static void saveprefs(struct Gadget *gad, struct Window *w, struct Requester *req)
{
   *(ULONG *)gad->UserData = PREF_SAVE;
   ready = TRUE;
}

static void useprefs(struct Gadget *gad, struct Window *w, struct Requester *req)
{
   *(ULONG *)gad->UserData = PREF_USE;
   ready = TRUE;
}

static void loadprefs(struct Gadget *gad, struct Window *w, struct Requester *req)
{
   *(ULONG *)gad->UserData = PREF_LOAD;
   ready = TRUE;
}

static void cancelprefs(struct Gadget *gad, struct Window *w, struct Requester *req)
{
   *(ULONG *)gad->UserData = PREF_CANCEL;
   ready = TRUE;
}

