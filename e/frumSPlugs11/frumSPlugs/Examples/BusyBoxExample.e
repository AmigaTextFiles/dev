/*
**   ((( frumSPlugs )))
** ©1996 Stephen Sinclair
**
** This source may be copied or edited in any
** way you wish.
**
** This file is part of the frumSPlugs package,
** and may only be distributed with it.
*/

/* Example for BusyBoxPlugin */
-> $VER: BusyBoxExample.e V1.1 Stephen Sinclair (96.07.15)

MODULE 'Tools/EasyGUI','Plugins/BusyBox'

DEF bb:PTR TO busyboxplugin

PROC main() HANDLE
  easygui('BusyBoxPlugin Example',
    [EQROWS,
      [TEXT,'BusyBox:',NIL,TRUE,STRLEN],

/* create a busybox which expands both ways and has a priority of -15. */
      [PLUGIN,0,NEW bb.busyboxplugin([1,2,3]:INT)],
      [EQCOLS,
        [SBUTTON,{turnon},'On'],
        [SBUTTON,{turnoff},'Off']
      ],
      [BUTTON,0,'Quit']
    ]
  )
EXCEPT DO

/* Always END the object! */
  END bb
  IF exception<>0 THEN WriteF('\s\n',[exception,0])
ENDPROC

CHAR '$VER: BusyBoxExample V1.1 Stephen Sinclair (96.07.15)',0

PROC turnon(x) IS bb.on(TRUE)
PROC turnoff(x) IS bb.on(FALSE)
