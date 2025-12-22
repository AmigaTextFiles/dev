;
; *************************************************
;
; 'DualPlayField Screen' example file for PureBasic
;
;          © 2000 - Fantaisie Software -
;
; *************************************************
;
; This example should work on AGA Amiga only as it
; use two 16 colours playfields. For non AGA Amiga,
; you can reduce the bitmaps depth from 4 to 3, to
; have two 8 colours playfields.
; 

InitScreen(0)   
InitBitMap(1)   
InitPalette(1)

*TagList = InitTagList(10)

AllocateBitMap(0,320,200,4)
AllocateBitMap(1,320,400,4)

;
; Draw an horizontal rainbow on the second BitMap (back playfield)
;

DrawingOutput(BitMapRastPort())  

For k=1 To 15
  FrontColour(k)
  BoxFill(50+k*10,150,50,50)
Next

;
; Draw a vertical rainbow on the first BitMap (front PlayField)
;

UseBitMap(0)

DrawingOutput(BitMapRastPort())

For k=4 To 15
  FrontColour(k)
  BoxFill(150,100+k*5,100,30)
Next

;
; Create a 32 colours palette...
;

CreatePalette(0, 32)

;
; Setup the front playfield palette (range: 0 to 15)
; A nice red rainbow
;

For k=0 To 15
  PalRGB(k, k*15, 0, 0)
Next

;
; Setup the back playfield palette (range: 16 to 31)
; A little blue rainbow

For k=0 To 15
  PalRGB(k+16, 0, 0, k*15)
Next

;
; Finally setup the 3 first colours to have a correct looking
; Window...
;
PalRGB(1, 100,100,100)
PalRGB(2, 255,255,255)
PalRGB(3, 0,0,155)

ResetTagList(#SA_DisplayID    , #LORES_KEY)
      AddTag(#SA_Type         , #CUSTOMBITMAP)
      AddTag(#SA_BitMap       , BitMapID())
      AddTag(#SA_LikeWorkbench, 1)
If OpenScreen(0, 320, 200, 4, *TagList)  ; Open a standard 16 colours screen

  ResetTagList(#WA_CustomScreen, ScreenID())
  If OpenWindow(0, 0, 10, 50, 50, #WFLG_DRAGBAR, *TagList)

    DisplayPalette(0, ScreenID())

    UseBitMap(1)
    CreateDualPlayField(BitMapID())  ; Create our second playfield !

    For k=0 To 150
      VWait()
      ShowBackBitMap(1, ScreenID(), 0, k) ; Scroll the BackBitMap !
    Next

    Delay(200)                       ; Wait some time

    RemoveDualPlayField()            ; Remove it before quit...

  EndIf
EndIf

End

