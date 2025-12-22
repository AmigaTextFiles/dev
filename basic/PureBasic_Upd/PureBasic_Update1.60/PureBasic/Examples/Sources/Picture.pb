;
; ***********************************
;
; Picture example file for Pure Basic
;
;    © 1999 - Fantaisie Software -
;
; ***********************************
;
;

InitPicture(0)
InitRequester()
InitBitMap(0)
InitScreen(0)
InitWindow(0)
InitPalette(2)

FindScreen(0,"Workbench")
ShowScreen()

PrintN("Choose a picture...")

FileName$ = FileRequester(0)

If FileName$ <> ""
  res.l = LoadPicture(0,FileName$)

  If res>0

    PrintN ("Picture information: "+Str(PictureWidth())+"*"+Str(PictureHeight())+"*"+Str(PictureDepth()))

    AllocateBitMap (0, PictureWidth(), PictureHeight(), PictureDepth())

    PictureToBitMap(0, BitMapID())

    GetScreenPalette(0, ScreenID())

    CreatePalette (2,1 LSL ScreenDepth())            ; Put the display black
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

      MouseWait()

    EndIf

    DisplayPalette (0, ScreenID())

  EndIf
Endif

End
