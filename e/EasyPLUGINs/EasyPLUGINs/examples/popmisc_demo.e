
/*

*/

OPT PREPROCESS, OSVERSION=37

MODULE 'tools/easygui', 'easyplugins/popmisc',
       'utility', 'utility/tagitem'

DEF poptask:PTR TO popmisc_plugin,
    popport:PTR TO popmisc_plugin,
    poplib:PTR TO popmisc_plugin,
    popdevice:PTR TO popmisc_plugin,
    popresource:PTR TO popmisc_plugin,
    popmemnode:PTR TO popmisc_plugin

PROC main() HANDLE

    IF (utilitybase:=OpenLibrary('utility.library', 37))=NIL THEN Raise("utlb")

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

    IF utilitybase THEN CloseLibrary(utilitybase)

ENDPROC

PROC dummy() IS EMPTY


