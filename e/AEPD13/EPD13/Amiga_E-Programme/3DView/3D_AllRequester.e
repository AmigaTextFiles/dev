/***********************************/
/* INFO PRG                        */
/***********************************/
DEF prg_version
DEF prg_revision
DEF prg_name[20]:STRING
DEF prg_author[20]:STRING
DEF title_req[80]:STRING
PROC do_ReadHeader(adr_header) /*"do_ReadHeader(adr_header)"*/
/********************************************************************************
 * Para         : Address of a prgheader struct (MHeader.m).
 * Return       : NONE
 * Description  : Initialise the Info Prg var.
 *******************************************************************************/
    DEF my_header:PTR TO prgheader
    my_header:=adr_header
    prg_version:=my_header.version
    prg_revision:=my_header.revision
    StringF(prg_name,'\s',my_header.nomprg)
    StringF(prg_author,'\s',my_header.auteur)
    StringF(title_req,'\s \d.\d © \s',prg_name,prg_version,prg_revision,prg_author)
ENDPROC
PROC init_req(titre) /*"init_req(titre)"*/
/********************************************************************************
 * Para         : Title (STRING).
 * Return       : address of the window.
 * Description  : Open a little Window (center on 3DviewScreen).
 *******************************************************************************/
    DEF w,wx,wy,p_itext:PTR TO intuitext,long
    p_itext:=New(SIZEOF intuitext)
    p_itext.itextfont:=tattr
    p_itext.itext:=String(EstrLen(titre))
    StrCopy(p_itext.itext,titre,ALL)
    p_itext.nexttext:=NIL
    long:=IntuiTextLength(p_itext)
    wx:=Div(view_screen.width,2)-Div(long,2)
    wy:=Div(view_screen.height,2)-5
    w:=OpenW(wx,wy,long,10,$100,$0,titre,view_screen,15,NIL)
    Dispose(p_itext)
    RETURN w
ENDPROC
PROC init_reqwb(titre) /*"init_reqwb(titre)"*/
/********************************************************************************
 * Para         : Title (STRING).
 * Return       : Address of the window.
 * Description  : Open a little window (center on WBScreen).
 *******************************************************************************/
    DEF w,wx,wy,scr:PTR TO screen,p_itext:PTR TO intuitext
    DEF long
    p_itext:=New(SIZEOF intuitext)
    p_itext.itextfont:=tattr
    p_itext.itext:=String(EstrLen(titre))
    StrCopy(p_itext.itext,titre,ALL)
    p_itext.nexttext:=NIL
    long:=IntuiTextLength(p_itext)
    scr:=LockPubScreen('Workbench')
    wx:=Div(scr.width,2)-Div(long,2)
    wy:=Div(scr.height,2)-5
    w:=OpenW(wx,wy,long,10,$100,$0,titre,0,1,NIL)
    UnlockPubScreen(scr,NIL)
    Dispose(p_itext)
    RETURN w
ENDPROC
PROC my_filerequester() /*"my_filerequester()"*/
/********************************************************************************
 * Para         : NONE
 * Return       : TRUE if ok,else FALSE.
 * Description  : PopUp a FileRequester to choose a new source file.
 *******************************************************************************/
    DEF req:PTR TO rtfilerequester,piv_string[256]:STRING,req_string[108]:STRING
    DEF retour=TRUE
    IF req:=RtAllocRequestA(RT_FILEREQ,NIL)
        RtChangeReqAttrA(req,[RTFI_DIR,default_dir])
        IF RtFileRequestA(req,req_string,title_req,[RT_WINDOW,view_window,RT_LOCKWINDOW,TRUE,RTFI_OKTEXT,'Load',TAG_DONE,0])
            StrCopy(default_dir,req.dir,ALL)
            AddPart(req.dir,'',256)
            StringF(piv_string,'\s\s',req.dir,req_string)
            StrCopy(fichier_source,piv_string,ALL)
            RtFreeRequest(req)
        ELSE
            retour:=FALSE
        ENDIF
    ELSE
        retour:=FALSE
    ENDIF
    RETURN retour
ENDPROC
PROC loadmultiobject() /*"loadmultiobject()"*/
/********************************************************************************
 * Para         : NONE
 * Return       : NONE
 * Description  : PopUp a MuliSelectRequester and call readfile().
 *******************************************************************************/
    DEF buffer[108]:STRING,add_liste
    DEF fich[100]:STRING
    DEF liste:PTR TO rtfilelist
    DEF reqfile:PTR TO rtfilerequester
    IF reqfile:=RtAllocRequestA(RT_FILEREQ,0)
        buffer[0]:=0
        RtChangeReqAttrA(reqfile,[RTFI_DIR,default_dir])
        add_liste:=RtFileRequestA(reqfile,buffer,title_req,[RT_WINDOW,view_window,RT_LOCKWINDOW,TRUE,RTFI_FLAGS,
                                                               FREQF_MULTISELECT,
                                                               RTFI_OKTEXT,'_Load',RTFI_HEIGHT,256,
                                                               RT_UNDERSCORE,"_",
                                                               TAG_DONE])
        StrCopy(default_dir,reqfile.dir,ALL)
        liste:=add_liste
        IF buffer[0]<>0
            WHILE liste
                AddPart(reqfile.dir,'',100)
                StrCopy(fich,reqfile.dir,ALL)
                StrAdd(fich,liste.name,ALL)
                StrCopy(fichier_source,fich,ALL)
                readfile()
                liste:=liste.next
            ENDWHILE
            RtFreeFileList(add_liste)
        ENDIF
        RtFreeRequest(reqfile)
    ELSE
        RtEZRequestA('Impossible d\aouvrir le sélécteur de fichiers.','Ok',0,0,[RT_WINDOW,view_window,RT_LOCKWINDOW,TRUE,RTEZ_REQTITLE,
                                                   '3Dview',
                                                   TAG_DONE]:tagitem)
    ENDIF
ENDPROC


