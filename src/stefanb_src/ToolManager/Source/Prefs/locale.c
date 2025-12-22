/*
 * locale.c  V3.1
 *
 * Preferences editor localization support
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

/* Global strings */
const char *TextGlobalTitle        = LOCALE_TEXT_GLOBAL_TITLE_STR;
const char *TextGlobalCommand      = LOCALE_TEXT_GLOBAL_COMMAND_STR;
const char *TextGlobalSelectCmd    = LOCALE_TEXT_GLOBAL_SELECT_COMMAND_STR;
const char *TextGlobalDirectory    = LOCALE_TEXT_GLOBAL_DIRECTORY_STR;
const char *TextGlobalSelectDir    = LOCALE_TEXT_GLOBAL_SELECT_DIRECTORY_STR;
const char *TextGlobalHotKey       = LOCALE_TEXT_GLOBAL_HOTKEY_STR;
const char *TextGlobalPublicScreen = LOCALE_TEXT_GLOBAL_PUBLIC_SCREEN_STR;
const char *TextGlobalPosition     = LOCALE_TEXT_GLOBAL_POSITION_STR;
const char *TextGlobalExecObject   = LOCALE_TEXT_GLOBAL_EXEC_OBJECT_STR;
const char *TextGlobalImageObject  = LOCALE_TEXT_GLOBAL_IMAGE_OBJECT_STR;
const char *TextGlobalSoundObject  = LOCALE_TEXT_GLOBAL_SOUND_OBJECT_STR;
const char *TextGlobalDock         = LOCALE_TEXT_GLOBAL_DOCK_STR;
const char *TextGlobalSelectFile   = LOCALE_TEXT_GLOBAL_SELECT_FILE_STR;
const char *TextGlobalDelete       = LOCALE_TEXT_GLOBAL_DELETE_STR;
const char *HelpGlobalDelete       = LOCALE_HELP_GLOBAL_DELETE_STR;
const char *TextGlobalUse          = LOCALE_TEXT_GLOBAL_USE_STR;
const char *HelpGlobalUse          = LOCALE_HELP_GLOBAL_USE_STR;
const char *TextGlobalCancel       = LOCALE_TEXT_GLOBAL_CANCEL_STR;
const char *HelpGlobalCancel       = LOCALE_HELP_GLOBAL_CANCEL_STR;
const char  TextGlobalAccept[]     = "0123456789";
const char  TextGlobalEmpty[]      = "";

/* Local data */
static struct Library *LocaleBase = NULL;
static struct Catalog *Catalog    = NULL;
static const struct TagItem CatalogParams[] = {
 OC_BuiltInLanguage, (ULONG) "english",
 OC_Version,         TMCATALOGVERSION,
 TAG_DONE
};

/* Initialize localization */
#undef  DEBUGFUNCTION
#define DEBUGFUNCTION InitLocale
void InitLocale(void)
{
 LOCALE_LOG(LOG0(Entry))

 /* Open locale.library */
 if (LocaleBase = OpenLibrary("locale.library", 38)) {

  LOCALE_LOG(LOG1(LocaleBase, "0x%08lx", LocaleBase))

  /* Open catalog */
  if (Catalog = OpenCatalogA(NULL, "toolmanagerprefs.catalog",
                             CatalogParams)) {

   LOCALE_LOG(LOG1(Catalog, "0x%08lx", Catalog))

   /* Translate global strings */
   TextGlobalTitle        = TranslateString(TextGlobalTitle,
                                          LOCALE_TEXT_GLOBAL_TITLE);
   TextGlobalCommand      = TranslateString(TextGlobalCommand,
                                          LOCALE_TEXT_GLOBAL_COMMAND);
   TextGlobalSelectCmd    = TranslateString(TextGlobalSelectCmd,
                                          LOCALE_TEXT_GLOBAL_SELECT_COMMAND);
   TextGlobalDirectory    = TranslateString(TextGlobalDirectory,
                                          LOCALE_TEXT_GLOBAL_DIRECTORY);
   TextGlobalSelectDir    = TranslateString(TextGlobalSelectDir,
                                          LOCALE_TEXT_GLOBAL_SELECT_DIRECTORY);
   TextGlobalHotKey       = TranslateString(TextGlobalHotKey,
                                          LOCALE_TEXT_GLOBAL_HOTKEY);
   TextGlobalPublicScreen = TranslateString(TextGlobalPublicScreen,
                                          LOCALE_TEXT_GLOBAL_PUBLIC_SCREEN);
   TextGlobalPosition     = TranslateString(TextGlobalPosition,
                                          LOCALE_TEXT_GLOBAL_POSITION);
   TextGlobalExecObject   = TranslateString(TextGlobalExecObject,
                                          LOCALE_TEXT_GLOBAL_EXEC_OBJECT);
   TextGlobalImageObject  = TranslateString(TextGlobalImageObject,
                                          LOCALE_TEXT_GLOBAL_IMAGE_OBJECT);
   TextGlobalSoundObject  = TranslateString(TextGlobalSoundObject,
                                          LOCALE_TEXT_GLOBAL_SOUND_OBJECT);
   TextGlobalDock         = TranslateString(TextGlobalDock,
                                          LOCALE_TEXT_GLOBAL_DOCK);
   TextGlobalSelectFile   = TranslateString(TextGlobalSelectFile,
                                          LOCALE_TEXT_GLOBAL_SELECT_FILE);
   TextGlobalDelete       = TranslateString(TextGlobalDelete,
                                          LOCALE_TEXT_GLOBAL_DELETE);
   HelpGlobalDelete       = TranslateString(HelpGlobalDelete,
                                          LOCALE_HELP_GLOBAL_DELETE);
   TextGlobalUse          = TranslateString(TextGlobalUse,
                                          LOCALE_TEXT_GLOBAL_USE);
   HelpGlobalUse          = TranslateString(HelpGlobalUse,
                                          LOCALE_HELP_GLOBAL_USE);
   TextGlobalCancel       = TranslateString(TextGlobalCancel,
                                          LOCALE_TEXT_GLOBAL_CANCEL);
   HelpGlobalCancel       = TranslateString(HelpGlobalCancel,
                                          LOCALE_HELP_GLOBAL_CANCEL);
  }
 }
}

/* Free locale stuff */
#undef  DEBUGFUNCTION
#define DEBUGFUNCTION DeleteLocale
void DeleteLocale(void)
{
 LOCALE_LOG(LOG0(Entry))

 /* Library opened? */
 if (LocaleBase) {

  /* Catalog opened? */
  if (Catalog) CloseCatalog(Catalog);

  /* Close library */
  CloseLibrary(LocaleBase);
 }
}


/* Translate one string */
#undef  DEBUGFUNCTION
#define DEBUGFUNCTION TranslateString
const char *TranslateString(const char *text, ULONG id)
{
 LOCALE_LOG(LOG3(Arguments, "Default '%s' (0x%08lx) ID %ld", text, text, id))

 /* Return string from catalog or default text */
 return(LocaleBase ? GetCatalogStr(Catalog, id, text) : text);
}
