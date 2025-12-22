;
; **********************************
;
; Sprite example file for Pure Basic
;
;  © 2000 - Fantaisie Software -
;
; **********************************
;
;

InitSprite(100,100,100)
InitBitMap(1)
InitScreen(0)
InitPalette(0)
*TagList = InitTagList(10)

;
; Create and allocate all the necessary bitmaps:
; 2 for the double buffering routine;
;
AllocateBitMap(0, 320, 240, 5)  
AllocateBitMap(1, 320, 240, 5)  

;
; Now we create the buffers to store the erased background
; information when we will display the sprites..
;
UseBitmap(1)
CreateSpriteBuffer(1, 4000, BitMapID())
UseBitMap(0)
CreateSpriteBuffer(0, 4000, BitMapID())

; Our global 'Path$'. All files are relative to this path for easier localisation...
;
Path$ = "PureBasic:Examples/WaponezII/"

LoadSprite(0, Path$+"Player_1")
;
; Load the needed palette and the title picture (and its palette)
;
LoadPalette(0, Path$+"Player_1")

UseBitMap(0)
ResetTagList(#SA_Type, #CUSTOMSCREEN | #CUSTOMBITMAP)
      AddTag(#SA_Quiet,1)
      AddTag(#SA_BitMap, BitMapID())
If OpenScreen(0,320,240,5, *TagList)

  DisplayPalette(0, ScreenID())

  db = 1

  For x=0 To 150
    VWait()

    ShowBitMap(db, ScreenID(), 0, 0) ; Here is the double buffering tips
                                     ; 'db' is alternately 0 and 1 so the bitmaps 0 and 1
                                     ; are displayed one after other. When a bitmap is
                                     ; displayed we do the work on the other bitmap.

    StartSpriteServer()              ; Start the sprite server !
    
    db = 1-db                        ; Alternate between 0 and 1, db now indicate the back
                                     ; (non-displayed) buffer
    
    UseSpriteBuffer(db)              ; Make this buffer the back buffer
    
    ResetSpriteServer()              ;
    RestoreBackGround()              ; Restore the old background erased with displayed sprites
    
    AddBufferedSprite(0, x, 100)     ; Display a sprite with Background save

    WaitSpriteServer()               ; Wait than all sprites are really displayed (as the server
                                     ; is asynchronous)
    StopSpriteServer()
  Next

EndIf

End
