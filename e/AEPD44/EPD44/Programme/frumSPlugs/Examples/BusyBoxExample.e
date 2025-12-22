/* Example for BusyBoxPlugin */
-> $VER: BusyBoxExample.e V1.0 Stephen Sinclair (96.06.16)

MODULE 'Tools/EasyGUI','Plugins/BusyBox'

DEF bb:PTR TO busyboxplugin

PROC main() HANDLE
  easygui('BusyBoxPlugin Example',
    [EQROWS,
      [TEXT,'BusyBox:',NIL,TRUE,STRLEN],

/* create a busybox which expands both ways and has a priority of -15. */
      [PLUGIN,0,NEW bb.busyboxplugin([1,2,3]:INT)],
      [EQCOLS,
        [BUTTON,{turnon},'On'],
        [BUTTON,{turnoff},'Off']
      ],
      [BUTTON,0,'Quit']
    ]
  )
EXCEPT DO

/* Always END the object! */
  END bb
  IF exception<>0 THEN WriteF('\s\n',[exception,0])
ENDPROC

CHAR '$VER: BusyBoxExample V1.0 Stephen Sinclair (96.06.16)',0

PROC turnon(x) IS bb.on(TRUE)
PROC turnoff(x) IS bb.on(FALSE)
