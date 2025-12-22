
/*

*/

OPT PREPROCESS

-> RST: Added conditional EASY_OS12 support
#define EASY_OS12

#ifdef EASY_OS12
  OPT LARGE
  MODULE 'tools/easygui_os12', 'easyplugins/popmisc_os12', 'hybrid/utility'
#endif
#ifndef EASY_OS12
  OPT OSVERSION=37
  MODULE 'tools/easygui', 'easyplugins/popmisc', 'utility'
#endif

MODULE 'utility/tagitem'

DEF poptask:PTR TO popmisc_plugin,
    popport:PTR TO popmisc_plugin,
    poplib:PTR TO popmisc_plugin,
    popdevice:PTR TO popmisc_plugin,
    popresource:PTR TO popmisc_plugin,
    popmemnode:PTR TO popmisc_plugin

PROC main() HANDLE

#ifdef EASY_OS12
    openUtility()
#endif
#ifndef EASY_OS12
    IF (utilitybase:=OpenLibrary('utility.library', 37))=NIL THEN Raise("utlb")
#endif

    NEW poptask.popmisc(),
        popport.popmisc([PLA_PopMisc_ListType, PLV_PopMisc_PortsList,
                         TAG_DONE]),
        poplib.popmisc([PLA_PopMisc_ListType, PLV_PopMisc_LibrariesList,
                         TAG_DONE]),
        popdevice.popmisc([PLA_PopMisc_ListType, PLV_PopMisc_DevicesList,
                           TAG_DONE]),
        popresource.popmisc([PLA_PopMisc_ListType, PLV_PopMisc_ResourcesList,
                           TAG_DONE]),
        popmemnode.popmisc([PLA_PopMisc_ListType, PLV_PopMisc_MemNodesList,
                           TAG_DONE])

    easyguiA('popmisc_plugin example', [COLS,
                                           [ROWS,
                                               [PLUGIN, {dummy}, poptask, TRUE],
                                               [PLUGIN, {dummy}, popport, TRUE],
                                               [PLUGIN, {dummy}, poplib, TRUE]
                                           ],
                                           [ROWS,
                                               [PLUGIN, {dummy}, popdevice, TRUE],
                                               [PLUGIN, {dummy}, popresource, TRUE],
                                               [PLUGIN, {dummy}, popmemnode, TRUE]
                                           ]
                                       ])

EXCEPT DO

    END poptask, popport, poplib, popdevice, popresource, popmemnode

#ifdef EASY_OS12
    closeUtility()
#endif
#ifndef EASY_OS12
    IF utilitybase THEN CloseLibrary(utilitybase)
#endif

ENDPROC

PROC dummy() IS EMPTY


