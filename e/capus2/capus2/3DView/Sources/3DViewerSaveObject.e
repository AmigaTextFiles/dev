/*"p_SaveGeoFile(mode)"*/
PROC p_SaveGeoFile(mode)
/********************************************************************************
 * Para         : NONE
 * Return       : TRUE if ok,else FALSE (Cancel).
 * Description  : Save selected objects in Geo (Amiga) format.
 *******************************************************************************/
    DEF req:PTR TO rtfilerequester,req_string[108]:STRING
    DEF save_dir[256]:STRING
    DEF b_pts,b_faces
    DEF n_pts,n_faces
    DEF mobj:PTR TO object3d
    DEF p_pts,p_faces
    DEF s_handle,fichier_out[256]:STRING,w_save
    DEF mylist:PTR TO lh,mynode:PTR TO ln,saveit=FALSE
    IF req:=RtAllocRequestA(RT_FILEREQ,NIL)
        /*RtChangeReqAttrA(req,[RTFI_FLAGS,FREQF_NOFILES])*/
        IF RtFileRequestA(req,req_string,title_req,[RTFI_FLAGS,FREQF_NOFILES,RT_WINDOW,view_window,RT_LOCKWINDOW,TRUE,RTFI_OKTEXT,get_3DView_string(GAD_SAVEGEO),TAG_DONE])
            StrCopy(save_dir,req.dir,ALL)
            AddPart(save_dir,'',256)
            RtFreeRequest(req)
        ELSE
            RETURN FALSE
        ENDIF
    ELSE
        RETURN FALSE
    ENDIF
    mylist:=mybase.objlist
    mynode:=mylist.head
    WHILE mynode
        IF mynode.succ<>0
            mobj:=mynode
            IF (mode=MENU_SAVE_OBJALL) 
                saveit:=TRUE
            ELSEIF ((mobj.selected=TRUE) AND (mode=MENU_SAVE_OBJSELECT)) 
                saveit:=TRUE
            ELSEIF ((mobj.selected=FALSE) AND (mode=MENU_SAVE_OBJDESELECT)) 
                saveit:=TRUE
            ENDIF
            IF saveit=TRUE
                StringF(fichier_out,'\s\s.geo',save_dir,mynode.name)
                w_save:=p_InitReq(fichier_out)
                s_handle:=Open(fichier_out,1006)
                Write(s_handle,'3DG1\n',5)
                n_pts:=mobj.nbrspts
                StringF(fichier_out,'\d\n',n_pts)
                Write(s_handle,fichier_out,StrLen(fichier_out))
                p_pts:=mobj.datapts
                FOR b_pts:=0 TO n_pts-1
                    StringF(fichier_out,'\d \d \d\n',Long(p_pts),Long(p_pts+4),Long(p_pts+8))
                    Write(s_handle,fichier_out,StrLen(fichier_out))
                    p_pts:=p_pts+12
                ENDFOR
                n_faces:=mobj.nbrsfcs
                p_faces:=mobj.datafcs
                FOR b_faces:=0 TO n_faces-1
                    StringF(fichier_out,'3 \d \d \d 141\n',Long(p_faces),Long(p_faces+4),Long(p_faces+8))
                    Write(s_handle,fichier_out,StrLen(fichier_out))
                    p_faces:=p_faces+12
                ENDFOR
                IF s_handle THEN Close(s_handle)
                IF w_save THEN CloseW(w_save)
                saveit:=FALSE
            ENDIF
        ENDIF
        mynode:=mynode.succ
    ENDWHILE
ENDPROC
/**/
/*"p_SaveDxfFile(mode)"*/
PROC p_SaveDxfFile(mode)
/********************************************************************************
 * Para         : NONE
 * Return       : TRUE if ok,else FALSE (Cancel).
 * Description  : Save selected objects in Dxf (PC) format.
 *******************************************************************************/
    DEF req:PTR TO rtfilerequester,req_string[108]:STRING
    DEF save_dir[256]:STRING
    DEF b_faces
    DEF n_faces
    DEF mobj:PTR TO object3d
    DEF p_pts,p_faces
    DEF s_handle=NIL,fichier_out[256]:STRING,w_save=NIL
    /*DEF x1,y1,z1,x2,y2,z2,x3,y3,z3*/
    DEF str_x1[20]:STRING,str_y1[20]:STRING,str_z1[20]:STRING
    DEF str_x2[20]:STRING,str_y2[20]:STRING,str_z2[20]:STRING
    DEF str_x3[20]:STRING,str_y3[20]:STRING,str_z3[20]:STRING
    DEF mylist:PTR TO lh,mynode:PTR TO ln,saveit=FALSE
    IF req:=RtAllocRequestA(RT_FILEREQ,NIL)
        /*RtChangeReqAttrA(req,[RTFI_FLAGS,FREQF_NOFILES])*/
        IF RtFileRequestA(req,req_string,title_req,[RTFI_FLAGS,FREQF_NOFILES,RT_WINDOW,view_window,RT_LOCKWINDOW,TRUE,RTFI_OKTEXT,get_3DView_string(GAD_SAVEDXF),TAG_DONE])
            StrCopy(save_dir,req.dir,ALL)
            AddPart(save_dir,'',256)
            RtFreeRequest(req)
        ELSE
            RETURN FALSE
        ENDIF
    ELSE
        RETURN FALSE
    ENDIF
    mylist:=mybase.objlist
    mynode:=mylist.head
    WHILE mynode
        IF mynode.succ<>0
            mobj:=mynode
            IF (mode=MENU_SAVE_OBJALL) 
                saveit:=TRUE
            ELSEIF ((mobj.selected=TRUE) AND (mode=MENU_SAVE_OBJSELECT)) 
                saveit:=TRUE
            ELSEIF ((mobj.selected=FALSE) AND (mode=MENU_SAVE_OBJDESELECT)) 
                saveit:=TRUE
            ENDIF
            IF saveit=TRUE
                StringF(fichier_out,'\s\s.dxf',save_dir,mynode.name)
                s_handle:=Open(fichier_out,1006)
                w_save:=p_InitReq(fichier_out)
                Write(s_handle,'0\nSECTION\n2\nENTITIES\n0\n',23)
                p_pts:=mobj.datapts
                n_faces:=mobj.nbrsfcs
                p_faces:=mobj.datafcs
                FOR b_faces:=0 TO n_faces-1
                    Write(s_handle,'3DFACE\n',7)
                    Write(s_handle,'8\n',2)
                    Write(s_handle,mynode.name,StrLen(mynode.name))
                    Write(s_handle,'\n',1)
                    StringF(str_x1,'\d\n',Long(p_pts+(Long(p_faces)*12)))
                    StringF(str_y1,'\d\n',Long(p_pts+(Long(p_faces)*12)+4))
                    StringF(str_z1,'\d\n',Long(p_pts+(Long(p_faces)*12)+8))
                    StringF(str_x2,'\d\n',Long(p_pts+(Long(p_faces+4)*12)))
                    StringF(str_y2,'\d\n',Long(p_pts+(Long(p_faces+4)*12)+4))
                    StringF(str_z2,'\d\n',Long(p_pts+(Long(p_faces+4)*12)+8))
                    StringF(str_x3,'\d\n',Long(p_pts+(Long(p_faces+8)*12)))
                    StringF(str_y3,'\d\n',Long(p_pts+(Long(p_faces+8)*12)+4))
                    StringF(str_z3,'\d\n',Long(p_pts+(Long(p_faces+8)*12)+8))
                    Write(s_handle,'10\n',3)
                    Write(s_handle,str_x1,StrLen(str_x1))
                    Write(s_handle,'20\n',3)
                    Write(s_handle,str_y1,StrLen(str_y1))
                    Write(s_handle,'30\n',3)
                    Write(s_handle,str_z1,StrLen(str_z1))
                    /**/
                    Write(s_handle,'11\n',3)
                    Write(s_handle,str_x2,StrLen(str_x2))
                    Write(s_handle,'21\n',3)
                    Write(s_handle,str_y2,StrLen(str_y2))
                    Write(s_handle,'31\n',3)
                    Write(s_handle,str_z2,StrLen(str_z2))
                    /**/
                    Write(s_handle,'12\n',3)
                    Write(s_handle,str_x3,StrLen(str_x3))
                    Write(s_handle,'22\n',3)
                    Write(s_handle,str_y3,StrLen(str_y3))
                    Write(s_handle,'32\n',3)
                    Write(s_handle,str_z3,StrLen(str_z3))
                    /**/
                    Write(s_handle,'13\n',3)
                    Write(s_handle,str_x3,StrLen(str_x3))
                    Write(s_handle,'23\n',3)
                    Write(s_handle,str_y3,StrLen(str_y3))
                    Write(s_handle,'33\n',3)
                    Write(s_handle,str_z3,StrLen(str_z3))
                    Write(s_handle,'0\n',2)
                    p_faces:=p_faces+12
                ENDFOR
                Write(s_handle,'ENDSEC\n0\nEOF\n',13)
                IF s_handle THEN Close(s_handle)
                IF w_save THEN CloseW(w_save)
            ENDIF
            saveit:=FALSE
        ENDIF
        mynode:=mynode.succ
    ENDWHILE
    RETURN TRUE
ENDPROC
/**/
/*"p_SaveRayFile(mode)"*/
PROC p_SaveRayFile(mode)
/********************************************************************************
 * Para         : NONE
 * Return       : TRUE if ok,else FALSE (Cancel).
 * Description  : Save selected objects in Ray (amiga) format.
 *******************************************************************************/
    DEF req:PTR TO rtfilerequester,req_string[108]:STRING
    DEF save_dir[256]:STRING
    DEF b_faces
    DEF n_faces
    DEF mobj:PTR TO object3d
    DEF p_pts,p_faces
    DEF s_handle,fichier_out[256]:STRING,w_save
    DEF str_1[20]:STRING
    DEF str_2[20]:STRING
    DEF str_3[20]:STRING
    DEF mylist:PTR TO lh,mynode:PTR TO ln,saveit
    IF req:=RtAllocRequestA(RT_FILEREQ,NIL)
        IF RtFileRequestA(req,req_string,title_req,[RTFI_FLAGS,FREQF_NOFILES,RT_WINDOW,view_window,RT_LOCKWINDOW,TRUE,RTFI_OKTEXT,get_3DView_string(GAD_SAVERAY),TAG_DONE])
            StrCopy(save_dir,req.dir,ALL)
            AddPart(save_dir,'',256)
            RtFreeRequest(req)
        ELSE
            RETURN FALSE
        ENDIF
    ELSE
        RETURN FALSE
    ENDIF
    mylist:=mybase.objlist
    mynode:=mylist.head
    WHILE mynode
        IF mynode.succ<>0
            mobj:=mynode
            IF (mode=MENU_SAVE_OBJALL) 
                saveit:=TRUE
            ELSEIF ((mobj.selected=TRUE) AND (mode=MENU_SAVE_OBJSELECT)) 
                saveit:=TRUE
            ELSEIF ((mobj.selected=FALSE) AND (mode=MENU_SAVE_OBJDESELECT)) 
                saveit:=TRUE
            ENDIF
            IF saveit=TRUE
                StringF(fichier_out,'\s\s.ray',save_dir,mynode.name)
                w_save:=p_InitReq(fichier_out)
                s_handle:=Open(fichier_out,1006)
                p_pts:=mobj.datapts
                n_faces:=mobj.nbrsfcs
                p_faces:=mobj.datafcs
                FOR b_faces:=0 TO n_faces-1
                    StringF(str_1,'\d \d \d\n',Long(p_pts+(Long(p_faces)*12)),Long(p_pts+(Long(p_faces)*12)+4),Long(p_pts+(Long(p_faces)*12)+8))
                    StringF(str_2,'\d \d \d\n',Long(p_pts+(Long(p_faces+4)*12)),Long(p_pts+(Long(p_faces+4)*12)+4),Long(p_pts+(Long(p_faces+4)*12)+8))
                    StringF(str_3,'\d \d \d\n',Long(p_pts+(Long(p_faces+8)*12)),Long(p_pts+(Long(p_faces+8)*12)+4),Long(p_pts+(Long(p_faces+8)*12)+8))
                    Write(s_handle,'triangle\n',9)
                    Write(s_handle,str_1,StrLen(str_1))
                    Write(s_handle,str_2,StrLen(str_2))
                    Write(s_handle,str_3,StrLen(str_3))
                    /**********************************/
                    p_faces:=p_faces+12
                ENDFOR
                IF s_handle THEN Close(s_handle)
                IF w_save THEN CloseW(w_save)
            ENDIF
        ENDIF
        mynode:=mynode.succ
    ENDWHILE
    RETURN TRUE
ENDPROC
/**/
/*"p_SaveBinFile(mode)"*/
PROC p_SaveBinFile(mode)
/********************************************************************************
 * Para         : NONE
 * Return       : TRUE if ok,else FALSE (Cancel).
 * Description  : Save selected objects in Geo (Amiga) format.
 *******************************************************************************/
    DEF req:PTR TO rtfilerequester,req_string[108]:STRING
    DEF save_dir[256]:STRING
    DEF b_pts,b_faces
    DEF n_pts,n_faces
    DEF mobj:PTR TO object3d
    DEF p_pts,p_faces
    DEF s_handle,fichier_out[256]:STRING,w_save
    DEF mylist:PTR TO lh,mynode:PTR TO ln,saveit=FALSE
    DEF facteur3d,r,strfct[20]:STRING
    DEF fx,fy,fz
    IF req:=RtAllocRequestA(RT_FILEREQ,NIL)
        /*RtChangeReqAttrA(req,[RTFI_FLAGS,FREQF_NOFILES])*/
        IF RtFileRequestA(req,req_string,title_req,[RTFI_FLAGS,FREQF_NOFILES,RT_WINDOW,view_window,RT_LOCKWINDOW,TRUE,RTFI_OKTEXT,get_3DView_string(GAD_SAVEBIN),TAG_DONE])
            StrCopy(save_dir,req.dir,ALL)
            AddPart(save_dir,'',256)
            RtFreeRequest(req)
        ELSE
            RETURN FALSE
        ENDIF
    ELSE
        RETURN FALSE
    ENDIF
    StrCopy(strfct,'1.0',ALL)
    r:=RtGetStringA(strfct,8,get_3DView_string(GAD_FCT3DSAVEBIN),NIL,[RT_WINDOW,view_window,RT_LOCKWINDOW,TRUE,RT_UNDERSCORE,"_",0])
    IF r
        facteur3d:=p_StringToFloat(strfct)
    ELSE
        facteur3d:=1.0
    ENDIF
    mylist:=mybase.objlist
    mynode:=mylist.head
    WHILE mynode
        IF mynode.succ<>0
            mobj:=mynode
            IF (mode=MENU_SAVE_OBJALL) 
                saveit:=TRUE
            ELSEIF ((mobj.selected=TRUE) AND (mode=MENU_SAVE_OBJSELECT)) 
                saveit:=TRUE
            ELSEIF ((mobj.selected=FALSE) AND (mode=MENU_SAVE_OBJDESELECT)) 
                saveit:=TRUE
            ENDIF
            IF saveit=TRUE
                StringF(fichier_out,'\s\s_pts.bin',save_dir,mynode.name)
                w_save:=p_InitReq(fichier_out)
                s_handle:=Open(fichier_out,1006)
                n_pts:=mobj.nbrspts
                Write(s_handle,[n_pts]:INT,2)
                StringF(fichier_out,'\d\n',n_pts)
                p_pts:=mobj.datapts
                FOR b_pts:=0 TO n_pts-1
                    fx:=SpFix(SpMul(SpFlt(Long(p_pts)),facteur3d))
                    fy:=SpFix(SpMul(SpFlt(Long(p_pts+4)),facteur3d))
                    fz:=SpFix(SpMul(SpFlt(Long(p_pts+8)),facteur3d))
                    Write(s_handle,[fx,fy,fz,0]:INT,8)
                    p_pts:=p_pts+12
                ENDFOR
                IF s_handle THEN Close(s_handle)
                IF w_save THEN CloseW(w_save)
                StringF(fichier_out,'\s\s_fcs.bin',save_dir,mynode.name)
                s_handle:=Open(fichier_out,1006)
                w_save:=p_InitReq(fichier_out)
                n_faces:=mobj.nbrsfcs
                p_faces:=mobj.datafcs
                Write(s_handle,[n_faces]:INT,2)
                FOR b_faces:=0 TO n_faces-1
                    Write(s_handle,[3,5,Long(p_faces)*4,Long(p_faces+4)*4,Long(p_faces+8)*4,Long(p_faces)*4,0,0,0,0,0]:INT,22)
                    p_faces:=p_faces+12
                ENDFOR
                IF s_handle THEN Close(s_handle)
                IF w_save THEN CloseW(w_save)
                saveit:=FALSE
            ENDIF
        ENDIF
        mynode:=mynode.succ
    ENDWHILE
ENDPROC
/**/

