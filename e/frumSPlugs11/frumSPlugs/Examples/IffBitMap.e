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

/* Example of frumSPlugs' BitMap plugin */
-> $VER: IffBitMap.e V1.1 Stephen Sinclair (96.07.15)

OPT PREPROCESS,OSVERSION=37

MODULE 'iff','libraries/iff','graphics/gfx'
MODULE 'workbench/workbench','intuition/intuition'
MODULE 'tools/EasyGUI','Plugins/BitMap'

ENUM SUCCESS,ER_NOBMHD,ER_NOMEM,ER_DECODE

DEF planes:PTR TO LONG
DEF myargs:PTR TO LONG,bmp:bitmap,bmhd:PTR TO bmh

/* The entire main procedure deals with opening the iff, allocating the **
** bitmaps and decoding the bitplanes.  Uses iff.library.               */
PROC main() HANDLE
  DEF iff,i
  DEF rdargs

  myargs:=[0]
  IF rdargs:=ReadArgs('ILBM_FILE/A',myargs,NIL)

    IF iffbase:=OpenLibrary('iff.library',23)
          IF iff:=IfFL_OpenIFF(myargs[0],IFFL_MODE_READ)
            IF bmhd:=IfFL_GetBMHD(iff)
              WriteF('Initializing & Allocating bitmaps...\n')
              InitBitMap(bmp,bmhd.nplanes,bmhd.width,bmhd.height)
              planes:=bmp.planes
              planes[0]:=AllocRaster(bmhd.width,bmhd.height*bmhd.nplanes)
              IF planes[0]=NIL THEN Raise(ER_NOMEM)
              FOR i:=1 TO bmhd.nplanes-1
                planes[i]:=planes[0]+(i*RASSIZE(bmhd.width,bmhd.height))
              ENDFOR
              WriteF('Decoding pic...\n')
              IF IfFL_DecodePic(iff,bmp)
                WriteF('\s:  \dx\dx\d\n',myargs[0],bmhd.width,bmhd.height,bmhd.nplanes)
                creategui()
              ELSE
                Raise(ER_DECODE)
              ENDIF
            ELSE
              Raise(ER_NOBMHD)
            ENDIF
          ELSE
            WriteF('Couldn''t open iff `\s''.\n',myargs[0])
            Raise(0)
          ENDIF
    ELSE
      WriteF('Couldn''t open iff.library v23+\n')
      Raise(0)
    ENDIF
  ELSE
    WriteF('Bad Args!\n')
    CleanUp(0)
  ENDIF
EXCEPT DO
  planes:=bmp.planes
  FOR i:=0 TO bmhd.nplanes-1
    IF planes[i] THEN FreeRaster(planes[i],bmhd.width,bmhd.height)
  ENDFOR
  IF iff THEN IfFL_CloseIFF(iff)
  IF iffbase THEN CloseLibrary(iffbase)
  IF rdargs THEN FreeArgs(rdargs)
  IF exception>0
    WriteF('\s\n',ListItem(['No bitmap header!',
                            'Couldn''t allocate enough mem for bitmaps!',
                            'Couldn''t decode the iff!'],exception-1))
  ENDIF
ENDPROC

CHAR '$VER: IffBitMap V1.1 Stephen Sinclair (96.07.15)',0

/* This is where the bitmap plugin is used */
PROC creategui()
  DEF plug:PTR TO bitmapplugin,s[30]:STRING
  StrCopy(s,'ALIEN')
  easygui('Test for BitMapPlugin',
    [EQROWS,
      [TEXT,'Bitmap:',NIL,TRUE,STRLEN],
      [BEVEL,

/* put the bitmap from the iff brush into the gui */
        [PLUGIN,0,NEW plug.bitmapplugin(bmp,0,0,bmhd.width,bmhd.height)]
      ],
      [BUTTON,0,'Okay']
    ]
  )
ENDPROC
