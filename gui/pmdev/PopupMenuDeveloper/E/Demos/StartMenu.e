/* -- ----------------------------------------------------------------- -- *
 * -- Program.....: StartMenu.e                                         -- *
 * -- Author......: Daniel Kasmeroglu <raptor@cs.tu-berlin.de>          -- *
 * -- Description.: Port of an example by Henrik Isaksson.              -- *
 * -- ----------------------------------------------------------------- -- *
 * -- Original header:                                                  -- *
 * --                                                                   -- *
 * --   $VER: StartMenu.c 2.3 (23.9.97)                                 -- *
 * --                                                                   -- *
 * --   Popup Menu example program                                      -- *
 * --                                                                   -- *
 * --   ©1996-1997 Henrik Isaksson                                      -- *
 * --   All Rights Reserved.                                            -- *
 * --                                                                   -- *
 * --   Run and move the mouse pointer to the bottom of the screen!     -- *
 * --                                                                   -- *
 * -- ----------------------------------------------------------------- -- */

/* -- ----------------------------------------------------------------- -- *
 * --                              Options                              -- *
 * -- ----------------------------------------------------------------- -- */

OPT PREPROCESS       -> enable preprocessor


/* -- ----------------------------------------------------------------- -- *
 * --                              Modules                              -- *
 * -- ----------------------------------------------------------------- -- */

MODULE 'intuition/intuition'  ,
       'intuition/screens'    ,
       'utility/tagitem'      ,
       'libraries/popupmenu'  ,
       'exec/memory'

MODULE 'popupmenu'


/* -- ----------------------------------------------------------------- -- *
 * --                            Procedures                             -- *
 * -- ----------------------------------------------------------------- -- */

->»» PROC copydata
PROC copydata( cop_data, cop_size )
DEF cop_mem

  cop_mem := NewM( cop_size, MEMF_CHIP )
  IF cop_mem <> NIL THEN CopyMem( cop_data, cop_mem, cop_size )

ENDPROC cop_mem
->»»>


/* -- ----------------------------------------------------------------- -- *
 * --                               Main                                -- *
 * -- ----------------------------------------------------------------- -- */

->»» PROC main
PROC main()
DEF ma_miamiunsel : PTR TO image
DEF ma_miamisel   : PTR TO image
DEF ma_yamunsel   : PTR TO image
DEF ma_yamsel     : PTR TO image
DEF ma_nn         : PTR TO image
DEF ma_amiga      : PTR TO image
DEF ma_menu       : PTR TO popupmenu
DEF ma_screen     : PTR TO screen
DEF ma_window     : window  -> a faked window, don't try this at home... ;)
DEF ma_result

  ->»» INITIALISATION
  ->
  -> WARNING:
  ->
  ->   During the creation of the image structures the data at the
  ->   end of the source will be copied to new allocated chip memory.
  ->   As you can see, I'm not testing whether memory was successfully
  ->   allocated or not because the whole size is very small, so I
  ->   suggest that there should be no problem.
  ->
  ma_amiga  := NIL
  ma_result := TRUE

  ma_nn := [ 0, 0,                             -> LeftEdge, TopEdge
             88, 31, 3,                        -> Width, Height, Depth
             copydata( {lab_NNData}, 1116 ),   -> ImageData
             $7,$0,                            -> PlanePick, PlaneOnOff
             NIL ]:image                       -> NextImage

  ma_miamisel := [ 0, 0,                                 -> LeftEdge, TopEdge
                   52, 35, 3,                            -> Width, Height, Depth
                   copydata( {lab_MiamiSelData}, 560 ),  -> ImageData
                   $3, $0,                               -> PlanePick, PlaneOnOff
                   NIL ]:image                           -> NextImage

  ma_miamiunsel := [ 0, 0,                                   -> LeftEdge, TopEdge
                     52, 35, 3,                              -> Width, Height, Depth
                     copydata( {lab_MiamiUnSelData}, 560 ),  -> ImageData
                     $3, $0,                                 -> PlanePick, PlaneOnOff
                     NIL ]:image                             -> NextImage

  ma_yamsel := [ 0, 0,                                -> LeftEdge, TopEdge
                 54, 29, 3,                           -> Width, Height, Depth
                 copydata( {lab_YAMSelData}, 696 ),   -> ImageData
                 $7, $0,                              -> PlanePick, PlaneOnOff
                 NIL ]:image                          -> NextImage

  ma_yamunsel := [ 0, 0,                                 -> LeftEdge, TopEdge
                   54, 29, 3,                            -> Width, Height, Depth
                   copydata( {lab_YAMUnSelData}, 696 ),  -> ImageData
                   $7, $0,                               -> PlanePick, PlaneOnOff
                   NIL ]:image                           -> NextImage

  ma_window.leftedge := 0
  ma_window.topedge  := 0
  ->»»>

  popupmenubase := OpenLibrary( 'popupmenu.library', 9 )
  IF popupmenubase <> NIL

    ma_screen := LockPubScreen( NIL )
    IF ma_screen <> NIL

      ma_window.wscreen := ma_screen
      ma_window.mousey  := 0
      ma_window.rport   := ma_screen.rastport

      -> create a very simple start-menu...
      ma_menu := PMStartMenu,
                   PMItem( 'Miami'   ), PM_USERDATA, 10, PM_ICONSELECTED, ma_miamisel , PM_ICONUNSELECTED , ma_miamiunsel , PMEnd,
                   PMItem( 'IBrowse' ), PM_USERDATA, 20, PM_ICONSELECTED, ma_nn       , PMEnd             ,
                   PMItem( 'YAM'     ), PM_USERDATA, 30, PM_ICONSELECTED, ma_yamsel   , PM_ICONUNSELECTED , ma_yamunsel   , PMEnd,
                   PMBar, PMEnd,
                   PMItem( 'Quit' ), PM_USERDATA, 5, PMEnd,
                 End

      IF ma_menu <> NIL

        PrintF( 'StartMenu is now running.\nMove the mousepointer to the bottom of the screen to open the menu.\nThis demo may cause deadlocks (e.g. if you move an icon to the bottom of the screen), but they should be solved quickly.\nA better startmenu example will follow soon...\n' )

        WHILE ma_result <> FALSE

          Delay( 4 )   -> A CX object would be better...

          -> If we're somewhere near the bottom of the screen...
          IF ma_screen.mousey > (ma_screen.height - 3)

            ma_window.mousex := ma_screen.mousex

            ma_result := Pm_OpenPopupMenuA( ma_window, -> Open our start menu !
            [ PM_MENU ,  ma_menu, TAG_END ] )

            -> Take care of the return codes here. (PM_UserData is returned)
            SELECT ma_result
            CASE 30 ; Execute( 'Run COMM:YAM/YAM', NIL, NIL )
            CASE 20 ; Execute( 'Run COMM:IBrowse/IBrowse', NIL, NIL )
            CASE 10 ; Execute( 'Run COMM:Miami/Miami', NIL, NIL )
            ENDSELECT

            -> When we get a 5 from OpenPopupMenu we make it into a 0,
            -> and the program exits!
            ma_result := ma_result - 5

          ENDIF

        ENDWHILE

        Pm_FreePopupMenu( ma_menu )

      ELSE
        PrintF( 'Menu error !\n' )
      ENDIF

    ELSE
      PrintF( 'No public screen !\n' )
    ENDIF
    CloseLibrary( popupmenubase )
  ELSE
    PrintF( 'Cannot open "popupmenu.library" v9+ !\n' )
  ENDIF

ENDPROC
->»»>


/* -- ----------------------------------------------------------------- -- *
 * --                               Data                                -- *
 * -- ----------------------------------------------------------------- -- */

->»» IMAGE DATA nn
lab_NNData:
INT $0000,$0000,$0000,$0000,$0000,$0100,$0000,$0000, -> Plane 0
    $0000,$0000,$0000,$0300,$0000,$0000,$0000,$0000,
    $0000,$0300,$0000,$0000,$0000,$0000,$0000,$0300,
    $0FFF,$FFF0,$0000,$0000,$0000,$0300,$0FFF,$FFF0,
    $0000,$0000,$0000,$0300,$0FFF,$FFF0,$0000,$0000,
    $0003,$8300,$0FFF,$FFF0,$8BDF,$3CF1,$9EF2,$4300,
    $0F8F,$E1F0,$CA04,$2082,$5280,$8300,$0FE7,$FBF0,
    $ABC4,$3883,$DEF1,$0300,$0FE3,$FBF0,$9A04,$0482,
    $5081,$0300,$0FE9,$FBF0,$8BC4,$3CF2,$50F9,$0300,
    $0FE8,$FBF0,$0000,$0000,$0000,$0300,$0FEC,$7BF0,
    $0040,$0000,$001C,$0300,$0FEE,$3BF0,$18C0,$0000,
    $0018,$0300,$0FEF,$1BF0,$38C0,$0000,$0018,$0300,
    $0FEF,$93F0,$3CC0,$0000,$0018,$0300,$0FEF,$83F0,
    $3CC0,$0060,$0038,$0300,$0FA0,$01F0,$3EC3,$C0E7,
    $BBF8,$0300,$0000,$0000,$36C7,$D9CF,$BFF8,$0300,
    $0000,$0000,$37CF,$9DDF,$1E38,$0300,$0000,$0000,
    $33CF,$7F9E,$FC30,$0300,$0000,$0000,$33CC,$FF19,
    $FC30,$0300,$0000,$0000,$31CF,$EF1F,$F830,$0300,
    $0000,$0000,$30C7,$8E0F,$3800,$0300,$0000,$0000,
    $3000,$0000,$1030,$0300,$0000,$0000,$0000,$0000,
    $0030,$0300,$0000,$0000,$0000,$0000,$0030,$0300,
    $0000,$0000,$0000,$0000,$0000,$0300,$7FFF,$FFFF,
    $FFFF,$FFFF,$FFFF,$FF00,$FFFF,$FFFF,$FFFF,$FFFF,
    $FFFF,$FF00,
    $FFFF,$FFFF,$FFFF,$FFFF,$FFFF,$FE00,$FFFF,$FFFF,  -> Plane 1
    $FFFF,$FFFF,$FFFF,$FC00,$C000,$0000,$0000,$0000,
    $0000,$0000,$C000,$0000,$0000,$0000,$0000,$0000,
    $C000,$0000,$0000,$0000,$0000,$0000,$C000,$0000,
    $0000,$0000,$0000,$0000,$C000,$0000,$0000,$0000,
    $0000,$0000,$C0E0,$3200,$0000,$0000,$0000,$0000,
    $C0FB,$BF00,$0000,$0000,$0000,$0000,$CFFF,$FC10,
    $0000,$0000,$0000,$0000,$CFFF,$FED0,$0000,$0000,
    $0000,$0000,$CFFF,$FFF0,$0000,$0000,$0000,$0000,
    $CFFF,$FFF0,$0000,$0000,$0000,$0000,$CFFF,$FFF0,
    $0040,$0000,$001C,$0000,$CFFF,$FFF0,$18C0,$0000,
    $0018,$0000,$CFFF,$FFF0,$38C0,$0000,$0018,$0000,
    $CFFF,$FFF0,$3CC0,$0000,$0018,$0000,$CFFF,$FFF0,
    $3CC0,$0060,$0038,$0000,$CFB0,$09F0,$3EC3,$C0E7,
    $BBF8,$0000,$C030,$0000,$36C7,$D9CF,$BFF8,$0000,
    $C030,$0000,$37CF,$9DDF,$1E38,$0000,$C000,$0000,
    $33CF,$7F9E,$FC30,$0000,$C000,$0000,$33CC,$FF19,
    $FC30,$0000,$C000,$0000,$31CF,$EF1F,$F830,$0000,
    $C000,$0000,$30C7,$8E0F,$3800,$0000,$C000,$0000,
    $3000,$0000,$1030,$0000,$C000,$0000,$0000,$0000,
    $0030,$0000,$C000,$0000,$0000,$0000,$0030,$0000,
    $C000,$0000,$0000,$0000,$0000,$0000,$8000,$0000,
    $0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000,
    $0000,$0000,
    $0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000, -> Plane 2
    $0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000,
    $0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000,
    $0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000,
    $0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000,
    $0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000,
    $0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000,
    $0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000,
    $0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000,
    $0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000,
    $0040,$0000,$001C,$0000,$0000,$0000,$18C0,$0000,
    $0018,$0000,$0000,$0000,$38C0,$0000,$0018,$0000,
    $0000,$0000,$3CC0,$0000,$0018,$0000,$0000,$0000,
    $3CC0,$0060,$0038,$0000,$004F,$F600,$3EC3,$C0E7,
    $BBF8,$0000,$0FCF,$FFF0,$36C7,$D9CF,$BFF8,$0000,
    $0FCF,$FFF0,$37CF,$9DDF,$1E38,$0000,$0FFF,$FFF0,
    $33CF,$7F9E,$FC30,$0000,$0FFF,$FFF0,$33CC,$FF19,
    $FC30,$0000,$0FFF,$FFF0,$31CF,$EF1F,$F830,$0000,
    $0FFF,$FFF0,$30C7,$8E0F,$3800,$0000,$0FFF,$FFF0,
    $3000,$0000,$1030,$0000,$0FFF,$FFF0,$0000,$0000,
    $0030,$0000,$0000,$0000,$0000,$0000,$0030,$0000,
    $0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000,
    $0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000,
    $0000,$0000
->»»>

->»» IMAGE DATA YAM (Selected)
lab_YAMSelData:
INT $FFFF,$FFFF,$FFFF,$FC00,$FFFF,$FFFF,$FFFF,$F800, -> Plane 0
    $FFD7,$FFFF,$FFFF,$F800,$F9FD,$FFFF,$F9CC,$7800,
    $BABF,$EAAA,$A88C,$6800,$F05B,$FFFF,$F18C,$7800,
    $B00E,$DEAA,$A4CC,$6800,$E805,$F7DD,$C10C,$5800,
    $B500,$BDEA,$B559,$2800,$AAA0,$D731,$0004,$5000,
    $BF50,$8DDA,$9119,$2800,$BFEA,$8AB8,$2464,$4000,
    $BFF4,$DCD8,$D119,$2800,$BFFE,$9B28,$8004,$8000,
    $BFFE,$F5D8,$4001,$0000,$BFFE,$BA98,$8000,$8000,
    $BFFE,$B499,$4411,$0000,$B7FF,$FA6A,$8A20,$8000,
    $8DFF,$F559,$0411,$0000,$837F,$FAAF,$0821,$8000,
    $80DF,$F54D,$1011,$0000,$8077,$FA9E,$2821,$8000,
    $804D,$F56C,$1051,$8000,$8047,$7B9C,$6AB1,$8000,
    $8044,$D61C,$7FF1,$8000,$8044,$7800,$0000,$0000,
    $8044,$0000,$0000,$0000,$807C,$0000,$0000,$0000,
    $8000,$0000,$0000,$0000,
    $0000,$0000,$0000,$0000,$0000,$0000,$0000,$0400, -> Plane 1
    $0008,$0000,$0000,$0400,$020E,$0000,$0000,$0400,
    $054F,$0000,$0000,$0400,$0FA7,$0000,$0000,$0400,
    $0FF1,$0000,$0440,$0400,$17FA,$0000,$0000,$0400,
    $0AFE,$4000,$1551,$0400,$155E,$2800,$0000,$0400,
    $00AE,$7000,$1111,$0400,$0014,$7000,$2020,$0400,
    $000A,$2000,$5111,$0400,$0000,$6000,$8000,$8400,
    $0000,$0000,$4001,$0400,$0000,$4040,$8000,$8400,
    $0000,$0041,$4411,$0400,$0000,$0002,$8A20,$8400,
    $0000,$0001,$0411,$0400,$0000,$0007,$0821,$8400,
    $0000,$0005,$1011,$0400,$0000,$0006,$2821,$8400,
    $0000,$000C,$1051,$8400,$0000,$001C,$6AB1,$8400,
    $0000,$001C,$7FF1,$8400,$0000,$0000,$0000,$0400,
    $0000,$0000,$0000,$0400,$0000,$0000,$0000,$0400,
    $7FFF,$FFFF,$FFFF,$FC00,
    $0000,$0000,$0000,$0000,$7E07,$FFFF,$FFFF,$F800, -> Plane 2
    $79E9,$FFFF,$FFFF,$F800,$75EE,$7FFF,$F9CC,$7800,
    $22AF,$2AAA,$AEBD,$E800,$4047,$0FFF,$FFFD,$F800,
    $1009,$62AA,$AABD,$E800,$4804,$78DD,$DFFD,$D800,
    $1501,$3E2A,$AAA8,$A800,$0AA1,$54D1,$3FF5,$D000,
    $1F51,$0BEA,$AAA8,$A800,$1FEB,$07E0,$57D5,$C000,
    $1FF5,$4630,$A228,$A800,$1FFF,$0ED0,$6337,$0000,
    $1FFF,$6EF0,$A000,$8000,$1FFF,$2F21,$4003,$0000,
    $1FFF,$2F30,$9320,$9000,$0FFF,$6F91,$0413,$0000,
    $53FF,$EFF6,$D964,$D000,$20FF,$EFF0,$3612,$2000,
    $553F,$EFF2,$4D64,$D000,$2A8F,$EFE0,$929A,$2800,
    $5513,$EF93,$6FA6,$5000,$6AB8,$EE23,$954A,$3800,
    $5511,$2941,$0006,$5000,$7FBB,$87FF,$FFFF,$F800,
    $7FBB,$FFFF,$FFFF,$F800,$7F83,$FFFF,$FFFF,$F800,
    $0000,$0000,$0000,$0000
->»»>

->»» IMAGE DATA YAM (Unselected)
lab_YAMUnSelData:
INT $0000,$0000,$0000,$0000,$7FFF,$FFFF,$FFFF,$FC00, -> Plane 0
    $7FFF,$FFFF,$FFFF,$FC00,$79FF,$FFFF,$F9CC,$7C00,
    $3ABF,$EAAA,$A88C,$6C00,$7057,$3FFF,$F18C,$7C00,
    $300B,$DEAA,$A4CC,$6C00,$6805,$77DD,$C10C,$5C00,
    $3500,$BDEA,$B559,$2C00,$2AA0,$5731,$0004,$5400,
    $3F50,$0DDA,$9119,$2C00,$3EEA,$0AB8,$2464,$4400,
    $3DB5,$5CD8,$D119,$2C00,$3FDE,$9B28,$8004,$8400,
    $3FB7,$75D8,$4001,$0400,$3FEC,$BA98,$8000,$8400,
    $3FFB,$3499,$4411,$0400,$37FE,$FA6A,$8A20,$8400,
    $0DFF,$F559,$0411,$0400,$037F,$FAAF,$0821,$8400,
    $00DF,$F54D,$1011,$0400,$0077,$FA9E,$2821,$8400,
    $004D,$F56C,$1051,$8400,$0047,$7B9C,$6AB1,$8400,
    $0044,$D61C,$7FF1,$8400,$0044,$7800,$0000,$0400,
    $0044,$0000,$0000,$0400,$007C,$0000,$0000,$0400,
    $7FFF,$FFFF,$FFFF,$FC00,
    $FFFF,$FFFF,$FFFF,$FC00,$8000,$0000,$0000,$0000, -> Plane 1
    $8000,$0000,$0000,$0000,$8200,$0000,$0000,$0000,
    $8540,$0000,$0000,$0000,$8FA8,$0000,$0000,$0000,
    $8FF4,$0000,$0440,$0000,$97FA,$8000,$0000,$0000,
    $8AFF,$4000,$1551,$0000,$955F,$A800,$0000,$0000,
    $80AF,$F000,$1111,$0000,$8015,$F000,$2020,$0000,
    $820A,$A000,$5111,$0000,$8301,$6000,$8000,$8000,
    $8300,$8000,$4001,$0000,$8300,$4040,$8000,$8000,
    $8100,$0041,$4411,$0000,$8000,$0002,$8A20,$8000,
    $8000,$0001,$0411,$0000,$8000,$0007,$0821,$8000,
    $8000,$0005,$1011,$0000,$8000,$0006,$2821,$8000,
    $8000,$000C,$1051,$8000,$8000,$001C,$6AB1,$8000,
    $8000,$001C,$7FF1,$8000,$8000,$0000,$0000,$0000,
    $8000,$0000,$0000,$0000,$8000,$0000,$0000,$0000,
    $8000,$0000,$0000,$0000,
    $0000,$0000,$0000,$0000,$7E07,$FFFF,$FFFF,$F800, -> Plane 2
    $79F9,$FFFF,$FFFF,$F800,$75FE,$7FFF,$F9CC,$7800,
    $22BF,$2AAA,$AEBD,$E800,$4057,$CFFF,$FFFD,$F800,
    $100B,$E2AA,$AABD,$E800,$4805,$78DD,$DFFD,$D800,
    $1500,$BE2A,$AAA8,$A800,$0AA0,$54D1,$3FF5,$D000,
    $1F50,$0BEA,$AAA8,$A800,$19EA,$07E0,$57D5,$C000,
    $1A75,$4630,$A228,$A800,$1B3E,$8ED0,$6337,$0000,
    $1B4F,$6EF0,$A000,$8000,$1B73,$AF21,$4003,$0000,
    $197C,$AF30,$9320,$9000,$0E7F,$2F91,$0413,$0000,
    $53FF,$EFF6,$D964,$D000,$20FF,$EFF0,$3612,$2000,
    $553F,$EFF2,$4D64,$D000,$2A8F,$EFE0,$929A,$2800,
    $5513,$EF93,$6FA6,$5000,$6AB8,$EE23,$954A,$3800,
    $5511,$2941,$0006,$5000,$7FBB,$87FF,$FFFF,$F800,
    $7FBB,$FFFF,$FFFF,$F800,$7F83,$FFFF,$FFFF,$F800,
    $0000,$0000,$0000,$0000
->»»>

->»» IMAGE DATA Miami (Selected)
lab_MiamiSelData:
INT $FFFF,$FFFF,$FFFF,$E000,$8000,$0000,$0000,$0000, -> Plane 0
    $8000,$0000,$0000,$0000,$8FFF,$FFFF,$FFFF,$0000,
    $8FFF,$FFFF,$FFFF,$0000,$8FFF,$FD55,$FFFF,$0000,
    $8FFF,$EAAA,$FFFF,$0000,$8FFF,$5555,$7FFD,$0000,
    $8FFF,$FEAB,$FFFF,$0000,$8FFD,$57FF,$5FFF,$0000,
    $8FFF,$AAAA,$AFFF,$0000,$8FFD,$D755,$57FF,$0000,
    $8FFB,$EAAA,$BBFF,$0000,$8FF7,$5555,$F7FF,$0000,
    $8FFA,$AAAB,$ABFF,$0000,$8FF7,$D555,$5DFF,$0000,
    $8FFF,$FFAA,$EBFF,$0000,$8FF7,$FD55,$55FF,$0000,
    $8FFE,$EAAA,$ABFF,$0000,$8FF7,$5555,$55FF,$0000,
    $8FFA,$AAAA,$ABFF,$0000,$8FF7,$5555,$57FF,$0000,
    $8FFA,$AAAA,$ABFF,$0000,$8FFD,$5555,$57FF,$0000,
    $8FFB,$AAAA,$ABFF,$0000,$8FFD,$D555,$5FFF,$0000,
    $8FFE,$EAAA,$FBFF,$0000,$8FFF,$7555,$DFFF,$0000,
    $8FFF,$BFAF,$AFFF,$0000,$8FFF,$D7FF,$7FFF,$0000,
    $8FFF,$FBFA,$FFFF,$0000,$8FFF,$FD57,$FFFF,$0000,
    $8000,$0000,$0000,$0000,$8000,$0000,$0000,$0000,
    $8000,$0000,$0000,$0000,
    $0000,$0000,$0000,$1000,$0000,$0000,$0000,$1000, -> Plane 1
    $0000,$0000,$0000,$1000,$0FFF,$FE97,$FFFF,$1000,
    $0FFF,$F8F8,$FFFF,$1000,$0FFF,$FBFD,$3FFF,$1000,
    $00FF,$EF4F,$8FF6,$1000,$0FA1,$F801,$C6DD,$1000,
    $0F7F,$0203,$5F7F,$1000,$0FFF,$F73E,$5FFF,$1000,
    $0FFF,$8BD5,$1BFF,$1000,$0FFE,$8200,$1DFF,$1000,
    $0FFE,$8000,$3DFF,$1000,$0FFD,$00D8,$06FF,$1000,
    $0FF8,$01FE,$04FF,$1000,$0FFE,$0366,$0EFF,$1000,
    $0FFC,$03B6,$46FF,$1000,$0FFE,$03EB,$02FF,$1000,
    $0FFC,$442B,$06FF,$1000,$0FFE,$0020,$057F,$1000,
    $0FF8,$00A0,$06FF,$1000,$0FFC,$0060,$06FF,$1000,
    $0FFC,$0060,$0DFF,$1000,$0FFD,$0060,$07FF,$1000,
    $0FFB,$0060,$1FFF,$1000,$0FFF,$0070,$1FFF,$1000,
    $0FFF,$82F6,$57FF,$1000,$0FFF,$87FF,$9FFF,$1000,
    $0FFF,$F3F7,$BFFF,$1000,$0FFF,$F60D,$FFFF,$1000,
    $0FFF,$FFDF,$FFFF,$1000,$0FFF,$FFFF,$FFFF,$1000,
    $0000,$0000,$0000,$1000,$0000,$0000,$0000,$1000,
    $7FFF,$FFFF,$FFFF,$F000
->»»>

->»» IMAGE DATA Miami (Unselected)
lab_MiamiUnSelData:
INT $0000,$0000,$0000,$1000,$0000,$0000,$0000,$1000, -> Plane 0
    $0000,$0000,$0000,$1000,$0000,$0000,$0000,$1000,
    $0000,$0000,$0000,$1000,$0000,$07FE,$0000,$1000,
    $0000,$1FFF,$8000,$1000,$0400,$BFFF,$C002,$1000,
    $00A8,$01FC,$0080,$1000,$0003,$FC01,$F000,$1000,
    $0002,$7FFF,$F800,$1000,$0006,$7DFF,$F800,$1000,
    $0004,$3FFF,$CC00,$1000,$000C,$FFFF,$4C00,$1000,
    $000D,$FFFC,$7E00,$1000,$0008,$3FFF,$E600,$1000,
    $0008,$02FF,$BE00,$1000,$0008,$06BF,$FE00,$1000,
    $0009,$1FFD,$5E00,$1000,$0009,$FFFF,$FE00,$1000,
    $000D,$FF7F,$FE00,$1000,$000D,$FFFF,$FC00,$1000,
    $0005,$FFFF,$FC00,$1000,$0006,$FFFF,$F800,$1000,
    $0006,$7FFF,$F400,$1000,$0003,$3FFF,$E000,$1000,
    $0001,$BFFF,$8C00,$1000,$0000,$CFFE,$3000,$1000,
    $0000,$60F8,$7000,$1000,$0000,$3800,$C000,$1000,
    $0000,$0EA7,$8000,$1000,$0000,$03FC,$0000,$1000,
    $0000,$0000,$0000,$1000,$0000,$0000,$0000,$1000,
    $7FFF,$FFFF,$FFFF,$F000,
    $FFFF,$FFFF,$FFFF,$E000,$8000,$0000,$0000,$0000, -> Plane 1
    $8000,$0000,$0000,$0000,$8000,$0168,$0000,$0000,
    $8000,$0707,$0000,$0000,$8000,$0402,$C000,$0000,
    $8F00,$10B0,$7009,$0000,$805E,$07FE,$3922,$0000,
    $8080,$FDFC,$A080,$0000,$8000,$08C1,$A000,$0000,
    $8000,$742A,$E400,$0000,$8001,$7DFF,$E200,$0000,
    $8001,$7FFF,$C200,$0000,$8002,$FF27,$F900,$0000,
    $8007,$FE01,$FB00,$0000,$8001,$FC99,$F100,$0000,
    $8003,$FC49,$B900,$0000,$8001,$FC14,$FD00,$0000,
    $8003,$BBD4,$F900,$0000,$8001,$FFDF,$FA80,$0000,
    $8007,$FF5F,$F900,$0000,$8003,$FF9F,$F900,$0000,
    $8003,$FF9F,$F200,$0000,$8002,$FF9F,$F800,$0000,
    $8004,$FF9F,$E000,$0000,$8000,$FF8F,$E000,$0000,
    $8000,$7D09,$A800,$0000,$8000,$7800,$6000,$0000,
    $8000,$0C08,$4000,$0000,$8000,$09F2,$0000,$0000,
    $8000,$0020,$0000,$0000,$8000,$0000,$0000,$0000,
    $8000,$0000,$0000,$0000,$8000,$0000,$0000,$0000,
    $8000,$0000,$0000,$0000
->»»>
