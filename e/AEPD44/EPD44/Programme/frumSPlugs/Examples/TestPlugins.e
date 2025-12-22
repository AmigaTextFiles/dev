/* Program to test all frumSPlugs plugins */
-> $VER: TestPlugins.e V1.0 Stephen Sinclair (96.06.16)

OPT OSVERSION=37
MODULE 'Tools/EasyGUI','Plugins/BackDrop','Plugins/BitMap','Plugins/Gauge',
       'Plugins/BusyBox','Plugins/Image','Plugins/ImageButton'
MODULE 'Intuition/Intuition','Utility','Graphics/Gfx','Intuition/Screens'

DEF bdp:PTR TO backdropplugin,
    bp:PTR TO bitmapplugin,
    gp:PTR TO gaugeplugin,
    bbp:PTR TO busyboxplugin,
    ip:PTR TO imageplugin,
    ibp:PTR TO imagebuttonplugin
DEF bmp1:PTR TO bitmap,bmp2:PTR TO bitmap,scr:PTR TO screen

PROC main() HANDLE
/* Must open utility.library for imagebutton. */
  IF (utilitybase:=OpenLibrary('utility.library',0))=NIL THEN Raise("UTIL")

/* Allocate bitmaps to use for backdrop, bitmap, image, and imagebutton */
  IF (bmp1:=AllocBitMap(32,32,3,BMF_CLEAR,NIL))=NIL THEN Raise("MEM")
  IF (bmp2:=AllocBitMap(25,28,1,0,NIL))=NIL THEN Raise("MEM")

/* This is much better on a MagicWB screen, but if the user runs it on */
/* a regular 4 colour screen, we may as well try our best to make it   */
/* look good.                                                          */
  scr:=LockPubScreen(NIL)
  IF scr
    IF scr.bitmap.depth<=2
      easygui('Warning!',
        [ROWS,
          [BAR],
          [TEXT,'You really should run this',NIL,FALSE,STRLEN],
          [TEXT,'on an 8 colour screen with',NIL,FALSE,STRLEN],
          [TEXT,'the MagicWB colours.  It',NIL,FALSE,STRLEN],
          [TEXT,'looks a lot nicer that way.',NIL,FALSE,STRLEN],
          [BAR],
          [BUTTON,0,'I''ll remember that...']
        ],0,scr)
/* For four colour screens, make the backdrop blue. */
      CopyMem({backdrop},bmp1.planes[0],128)
      CopyMem({backdrop},bmp1.planes[1],128)
    ELSE
/* For a MagicWB screen, make it light gray. */
      CopyMem({backdrop},bmp1.planes[0],128)
      CopyMem({backdrop},bmp1.planes[2],128)
    ENDIF
  ENDIF

  CopyMem({alien},bmp2.planes[0],112)

/* And now for the EasyGUI magic! */
  easygui('frumSPlugs',
    [ROWS,
      [PLUGIN,0,NEW bdp.backdropplugin(bmp1,0,0,32,32)],
      [TEXT,'BackDrop: (All over)',NIL,FALSE,5],
      [BEVEL,[ROWS,
        [COLS,
          [ROWS,
            [TEXT,'BitMap:',NIL,FALSE,5],
            [BEVELR,[PLUGIN,0,NEW bp.bitmapplugin(bmp2,0,0,25,28,$30)]]
          ],
          [BAR],
          [ROWS,
            [TEXT,'Gauge:',NIL,FALSE,5],
            [PLUGIN,0,NEW gp.gaugeplugin(100,0)]
          ]
        ],
        [BAR],
        [COLS,
          [ROWS,
            [TEXT,'BusyBox:',NIL,FALSE,5],
            [PLUGIN,0,NEW bbp.busyboxplugin([1,2,3,4,5,6,7]:INT,BEVELR,RESIZEX)]
          ],
          [BAR],
          [ROWS,
            [TEXT,'Image:',NIL,FALSE,5],
            [BEVELR,[PLUGIN,0,NEW ip.imageplugin([0,0,25,28,1,bmp2.planes[0],1,6,NIL]:image)]]
          ],
          [BAR],
          [ROWS,
            [TEXT,'ImageButton:  (Click Me!)',NIL,FALSE,5],
            [PLUGIN,{dostuff},NEW ibp.imagebuttonplugin([0,0,25,28,1,bmp2.planes[0],1,0,NIL]:image,
                                                        [0,0,25,28,1,bmp2.planes[0],1,2,NIL]:image)]
          ]
        ]
      ]],
      [BUTTON,0,'Okay']
    ])
EXCEPT DO
/* ALWAYS END imagebuttons and busyboxes. */
  END ibp,bbp
  IF utilitybase THEN CloseLibrary(utilitybase)
  IF bmp1 THEN FreeBitMap(bmp1)
  IF bmp2 THEN FreeBitMap(bmp2)
  SELECT exception
    CASE "UTIL"; WriteF('Could not open utility.library.\n')
    CASE "MEM" ; WriteF('Not enough mem.\n')
    DEFAULT; IF exception>0 THEN WriteF('Exception: \s\n',[exception,0])
  ENDSELECT
ENDPROC

CHAR '$VER: TestPlugins V1.0 Stephen Sinclair (95.06.16)',0

/* The bitplane data */
backdrop:
/* 32 x 32 x 1 */
INT $0000,$0000,$7FFF,$FFFE,$4000,$0002,$4000,$0002,$4000,$0002,$4000,$0002,
    $43FF,$FFC2,$4200,$0042,$4200,$0042,$427F,$FE42,$4240,$0242,$4240,$0242,
    $4240,$0242,$4240,$0242,$4243,$FE42,$4242,$0042,$4242,$0042,$4242,$7FC2,
    $4242,$4002,$4242,$4002,$4242,$4002,$4242,$4002,$4242,$7FFE,$4242,$0000,
    $4242,$0000,$C243,$FFFF,$0240,$0000,$0240,$0000,$0240,$0000,$0240,$0000,
    $FE7F,$FFFF,$0000,$0000,$0042

alien:
/* 25 x 28 x 1 */
INT $0000,$0000,$007F,$0000,$03FF,$E000,$0FFF,$F800,$1FFF,$FC00,$1FFF,$FE00,
    $3FFF,$FE00,$7FFF,$FF00,$7FFF,$FF00,$7FFF,$FF00,$47FF,$F100,$41FF,$C100,
    $607F,$0300,$203E,$0200,$301C,$0600,$381C,$0E00,$1E08,$3C00,$1F88,$FC00,
    $0FFF,$F800,$0FFF,$F800,$07FF,$F000,$03FF,$E000,$03FF,$E000,$01FF,$C000,
    $00FF,$8000,$007F,$0000,$003E,$0000,$0000,$0000,$0600

/* Procedure to demonstrate the gauge and the busybox at the same time */
PROC dostuff(x)
  DEF inc
  IF gp.cv>50 THEN inc:=-1 ELSE inc:=1
  bbp.on(TRUE)
  FOR x:=1 TO 100
    gp.addgauge(inc)
    Delay(1)  -> needs a delay - otherwise it's too fast to see
  ENDFOR
  bbp.on(FALSE)
ENDPROC

/* That's it!  It's that simple to use frumSPlugs! */
