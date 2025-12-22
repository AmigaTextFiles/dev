/********************************************************************************
 * << EUTILS HEADER >>
 ********************************************************************************
 ED           "EDG"
 EC           "EC"
 PREPRO       "EPP"
 SOURCE       "Jpeg&Ilbm24.e"
 EPPDEST      "JPEG&Ilbm24_Epp.e"
 EXEC         "Jpeg&Ilbm24"
 ISOURCE      " "
 HSOURCE      " "
 ERROREC      " "
 ERROREPP     " "
 VERSION      "0"
 REVISION     "1"
 NAMEPRG      "Jpeg&Ilbm24"
 NAMEAUTHOR   "NasGûl"
 ********************************************************************************
 * HISTORY :
 *******************************************************************************/


OPT OSVERSION=37

CONST JPEGTOILBM24=0,
      ILBM24TOJPEG=1,
      ILBMTOILBM24=2

ENUM ER_NONE,ER_INTUITIONLIB,ER_GADTOOLSLIB,ER_GFXLIB,ER_OPALLIB,ER_REQTOOLSLIB,
     ER_WB,ER_VISUAL,ER_CONTEXT,ER_MENU,ER_GADGET,ER_WINDOW,
     ER_OPENFILE,ER_NOTILBM,ER_BADIFF,ER_NOTIFF,ER_OUTOFMEM,ER_SAVEFILE,
     ER_VIRTUALOPALSCREEN,ER_PRGSIG

MODULE 'intuition/intuition'
MODULE 'gadtools','libraries/gadtools'
MODULE 'intuition/gadgetclass','intuition/screens','graphics/text'
MODULE 'exec/lists','exec/nodes','utility/tagitem','exec/ports'
MODULE 'opal','libraries/opal'
MODULE 'reqtools','libraries/reqtools'

/* DEFINITION GENERALES */
DEF conv_screen:PTR TO screen,
    conv_visual=NIL,
    conv_window:PTR TO window,
    conv_glist=NIL,
    conv_type,conv_infos

/** GADGETLABELS **/

DEF g_convert,g_inout,g_opalchunk,g_fastformat,g_jpegcorrupt
DEF tattr,opt_opalchunk,opt_fastformat,opt_convert,opt_quality,opt_patout:PTR TO LONG
DEF fichier_s[256]:STRING,fichier_d[256]:STRING
DEF opal_screen:PTR TO os
DEF prg_sig=-1,window_sig,all_sig
PROC main() HANDLE /*"main()"*/
/********************************************************************************
 * Para         : NONE
 * Return       : NONE
 * Description  : Main Proc.
 *******************************************************************************/
    DEF test_main
    VOID {prg_banner}        /* For INCBIN */
    tattr:=['topaz.font',8,0,0]:textattr
    opt_quality:=75
    opt_patout:=['Ilbm24','Jpeg','Ilbm24']
    IF (prg_sig:=AllocSignal(prg_sig))=NIL THEN Raise(ER_PRGSIG)
    IF (test_main:=open_lib())<>ER_NONE THEN Raise(test_main)
    IF (test_main:=open_interface())<>ER_NONE THEN Raise(test_main)
    all_sig:=Shl(1,prg_sig) OR window_sig
    SetWindowTitles(conv_window,'Jpeg&Ilbm24','Jpeg&Ilbm24 v0.0a © 1994 NasGûl')
    REPEAT
        wait4message()
        IF conv_type=IDCMP_CLOSEWINDOW
            IF (RtEZRequestA('          >>  Jpeg&Ilbm24  <<            \n'+
                            '                                          \n'+
                            ' GadToolsBox  v37.273 © Jaba Development. \n'+
                            ' Gui2E        v0.0a   © NasGûl.           \n'+
                            ' Opal.Library v2.2    © Opal Technology.  \n'+
                            ' AmigaE       v2.1b   © W. Van Oortmersen.\n'+
                            '                                          \n'+
                            '          >> © 1994 NasGûl <<             \n'+
                            '         Voulez-vous Quittez ?            ','_Oui|_Non',0,0,[RT_WINDOW,conv_window,RT_LOCKWINDOW,TRUE,RT_UNDERSCORE,"_",TAG_DONE,0])) THEN conv_type:=IDCMP_CLOSEWINDOW ELSE conv_type:=0
            ENDIF
    UNTIL conv_type=IDCMP_CLOSEWINDOW
    Raise(ER_NONE)
EXCEPT
    close_interface()
    close_lib()
    SELECT exception
        CASE ER_INTUITIONLIB; WriteF('Intuition.library ?\n')
        CASE ER_GADTOOLSLIB;  WriteF('GadTools.library ?\n')
        CASE ER_GFXLIB;       WriteF('Graphics.library ?\n')
        CASE ER_OPALLIB;      WriteF('Opal.library ?\n')
        CASE ER_WB;           WriteF('Lock WB ?\n')
        CASE ER_VISUAL;       WriteF('Erreur Visual.\n')
        CASE ER_CONTEXT;      WriteF('Erreur Context.\n')
        CASE ER_MENU;         WriteF('Erreur Menu.\n')
        CASE ER_GADGET;       WriteF('Erreur Gadget.\n')
        CASE ER_WINDOW;       WriteF('Erreur Window.\n')
        CASE ER_PRGSIG;       WriteF('Erreur d\aallocation du signal.\n')
        DEFAULT;              NOP
    ENDSELECT
ENDPROC
PROC open_lib() HANDLE /*"open_lib()"*/
/********************************************************************************
 * Para         : NONE
 * Return       : ER_NONE if ok,else the error
 * Description  : Open Libraries.
 *******************************************************************************/
    IF (intuitionbase:=OpenLibrary('intuition.library',37))=NIL THEN Raise(ER_INTUITIONLIB)
    IF (gadtoolsbase:=OpenLibrary('gadtools.library',37))=NIL THEN Raise(ER_GADTOOLSLIB)
    IF (gfxbase:=OpenLibrary('graphics.library',37))=NIL THEN Raise(ER_GFXLIB)
    IF (opalbase:=OpenLibrary('opal.library',2))=NIL THEN Raise(ER_OPALLIB)
    IF (reqtoolsbase:=OpenLibrary('reqtools.library',38))=NIL THEN Raise(ER_OPALLIB)
    Raise(ER_NONE)
EXCEPT
    RETURN exception
ENDPROC
PROC close_lib()  /*"close_lib()"*/
/********************************************************************************
 * Para         : NONE
 * Return       : NONE
 * Description  : Close Libraries.
 *******************************************************************************/
    IF reqtoolsbase THEN CloseLibrary(reqtoolsbase)
    IF opalbase THEN CloseLibrary(opalbase)
    IF gfxbase THEN CloseLibrary(gfxbase)
    IF gadtoolsbase THEN CloseLibrary(gadtoolsbase)
    IF intuitionbase THEN CloseLibrary(intuitionbase)
ENDPROC
PROC open_interface() HANDLE /*"open_interface()"*/
/********************************************************************************
 * Para         : NONE
 * Return       : ER_NONE if of ,else the error.
 * Description  : Init and open the window.
 *******************************************************************************/
    DEF windowport:PTR TO mp
    IF (conv_screen:=LockPubScreen('Workbench'))=NIL THEN Raise(ER_WB)
    IF (conv_visual:=GetVisualInfoA(conv_screen,NIL))=NIL THEN Raise(ER_VISUAL)
    IF (conv_glist:=CreateContext({conv_glist}))=NIL THEN Raise(ER_CONTEXT)
    IF (g_convert:=CreateGadgetA(BUTTON_KIND,conv_glist,[4,12,169,14,'Convert',tattr,0,16,conv_visual,0]:newgadget,[GA_RELVERIFY,TRUE,GA_DISABLED,FALSE,GT_UNDERSCORE,"_",TAG_DONE,0]))=NIL THEN Raise(ER_GADGET)
    IF (g_inout:=CreateGadgetA(CYCLE_KIND,g_convert,[4,26,169,14,'',tattr,1,0,conv_visual,0]:newgadget,[GA_RELVERIFY,TRUE,GTCY_LABELS,['Jpeg->Ilbm24','Ilbm24->Jpeg','Ilbm->Ilbm24',0],GT_UNDERSCORE,"_",TAG_DONE,0]))=NIL THEN Raise(ER_GADGET)
    IF (g_opalchunk:=CreateGadgetA(CHECKBOX_KIND,g_inout,[4,40,26,11,'Opal Chunk',tattr,2,2,conv_visual,0]:newgadget,[GA_RELVERIFY,TRUE,GTCB_CHECKED,FALSE,GT_UNDERSCORE,"_", TAG_DONE,0]))=NIL THEN Raise(ER_GADGET)
    IF (g_fastformat:=CreateGadgetA(CHECKBOX_KIND,g_opalchunk,[4,51,26,11,'Fast Format',tattr,3,2,conv_visual,0]:newgadget,[GA_RELVERIFY,TRUE,GTCB_CHECKED,FALSE,GT_UNDERSCORE,"_", TAG_DONE,0]))=NIL THEN Raise(ER_GADGET)
    IF (g_jpegcorrupt:=CreateGadgetA(INTEGER_KIND,g_fastformat,[4,62,40,13,'Perte Jpeg',tattr,4,2,conv_visual,0]:newgadget,[GA_RELVERIFY,TRUE,GTIN_NUMBER,opt_quality,GTIN_MAXCHARS,3,GT_UNDERSCORE,"_",TAG_DONE,0]))=NIL THEN Raise(ER_GADGET)
    IF (conv_window:=OpenW(4,12,177,77,$240,$E,'Jpeg&Ilbm24',NIL,1,conv_glist))=NIL THEN Raise(ER_WINDOW)
    Gt_RefreshWindow(conv_window,NIL)
    Gt_SetGadgetAttrsA(g_jpegcorrupt,conv_window,NIL,[GA_DISABLED,TRUE,TAG_DONE,0])
    windowport:=conv_window.userport
    window_sig:=Shl(1,windowport.sigbit)
    Raise(ER_NONE)
EXCEPT
    RETURN exception
ENDPROC
PROC close_interface() /*"close_interface()"*/
/********************************************************************************
 * Para         : NONE
 * Return       : NONE
 * Description  : Free all and close the window.
 *******************************************************************************/
    IF prg_sig THEN FreeSignal(prg_sig)
    IF conv_visual THEN FreeVisualInfo(conv_visual)
    IF conv_window THEN CloseWindow(conv_window)
    IF conv_glist THEN FreeGadgets(conv_glist)
    IF conv_screen THEN UnlockPubScreen(conv_screen,NIL)
ENDPROC
PROC wait4message() /*"wait4message()"*/
/********************************************************************************
 * Para         : NONE
 * Return       : NONE
 * Description  : Wait Message on window.
 *******************************************************************************/
    DEF conv_mes:PTR TO intuimessage
    DEF conv_g:PTR TO gadget
    DEF conv_gstr:PTR TO stringinfo
    DEF num,return_sig=NIL
    REPEAT
        conv_type:=0
        IF conv_mes:=Gt_GetIMsg(conv_window.userport)
            conv_type:=conv_mes.class
            IF conv_type=IDCMP_MENUPICK
                conv_infos:=conv_mes.code
                SELECT conv_infos
                    CASE $F800
                ENDSELECT
            ELSEIF (conv_type=IDCMP_GADGETDOWN) OR (conv_type=IDCMP_GADGETUP)
                conv_g:=conv_mes.iaddress
                conv_infos:=conv_g.gadgetid
                SELECT conv_infos
                    num:=conv_mes.code
                    CASE 0 /* CONVERT */
                        do_conversion()
                    CASE 1 /* CYCLE KIND */
                        SELECT num
                            CASE 0  /* JPEG->ILBM24 */
                                Gt_SetGadgetAttrsA(g_jpegcorrupt,conv_window,NIL,[GA_DISABLED,TRUE,TAG_DONE,0])
                                Gt_SetGadgetAttrsA(g_opalchunk,conv_window,NIL,[GA_DISABLED,FALSE,TAG_DONE,0])
                                Gt_SetGadgetAttrsA(g_fastformat,conv_window,NIL,[GA_DISABLED,FALSE,TAG_DONE,0])
                                opt_convert:=JPEGTOILBM24
                            CASE 1  /* ILBM24->JPEG */
                                Gt_SetGadgetAttrsA(g_jpegcorrupt,conv_window,NIL,[GA_DISABLED,FALSE,TAG_DONE,0])
                                Gt_SetGadgetAttrsA(g_opalchunk,conv_window,NIL,[GA_DISABLED,TRUE,TAG_DONE,0])
                                Gt_SetGadgetAttrsA(g_fastformat,conv_window,NIL,[GA_DISABLED,TRUE,TAG_DONE,0])
                                opt_convert:=ILBM24TOJPEG
                            CASE 2  /* ILBM->ILBM24 */
                                Gt_SetGadgetAttrsA(g_jpegcorrupt,conv_window,NIL,[GA_DISABLED,TRUE,TAG_DONE,0])
                                Gt_SetGadgetAttrsA(g_opalchunk,conv_window,NIL,[GA_DISABLED,FALSE,TAG_DONE,0])
                                Gt_SetGadgetAttrsA(g_fastformat,conv_window,NIL,[GA_DISABLED,FALSE,TAG_DONE,0])
                                opt_convert:=ILBMTOILBM24
                        ENDSELECT
                    CASE 2 /* OPAL CHUNK */
                        opt_opalchunk:=num
                    CASE 3 /* FASTFORMAT */
                        opt_fastformat:=num
                    CASE 4 /* QUALITY JPEG */
                        conv_gstr:=conv_g.specialinfo
                        opt_quality:=Val(conv_gstr.buffer,NIL)
                        IF (opt_quality<0) OR (opt_quality>100)
                            opt_quality:=75
                            RtEZRequestA('Cette valeur doit être comprise\nentre 0 et 100.','_Ok',0,0,[RT_WINDOW,conv_window,RT_LOCKWINDOW,TRUE,RT_UNDERSCORE,"_",TAG_DONE,0])
                            Gt_SetGadgetAttrsA(g_jpegcorrupt,conv_window,NIL,[GTIN_NUMBER,opt_quality,GTIN_MAXCHARS,3,TAG_DONE,0])
                        ENDIF
                ENDSELECT
            ELSEIF conv_type<>IDCMP_CLOSEWINDOW
                conv_type:=0
            ENDIF
            Gt_ReplyIMsg(conv_mes)
        ELSE
            return_sig:=Wait(all_sig)
        ENDIF
    UNTIL conv_type
ENDPROC
PROC do_conversion() /*"do_conversion()"*/
/********************************************************************************
 * Para         : NONE
 * Return       : NONE
 * Description  : Popup a MultiFilerequester to choose the sources file.
 *                PopUp a DirFileRequester to choose the Dir out.
 *                Call convert().
 *******************************************************************************/
    DEF buffer[108]:STRING,add_liste
    DEF liste:PTR TO rtfilelist
    DEF reqfile:PTR TO rtfilerequester
    DEF dossier_source[256]:STRING,dossier_destin[256]:STRING
    DEF fichier_source[256]:STRING,fichier_destin[256]:STRING
    DEF piv1[256]:STRING,c=1,pos
    DEF max_fich
    DEF source_f[256]:ARRAY OF LONG
    DEF destin_f[256]:ARRAY OF LONG
    DEF titre_req[256]:STRING
    IF reqfile:=RtAllocRequestA(RT_FILEREQ,NIL)
        buffer[0]:=0
        add_liste:=RtFileRequestA(reqfile,buffer,'Jpeg&Ilbm24 Source(s).',[RT_WINDOW,conv_window,RT_LOCKWINDOW,TRUE,RTFI_FLAGS,
                                                                      FREQF_MULTISELECT,
                                                                      FREQF_PATGAD,TRUE,
                                                                      TAG_DONE])
        liste:=add_liste
        IF buffer[0]<>0
            WHILE liste
                IF liste
                    AddPart(reqfile.dir,'',ALL)
                    StringF(dossier_source,'\s',reqfile.dir)
                    IF pos:=InStr(liste.name,'.',0)
                        MidStr(piv1,liste.name,0,pos)
                    ELSE
                        StrCopy(piv1,liste.name,ALL)
                    ENDIF
                    StringF(fichier_source,'\s\s',reqfile.dir,liste.name)
                    StringF(fichier_destin,'\s.\s',piv1,opt_patout[opt_convert])
                    source_f[c]:=String(EstrLen(fichier_source))
                    StrCopy(source_f[c],fichier_source,ALL)
                    destin_f[c]:=String(EstrLen(fichier_destin))
                    StrCopy(destin_f[c],fichier_destin,ALL)
                    c:=c+1
                ENDIF
                liste:=liste.next
            ENDWHILE
            max_fich:=c-1
        ELSE
            RtFreeFileList(add_liste)
            RtFreeRequest(reqfile)
            JUMP fini
        ENDIF
        RtFreeFileList(add_liste)
        RtFreeRequest(reqfile)
    ELSE
    ENDIF
    IF reqfile:=RtAllocRequestA(RT_FILEREQ,NIL)
        add_liste:=RtFileRequestA(reqfile,buffer,'Jpeg&Ilbm24 Destination.',[RT_WINDOW,conv_window,RT_LOCKWINDOW,TRUE,RTFI_FLAGS,
                                                                      FREQF_NOFILES,
                                                                      TAG_DONE,0])

                    AddPart(reqfile.dir,'',ALL)
                    StringF(dossier_destin,'\s',reqfile.dir)
                    RtFreeRequest(reqfile)
    ELSE
    ENDIF
    Gt_SetGadgetAttrsA(g_convert,conv_window,NIL,[GA_DISABLED,TRUE,TAG_DONE,0])
    FOR c:=1 TO max_fich
        StringF(fichier_s,'\s',source_f[c])
        StringF(piv1,'\d/\d',c,max_fich)
        StrCopy(titre_req,piv1,ALL)
        SetWindowTitles(conv_window,titre_req,fichier_s)
        StringF(fichier_d,'\s\s',dossier_destin,destin_f[c])
        convert()
        IF source_f[c] THEN Dispose(source_f[c])
        IF destin_f[c] THEN Dispose(destin_f[c])
        DisplayBeep(0)
    ENDFOR
    fini:
    Gt_SetGadgetAttrsA(g_convert,conv_window,NIL,[GA_DISABLED,FALSE,TAG_DONE,0])
    SetWindowTitles(conv_window,'Jpeg&Ilbm24','Jpeg&Ilbm24 v0.0a © 1994 NasGûl')
ENDPROC
PROC convert() HANDLE /*"convert()"*/
/********************************************************************************
 * Para         : NONE
 * Return       : ER_NONE if ok,else the error.
 * Description  : Open a VirtualOpalScreen and make convertion.
 *******************************************************************************/
    DEF err,flags=NIL,error
    opal_screen:=NIL
    err:=LoadIFF24(opal_screen,fichier_s,VIRTUALSCREEN24+FORCE24)
    IF err<OL_ERR_MAXERR
        IF err=OL_ERR_OPENFILE THEN Raise(ER_OPENFILE)
        IF err=OL_ERR_NOTILBM THEN Raise(ER_NOTILBM)
        IF err=OL_ERR_BADIFF THEN Raise(ER_BADIFF)
        IF err=OL_ERR_NOTIFF THEN Raise(ER_NOTIFF)
        IF err=OL_ERR_OUTOFMEM THEN Raise(ER_OUTOFMEM)
    ELSE
        error:=FALSE
        opal_screen:=err
        IF opt_convert=ILBM24TOJPEG
            IF (SaveJPEG24(opal_screen,fichier_d,NIL,opt_quality)) THEN error:=TRUE
        ELSEIF (opt_convert=JPEGTOILBM24) OR (opt_convert=ILBMTOILBM24)
            IF Not(opt_opalchunk) THEN flags:=flags+NOTHUMBNAIL
            IF opt_fastformat THEN flags:=flags+OVFASTFORMAT
            IF (SaveIFF24(opal_screen,fichier_d,NIL,flags)) THEN error:=TRUE
        ENDIF
        IF error THEN Raise(ER_SAVEFILE)
    ENDIF
    Raise(ER_NONE)
EXCEPT
    IF opal_screen THEN FreeScreen24(opal_screen)
    SELECT exception
        CASE ER_SAVEFILE;                RtEZRequestA('Erreur durant la sauvegarde de \s','_Ok',0,[fichier_d],[RT_WINDOW,conv_window,RT_LOCKWINDOW,TRUE,RT_UNDERSCORE,"_",TAG_DONE,0])
        CASE ER_VIRTUALOPALSCREEN;       RtEZRequestA('Allocation de l\aécran Virtuel Opal impossible.','_Ok',0,0,[RT_WINDOW,conv_window,RT_LOCKWINDOW,TRUE,RT_UNDERSCORE,"_",TAG_DONE,0])
        CASE ER_OPENFILE;                RtEZRequestA('Impossible d\aouvrir le fichier source.','_Ok',0,0,[RT_WINDOW,conv_window,RT_LOCKWINDOW,TRUE,RT_UNDERSCORE,"_",TAG_DONE,0])
        CASE ER_NOTILBM;                 RtEZRequestA('le fichier source n\aest pas un fichier ILBM.','_Ok',0,0,[RT_WINDOW,conv_window,RT_LOCKWINDOW,TRUE,RT_UNDERSCORE,"_",TAG_DONE,0])
        CASE ER_NOTIFF;                  RtEZRequestA('le fichier source n\aest pas un fichier IFF.','_Ok',0,0,[RT_WINDOW,conv_window,RT_LOCKWINDOW,TRUE,RT_UNDERSCORE,"_",TAG_DONE,0])
        CASE ER_BADIFF;                  RtEZRequestA('le fichier source est incomplet.','_Ok',0,0,[RT_WINDOW,conv_window,RT_LOCKWINDOW,TRUE,RT_UNDERSCORE,"_",TAG_DONE,0])
        CASE ER_OUTOFMEM;                RtEZRequestA('Pas assez de mémoire.','_Ok',0,0,[RT_WINDOW,conv_window,RT_LOCKWINDOW,TRUE,RT_UNDERSCORE,"_",TAG_DONE,0])
    ENDSELECT
    RETURN exception
ENDPROC
prg_banner:
INCBIN 'Jpeg&Ilbm24.header'

