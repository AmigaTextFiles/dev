/*"Rotation et refresh de la vue 3D."*/
/*"p_RotationBase(r_axe,r_angle) :Effectue une rotation de tous les objs.<r_axe>=Axe (3dview.m),<r_angle>=en rad."*/
PROC p_RotationBase(r_axe,r_angle)
/********************************************************************************
 * Para         : Axe of rotation (see 3Dview.i or .m),Angle (in rad).
 * Return       : NONE
 * Description  : Rotate all objects.
 *******************************************************************************/
    DEF old_x=NIL,old_y=NIL,old_z=NIL
    DEF new_x=NIL,new_y=NIL,new_z=NIL
    DEF adr_x=NIL,adr_y=NIL,adr_z=NIL
    DEF r_obj:PTR TO object3d,r_point=NIL,n_pts=NIL,b_pts=NIL
    DEF r_req=NIL
    DEF thelist:PTR TO lh,thenode:PTR TO ln
    dWriteF(['p_RotationBase() Axe:\d',' Angle :\d\n'],[r_axe,r_angle])
    r_req:=p_InitReq('Rotate Object(s) ')
    thelist:=mybase.objlist
    thenode:=thelist.head
    WHILE thenode
        IF thenode.succ<>0
            r_obj:=thenode
            r_point:=r_obj.datapts
            n_pts:=r_obj.nbrspts
            FOR b_pts:=0 TO n_pts-1
                adr_x:=r_point
                adr_y:=r_point+4
                adr_z:=r_point+8
                old_x:=Long(adr_x)
                old_y:=Long(adr_y)
                old_z:=Long(adr_z)
                SELECT r_axe
                    CASE AXE_X
                        new_x:=SpFlt(old_x)
                        new_y:=SpSub(SpMul(SpFlt(old_z),SpSin(r_angle)),SpMul(SpFlt(old_y),SpCos(r_angle)))
                        new_z:=SpAdd(SpMul(SpFlt(old_y),SpSin(r_angle)),SpMul(SpFlt(old_z),SpCos(r_angle)))
                    CASE AXE_Y
                        new_x:=SpSub(SpMul(SpFlt(old_z),SpSin(r_angle)),SpMul(SpFlt(old_x),SpCos(r_angle)))
                        new_y:=SpFlt(old_y)
                        new_z:=SpAdd(SpMul(SpFlt(old_x),SpSin(r_angle)),SpMul(SpFlt(old_z),SpCos(r_angle)))
                    CASE AXE_Z
                        new_x:=SpSub(SpMul(SpFlt(old_y),SpSin(r_angle)),SpMul(SpFlt(old_x),SpCos(r_angle)))
                        new_y:=SpAdd(SpMul(SpFlt(old_x),SpSin(r_angle)),SpMul(SpFlt(old_y),SpCos(r_angle)))
                        new_z:=SpFlt(old_z)
                ENDSELECT
                ^adr_x:=SpFix(new_x)
                ^adr_y:=SpFix(new_y)
                ^adr_z:=SpFix(new_z)
                r_point:=r_point+12
            ENDFOR
        ENDIF
        thenode:=thenode.succ
    ENDWHILE
    CloseW(r_req)
ENDPROC
/**/
/*"p_DrawBase() :redessine le base 3D."*/
PROC p_DrawBase()
/********************************************************************************
 * Para         : NONE
 * Return       : NONE
 * Description  : Parse objects (bounded,selected) and call draw_face().
 *******************************************************************************/
    DEF d_obj:PTR TO object3d
    DEF b_faces,t_faces,d_faces,curs
    DEF stop_mes:PTR TO intuimessage,stop_type,stop_infos
    DEF adr_req
    DEF mylist:PTR TO lh,mynode:PTR TO ln
    /*DEF num_obj,num_p1,num_p2,num_p3*/
    DEF list_vertices,list_datapts
    dWriteF(['p_DrawBase()'],[0])
    adr_req:=p_InitReq('Drawing ')
    SetAPen(view_window.rport,0)
    SetRast(view_window.rport,0)
    SetAPen(view_window.rport,1)
    mylist:=mybase.objlist
    mynode:=mylist.head
    WHILE mynode
        IF mynode.succ<>0
            d_obj:=mynode
            IF d_obj.selected=TRUE THEN SetAPen(view_window.rport,mybase.rgbselect) ELSE SetAPen(view_window.rport,mybase.rgbnormal)
            IF d_obj.bounded=TRUE
                list_vertices:=[d_obj.objminx,d_obj.objminy,d_obj.objminz,
                                d_obj.objminx,d_obj.objmaxy,d_obj.objminz,
                                d_obj.objmaxx,d_obj.objmaxy,d_obj.objminz,
                                d_obj.objmaxx,d_obj.objminy,d_obj.objminz,
                                d_obj.objminx,d_obj.objminy,d_obj.objmaxz,
                                d_obj.objminx,d_obj.objmaxy,d_obj.objmaxz,
                                d_obj.objmaxx,d_obj.objmaxy,d_obj.objmaxz,
                                d_obj.objmaxx,d_obj.objminy,d_obj.objmaxz]
                SetAPen(view_window.rport,2)
                t_faces:=12
                d_faces:=data_boundedbox
                list_datapts:=list_vertices
            ELSE
                t_faces:=d_obj.nbrsfcs
                d_faces:=d_obj.datafcs
                list_datapts:=d_faces
            ENDIF
            curs:=d_faces
            FOR b_faces:=0 TO t_faces-1
                p_DrawFace(d_obj,Long(curs),Long(curs+4),Long(curs+8),list_datapts)
                curs:=curs+12
                IF stop_mes:=Gt_GetIMsg(view_window.userport)
                    stop_type:=stop_mes.class
                    IF stop_type=IDCMP_RAWKEY
                        stop_infos:=stop_mes.code
                        IF stop_infos=$21 THEN JUMP fini
                    ENDIF
                ENDIF
            ENDFOR
            IF list_vertices THEN Dispose(list_vertices)
        ENDIF
        mynode:=mynode.succ
    ENDWHILE
    JUMP fini
    fini:
    WHILE stop_mes:=Gt_GetIMsg(view_window.userport) DO Gt_ReplyIMsg(stop_mes)
    CloseW(adr_req)
ENDPROC
/**/
/*"p_DrawFace(d_obj,num_p1,num_p2,num_p3) :Dessine une face."*/
PROC p_DrawFace(d_obj:PTR TO object3d,num_p1,num_p2,num_p3,list_datapts)
/********************************************************************************
 * Para         : Num object,Num vertice 1,Num vertice 2,Num vertice 3,datapts
 * Return       : NONE
 * Description  : Draw one face.
 *******************************************************************************/
    DEF x1,y1,z1,x2,y2,z2,x3,y3,z3
    DEF fx_one=NIL,fx_two=NIL,fx_three=NIL,fy_one=NIL,fy_two=NIL,fy_three=NIL
    DEF plan
    plan:=mybase.plan
    IF d_obj.bounded=FALSE
        list_datapts:=d_obj.datapts
    ENDIF
    x1:=mybase.signex*Long(list_datapts+(num_p1*12))
    y1:=mybase.signey*Long(list_datapts+(num_p1*12)+4)
    z1:=mybase.signez*Long(list_datapts+(num_p1*12)+8)
    x2:=mybase.signex*Long(list_datapts+(num_p2*12))
    y2:=mybase.signey*Long(list_datapts+(num_p2*12)+4)
    z2:=mybase.signez*Long(list_datapts+(num_p2*12)+8)
    x3:=mybase.signex*Long(list_datapts+(num_p3*12))
    y3:=mybase.signey*Long(list_datapts+(num_p3*12)+4)
    z3:=mybase.signez*Long(list_datapts+(num_p3*12)+8)
    SELECT plan
        CASE PLAN_XOY
            fx_one:=SpAdd(SpMul(SpMul(mybase.echelle,SpFlt(x1)),mybase.format),SpFlt(mybase.centrex))
            fx_two:=SpAdd(SpMul(SpMul(mybase.echelle,SpFlt(x2)),mybase.format),SpFlt(mybase.centrex))
            fx_three:=SpAdd(SpMul(SpMul(mybase.echelle,SpFlt(x3)),mybase.format),SpFlt(mybase.centrex))
            fy_one:=SpAdd(SpMul(mybase.echelle,SpFlt(y1)),SpFlt(mybase.centrey))
            fy_two:=SpAdd(SpMul(mybase.echelle,SpFlt(y2)),SpFlt(mybase.centrey))
            fy_three:=SpAdd(SpMul(mybase.echelle,SpFlt(y3)),SpFlt(mybase.centrey))
        CASE PLAN_XOZ
            fx_one:=SpAdd(SpMul(SpMul(mybase.echelle,SpFlt(x1)),mybase.format),SpFlt(mybase.centrex))
            fx_two:=SpAdd(SpMul(SpMul(mybase.echelle,SpFlt(x2)),mybase.format),SpFlt(mybase.centrex))
            fx_three:=SpAdd(SpMul(SpMul(mybase.echelle,SpFlt(x3)),mybase.format),SpFlt(mybase.centrex))
            fy_one:=SpAdd(SpMul(mybase.echelle,SpFlt(z1)),SpFlt(mybase.centrey))
            fy_two:=SpAdd(SpMul(mybase.echelle,SpFlt(z2)),SpFlt(mybase.centrey))
            fy_three:=SpAdd(SpMul(mybase.echelle,SpFlt(z3)),SpFlt(mybase.centrey))
        CASE PLAN_YOZ
            fx_one:=SpAdd(SpMul(SpMul(mybase.echelle,SpFlt(y1)),mybase.format),SpFlt(mybase.centrex))
            fx_two:=SpAdd(SpMul(SpMul(mybase.echelle,SpFlt(y2)),mybase.format),SpFlt(mybase.centrex))
            fx_three:=SpAdd(SpMul(SpMul(mybase.echelle,SpFlt(y3)),mybase.format),SpFlt(mybase.centrex))
            fy_one:=SpAdd(SpMul(mybase.echelle,SpFlt(z1)),SpFlt(mybase.centrey))
            fy_two:=SpAdd(SpMul(mybase.echelle,SpFlt(z2)),SpFlt(mybase.centrey))
            fy_three:=SpAdd(SpMul(mybase.echelle,SpFlt(z3)),SpFlt(mybase.centrey))
    ENDSELECT
    x1:=SpFix(fx_one)
    x2:=SpFix(fx_two)
    x3:=SpFix(fx_three)
    y1:=SpFix(fy_one)
    y2:=SpFix(fy_two)
    y3:=SpFix(fy_three)
    IF ((mybase.drawmode=DRAW_PTS) OR (mybase.drawmode=DRAW_PTSFCS))
        SetAPen(view_window.rport,mybase.rgbpts)
        RectFill(view_window.rport,x1-1,y1-1,x1+1,y1+1)
        RectFill(view_window.rport,x2-1,y2-1,x2+1,y2+1)
        RectFill(view_window.rport,x3-1,y3-1,x3+1,y3+1)
        /*=================================
        WritePixel(view_window.rport,x1,y1)
        WritePixel(view_window.rport,x2,y2)
        WritePixel(view_window.rport,x3,y3)
        ===================================*/
        SetAPen(view_window.rport,mybase.rgbnormal)
    ENDIF
    IF ((mybase.drawmode=DRAW_FCS) OR (mybase.drawmode=DRAW_PTSFCS))
    IF d_obj.selected=TRUE
        SetAPen(view_window.rport,mybase.rgbselect)
    ELSEIF d_obj.bounded=TRUE
        SetAPen(view_window.rport,mybase.rgbbounding)
    ELSE
        SetAPen(view_window.rport,mybase.rgbnormal)
    ENDIF

        Move(view_window.rport,x1,y1)
        Draw(view_window.rport,x2,y2)
        Move(view_window.rport,x2,y2)
        Draw(view_window.rport,x3,y3)
        Move(view_window.rport,x3,y3)
        Draw(view_window.rport,x1,y1)
    ENDIF
ENDPROC
/**/
/*"p_CentreObjs() :Centre tous les objets."*/
PROC p_CentreObjs()
/********************************************************************************
 * Para         : NONE
 * Return       : NONE
 * Description  : Center Database in 0,0,0 and Call rebuildminmax().
 *******************************************************************************/
    DEF c_obj:PTR TO object3d,cp=NIL,curs=NIL
    DEF c_point:PTR TO vertices
    DEF mylist:PTR TO lh,mynode:PTR TO ln
    dWriteF(['CentreObjs()\n'],[0])
    mylist:=mybase.objlist
    mynode:=mylist.head
    WHILE mynode
        IF mynode.succ<>0
            c_obj:=mynode
            curs:=c_obj.datapts
            dWriteF(['Obj Adr:\h ','NbrsPts:\d\n'],[c_obj,c_obj.nbrspts])
            c_obj.objcx:=c_obj.objcx-mybase.basecx
            c_obj.objcy:=c_obj.objcy-mybase.basecy
            c_obj.objcz:=c_obj.objcz-mybase.basecz
            FOR cp:=0 TO c_obj.nbrspts-1
                c_point:=curs
                c_point.x:=c_point.x-mybase.basecx
                c_point.y:=c_point.y-mybase.basecy
                c_point.z:=c_point.z-mybase.basecz
                curs:=curs+12
            ENDFOR
        ENDIF
        mynode:=mynode.succ
    ENDWHILE
    p_RebuildMinMax()
ENDPROC
/**/
/*"p_RebuildMinMax() :recalcule les lini est maxi des objets."*/
PROC p_RebuildMinMax() 
/********************************************************************************
 * Para         : NONE
 * Return       : NONE
 * Description  : rebuild the Min and Max of all objects and database.
 *******************************************************************************/
    DEF re_obj:PTR TO object3d
    DEF re_pts:PTR TO vertices
    DEF b1=NIL,curs,nx,ny,nz
    DEF o_minx,o_maxx,o_miny,o_maxy,o_minz,o_maxz,o_cx=NIL,o_cy=NIL,o_cz=NIL
    DEF mylist:PTR TO lh,mynode:PTR TO ln
    mybase.minx:=10000000
    mybase.maxx:=-10000000
    mybase.miny:=10000000
    mybase.maxy:=-10000000
    mybase.minz:=10000000
    mybase.maxz:=-10000000
    /*****************/
    mylist:=mybase.objlist
    mynode:=mylist.head
    WHILE mynode
        IF mynode.succ<>0
            re_obj:=mynode
            o_minx:=10000000
            o_maxx:=-10000000
            o_miny:=10000000
            o_maxy:=-10000000
            o_minz:=10000000
            o_maxz:=-10000000
            re_pts:=re_obj.datapts
            curs:=re_pts
            FOR b1:=0 TO re_obj.nbrspts-1
                re_pts:=curs
                nx:=re_pts.x
                ny:=re_pts.y
                nz:=re_pts.z
                IF nx>=mybase.maxx THEN mybase.maxx:=nx
                IF nx<mybase.minx THEN mybase.minx:=nx
                IF ny>=mybase.maxy THEN mybase.maxy:=ny
                IF ny<mybase.miny THEN mybase.miny:=ny
                IF nz>=mybase.maxz THEN mybase.maxz:=nz
                IF nz<mybase.minz THEN mybase.minz:=nz
                /**********************/
                IF nx>=o_maxx THEN o_maxx:=nx
                IF nx<o_minx THEN o_minx:=nx
                IF ny>=o_maxy THEN o_maxy:=ny
                IF ny<o_miny THEN o_miny:=ny
                IF nz>=o_maxz THEN o_maxz:=nz
                IF nz<o_minz THEN o_minz:=nz
                curs:=curs+12
            ENDFOR
            o_cx:=o_minx+Div((o_maxx-o_minx),2)
            o_cy:=o_miny+Div((o_maxy-o_miny),2)
            o_cz:=o_minz+Div((o_maxz-o_minz),2)
            re_obj.objcx:=o_cx
            re_obj.objcy:=o_cy
            re_obj.objcz:=o_cz
            re_obj.objminx:=o_minx
            re_obj.objmaxx:=o_maxx
            re_obj.objminy:=o_miny
            re_obj.objmaxy:=o_maxy
            re_obj.objminz:=o_minz
            re_obj.objmaxz:=o_maxz
        ENDIF
        mynode:=mynode.succ
    ENDWHILE
    mybase.basecx:=mybase.minx+Div((mybase.maxx-mybase.minx),2)
    mybase.basecy:=mybase.miny+Div((mybase.maxy-mybase.miny),2)
    mybase.basecz:=mybase.minz+Div((mybase.maxz-mybase.minz),2)
ENDPROC
/**/
/**/

