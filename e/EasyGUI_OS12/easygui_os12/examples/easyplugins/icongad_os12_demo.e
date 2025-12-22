/*

  $VER: IconGad Demo V1.10 - By Fabio Rotondo (fsoft@intercom.it)

  This source is Public Domain

  Part of EasyPLUGINs distribution.

*/

OPT PREPROCESS

-> RST: Added conditional EASY_OS12 support
#define EASY_OS12

#ifdef EASY_OS12
  MODULE 'tools/easygui_os12', 'easyplugins/icongad_os12'
#endif
#ifndef EASY_OS12
  OPT OSVERSION=37
  MODULE 'tools/easygui', 'easyplugins/icongad'
#endif

MODULE 'tools/exceptions'

PROC main() HANDLE
  DEF ig=NIL:PTR TO icongad_plugin

  NEW ig.init('sys:disk')

  easyguiA('Test',
            [ROWS,
              [SBUTTON, {dis}, 'Disable', ig],
              [SBUTTON, {ena}, 'Enable', ig],
              [SPACEV],
              [COLS,
                [SPACEH],
                [ICONGAD, {ignore}, ig],     -> Note: ICONGAD keyword.
                [SPACEH]
              ]
            ]
          )
EXCEPT DO
  report_exception()
  END ig
ENDPROC

PROC ignore() IS EMPTY

PROC dis(ig:PTR TO icongad_plugin, i) IS ig.disabled()

PROC ena(ig:PTR TO icongad_plugin, i) IS ig.disabled(FALSE)
