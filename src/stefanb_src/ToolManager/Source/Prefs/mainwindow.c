/*
 * mainwindow.c  V3.1
 *
 * Main window class
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

/* Local data */
static const char *TextObjects[TMOBJTYPES + 1];

/* Menu ids */
enum { MENUID_OPEN      = 1000,
       MENUID_APPEND,
       MENUID_SAVEAS,
       MENUID_CLIPBOARD,
       MENUID_ABOUT,
       MENUID_ABOUTMUI,
       MENUID_QUIT,
       MENUID_LASTSAVED,
       MENUID_RESTORE,
       MENUID_GLOBAL,
       MENUID_MUI
};

/* MainWindow class instance data */
struct MainWindowClassData {
 Object     *mwcd_Icons;
 Object     *mwcd_Register;
 Object     *mwcd_Lists[TMOBJTYPES];
 const char *mwcd_DefaultFile;
};
#define TYPED_INST_DATA(cl, o) ((struct MainWindowClassData *) INST_DATA((cl), (o)))

/* MainWindow class method: OM_NEW */
#undef  DEBUGFUNCTION
#define DEBUGFUNCTION MainWindowClassNew
static ULONG MainWindowClassNew(Class *cl, Object *obj, struct opSet *ops)
{
 char   *file;
 Object *rc   = NULL;

 /* Duplicate default file name */
 if (file = DuplicateString("SYS:Prefs/Presets/" TMCONFIGNAME)) {
  Object *Icons;
  Object *Register;
  Object *SaveButton;
  Object *UseButton;
  Object *TestButton;
  Object *CancelButton;
  Object *Lists[TMOBJTYPES];

  MAINWINDOW_LOG((LOG1(Tags, "0x%08lx", ops->ops_AttrList),
                  PrintTagList(ops->ops_AttrList)))

  if (rc = (Object *) DoSuperNew(cl, obj,
       MUIA_Window_Title,     TextGlobalTitle,
       MUIA_Window_ID,        MAKE_ID('M','A','I','N'),
       MUIA_Window_AppWindow, TRUE,
       MUIA_Window_Menustrip, MenustripObject,
        MUIA_Family_Child, MenuObject,
         MUIA_Menu_Title,  TranslateString(
                    LOCALE_TEXT_MAINWINDOW_MENU_PROJECT_TITLE_STR,
                    LOCALE_TEXT_MAINWINDOW_MENU_PROJECT_TITLE),
         MUIA_Family_Child,       MenuitemObject,
          MUIA_Menuitem_Title,    TranslateString(
                    LOCALE_TEXT_MAINWINDOW_MENU_PROJECT_OPEN_STR,
                    LOCALE_TEXT_MAINWINDOW_MENU_PROJECT_OPEN),
          MUIA_Menuitem_Shortcut, TranslateString(
                    LOCALE_TEXT_MAINWINDOW_MENU_PROJECT_OPEN_SHORTCUT_STR,
                    LOCALE_TEXT_MAINWINDOW_MENU_PROJECT_OPEN_SHORTCUT),
          MUIA_UserData,          MENUID_OPEN,
         End,
         MUIA_Family_Child,       MenuitemObject,
          MUIA_Menuitem_Title,    TranslateString(
                    LOCALE_TEXT_MAINWINDOW_MENU_PROJECT_APPEND_STR,
                    LOCALE_TEXT_MAINWINDOW_MENU_PROJECT_APPEND),
          MUIA_UserData,          MENUID_APPEND,
         End,
         MUIA_Family_Child,       MenuitemObject,
          MUIA_Menuitem_Title,    TranslateString(
                    LOCALE_TEXT_MAINWINDOW_MENU_PROJECT_SAVEAS_STR,
                    LOCALE_TEXT_MAINWINDOW_MENU_PROJECT_SAVEAS),
          MUIA_Menuitem_Shortcut, TranslateString(
                    LOCALE_TEXT_MAINWINDOW_MENU_PROJECT_SAVEAS_SHORTCUT_STR,
                    LOCALE_TEXT_MAINWINDOW_MENU_PROJECT_SAVEAS_SHORTCUT),
          MUIA_UserData,          MENUID_SAVEAS,
         End,
         MUIA_Family_Child,       MenuitemObject,
          MUIA_Menuitem_Title,    NM_BARLABEL,
         End,
         MUIA_Family_Child,       MenuitemObject,
          MUIA_Menuitem_Title,    TranslateString(
                    LOCALE_TEXT_MAINWINDOW_MENU_PROJECT_CLIPBOARD_STR,
                    LOCALE_TEXT_MAINWINDOW_MENU_PROJECT_CLIPBOARD),
          MUIA_Menuitem_Shortcut, TranslateString(
                    LOCALE_TEXT_MAINWINDOW_MENU_PROJECT_CLIPBOARD_SHORTCUT_STR,
                    LOCALE_TEXT_MAINWINDOW_MENU_PROJECT_CLIPBOARD_SHORTCUT),
          MUIA_UserData,          MENUID_CLIPBOARD,
         End,
         MUIA_Family_Child,       MenuitemObject,
          MUIA_Menuitem_Title,    NM_BARLABEL,
         End,
         MUIA_Family_Child,       MenuitemObject,
          MUIA_Menuitem_Title,    TranslateString(
                    LOCALE_TEXT_MAINWINDOW_MENU_PROJECT_ABOUT_STR,
                    LOCALE_TEXT_MAINWINDOW_MENU_PROJECT_ABOUT),
          MUIA_UserData,          MENUID_ABOUT,
         End,
         MUIA_Family_Child,       MenuitemObject,
          MUIA_Menuitem_Title,    TranslateString(
                    LOCALE_TEXT_MAINWINDOW_MENU_PROJECT_ABOUT_MUI_STR,
                    LOCALE_TEXT_MAINWINDOW_MENU_PROJECT_ABOUT_MUI),
          MUIA_UserData,          MENUID_ABOUTMUI,
         End,
         MUIA_Family_Child,       MenuitemObject,
          MUIA_Menuitem_Title,    NM_BARLABEL,
         End,
         MUIA_Family_Child,       MenuitemObject,
          MUIA_Menuitem_Title,    TranslateString(
                    LOCALE_TEXT_MAINWINDOW_MENU_PROJECT_QUIT_STR,
                    LOCALE_TEXT_MAINWINDOW_MENU_PROJECT_QUIT),
          MUIA_Menuitem_Shortcut, TranslateString(
                    LOCALE_TEXT_MAINWINDOW_MENU_PROJECT_QUIT_SHORTCUT_STR,
                    LOCALE_TEXT_MAINWINDOW_MENU_PROJECT_QUIT_SHORTCUT),
          MUIA_UserData,          MENUID_QUIT,
         End,
        End,
        MUIA_Family_Child, MenuObject,
         MUIA_Menu_Title,  TranslateString(
                    LOCALE_TEXT_MAINWINDOW_MENU_EDIT_TITLE_STR,
                    LOCALE_TEXT_MAINWINDOW_MENU_EDIT_TITLE),
         MUIA_Family_Child,       MenuitemObject,
          MUIA_Menuitem_Title,    TranslateString(
                    LOCALE_TEXT_MAINWINDOW_MENU_EDIT_LASTSAVED_STR,
                    LOCALE_TEXT_MAINWINDOW_MENU_EDIT_LASTSAVED),
          MUIA_Menuitem_Shortcut, TranslateString(
                    LOCALE_TEXT_MAINWINDOW_MENU_EDIT_LASTSAVED_SHORTCUT_STR,
                    LOCALE_TEXT_MAINWINDOW_MENU_EDIT_LASTSAVED_SHORTCUT),
          MUIA_UserData,          MENUID_LASTSAVED,
         End,
         MUIA_Family_Child,       MenuitemObject,
          MUIA_Menuitem_Title,    TranslateString(
                    LOCALE_TEXT_MAINWINDOW_MENU_EDIT_RESTORE_STR,
                    LOCALE_TEXT_MAINWINDOW_MENU_EDIT_RESTORE),
          MUIA_Menuitem_Shortcut, TranslateString(
                    LOCALE_TEXT_MAINWINDOW_MENU_EDIT_RESTORE_SHORTCUT_STR,
                    LOCALE_TEXT_MAINWINDOW_MENU_EDIT_RESTORE_SHORTCUT),
          MUIA_UserData,          MENUID_RESTORE,
         End,
        End,
        MUIA_Family_Child,  MenuObject,
         MUIA_Menu_Title,   TranslateString(
                    LOCALE_TEXT_MAINWINDOW_MENU_SETTINGS_TITLE_STR,
                    LOCALE_TEXT_MAINWINDOW_MENU_SETTINGS_TITLE),
         MUIA_Family_Child, Icons = MenuitemObject,
          MUIA_Menuitem_Title,    TranslateString(
                    LOCALE_TEXT_MAINWINDOW_MENU_SETTINGS_ICONS_STR,
                    LOCALE_TEXT_MAINWINDOW_MENU_SETTINGS_ICONS),
          MUIA_Menuitem_Shortcut, TranslateString(
                    LOCALE_TEXT_MAINWINDOW_MENU_SETTINGS_ICONS_SHORTCUT_STR,
                    LOCALE_TEXT_MAINWINDOW_MENU_SETTINGS_ICONS_SHORTCUT),
          MUIA_Menuitem_Checkit,  TRUE,
          MUIA_Menuitem_Checked,  CreateIcons,
         End,
         MUIA_Family_Child,       MenuitemObject,
          MUIA_Menuitem_Title,    NM_BARLABEL,
         End,
         MUIA_Family_Child,       MenuitemObject,
          MUIA_Menuitem_Title,    TranslateString(
                    LOCALE_TEXT_MAINWINDOW_MENU_SETTINGS_GLOBAL_STR,
                    LOCALE_TEXT_MAINWINDOW_MENU_SETTINGS_GLOBAL),
          MUIA_Menuitem_Shortcut, TranslateString(
                    LOCALE_TEXT_MAINWINDOW_MENU_SETTINGS_GLOBAL_SHORTCUT_STR,
                    LOCALE_TEXT_MAINWINDOW_MENU_SETTINGS_GLOBAL_SHORTCUT),
          MUIA_UserData,          MENUID_GLOBAL,
         End,
         MUIA_Family_Child,       MenuitemObject,
          MUIA_Menuitem_Title,    TranslateString(
                    LOCALE_TEXT_MAINWINDOW_MENU_SETTINGS_MUI_STR,
                    LOCALE_TEXT_MAINWINDOW_MENU_SETTINGS_MUI),
          MUIA_Menuitem_Shortcut, TranslateString(
                    LOCALE_TEXT_MAINWINDOW_MENU_SETTINGS_MUI_SHORTCUT_STR,
                    LOCALE_TEXT_MAINWINDOW_MENU_SETTINGS_MUI_SHORTCUT),
          MUIA_UserData,          MENUID_MUI,
         End,
        End,
       End,
       WindowContents, VGroup,
        Child, Register = RegisterGroup(TextObjects),
         MUIA_CycleChain, TRUE,
         MUIA_ShortHelp,  TranslateString(LOCALE_HELP_MAINWINDOW_TYPES_STR,
                                          LOCALE_HELP_MAINWINDOW_TYPES),
         Child, Lists[TMOBJTYPE_EXEC] =
                 NewObject(ListPanelClass->mcc_Class, NULL,
                           TMA_Class,      ObjectClasses[TMOBJTYPE_EXEC],
                           MUIA_ShortHelp, TranslateString(
                                        LOCALE_HELP_MAINWINDOW_TYPE_EXEC_STR,
                                        LOCALE_HELP_MAINWINDOW_TYPE_EXEC),
                           TAG_DONE),
         Child, Lists[TMOBJTYPE_IMAGE] =
                 NewObject(ListPanelClass->mcc_Class, NULL,
                           TMA_Class, ObjectClasses[TMOBJTYPE_IMAGE],
                           MUIA_ShortHelp, TranslateString(
                                        LOCALE_HELP_MAINWINDOW_TYPE_IMAGE_STR,
                                        LOCALE_HELP_MAINWINDOW_TYPE_IMAGE),
                           TAG_DONE),
         Child, Lists[TMOBJTYPE_SOUND] =
                 NewObject(ListPanelClass->mcc_Class, NULL,
                           TMA_Class, ObjectClasses[TMOBJTYPE_SOUND],
                           MUIA_ShortHelp, TranslateString(
                                        LOCALE_HELP_MAINWINDOW_TYPE_SOUND_STR,
                                        LOCALE_HELP_MAINWINDOW_TYPE_SOUND),
                           TAG_DONE),
         Child, Lists[TMOBJTYPE_MENU] =
                 NewObject(ListPanelClass->mcc_Class, NULL,
                           TMA_Class, ObjectClasses[TMOBJTYPE_MENU],
                           MUIA_ShortHelp, TranslateString(
                                        LOCALE_HELP_MAINWINDOW_TYPE_MENU_STR,
                                        LOCALE_HELP_MAINWINDOW_TYPE_MENU),
                           TAG_DONE),
         Child, Lists[TMOBJTYPE_ICON] =
                 NewObject(ListPanelClass->mcc_Class, NULL,
                           TMA_Class, ObjectClasses[TMOBJTYPE_ICON],
                           MUIA_ShortHelp, TranslateString(
                                        LOCALE_HELP_MAINWINDOW_TYPE_ICON_STR,
                                        LOCALE_HELP_MAINWINDOW_TYPE_ICON),
                           TAG_DONE),
         Child, Lists[TMOBJTYPE_DOCK] =
                 NewObject(ListPanelClass->mcc_Class, NULL,
                           TMA_Class, ObjectClasses[TMOBJTYPE_DOCK],
                           MUIA_ShortHelp, TranslateString(
                                        LOCALE_HELP_MAINWINDOW_TYPE_DOCK_STR,
                                        LOCALE_HELP_MAINWINDOW_TYPE_DOCK),
                           TAG_DONE),
         Child, Lists[TMOBJTYPE_ACCESS] =
                 NewObject(ListPanelClass->mcc_Class, NULL,
                           TMA_Class, ObjectClasses[TMOBJTYPE_ACCESS],
                           MUIA_ShortHelp, TranslateString(
                                        LOCALE_HELP_MAINWINDOW_TYPE_ACCESS_STR,
                                        LOCALE_HELP_MAINWINDOW_TYPE_ACCESS),
                           MUIA_Disabled, TRUE,
                           TAG_DONE),
        End,
        Child, HGroup,
         MUIA_Group_SameWidth, TRUE,
         Child, SaveButton =   MakeButton(TranslateString(
                                             LOCALE_TEXT_MAINWINDOW_SAVE_STR,
                                             LOCALE_TEXT_MAINWINDOW_SAVE),
                                          TranslateString(
                                             LOCALE_HELP_MAINWINDOW_SAVE_STR,
                                             LOCALE_HELP_MAINWINDOW_SAVE)),
         Child, HSpace(0),
         Child, UseButton =    MakeButton(TextGlobalUse,
                                          TranslateString(
                                             LOCALE_HELP_MAINWINDOW_USE_STR,
                                             LOCALE_HELP_MAINWINDOW_USE)),
         Child, HSpace(0),
         Child, TestButton =   MakeButton(TranslateString(
                                             LOCALE_TEXT_MAINWINDOW_TEST_STR,
                                             LOCALE_TEXT_MAINWINDOW_TEST),
                                          TranslateString(
                                             LOCALE_HELP_MAINWINDOW_TEST_STR,
                                             LOCALE_HELP_MAINWINDOW_TEST)),
         Child, HSpace(0),
         Child, CancelButton = MakeButton(TextGlobalCancel,
                                          TranslateString(
                                             LOCALE_HELP_MAINWINDOW_CANCEL_STR,
                                             LOCALE_HELP_MAINWINDOW_CANCEL)),
        End,
       End,
       MUIA_HelpNode, "MainWindow",
       TAG_MORE,      ops->ops_AttrList)) {
   struct MainWindowClassData *mwcd = TYPED_INST_DATA(cl, rc);

   /* Initialize instance data */
   mwcd->mwcd_Icons    = Icons;
   mwcd->mwcd_Register = Register;

   /* Copy lists */
   {
    int i;

    for (i = TMOBJTYPE_EXEC; i < TMOBJTYPES; i++)
     mwcd->mwcd_Lists[i] = Lists[i];
   }

   /* Set default file name */
   mwcd->mwcd_DefaultFile = file;

   /* Close window action */
   DoMethod(rc, MUIM_Notify, MUIA_Window_CloseRequest, TRUE,
            rc, 2, TMM_Finish, TMV_Finish_Cancel);

   /* Menu action */
   DoMethod(rc, MUIM_Notify, MUIA_Window_MenuAction, MUIV_EveryTime,
            rc, 2, TMM_Menu, MUIV_TriggerValue);

   /* AppWindow action */
   DoMethod(rc, MUIM_Notify, MUIA_AppMessage, MUIV_EveryTime,
            rc, 3, MUIM_CallHook, &AppMessageHook, MUIV_TriggerValue);

   /* Button actions */
   DoMethod(SaveButton,   MUIM_Notify, MUIA_Pressed, FALSE,
            rc, 2, TMM_Finish, TMV_Finish_Save);
   DoMethod(UseButton,    MUIM_Notify, MUIA_Pressed, FALSE,
            rc, 2, TMM_Finish, TMV_Finish_Use);
   DoMethod(TestButton,   MUIM_Notify, MUIA_Pressed, FALSE,
            rc, 2, TMM_Finish, TMV_Finish_Test);
   DoMethod(CancelButton, MUIM_Notify, MUIA_Pressed, FALSE,
            rc, 2, TMM_Finish, TMV_Finish_Cancel);

  } else

   /* Couldn't create object, free file name again */
   FreeVector(file);
 }

 MAINWINDOW_LOG(LOG1(Result, "0x%08lx", rc))

 /* Return pointer to created object */
 return((ULONG) rc);
}

/* MainWindow class method: OM_DISPOSE */
#undef  DEBUGFUNCTION
#define DEBUGFUNCTION MainWindowClassDispose
static ULONG MainWindowClassDispose(Class *cl, Object *obj, Msg msg)
{
 struct MainWindowClassData *mwcd = TYPED_INST_DATA(cl, obj);

 MAINWINDOW_LOG(LOG1(Disposing, "0x%08lx", obj))

 /* Free default file name */
 FreeVector(mwcd->mwcd_DefaultFile);

 /* Call SuperClass */
 return(DoSuperMethodA(cl, obj, msg));
}

/* MainWindow class method: TMM_Finish */
#undef  DEBUGFUNCTION
#define DEBUGFUNCTION MainWindowClassFinish
static ULONG MainWindowClassFinish(Class *cl, Object *obj,
                                   struct TMP_Finish *tmpf)
{
 struct MainWindowClassData *mwcd = TYPED_INST_DATA(cl, obj);
 BOOL                        quit = FALSE;

 /* What type of close event? */
 switch (tmpf->tmpf_Type) {
  case TMV_Finish_Cancel:
   /* Always quit, but check requesters first */
   if (CheckRequesters(obj)) quit = TRUE;
   break;

  case TMV_Finish_Use:
   /* Write configuration to ENV: and quit if successful */
   quit = CheckRequesters(obj) &&
          WriteConfig(obj, mwcd->mwcd_Lists, ConfigUseName, FALSE);
   break;

  case TMV_Finish_Test:
   /* Write configuration to ENV: and DON'T quit! */
   WriteConfig(obj, mwcd->mwcd_Lists, ConfigUseName, FALSE);
   break;

  case TMV_Finish_Save:
   /* Write configuration to ENVARC: and ENV: and quit if both successful */
   quit = CheckRequesters(obj) &&
          WriteConfig(obj, mwcd->mwcd_Lists, ConfigSaveName, FALSE) &&
          WriteConfig(obj, mwcd->mwcd_Lists, ConfigUseName,  FALSE);
   break;
 }

 /* Quit? Send quit message to application */
 if (quit) DoMethod(_app(obj), MUIM_Application_ReturnID,
                    MUIV_Application_ReturnID_Quit);

 /* Return 1 to indicate that the method is implemented */
 return(1);
}

/* MainWindow class method: TMM_Load */
#undef  DEBUGFUNCTION
#define DEBUGFUNCTION MainWindowClassLoad
static ULONG MainWindowClassLoad(Class *cl, Object *obj, struct TMP_Load *tmpl)
{
 MAINWINDOW_LOG(LOG2(File, "%s (0x%08lx)", tmpl->tmpl_File, tmpl->tmpl_File))

 /* Load configuration file */
 ReadConfig(obj, TYPED_INST_DATA(cl,obj)->mwcd_Lists, TRUE, tmpl->tmpl_File);

 /* Return 1 to indicate that the method is implemented */
 return(1);
}

/* MainWindow class method: TMM_Menu */
#undef  DEBUGFUNCTION
#define DEBUGFUNCTION MainWindowClassMenu
static ULONG MainWindowClassMenu(Class *cl, Object *obj, struct TMP_Menu *tmpm)
{
 struct MainWindowClassData *mwcd = TYPED_INST_DATA(cl, obj);

 MAINWINDOW_LOG(LOG1(UserData, "%ld", tmpm->tmpm_UserData))

 /* Which menu? */
 switch (tmpm->tmpm_UserData) {
  case MENUID_OPEN: {
    const char *newname;

    /* Read configuration file using a file requester */
    if (CheckRequesters(obj) &&
        (newname = ReadConfigWithRequester(obj, mwcd->mwcd_Lists, TRUE,
                                           mwcd->mwcd_DefaultFile))) {

     MAINWINDOW_LOG(LOG2(New Name, "%s (0x%08lx)", newname, newname))

     /* User has selected a new default file, free old name */
     FreeVector(mwcd->mwcd_DefaultFile);

     /* Store pointer to new name */
     mwcd->mwcd_DefaultFile = newname;
    }
   }
   break;

  case MENUID_APPEND: {
    const char *newname;

    /* Read configuration file using a file requester */
    if (newname = ReadConfigWithRequester(obj, mwcd->mwcd_Lists, FALSE,
                                          mwcd->mwcd_DefaultFile)) {

     MAINWINDOW_LOG(LOG2(New Name, "%s (0x%08lx)", newname, newname))

     /* User has selected a new default file, free old name */
     FreeVector(mwcd->mwcd_DefaultFile);

     /* Store pointer to new name */
     mwcd->mwcd_DefaultFile = newname;
    }
   }
   break;

  case MENUID_SAVEAS: {
    const char *newname;

    /* Write configuration file using a file requester */
    if (newname = WriteConfigWithRequester(obj, mwcd->mwcd_Lists,
                                           mwcd->mwcd_DefaultFile,
                                           GetCheckitState(mwcd->mwcd_Icons,
                                                           TRUE))) {

     MAINWINDOW_LOG(LOG2(New Name, "%s (0x%08lx)", newname, newname))

     /* User has selected a new default file, free old name */
     FreeVector(mwcd->mwcd_DefaultFile);

     /* Store pointer to new name */
     mwcd->mwcd_DefaultFile = newname;
    }
   }
   break;

  case MENUID_CLIPBOARD: {
    Object *win;

    /* Create new clipboard window */
    if (win = NewObject(ClipWindowClass->mcc_Class, NULL, NULL)) {
     ULONG opened;

     MAINWINDOW_LOG(LOG1(Clipboard window, "0x%08lx", win))

     /* Add window to application */
     DoMethod(_app(obj), OM_ADDMEMBER, win);

     /* Open main window */
     SetAttrs(win, MUIA_Window_Open, TRUE, TAG_DONE);

     /* Get window open status */
     GetAttr(MUIA_Window_Open, win, &opened);

     /* Window open? */
     if (opened == FALSE) {

      MAINWINDOW_LOG(LOG0(Could not open clipboard window))

      /* No, remove window from application */
      DoMethod(_app(obj), OM_REMMEMBER, win);

      /* Dispose window */
      MUI_DisposeObject(win);
     }
    }
   }
   break;

  case MENUID_ABOUT:
   MUI_RequestA(_app(obj), obj, 0,
                TextGlobalTitle, TextGlobalCancel,
                MUIX_B MUIX_C "ToolManager " TMVERSION " (" __COMMODORE_DATE__
                             ")\n\n"
                MUIX_N MUIX_C "© " TMCOPYRIGHTYEAR " Stefan Becker",
                NULL);
   break;

  case MENUID_ABOUTMUI:
   /* Send about message to application */
   DoMethod(_app(obj), MUIM_Application_AboutMUI, obj);
   break;

  case MENUID_QUIT:
   /* Cancel main window */
   DoMethod(obj, TMM_Finish, TMV_Finish_Cancel);
   break;

  case MENUID_LASTSAVED:
   if (CheckRequesters(obj)) ReadConfig(obj, mwcd->mwcd_Lists, TRUE,
                                       ConfigSaveName);
   break;

  case MENUID_RESTORE:
   if (CheckRequesters(obj)) ReadConfig(obj, mwcd->mwcd_Lists, TRUE,
                                       ConfigUseName);
   break;

  case MENUID_GLOBAL:
   OpenGlobalWindow(_app(obj));
   break;

  case MENUID_MUI:
   /* Send settings message to application */
   DoMethod(_app(obj), MUIM_Application_OpenConfigWindow, 0);
   break;
 }

 /* Return 1 to indicate that the method is implemented */
 return(1);
}

/* MainWindow class method: TMM_AppEvent */
#undef  DEBUGFUNCTION
#define DEBUGFUNCTION MainWindowClassAppEvent
static ULONG MainWindowClassAppEvent(Class *cl, Object *obj,
                                     struct TMP_AppEvent *tmpae)
{
 struct MainWindowClassData *mwcd = TYPED_INST_DATA(cl, obj);
 struct AppMessage          *am   = tmpae->tmpae_Message;

 MAINWINDOW_LOG(LOG2(Arguments, "Msg 0x%08lx Object 0x%08lx", am,
                     tmpae->tmpae_Object))

 /* Is MainWindow the calling object? */
 if (tmpae->tmpae_Object == obj) {
  struct WBArg *wa;
  ULONG         i;
  ULONG         type;

  MAINWINDOW_LOG(LOG0(Icon dropped on ourself))

  /* Yes, get currently visible object list */
  GetAttr(MUIA_Group_ActivePage, mwcd->mwcd_Register, &type);

  MAINWINDOW_LOG(LOG1(List type, "%ld", type))

  /* For each argument in the AppMessage */
  for (i = am->am_NumArgs, wa = am->am_ArgList; i > 0; i--, wa++) {

   MAINWINDOW_LOG(LOG1(Next WBArg, "0x%08lx", wa))

   /* Send WBArg method to visible object list */
   DoMethod(mwcd->mwcd_Lists[type], TMM_WBArg, wa, mwcd->mwcd_Lists);
  }

 } else {

  MAINWINDOW_LOG(LOG1(Icon dropped on Object, "0x%08lx", tmpae->tmpae_Object))

  /* No, forward method to object */
  DoMethod(tmpae->tmpae_Object, TMM_WBArg, am->am_ArgList, mwcd->mwcd_Lists);
 }

 /* Return 1 to indicate that the method is implemented */
 return(1);
}

/* MainWindow class method dispatcher */
#undef  DEBUGFUNCTION
#define DEBUGFUNCTION MainWindowClassDispatcher
__geta4 static ULONG MainWindowClassDispatcher(__a0 Class *cl,
                                               __a2 Object *obj, __a1 Msg msg)
{
 ULONG rc;

#if DEBUG_VERY_NOISY
 /* This just generates too much debug output... */
 MAINWINDOW_LOG(LOG3(Arguments, "Class 0x%08lx Object 0x%08lx Msg 0x%08lx",
                     cl, obj, msg))
#endif

 switch(msg->MethodID) {
  /* BOOPSI methods */
  case OM_NEW:
   rc = MainWindowClassNew(cl, obj, (struct opSet *) msg);
   break;

  case OM_DISPOSE:
   rc = MainWindowClassDispose(cl, obj, msg);
   break;

  /* TM methods */
  case TMM_Finish:
   rc = MainWindowClassFinish(cl, obj, (struct TMP_Finish *) msg);
   break;

  case TMM_Load:
   rc = MainWindowClassLoad(cl, obj, (struct TMP_Load *) msg);
   break;

  case TMM_Menu:
   rc = MainWindowClassMenu(cl, obj, (struct TMP_Menu *) msg);
   break;

  case TMM_AppEvent:
   rc = MainWindowClassAppEvent(cl, obj, (struct TMP_AppEvent *) msg);
   break;

  /* Unknown method -> delegate to SuperClass */
  default:
   rc = DoSuperMethodA(cl, obj, msg);
   break;
 }

 return(rc);
}

/* Create MainWindow class */
#undef  DEBUGFUNCTION
#define DEBUGFUNCTION CreateMainWindowClass
struct MUI_CustomClass *CreateMainWindowClass(void)
{
 struct MUI_CustomClass *rc;

 /* Create class */
 if (rc = MUI_CreateCustomClass(NULL, MUIC_Window, NULL,
                                sizeof(struct MainWindowClassData),
                                MainWindowClassDispatcher)) {

  /* Localize strings */
  TextObjects[TMOBJTYPE_EXEC]   = TranslateString(
                                       LOCALE_TEXT_MAINWINDOW_TYPE_EXEC_STR,
                                       LOCALE_TEXT_MAINWINDOW_TYPE_EXEC);
  TextObjects[TMOBJTYPE_IMAGE]  = TranslateString(
                                       LOCALE_TEXT_MAINWINDOW_TYPE_IMAGE_STR,
                                       LOCALE_TEXT_MAINWINDOW_TYPE_IMAGE);
  TextObjects[TMOBJTYPE_SOUND]  = TranslateString(
                                       LOCALE_TEXT_MAINWINDOW_TYPE_SOUND_STR,
                                       LOCALE_TEXT_MAINWINDOW_TYPE_SOUND);
  TextObjects[TMOBJTYPE_MENU]   = TranslateString(
                                       LOCALE_TEXT_MAINWINDOW_TYPE_MENU_STR,
                                       LOCALE_TEXT_MAINWINDOW_TYPE_MENU);
  TextObjects[TMOBJTYPE_ICON]   = TranslateString(
                                       LOCALE_TEXT_MAINWINDOW_TYPE_ICON_STR,
                                       LOCALE_TEXT_MAINWINDOW_TYPE_ICON);
  TextObjects[TMOBJTYPE_DOCK]   = TextGlobalDock;
  TextObjects[TMOBJTYPE_ACCESS] = TranslateString(
                                       LOCALE_TEXT_MAINWINDOW_TYPE_ACCESS_STR,
                                       LOCALE_TEXT_MAINWINDOW_TYPE_ACCESS);
  TextObjects[TMOBJTYPES]       = NULL;
 }

 MAINWINDOW_LOG(LOG1(Result, "0x%08lx", rc))

 return(rc);
}
