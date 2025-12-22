PROC rotationbase(r_axe,r_angle) /*"rotationbase(r_axe,r_angle)"*/
/********************************************************************************
 * Para         : Axe of rotation (see 3Dview.i or .m),Angle (in rad).
 * Return       : NONE
 * Description  : Rotate all objects.
 *******************************************************************************/
    DEF old_x=NIL,old_y=NIL,old_z=NIL
    DEF new_x=NIL,new_y=NIL,new_z=NIL
    DEF adr_x=NIL,adr_y=NIL,adr_z=NIL
    DEF b,r_obj:PTR TO object3d,r_point=NIL,n_pts=NIL,b_pts=NIL
    DEF r_req=NIL
    r_req:=init_req('Rotate Object(s) ')
    FOR b:=0 TO ListLen(list_obj)-1
        r_obj:=list_obj[b]
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
    ENDFOR
    CloseW(r_req)
ENDPROC
PROC draw_base() /*"draw_base()"*/
/********************************************************************************
 * Para         : NONE
 * Return       : NONE
 * Description  : Parse objects (bounded,selected) and call draw_face().
 *******************************************************************************/
    DEF d_obj:PTR TO object3d,b_obj
    DEF b_faces,t_faces,d_faces,curs
    DEF stop_mes:PTR TO intuimessage,stop_type,stop_infos
    DEF adr_req
    /*DEF num_obj,num_p1,num_p2,num_p3*/
    DEF list_vertices,list_datapts
    adr_req:=init_req('Drawing ')
    SetAPen(view_window.rport,0)
    SetRast(view_window.rport,0)
    SetAPen(view_window.rport,1)
    FOR b_obj:=0 TO ListLen(list_obj)-1
        d_obj:=list_obj[b_obj]
        IF d_obj.selected=TRUE THEN SetAPen(view_window.rport,3) ELSE SetAPen(view_window.rport,1)
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
            t_faces:=d_obj.nbrsfaces
            d_faces:=d_obj.datafaces
            list_datapts:=d_faces
        ENDIF
        curs:=d_faces
        FOR b_faces:=0 TO t_faces-1
            draw_face(b_obj,Long(curs),Long(curs+4),Long(curs+8),list_datapts)
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
    ENDFOR
    JUMP fini
    fini:
    WHILE stop_mes:=Gt_GetIMsg(view_window.userport) DO Gt_ReplyIMsg(stop_mes)
    CloseW(adr_req)
ENDPROC
PROC draw_face(num_obj,num_p1,num_p2,num_p3,list_datapts) /*"draw_face(num_obj,num_p1,num_p2,num_p3)"*/
/********************************************************************************
 * Para         : Num object,Num vertice 1,Num vertice 2,Num vertice 3,datapts
 * Return       : NONE
 * Description  : Draw one face.
 *******************************************************************************/
    DEF d_obj:PTR TO object3d
    DEF x1,y1,z1,x2,y2,z2,x3,y3,z3
    DEF fx_one=NIL,fx_two=NIL,fx_three=NIL,fy_one=NIL,fy_two=NIL,fy_three=NIL
    d_obj:=list_obj[num_obj]
    IF d_obj.bounded=FALSE
        list_datapts:=d_obj.datapts
    ENDIF
    x1:=signe_x*Long(list_datapts+(num_p1*12))
    y1:=signe_y*Long(list_datapts+(num_p1*12)+4)
    z1:=signe_z*Long(list_datapts+(num_p1*12)+8)
    x2:=signe_x*Long(list_datapts+(num_p2*12))
    y2:=signe_y*Long(list_datapts+(num_p2*12)+4)
    z2:=signe_z*Long(list_datapts+(num_p2*12)+8)
    x3:=signe_x*Long(list_datapts+(num_p3*12))
    y3:=signe_y*Long(list_datapts+(num_p3*12)+4)
    z3:=signe_z*Long(list_datapts+(num_p3*12)+8)
    SELECT plan
        CASE PLAN_XOY
            fx_one:=SpAdd(SpMul(SpMul(echelle,SpFlt(x1)),format),SpFlt(centre_x))
            fx_two:=SpAdd(SpMul(SpMul(echelle,SpFlt(x2)),format),SpFlt(centre_x))
            fx_three:=SpAdd(SpMul(SpMul(echelle,SpFlt(x3)),format),SpFlt(centre_x))
            fy_one:=SpAdd(SpMul(echelle,SpFlt(y1)),SpFlt(centre_y))
            fy_two:=SpAdd(SpMul(echelle,SpFlt(y2)),SpFlt(centre_y))
            fy_three:=SpAdd(SpMul(echelle,SpFlt(y3)),SpFlt(centre_y))
        CASE PLAN_XOZ
            fx_one:=SpAdd(SpMul(SpMul(echelle,SpFlt(x1)),format),SpFlt(centre_x))
            fx_two:=SpAdd(SpMul(SpMul(echelle,SpFlt(x2)),format),SpFlt(centre_x))
            fx_three:=SpAdd(SpMul(SpMul(echelle,SpFlt(x3)),format),SpFlt(centre_x))
            fy_one:=SpAdd(SpMul(echelle,SpFlt(z1)),SpFlt(centre_y))
            fy_two:=SpAdd(SpMul(echelle,SpFlt(z2)),SpFlt(centre_y))
            fy_three:=SpAdd(SpMul(echelle,SpFlt(z3)),SpFlt(centre_y))
        CASE PLAN_YOZ
            fx_one:=SpAdd(SpMul(SpMul(echelle,SpFlt(y1)),format),SpFlt(centre_x))
            fx_two:=SpAdd(SpMul(SpMul(echelle,SpFlt(y2)),format),SpFlt(centre_x))
            fx_three:=SpAdd(SpMul(SpMul(echelle,SpFlt(y3)),format),SpFlt(centre_x))
            fy_one:=SpAdd(SpMul(echelle,SpFlt(z1)),SpFlt(centre_y))
            fy_two:=SpAdd(SpMul(echelle,SpFlt(z2)),SpFlt(centre_y))
            fy_three:=SpAdd(SpMul(echelle,SpFlt(z3)),SpFlt(centre_y))
    ENDSELECT
    x1:=SpFix(fx_one)
    x2:=SpFix(fx_two)
    x3:=SpFix(fx_three)
    y1:=SpFix(fy_one)
    y2:=SpFix(fy_two)
    y3:=SpFix(fy_three)
    Move(view_window.rport,x1,y1)
    Draw(view_window.rport,x2,y2)
    Move(view_window.rport,x2,y2)
    Draw(view_window.rport,x3,y3)
    Move(view_window.rport,x3,y3)
    Draw(view_window.rport,x1,y1)
ENDPROC
PROC cleanupbase() /*"cleanupbase()"*/
/********************************************************************************
 * Para         : NONE
 * Return       : NONE
 * Description  : CleanUp database (Free all objects).
 *                Call cleanlist()   (Free list).
 *                Initialise the var list_obj.
 *******************************************************************************/
    DEF b,myobj:PTR TO object3d
    FOR b:=0 TO ListLen(list_obj)-1
        myobj:=list_obj[b]
        IF myobj.datapts THEN Dispose(myobj.datapts)
        IF myobj.datafaces THEN Dispose(myobj.datafaces)
        IF myobj THEN Dispose(myobj)
    ENDFOR
    my_database.nbrsobjs:=0
    my_database.totalpts:=0
    my_database.totalfaces:=0
    my_database.firstobj:=list_obj[0]
    cleanlist(new_liste)
    SetList(list_obj,0)
ENDPROC
PROC getadrnode(bobj) /*"getadrnode(n)"*/
/********************************************************************************
 * Para         : Num of object.
 * Return       : Address of the object if ok,else NIL.
 * Description  : Found the address of a object.
 *******************************************************************************/
    DEF g_list:PTR TO lh
    DEF g_node:PTR TO ln
    DEF count=0
    g_list:=new_liste
    g_node:=g_list.head
    WHILE g_node
        IF count=bobj THEN RETURN g_node
        INC count
        g_node:=g_node.succ
    ENDWHILE
    RETURN NIL
ENDPROC
PROC centre_objs() /*"centre_objs()"*/
/********************************************************************************
 * Para         : NONE
 * Return       : NONE
 * Description  : Center Database in 0,0,0 and Call rebuildminmax().
 *******************************************************************************/
    DEF c_obj:PTR TO object3d,b=NIL,cp=NIL,curs=NIL
    DEF c_point:PTR TO vertices
    FOR b:=0 TO ListLen(list_obj)-1
        c_obj:=list_obj[b]
        curs:=c_obj.datapts
        c_obj.objcx:=c_obj.objcx-base_cx
        c_obj.objcy:=c_obj.objcy-base_cy
        c_obj.objcz:=c_obj.objcz-base_cz
        FOR cp:=0 TO c_obj.nbrspts-1
            c_point:=curs
            c_point.x:=c_point.x-base_cx
            c_point.y:=c_point.y-base_cy
            c_point.z:=c_point.z-base_cz
            curs:=curs+12
        ENDFOR
    ENDFOR
    rebuildminmax()
ENDPROC
PROC rebuildminmax() /*"rebuildminmax()"*/
/********************************************************************************
 * Para         : NONE
 * Return       : NONE
 * Description  : rebuild the Min and Max of all objects and database.
 *******************************************************************************/
    DEF re_obj:PTR TO object3d
    DEF re_pts:PTR TO vertices
    DEF b=NIL,b1=NIL,curs,nx,ny,nz
    DEF o_minx,o_maxx,o_miny,o_maxy,o_minz,o_maxz,o_cx=NIL,o_cy=NIL,o_cz=NIL
    minx:=10000000
    maxx:=-10000000
    miny:=10000000
    maxy:=-10000000
    minz:=10000000
    maxz:=-10000000
    /*****************/
    FOR b:=0 TO ListLen(list_obj)-1
        o_minx:=10000000
        o_maxx:=-10000000
        o_miny:=10000000
        o_maxy:=-10000000
        o_minz:=10000000
        o_maxz:=-10000000
        re_obj:=list_obj[b]
        re_pts:=re_obj.datapts
        curs:=re_pts
        FOR b1:=0 TO re_obj.nbrspts-1
            re_pts:=curs
            nx:=re_pts.x
            ny:=re_pts.y
            nz:=re_pts.z
            IF nx>=maxx THEN maxx:=nx
            IF nx<minx THEN minx:=nx
            IF ny>=maxy THEN maxy:=ny
            IF ny<miny THEN miny:=ny
            IF nz>=maxz THEN maxz:=nz
            IF nz<minz THEN minz:=nz
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
        re_obj.num:=b
        re_obj.objcx:=o_cx
        re_obj.objcy:=o_cy
        re_obj.objcz:=o_cz
        re_obj.objminx:=o_minx
        re_obj.objmaxx:=o_maxx
        re_obj.objminy:=o_miny
        re_obj.objmaxy:=o_maxy
        re_obj.objminz:=o_minz
        re_obj.objmaxz:=o_maxz
    ENDFOR
    base_cx:=minx+Div((maxx-minx),2)
    base_cy:=miny+Div((maxy-miny),2)
    base_cz:=minz+Div((maxz-minz),2)
ENDPROC
PROC cleanlist(adr_list) /*"cleanlist(adr_list)"*/
/********************************************************************************
 * Para         : Address of a lh structure.
 * Return       : Address of the cleanup lh structure.
 * Description  : Remove all nodes (ln) from the list (lh).
 *******************************************************************************/
    DEF c_node:PTR TO ln
    DEF ll:PTR TO lh
    ll:=adr_list
    c_node:=new_liste.head
    IF new_liste
        c_node:=new_liste.head
        WHILE c_node
            IF c_node.succ
                IF c_node.succ=0
                    RemTail(new_liste)
                ELSEIF c_node.pred=0
                    RemHead(new_liste)
                ELSEIF (c_node.succ<>0) AND (c_node.pred<>0)
                    Remove(c_node)
                ENDIF
            ENDIF
            Dispose(c_node.name)
            c_node:=c_node.succ
        ENDWHILE
    ENDIF
    RETURN new_liste
ENDPROC

