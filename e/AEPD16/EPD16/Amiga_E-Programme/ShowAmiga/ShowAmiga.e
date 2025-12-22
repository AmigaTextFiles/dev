OPT OSVERSION=39

MODULE 'intuition/intuition',
       'intuition/screens',
       'graphics/text',
       'graphics/rastport',
       'diskfont',
       'libraries/diskfont'

CONST MAXBUFFER=10000
       
DEF win=NIL:PTR TO window,scr=NIL:PTR TO screen,pt=NIL,
    font=NIL,fontbig=NIL,
    cimage=NIL:PTR TO image,p1img=NIL:PTR TO image,p2img=NIL:PTR TO image,
    lang=NIL:PTR TO LONG,langanz,langnr=-1,
    art:PTR TO LONG,atyp:PTR TO CHAR,artanz,
    auto=FALSE

PROC main()
  DEF e=FALSE,k
  getcliargs()
  EasyRequestArgs(NIL,[20,0,NIL,'ShowAmiga V1.00\nby\nBastian Frank\nSchwalbachweg 16\nD-95666 Mitterteich\n\nThis programme is PD!','Weiter'],0,NIL)
  IF fehler(initialise())<>-1
    freeall()
    CleanUp(20)
  ENDIF
  WHILE e=FALSE
    getlanguages()
    k:=title(auto)
    IF k=5
      /*e:=TRUE*/
    ELSE
      IF auto
        IF langnr<0
          langnr:=chooselang()
        ENDIF
      ELSE
        langnr:=chooselang()
      ENDIF    
      art,atyp,artanz:=getarticles(langnr)
      IF art<>NIL AND (atyp<>NIL)
        IF auto THEN textautomatic() ELSE textsteuerung()  
      ENDIF
      freearticles(art,atyp)    
    ENDIF
  ENDWHILE
  freeall()
ENDPROC
PROC getcliargs()
  DEF arg:PTR TO LONG,rdargs
  arg:=[0]
  IF rdargs:=ReadArgs('AUTO=AUTOMATIC/S',arg,NIL)
    IF arg[0] THEN auto:=TRUE
    FreeArgs(rdargs)
  ENDIF
ENDPROC

PMODULE 'ShowAmiga_parts','ShowAmiga_initialise','ShowAmiga_system'
