/*
 * misc.c  V3.1
 *
 * Preferences editor miscellaneous routines
 *
 * Copyright (C) 1990-98 Stefan Becker
 *
 * This source code is for educational purposes only. You may study it
 * and copy ideas or algorithms from it for your own projects. It is
 * not allowed to use any of the source codes (in full or in parts)
 * in other programs. Especially it is not allowed to create variants
 * of ToolManager or ToolManager-like programs from this source code.
 *
 */

#include "toolmanager.h"

#ifdef _DCC
/* VarArgs stub for NewObjectA */
APTR NewObject(struct IClass *class, UBYTE *classID, Tag tag1, ... )
{
 return(NewObjectA(class, classID, (struct TagItem *) &tag1));
}

/* VarArgs stub for SetAttrsA */
ULONG SetAttrs(APTR obj, Tag tag1, ...)
{
 return(SetAttrsA(obj, (struct TagItem *) &tag1));
}

/* VarArgs stub for MUI_NewObjectA */
Object *MUI_NewObject(char *classname, Tag tag1, ...)
{
 return(MUI_NewObjectA(classname, (struct TagItem *) &tag1));
}

/* VarArgs stub for MUI_MakeObjectA */
Object *MUI_MakeObject(LONG type, ...)
{
 return(MUI_MakeObjectA(type, (ULONG *) &type + 1));
}

/* VarArgs stub for MUI_RequestA */
LONG MUI_Request(APTR app, APTR win, LONGBITS flags, char *title,
                 char *gadgets, char *format, ...)
{
 return(MUI_RequestA(app, win, flags, title, gadgets, format,
                     (APTR) (&format + 1)));
}

/* VarArgs stub for MUI_AllocAslRequest */
APTR MUI_AllocAslRequestTags(ULONG type, Tag tag1, ...)
{
 return(MUI_AllocAslRequest(type, (struct TagItem *) &tag1));
}

/* VarArgs stub for MUI_AslRequestTags */
BOOL MUI_AslRequestTags(APTR req, Tag tag1, ...)
{
 return(MUI_AslRequest(req, (struct TagItem *) &tag1));
}

/* MUI class names */
const char MUIC_Application[]   = "Application.mui";
const char MUIC_Cycle[]         = "Cycle.mui";
const char MUIC_Group[]         = "Group.mui";
const char MUIC_List[]          = "List.mui";
const char MUIC_Listtree[]      = "Listtree.mcc";
const char MUIC_Listview[]      = "Listview.mui";
const char MUIC_Menu[]          = "Menu.mui";
const char MUIC_Menuitem[]      = "Menuitem.mui";
const char MUIC_Menustrip[]     = "Menustrip.mui";
const char MUIC_Numericbutton[] = "Numericbutton.mui";
const char MUIC_Popasl[]        = "Popasl.mui";
const char MUIC_Pophotkey[]     = "Pophotkey.mcc";
const char MUIC_Poplist[]       = "Poplist.mui";
const char MUIC_Popscreen[]     = "Popscreen.mui";
const char MUIC_Popport[]       = "Popport.mcc";
const char MUIC_Popposition[]   = "Popposition.mcc";
const char MUIC_Register[]      = "Register.mui";
const char MUIC_String[]        = "String.mui";
const char MUIC_Text[]          = "Text.mui";
const char MUIC_Window[]        = "Window.mui";
#endif

/* Perform OM_NEW method on super class */
ULONG DoSuperNew(Class *cl, Object *obj, Tag tag1, ...)
{
 return(DoSuperMethod(cl, obj, OM_NEW, &tag1, NULL));
}

/* Duplicate a string */
#undef  DEBUGFUNCTION
#define DEBUGFUNCTION DuplicateString
char *DuplicateString(const char *s)
{
 char *rc;

 /* Allocate memory for string and copy string */
 if (rc = GetVector(strlen(s) + 1)) strcpy(rc, s);

 MISC_LOG(LOG1(Result, "0x%08lx", rc))

 /* Return pointer to new string */
 return(rc);
}

/* Duplicate a string from a MUI string object */
#undef  DEBUGFUNCTION
#define DEBUGFUNCTION GetStringContents
char *GetStringContents(Object *obj, const char *s)
{
 char *rc;

 /* Get string contents */
 GetAttr(MUIA_String_Contents, obj, (ULONG *) &rc);

 MISC_LOG(LOG2(Contents, "'%s' (0x%08lx)", rc, rc))

 /* Return NULL for empty string otherwise duplicate new contents*/
 rc = (*rc == '\0') ? NULL : DuplicateString(rc);

 /* Old string valid? Free it */
 if (s) FreeVector(s);

 MISC_LOG(LOG1(Result, "0x%08lx", rc))

 /* Return pointer to new/old string */
 return(rc);
}

/* Get state of checkmark gadget and return "value" if selected */
#undef  DEBUGFUNCTION
#define DEBUGFUNCTION GetCheckmarkState
ULONG GetCheckmarkState(Object *obj, ULONG value)
{
 ULONG state;

 /* Get checkmark state */
 GetAttr(MUIA_Selected, obj, &state);

 MISC_LOG(LOG1(State, "%ld", state))

 /* Return 0 or "value" depending on selected state */
 return(state ? value : 0);
}

/* Get state of checkit menu item and return "value" if selected */
#undef  DEBUGFUNCTION
#define DEBUGFUNCTION GetCheckitState
ULONG GetCheckitState(Object *obj, ULONG value)
{
 ULONG state;

 /* Get checkmark state */
 GetAttr(MUIA_Menuitem_Checked, obj, &state);

 MISC_LOG(LOG1(State, "%ld", state))

 /* Return 0 or "value" depending on selected state */
 return(state ? value : 0);
}

/* Get attach data from DropArea object */
#undef  DEBUGFUNCTION
#define DEBUGFUNCTION GetAttachData
struct AttachData *GetAttachData(Object *drop, Object *obj,
                                 struct AttachData *old)
{
 struct AttachData *rc  = NULL;
 struct AttachData *new;

 /* Detach old object */
 if (old) DoMethod(old->ad_Object, TMM_Detach, old);

 /* Ask DropArea object about attach data */
 GetAttr(TMA_Attach, drop, (ULONG *) &new);

 MISC_LOG(LOG1(Attach, "0x%08lx", new))

 /* Data valid? Yes, attach to new object */
 if (new) rc = (struct AttachData *) DoMethod(new->ad_Object, TMM_Attach, obj);

 MISC_LOG(LOG1(Result, "0x%08lx", rc))

 /* Return pointer to new attach data */
 return(rc);
}

/* Set disabled state of a gadget */
#undef  DEBUGFUNCTION
#define DEBUGFUNCTION SetDisabledState
void SetDisabledState(Object *obj, ULONG state)
{
 MISC_LOG(LOG1(State, "%ld", state))

 SetAttrs(obj, MUIA_Disabled, state, TAG_DONE);
}

/* Make a button and insert it into the TAB cycle chain */
#undef  DEBUGFUNCTION
#define DEBUGFUNCTION MakeButton
Object *MakeButton(const char *label, const char *help)
{
 Object *rc;

 /* Create button */
 if (rc = SimpleButton(label)) {

  MISC_LOG(LOG0(Button created))

  /* Insert into cycle chain and add bubble help */
  SetAttrs(rc, MUIA_CycleChain, TRUE,
               MUIA_ShortHelp,  help,
               TAG_DONE);
 }

 MISC_LOG(LOG1(Result, "0x%08lx", rc))

 return(rc);
}

/* Make a checkmark and insert it into the TAB cycle chain */
#undef  DEBUGFUNCTION
#define DEBUGFUNCTION MakeCheckmark
Object *MakeCheckmark(ULONG selected, const char *help)
{
 Object *rc;

 /* Create button */
 if (rc = MUI_MakeObject(MUIO_Checkmark, NULL)) {

  MISC_LOG(LOG0(Button created))

  /* Set selected state,insert into cycle chain and add bubble help */
  SetAttrs(rc, MUIA_Selected,   selected,
               MUIA_CycleChain, TRUE,
               MUIA_ShortHelp,  help,
               TAG_DONE);
 }

 MISC_LOG(LOG1(Result, "0x%08lx", rc))

 return(rc);
}

/* Include global miscellaneous code */
#include "/global_misc.c"
