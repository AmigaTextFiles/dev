/*

  $VER: RawKey PlugIn 1.00 - By Fabio Rotondo (fsoft@intercom.it)

        Part of the EasyPLUGINs package

  V1.00 - Initial Release

*/

OPT MODULE
OPT EXPORT
OPT PREPROCESS

-> RST: Added conditional EASY_OS12 support
#define EASY_OS12

#ifdef EASY_OS12
  MODULE 'tools/easygui_os12'
#endif
#ifndef EASY_OS12
  OPT OSVERSION=37
  MODULE 'tools/easygui'
#endif

MODULE 'intuition/intuition',
       'graphics/text',
       'workbench/workbench'

CONST PLA_KEY_UP = 76, PLA_KEY_DOWN = 77, PLA_KEY_RIGHT = 78, PLA_KEY_LEFT = 79,
      PLA_KEY_CONTROL = 99,
      PLA_KEY_LSHIFT = 96, PLA_KEY_RSHIFT = 97,
      PLA_KEY_LALT = 100, PLA_KEY_RALT = 101,
      PLA_KEY_LAMIGA = 102, PLA_KEY_RAMIGA = 103,
      PLA_KEY_HELP = 95,
      PLA_KEY_USERDATA = 1

ENUM PLA_KEY_F1=80, PLA_KEY_F2, PLA_KEY_F3, PLA_KEY_F4, PLA_KEY_F5, PLA_KEY_F6, PLA_KEY_F7, PLA_KEY_F8, PLA_KEY_F9, PLA_KEY_F10

OBJECT rawkey OF plugin
  PRIVATE
  up
  down
  left
  right
  control
  lshift
  rshift
  lalt
  ralt
  lamiga
  ramiga
  help
  f1
  f2
  f3
  f4
  f5
  f6
  f7
  f8
  f9
  f10

  user
ENDOBJECT

PROC init() OF rawkey
  self.up:=NIL
  self.down:=NIL
  self.left:=NIL
  self.right:=NIL
  self.control:=NIL
  self.lshift:=NIL
  self.rshift:=NIL
  self.lalt:=NIL
  self.ralt:=NIL
  self.lamiga:=NIL
  self.ramiga:=NIL
  self.help:=NIL
  self.f1:=NIL
  self.f2:=NIL
  self.f3:=NIL
  self.f4:=NIL
  self.f5:=NIL
  self.f6:=NIL
  self.f7:=NIL
  self.f8:=NIL
  self.f9:=NIL
  self.f10:=NIL

  self.user:=NIL
ENDPROC

PROC end() OF rawkey IS EMPTY

PROC will_resize() OF rawkey IS 0,0

PROC min_size(ta:PTR TO textattr, fontheight) OF rawkey IS 0,0

PROC render(ta:PTR TO textattr, x, y, xs, ys, win:PTR TO window) OF rawkey IS EMPTY

PROC clear_render(win:PTR TO window) OF rawkey IS EMPTY

PROC message_test(imsg:PTR TO intuimessage, win:PTR TO window) OF rawkey
  DEF c, x

  IF (imsg.class=IDCMP_RAWKEY)
    c:=imsg.code
    SELECT c
      CASE PLA_KEY_UP
        x:=self.up
      CASE PLA_KEY_DOWN
        x:=self.down
      CASE PLA_KEY_RIGHT
        x:=self.right
      CASE PLA_KEY_LEFT
        x:=self.left
      CASE PLA_KEY_CONTROL
        x:=self.control
      CASE PLA_KEY_LSHIFT
        x:=self.lshift
      CASE PLA_KEY_RSHIFT
        x:=self.rshift
      CASE PLA_KEY_LALT
        x:=self.lalt
      CASE PLA_KEY_RALT
        x:=self.ralt
      CASE PLA_KEY_LAMIGA
        x:=self.lamiga
      CASE PLA_KEY_RAMIGA
        x:=self.ramiga
      CASE PLA_KEY_HELP
        x:=self.help
      CASE PLA_KEY_F1
        x:=self.f1
      CASE PLA_KEY_F2
        x:=self.f2
      CASE PLA_KEY_F3
        x:=self.f3
      CASE PLA_KEY_F4
        x:=self.f4
      CASE PLA_KEY_F5
        x:=self.f5
      CASE PLA_KEY_F6
        x:=self.f6
      CASE PLA_KEY_F7
        x:=self.f7
      CASE PLA_KEY_F8
        x:=self.f8
      CASE PLA_KEY_F9
        x:=self.f9
      CASE PLA_KEY_F10
        x:=self.f10
    ENDSELECT

    IF x THEN x(self.user)
  ENDIF
ENDPROC FALSE

PROC message_action(class, qual, code, win:PTR TO window) OF rawkey IS EMPTY

PROC setattrs(tags:PTR TO LONG) OF rawkey
  DEF t,v

  WHILE (t:=Long(tags++))
    v:=Long(tags++)
    SELECT t
      CASE PLA_KEY_UP
        self.up:=v
      CASE PLA_KEY_DOWN
        self.down:=v
      CASE PLA_KEY_RIGHT
        self.right:=v
      CASE PLA_KEY_LEFT
        self.left:=v
      CASE PLA_KEY_CONTROL
        self.control:=v
      CASE PLA_KEY_LSHIFT
        self.lshift:=v
      CASE PLA_KEY_RSHIFT
        self.rshift:=v
      CASE PLA_KEY_LALT
        self.lalt:=v
      CASE PLA_KEY_RALT
        self.ralt:=v
      CASE PLA_KEY_LAMIGA
        self.lamiga:=v
      CASE PLA_KEY_RAMIGA
        self.ramiga:=v
      CASE PLA_KEY_HELP
        self.help:=v
      CASE PLA_KEY_F1
        self.f1:=v
      CASE PLA_KEY_F2
        self.f2:=v
      CASE PLA_KEY_F3
        self.f3:=v
      CASE PLA_KEY_F4
        self.f4:=v
      CASE PLA_KEY_F5
        self.f5:=v
      CASE PLA_KEY_F6
        self.f6:=v
      CASE PLA_KEY_F7
        self.f7:=v
      CASE PLA_KEY_F8
        self.f8:=v
      CASE PLA_KEY_F9
        self.f9:=v
      CASE PLA_KEY_F10
        self.f10:=v
      CASE PLA_KEY_USERDATA
        self.user:=v
    ENDSELECT
  ENDWHILE
ENDPROC

