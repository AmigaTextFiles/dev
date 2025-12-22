/* 
 *  Testing some Graphics-Rendering-Functions
 * -=========================================-
 *  __      __                   __
 *  \ \    / /___ __    __ ___  / /
 *   \ \  / // _ \\ \  / // __\/ /   - ENGINE
 *    \ \/ // /_\ \\ \/ // _/ / /__    Projekt
 *     \__/ \_____//_/\_\\__/ \___/
 * 
 * 
 * © 1998 THE DARK FRONTIER Softwareentwicklungen
 *
 * Begonnen             : Freitag       17 Juli   1998
 * Letzte Änderung      : Sonntag       02 August 1998
 *
 * Geplant:
 * --------
 *        (bewirkt Berg-Tal Effekt) geplant
 *      - Kamera-Unterstützung (Drehen nach links und rechts) [NOCH NICHT IM VOXEL-MODUL IMPLEMENTIERT!!!]
 *      - Benutzung eines Hintergrundbildes anstatt eines einfachen blauen Rechtecks!
 *      - Ziehende Wolken einbauen (benutzung von IDCMP_INTUITICK für die Wolkenbewegung!)
 *      - Source kommentieren
 *      - ???
 *
 * Verwirklicht:
 * -------------
 *      - 100 % System-Konform programmiert!
 *      - Cockpit-Unterstützung (wenn auch nur minimal!)
 *      - Landscape-Map (mit einem Berg in der Mitte und einem kleinen Tal außenrum)
 *      - Joystick (und Joypad) unterstützung
 *      - Double-Buffering beim Bildschirm-Aufbau gegen lästiges Flimmern (Mittels Window-Backdrop-Routine)
 */

OPT     OSVERSION = 39                  -> Because of AllocBitMap

MODULE  '*voxel_gfx'
MODULE  'graphics/rastport'
MODULE  'intuition/intuition'
MODULE  'intuition/screens'
MODULE  'utility/tagitem'
MODULE  'lowlevel'
MODULE  'libraries/lowlevel'

CONST   MAP_WIDTH       = 400,
        MAP_LENGTH      = 200,
        MAP_MAXHEIGHT   = 128

CONST   SCREEN_WIDTH    = 320,
        SCREEN_HEIGHT   = 256,
        SCREEN_DEPTH    = 8

DEF     screen     =NIL :PTR TO screen,
        rport      =NIL :PTR TO rastport,
        bufferwin  =NIL :PTR TO window,
        display    =NIL :PTR TO voxel_display,
        map        =NIL :PTR TO LONG,
        position   =NIL :PTR TO voxel_position,
        buffer     =TRUE

PROC main()
 DEF    row=0,
        col=0,
        posx=0,
        posy=0,
        color=0,
        change=FALSE,
        joystate=NIL,
        id=NIL,
        pos,
        height=0

 IF (lowlevelbase:=OpenLibrary('lowlevel.library',37))

 IF (arg<>NIL) THEN id:=Val(arg,NIL)
 IF (screen:=OpenScreenTagList(NIL,
       [SA_WIDTH,       320,
        SA_HEIGHT,      256,
        SA_DEPTH,       7,
        IF (id<>NIL) THEN SA_DISPLAYID ELSE TAG_IGNORE,   id,
        NIL,            NIL]))
  setpalette()
  IF (display:=voxel_InitDisplay(screen,320,256,320,150,3,{fillback},NIL))
   rport:=display.window.rport
    display.rport:=rport
     bufferwin:=OpenWindowTagList(NIL,
               [WA_LEFT,        0,
                WA_TOP,         0,
                WA_WIDTH,       SCREEN_WIDTH,
                WA_HEIGHT,      SCREEN_HEIGHT,
                WA_IDCMP,       DISPLAY_IDCMP,
                WA_FLAGS,       WFLG_BORDERLESS OR WFLG_ACTIVATE,
                IF (screen=NIL) THEN TAG_IGNORE ELSE WA_CUSTOMSCREEN,screen,
                NIL,            NIL])
    IF (map:=voxel_InitMap(MAP_WIDTH,MAP_LENGTH))

      FOR row:=0 TO MAP_LENGTH-1
       FOR col:=0 TO MAP_WIDTH-1
        IF (col<=(MAP_WIDTH/2))
         height:=(col*(MAP_MAXHEIGHT/2)/MAP_WIDTH)+4
        ELSE
         height:=(MAP_MAXHEIGHT/2)-(col*(MAP_MAXHEIGHT/2)/MAP_WIDTH)+4
        ENDIF
         IF (row<=(MAP_LENGTH/2))
          height:=height+(row*(MAP_MAXHEIGHT/2)/MAP_LENGTH)
         ELSE
          height:=height+(MAP_MAXHEIGHT/2)-(row*(MAP_MAXHEIGHT/2)/MAP_LENGTH)
         ENDIF
        color:=height

        voxel_SetMap(map,col,row,color,height)
       ENDFOR
      ENDFOR

      IF (position:=voxel_InitPosition(map,50,100,0,90))

        voxel_DrawDisplay(display,map,position)
         SetDrMd(rport,RP_JAM1)
        drawcockpit()

         REPEAT
          joystate:=ReadJoyPort(1)
           IF (joystate AND JP_TYPE_NOTAVAIL) 
            WriteF('Joyport not available!\n')
             change:=-2
           ENDIF
            IF (joystate AND JPF_BUTTON_BLUE)
             pos:=10
            ELSEIF (joystate AND JPF_BUTTON_RED)
             change:=-2
            ELSE
             pos:=1
            ENDIF
             IF (joystate AND JPF_JOY_UP)
              posx,posy,height:=voxel_GetPosition(position)
               change:=TRUE
              posy:=posy-pos
             ELSEIF (joystate AND JPF_JOY_DOWN)
              posx,posy,height:=voxel_GetPosition(position)
               change:=TRUE
              posy:=posy+pos
             ENDIF
             IF (joystate AND JPF_JOY_LEFT)
              posx,posy,height:=voxel_GetPosition(position)
               change:=TRUE
              posx:=posx-pos
             ELSEIF (joystate AND JPF_JOY_RIGHT)
              posx,posy,height:=voxel_GetPosition(position)
               change:=TRUE
              posx:=posx+pos
             ENDIF

             IF change=TRUE
              voxel_SetPosition(map,position,posx,posy,0)
               voxel_DrawDisplay(display,map,position)
                drawcockpit()
               IF buffer=FALSE
                display.rport:=display.window.rport
                 buffer:=TRUE
                rport:=display.rport
                MoveWindowInFrontOf(bufferwin,display.window)
               ELSE
                display.rport:=bufferwin.rport
                 buffer:=FALSE
                rport:=display.rport
               MoveWindowInFrontOf(display.window,bufferwin)
               ENDIF
              change:=FALSE     
             ELSE
              Delay(1)
             ENDIF

         UNTIL (change=-2) OR CtrlC()

       voxel_FreePosition(position)
      ELSE
       WriteF('Couldn`t init the Position!')
      ENDIF

     voxel_FreeMap(map)
    ELSE
     WriteF('Couldn`t init the MAP!\n')
    ENDIF

   IF (bufferwin<>NIL) THEN CloseWindow(bufferwin)
   voxel_FreeDisplay(display)
  ELSE
   WriteF('Couldn`t init the Display!\n')
  ENDIF 
 CloseScreen(screen)
 ELSE
  WriteF('Couldn`t open the needed 320x256 screen!\n')
 ENDIF
  CloseLibrary(lowlevelbase)
 ELSE
  WriteF('Couldn`t open the lowlevel.library')
 ENDIF
CleanUp(exception)
ENDPROC

PROC setpalette()
 DEF    color
  SetColour(screen,0,$1F,$2F,$FF)
  SetColour(screen,1,$00,$FF,$00)
  SetColour(screen,2,$FF,$00,$00)
  SetColour(screen,3,$1F,$2F,$FF)
   FOR color:=4 TO 127
    SetColour(screen,color,color,color,color)
   ENDFOR
ENDPROC

PROC fillback(dis:PTR TO voxel_display,voxelmap:PTR TO LONG,pos:PTR TO voxel_position)
-> Draw "sky"
 SetAPen(rport,3)
  RectFill(rport,0,0,dis.window.width,dis.height)
ENDPROC

PROC drawcockpit()
 DEF    h,
        a=0
  SetAPen(rport,1)
   h:=(display.window.height-MAP_MAXHEIGHT)/2
    Move(rport,10,h)
     Draw(rport,10,h+((MAP_MAXHEIGHT/10)*10))
    FOR a:=0 TO 10
     Move(rport,5,h+((MAP_MAXHEIGHT/10)*a))
      Draw(rport,15,h+((MAP_MAXHEIGHT/10)*a))
    ENDFOR
   SetAPen(rport,2)
  Move(rport,20,h+MAP_MAXHEIGHT-position.height)
 Draw(rport,25,h+MAP_MAXHEIGHT-position.height)
ENDPROC

