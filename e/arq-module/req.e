-> Simple ARQ Extended Requester Demo
-> compiled with ec3.1a

-> This Code was written by me, Arne Meyer and is FreeWare.
-> Do whatever you like with it.
-> but send me a short eMail if it was useful for you.
-> my email address is <q09883@pbhrzx.uni-paderborn.de>

OPT OSVERSION=36
OPT PREPROCESS

->#define DEBUG

#ifdef DEBUG
MODULE 'tools/debug'
#endif

MODULE 'intuition/intuition', 'tools/arq', 'exec/memory',
       'icon', 'workbench/workbench',
       'intuition/intuitionbase', 'intuition/screens'     -> for img test window


DEF title[40]:STRING,
    myargs[5]:ARRAY OF LONG

-> /// -------------------------- "PROC main" ---------------------------

PROC main()
DEF result, rdargs

    IF rdargs := ReadArgs( 'TEXT/A,TITLE/A,BUTTONS/A,REQTYPE/N,ICON,X/N,Y/N', myargs, NIL )
        result := geticonimage( myargs[4], Long(myargs[5]), Long(myargs[6]) )
        FreeArgs( rdargs )
    ENDIF

ENDPROC result

-> /// ------------------------------------------------------------------
-> /// ---------------------- "PROC geticonimage" -----------------------

PROC geticonimage( object, xoffset = NIL, yoffset = NIL )
DEF result = NIL,
    dob:PTR TO diskobject

    IF (iconbase := OpenLibrary('icon.library',36))
      #ifdef DEBUG
      kputfmt( 'icon.library opened\n', NIL )
      #endif
      IF ( dob := GetDiskObject( object ) )
        #ifdef DEBUG
        kputfmt( 'dob         = $\h\n', [dob] )
        kputfmt( 'dob.magic   = $\h\n', [dob.magic] )
        kputfmt( 'dob.version = $\h\n', [dob.version] )
        kputfmt( 'dob.stack   = $\h\n', [dob.stacksize] )
        #endif

        result := doreq(dob.gadget::gadget.gadgetrender,xoffset,yoffset)

        FreeDiskObject( dob )
      ELSE
        #ifdef DEBUG
        kputfmt( 'ERRORCODE = $\h\n', [ IoErr() ] )
        #endif
        result := doreq()
      ENDIF
    CloseLibrary( iconbase )
    ENDIF
ENDPROC result

-> /// ------------------------------------------------------------------
/*
-> /// ------------------------- "PROC showimg" -------------------------

PROC showimg(img:PTR TO image)
DEF wnd:PTR TO window,
    screen:PTR TO screen,
    intuibase:PTR TO intuitionbase

WriteF('imgdata  at \h\n',img)
    intuibase := intuitionbase
    screen    := intuibase.activescreen
    wnd := OpenW(0,20,100,100,IDCMP_CLOSEWINDOW,$e,'testwin',screen,2,0)
    DrawImage(wnd.rport,img,20,20)
    WaitIMessage(wnd)
    CloseW(wnd)
ENDPROC

-> /// ------------------------------------------------------------------
*/
-> /// -------------------------- "PROC doreq" --------------------------

PROC doreq(img=NIL:PTR TO image,xoffset=NIL,yoffset=NIL)
DEF result, eestruct:PTR TO exteasystruct  -> for ARQ

    NEW eestruct

    StringF(title,'\s\c',myargs[1],$a0) -> do the non-blanking space

    IF img
        img.leftedge           := img.leftedge + xoffset
        img.topedge            := img.topedge  + yoffset

        eestruct.animid        := ARQ_ID_IMAGE
    ELSE
        eestruct.animid        := And(Long(myargs[3]),7)
    ENDIF

    eestruct.magic             := ARQ_MAGIC

    eestruct.flags             := NIL
    eestruct.sound             := NIL
    eestruct.reserved[0]       := NIL
    eestruct.reserved[1]       := NIL
    eestruct.reserved[2]       := NIL

    eestruct.image             := img

    eestruct.easy.structsize   := SIZEOF easystruct
    eestruct.easy.flags        := NIL
    eestruct.easy.title        := title
    eestruct.easy.textformat   := myargs[0]
    eestruct.easy.gadgetformat := myargs[2]

    result := EasyRequestArgs( NIL, eestruct.easy, NIL, NIL )

    END eestruct

ENDPROC result
-> /// ------------------------------------------------------------------
