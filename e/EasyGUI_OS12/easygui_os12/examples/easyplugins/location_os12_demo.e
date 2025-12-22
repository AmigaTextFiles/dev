
/*

*/

OPT PREPROCESS

-> RST: Added conditional EASY_OS12 support
#define EASY_OS12

#ifdef EASY_OS12
  MODULE 'tools/easygui_os12', 'easyplugins/location_os12'
#endif
#ifndef EASY_OS12
  OPT OSVERSION=37
  MODULE 'tools/easygui', 'easyplugins/location'
#endif

DEF location:PTR TO location_plugin

PROC main() HANDLE

    NEW location

    easyguiA('location_plugin example', [COLS,
                                            [TEXT, 'Move me then close me!', NIL, FALSE, 1],
                                            [PLUGIN, {location_action}, location]
                                        ])

    WriteF('Window ended at x: \d / y: \d / w: \d / h: \d\n',
           location.lx, location.ly, location.lw, location.lh)

EXCEPT DO

    END location

ENDPROC

PROC location_action(gh:PTR TO guihandle, location:PTR TO location_plugin)

    WriteF('location_plugin action - at x: \d / y: \d / w: \d / h: \d\n',
           location.lx, location.ly, location.lw, location.lh)

ENDPROC


