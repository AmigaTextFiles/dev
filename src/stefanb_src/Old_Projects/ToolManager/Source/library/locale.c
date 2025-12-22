/*
 * locale.c  V2.1
 *
 * locale stuff
 *
 * (c) 1990-1993 Stefan Becker
 */

#include "ToolManagerLib.h"

/* Broker port data */
struct NewBroker BrokerData={NB_VERSION,ToolManagerName, "ToolManager V"
                             TMVERSION " © " TMCRYEAR " Stefan Becker",
                             NULL,NBU_UNIQUE,0,0,NULL,0};

/* Menu data */
struct NewMenu DockMenu[]={
                           {NM_TITLE,NULL,NULL,0,~0,NULL},
                            {NM_ITEM,NULL,NULL,0,~0,(APTR) MENU_CLOSE},
                            {NM_ITEM,NULL,NULL,0,~0,(APTR) MENU_QUIT},
                           {NM_END}
                          };

static STRPTR AppStrings[]={
                            MSG_HANDLER_COMMODITIES_DESCRIPTION_STR,
                            MSG_HANDLER_DOCK_MENU_LABEL_STR,
                            MSG_HANDLER_CLOSE_MENU_LABEL_STR,
                            MSG_HANDLER_CLOSE_MENU_SHORTCUT_STR,
                            MSG_HANDLER_QUIT_MENU_LABEL_STR,
                            MSG_HANDLER_QUIT_MENU_SHORTCUT_STR,
                           };

/* misc. data */
struct Library *LocaleBase=NULL;
static struct Catalog *Catalog=NULL;

/* Get locale strings */
void GetLocale(void)
{
 /* Try to open locale.library */
 if (LocaleBase=OpenLibrary("locale.library",38)) {

  DEBUG_PRINTF("Locale: 0x%08lx\n",LocaleBase);

  /* Try to get catalog for current language */
  if (Catalog=OpenCatalog(NULL,"toolmanager.catalog",
                          OC_BuiltInLanguage, "english",
                          OC_Version,         3,
                          TAG_DONE)) {

   DEBUG_PRINTF("Catalog: 0x%08lx\n",Catalog);

   /* Get translation strings */
   BrokerData.nb_Descr=GetCatalogStr(Catalog,
                                     MSG_HANDLER_COMMODITIES_DESCRIPTION,
                                     AppStrings[0]);
   DockMenu[0].nm_Label=GetCatalogStr(Catalog,MSG_HANDLER_DOCK_MENU_LABEL,
                                      AppStrings[1]);
   DockMenu[1].nm_Label=GetCatalogStr(Catalog,MSG_HANDLER_CLOSE_MENU_LABEL,
                                      AppStrings[2]);
   DockMenu[1].nm_CommKey=GetCatalogStr(Catalog,
                                        MSG_HANDLER_CLOSE_MENU_SHORTCUT,
                                        AppStrings[3]);
   DockMenu[2].nm_Label=GetCatalogStr(Catalog,MSG_HANDLER_QUIT_MENU_LABEL,
                                      AppStrings[4]);
   DockMenu[2].nm_CommKey=GetCatalogStr(Catalog,MSG_HANDLER_QUIT_MENU_SHORTCUT,
                                        AppStrings[5]);
  }
 }

 /* Set defaults */
 if (!Catalog) {
  BrokerData.nb_Descr=AppStrings[0];
  DockMenu[0].nm_Label=AppStrings[1];
  DockMenu[1].nm_Label=AppStrings[2];
  DockMenu[1].nm_CommKey=AppStrings[3];
  DockMenu[2].nm_Label=AppStrings[4];
  DockMenu[2].nm_CommKey=AppStrings[5];
 }
}

void FreeLocale(void)
{
 if (LocaleBase) {
  if (Catalog) {
   CloseCatalog(Catalog);
   Catalog=NULL;
  }
  CloseLibrary(LocaleBase);
  LocaleBase=NULL;
 }
}
