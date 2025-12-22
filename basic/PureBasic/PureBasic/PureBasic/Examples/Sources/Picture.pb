;
; ***********************************
;
; Picture example file for Pure Basic
;
;    © 2001 - Fantaisie Software -
;
; ***********************************
;
;

InitPicture(0)
InitBitMap(0)
InitScreen(0)
InitPalette(2)

FindScreen(0,"Workbench")
ShowScreen()

PrintN("Choose a picture...")

FileName$ = FileRequester(0)

If FileName$ <> ""
  res.l = LoadPicture(0,FileName$)

  If res>0

    PrintN ("Picture information: "+Str(PictureWidth())+"*"+Str(PictureHeight())+"*"+Str(PictureDepth()))

    Delay(100)
    AllocateBitMap (0, PictureWidth(), PictureHeight(), PictureDepth())

    PictureToBitMap(0, BitMapID())

    GetScreenPalette(0, ScreenID())

    CreatePalette (2, 1 << ScreenDepth())            ; Put the display black
    DisplayPalette(2, ScreenID())   ;

    If OpenWindow (0, 0, 0, ScreenWidth(), ScreenHeight(), #WFLG_BORDERLESS, 0)

      DrawingOutput(WindowRastPort())

      GetPicturePalette (1, PictureID())

      x.w = (ScreenWidth()  - PictureWidth() )/2
      y.w = (ScreenHeight() - PictureHeight())/2

      If x<0 : x=0 : EndIf
      If y<0 : y=0 : EndIf

      DisplayPalette(1, ScreenID())

      CopyBitMap(BitMapID(),0,0,x,y,PictureWidth(), PictureHeight())
      
      ;GrabPicture(1, BitMapID(), UsePalette(1))
      ;SavePicture(1, "ram:Test.iff")

      MouseWait()

    EndIf

    FadeOut(1, ScreenID(), 5, 255)
    DisplayPalette (0, ScreenID())

  EndIf
Endif

End
; MainProcessor=0
; Optimizations=0
; CommentedSource=0
; CreateIcon=0
; NoCliOutput=0
; Executable=PureBasic:Examples/Sources/
; Debugger=1
