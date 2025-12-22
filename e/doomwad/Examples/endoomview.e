/*
** ENDOOM viewer
**
** A little example for my "doomwad.m" module
**
** Have fun...
**
*/

MODULE 'doomwad','exec/memory','dos/dos','intuition/screens','intuition/intuition',
       'graphics/text','diskfont', 'libraries/diskfont'

DEF mwh:PTR TO wadhandle, mdb:dirblock, r,c,scr:PTR TO screen, tattr:textattr

PROC main()
  DEF x,y,p,fg,bg,fnt
  
  -> Little message
  WriteF('ENDOOM viewer v1.0 ©1998 Peter Gordon\n\nPointless? No, just a programming excersize...\n\n')
  
  -> Details of the IBM style font to use
  tattr.name:='ansi.font'
  tattr.ysize:=8
  tattr.style:=0
  tattr.flags:=0
  
  -> Try to load the font from disk. Doesnt matter if we fail, AmigaOS will
  -> just revert to topaz.
  IF(diskfontbase:=OpenLibrary('diskfont.library',36))
    fnt:=OpenDiskFont(tattr)
    CloseLibrary(diskfontbase)
  ENDIF
  
  -> Open WAD
  IF(mwh:=openwad(arg))
  
    -> Pointless information :)
    WriteF('"\s" is a',arg)
    IF(mwh.iwad) THEN WriteF('n IWAD\n') ELSE WriteF(' PWAD\n')

    -> Find the ENDOOM entry
    WriteF('Scanning for ENDOOM lump...')
    r,c:=findentry('ENDOOM',mwh,mdb)
    IF(r)
      
      -> Wahay! We got one!
      WriteF('FOUND!\n')
      
      -> Allocate memory to load the ENDOOM lump into
      IF(c:=NewM(mdb.size,MEMF_ANY))
      
        -> Seek to endoom lump
        Seek(mwh.dosh,mdb.offset,OFFSET_BEGINNING)
        
        -> Read it in
        Read(mwh.dosh,c,mdb.size)
        
        -> Open a 640 x 256 x 16 screen
        IF(scr:=OpenS(640,256,4,$8000,0,[SA_FONT,tattr,SA_SHOWTITLE,FALSE,0,0]))
          
          -> Completely blank it
          Box(0,0,639,255,0)
          
          -> El-Crappo MS-DOG colours :)
          SetColour(scr,0,0,0,0)
          SetColour(scr,1,0,0,170)
          SetColour(scr,2,0,170,0)
          SetColour(scr,3,0,170,170)
          SetColour(scr,4,170,0,0)
          SetColour(scr,5,170,0,170)
          SetColour(scr,6,170,170,0)
          SetColour(scr,7,170,170,170)
          SetColour(scr,8,102,102,102)
          SetColour(scr,9,0,80,255)
          SetColour(scr,10,40,255,40)
          SetColour(scr,11,20,255,255)
          SetColour(scr,12,255,20,20)
          SetColour(scr,13,255,20,255)
          SetColour(scr,14,255,255,0)
          SetColour(scr,15,255,255,255)
          
          -> "p" is the position from the start of the ENDOOM lump
          -> "x" and "y" are the screen positions
          p:=0
          x:=0
          y:=0
          
          -> Loop through the whole endoom lump
          WHILE(p<(mdb.size/2))
          
            -> The ENDOOM lump is basically a dump of the PC text screen
            -> memory, so we have to extract useful values from it.
            -> The foreground colour is stored in the low 4 bits, the
            -> background colour is stored in the next 3 bits, and the
            -> remaining bit is "BLINK", but we're ignoring blink :)
            fg:=(Char(c+(p*2)+1) AND %00001111)
            bg:=Shr((Char(c+(p*2)+1) AND %01110000),4)
            
            -> Set the colour
            Colour(fg,bg)
            
            -> Print the char
            TextF(x*8,y*8+24,'\c',Char(c+(p*2)))
            
            -> Next char in ENDOOM
            INC p
            
            -> Next screen position
            INC x
            IF(x=80)
              x:=0
              INC y
            ENDIF
          ENDWHILE
          
          -> Wait for mouse
          WHILE(Mouse()=0);WaitTOF();ENDWHILE
          
          -> Byee!
          CloseS(scr)
        ENDIF
        Dispose(c)
      ENDIF
    ELSE
      WriteF('No chance :)\n')
    ENDIF
    closewad(mwh)
  ENDIF
  IF(fnt) THEN CloseFont(fnt)
ENDPROC

      
