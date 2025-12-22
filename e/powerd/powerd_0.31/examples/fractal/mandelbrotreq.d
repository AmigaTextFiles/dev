// Mandelbrot fractal by Robert Kihl (robert@snarl-up.com)


MODULE  'dos/dos','exec/memory','intuition/intuition','intuition/screens',
        'graphics/modeid','utility/tagitem','asl','libraries/asl'

DEF ASLBase

PROC main()
  DEFW w=320,h=240,d=8,x,y=0,n,iters
  DEFF zp,zq,cp,cq,xstep,ystep,xmin=-2.0,xmax=0.8,ymin=-1.2,ymax=1.2,ftemp
  DEF screen:PTR TO Screen,window:PTR TO Window,vp
  DEF asl:PTR TO ScreenModeRequester

  IF ASLBase:=OpenLibrary('asl.library',37)

    IF asl:=AllocAslRequest(ASL_ScreenModeRequest, NIL)

      IF AslRequest(asl, NIL)

        IF screen:=OpenScreenTags(NIL, SA_Width,asl.DisplayWidth,
                                       SA_Height,asl.DisplayHeight,
                                       SA_Depth,8,
                                       SA_Title,'Mandelbrot',
                                       SA_DisplayID,asl.DisplayID,
                                       TAG_END)

          IF window:=OpenWindowTags(NIL, WA_Width,asl.DisplayWidth,
                                         WA_Height,asl.DisplayHeight,
                                         WA_IDCMP,IDCMP_CLOSEWINDOW|IDCMP_MOUSEBUTTONS,
                                         WA_Flags,WFLG_BORDERLESS|WFLG_ACTIVATE|WFLG_RMBTRAP,
                                         WA_CustomScreen,screen,
                                         TAG_END)

            vp:=ViewPortAddress(window)
            FOR n:=0 TO 255 DO SetRGB32(vp,n,n<<20,n<<23,n<<24)

            xstep:=(xmax-xmin)/asl.DisplayWidth
            ystep:=(ymax-ymin)/asl.DisplayHeight
 

            FOR cq:=ymin TO ymax STEP ystep
              x:=0
              FOR cp:=xmin TO xmax STEP xstep
                iters:=0
                zp:=0
                zq:=0
                WHILE FAbs(zp)<4 AND iters<96
                  ftemp:=zp*zp-zq*zq+cp
                  zq:=2*(zp*zq)+cq
                  zp:=ftemp
                  iters++
                ENDWHILE
                SetAPen(window.RPort,192-iters*2)
                WritePixel(window.RPort,x,y)
                x++
                IF Mouse() THEN cq:=ymax
              ENDFOR
              y++
            ENDFOR

            WaitPort(window.UserPort)
            CloseWindow(window)
            FreeAslRequest(asl)

          ELSE PrintF('Unable to open window\n')

          CloseScreen(screen)

        ELSE PrintF('Unable to open screen\n')

      ELSE PrintF('Unable to open aslrequester\n')

    ELSE PrintF('Unable to Allocate aslrequester\n')

  ELSE PrintF('Unable to open asl.library\n')

ENDPROC
