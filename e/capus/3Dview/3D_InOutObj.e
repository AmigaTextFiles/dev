PROC readfile() /*"readfile()"*/
/********************************************************************************
 * Para         : NONE
 * Return       : OK_FICHIER if ok,else the error.
 * Description  : Read source file and call the good Proc.
 *******************************************************************************/
    DEF len,adr,buf,handle,flen=TRUE,chunk,retour_read=NIL
    DEF w_req=NIL,req_tag=NIL
    IF (flen:=FileLength(fichier_source))=-1 THEN RETURN ER_NOFICHIER
    IF (buf:=New(flen+1))=NIL THEN RETURN ER_NOMEM
    IF (handle:=Open(fichier_source,1005))=NIL THEN RETURN ER_OPEN
    len:=Read(handle,buf,flen)
    Close(handle)
    IF len<1 THEN RETURN ER_NOFICHIER
    adr:=buf
    chunk:=Int(adr)
    IF chunk=ID_3D2
        Dispose(buf)
        IF view_window THEN w_req:=init_req('Load 3D2 Object(s) ') ELSE w_req:=init_reqwb('Load 3D2 Object(s) ')
        retour_read:=read3d2file()
        CloseW(w_req)
        RETURN retour_read
    ELSEIF chunk=ID_3D3D
        Dispose(buf)
        IF view_window THEN w_req:=init_req('Load 3D Object(s) ') ELSE w_req:=init_reqwb('Load 3D Object(s) ')
        retour_read:=read3dfile()
        CloseW(w_req)
        RETURN retour_read
    ENDIF
    chunk:=Long(adr)
    IF (chunk=ID_VR3D) OR (chunk=ID_VE3D)
        Dispose(buf)
        IF view_window THEN w_req:=init_req('Load Vertex Object(s) ') ELSE w_req:=init_reqwb('Load Vertex Object(s) ')
        retour_read:=readvertexfile(chunk)
        CloseW(w_req)
        RETURN retour_read
    ELSEIF chunk=ID_3DPRO
        Dispose(buf)
        IF view_window THEN w_req:=init_req('Load 3Dpro Object(s) ') ELSE w_req:=init_reqwb('Load 3Dpro Object(s) ')
        retour_read:=read3dprofile()
        CloseW(w_req)
        RETURN retour_read
    ENDIF
    chunk:=Long(adr+8)
    SELECT chunk
        CASE ID_TDDD
            Dispose(buf)
            IF view_window THEN w_req:=init_req('Load Imagine Object(s) ') ELSE w_req:=init_reqwb('Load Imagine Object(s) ')
            retour_read:=readimaginefile()
            CloseW(w_req)
            RETURN retour_read
        CASE ID_SC3D
            Dispose(buf)
            IF view_window THEN w_req:=init_req('Load Sculpt Object(s) ') ELSE w_req:=init_reqwb('Load Sculpt Object(s) ')
            retour_read:=readsculptfile()
            CloseW(w_req)
            RETURN retour_read
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
            IF view_window THEN req_tag:=[RT_WINDOW,view_window,RT_LOCKWINDOW,TRUE,TAG_DONE,0]
            RtEZRequestA('                Type de fichier inconnu. \n'+
                         ' < IMAGINE/SCULPT/CYBER V2.0/VERTEX V 1.62a-V 1.73.1f > \n'+
                         ' <              3Dpro v1.10/CYBER v1.0                > \n'+
                         '                         ONLY            ','Ok',0,0,req_tag)
            RETURN ER_INCONNU
    ENDSELECT
ENDPROC
PROC read3dfile() HANDLE /*"read3dfile()"*/
/********************************************************************************
 * Para         : NONE
 * Return       : OK_FICHIER if ok,else the error.
 * Description  : Read a CyberStudio v1.0 (Atari) file.
 *******************************************************************************/
  DEF len,a,adr,buf,handle,flen=TRUE,i
  DEF nbrs_obj,nbrs_pts,nbrs_faces,obj_name[80]:STRING,x,y,z,my_obj_node:PTR TO ln
  DEF myobj:PTR TO object3d,piv_pts
  /*****************************************************/
  flen:=FileLength(fichier_source)
  buf:=New(flen+1)
  handle:=Open(fichier_source,1005)
  len:=Read(handle,buf,flen)
  Close(handle)
  adr:=buf
  nbrs_obj:=Int(adr+2)
  my_database.nbrsobjs:=my_database.nbrsobjs+nbrs_obj
  adr:=buf+34
  FOR i:=0 TO nbrs_obj-1
      StringF(obj_name,'\s',adr)
      IF StrLen(obj_name)=0 THEN StringF(obj_name,'Object_\d',ListLen(list_obj))
      my_obj_node:=New(SIZEOF ln)
      my_obj_node.succ:=0
      my_obj_node.name:=String(EstrLen(obj_name))
      StrCopy(my_obj_node.name,obj_name,ALL)
      AddTail(new_liste,my_obj_node)
      IF ListLen(list_obj)=0
        new_liste.head:=my_obj_node
        my_obj_node.pred:=0
      ENDIF
      myobj:=New(SIZEOF object3d)
      myobj.typeobj:=TYPE_OLDCYBER
      myobj.selected:=FALSE
      myobj.bounded:=FALSE
      ListAdd(list_obj,[myobj],1)
      nbrs_pts:=Int(adr+9)
      myobj.nbrspts:=nbrs_pts
      my_database.totalpts:=my_database.totalpts+nbrs_pts
      adr:=adr+11
      myobj.datapts:=New(nbrs_pts*12)
      piv_pts:=myobj.datapts
      FOR a:=0 TO nbrs_pts-1
          x:=Long(adr)
          y:=Long(adr+(nbrs_pts*4))
          z:=Long(adr+(nbrs_pts*8))
          ^piv_pts:=Mul(SpFix(x),100)
          piv_pts:=piv_pts+4
          ^piv_pts:=Mul(SpFix(y),100)
          piv_pts:=piv_pts+4
          ^piv_pts:=Mul(SpFix(z),100)
          piv_pts:=piv_pts+4
          adr:=adr+4
      ENDFOR
      adr:=adr+(nbrs_pts*8)
      nbrs_faces:=Int(adr)
      myobj.nbrsfaces:=nbrs_faces
      my_database.totalfaces:=my_database.totalfaces+nbrs_faces
      myobj.datafaces:=New(nbrs_faces*12)
      piv_pts:=myobj.datafaces
      adr:=adr+2
      FOR a:=0 TO nbrs_faces-1
          x:=Int(adr)
          y:=Int(adr+2)
          z:=Int(adr+4)
          ^piv_pts:=x
          piv_pts:=piv_pts+4
          ^piv_pts:=y
          piv_pts:=piv_pts+4
          ^piv_pts:=z
          piv_pts:=piv_pts+4
          adr:=adr+8
      ENDFOR
  ENDFOR
  Dispose(buf)
  Raise(OK_FICHIER)
EXCEPT
  RETURN exception
ENDPROC
PROC read3d2file() HANDLE /*"read3d2file()"*/
/********************************************************************************
 * Para         : NONE
 * Return       : OK_FICHIER if ok,else the error.
 * Description  : Read a CyberStudio v2.0 (Atari) file.
 *******************************************************************************/
    DEF len,a,adr,buf,handle,flen=TRUE,i
    DEF nbrs_obj,nbrs_pts,nbrs_faces,obj_name[80]:STRING,x,y,z,my_obj_node:PTR TO ln
    DEF myobj:PTR TO object3d,piv_pts,p1,p2,p3
    /*****************************************************/
    flen:=FileLength(fichier_source)
    buf:=New(flen+1)
    handle:=Open(fichier_source,1005)
    len:=Read(handle,buf,flen)
    Close(handle)
    adr:=buf
    nbrs_obj:=Int(adr+2)
    my_database.nbrsobjs:=my_database.nbrsobjs+nbrs_obj
    adr:=buf+256
    FOR i:=0 TO nbrs_obj-1
        StringF(obj_name,'\s',adr)
        IF StrLen(obj_name)=0 THEN StringF(obj_name,'Object_\d',ListLen(list_obj))
        my_obj_node:=New(SIZEOF ln)
        my_obj_node.succ:=0
        my_obj_node.name:=String(EstrLen(obj_name))
        StrCopy(my_obj_node.name,obj_name,ALL)
        AddTail(new_liste,my_obj_node)
        IF ListLen(list_obj)=0
            new_liste.head:=my_obj_node
            my_obj_node.pred:=0
        ENDIF
        myobj:=New(SIZEOF object3d)
        myobj.typeobj:=TYPE_NEWCYBER
        myobj.selected:=FALSE
        myobj.bounded:=FALSE
        ListAdd(list_obj,[myobj],1)
        nbrs_pts:=Int(adr+9)
        myobj.nbrspts:=nbrs_pts
        my_database.totalpts:=my_database.totalpts+nbrs_pts
        adr:=adr+11
        myobj.datapts:=New(nbrs_pts*12)
        piv_pts:=myobj.datapts
        FOR a:=0 TO nbrs_pts-1
            x:=Int(adr)
            y:=Int(adr+2)
            z:=Int(adr+4)
            IF x>32767 THEN x:=x-65535
            IF y>32767 THEN y:=y-65535
            IF z>32767 THEN z:=z-65535
            adr:=adr+6
            ^piv_pts:=x
            piv_pts:=piv_pts+4
            ^piv_pts:=y
            piv_pts:=piv_pts+4
            ^piv_pts:=z
            piv_pts:=piv_pts+4
        ENDFOR
        nbrs_faces:=Int(adr)
        myobj.nbrsfaces:=nbrs_faces
        my_database.totalfaces:=my_database.totalfaces+nbrs_faces
        myobj.datafaces:=New(nbrs_faces*12)
        piv_pts:=myobj.datafaces
        adr:=adr+2
        FOR a:=0 TO nbrs_faces-1
            p1:=Int(adr)
            p2:=Int(adr+2)
            p3:=Int(adr+4)
            ^piv_pts:=p1
            piv_pts:=piv_pts+4
            ^piv_pts:=p2
            piv_pts:=piv_pts+4
            ^piv_pts:=p3
            piv_pts:=piv_pts+4
            adr:=adr+8
        ENDFOR
    ENDFOR
    Dispose(buf)
    Raise(OK_FICHIER)
EXCEPT
    RETURN exception
ENDPROC
PROC read3dprofile() HANDLE /*"read3dprofile()"*/
/********************************************************************************
 * Para         : NONE
 * Return       : OK_FICHIER if ok,else the error.
 * Description  : Read a 3Dpro v1.10 (Amiga) file.
 *******************************************************************************/
  DEF len,adr,buf,handle,flen=TRUE
  DEF count=NIL,piv_pts,pf
  DEF nbrs_pts,nbrs_faces,x,y,z
  DEF myobj:PTR TO object3d,adr_face=NIL,pts_size=NIL
  DEF reel_nbrs_faces=0,max_pts_face=0,badr,obj_name[80]:STRING,my_obj_node:PTR TO ln
  /*****************************************************/
  flen:=FileLength(fichier_source)
  buf:=New(flen+1)
  handle:=Open(fichier_source,1005)
  len:=Read(handle,buf,flen)
  Close(handle)
  adr:=buf
  StringF(obj_name,'Object_\d',ListLen(list_obj))
  my_obj_node:=New(SIZEOF ln)
  my_obj_node.name:=String(EstrLen(obj_name))
  StrCopy(my_obj_node.name,obj_name,ALL)
  AddTail(new_liste,my_obj_node)
  IF ListLen(list_obj)=0
      new_liste.head:=my_obj_node
      my_obj_node.pred:=0
  ENDIF
  nbrs_faces:=Int(adr+9)-Int(adr+7)
  nbrs_pts:=Int(adr+13)-Int(adr+11)
  myobj:=New(SIZEOF object3d)
  myobj.typeobj:=TYPE_3DPRO
  myobj.selected:=FALSE
  myobj.bounded:=FALSE
  ListAdd(list_obj,[myobj],1)
  my_database.nbrsobjs:=ListLen(list_obj)
  myobj.nbrspts:=nbrs_pts
  my_database.totalpts:=my_database.totalpts+nbrs_pts
  myobj.datapts:=New(nbrs_pts*12)
  piv_pts:=myobj.datapts
  adr:=adr+76+7
  FOR count:=0 TO nbrs_pts-1
      x:=Long(adr)
      y:=Long(adr+4)
      z:=Long(adr+8)
      ^piv_pts:=x
      piv_pts:=piv_pts+4
      ^piv_pts:=y
      piv_pts:=piv_pts+4
      ^piv_pts:=z
      piv_pts:=piv_pts+4
      adr:=adr+12
  ENDFOR
  adr_face:=adr
  FOR count:=0 TO nbrs_faces-1
      pts_size:=Char(adr)
      IF pts_size>max_pts_face THEN max_pts_face:=pts_size
      reel_nbrs_faces:=reel_nbrs_faces+(pts_size-2)
      adr:=adr+22+(2*pts_size)
  ENDFOR
  myobj.nbrsfaces:=reel_nbrs_faces
  my_database.totalfaces:=my_database.totalfaces+reel_nbrs_faces
  myobj.datafaces:=New(reel_nbrs_faces*12)
  adr:=adr_face
  piv_pts:=myobj.datafaces
  FOR count:=0 TO nbrs_faces-1
        pts_size:=Char(adr)
        badr:=adr+22
        adr:=adr+22
        FOR pf:=1 TO pts_size-2
            x:=Int(badr)
            y:=Int(adr+2)
            z:=Int(adr+4)
            ^piv_pts:=x
            piv_pts:=piv_pts+4
            ^piv_pts:=y
            piv_pts:=piv_pts+4
            ^piv_pts:=z
            piv_pts:=piv_pts+4
            adr:=adr+2
        ENDFOR
        adr:=adr+4
  ENDFOR
  Dispose(buf)
  Raise(OK_FICHIER)
EXCEPT
  RETURN exception
ENDPROC
PROC readimaginefile() HANDLE /*"readimaginefile()"*/
/********************************************************************************
 * Para         : NONE
 * Return       : OK_FICHIER if ok,else the error.
 * Description  : Read Imagine (Amiga) file.
 *******************************************************************************/
  DEF len,a,adr,buf,handle,flen=TRUE,pos,chunk
  DEF count=NIL,nbrs_edges,piv
  DEF nbrs_pts,nbrs_faces
  DEF obj_name[80]:STRING,my_obj_node:PTR TO ln
  DEF adr_edges
  DEF myobj:PTR TO object3d,piv_pts,x,y,z
  /*****************************************************/
  flen:=FileLength(fichier_source)
  buf:=New(flen+1)
  handle:=Open(fichier_source,1005)
  len:=Read(handle,buf,flen)
  Close(handle)
  adr:=buf
  FOR a:=0 TO len-1
    pos:=adr++
    chunk:=Long(pos)
    SELECT chunk
        CASE ID_FORM
        CASE ID_TDDD
        CASE ID_NAME
            StringF(obj_name,pos+8,ALL)
            IF StrLen(obj_name)=0 THEN StringF(obj_name,'Object_\d',ListLen(list_obj))
        CASE ID_PNTS
            my_obj_node:=New(SIZEOF ln)
            my_obj_node.succ:=0
            my_obj_node.name:=String(EstrLen(obj_name))
            StrCopy(my_obj_node.name,obj_name,ALL)
            AddTail(new_liste,my_obj_node)
            IF ListLen(list_obj)=0
                new_liste.head:=my_obj_node
                my_obj_node.pred:=0
            ENDIF
            myobj:=New(SIZEOF object3d)
            ListAdd(list_obj,[myobj],1)
            myobj.typeobj:=TYPE_IMAGINE
            myobj.selected:=FALSE
            myobj.bounded:=FALSE
            my_database.nbrsobjs:=ListLen(list_obj)
            nbrs_pts:=Int(pos+8)
            my_database.totalpts:=my_database.totalpts+nbrs_pts
            myobj.nbrspts:=nbrs_pts
            myobj.datapts:=New(nbrs_pts*12)
            piv_pts:=myobj.datapts
            piv:=pos+10
            FOR count:=0 TO nbrs_pts-1
                x:=Mod(Long(piv),$FFFF)
                y:=Mod(Long(piv+4),$FFFF)
                z:=Mod(Long(piv+8),$FFFF)
                ^piv_pts:=x
                piv_pts:=piv_pts+4
                ^piv_pts:=y
                piv_pts:=piv_pts+4
                ^piv_pts:=z
                piv_pts:=piv_pts+4
                piv:=piv+12
            ENDFOR
        CASE ID_EDGE
            nbrs_edges:=Int(pos+8)
            piv:=pos+10
            adr_edges:=piv
            /*
            FOR count:=0 TO nbrs_edges-1
                WriteF('<NUM: \d[3] S1:\d[3] S2:\d[3]>',count,Int(piv),Int(piv+2))
                piv:=piv+4
            ENDFOR
            WriteF('\n')
            */
        CASE ID_FACE
            nbrs_faces:=Int(pos+8)
            myobj.nbrsfaces:=nbrs_faces
            my_database.totalfaces:=my_database.totalfaces+nbrs_faces
            myobj.datafaces:=New(nbrs_faces*12)
            piv_pts:=myobj.datafaces
            piv:=pos+10
            FOR count:=0 TO nbrs_faces-1
                x:=Int(adr_edges+(Int(piv)*4))
                y:=Int(adr_edges+(Int(piv)*4+2))
                z:=Int(adr_edges+(Int(piv+2)*4+2))
                ^piv_pts:=x
                piv_pts:=piv_pts+4
                ^piv_pts:=y
                piv_pts:=piv_pts+4
                ^piv_pts:=z
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
        DEFAULT
            NOP
    ENDSELECT
  ENDFOR
  Dispose(buf)
  Raise(OK_FICHIER)
EXCEPT
  RETURN exception
ENDPROC
PROC readsculptfile() HANDLE /*"readsculptfile()"*/
/********************************************************************************
 * Para         : NONE
 * Return       : OK_FICHIER if ok,else the error.
 * Description  : Read Sculpt (Amiga) file.
 *******************************************************************************/
  DEF len,a,adr,buf,handle,flen=TRUE,pos,chunk,i,piv
  DEF nbrs_pts,nbrs_faces
  DEF x,y,z
  DEF myobj:PTR TO object3d,piv_pts,obj_name[80]:STRING,my_obj_node:PTR TO ln
  /*****************************************************/
  flen:=FileLength(fichier_source)
  buf:=New(flen+1)
  handle:=Open(fichier_source,1005)
  len:=Read(handle,buf,flen)
  Close(handle)
  adr:=buf
  FOR a:=0 TO len-1
    pos:=adr++
    chunk:=Long(pos)
    SELECT chunk
        CASE ID_FORM
        CASE ID_SC3D
        CASE ID_VERT
            StringF(obj_name,'Object_\d',ListLen(list_obj))
            my_obj_node:=New(SIZEOF ln)
            my_obj_node.succ:=0
            my_obj_node.name:=String(EstrLen(obj_name))
            StrCopy(my_obj_node.name,obj_name,ALL)
            AddTail(new_liste,my_obj_node)
            IF ListLen(list_obj)=0
                new_liste.head:=my_obj_node
                my_obj_node.pred:=0
            ENDIF
            myobj:=New(SIZEOF object3d)
            ListAdd(list_obj,[myobj],1)
            myobj.typeobj:=TYPE_SCULPT
            myobj.selected:=FALSE
            myobj.bounded:=FALSE
            my_database.nbrsobjs:=ListLen(list_obj)
            nbrs_pts:=Long(pos+4)/12
            WriteF('\h \d pts\n',nbrs_pts,nbrs_pts)
            myobj.nbrspts:=nbrs_pts
            my_database.totalpts:=my_database.totalpts+nbrs_pts
            myobj.datapts:=New(nbrs_pts*12)
            piv_pts:=myobj.datapts
            piv:=pos+8
            FOR i:=0 TO nbrs_pts-1
                x:=Mod(Long(piv),$FFFF)
                y:=Mod(Long(piv+4),$FFFF)
                z:=Mod(Long(piv+8),$FFFF)
                ^piv_pts:=x
                piv_pts:=piv_pts+4
                ^piv_pts:=y
                piv_pts:=piv_pts+4
                ^piv_pts:=z
                piv_pts:=piv_pts+4
                piv:=piv+12
            ENDFOR
        CASE ID_EDGE
        CASE ID_FACE
            nbrs_faces:=Long(pos+4)/16
            myobj.nbrsfaces:=nbrs_faces
            myobj.datafaces:=New(nbrs_faces*12)
            my_database.totalfaces:=my_database.totalfaces+nbrs_faces
            piv_pts:=myobj.datafaces
            piv:=pos+8
            FOR i:=0 TO nbrs_faces-1
                x:=Long(piv)
                y:=Long(piv+4)
                z:=Long(piv+8)
                ^piv_pts:=x
                piv_pts:=piv_pts+4
                ^piv_pts:=y
                piv_pts:=piv_pts+4
                ^piv_pts:=z
                piv_pts:=piv_pts+4
                piv:=piv+16
            ENDFOR
        DEFAULT
            NOP
    ENDSELECT
  ENDFOR
  Dispose(buf)
  Raise(OK_FICHIER)
EXCEPT
  RETURN exception
ENDPROC
PROC readvertexfile(chunk) HANDLE /*"readvertexfile()"*/
/********************************************************************************
 * Para         : the version chunk of the vertex file.
 * Return       : OK_FICHIER if ok,else the error.
 * Description  : Read Vertex (Amiga) file.
 *******************************************************************************/
  DEF len,a,adr,buf,handle,flen=TRUE
  DEF piv
  DEF nbrs_pts,nbrs_edges,nbrs_faces,x,y,z
  DEF myobj:PTR TO object3d,piv_pts,obj_name[80]:STRING,my_obj_node:PTR TO ln
  /*****************************************************/
  flen:=FileLength(fichier_source)
  buf:=New(flen+1)
  handle:=Open(fichier_source,1005)
  len:=Read(handle,buf,flen)
  Close(handle)
  adr:=buf
  StringF(obj_name,'Object_\d',ListLen(list_obj))
  my_obj_node:=New(SIZEOF ln)
  my_obj_node.succ:=0
  my_obj_node.name:=String(EstrLen(obj_name))
  StrCopy(my_obj_node.name,obj_name,ALL)
  AddTail(new_liste,my_obj_node)
  IF ListLen(list_obj)=0
      new_liste.head:=my_obj_node
      my_obj_node.pred:=0
  ENDIF
  myobj:=New(SIZEOF object3d)
  IF chunk=ID_VE3D THEN myobj.typeobj:=TYPE_OLDVERTEX ELSE myobj.typeobj:=TYPE_NEWVERTEX
  myobj.selected:=FALSE
  myobj.bounded:=FALSE
  ListAdd(list_obj,[myobj],1)
  my_database.nbrsobjs:=ListLen(list_obj)
  nbrs_pts:=Long(adr+4)
  myobj.nbrspts:=nbrs_pts
  my_database.totalpts:=my_database.totalpts+nbrs_pts
  myobj.datapts:=New(nbrs_pts*12)
  piv_pts:=myobj.datapts
  piv:=adr+8
  FOR a:=0 TO nbrs_pts-1
      x:=Mod(Long(piv),$FFFF)
      y:=Mod(Long(piv+4),$FFFF)
      z:=Mod(Long(piv+8),$FFFF)
      ^piv_pts:=x
      piv_pts:=piv_pts+4
      ^piv_pts:=y
      piv_pts:=piv_pts+4
      ^piv_pts:=z
      piv_pts:=piv_pts+4
      /*WriteF('X \d[12] Y \d[12] Z \d[12]\n',Mod(Long(piv),$FFFF),Mod(Long(piv+4),$FFFF),Mod(Long(piv+8),$FFFF))*/
      IF chunk=ID_VE3D THEN piv:=piv+16 ELSE piv:=piv+17
      /*piv:=piv+17*/
  ENDFOR
  nbrs_edges:=Long(piv)
  piv:=piv+4+Mul(nbrs_edges,8)
  nbrs_faces:=Long(piv)
  myobj.nbrsfaces:=nbrs_faces
  my_database.totalfaces:=my_database.totalfaces+nbrs_faces
  myobj.datafaces:=New(nbrs_faces*12)
  piv_pts:=myobj.datafaces
  piv:=piv+4
  FOR a:=0 TO nbrs_faces-1
      x:=Long(piv)-1
      y:=Long(piv+4)-1
      z:=Long(piv+8)-1
      ^piv_pts:=x
      piv_pts:=piv_pts+4
      ^piv_pts:=y
      piv_pts:=piv_pts+4
      ^piv_pts:=z
      piv_pts:=piv_pts+4
      piv:=piv+12
  ENDFOR
  Dispose(buf)
  Raise(OK_FICHIER)
EXCEPT
  RETURN exception
ENDPROC
PROC savegeofile() /*"savegeofile()"*/
/********************************************************************************
 * Para         : NONE
 * Return       : TRUE if ok,else FALSE (Cancel).
 * Description  : Save selected objects in Geo (Amiga) format.
 *******************************************************************************/
    DEF req:PTR TO rtfilerequester,req_string[108]:STRING
    DEF save_dir[256]:STRING
    DEF b_obj,b_pts,b_faces
    DEF n_obj,n_pts,n_faces
    DEF mobj:PTR TO object3d
    DEF p_pts,p_faces
    DEF s_handle,fichier_out[256]:STRING,adr_node:PTR TO ln,w_save
    IF req:=RtAllocRequestA(RT_FILEREQ,NIL)
        /*RtChangeReqAttrA(req,[RTFI_FLAGS,FREQF_NOFILES])*/
        IF RtFileRequestA(req,req_string,'3Dview v0.f',[RTFI_FLAGS,FREQF_NOFILES,RT_WINDOW,view_window,RT_LOCKWINDOW,TRUE,RTFI_OKTEXT,'Save GEO',TAG_DONE,0])
            StrCopy(save_dir,req.dir,ALL)
            AddPart(save_dir,'',256)
            RtFreeRequest(req)
        ELSE
            RETURN FALSE
        ENDIF
    ELSE
        RETURN FALSE
    ENDIF
    n_obj:=ListLen(list_obj)-1
    w_save:=init_req('Save Selected Object(s) ')
    FOR b_obj:=0 TO n_obj
        mobj:=list_obj[b_obj]
        IF mobj.selected=TRUE
            adr_node:=getadrnode(b_obj)
            StringF(fichier_out,'\s\s.geo',save_dir,adr_node.name)
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
            n_faces:=mobj.nbrsfaces
            p_faces:=mobj.datafaces
            FOR b_faces:=0 TO n_faces-1
                StringF(fichier_out,'3 \d \d \d 141\n',Long(p_faces),Long(p_faces+4),Long(p_faces+8))
                Write(s_handle,fichier_out,StrLen(fichier_out))
                p_faces:=p_faces+12
            ENDFOR
            Close(s_handle)
        ENDIF
    ENDFOR
    CloseW(w_save)
    RETURN TRUE
ENDPROC
PROC savedxffile() /*"savedxffile()"*/
/********************************************************************************
 * Para         : NONE
 * Return       : TRUE if ok,else FALSE (Cancel).
 * Description  : Save selected objects in Dxf (PC) format.
 *******************************************************************************/
    DEF req:PTR TO rtfilerequester,req_string[108]:STRING
    DEF save_dir[256]:STRING
    DEF b_obj,b_faces
    DEF n_obj,n_faces
    DEF mobj:PTR TO object3d
    DEF p_pts,p_faces
    DEF s_handle,fichier_out[256]:STRING,adr_node:PTR TO ln,w_save
    /*DEF x1,y1,z1,x2,y2,z2,x3,y3,z3*/
    DEF str_x1[20]:STRING,str_y1[20]:STRING,str_z1[20]:STRING
    DEF str_x2[20]:STRING,str_y2[20]:STRING,str_z2[20]:STRING
    DEF str_x3[20]:STRING,str_y3[20]:STRING,str_z3[20]:STRING
    IF req:=RtAllocRequestA(RT_FILEREQ,NIL)
        /*RtChangeReqAttrA(req,[RTFI_FLAGS,FREQF_NOFILES])*/
        IF RtFileRequestA(req,req_string,'3Dview v0.f',[RTFI_FLAGS,FREQF_NOFILES,RT_WINDOW,view_window,RT_LOCKWINDOW,TRUE,RTFI_OKTEXT,'Save DXF',TAG_DONE,0])
            StrCopy(save_dir,req.dir,ALL)
            AddPart(save_dir,'',256)
            RtFreeRequest(req)
        ELSE
            RETURN FALSE
        ENDIF
    ELSE
        RETURN FALSE
    ENDIF
    n_obj:=ListLen(list_obj)-1
    w_save:=init_req('Save Selected Object(s) ')
    FOR b_obj:=0 TO n_obj
        mobj:=list_obj[b_obj]
        IF mobj.selected=TRUE
            adr_node:=getadrnode(b_obj)
            StringF(fichier_out,'\s\s.dxf',save_dir,adr_node.name)
            s_handle:=Open(fichier_out,1006)
            Write(s_handle,'0\nSECTION\n2\nENTITIES\n0\n',23)
            p_pts:=mobj.datapts
            n_faces:=mobj.nbrsfaces
            p_faces:=mobj.datafaces
            FOR b_faces:=0 TO n_faces-1
                Write(s_handle,'3DFACE\n',7)
                Write(s_handle,'8\n',2)
                Write(s_handle,adr_node.name,StrLen(adr_node.name))
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
            Close(s_handle)
        ENDIF
    ENDFOR
    CloseW(w_save)
    RETURN TRUE
ENDPROC
PROC saverayfile() /*"saverayfile()"*/
/********************************************************************************
 * Para         : NONE
 * Return       : TRUE if ok,else FALSE (Cancel).
 * Description  : Save selected objects in Ray (amiga) format.
 *******************************************************************************/
    DEF req:PTR TO rtfilerequester,req_string[108]:STRING
    DEF save_dir[256]:STRING
    DEF b_obj,b_faces
    DEF n_obj,n_faces
    DEF mobj:PTR TO object3d
    DEF p_pts,p_faces
    DEF s_handle,fichier_out[256]:STRING,adr_node:PTR TO ln,w_save
    DEF str_1[20]:STRING
    DEF str_2[20]:STRING
    DEF str_3[20]:STRING
    IF req:=RtAllocRequestA(RT_FILEREQ,NIL)
        IF RtFileRequestA(req,req_string,'3Dview v0.f',[RTFI_FLAGS,FREQF_NOFILES,RT_WINDOW,view_window,RT_LOCKWINDOW,TRUE,RTFI_OKTEXT,'Save RAY',TAG_DONE,0])
            StrCopy(save_dir,req.dir,ALL)
            AddPart(save_dir,'',256)
            RtFreeRequest(req)
        ELSE
            RETURN FALSE
        ENDIF
    ELSE
        RETURN FALSE
    ENDIF
    n_obj:=ListLen(list_obj)-1
    w_save:=init_req('Save Selected Object(s) ')
    FOR b_obj:=0 TO n_obj
        mobj:=list_obj[b_obj]
        IF mobj.selected=TRUE
            adr_node:=getadrnode(b_obj)
            StringF(fichier_out,'\s\s.ray',save_dir,adr_node.name)
            s_handle:=Open(fichier_out,1006)
            p_pts:=mobj.datapts
            n_faces:=mobj.nbrsfaces
            p_faces:=mobj.datafaces
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
            Close(s_handle)
        ENDIF
    ENDFOR
    CloseW(w_save)
    RETURN TRUE
ENDPROC

