PROC initlookcloseinfowindow() HANDLE /*"initlookcloseinfowindow()"*/
/********************************************************************************
 * Para         : NONE
 * Return       : ER_NONE if ok,else the error.
 * Description  : Open InfoWindow,WaitMsg on InfoWindow,Close InfoWindow.
 *******************************************************************************/
    DEF numobj,s_obj:PTR TO object3d
    DEF sig_return,infowindow_sig,windowport:PTR TO mp
    StrCopy(texte,'',ALL)
    IF (wininfo_window:=OpenW(4,12,544,195,$278,$E,'Object(s) Info',view_screen,15,wininfo_glist))=NIL THEN Raise(ER_WINDOW)
    DrawBevelBoxA(wininfo_window.rport,255,15,279,54,[GT_VISUALINFO,wininfo_visual,TAG_DONE,0])
    DrawBevelBoxA(wininfo_window.rport,13,15,235,81,[GT_VISUALINFO,wininfo_visual,TAG_DONE,0])
    DrawBevelBoxA(wininfo_window.rport,13,98,236,94,[GT_VISUALINFO,wininfo_visual,TAG_DONE,0])
    RefreshGList(g_num,wininfo_window,NIL,-1)
    Gt_RefreshWindow(wininfo_window,NIL)
    Gt_SetGadgetAttrsA(g_listobj,wininfo_window,NIL,[GTLV_SHOWSELECTED,TRUE,GTLV_SELECTED,0,GTLV_LABELS,new_liste,0])
    windowport:=wininfo_window.userport
    infowindow_sig:=windowport.sigbit
    infowindow_sig:=Shl(1,infowindow_sig)
    numobj:=0
    s_obj:=list_obj[numobj]
    remake_gadget_info(0)
    REPEAT
        wininfo_type:=0
        IF wininfo_mes:=Gt_GetIMsg(wininfo_window.userport)
            wininfo_type:=wininfo_mes.class
            IF wininfo_type=IDCMP_MENUPICK
                wininfo_infos:=wininfo_mes.code
                SELECT wininfo_infos
                    CASE $F800
                ENDSELECT
            ELSEIF (wininfo_type=IDCMP_GADGETDOWN) OR (wininfo_type=IDCMP_GADGETUP)
                wininfo_g:=wininfo_mes.iaddress
                wininfo_infos:=wininfo_g.gadgetid
                SELECT wininfo_infos
                    CASE 14 /* LISTVIEWKIND */
                        numobj:=wininfo_mes.code
                        s_obj:=list_obj[numobj]
                        remake_gadget_info(numobj)
                    CASE 15 /* CHECKED KIND */
                        IF wininfo_mes.code=1 THEN s_obj.selected:=TRUE ELSE s_obj.selected:=FALSE
                    CASE 17 /* BOUNDED ONJ */
                        IF wininfo_mes.code=1 THEN s_obj.bounded:=TRUE ELSE s_obj.bounded:=FALSE
                ENDSELECT
            ELSEIF wininfo_type<>IDCMP_CLOSEWINDOW
                wininfo_type:=0
            ENDIF
            Gt_ReplyIMsg(wininfo_mes)
        ELSE
            /*sig_return:=Wait(infowindow_sig OR viewwindow_sig)*/
            sig_return:=Wait(infowindow_sig)
        ENDIF
    UNTIL wininfo_type=IDCMP_CLOSEWINDOW
    Raise(ER_NONE)
EXCEPT
    WHILE wininfo_mes:=Gt_GetIMsg(wininfo_window.userport) DO Gt_ReplyIMsg(wininfo_mes)
    IF wininfo_window THEN CloseW(wininfo_window)
ENDPROC
PROC remake_gadget_info(num_obj) /*"remake_gadget_info()"*/
/********************************************************************************
 * Para         : Num of the object.
 * Return       : NONE
 * Description  : Update all Gadgets of the InfoWindow.
 *******************************************************************************/
    DEF inf_obj:PTR TO object3d
    DEF str_num[20]:STRING
    DEF str_nbrspts[20]:STRING
    DEF str_nbrsfaces[20]:STRING
    DEF str_datapts[20]:STRING
    DEF str_datafaces[20]:STRING
    DEF str_objcx[20]:STRING
    DEF str_objcy[20]:STRING
    DEF str_objcz[20]:STRING
    DEF str_objminx[20]:STRING
    DEF str_objmaxx[20]:STRING
    DEF str_objminy[20]:STRING
    DEF str_objmaxy[20]:STRING
    DEF str_objminz[20]:STRING
    DEF str_objmaxz[20]:STRING
    DEF str_objtype[20]:STRING
    inf_obj:=list_obj[num_obj]
    StringF(str_num,'\l\d[9]',inf_obj.num)
    StringF(str_nbrspts,'\l\d[9]',inf_obj.nbrspts)
    StringF(str_nbrsfaces,'\l\d[9]',inf_obj.nbrsfaces)
    StringF(str_datapts,'\l\h[8]',inf_obj.datapts)
    StringF(str_datafaces,'\l\h[8]',inf_obj.datafaces)
    StringF(str_objcx,'\l\d[9]',inf_obj.objcx)
    StringF(str_objcy,'\l\d[9]',inf_obj.objcy)
    StringF(str_objcz,'\l\d[9]',inf_obj.objcz)
    StringF(str_objminx,'\l\d[9]',inf_obj.objminx)
    StringF(str_objmaxx,'\l\d[9]',inf_obj.objmaxx)
    StringF(str_objminy,'\l\d[9]',inf_obj.objminy)
    StringF(str_objmaxy,'\l\d[9]',inf_obj.objmaxy)
    StringF(str_objminz,'\l\d[9]',inf_obj.objminz)
    StringF(str_objmaxz,'\l\d[9]',inf_obj.objmaxz)
    StringF(str_objtype,'\s',data_objtype[inf_obj.typeobj])
    Gt_SetGadgetAttrsA(g_num,wininfo_window,NIL,[GTTX_BORDER,TRUE,GTTX_TEXT,str_num,TAG_DONE,0])
    Gt_SetGadgetAttrsA(g_nbrspts,wininfo_window,NIL,[GTTX_BORDER,TRUE,GTTX_TEXT,str_nbrspts,TAG_DONE,0])
    Gt_SetGadgetAttrsA(g_nbrsfaces,wininfo_window,NIL,[GTTX_BORDER,TRUE,GTTX_TEXT,str_nbrsfaces,TAG_DONE,0])
    Gt_SetGadgetAttrsA(g_datapts,wininfo_window,NIL,[GTTX_BORDER,TRUE,GTTX_TEXT,str_datapts,TAG_DONE,0])
    Gt_SetGadgetAttrsA(g_datafaces,wininfo_window,NIL,[GTTX_BORDER,TRUE,GTTX_TEXT,str_datafaces,TAG_DONE,0])
    Gt_SetGadgetAttrsA(g_objcx,wininfo_window,NIL,[GTTX_BORDER,TRUE,GTTX_TEXT,str_objcx,TAG_DONE,0])
    Gt_SetGadgetAttrsA(g_objcy,wininfo_window,NIL,[GTTX_BORDER,TRUE,GTTX_TEXT,str_objcy,TAG_DONE,0])
    Gt_SetGadgetAttrsA(g_objcz,wininfo_window,NIL,[GTTX_BORDER,TRUE,GTTX_TEXT,str_objcz,TAG_DONE,0])
    Gt_SetGadgetAttrsA(g_objminx,wininfo_window,NIL,[GTTX_BORDER,TRUE,GTTX_TEXT,str_objminx,TAG_DONE,0])
    Gt_SetGadgetAttrsA(g_objmaxx,wininfo_window,NIL,[GTTX_BORDER,TRUE,GTTX_TEXT,str_objmaxx,TAG_DONE,0])
    Gt_SetGadgetAttrsA(g_objminy,wininfo_window,NIL,[GTTX_BORDER,TRUE,GTTX_TEXT,str_objminy,TAG_DONE,0])
    Gt_SetGadgetAttrsA(g_objmaxy,wininfo_window,NIL,[GTTX_BORDER,TRUE,GTTX_TEXT,str_objmaxy,TAG_DONE,0])
    Gt_SetGadgetAttrsA(g_objminz,wininfo_window,NIL,[GTTX_BORDER,TRUE,GTTX_TEXT,str_objminz,TAG_DONE,0])
    Gt_SetGadgetAttrsA(g_objmaxz,wininfo_window,NIL,[GTTX_BORDER,TRUE,GTTX_TEXT,str_objmaxz,TAG_DONE,0])
    Gt_SetGadgetAttrsA(g_objselected,wininfo_window,NIL,[GTCB_CHECKED,inf_obj.selected,TAG_DONE,0])
    Gt_SetGadgetAttrsA(g_objbounded,wininfo_window,NIL,[GTCB_CHECKED,inf_obj.bounded,TAG_DONE,0])
    Gt_SetGadgetAttrsA(g_objtype,wininfo_window,NIL,[GTTX_BORDER,TRUE,GTTX_TEXT,str_objtype,TAG_DONE,0])
ENDPROC

