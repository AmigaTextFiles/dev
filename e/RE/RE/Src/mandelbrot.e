-> Mandelbrot fractal by Robert Kihl (robert@snarl-up.com)

->OPT CPU='WUP'
MODULE  'dos/dos','exec/memory','intuition/intuition','intuition/screens',
                        'graphics/modeid','utility/tagitem'


PROC main()
  DEF w=320,h=240,d=8,x,y=0,n,iters
  DEF zp,zq,cp,cq,xstep,ystep,xmin=-2.0,xmax=0.8,ymin=-1.2,ymax=1.2,ftemp
  DEF screen:PTR TO Screen,window:PTR TO Window,vp

  xstep:=!(!xmax-xmin)/(w!)
  ystep:=!(!ymax-ymin)/(h!)

  IF screen:=OpenScreenTags(NIL,
                            SA_Width,w,
                            SA_Height,h,
                            SA_Depth,d,
                            SA_Title,'Mandelbrot',
                            TAG_END)

    IF window:=OpenWindowTags(NIL,
                              WA_Width,w,
                              WA_Height,h,
                              WA_IDCMP,IDCMP_CLOSEWINDOW OR IDCMP_MOUSEBUTTONS,
                              WA_Flags,WFLG_BORDERLESS + WFLG_ACTIVATE + WFLG_RMBTRAP,
                              WA_CustomScreen,screen,
                              TAG_END)
      ->make a grey scale palette
      vp:=ViewPortAddress(window)
      FOR n:=0 TO 255 DO SetRGB32(vp,n,n<<24,n<<24,n<<24)

      cq:=ymin
      WHILE y<h
        x:=0
        cp:=xmin
        WHILE x<w
          iters:=0
          zp:=0.0
          zq:=0.0
          WHILE (!zp<4.0) AND (iters<150)
            ftemp:=!(!zp*zp)-(!zq*zq)+cp
            zq:=!(!2.0*(!zp*zq))+cq
            zp:=ftemp
            iters++
            IF Mouse()=1 THEN JUMP ext
          ENDWHILE
          SetAPen(window.RPort,150-iters)
          WritePixel(window.RPort,x,y)
          cp := !cp+xstep
          x++
        ENDWHILE
        cq := !cq+ystep
        y++
      ENDWHILE
ext:
      WaitPort(window.UserPort)
      CloseWindow(window)

    ELSE
      PrintF('Unable to open window!\n')
    ENDIF
    CloseScreen(screen)

  ELSE
    PrintF('Unable to open screen!\n')
  ENDIF

ENDPROC

