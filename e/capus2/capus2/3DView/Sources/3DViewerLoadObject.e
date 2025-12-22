/*"ReadObject3D :Routines de chargement des objets 3D."*/
/*"p_ReadFile(fichier) :Lit un fichier 3D <fichier> STRING et renvois sur la bonne routine."*/
PROC p_ReadFile(fichier) HANDLE 
/********************************************************************************
 * Para         : NONE
 * Return       : OK_FICHIER if ok,else the error.
 * Description  : Read source file and call the good Proc.
 *******************************************************************************/
    DEF len,adr,buf,handle,flen=TRUE,chunk,retour_read=NIL
    DEF w_l
    IF (flen:=FileLength(fichier))=-1 THEN Raise(ER_NOFICHIER)
    IF (buf:=New(flen+1))=NIL THEN Raise(ER_MEM)
    IF (handle:=Open(fichier,1005))=NIL THEN Raise(ER_OPEN)
    len:=Read(handle,buf,flen)
    Close(handle)
    IF len<1 THEN Raise(ER_NOFICHIER)
    adr:=buf
    chunk:=Int(adr)
    IF chunk=ID_3D2
        Dispose(buf)
        w_l:=p_InitReq(get_3DView_string(WREQ_3D2))
        retour_read:=p_Read3D2File(fichier)
        CloseW(w_l)
        Raise(retour_read)
    ELSEIF chunk=ID_3D3D
        Dispose(buf)
        w_l:=p_InitReq(get_3DView_string(WREQ_3D))
        retour_read:=p_Read3DFile(fichier)
        CloseW(w_l)
        Raise(retour_read)
    ENDIF
    chunk:=Long(adr)
    IF (chunk=ID_VR3D) OR (chunk=ID_VE3D)
        Dispose(buf)
        w_l:=p_InitReq(get_3DView_string(WREQ_VERTEX))
        retour_read:=p_ReadVertexFile(chunk,fichier)
        CloseW(w_l)
        Raise(retour_read)
    ELSEIF chunk=ID_3DPRO
        Dispose(buf)
        w_l:=p_InitReq(get_3DView_string(WREQ_3DPRO))
        retour_read:=p_Read3DProFile(fichier)
        CloseW(w_l)
        Raise(retour_read)
    ENDIF
    chunk:=Long(adr+8)
    SELECT chunk
        CASE ID_TDDD
            Dispose(buf)
            w_l:=p_InitReq(get_3DView_string(WREQ_IMAGINE))
            retour_read:=p_ReadImagineFile(fichier)
            CloseW(w_l)
            Raise(retour_read)
        CASE ID_SC3D
            Dispose(buf)
            w_l:=p_InitReq(get_3DView_string(WREQ_SCULPT))
            retour_read:=p_ReadSculptFile(fichier)
            CloseW(w_l)
            Raise(retour_read)
        CASE ID_3DDD
            Dispose(buf)
            w_l:=p_InitReq(get_3DView_string(WREQ_VERTEX2))
            retour_read:=p_ReadVertex2File(fichier)
            CloseW(w_l)
            Raise(retour_read)
        /*
        CASE ID_LWOB
            Dispose(buf)
            IF view_window THEN w_req:=init_req('Load LightWave Object(s) ') ELSE w_req:=init_reqwb('Load LightWave Object(s) ')
            retour_read:=readlightwavefile()
            CloseW(w_req)
            RETURN retour_read
        */
        DEFAULT
            Dispose(buf)
            RtEZRequestA(get_3DView_string(REQ_INCONNU),
                         get_3DView_string(GAD_OUI),0,0,[RTEZ_REQTITLE,fichier,RT_WINDOW,view_window,RT_LOCKWINDOW,TRUE,0])
            Raise(ER_INCONNU)
    ENDSELECT
    Raise(OK_FICHIER)
EXCEPT
    RETURN exception
ENDPROC
/**/
/*"p_Read3DFile(source) :Lit un fichier au format Cyber v1.0. <source>=Fichier a charger."*/
PROC p_Read3DFile(source) HANDLE
/********************************************************************************
 * Para         : NONE
 * Return       : OK_FICHIER if ok,else the error.
 * Description  : Read a CyberStudio v1.0 (Atari) file.
 *******************************************************************************/
  DEF len,a,adr,buf,handle,flen=TRUE,i
  DEF nbrs_obj,obj_name[80]:STRING,x,y,z
  DEF myobj:PTR TO object3d,piv_pts
  /*****************************************************/
  flen:=FileLength(source)
  buf:=New(flen+1)
  handle:=Open(source,1005)
  len:=Read(handle,buf,flen)
  Close(handle)
  adr:=buf
  nbrs_obj:=Int(adr+2)
  mybase.nbrsobjs:=mybase.nbrsobjs+nbrs_obj
  adr:=buf+34
  FOR i:=0 TO nbrs_obj-1
      StringF(obj_name,'\s',adr)                                 /*==== name of object         ====*/
      myobj:=New(SIZEOF object3d)                                /*==== Allocate new structure ====*/
      myobj.typeobj:=TYPE_OLDCYBER                               /*==== Type object            ====*/
      myobj.selected:=FALSE                                      /*==== Object selected        ====*/
      myobj.bounded:=FALSE                                       /*==== Object bounded         ====*/
      myobj.nbrspts:=Int(adr+9)                                  /*==== Number of vertices     ====*/
      mybase.totalpts:=mybase.totalpts+myobj.nbrspts             /*==== Update database (pts)  ====*/
      adr:=adr+11                                                /*==== Jump to datapts        ====*/
      myobj.datapts:=New(myobj.nbrspts*12)                       /*==== Allocate Mem for pts   ====*/
      piv_pts:=myobj.datapts                                     /*==== Pointer to ObjDataPts  ====*/
      FOR a:=0 TO myobj.nbrspts-1
          x:=Long(adr)                                           /*==== Read x ====*/
          y:=Long(adr+(myobj.nbrspts*4))                         /*==== Read y ====*/
          z:=Long(adr+(myobj.nbrspts*8))                         /*==== Read z ====*/
          ^piv_pts:=Mul(SpFix(x),100)                            /*==== Stock x ====*/
          piv_pts:=piv_pts+4
          ^piv_pts:=Mul(SpFix(y),100)                            /*==== Stock y ====*/
          piv_pts:=piv_pts+4
          ^piv_pts:=Mul(SpFix(z),100)                            /*==== Stock z ====*/
          /*===========================
          ^piv_pts:=x                            /*==== Stock x ====*/
          piv_pts:=piv_pts+4
          ^piv_pts:=y                            /*==== Stock y ====*/
          piv_pts:=piv_pts+4
          ^piv_pts:=z                            /*==== Stock z ====*/
          ==============================*/
          piv_pts:=piv_pts+4
          adr:=adr+4
      ENDFOR
      adr:=adr+(myobj.nbrspts*8)                                 /*==== Jump to faces          ====*/
      myobj.nbrsfcs:=Int(adr)                                    /*==== Number of faces        ====*/
      mybase.totalfcs:=mybase.totalfcs+myobj.nbrsfcs             /*==== Update DataBase (fcs)  ====*/
      myobj.datafcs:=New(myobj.nbrsfcs*12)                       /*==== Allocate Mem for faces ====*/
      piv_pts:=myobj.datafcs                                     /*==== Pointer to datafaces   ====*/
      adr:=adr+2                                                 /*==== Jump to datafcs        ====*/
      FOR a:=0 TO myobj.nbrsfcs-1
          x:=Int(adr)                                            /*==== Number 1 (vertive) ====*/
          y:=Int(adr+2)                                          /*==== Number 2 (vertive) ====*/
          z:=Int(adr+4)                                          /*==== Number 3 (vertice) ====*/
          ^piv_pts:=x                                            /*==== Stock vertice 1 ====*/
          piv_pts:=piv_pts+4
          ^piv_pts:=y                                            /*==== Stock vertice 2 ====*/
          piv_pts:=piv_pts+4
          ^piv_pts:=z                                            /*==== Stock vertice 3 ====*/
          piv_pts:=piv_pts+4
          adr:=adr+8
      ENDFOR
      p_AjouteNode(mybase.objlist,obj_name,myobj)
  ENDFOR
  IF buf THEN Dispose(buf)
  Raise(OK_FICHIER)
EXCEPT
  RETURN exception
ENDPROC
/**/
/*"p_Read3D2File(source) :Lit un fichier au format Cyber v2.0. <source>=Fichier a charger."*/
PROC p_Read3D2File(source) HANDLE
/********************************************************************************
 * Para         : NONE
 * Return       : OK_FICHIER if ok,else the error.
 * Description  : Read a CyberStudio v2.0 (Atari) file.
 *******************************************************************************/
    DEF len,a,adr,buf,handle,flen=TRUE,i
    DEF nbrs_obj,obj_name[80]:STRING,x,y,z
    DEF myobj:PTR TO object3d,piv_pts,p1,p2,p3
    /*****************************************************/
    flen:=FileLength(source)
    buf:=New(flen+1)
    handle:=Open(source,1005)
    len:=Read(handle,buf,flen)
    Close(handle)
    adr:=buf
    nbrs_obj:=Int(adr+2)
    mybase.nbrsobjs:=mybase.nbrsobjs+nbrs_obj
    adr:=buf+256
    FOR i:=0 TO nbrs_obj-1
        StringF(obj_name,'\s',adr)
        myobj:=New(SIZEOF object3d)                                /*==== Allocate new structure ====*/
        myobj.typeobj:=TYPE_NEWCYBER                               /*==== Type object            ====*/
        myobj.selected:=FALSE                                      /*==== Object selected        ====*/
        myobj.bounded:=FALSE                                       /*==== Object bounded         ====*/
        myobj.nbrspts:=Int(adr+9)                                  /*==== Number of vertices     ====*/
        mybase.totalpts:=mybase.totalpts+myobj.nbrspts             /*==== Update database (pts)  ====*/
        adr:=adr+11                                                /*==== Jump to datapts        ====*/
        myobj.datapts:=New(myobj.nbrspts*12)                       /*==== Allocate Mem for pts   ====*/
        piv_pts:=myobj.datapts                                     /*==== Pointer to ObjDataPts  ====*/
        FOR a:=0 TO myobj.nbrspts-1
            x:=Int(adr)                                            /*==== Read x ====*/
            y:=Int(adr+2)                                          /*==== Read y ====*/
            z:=Int(adr+4)                                          /*==== Read z ====*/
            IF x>32767 THEN x:=x-65535
            IF y>32767 THEN y:=y-65535
            IF z>32767 THEN z:=z-65535
            adr:=adr+6
            ^piv_pts:=x                                            /*==== Stock x ====*/
            piv_pts:=piv_pts+4
            ^piv_pts:=y                                            /*==== Stock y ====*/
            piv_pts:=piv_pts+4
            ^piv_pts:=z                                            /*==== Stock z ====*/
            piv_pts:=piv_pts+4
        ENDFOR
        myobj.nbrsfcs:=Int(adr)                                    /*==== Number of faces       ====*/
        mybase.totalfcs:=mybase.totalfcs+myobj.nbrsfcs             /*==== Update database (fcs) ====*/
        myobj.datafcs:=New(myobj.nbrsfcs*12)                       /*==== Allocate Mem for fcs  ====*/
        piv_pts:=myobj.datafcs                                     /*==== Pointer to ObjDataFcs ====*/
        adr:=adr+2                                                 /*==== Jump to datafcs       ====*/
        FOR a:=0 TO myobj.nbrsfcs-1
            p1:=Int(adr)                                           /*==== Read 1 vertice ====*/
            p2:=Int(adr+2)                                         /*==== Read 2 vertice ====*/
            p3:=Int(adr+4)                                         /*==== Read 3 vertice ====*/
            ^piv_pts:=p1                                           /*==== Stock 1 vertice ====*/
            piv_pts:=piv_pts+4
            ^piv_pts:=p2                                           /*==== Stock 2 vertice ====*/
            piv_pts:=piv_pts+4
            ^piv_pts:=p3                                           /*==== Stock 3 vertice ====*/
            piv_pts:=piv_pts+4
            adr:=adr+8
        ENDFOR
        p_AjouteNode(mybase.objlist,obj_name,myobj)
    ENDFOR
    IF buf THEN Dispose(buf)
    Raise(OK_FICHIER)
EXCEPT
    RETURN exception
ENDPROC
/**/
/*"p_Read3DProFile(source) :Lit un fichier au format 3DPro v1.10. <source>=Fichier a charger."*/
PROC p_Read3DProFile(source) HANDLE
/********************************************************************************
 * Para         : NONE
 * Return       : OK_FICHIER if ok,else the error.
 * Description  : Read a 3Dpro v1.10 (Amiga) file.
 *******************************************************************************/
  DEF len,adr,buf,handle,flen=TRUE
  DEF count=NIL,piv_pts,pf
  DEF x,y,z
  DEF myobj:PTR TO object3d,adr_face=NIL,pts_size=NIL
  DEF reel_nbrs_faces=0,max_pts_face=0,badr,obj_name[80]:STRING
  DEF numobj,oldnumface
  /*****************************************************/
  flen:=FileLength(source)
  buf:=New(flen+1)
  handle:=Open(source,1005)
  len:=Read(handle,buf,flen)
  Close(handle)
  adr:=buf
  numobj:=p_CountNodes(mybase.objlist)
  StringF(obj_name,'Object_\d',numobj+1)
  myobj:=New(SIZEOF object3d)                       /*==== Allocate Mem for structure ====*/
  myobj.typeobj:=TYPE_3DPRO                         /*==== Type object                ====*/
  myobj.selected:=FALSE                             /*==== Object selected            ====*/
  myobj.bounded:=FALSE                              /*==== Object bounded             ====*/
  myobj.nbrspts:=(Int(adr+13)-Int(adr+11))          /*==== Number of pts              ====*/
  myobj.nbrsfcs:=(Int(adr+9)-Int(adr+7))            /*==== Number of faces            ====*/ /*==== WARNING !!, with 3dpro faces can have more than 3 vertice ====*/
  oldnumface:=myobj.nbrsfcs
  mybase.totalpts:=mybase.totalpts+myobj.nbrspts    /*==== Update database (pts)      ====*/
  myobj.datapts:=New(myobj.nbrspts*12)              /*==== Allocate mem for pts       ====*/
  piv_pts:=myobj.datapts                            /*==== Pointer to objdatapts      ====*/
  adr:=adr+76+7                                     /*==== Jump to datapts            ====*/
  FOR count:=0 TO myobj.nbrspts-1
      x:=SpFix(SpMul(SpFlt(Long(adr)),mybase.fct3dpro))                                  /*==== Read x ====*/
      y:=SpFix(SpMul(SpFlt(Long(adr+4)),mybase.fct3dpro))                                /*==== Read y ====*/
      z:=SpFix(SpMul(SpFlt(Long(adr+8)),mybase.fct3dpro))                                /*==== Read z ====*/
      ^piv_pts:=x                                   /*==== Stock x ====*/
      piv_pts:=piv_pts+4
      ^piv_pts:=y                                   /*==== Stock y ====*/
      piv_pts:=piv_pts+4
      ^piv_pts:=z                                   /*==== Stock z ====*/
      piv_pts:=piv_pts+4
      adr:=adr+12
  ENDFOR
  adr_face:=adr                                     /*==== 3DPro can have some faces with more than 3 vertices ====*/
  FOR count:=0 TO myobj.nbrsfcs-1
      pts_size:=Char(adr)
      IF pts_size>max_pts_face THEN max_pts_face:=pts_size
      reel_nbrs_faces:=reel_nbrs_faces+(pts_size-2)
      adr:=adr+22+(2*pts_size)
  ENDFOR
  myobj.nbrsfcs:=reel_nbrs_faces                                     /*==== The reel number of faces (convert to faces with 3 vertice ====*/
  mybase.totalfcs:=mybase.totalfcs+reel_nbrs_faces                   /*==== Update databse (fcs) ====*/
  myobj.datafcs:=New(reel_nbrs_faces*12)                             /*==== Allocate Mem for faces ====*/
  adr:=adr_face                                                      /*==== Jump to datafaces ====*/
  piv_pts:=myobj.datafcs                                             /*==== Pointer to objdatafcs ====*/
  FOR count:=0 TO oldnumface-1
        pts_size:=Char(adr)
        badr:=adr+22
        adr:=adr+22
        FOR pf:=1 TO pts_size-2
            x:=Int(badr)                  /*==== Read x ====*/
            y:=Int(adr+2)                 /*==== Read y ====*/
            z:=Int(adr+4)                 /*==== Read z ====*/
            ^piv_pts:=x                   /*==== Stock x ====*/
            piv_pts:=piv_pts+4
            ^piv_pts:=y                   /*==== Stock y ====*/
            piv_pts:=piv_pts+4
            ^piv_pts:=z                   /*==== Stock z ====*/
            piv_pts:=piv_pts+4
            adr:=adr+2
        ENDFOR
        adr:=adr+4
  ENDFOR
  p_AjouteNode(mybase.objlist,obj_name,myobj)
  IF buf THEN Dispose(buf)
  Raise(OK_FICHIER)
EXCEPT
  RETURN exception
ENDPROC
/**/
/*"p_ReadImagineFile(source) :Lit un fichier au format Imagine. <source>=Fichier a charger."*/
PROC p_ReadImagineFile(source) HANDLE
/********************************************************************************
 * Para         : NONE
 * Return       : OK_FICHIER if ok,else the error.
 * Description  : Read Imagine (Amiga) file.
 *******************************************************************************/
  DEF len,a,adr,buf,handle,flen=TRUE,pos,chunk
  DEF count=NIL,nbrs_edges,piv
  DEF obj_name[80]:STRING
  DEF adr_edges
  DEF myobj:PTR TO object3d,piv_pts,x,y,z
  DEF x_size,y_size,z_size
  /*****************************************************/
  flen:=FileLength(source)
  buf:=New(flen+1)
  handle:=Open(source,1005)
  len:=Read(handle,buf,flen)
  Close(handle)
  adr:=buf
  FOR a:=0 TO len-1
    pos:=adr++
    IF Even(pos)
        chunk:=Long(pos)
        SELECT chunk
            CASE ID_FORM
            CASE ID_TDDD
            CASE ID_SIZE
                x_size:=SpMul(SpFlt(Int(pos+8)),2048.0)
                y_size:=SpMul(SpFlt(Int(pos+12)),2048.0)
                z_size:=SpMul(SpFlt(Int(pos+16)),2048.0)
            CASE ID_NAME
                StringF(obj_name,pos+8,ALL)
                IF StrLen(obj_name)=0 THEN StringF(obj_name,'Object_\d',p_CountNodes(mybase.objlist))
            CASE ID_PNTS
                myobj:=New(SIZEOF object3d)                     /*==== Allocate Mem for structure ====*/
                myobj.typeobj:=TYPE_IMAGINE                     /*==== Type object                ====*/
                myobj.selected:=FALSE                           /*==== Object selected            ====*/
                myobj.bounded:=FALSE                            /*==== Object bounded             ====*/
                myobj.nbrspts:=Int(pos+8)                       /*==== Number of pts              ====*/
                mybase.totalpts:=mybase.totalpts+myobj.nbrspts  /*==== Update database (pts)      ====*/
                myobj.datapts:=New(myobj.nbrspts*12)            /*==== Allocate mem for pts       ====*/
                piv_pts:=myobj.datapts                          /*==== Pointer to objdatapts      ====*/
                piv:=pos+10                                     /*==== Jump to datapts            ====*/
                dWriteF(['Imagine nom:\s',' pts:\d',' Fcs\d\n'],[obj_name,myobj.nbrspts,myobj.nbrsfcs])
                FOR count:=0 TO myobj.nbrspts-1
                    /*=============================================================
                    x:=Mod(Long(piv),$FFFF)                     /*==== Read x ====*/
                    y:=Mod(Long(piv+4),$FFFF)                   /*==== Read y ====*/
                    z:=Mod(Long(piv+8),$FFFF)                   /*==== Read z ====*/
                    ==============================================================*/
                    x:=SpFix(SpMul(SpDiv(x_size,SpFlt(Long(piv))),mybase.fctimagine))              /*==== Read x ====*/
                    y:=SpFix(SpMul(SpDiv(y_size,SpFlt(Long(piv+4))),mybase.fctimagine))           /*==== Read y ====*/
                    z:=SpFix(SpMul(SpDiv(z_size,SpFlt(Long(piv+8))),mybase.fctimagine))           /*==== Read z ====*/
                    ^piv_pts:=x                                 /*==== Stock x ====*/
                    piv_pts:=piv_pts+4
                    ^piv_pts:=y                                 /*==== Stock y ====*/
                    piv_pts:=piv_pts+4
                    ^piv_pts:=z                                 /*==== Stock z ====*/
                    piv_pts:=piv_pts+4
                    piv:=piv+12
                ENDFOR
            CASE ID_EDGE
                nbrs_edges:=Int(pos+8)                          /*==== Number of edges ====*/
                piv:=pos+10                                     /*==== just remember   ====*/
                adr_edges:=piv                                  /*==== the address     ====*/
                /*
                FOR count:=0 TO nbrs_edges-1
                    WriteF('<NUM: \d[3] S1:\d[3] S2:\d[3]>',count,Int(piv),Int(piv+2))
                    piv:=piv+4
                ENDFOR
                WriteF('\n')
                */
            CASE ID_FACE
                myobj.nbrsfcs:=Int(pos+8)                                       /*==== Number of fcs         ====*/
                mybase.totalfcs:=mybase.totalfcs+myobj.nbrsfcs                  /*==== Update database       ====*/
                myobj.datafcs:=New(myobj.nbrsfcs*12)                            /*==== Allocate mem for fcs  ====*/
                piv_pts:=myobj.datafcs                                          /*==== Pointer to objdatafcs ====*/
                piv:=pos+10                                                     /*==== Jump to datafcs       ====*/
                FOR count:=0 TO myobj.nbrsfcs-1
                    x:=Int(adr_edges+(Int(piv)*4))                              /*==== Read 1 vertice ====*/
                    y:=Int(adr_edges+(Int(piv)*4+2))                            /*==== Read 2 vertice ====*/
                    z:=Int(adr_edges+(Int(piv+2)*4+2))                          /*==== Read 3 vertice ====*/
                    ^piv_pts:=x                                                 /*==== Stock 1 vertice ====*/
                    piv_pts:=piv_pts+4
                    ^piv_pts:=y                                                 /*==== Stock 2 vertice ====*/
                    piv_pts:=piv_pts+4
                    ^piv_pts:=z                                                 /*==== Stock 3 vertice ====*/
                    piv_pts:=piv_pts+4
                    /*
                    WriteF('\d[2] \d[2] \d[2] \d[2] \d[2] \d[2]\n',
                            Int(adr_edges+(Int(piv)*4)),
                            Int(adr_edges+(Int(piv)*4+2)),
                            Int(adr_edges+(Int(piv+2)*4)),
                            Int(adr_edges+(Int(piv+2)*4+2)),
                            Int(adr_edges+(Int(piv+4)*4)),
                            Int(adr_edges+(Int(piv+4)*4+2)))
                    */
                    piv:=piv+6
                ENDFOR
                p_AjouteNode(mybase.objlist,obj_name,myobj)
            DEFAULT
                NOP
        ENDSELECT
    ENDIF
  ENDFOR
  IF buf THEN Dispose(buf)
  Raise(OK_FICHIER)
EXCEPT
  RETURN exception
ENDPROC
/**/
/*"p_ReadSculptFile(source) :Lit un fichier au format Sculpt. <source>=Fichier a charger."*/
PROC p_ReadSculptFile(source) HANDLE
/********************************************************************************
 * Para         : NONE
 * Return       : OK_FICHIER if ok,else the error.
 * Description  : Read Sculpt (Amiga) file.
 *******************************************************************************/
  DEF len,a,adr,buf,handle,flen=TRUE,pos,chunk,i,piv
  DEF x,y,z
  DEF myobj:PTR TO object3d,piv_pts,obj_name[80]:STRING
  DEF numobj
  /*****************************************************/
  flen:=FileLength(source)
  buf:=New(flen+1)
  handle:=Open(source,1005)
  len:=Read(handle,buf,flen)
  Close(handle)
  adr:=buf
  FOR a:=0 TO len-1
    pos:=adr++
    IF Even(pos)
        chunk:=Long(pos)
        SELECT chunk
            CASE ID_FORM
            CASE ID_SC3D
            CASE ID_VERT
                numobj:=p_CountNodes(mybase.objlist)
                StringF(obj_name,'Object_\d',numobj+1)
                myobj:=New(SIZEOF object3d)                        /*==== Allocate mem for structure ====*/
                myobj.typeobj:=TYPE_SCULPT                         /*==== Type object                ====*/
                myobj.selected:=FALSE                              /*==== Object selected            ====*/
                myobj.bounded:=FALSE                               /*==== Object bounded             ====*/
                myobj.nbrspts:=Long(pos+4)/12                      /*==== Number of pts              ====*/
                mybase.totalpts:=mybase.totalpts+myobj.nbrspts     /*==== Update database (pts)      ====*/
                myobj.datapts:=New(myobj.nbrspts*12)               /*==== Allocate mem for pts       ====*/
                piv_pts:=myobj.datapts                             /*==== Pointer to objdatapts      ====*/
                piv:=pos+8                                         /*==== Jump to datapts            ====*/
                FOR i:=0 TO myobj.nbrspts-1
                    /*================================================================
                    x:=Mod(Long(piv),$FFFF)                        /*==== Read x ====*/
                    y:=Mod(Long(piv+4),$FFFF)                      /*==== Read y ====*/
                    z:=Mod(Long(piv+8),$FFFF)                      /*==== Read z ====*/
                    =================================================================*/
                    x:=SpFix(SpMul(SpFlt(Long(piv)),mybase.fctsculpt))                        /*==== Read x ====*/
                    y:=SpFix(SpMul(SpFlt(Long(piv+4)),mybase.fctsculpt))                      /*==== Read y ====*/
                    z:=SpFix(SpMul(SpFlt(Long(piv+8)),mybase.fctsculpt))                      /*==== Read z ====*/
                    ^piv_pts:=x                                    /*==== Stock x ====*/
                    piv_pts:=piv_pts+4
                    ^piv_pts:=y                                    /*==== Stock y ====*/
                    piv_pts:=piv_pts+4
                    ^piv_pts:=z                                    /*==== Stock z ====*/
                    piv_pts:=piv_pts+4
                    piv:=piv+12
                ENDFOR
            CASE ID_EDGE
            CASE ID_FACE
                myobj.nbrsfcs:=Long(pos+4)/16                                 /*==== Number of fcs         ====*/
                myobj.datafcs:=New(myobj.nbrsfcs*12)                          /*==== Allocate mem for fcs  ====*/
                mybase.totalfcs:=mybase.totalfcs+myobj.nbrsfcs                /*==== Update database (fcs) ====*/
                piv_pts:=myobj.datafcs                                        /*==== Pointer to objdatafcs ====*/
                piv:=pos+8                                                    /*==== Jump to datafcs       ====*/
                FOR i:=0 TO myobj.nbrsfcs-1
                    x:=Long(piv)                          /*==== Read 1 vertice ====*/
                    y:=Long(piv+4)                        /*==== Read 2 vertice ====*/
                    z:=Long(piv+8)                        /*==== Read 3 vertice ====*/
                    ^piv_pts:=x                           /*==== Stock 1 vertice ====*/
                    piv_pts:=piv_pts+4
                    ^piv_pts:=y                           /*==== Stock 2 vertice ====*/
                    piv_pts:=piv_pts+4
                    ^piv_pts:=z                           /*==== Stock 3 vertice ====*/
                    piv_pts:=piv_pts+4
                    piv:=piv+16
                ENDFOR
                p_AjouteNode(mybase.objlist,obj_name,myobj)
            DEFAULT
                NOP
        ENDSELECT
    ENDIF
  ENDFOR
  IF buf THEN Dispose(buf)
  Raise(OK_FICHIER)
EXCEPT
  RETURN exception
ENDPROC
/**/
/*"p_ReadVertexFile(chunk,source) :Lit un fichier au format Vertex,<chunk>=LONG,<source>=Fichier a charger."*/
PROC p_ReadVertexFile(chunk,source) HANDLE
/********************************************************************************
 * Para         : the version chunk of the vertex file.
 * Return       : OK_FICHIER if ok,else the error.
 * Description  : Read Vertex (Amiga) file.
 *******************************************************************************/
  DEF len,a,adr,buf,handle,flen=TRUE
  DEF piv
  DEF nbrs_edges,x,y,z
  DEF myobj:PTR TO object3d,piv_pts,obj_name[80]:STRING
  DEF numobj
  /*****************************************************/
  flen:=FileLength(source)
  buf:=New(flen+1)
  handle:=Open(source,1005)
  len:=Read(handle,buf,flen)
  Close(handle)
  adr:=buf
  numobj:=p_CountNodes(mybase.objlist)
  StringF(obj_name,'Object_\d',numobj+1)
  myobj:=New(SIZEOF object3d)                          /*==== Allocate mem for structure ====*/
  IF chunk=ID_VE3D THEN myobj.typeobj:=TYPE_OLDVERTEX ELSE myobj.typeobj:=TYPE_NEWVERTEX    /*==== Object type ====*/
  myobj.selected:=FALSE                                /*==== Object selected ====*/
  myobj.bounded:=FALSE                                 /*==== Object bounded  ====*/
  myobj.nbrspts:=Long(adr+4)                           /*==== Number of pts   ====*/
  mybase.totalpts:=mybase.totalpts+myobj.nbrspts       /*==== Update database (pts) ====*/
  myobj.datapts:=New(myobj.nbrspts*12)                 /*==== Allocate mem for pts ====*/
  piv_pts:=myobj.datapts                               /*==== Pointer to objdatapts ====*/
  piv:=adr+8                                           /*==== Jump to datapts ====*/
  dWriteF(['Vertex Nom:\s',' pts:\d',' Fcs\d\n'],[obj_name,myobj.nbrspts,myobj.nbrsfcs])
  FOR a:=0 TO myobj.nbrspts-1
      /*==================================================================
      x:=Mod(Long(piv),$FFFF)                          /*==== Read x ====*/
      y:=Mod(Long(piv+4),$FFFF)                        /*==== Read y ====*/
      z:=Mod(Long(piv+8),$FFFF)                        /*==== Read z ====*/
      ===================================================================*/
      x:=SpFix(SpMul(SpFlt(Long(piv)),mybase.fctvertex))                          /*==== Read x ====*/
      y:=SpFix(SpMul(SpFlt(Long(piv+4)),mybase.fctvertex))                        /*==== Read y ====*/
      z:=SpFix(SpMul(SpFlt(Long(piv+8)),mybase.fctvertex))                        /*==== Read z ====*/
      ^piv_pts:=x                                      /*==== Stock x ====*/
      piv_pts:=piv_pts+4
      ^piv_pts:=y                                      /*==== Stock y ====*/
      piv_pts:=piv_pts+4
      ^piv_pts:=z                                      /*==== Stock z ====*/
      piv_pts:=piv_pts+4
      /*WriteF('X \d[12] Y \d[12] Z \d[12]\n',Mod(Long(piv),$FFFF),Mod(Long(piv+4),$FFFF),Mod(Long(piv+8),$FFFF))*/
      IF chunk=ID_VE3D THEN piv:=piv+16 ELSE piv:=piv+17
      /*piv:=piv+17*/
  ENDFOR
  nbrs_edges:=Long(piv)
  piv:=piv+4+Mul(nbrs_edges,8)
  myobj.nbrsfcs:=Long(piv)                             /*==== Number of fcs ====*/
  mybase.totalfcs:=mybase.totalfcs+myobj.nbrsfcs       /*==== Update database fcs ====*/
  myobj.datafcs:=New(myobj.nbrsfcs*12)                 /*==== Allocate mem for fcs ====*/
  piv_pts:=myobj.datafcs                               /*==== Pointer to objdatafcs ====*/
  piv:=piv+4                                           /*==== Jump to datafcs ====*/
  FOR a:=0 TO myobj.nbrsfcs-1
      x:=Long(piv)-1                                   /*==== Read 1 vertice ====*/
      y:=Long(piv+4)-1                                 /*==== Read 2 vertice ====*/
      z:=Long(piv+8)-1                                 /*==== Read 3 vertice ====*/
      ^piv_pts:=x                                      /*==== Stock 1 vertice ====*/
      piv_pts:=piv_pts+4
      ^piv_pts:=y                                      /*==== Stock 2 vertice ====*/
      piv_pts:=piv_pts+4
      ^piv_pts:=z                                      /*==== Stock 3 vertice ====*/
      piv_pts:=piv_pts+4
      piv:=piv+12
  ENDFOR
  p_AjouteNode(mybase.objlist,obj_name,myobj)
  IF buf THEN Dispose(buf)
  Raise(OK_FICHIER)
EXCEPT
  RETURN exception
ENDPROC
/**/
/*"p_ReadVertex2File(source):Lit un fichier au format VerteX2.0,<source>=Fichier a charger."*/
PROC p_ReadVertex2File(source) HANDLE
/********************************************************************************
 * Para         : NONE
 * Return       : OK_FICHIER if ok,else the error.
 * Description  : Read Sculpt (Amiga) file.
 *******************************************************************************/
  DEF len,a,adr,buf,handle,flen=TRUE,pos,chunk,i,piv
  DEF x,y,z
  DEF myobj:PTR TO object3d,piv_pts,obj_name[80]:STRING
  DEF numobj
  DEF longf,longe,adr_edges,nbrs_edges
  /*****************************************************/
  flen:=FileLength(source)
  buf:=New(flen+1)
  handle:=Open(source,1005)
  len:=Read(handle,buf,flen)
  Close(handle)
  adr:=buf
  FOR a:=0 TO len-1
    pos:=adr++
    IF Even(pos)
        chunk:=Long(pos)
        SELECT chunk
            CASE ID_NAME
                StringF(obj_name,pos+8,ALL)
                IF StrLen(obj_name)=0 THEN StringF(obj_name,'Object_\d',p_CountNodes(mybase.objlist))
            CASE ID_VERT
                numobj:=p_CountNodes(mybase.objlist)
                myobj:=New(SIZEOF object3d)
                myobj.typeobj:=TYPE_VERTEX2                        /*==== Type object                ====*/
                myobj.selected:=FALSE                              /*==== Object selected            ====*/
                myobj.bounded:=FALSE                               /*==== Object bounded             ====*/
                myobj.nbrspts:=Long(pos+4)/12                      /*==== Number of pts              ====*/
                mybase.totalpts:=mybase.totalpts+myobj.nbrspts     /*==== Update database (pts)      ====*/
                myobj.datapts:=New(myobj.nbrspts*12)               /*==== Allocate mem for pts       ====*/
                piv_pts:=myobj.datapts                             /*==== Pointer to objdatapts      ====*/
                piv:=pos+8                                         /*==== Jump to datapts            ====*/
                FOR i:=0 TO myobj.nbrspts-1
                    /*================================================================
                    x:=Mod(Long(piv),$FFFF)                        /*==== Read x ====*/
                    y:=Mod(Long(piv+4),$FFFF)                      /*==== Read y ====*/
                    z:=Mod(Long(piv+8),$FFFF)                      /*==== Read z ====*/
                    =================================================================*/
                    x:=SpFix(SpMul(SpFlt(Long(piv)),mybase.fctvertex))                        /*==== Read x ====*/
                    y:=SpFix(SpMul(SpFlt(Long(piv+4)),mybase.fctvertex))                      /*==== Read y ====*/
                    z:=SpFix(SpMul(SpFlt(Long(piv+8)),mybase.fctvertex))                      /*==== Read z ====*/
                    ^piv_pts:=x                                    /*==== Stock x ====*/
                    piv_pts:=piv_pts+4
                    ^piv_pts:=y                                    /*==== Stock y ====*/
                    piv_pts:=piv_pts+4
                    ^piv_pts:=z                                    /*==== Stock z ====*/
                    piv_pts:=piv_pts+4
                    piv:=piv+12
                ENDFOR
            CASE ID_EDGE
                longe:=Long(pos+4)
                IF longe<765
                    nbrs_edges:=longe/3
                ELSE
                    nbrs_edges:=longe/6
                ENDIF
                adr_edges:=pos+8
            CASE ID_FACE
                longf:=Long(pos+4)
                IF longf<765
                    myobj.nbrsfcs:=Long(pos+4)/3                                 /*==== Number of fcs         ====*/
                    dWriteF(['InProc nbrsFcs (Byte) :\d\n'],[myobj.nbrsfcs])
                ELSE
                    myobj.nbrsfcs:=Long(pos+4)/6                                 /*==== Number of fcs         ====*/
                    dWriteF(['InProc nbrsFcs (Int) :\d\n'],[myobj.nbrsfcs])
                ENDIF
                myobj.datafcs:=New(myobj.nbrsfcs*12)                          /*==== Allocate mem for fcs  ====*/
                mybase.totalfcs:=mybase.totalfcs+myobj.nbrsfcs                /*==== Update database (fcs) ====*/
                piv_pts:=myobj.datafcs                                        /*==== Pointer to objdatafcs ====*/
                piv:=pos+8                                                    /*==== Jump to datafcs       ====*/
                FOR i:=0 TO myobj.nbrsfcs-1
                    IF longf<765
                        x:=Char(piv)-1
                        y:=Char(piv+1)-1
                        z:=Char(piv+2)-1
                        ^piv_pts:=x                           /*==== Stock 1 vertice ====*/
                        piv_pts:=piv_pts+4
                        ^piv_pts:=y                           /*==== Stock 2 vertice ====*/
                        piv_pts:=piv_pts+4
                        ^piv_pts:=z                           /*==== Stock 3 vertice ====*/
                        piv_pts:=piv_pts+4
                        piv:=piv+3
                    ELSE
                        x:=Int(piv)-1                          /*==== Read 1 vertice ====*/
                        y:=Int(piv+2)-1                        /*==== Read 2 vertice ====*/
                        z:=Int(piv+4)-1                        /*==== Read 3 vertice ====*/
                        ^piv_pts:=x                           /*==== Stock 1 vertice ====*/
                        piv_pts:=piv_pts+4
                        ^piv_pts:=y                           /*==== Stock 2 vertice ====*/
                        piv_pts:=piv_pts+4
                        ^piv_pts:=z                           /*==== Stock 3 vertice ====*/
                        piv_pts:=piv_pts+4
                        piv:=piv+6
                    ENDIF
                ENDFOR
                p_AjouteNode(mybase.objlist,obj_name,myobj)
            DEFAULT
                NOP
        ENDSELECT
    ENDIF
  ENDFOR
  IF buf THEN Dispose(buf)
  Raise(OK_FICHIER)
EXCEPT
  RETURN exception
ENDPROC
/**/
/**/

