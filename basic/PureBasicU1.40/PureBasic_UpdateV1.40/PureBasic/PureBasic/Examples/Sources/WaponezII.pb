;
; **************
;               *
; Waponez II     **********************************************
;                                                              *
;   Origninal Waponez is from NC Gamez ! Check it on Aminet...  *
;                                                                *
; *****************************************************************
;
;
; Author note (AlphaSND):
; -----------------------
;
; This game was developped in a hurry (all the game was done in 6 days,
; working at spare time) so it's just a little example of what the
; PureBasic can do. This game requiers an AGA Amiga for the nice title
; screen, else the rest of the gfx are in standard 32 colours (work
; on all Amiga). 
;
; -----------------------------------------------------------------------
;
; History:
;
; 11/03/2000
;   + Added sound support !
;   + Draw a nice title picture...
;   + Use an AmigaSprite to hide the mouse pointer.
;   + Commented the code a lot
;
; 21/02/2000
;   + Added Pause & ESC key support :).
;
; 20/02/2000
;   + Added Mapped background... A special tool has been created
;     to create nice background with ease.
;   + Start/Stop the sprite server in the loop ensure a good multitask !
;     Very plaisant to see...
;   + Added some other aliens (the final boss ;*)
;   + Added a nice FadeOut routine at the end (easy, it's PB which do it).
;   + Added collisions between player & sprite.
;
; 19/02/2000
;   + Added real sprite support (still using linked list :*)...)
;   + Added animated sprite support
;   + Added lot of bullets... It works very well !! :)
;   + Added explosion & collision routines.. Need a good CPU now :*D.
;   + Perfectly smooth on a 1230/50.
;
; 18/02/2000
;   + Added the real gfx, it looks very nice :)
;   + Implemented the bullets via a linked list, the easier way...
;
; 15/02/2000
;   + Started the routine.
;   + Very nice looking 50 fps scroll in OS mode.
;   + Added the main sprite which moving around with joypad...
;   + Added the aliens :*). 
;   + Reworked the routine because a big bug (still same speed)
;

; This game can be started from the Workbench.
;
WbStartup()

; Initialise all the libraries we're using in this game
;
InitAmigaSprites(10)
InitSprite(100,100,100)
InitBitMap(2)
InitScreen(2)
InitJoypad()
InitPalette(10)
InitPicture(1)
InitSound(10)
*TagList = InitTagList(100)

;
; Create and allocate all the necessary bitmaps:
; 2 for the double buffering routine;
; 1 for the title screen
;
AllocateBitMap(0, 320, 480+64+20, 5)  ; 2 x ScreenHeight + 64 + 20 
AllocateBitMap(1, 320, 480+64+20, 5)  ;
AllocateBitMap(2, 320, 50, 8)         ; Title BitMap

;
; Our own structures for each objects (bullets, aliens,...)
; It's very handy to use such structures because all the 
; informations relative to each objects (bullet, aliens,...)
; like the position, the speed... is stored in the
; same name. It's object oriented programming :*) (A bit... OOPs)
;
Structure Bullet
  x.w
  y.w
  Width.w
  Height.w
  Image.w
  SpeedX.w
  SpeedY.w
EndStructure

NewList Bullet.Bullet()


Structure Alien
  x.w
  y.w
  Width.w
  Height.w
  Speed.w
  StartImage.w
  EndImage.w
  ImageDelay.w
  NextImageDelay.w
  ActualImage.w
  Armor.w
EndStructure

NewList Aliens.Alien()


Structure Explosion
  x.w
  y.w
  State.w
  Delay.w
EndStructure

NewList Explosion.Explosion()


;
; Now we create the buffers to store the erased background
; information when we will display the sprites..
;
UseBitMap(1)
CreateSpriteBuffer(1, 10000, BitMapID())
UseBitMap(0)
CreateSpriteBuffer(0, 10000, BitMapID())

; Our global 'Path$'. All files are relative to this path for easier localisation...
;
Path$ = "PureBasic:Examples/WaponezII/"

LoadSprite(0, Path$+"Back_1")
LoadSprite(1, Path$+"Player_1")
LoadSprite(2, Path$+"Player_2")
LoadSprite(3, Path$+"Player_3")
LoadSprite(4, Path$+"Bullet_1")
LoadSprite(5, Path$+"Back_2")

LoadSprite(6, Path$+"Bullet_Right")
LoadSprite(7, Path$+"Bullet_Left")
LoadSprite(8, Path$+"Bullet_Diag1")
LoadSprite(9, Path$+"Bullet_Diag2")

LoadSprite(55, Path$+"Bullet_Bottom")

;
; Sprite 10 to 5 reserved for the rotating animated alien..
;

For k=0 To 5
  LoadSprite(k+10, Path$+"Ennemy_3_"+Str(k+1))
Next

;
; Sprite 20 to 30 reserved for the explosions...
;

For k=0 To 7
  LoadSprite(k+20, Path$+"Explosion_"+Str(k+1))
Next

;
; Load all the background blocks...
;

For k=0 to 9
  LoadSprite(k+30, Path$+"Back_"+Str(k+1))
Next

LoadSprite(50, Path$+"Boss")

;
; Load our blank AmigaSprite to hide pointer on the 2 screens
;

LoadAmigaSprite(0, Path$+"Blank")

;
; Now, load our sounds..
;

SoundPath$ = Path$+"Sounds/"

LoadSound(0, SoundPath$+"Lazer")
SetSoundChannels(0, 1)            ; Will be played only the 1st channel
SetSoundVolume(0, 32)

LoadSound(1, SoundPath$+"Background")
SetSoundChannels(1, 2)            ; ...only on the 2nd channel

LoadSound(2, SoundPath$+"Explosion")
SetSoundChannels(2, 4)            ; ...only the 3nd channel
SetSoundVolume(2, 48)
SetSoundPeriod(2, 400)

;
; Init all variables with will be used later
;

PlayerWidth  = SpriteWidth(1)
PlayerHeight = SpriteHeight(1)

;
; Load the needed palette and the title picture (and its palette)
;
LoadPalette(0, Path$+"Back_1")

LoadPicture(0, Path$+"Title_256.iff")  ; Whow a 256 colour picture ?
GetPicturePalette(4, PictureID())      ;

UseBitMap(2)                      ; Render the picture on the BitMap
PictureToBitMap(0, BitMapID())    ;

; Very important: change the program priority to 20, as we need lot
; of cpu time..
; 
ProgramPriority(20) 

ResetTagList(#SA_Type, #CUSTOMSCREEN | #CUSTOMBITMAP)
      AddTag(#SA_Quiet, 1)
      AddTag(#SA_BitMap, BitMapID())
If OpenScreen(1, 320, 25, 8, *TagList) = 0
  End
EndIf

DisplayPalette(4,ScreenID())

UseBitMap(0)
ResetTagList(#SA_Type, #CUSTOMSCREEN | #CUSTOMBITMAP)
      AddTag(#SA_Quiet,1)
      AddTag(#SA_BitMap, BitMapID())
      AddTag(#SA_Top, 28)
      AddTag(#SA_Parent, ScreenID())
      AddTag(#SA_Draggable, 0)
If OpenScreen(0,320,240,5, *TagList)

  DisplayPalette(0, ScreenID())

  AmigaSpriteScreen(ScreenID())  ; AmigaSprite will be displayed on this screen

  AllocateSoundChannels(15) ; All Channels are reserved for Waponez II

  PlayerSpeed = 2      ; The speed of our player !

  db = 1
   b = 0

  ScrollY.w = 240+32+16

  AdditionnalBlock = 8
  BackgroundLine   = 0

  *Level1 = ?Level1

  PlaySound(1,-1)

  Repeat
    VWait()

    DisplayAmigaSprite(0, 0, 321, 241)    ; remove the mouse pointer ! (Sprite 0 on Channel 0 at position 321, 241)
   
    ShowBitMap(db, ScreenID(), 0, ScrollY) ; Here is the double buffering tips
                                           ; 'db' is alternately 0 and 1 so the bitmaps 0 and 1
                                           ; are displayed one after other. When a bitmap is
                                           ; displayed we do the work on the other bitmap.

    StartSpriteServer()    ; Start the sprite server !

    Gosub CheckPause
 
    If BackgroundLine < 15*4
      ScrollY-1

      If ScrollY<16
        ScrollY = 240+31+16
      EndIf
    Else
      If Boss = 0
        AlienDelay = 100
      EndIf

      Boss = 1
    EndIf

    db = 1-db
    
    UseSpriteBuffer(db)
    
    ResetSpriteServer()
    RestoreBackGround()
    
    If BackgroundLine < 15*4
    
    BlockY = ScrollY & $FFF0 - 16   ; Little tip to have 16 boundary aligned Y coords..
    
    BlockID1 = PeekB(*Level1)+30     ; Read which blocks should be displayed on the background..
    BlockID2 = PeekB(*Level1+1)+30   ;
    
    AddBlockSprite(BlockID1, BlockX   , BlockY)
    AddBlockSprite(BlockID2, BlockX+16, BlockY)
    AddBlockSprite(BlockID1, BlockX   , BlockY+240+32)
    AddBlockSprite(BlockID2, BlockX+16, BlockY+240+32)
    
    If AdditionnalBlock
      BlockID3 = PeekB(*Level1+2)+30
    
      AddBlockSprite(BlockID3, BlockX+32, BlockY)
      AddBlockSprite(BlockID3, BlockX+32, BlockY+240+32)
    
      AdditionnalBlock-1
      If db = 1
        BlockX+16
        *Level1+1
      EndIf
    EndIf

    If db = 1
      BlockX+32
      *Level1+2
    EndIf

    If BlockX >= 320
      BlockX = 0
      AdditionnalBlock = 8
      BackgroundLine+1
    Endif

    EndIf

    UseSpriteBuffer(db)  ; Restore original buffer...

    Gosub CheckCollisions

    Gosub MovePlayers
    
    Gosub DisplayBullets
    
    Gosub NewAlienWave
    
    Gosub DisplayAliens
    
    Gosub DisplayExplosions

    If BulletDelay > 0
      BulletDelay-1
    EndIf
     
    WaitSpriteServer()
    StopSpriteServer()
  Until Quit = 1 OR PressedRawKey() = 69

  Gosub EndGame

EndIf

End

                                           
MovePlayers:

  Select JoypadMovement(1)
    Case 1
      PlayerY - PlayerSpeed
      PlayerImage = 1

    Case 2
      PlayerY - PlayerSpeed
      PlayerX + PlayerSpeed
      PlayerImage = 2

    Case 3
      PlayerX + PlayerSpeed
      PlayerImage = 2

    Case 4
      PlayerX + PlayerSpeed
      PlayerY + PlayerSpeed
      PlayerImage = 2

    Case 5
      PlayerY + PlayerSpeed
      PlayerImage = 1
   
    Case 6
      PlayerY + PlayerSpeed
      PlayerX - PlayerSpeed
      PlayerImage = 3

    Case 7
      PlayerX - PlayerSpeed
      PlayerImage = 3
    
    Case 8
      PlayerX - PlayerSpeed
      PlayerY - PlayerSpeed
      PlayerImage = 3

    Default
      PlayerImage = 1

  EndSelect

  If PlayerX < 0 : PlayerX = 0 : EndIf
  If PlayerY < 0 : PlayerY = 0 : EndIf

  If PlayerX > 320-PlayerWidth  : PlayerX = 320-PlayerWidth : EndIf
  If PlayerY > 240-PlayerHeight : PlayerY = 240-PlayerHeight : EndIf

 
  If Dead = 1 
    AddElement(Explosion())
    Explosion()\x = PlayerX
    Explosion()\y = PlayerY

    Dead = 0
  Else
    If DeadDelay>0 
      DeadDelay-1
      If db=1 And DeadDelay < 100
        AddBufferedSprite(PlayerImage, PlayerX, PlayerY+ScrollY)
      EndIf
    Else
      AddBufferedSprite(PlayerImage, PlayerX, PlayerY+ScrollY)
    EndIf
  EndIf

  PressedButtons.l = JoypadButtons(1)
  
  
  If PressedButtons & #PB_JOYPAD_BUTTON1
    If BulletDelay = 0 And DeadDelay < 100
    AddElement(Bullet())
    Bullet()\x     = PlayerX+5
    Bullet()\y     = PlayerY-10
    Bullet()\Width = SpriteWidth(4)
    Bullet()\Height= SpriteHeight(4)
    Bullet()\Image = 4
    Bullet()\SpeedY = -7
    BulletDelay = 10

    AddElement(Bullet())
    Bullet()\x = PlayerX+26
    Bullet()\y = PlayerY+6
    Bullet()\Width = SpriteWidth(6)
    Bullet()\Height= SpriteHeight(6)
    Bullet()\Image = 6
    Bullet()\SpeedX = 7  

    AddElement(Bullet())
    Bullet()\x = PlayerX-11
    Bullet()\y = PlayerY+6
    Bullet()\Width = SpriteWidth(7)
    Bullet()\Height= SpriteHeight(7)
    Bullet()\Image = 7
    Bullet()\SpeedX = -7

    AddElement(Bullet())
    Bullet()\x = PlayerX+26
    Bullet()\y = PlayerY-6
    Bullet()\Width = SpriteWidth(8)
    Bullet()\Height= SpriteHeight(8)
    Bullet()\Image = 8
    Bullet()\SpeedX = 7
    Bullet()\SpeedY = -7

    AddElement(Bullet())
    Bullet()\x = PlayerX-11
    Bullet()\y = PlayerY-6
    Bullet()\Width = SpriteWidth(9)
    Bullet()\Height= SpriteHeight(9)
    Bullet()\Image = 9
    Bullet()\SpeedX = -7
    Bullet()\SpeedY = -7

    AddElement(Bullet())
    Bullet()\x = PlayerX+12
    Bullet()\y = PlayerY+32
    Bullet()\Width = SpriteWidth(55)
    Bullet()\Height= SpriteHeight(55)
    Bullet()\Image = 55
    Bullet()\SpeedY = 7

    PlaySound(0,1)

    EndIf
  EndIf

  P2.l = JoypadButtons(0)

  If P2 & #PB_JOYPAD_BUTTON2
    Quit = 1
  EndIf

Return


NewAlienWave:

  If AlienDelay = 0

    AddElement(Aliens())

    If Boss = 1
      Aliens()\x = 100
      Aliens()\y = -16
      Aliens()\Width  = SpriteWidth(50)
      Aliens()\Height = SpriteHeight(50)
      Aliens()\Speed  = 2
      Aliens()\StartImage = 50
      Aliens()\EndImage = 50
      Aliens()\ImageDelay = 1
      Aliens()\NextImageDelay = 1
      Aliens()\ActualImage = 50
      Aliens()\Armor = 20
   
      AlienDelay = 80

    Else

    Aliens()\x = 100
    Aliens()\y = -16
    Aliens()\Width  = SpriteWidth(10) 
    Aliens()\Height = SpriteHeight(10)
    Aliens()\Speed = 2
    Aliens()\StartImage  = 10 
    Aliens()\EndImage    = 15 
    Aliens()\ImageDelay  =  4
    Aliens()\NextImageDelay = Aliens()\ImageDelay
    Aliens()\ActualImage = 10
    Aliens()\Armor = 4

    AlienDelay = 22

    Endif
  Else
    AlienDelay - 1
  EndIf

Return


DisplayAliens:

  ResetList(Aliens())
  While NextElement(Aliens())

    AddBufferedSprite(Aliens()\ActualImage, Aliens()\x, Aliens()\y+ScrollY)

    Aliens()\y + Aliens()\Speed

    If Aliens()\NextImageDelay = 0
 
      Aliens()\ActualImage+1

      If Aliens()\ActualImage > Aliens()\EndImage
        Aliens()\ActualImage = Aliens()\StartImage
      EndIf

      Aliens()\NextImageDelay = Aliens()\ImageDelay
    Else
      Aliens()\NextImageDelay-1
    EndIf

    If Aliens()\Armor <= 0 Or Aliens()\y > 240+16
      If Aliens()\Armor <= 0

        AddElement(Explosion())
        Explosion()\x = Aliens()\x
        Explosion()\y = Aliens()\y

        Score+20
      EndIf
 
      KillElement(Aliens())
    EndIf
  Wend
Return


DisplayBullets:

  ResetList(Bullet())
  While NextElement(Bullet())

    If Bullet()\y < 0
      KillElement(Bullet())
    Else
      If Bullet()\x < 0
        KillElement(Bullet())
      Else

        If Bullet()\x > 320-Bullet()\Width
          KillElement(Bullet())
        Else
          If Bullet()\y > 245
            KillElement(Bullet())
          Else
            AddBufferedSprite(Bullet()\Image, Bullet()\x, Bullet()\y+ScrollY)

            Bullet()\y + Bullet()\SpeedY
            Bullet()\x + Bullet()\SpeedX
          Endif
        EndIf
      EndIf
    EndIf

  Wend

Return

;
; This routine is very CPU intensive when many bullets are flying
; all around the screen...
;
CheckCollisions:

  ResetList(Aliens())
  While NextElement(Aliens())
    ResetList(Bullet())
    While NextElement(Bullet())

      If Bullet()\y <= Aliens()\y+Aliens()\Height
        If Bullet()\y+Bullet()\Height >= Aliens()\y
          If Bullet()\x+Bullet()\Width => Aliens()\x
            If Bullet()\x <= Aliens()\x+Aliens()\Width
              Aliens()\Armor-1
              KillElement(Bullet())
            EndIf
          EndIf
        EndIf
      EndIf
    Wend

    If DeadDelay = 0
    If PlayerX+PlayerWidth > Aliens()\x
      If PlayerX < Aliens()\x+Aliens()\Width
        If PlayerY+PlayerHeight > Aliens()\y
          If PlayerY < Aliens()\y+Aliens()\Height
            Dead = 1
            DeadDelay = 180 

            AddElement(Explosion())
            Explosion()\x = Aliens()\x
            Explosion()\y = Aliens()\y

            KillElement(Aliens())
          EndIf
        EndIf
      EndIf
    EndIf
    EndIf
  Wend

Return


DisplayExplosions:

  ResetList(Explosion())
  While NextElement(Explosion())

    AddBufferedSprite(Explosion()\State+20, Explosion()\x, Explosion()\y+ScrollY)

    If Explosion()\Delay = 0
      If Explosion()\State = 0
        PlaySound(2,1) 
      EndIf

      If Explosion()\State < 7
        Explosion()\State+1
        Explosion()\Delay = 2
      Else
        KillElement(Explosion())
      Endif
    Else
      Explosion()\Delay-1
    EndIf
  Wend

Return


CheckPause:

  If PressedRawKey() = 25

    WaitSpriteServer()
    StopSpriteServer()

    StopSound(0)

    Repeat
      VWait()
    Until PressedRawKey() <> 25

    Repeat
      VWait()
    Until PressedRawKey() = 25

    Repeat
      VWait()
    Until PressedRawKey() <> 25

    PlaySound(1,-1)

    StartSpriteServer()

  EndIf
Return


EndGame:

  FadeOut(0, ScreenID(), 4, 64)

  HideScreen()

Return


Level1:
IncludeBinary "PureBasic:Examples/WaponezII/DefaultMap"
