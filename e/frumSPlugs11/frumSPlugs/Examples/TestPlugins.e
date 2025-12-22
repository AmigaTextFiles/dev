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

/* Program to test all frumSPlugs plugins */
-> $VER: TestPlugins.e V1.1 Stephen Sinclair (96.07.18)

OPT OSVERSION=37,LARGE
MODULE 'Tools/EasyGUI','Plugins/BackDrop','Plugins/BitMap','Plugins/Gauge',
       'Plugins/BusyBox','Plugins/Image','Plugins/ImageButton',
       'Plugins/TextPanel','Plugins/AslPopups','Plugins/ClrWhlGrdSld'
MODULE 'Intuition/Intuition','Graphics/Gfx','Intuition/Screens'

DEF bdp:PTR TO backdropplugin,
    bp:PTR TO bitmapplugin,
    gp:PTR TO gaugeplugin,
    bbp:PTR TO busyboxplugin,
    ip:PTR TO imageplugin,
    ibp:PTR TO imagebuttonplugin,
    tpp:PTR TO textpanelplugin,
    aslfile:PTR TO aslfileplugin,
    aslfont:PTR TO aslfontplugin,
    aslmode:PTR TO aslscrmdplugin,
    cwgs:PTR TO cwgsplugin
DEF bmp1:PTR TO bitmap,bmp2:PTR TO bitmap,scr:PTR TO screen,is8colour=TRUE
DEF filename[100]:STRING,fontname[30]:STRING,modename[30]:STRING,
    filegad,fontgad,modegad
DEF gh:PTR TO guihandle

PROC main() HANDLE
/* Allocate bitmaps to use for backdrop, bitmap, image, and imagebutton */
  IF (bmp1:=AllocBitMap(32,32,3,BMF_CLEAR,NIL))=NIL THEN Raise("MEM")
  IF (bmp2:=AllocBitMap(25,28,1,0,NIL))=NIL THEN Raise("MEM")

/* This is much better on a MagicWB screen, but if the user runs it on */
/* a regular 4 colour screen, we may as well try our best to make it   */
/* look good.                                                          */
  scr:=LockPubScreen(NIL)
  IF scr
    IF scr.bitmap.depth<=2 THEN is8colour:=FALSE
  ENDIF
  IF is8colour=FALSE
    new_easygui('Warning!',
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

  CopyMem({alien},bmp2.planes[0],112)

/* And now for the EasyGUI magic! */
  new_easygui('frumSPlugs',
    [ROWS,
      [PLUGIN,0,NEW bdp.backdropplugin(bmp1,0,0,32,32)],
      [TEXT,'BackDrop: (All over)',NIL,FALSE,5],
      [BEVEL,[COLS,
        [ROWS,
          [ROWS,
            [TEXT,'TextPanel:',NIL,FALSE,5],
            [PLUGIN,0,NEW tpp.textpanelplugin(['\eacWelcome To \esbfrumSPlugs V1.1\esb!',NIL,
                                               '\eBAR',NIL,
                                               '\eacThis is one of the newest features,',NIL,
                                               '\eac\ep\c\essThe TextPanel!\esn',[SHINEPEN],
                                               '\eBAR',NIL,
                                               '\eacYou can now make panels of text with formatting!',NIL,
                                               '\eac\esbBold\esb \esuUnderlined\esu \esiItalics\esi \ese\ep\cEmbossed \ess\ep\cShadowed\esn',[BACKGROUNDPEN,FILLPEN]],
                                               NIL,TRUE,BEVELR,IF is8colour THEN 0 ELSE -1,5)]
          ],
          [BAR],
          [COLS,
            [ROWS,
              [TEXT,'BitMap:',NIL,FALSE,5],
              [BEVELR,[PLUGIN,0,NEW bp.bitmapplugin(bmp2,0,0,25,28,$30)]]
            ],
            [BAR],
            [ROWS,
              [TEXT,'Gauge:',NIL,FALSE,5],
              [PLUGIN,0,NEW gp.gaugeplugin(100,0,RESIZEX,BEVELR,0,0,0,'\d%%',TRUE)]
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
          ],
          [BAR],
          [ROWS,
            [COLS,
              filegad:=[STR,{dummy},'File:',filename,100,5],
              [PLUGIN,{fileproc},NEW aslfile.aslfileplugin(filename)]
            ],
            [COLS,
              fontgad:=[STR,{dummy},'Font:',fontname,50,5],
              [PLUGIN,{fontproc},NEW aslfont.aslfontplugin(fontname)]
            ],
            [COLS,
              modegad:=[TEXT,modename,'Display:',TRUE,5],
              [PLUGIN,{modeproc},NEW aslmode.aslscrmdplugin(modename)]
            ]
          ]
        ],
/* if we have OS 3.0 or more, we can have a colorwheel, else put a space */
        IF KickVersion(39) THEN
          [COLS,
            [BAR],
            [EQROWS,
              [TEXT,'ColorWheel and',NIL,FALSE,STRLEN],
              [TEXT,'GradienSlider',NIL,FALSE,STRLEN],
              [PLUGIN,0,NEW cwgs.cwgsplugin(2,TRUE,NIL,10,10,256,0)]
            ]
          ]
          ELSE
          [SPACEV]

      ]],
      [BUTTON,0,'Okay']
    ])
EXCEPT DO
  cwgs.revert()
/* ALWAYS END imagebuttons, busyboxes,, textpanels, asl popups, and colorwheels. */
  END ibp,bbp,tpp,aslfile,aslfont,aslmode,cwgs
  IF bmp1 THEN FreeBitMap(bmp1)
  IF bmp2 THEN FreeBitMap(bmp2)
  SELECT exception
    CASE "UTIL"; WriteF('Could not open utility.library.\n')
    CASE "ASL";  WriteF('Could not open asl.library.\n')
    CASE "MEM" ; WriteF('Not enough mem.\n')
    CASE "bigg"; WriteF('Screen not large enough. :(\n')
    DEFAULT; IF exception>0 THEN WriteF('Exception: \s\n',[exception,0])
  ENDSELECT
ENDPROC

CHAR '$VER: TestPlugins V1.0 Stephen Sinclair (95.07.18)',0

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
  IF gp.cv()>50 THEN inc:=-1 ELSE inc:=1
  bbp.on(TRUE)
  FOR x:=1 TO 100
    gp.addgauge(inc)
    Delay(1)  -> needs a delay - otherwise it's too fast to see
  ENDFOR
  bbp.on(FALSE)
ENDPROC

/* Procedure for strings */
PROC dummy(x,s) IS x,s

/* Procedures for asl popups */
PROC fileproc(x) IS setstr(gh,filegad,filename),x
PROC fontproc(x) IS setstr(gh,fontgad,fontname),x
PROC modeproc(x) IS settext(gh,modegad,modename),x

/* new easygui that uses a global guihandle */
PROC new_easygui(title,gui,info=0,screen=0,font=0,menu=0) HANDLE
  DEF res=-1
  gh:=guiinit(title,gui,info,screen,font,menu)
  WHILE res<0
    Wait(gh.sig)
    res:=guimessage(gh)
  ENDWHILE
EXCEPT DO
  cleangui(gh)
  ReThrow()
ENDPROC

/* That's it!  It's that simple to use frumSPlugs! */
