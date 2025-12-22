/* 
     Someone asked for a fonts demo, here is a small one. 
*/

MODULE 'diskfont'             /* OpenDiskFont is here */
MODULE 'graphics/text'        /* textattr structure is here */
MODULE 'intuition/intuition'  /* window structure is here */

PROC do_it(rport)
DEF f,ta:PTR TO textattr
  ta:=New(SIZEOF textattr)
  ta.name:='ruby.font'  
  ta.ysize:=15           /* point size */
  ta.style:=FS_NORMAL    /* no underlines etc. */
  ta.flags:=FPF_DISKFONT 
  f:=OpenDiskFont(ta)
  IF f
    SetTopaz(8)               /* Use topaz 8 for first line */
    TextF(20,20,'FontDemo by Kai.Nikulainen@utu.fi')
    SetFont(rport,f)          /* change the window's font */
    TextF(70,80,'This is Ruby 15')
    Move(rport,80,150)              /* an altenative way to print text which */
    Text(rport,'Hit ^C to quit',14) /* does not use stdrast */
    CloseFont(f)             /* fonts must be closed after use */
    SetTopaz(8)              /* set font back to standard */
  ELSE
    WriteF('Can not open font\n')
  ENDIF
ENDPROC

PROC main()
DEF s,w:PTR TO window
  s:=OpenS(320,200,2,0,'')
  IF s
    w:=OpenW(0,0,320,200,0,0,'',s,15,0)
    IF w
      diskfontbase:=OpenLibrary('diskfont.library',0)
      IF diskfontbase
        do_it(w.rport)
        WHILE CtrlC()=FALSE  /* wait for ctrl-c, which does NOT register */
        ENDWHILE             /* if the program window is activated */
      ELSE /* no diskfont.library found */
        WriteF('Can not open diskfont.library\n')
      ENDIF /* diskfontbase */
      CloseW(w)
    ELSE /* window did not open */
      WriteF('Can not open window\n')  
    ENDIF /* w */
    CloseS(s)
  ELSE /* screen did not open */
    WriteF('Can not open screen\n')
  ENDIF /* s */
ENDPROC

/*
   *-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*
   |   Kai.Nikulainen@utu.fi, Computer Science,    |
   |   University of Turku, Phone:+358 21 2335407  |
   *-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*
*/
