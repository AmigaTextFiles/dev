/********************************************************************************
 * << AUTO HEADER XDME >>
 ********************************************************************************
 ED             "EDG"
 EC             "EC"
 PREPRO         "EPP"
 SOURCE         "ViewIlbm.e"
 EPPDEST        "ViewIlbm_EPP.e"
 EXEC           "ViewIlbm"
 ISOURCE        " "
 HSOURCE        " "
 ERROREC        " "
 ERROREPP       " "
 VERSION        "0"
 REVISION       "1"
 NAMEPRG        "ViewIlbm"
 NAMEAUTHOR     "NasGûl"
 ********************************************************************************
 * HISTORY :
 *******************************************************************************/

OPT OSVERSION=39

ENUM ER_NONE,ER_GFX,ER_INTUI,ER_IFF,ER_REQTOOLS,ER_ONLYCLI,ER_BADARGS

MODULE 'graphics/gfxbase','graphics/displayinfo','dos/dos','intuition/screens','intuition/intuition'
MODULE 'graphics/view','graphics/gfx','graphics/rastport'
MODULE 'iff','libraries/iff'
MODULE 'reqtools','libraries/reqtools'
MODULE 'utility/tagitem'

DEF f_s[256]:STRING,opt_hires,opt_lace,opt_lores,opt_req,opt_info,opt_filereq
DEF opt_did_cli,whith_req=FALSE
DEF reqbody[500]:STRING
DEF rast

PROC main() HANDLE /*"main()"*/
/********************************************************************************
 * Para         : NONE
 * Return       : NONE
 * Description  : Main proc.
 *******************************************************************************/
    DEF test_main
    VOID {prg_banner}
    IF (gfxbase:=OpenLibrary('graphics.library',37))=NIL THEN Raise(ER_GFX)
    IF (intuitionbase:=OpenLibrary('intuition.library',37))=NIL THEN Raise(ER_INTUI)
    IF (iffbase:=OpenLibrary('iff.library',23))=NIL THEN Raise(ER_IFF)
    IF (reqtoolsbase:=OpenLibrary('reqtools.library',38))=NIL THEN Raise(ER_REQTOOLS)
    IF wbmessage<>NIL
        Raise(ER_ONLYCLI)
    ELSE
        IF (test_main:=start_from_cli())<>ER_NONE THEN Raise(test_main)
    ENDIF
    IF opt_filereq
        my_filerequester()
    ELSE
        displayilbm(f_s)
    ENDIF
    Raise(ER_NONE)
EXCEPT
    IF reqtoolsbase THEN CloseLibrary(reqtoolsbase)
    IF iffbase THEN CloseLibrary(iffbase)
    IF intuitionbase THEN CloseLibrary(intuitionbase)
    IF gfxbase THEN CloseLibrary(gfxbase)
    SELECT exception
        CASE ER_GFX;         WriteF('Graphics.library ?\n')
        CASE ER_INTUI;       WriteF('Intuition.library ?\n')
        CASE ER_IFF;         WriteF('Iff.library ?\n')
        CASE ER_REQTOOLS;    WriteF('Reqtools.library ?\n')
        CASE ER_ONLYCLI;     WriteF('Du cli uniquement.\n')
        CASE ER_BADARGS;     WriteF('Mauvais Argument.\n')
    ENDSELECT
ENDPROC
PROC my_filerequester() /*"my_filerequester()"*/
/********************************************************************************
 * Para         : NONE
 * Return       : NONE
 * Description  : PopUp a MultiFileRequester to choose the source(s).
 *******************************************************************************/
    DEF buffer[108]:STRING,add_liste
    DEF fich[100]:STRING
    DEF liste:PTR TO rtfilelist
    DEF reqfile:PTR TO rtfilerequester
    IF reqfile:=RtAllocRequestA(RT_FILEREQ,0)
        buffer[0]:=0
        add_liste:=RtFileRequestA(reqfile,buffer,'ViewIlbm v0.0a (c) NasGûl',[RTFI_FLAGS,FREQF_MULTISELECT,
                                                               RTFI_OKTEXT,'_View',RTFI_HEIGHT,256,
                                                               RT_UNDERSCORE,"_",
                                                               TAG_DONE])
        liste:=add_liste
        IF buffer[0]<>0
            WHILE liste
                AddPart(reqfile.dir,'',100)
                StrCopy(fich,reqfile.dir,ALL)
                StrAdd(fich,liste.name,ALL)
                StrCopy(f_s,fich,ALL)
                displayilbm(f_s)
                liste:=liste.next
            ENDWHILE
            RtFreeFileList(add_liste)
        ENDIF
        RtFreeRequest(reqfile)
    ELSE
        RtEZRequestA('Impossible d\aouvrir le sélécteur de fichiers.','Ok',0,0,[RTEZ_REQTITLE,'ViewIlbm v0.0a (c) 1994 NasGûl',
                                                   TAG_DONE,0]:tagitem)
    ENDIF
ENDPROC
PROC start_from_cli() /*"start_from_cli()"*/
/********************************************************************************
 * Para         : NONE
 * Return       : ER_NONE if ok,else the error.
 * Description  : Parse CLi arguments.
 *******************************************************************************/
    DEF myargs:PTR TO LONG,rdargs
    myargs:=[0,0,0,0,0,0,0]
    IF rdargs:=ReadArgs('FICHIER,HIRES/S,LACE/S,LORES/S,REQ/S,INFO/S,FILEREQ/S',myargs,NIL)
        StringF(f_s,'\s',myargs[0])
        IF opt_hires:=myargs[1] THEN opt_did_cli:=HIRES_KEY
        IF opt_lace:=myargs[2] THEN opt_did_cli:=LORESLACE_KEY
        IF (opt_hires:=myargs[1]) AND (opt_lace:=myargs[2]) THEN opt_did_cli:=HIRESLACE_KEY
        IF (opt_lores:=myargs[3]) THEN opt_did_cli:=LORES_KEY
        IF (opt_req:=myargs[4]) THEN whith_req:=TRUE
        opt_info:=myargs[5]
        opt_filereq:=myargs[6]
        FreeArgs(rdargs)
    ELSE
        RETURN ER_BADARGS
    ENDIF
    RETURN ER_NONE
ENDPROC
PROC displayilbm(f_s) /*"displayilbm(f_s)"*/
/********************************************************************************
 * Para         : the source file (STRING).
 * Return       : NONE
 * Description  : View the source file.
 *******************************************************************************/
    DEF iff
    DEF my_bmhd:PTR TO bmhd
    DEF my_screen:PTR TO screen
    DEF my_ns:PTR TO ns
    DEF count,colortable[768]:ARRAY OF INT
    DEF passe_chunk=NIL
    DEF f_mode,adr_chunk_camg,offset_camg
    DEF ret,x
    DEF vquatre_bit=FALSE
    IF iff:=IfFL_OpenIFF(f_s,IFFL_MODE_READ)
        IF adr_chunk_camg:=IfFL_FindChunk(iff,"CAMG")
            offset_camg:=adr_chunk_camg-iff
        ENDIF
        IF my_bmhd:=IfFL_GetBMHD(iff)
            my_ns:=New(SIZEOF ns)
            my_ns.type:=CUSTOMSCREEN+SCREENBEHIND+SCREENQUIET
            my_ns.width:=my_bmhd.w
            my_ns.height:=my_bmhd.h
            my_ns.depth:=my_bmhd.nplanes
            IF my_ns.depth>8
                my_ns.depth:=8
                vquatre_bit:=TRUE
            ENDIF
            f_mode:=IfFL_GetViewModes(iff)
            IF whith_req=FALSE
                my_ns.viewmodes:=f_mode+opt_did_cli
            ELSE
                my_ns.viewmodes:=choosedisplayid(f_mode)
            ENDIF
            IF my_screen:=OpenScreen(my_ns)
                /*PubScreenStatus(my_screen,0)*/
                rast:=my_screen.rastport
                count:=IfFL_GetColorTab(iff,colortable)
                IF vquatre_bit=FALSE
                    IF (IfFL_FindChunk(iff,"CMAP"))
                        LoadRGB4(my_screen.viewport,colortable,count)
                    ELSE
                        /*LoadRGB4(my_screen.viewport,{pal256},768)*/
                    ENDIF
                ELSE
                    FOR x:=0 TO 255 DO fullcolour(x,x,x,x)
                ENDIF
                IF (IfFL_DecodePic(iff,my_screen.bitmap))
                    ScreenToFront(my_screen)
                    StringF(reqbody,'ViewIlbm v0.0a © 1994 NasGûl\n'+
                               'Image             Ecran\n'+
                               'Width   :\l\d[8]  Width   :\l\d[8]\n'+
                               'Height  :\l\d[8]  Height  :\l\d[8]\n'+
                               'Depth   :\l\d[8]  Depth   :\l\d[8]\n'+
                               'DisMode :\l\h[8]  DisMode :\l\h[8]\n',
                                my_bmhd.w,my_screen.width,
                                my_bmhd.h,my_screen.height,
                                my_bmhd.nplanes,my_ns.depth,
                                f_mode,my_ns.viewmodes)
                    REPEAT
                        IF Mouse()=3
                            DisplayBeep(my_screen)
                            passe_chunk:=my_ns.viewmodes
                        ENDIF
                    UNTIL Mouse()=2
                    ScreenToBack(my_screen)
                    IF opt_info THEN RtEZRequestA(reqbody,'_Ok',0,0,[RT_UNDERSCORE,"_",TAG_DONE,0])
                ELSE
                    RtEZRequestA('can\at decode picture.','Ok',0,0,NIL)
                ENDIF
                CloseScreen(my_screen)
                Dispose(my_ns)
            ELSE
                RtEZRequestA('can\at open screen.','Ok',0,0,NIL)
            ENDIF
        ELSE
            RtEZRequestA('This file has not bitmap header.','Ok',0,0,NIL)
        ENDIF
        IF iff THEN IfFL_CloseIFF(iff)
    ELSE
        RtEZRequestA('Can\at open file \s','Ops',0,[f_s],NIL)
    ENDIF
    IF passe_chunk
        IF vquatre_bit=FALSE
            IF (RtEZRequestA('Save New Viewmodes in \s\n','_Yes|_No',0,[f_s],[RT_UNDERSCORE,"_",TAG_DONE,0]))
                ret:=save_chunk_viewmodes(passe_chunk,offset_camg)
                IF ret=FALSE THEN RtEZRequestA('Save NewModes Failed','_Ok',0,0,[RT_UNDERSCORE,"_",TAG_DONE,0])
            ENDIF
        ELSE
            RtEZRequestA('No Save in 24 bits file !!','_Ok',0,0,[RT_UNDERSCORE,"_",TAG_DONE,0])
        ENDIF
    ENDIF
ENDPROC
PROC save_chunk_viewmodes(passe_chunk,offset_camg) /*"save_chunk_viewmodes(passe_chunk,offset_camg)"*/
/********************************************************************************
 * Para         : the chunk,the offset of the camg chunk.
 * Return       : TRUE if ok,else FALSE
 * Description  : Save the new Chunk Camg in file.
 *******************************************************************************/
  DEF len,adr,buf,handle,flen=TRUE,ccc
  DEF new_chunk,my_buf_chunk[3]:LIST
  IF (flen:=FileLength(f_s))=-1 THEN RETURN FALSE
  IF (buf:=New(flen+1))=NIL THEN RETURN FALSE
  IF (handle:=Open(f_s,1005))=NIL THEN RETURN FALSE
  len:=Read(handle,buf,flen)
  Close(handle)
  IF len<1 THEN RETURN FALSE
  new_chunk:=passe_chunk
  my_buf_chunk:=[ID_CAMG,4,new_chunk]:LONG
  adr:=buf
  ccc:=adr+offset_camg
  ^ccc:=ID_CAMG
  ccc:=adr+offset_camg+4
  ^ccc:=4
  ccc:=adr+offset_camg+8
  ^ccc:=new_chunk
  handle:=Open(f_s,1006)
  Write(handle,buf,len)
  Close(handle)
  Dispose(my_buf_chunk)
  Dispose(buf)
  RETURN TRUE
ENDPROC
PROC choosedisplayid(f_mode) /*"choosedisplayid(f_mode)"*/
/********************************************************************************
 * Para         : IDMode.
 * Return       : The new IdMode selected.
 * Description  : PopUp a ScreenModeRequester to choose the DisplayID.
 *******************************************************************************/
    DEF reqscreen:PTR TO rtscreenmoderequester
    DEF retour
    IF reqscreen:=RtAllocRequestA(RT_SCREENMODEREQ,NIL)
            RtChangeReqAttrA(reqscreen,[RTSC_DISPLAYID,f_mode,TAG_DONE,0])
            RtScreenModeRequestA(reqscreen,f_s,[RTSC_FLAGS,SCREQF_NONSTDMODES,TAG_DONE,0])
            retour:=reqscreen.displayid
            RtFreeRequest(reqscreen)
    ENDIF
    RETURN retour
ENDPROC
PROC fullcolour(nr,r,g,b) /*"fullcolour(nr,r,g,b)"*/
/********************************************************************************
 * Para         : Red,Green,Blue (0-255).
 * Return       : NONE
 * Description  : Make a SetRGB32().
 *******************************************************************************/
  MOVE.L rast,A0
  SUB.L  #40,A0
  MOVE.L nr,D0
  MOVE.L r,D1
  SWAP   D1
  LSL.L  #8,D1
  MOVE.L g,D2
  SWAP   D2
  LSL.L  #8,D2
  MOVE.L b,D3
  SWAP   D3
  LSL.L  #8,D3
  MOVE.L gfxbase,A6
  JSR    -$354(A6)
ENDPROC
prg_banner:
INCBIN 'ViewIlbm.header'
