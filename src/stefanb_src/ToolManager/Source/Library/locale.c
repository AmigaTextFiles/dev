/*
 * locale.c  V3.1
 *
 * ToolManager library localization support
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
void StartLocale(void)
{
 LOCALE_LOG(LOG0(Entry))

 /* Open locale.library */
 if (LocaleBase = OpenLibrary("locale.library", 38)) {

  LOCALE_LOG(LOG1(LocaleBase, "0x%08lx", LocaleBase))

  /* Open catalog */
  Catalog = OpenCatalogA(NULL, TMCATALOGNAME, CatalogParams);

  LOCALE_LOG(LOG1(Catalog, "0x%08lx", Catalog))
 }
}

/* Free locale stuff */
#undef  DEBUGFUNCTION
#define DEBUGFUNCTION StopLocale
void StopLocale(void)
{
 LOCALE_LOG(LOG0(Entry))

 /* Library opened? */
 if (LocaleBase) {

  /* Catalog opened? */
  if (Catalog) {

   /* Close catalog and clear pointer */
   CloseCatalog(Catalog);
   Catalog = NULL;
  }

  /* Close library and clear pointer */
  CloseLibrary(LocaleBase);
  LocaleBase = NULL;
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
