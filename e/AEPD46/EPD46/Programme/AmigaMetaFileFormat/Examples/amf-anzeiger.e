OPT OSVERSION=37
OPT STACK=100000

MODULE 'gadtools','libraries/gadtools','intuition/intuition',
       'intuition/screens', 'intuition/gadgetclass', 'graphics/text',
       '*amigametaformat','graphics/view','iffparse','dos/dos',
       'libraries/iffparse','asl','libraries/asl','*amigametaformat.const',
       'tools/constructors','exec/nodes','exec/lists','workbench/startup'

ENUM  NOSCREEN,NOWINDOW,NOGADLIB,NOAMFLIB,NOIFFLIB,NOASLLIB,NOMEM,
      INFO,
      LOADERR,SAVEERR,AMFERR,CDRERR

DEF window=NIL:PTR TO window,menus=NIL,infos=NIL:PTR TO gadget
DEF scr=NIL:PTR TO screen,visual=NIL,offy,tattr,list:PTR TO lh
DEF filename[256]:STRING

/**/PROC openscreen()
DEF result=FALSE
IF gadtoolsbase:=OpenLibrary('gadtools.library',37)
  IF scr:=OpenScreenTagList(NIL,
    [SA_LEFT,0,
     SA_TOP,0,
     SA_WIDTH,-1,
     SA_HEIGHT,-1,
     SA_DEPTH,4,
     SA_TITLE,'Show AmigaMetaFormat-files © Henk Jonas',
     SA_DISPLAYID,$8004,
     SA_PENS,[-1,0],
     NIL])
    LoadRGB4(scr.viewport,[$0888,  $0000,  $0FFF,  $027A,
                           $0F00,  $00F0,  $0FF0,  $000F,
                           $0F0F,  $00FF,  $0700,  $0070,
                           $0770,  $0007,  $0707,  $0077,
                           -1]:INT,16)
    IF visual:=GetVisualInfoA(scr,NIL)
      result:=TRUE
    ELSE
      message(NOSCREEN)
    ENDIF
  ELSE
    message(NOSCREEN)
  ENDIF
ELSE
  message(NOGADLIB)
ENDIF
offy:=scr.wbortop+Int(scr.rastport+58)+1
tattr:=['topaz.font',8,0,0]:textattr
ENDPROC result
/**/

/**/PROC closescreen()
  IF visual THEN FreeVisualInfo(visual)
  IF scr THEN CloseScreen(scr)
  IF gadtoolsbase THEN CloseLibrary(gadtoolsbase)
ENDPROC
/**/

/**/PROC openwindow()
DEF result=FALSE
IF menus:=CreateMenusA(
   [NM_TITLE,0,'Project',0,$0,0,0,
    NM_ITEM,0,'Load',0,$0,0,0,
    NM_SUB,0,'AMF',0,$0,0,0,
    NM_SUB,0,'CDR',0,$0,0,0,
    NM_ITEM,0,'Save as',0,$0,0,0,
    NM_SUB,0,'AMF',0,$0,0,0,
    NM_SUB,0,'AMF+PIC',0,$0+NM_ITEMDISABLED,0,0,
    NM_SUB,0,'ILBM',0,$0+NM_ITEMDISABLED,0,0,
    NM_SUB,0,'EPS',0,$0,0,0,
    NM_SUB,0,'GEM',0,$0,0,0,
    NM_SUB,0,'CGM',0,$0,0,0,
    NM_ITEM,0,NM_BARLABEL,0,$0,0,0,
    NM_ITEM,0,'About',0,$0,0,0,
    NM_ITEM,0,'Quit',0,$0,0,0,
    0,0,0,0,0,0,0]:newmenu,NIL)
  IF LayoutMenusA(menus,visual,[GTMN_NEWLOOKMENUS,TRUE,NIL])
    IF window:=OpenWindowTagList(NIL,
       [WA_LEFT,0,
        WA_TOP,offy,
        WA_WIDTH,scr.width,
        WA_HEIGHT,scr.height-offy,
        WA_IDCMP,$76E,
        WA_FLAGS,$100F,
        WA_TITLE,'chose a menuitem',
        WA_CUSTOMSCREEN,scr,
        WA_MINWIDTH,100,
        WA_MINHEIGHT,50,
        WA_MAXWIDTH,-1,
        WA_MAXHEIGHT,-1,
        WA_AUTOADJUST,1,
        WA_NEWLOOKMENUS,TRUE,
        NIL])
      IF SetMenuStrip(window,menus)
        Gt_RefreshWindow(window,NIL)
        result:=TRUE
      ELSE
        message(NOWINDOW)
      ENDIF
    ELSE
      message(NOWINDOW)
    ENDIF
  ELSE
    message(NOWINDOW)
  ENDIF
ELSE
  message(NOWINDOW)
ENDIF
ENDPROC result
/**/

/**/PROC closewindow()
  IF window THEN ClearMenuStrip(window)
  IF menus THEN FreeMenus(menus)
  IF window THEN CloseWindow(window)
ENDPROC
/**/

/**/PROC wait4message()
DEF mes:PTR TO intuimessage,type
DEF requester:PTR TO requester,loadfile=NIL
  requester:=New(SIZEOF requester)
  REPEAT
    type:=0
    IF mes:=Gt_GetIMsg(window.userport)
      type:=mes.class
      IF type=IDCMP_MENUPICK
        infos:=And(mes.code,$FFFF)
        IF infos=$0
          Request(requester,window)
          IF filereq('load','Please chose AMF-File')
            clearlist()
            IF loadfile:=Open(filename,MODE_OLDFILE)
              parse(loadfile)
              Close(loadfile)
            ELSE
              message(LOADERR)
            ENDIF
          ENDIF
          updatewindow()
          EndRequest(requester,window)
        ELSEIF infos=$800
          Request(requester,window)
          IF filereq('load','Please chose CDR-File')
            clearlist()
            IF loadfile:=Open(filename,MODE_OLDFILE)
              parsecdr(loadfile)
              Close(loadfile)
            ELSE
              message(LOADERR)
            ENDIF
          ENDIF
          updatewindow()
          EndRequest(requester,window)
        ELSEIF infos=$20
          Request(requester,window)
          IF filereq('save','Name of AMF-File')
            saveamf()
          ENDIF
          EndRequest(requester,window)
        ELSEIF infos=$820
          Request(requester,window)
          IF filereq('save','Name of AMF-File')
            saveamf2()
          ENDIF
          EndRequest(requester,window)
        ELSEIF infos=$1020
          Request(requester,window)
          IF filereq('save','Name of ILBM-File')
            saveilbm()
          ENDIF
          EndRequest(requester,window)
        ELSEIF infos=$1820
          Request(requester,window)
          IF filereq('save','Name of EPS-File')
            saveeps()
          ENDIF
          EndRequest(requester,window)
        ELSEIF infos=$2020
          Request(requester,window)
          IF filereq('save','Name of GEM-File')
            savegem()
          ENDIF
          EndRequest(requester,window)
        ELSEIF infos=$2820
          Request(requester,window)
          IF filereq('save','Name of CGM-File')
            savecgm()
          ENDIF
          EndRequest(requester,window)
        ELSEIF infos=$F860
          Request(requester,window)
          message(INFO)
          EndRequest(requester,window)
        ELSEIF infos=$F880
          type:=IDCMP_CLOSEWINDOW
        ELSEIF $F801
          logo()
        ELSE
          WriteF(' \h ',infos)
        ENDIF
      ELSEIF type=IDCMP_REFRESHWINDOW
        Gt_BeginRefresh(window)
        Gt_EndRefresh(window,TRUE)
        updatewindow()
        WHILE mes:=Gt_GetIMsg(window.userport)
          Gt_ReplyIMsg(mes)
        ENDWHILE
        type:=0
      ENDIF
      IF mes THEN Gt_ReplyIMsg(mes)
    ELSE
      WaitPort(window.userport)
    ENDIF
  UNTIL type=IDCMP_CLOSEWINDOW
ENDPROC type
/**/

/**/PROC updatewindow()
DEF amf,x,y,xx,yy,func,length,node:PTR TO ln
x:=window.borderleft
y:=window.bordertop
xx:=window.width-window.borderright-window.borderleft
yy:=window.height-window.borderbottom-window.bordertop
IF amf:=AmfOpen(4,[window.rport,x,y,xx,yy,scr::screen.viewport::viewport.colormap])
  node:=list.head
  WHILE node.succ
    func:=Long(node.name)
    length:=Long(node.name+4)
    IF AmfFunction(amf,node.name+8,func,length)<>0 THEN message(AMFERR)
    node:=node.succ
  ENDWHILE
  AmfClose(amf)
ENDIF
ENDPROC
/**/

/**/PROC saveamf()
DEF myiff:PTR TO iffhandle,amf,amffile,func,length,node:PTR TO ln
IF amffile:=Open(filename,MODE_NEWFILE)
  IF myiff:=AllocIFF()
    InitIFFasDOS(myiff)
    myiff.stream:=amffile
    OpenIFF(myiff,IFFF_WRITE)
    IF amf:=AmfOpen(3,[myiff,640,480])
      node:=list.head
      WHILE node.succ
        func:=Long(node.name)
        length:=Long(node.name+4)
        AmfFunction(amf,node.name+8,func,length)
        node:=node.succ
      ENDWHILE
      AmfClose(amf)
    ENDIF
    CloseIFF(myiff)
    FreeIFF(myiff)
  ENDIF
  Close(amffile)
ELSE
  message(SAVEERR)
ENDIF
ENDPROC
/**/

/**/PROC saveamf2()
DEF amf,x,y,xx,yy,func,length,node:PTR TO ln
x:=window.borderleft
y:=window.bordertop
xx:=window.width-window.borderright-1
yy:=window.height-window.borderbottom-1
IF amf:=AmfOpen(4,[window.rport,x,y,xx,yy,scr::screen.viewport::viewport.colormap])
  node:=list.head
  WHILE node.succ
    func:=Long(node.name)
    length:=Long(node.name+4)
    AmfFunction(amf,node.name+8,func,length)
    node:=node.succ
  ENDWHILE
  AmfClose(amf)
ENDIF
ENDPROC
/**/

/**/PROC saveeps()
DEF amf,epsfile,func,length,node:PTR TO ln
IF epsfile:=Open(filename,MODE_NEWFILE)
  IF amf:=AmfOpen(5,[epsfile])
    node:=list.head
    WHILE node.succ
      func:=Long(node.name)
      length:=Long(node.name+4)
      AmfFunction(amf,node.name+8,func,length)
      node:=node.succ
    ENDWHILE
    AmfClose(amf)
  ENDIF
  Close(epsfile)
ELSE
  message(SAVEERR)
ENDIF
ENDPROC
/**/

/**/PROC savegem()
DEF amf,gemfile,func,length,node:PTR TO ln
IF gemfile:=Open(filename,MODE_NEWFILE)
  IF amf:=AmfOpen(6,[gemfile])
    node:=list.head
    WHILE node.succ
      func:=Long(node.name)
      length:=Long(node.name+4)
      AmfFunction(amf,node.name+8,func,length)
      node:=node.succ
    ENDWHILE
    AmfClose(amf)
  ENDIF
  Close(gemfile)
ELSE
  message(SAVEERR)
ENDIF
ENDPROC
/**/

/**/PROC savecgm()
DEF amf,cgmfile,func,length,node:PTR TO ln
IF cgmfile:=Open(filename,MODE_NEWFILE)
  IF amf:=AmfOpen(7,[cgmfile])
    node:=list.head
    WHILE node.succ
      func:=Long(node.name)
      length:=Long(node.name+4)
      AmfFunction(amf,node.name+8,func,length)
      node:=node.succ
    ENDWHILE
    AmfClose(amf)
  ENDIF
  Close(cgmfile)
ELSE
  message(SAVEERR)
ENDIF
ENDPROC
/**/

/**/PROC saveilbm()
DEF amf,x,y,xx,yy,func,length,node:PTR TO ln
x:=window.borderleft
y:=window.bordertop
xx:=window.width-window.borderright-1
yy:=window.height-window.borderbottom-1
IF amf:=AmfOpen(4,[window.rport,x,y,xx,yy,scr::screen.viewport::viewport.colormap])
  node:=list.head
  WHILE node.succ
    func:=Long(node.name)
    length:=Long(node.name+4)
    AmfFunction(amf,node.name+8,func,length)
    node:=node.succ
  ENDWHILE
  AmfClose(amf)
ENDIF
ENDPROC
/**/

/**/PROC filereq(grund,was)
DEF req:PTR TO filerequester,ergebnis,flag
ergebnis:=0
IF aslbase:=OpenLibrary('asl.library',37)
  IF req:=AllocAslRequest(ASL_FILEREQUEST,NIL)
    IF (grund='speichern') THEN flag:=$20
    IF AslRequest(req,
      [ASL_WINDOW,window,
       ASL_OKTEXT,grund,
       ASL_HAIL,was,
       NIL])
      StrCopy(filename,req.drawer,ALL)
      AddPart(filename,req.file,255)
      ergebnis:=1
    ENDIF
    FreeAslRequest(req)
  ENDIF
  CloseLibrary(aslbase)
ELSE
  message(NOASLLIB)
ENDIF
ENDPROC(ergebnis)
/**/

/**/PROC parse(file)
DEF myiff=0:PTR TO iffhandle,funktion,count,array,anz
IF myiff:=AllocIFF()
  InitIFFasDOS(myiff)
  myiff.stream:=file
  IF 0=OpenIFF(myiff,IFFF_WRITE)
    IF 0=PropChunk(myiff,"AMFF","VERS")
      IF 0=StopChunk(myiff,"AMFF","BODY")
        IF 0=ParseIFF(myiff,IFFPARSE_SCAN)
          REPEAT
            anz:=ReadChunkBytes(myiff,{funktion},4)
            IF anz=4
              anz:=ReadChunkBytes(myiff,{count},4)
              IF anz=4
                array:=New(count*4)
                IF array
                  anz:=ReadChunkBytes(myiff,array,count*4)
                  IF anz=(count*4)
                    myamf(array,funktion,count)
                  ELSE
                    anz:=-1
                  ENDIF
                  Dispose(array)
                ELSE
                  anz:=-1
                ENDIF
              ELSE
                anz:=-1
              ENDIF
            ELSE
              anz:=-1
            ENDIF
          UNTIL (anz<0)
        ELSE
          message(AMFERR)
        ENDIF
      ENDIF
    ELSE
      message(AMFERR)
    ENDIF
    CloseIFF(myiff)
  ELSE
    message(AMFERR)
  ENDIF
  FreeIFF(myiff)
ELSE
  message(NOMEM)
ENDIF
ENDPROC
/**/

/**/PROC parsecdr(file)
DEF char,a,b,k,lenght,chars[4]:ARRAY OF CHAR,tmpfile
Fread(file,chars,4,1)
IF (chars[0]="R") AND (chars[1]="I") AND (chars[2]="F") AND (chars[3]="F")
  lenght:=FgetC(file)+(256*(FgetC(file)+(256*(FgetC(file)+(256*FgetC(file))))))
  Fread(file,chars,4,1)
  WriteF('RIFF Länge=\d \s\n',lenght,chars)
  IF char<>-1 THEN parsecdr(file)          -> noch nicht am FileEnde
ELSEIF (chars[0]="L") AND (chars[1]="I") AND (chars[2]="S") AND (chars[3]="T")
  lenght:=FgetC(file)+(256*(FgetC(file)+(256*(FgetC(file)+(256*FgetC(file))))))
  Fread(file,chars,4,1)
  WriteF('LIST Länge=\d \s\n',lenght,chars)
  IF char<>-1 THEN parsecdr(file)          -> noch nicht am FileEnde
ELSEIF (chars[0]="v") AND (chars[1]="r") AND (chars[2]="s") AND (chars[3]="n")
  lenght:=FgetC(file)+(256*(FgetC(file)+(256*(FgetC(file)+(256*FgetC(file))))))
  IF lenght=2
    a:=FgetC(file)
    b:=FgetC(file)
    WriteF('Version=\d.\d\n',b,a)
  ELSE
    k:=1
    REPEAT
      char:=FgetC(file)
      k++
    UNTIL (char=-1) OR (k>lenght)
    IF (lenght/2*2)<>lenght THEN FgetC(file) -> beginnt immer an Wortgrenze
  ENDIF
  IF char<>-1 THEN parsecdr(file)          -> noch nicht am FileEnde
ELSEIF (chars[0]="i") AND (chars[1]="d") AND (chars[2]=" ") AND (chars[3]=" ")
  lenght:=FgetC(file)+(256*(FgetC(file)+(256*(FgetC(file)+(256*FgetC(file))))))
  IF lenght=2
    WriteF('Seite=\d\n',FgetC(file)+(256*FgetC(file)))
  ELSE
    k:=1
    REPEAT
      char:=FgetC(file)
      k++
    UNTIL (char=-1) OR (k>lenght)
    IF (lenght/2*2)<>lenght THEN FgetC(file) -> beginnt immer an Wortgrenze
  ENDIF
  IF char<>-1 THEN parsecdr(file)          -> noch nicht am FileEnde
ELSEIF (chars[0]="i") AND (chars[1]="m") AND (chars[2]="h") AND (chars[3]="d")
  lenght:=FgetC(file)+(256*(FgetC(file)+(256*(FgetC(file)+(256*FgetC(file))))))
  WriteF('Preview-File Länge=\d\n',lenght)
  k:=1
  IF tmpfile:=Open('t:preview.bmp',MODE_NEWFILE)
    REPEAT
      char:=FgetC(file)
      FputC(tmpfile,char)
      k++
    UNTIL (char=-1) OR (k>lenght)
    Close(tmpfile)
    Execute('MultiView t:preview.bmp',NIL,NIL)
  ENDIF
  IF (lenght/2*2)<>lenght THEN FgetC(file) -> beginnt immer an Wortgrenze
  IF char<>-1 THEN parsecdr(file)          -> noch nicht am FileEnde
ELSE
  lenght:=FgetC(file)+(256*(FgetC(file)+(256*(FgetC(file)+(256*FgetC(file))))))
  WriteF('\s Länge=\d\n',chars,lenght)
  k:=1
  REPEAT
    char:=FgetC(file)
    k++
  UNTIL (char=-1) OR (k>lenght)
  IF (lenght/2*2)<>lenght THEN FgetC(file) -> beginnt immer an Wortgrenze
  IF char<>-1 THEN parsecdr(file)          -> noch nicht am FileEnde
ENDIF
ENDPROC
/**/
  
/**/PROC logo()
DEF k,j1,j2,j3,j4,j5,j6
->SETBGPEN
myamf([-1,-1,-1],AMF_SETBGPEN,3)
->CLEAR_REGION
myamf([0,0,32767,32767],AMF_CLEAR_REGION,4)
FOR k:=0 TO 15
  ->SETFGPEN
  myamf([Shl(16*k,24)+Shl(16*k,16)+Shl(16*k,8)+(k*16),0,0],AMF_SETFGPEN,3)
  ->FILL_POLY
  IF k=0
    myamf([6000,6000,7000,7000,8000,7000,9000,6000,8000,5000,7000,5000],AMF_FILL_POLY,12)
  ELSE
    j1:=9000+(k*1000)
    j2:=8000+(k*1000)
    j3:=9000+(k*1000)
    j4:=10000+(k*1000)
    j5:=9000+(k*1000)
    j6:=8000+(k*1000)
    myamf([j1,6000,j2,7000,j3,7000,j4,6000,j5,5000,j6,5000],AMF_FILL_POLY,12)
  ENDIF
  ->SETFGPEN
  myamf([0,Shl(16*k,24)+Shl(16*k,16)+Shl(16*k,8)+(k*16),0],AMF_SETFGPEN,3)
  ->FILL_POLY
  IF k=0
    myamf([6000,10000,7000,11000,8000,11000,9000,10000,8000,9000,7000,9000],AMF_FILL_POLY,12)
  ELSE
    j1:=9000+(k*1000)
    j2:=8000+(k*1000)
    j3:=9000+(k*1000)
    j4:=10000+(k*1000)
    j5:=9000+(k*1000)
    j6:=8000+(k*1000)
    myamf([j1,10000,j2,11000,j3,11000,j4,10000,j5,9000,j6,9000],AMF_FILL_POLY,12)
  ENDIF
  ->SETFGPEN
  myamf([0,0,Shl(16*k,24)+Shl(16*k,16)+Shl(16*k,8)+(16*k)],AMF_SETFGPEN,3)
  ->FILL_POLY
  IF k=0
    myamf([6000,14000,7000,15000,8000,15000,9000,14000,8000,13000,7000,13000],AMF_FILL_POLY,12)
  ELSE
    j1:=9000+(k*1000)
    j2:=8000+(k*1000)
    j3:=9000+(k*1000)
    j4:=10000+(k*1000)
    j5:=9000+(k*1000)
    j6:=8000+(k*1000)
    myamf([j1,14000,j2,15000,j3,15000,j4,14000,j5,13000,j6,13000],AMF_FILL_POLY,12)
  ENDIF
ENDFOR
->SETFGPEN
myamf([0,0,0],AMF_SETFGPEN,3)
->SETMARKSIZE
myamf([1000],AMF_SETMARKSIZE,1)
FOR k:=0 TO 6
  ->SETMARKTYPE
  myamf([k],AMF_SETMARKTYPE,1)
  ->MARK
  myamf([k*2000+10000,20000],AMF_MARK,2)
ENDFOR
FOR k:=0 TO 5
  ->SETLINEPAT
  myamf([k],AMF_SETLINEPAT,1)
  ->LINE
  myamf([k*4000+5000,22000,k*4000+9000,22000],AMF_LINE,4)
ENDFOR
->SETLINEPAT
myamf([0],AMF_SETLINEPAT,1)
FOR k:=0 TO 6
  ->SETFILLPAT
  myamf([k],AMF_SETFILLPAT,1)
  ->FILL_BOX
  myamf([k*2000+10000,24000,k*2000+11000,25000],AMF_FILL_BOX,4)
ENDFOR
->SETFILLPAT
myamf([0],AMF_SETFILLPAT,1)
->SETFGPEN
myamf([-1,0,0],AMF_SETFGPEN,3)
->FILL_PIE
myamf([7000,31000,3000,3000,45,135],AMF_FILL_PIE,6)
->SETFGPEN
myamf([0,-1,0],AMF_SETFGPEN,3)
->FILL_ROUNDED
myamf([10000,28000,13000,31000],AMF_FILL_ROUNDED,4)
->SETFGPEN
myamf([-1,-1,0],AMF_SETFGPEN,3)
->POLYGON
myamf([14000,31000,15500,28000,17000,31000,14000,29000,17000,29000,14000,31000],AMF_POLYGON,12)
->SETFGPEN
myamf([0,0,-1],AMF_SETFGPEN,3)
->CURVE
myamf([18000,30000,19000,28000,20000,31000,21000,29000],AMF_CURVE,8)
->SETFGPEN
myamf([-1,0,-1],AMF_SETFGPEN,3)
->FILL_ELLIPSE
myamf([23000,29500,1000,1500],AMF_FILL_ELLIPSE,4)
->SETFGPEN
myamf([0,-1,-1],AMF_SETFGPEN,3)
->ARC
myamf([26500,29500,1500,1500,0,180],AMF_ARC,6)
ENDPROC
/**/

/**/PROC myamf(array:PTR TO LONG,funktion,count)
DEF k,feld:PTR TO LONG,node:PTR TO ln
  IF feld:=New(count*4+8)
    feld[0]:=funktion
    feld[1]:=count
    FOR k:=0 TO count-1 DO feld[2+k]:=array[k]
    node:=newnode()
    node.name:=feld
    Enqueue(list,node)
  ENDIF
ENDPROC
/**/

/**/PROC clearlist()
DEF newnode,node:PTR TO ln
  node:=list.head
  WHILE node.succ
    newnode:=node.succ
    Remove(node)
    IF node.name THEN Dispose(node.name)
    node:=newnode
  ENDWHILE
  EraseRect(window.rport,window.borderleft,window.bordertop,window.width-window.borderright-1,window.height-window.borderbottom-1)
ENDPROC
/**/

/**/PROC message(number)
EasyRequestArgs(window,[SIZEOF easystruct,0,NIL,
   ListItem([
   'Can`t open "Screen"!',
   'Can`t open "Window"!',
   'Where is "gadtools.library 37+"?',
   'Where is "amigametaformat.library 2+"?',
   'Where is "iffparse.library 37+"?',
   'Where is "asl.library 37+"?',
   'Not enough memory!',
   'Show and convert AMF-files in GEM, CGM and EPS-files.\nWritten in E by Henk Jonas.\nBinarys and sources are Public Domain.\n\nThe CDR-part are still in progress.',
   'Can`t found!',
   'Can`t save!',
   'Warning!\nSome Errors in AMF-file.',
   'Warning!\nSome Errors in AMF-file.',
   NIL
   ],number),
   'OK'],NIL,NIL)
ENDPROC
/**/

PROC main()
DEF wb:PTR TO wbstartup,args:PTR TO wbarg,wbargs=FALSE,amffile
  IF wb:=wbmessage
    args:=wb.arglist
    IF wb.numargs>1
      args++
      NameFromLock(args.lock,filename,255)
      AddPart(filename,args.name,255)
      wbargs:=TRUE
    ENDIF
  ENDIF
  IF openscreen()
    IF amigametaformatbase:=OpenLibrary('amigametaformat.library',2)
      IF iffparsebase:=OpenLibrary('iffparse.library',37)
        IF list:=newlist()
          IF openwindow()
            IF wbargs
              IF amffile:=Open(filename,MODE_OLDFILE)
                parse(amffile)
                Close(amffile)
              ELSE
                message(LOADERR)
              ENDIF
            ELSE
              logo()
            ENDIF
            updatewindow()
            wait4message()
          ENDIF
        ENDIF
        closewindow()
        CloseLibrary(iffparsebase)
      ELSE
        message(NOIFFLIB)
      ENDIF
      CloseLibrary(amigametaformatbase)
    ELSE
      message(NOAMFLIB)
    ENDIF
  ENDIF
  closescreen()
ENDPROC

