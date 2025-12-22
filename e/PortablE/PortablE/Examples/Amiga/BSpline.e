/* An old E example converted to PortablE.
   From http://aminet.net/package/dev/e/bspline10 */

/*
** Custom B-Spline class in E. ©1996 Kristofer Maad, m93kma@student.tdb.uu.se
*/

OPT POINTER
OPT PREPROCESS

MODULE 'dos', 'exec', 'graphics', 'intuition'
MODULE 'muimaster', 'libraries/mui', 'libraries/muip',
       'mui/muicustomclass', 'amigalib/boopsi',
       'intuition/classes', 'intuition/classusr',
       'intuition/screens', 'intuition/intuition',
       'utility/tagitem', 'utility', 'utility/utility',
       'dos/dos', 'devices/inputevent',
       'console', 'exec/io',
       'graphics/gfx', 'graphics/rastport'

CONST MAXPTS=20

CONST MUIA_BSpline_Subdivision    =TAG_USER OR 0
CONST MUIA_BSpline_DragSubdivision=TAG_USER OR 1
CONST MUIA_BSpline_ShowPoints     =TAG_USER OR 2
CONST MUIA_BSpline_Editable       =TAG_USER OR 3

ENUM DRAW,ERASE,RUBBERBAND

/*
** Instance data for the custom class
*/

OBJECT mydata
    xc:PTR TO VALUE
    yc:PTR TO VALUE
    mi:PTR TO VALUE
    subdiv
    dragsubdiv
    editable
    showpts
    numpts
    selptind
    dragging
    lazydraw
    ox
    oy
    dx
    dy
    backgroundcolor
    drawcurvecolor
    drawselectcolor
    curvecolor
    selectcolor
    xormode
ENDOBJECT


/*
** Low-level application helper functions
*/

PROC setcurvemode(data:PTR TO mydata,mode)
    SELECT mode
        CASE DRAW
            data.curvecolor:=data.drawcurvecolor
            data.selectcolor:=data.drawselectcolor
            data.xormode:=FALSE
        CASE ERASE
            data.curvecolor:=data.backgroundcolor
            data.selectcolor:=data.backgroundcolor
            data.xormode:=FALSE
        CASE RUBBERBAND
            data.curvecolor:=Xor(data.drawcurvecolor,data.backgroundcolor)
            data.selectcolor:=Xor(data.drawselectcolor,data.backgroundcolor)
            data.xormode:=TRUE
    ENDSELECT
ENDPROC

PROC getindex(data:PTR TO mydata,x,y) RETURNS i
    DEF px,py,ps
    FOR i:=data.numpts-1 TO 0 STEP -1
        px:=data.xc[i]
        py:=data.yc[i]
        ps:=ptsize(data.mi[i])
        IF ((x >= (px-ps)) AND (x <= (px+ps)) AND (y >= (py-ps)) AND (y <= (py+ps)))
            RETURN i
        ENDIF
    ENDFOR
    RETURN -1
ENDPROC

PROC addpt(data:PTR TO mydata,index,x,y)
    DEF i
    IF data.numpts=MAXPTS THEN RETURN
    data.numpts:=data.numpts+1
    FOR i:=data.numpts-1 TO index+1 STEP -1
        data.xc[i]:=data.xc[i-1]
        data.yc[i]:=data.yc[i-1]
        data.mi[i]:=data.mi[i-1]
    ENDFOR
    data.xc[index]:=x
    data.yc[index]:=y
    data.mi[index]:=1
    data.selptind:=index
ENDPROC

PROC removept(data:PTR TO mydata,index)
    DEF i
    FOR i:=index TO data.numpts-2
        data.xc[i]:=data.xc[i+1]
        data.yc[i]:=data.yc[i+1]
        data.mi[i]:=data.mi[i+1]
    ENDFOR
    data.numpts:=data.numpts-1
    data.selptind:=-1
ENDPROC

PROC fcube(x:FLOAT) IS x*x*x

PROC fsqr(x:FLOAT) IS x*x

PROC bfunc(tau:FLOAT) RETURNS b:FLOAT
    IF (tau<-2.0) OR (tau>2.0) THEN RETURN 0

    IF (tau<=-1.0)
        RETURN fcube(2.0 + tau)/6.0
    ELSE IF (tau<=0.0)
        RETURN (4.0 - (6.0*fsqr(tau)) - (3.0*fcube(tau)))/6.0
    ELSE IF (tau<=1.0)
        RETURN (4.0 - (6.0*fsqr(tau)) + (3.0*fcube(tau)))/6.0
    ELSE
        RETURN fcube(2.0 - tau)/6.0
    ENDIF
ENDPROC

PROC ptsize(mi) IS 1+mi

PROC startdragging(cl:PTR TO iclass,obj:PTR TO mydata)
    DEF data:PTR TO mydata
    data:=INST_DATA(cl,obj)::mydata
    Mui_RequestIDCMP(obj!!PTR,IDCMP_MOUSEMOVE)
    data.dragging:=TRUE
    data.lazydraw:=FALSE
ENDPROC

PROC stopdragging(cl:PTR TO iclass,obj:PTR TO mydata)
    DEF data:PTR TO mydata
    data:=INST_DATA(cl,obj)::mydata
    Mui_RejectIDCMP(obj!!PTR,IDCMP_MOUSEMOVE)
    data.dragging:=FALSE
    data.lazydraw:=FALSE
ENDPROC

/*
** High-level application helper functions
*/

PROC addptfirst(cl:PTR TO iclass,obj:PTR TO mydata,x,y)
    DEF data:PTR TO mydata
    data:=INST_DATA(cl,obj)::mydata
    IF ((x >= 0) AND (x < _mwidth(obj)) AND (y >= 0)  AND (y < _mheight(obj)))
        setcurvemode(data,ERASE)
        Mui_Redraw(obj!!PTR,MADF_DRAWUPDATE)
        addpt(data,0,x,y)
        setcurvemode(data,DRAW)
        Mui_Redraw(obj!!PTR,MADF_DRAWUPDATE)
    ENDIF
ENDPROC

PROC addptlast(cl:PTR TO iclass,obj:PTR TO mydata,x,y)
    DEF data:PTR TO mydata
    data:=INST_DATA(cl,obj)::mydata
    IF ((x >= 0) AND (x < _mwidth(obj)) AND (y >= 0)  AND (y < _mheight(obj)))
        setcurvemode(data,ERASE)
        Mui_Redraw(obj!!PTR,MADF_DRAWUPDATE)
        addpt(data,data.numpts,x,y)
        setcurvemode(data,DRAW)
        Mui_Redraw(obj!!PTR,MADF_DRAWUPDATE)
    ENDIF
ENDPROC

PROC addptbefore(cl:PTR TO iclass,obj:PTR TO mydata,x,y)
    DEF data:PTR TO mydata
    data:=INST_DATA(cl,obj)::mydata
    IF ((data.selptind<>-1) AND (x >= 0) AND (x < _mwidth(obj)) AND (y >= 0)  AND (y < _mheight(obj)))
        setcurvemode(data,ERASE)
        Mui_Redraw(obj!!PTR,MADF_DRAWUPDATE)
        addpt(data,data.selptind,x,y)
        setcurvemode(data,DRAW)
        Mui_Redraw(obj!!PTR,MADF_DRAWUPDATE)
    ENDIF
ENDPROC

PROC addptafter(cl:PTR TO iclass,obj:PTR TO mydata,x,y)
    DEF data:PTR TO mydata
    data:=INST_DATA(cl,obj)::mydata
    IF ((data.selptind<>-1) AND (x >= 0) AND (x < _mwidth(obj)) AND (y >= 0)  AND (y < _mheight(obj)))
        setcurvemode(data,ERASE)
        Mui_Redraw(obj!!PTR,MADF_DRAWUPDATE)
        addpt(data,data.selptind+1,x,y)
        setcurvemode(data,DRAW)
        Mui_Redraw(obj!!PTR,MADF_DRAWUPDATE)
    ENDIF
ENDPROC

PROC changeselptmultind(cl:PTR TO iclass,obj:PTR TO mydata)
    DEF data:PTR TO mydata,i
    data:=INST_DATA(cl,obj)::mydata
    i:=data.selptind
    IF i<>-1
        setcurvemode(data,ERASE)
        Mui_Redraw(obj!!PTR,MADF_DRAWUPDATE)
        data.mi[i]:=data.mi[i]+1
        IF data.mi[i]>3 THEN data.mi[i]:=data.mi[i]-3
        setcurvemode(data,DRAW)
        Mui_Redraw(obj!!PTR,MADF_DRAWUPDATE)
    ENDIF
ENDPROC

PROC removeselpt(cl:PTR TO iclass,obj:PTR TO mydata)
    DEF data:PTR TO mydata,i
    data:=INST_DATA(cl,obj)::mydata
    i:=data.selptind
    IF i<>-1
        setcurvemode(data,ERASE)
        Mui_Redraw(obj!!PTR,MADF_DRAWUPDATE)
        removept(data,i)
        setcurvemode(data,DRAW)
        Mui_Redraw(obj!!PTR,MADF_DRAWUPDATE)
    ENDIF
ENDPROC


/*
** Functions implementing object methods
*/

PROC mNew(cl:PTR TO iclass,obj:PTR TO INTUIOBJECT,msg:PTR TO opset)
    DEF data:PTR TO mydata
    DEF tags REF_TO ARRAY OF tagitem
    DEF tag:PTR TO tagitem
    DEF t

    IF (obj:=doSuperMethodA(cl,obj,msg)!!PTR)=NIL THEN RETURN NIL

    data:=INST_DATA(cl,obj)::mydata

    NEW data.xc[MAXPTS]
    NEW data.yc[MAXPTS]
    NEW data.mi[MAXPTS]

    IF (data.xc=NIL) OR (data.yc=NIL) OR (data.mi=NIL) THEN Print('Baap!\n')

    data.subdiv:=10
    data.dragsubdiv:=5
    data.showpts:=TRUE
    data.editable:=TRUE
    data.numpts:=0
    data.selptind:=-1
    data.dragging:=FALSE

    tags[0]:=msg.attrlist
    WHILE (tag:=NextTagItem(tags))
        t:=tag.tag
        SELECT t
            CASE MUIA_BSpline_Subdivision
                data.subdiv:=tag.data
            CASE MUIA_BSpline_DragSubdivision
                data.dragsubdiv:=tag.data
            CASE MUIA_BSpline_ShowPoints
                data.showpts:=tag.data
            CASE MUIA_BSpline_Editable
                data.editable:=tag.data
        ENDSELECT
    ENDWHILE
ENDPROC obj

PROC mSet(cl:PTR TO iclass,obj:PTR TO INTUIOBJECT,msg:PTR TO opset)
    DEF data:PTR TO mydata
    DEF tags REF_TO ARRAY OF tagitem
    DEF tag:PTR TO tagitem
    DEF t

    data:=INST_DATA(cl,obj)::mydata

    tags[0]:=msg.attrlist
    WHILE (tag:=NextTagItem(tags))
        t:=tag.tag
        SELECT t
            CASE MUIA_BSpline_Subdivision
                IF data.subdiv<>tag.data
                    IF Not(data.xormode)
                        setcurvemode(data,ERASE)
                        Mui_Redraw(obj!!PTR,MADF_DRAWUPDATE)
                    ENDIF
                    data.subdiv:=tag.data
                    IF Not(data.xormode)
                        setcurvemode(data,DRAW)
                        Mui_Redraw(obj!!PTR,MADF_DRAWUPDATE)
                    ENDIF
                ENDIF
            CASE MUIA_BSpline_DragSubdivision
                IF data.dragsubdiv<>tag.data
                    IF data.lazydraw
                        data.lazydraw:=FALSE
                        Mui_Redraw(obj!!PTR,MADF_DRAWUPDATE)
                        data.dragsubdiv:=tag.data
                        Mui_Redraw(obj!!PTR,MADF_DRAWUPDATE)
                        data.lazydraw:=TRUE
                    ELSE
                        data.dragsubdiv:=tag.data
                    ENDIF
                ENDIF
            CASE MUIA_BSpline_ShowPoints
                IF data.showpts<>tag.data
                    IF data.xormode
                        stopdragging(cl,obj!!PTR)
                        Mui_Redraw(obj!!PTR,MADF_DRAWUPDATE)
                        data.xc[data.selptind]:=data.ox
                        data.yc[data.selptind]:=data.oy
                    ELSE IF data.showpts
                        setcurvemode(data,ERASE)
                        Mui_Redraw(obj!!PTR,MADF_DRAWUPDATE)
                    ENDIF
                    data.showpts:=tag.data
                    setcurvemode(data,DRAW)
                    Mui_Redraw(obj!!PTR,MADF_DRAWUPDATE)
                ENDIF
            CASE MUIA_BSpline_Editable
                IF data.editable<>tag.data
                    IF data.xormode
                        stopdragging(cl,obj!!PTR)
                        Mui_Redraw(obj!!PTR,MADF_DRAWUPDATE)
                        data.xc[data.selptind]:=data.ox
                        data.yc[data.selptind]:=data.oy
                    ENDIF
                    data.editable:=tag.data
                    setcurvemode(data,DRAW)
                    Mui_Redraw(obj!!PTR,MADF_DRAWUPDATE)
                ENDIF
        ENDSELECT
    ENDWHILE

ENDPROC doSuperMethodA(cl,obj,msg)


PROC mAskMinMax(cl:PTR TO iclass,obj:PTR TO INTUIOBJECT,msg:PTR TO muip_askminmax)
    doSuperMethodA(cl,obj,msg)

    msg.minmaxinfo.minwidth := msg.minmaxinfo.minwidth + 400
    msg.minmaxinfo.defwidth := msg.minmaxinfo.defwidth + 400
    msg.minmaxinfo.maxwidth := msg.minmaxinfo.maxwidth + 400

    msg.minmaxinfo.minheight := msg.minmaxinfo.minheight + 400
    msg.minmaxinfo.defheight := msg.minmaxinfo.defheight + 400
    msg.minmaxinfo.maxheight := msg.minmaxinfo.maxheight + 400
ENDPROC 0

PROC mDraw(cl:PTR TO iclass,obj:PTR TO mydata,msg:PTR TO muip_draw)
    DEF data:PTR TO mydata
    DEF index,firstindex,lastindex,i,j,ps,n,x:FLOAT,y:FLOAT,ox,oy,t:FLOAT,istart,iend,lazydraw,subdiv
    DEF left,top
    DEF cleft:INT,ctop:INT,cright:INT,cbottom:INT,cwidth:INT,cheight:INT,cliphandle:ARRAY
    DEF xcb[200]:ARRAY OF VALUE
    DEF ycb[200]:ARRAY OF VALUE

    data:=INST_DATA(cl,obj)::mydata

    SetDrMd(_rp(obj),1)
    SetWriteMask(_rp(obj),-1)
    doSuperMethodA(cl,obj!!PTR,msg)

    IF (msg.flags AND MADF_DRAWUPDATE) /* called from our input method */
        lazydraw:=data.lazydraw
    ELSE IF (msg.flags AND MADF_DRAWOBJECT)
        SetAPen(_rp(obj),data.backgroundcolor)
        RectFill(_rp(obj),_mleft(obj),_mtop(obj),_mright(obj),_mbottom(obj))
        lazydraw:=FALSE
    ELSE
        RETURN 0
    ENDIF

    left:=_mleft(obj)
    top:=_mtop(obj)

    cleft:=_mleft(obj)
    ctop:=_mtop(obj)
    cright:=_mright(obj)
    cbottom:=_mbottom(obj)

    IF cleft<0 THEN cleft:=0
    IF ctop<0 THEN ctop:=0

    cwidth:=cright-cleft+1 !!INT
    cheight:=cbottom-ctop+1 !!INT

    cliphandle:=Mui_AddClipping(muiRenderInfo(obj),cleft,ctop,cwidth,cheight)

    SetDrMd(_rp(obj),IF data.xormode THEN 2 ELSE 1)
    subdiv:=IF data.xormode THEN data.dragsubdiv ELSE data.subdiv

    IF data.showpts
        IF lazydraw
            i:=data.selptind
            x:=data.xc[i]+left
            y:=data.yc[i]+top
            ps:=ptsize(data.mi[i])
            IF data.xormode
                SetWriteMask(_rp(obj),data.selectcolor)
            ELSE
                SetAPen(_rp(obj),data.selectcolor)
            ENDIF
            RectFill(_rp(obj),x-ps!!VALUE,y-ps!!VALUE,x+ps!!VALUE,y+ps!!VALUE)
            IF data.xormode
                SetWriteMask(_rp(obj),data.curvecolor)
            ELSE
                SetAPen(_rp(obj),data.curvecolor)
            ENDIF
        ELSE
            IF data.xormode
                SetWriteMask(_rp(obj),data.curvecolor)
            ELSE
                SetAPen(_rp(obj),data.curvecolor)
            ENDIF
            FOR i:=0 TO data.numpts-1
                x:=data.xc[i]+left
                y:=data.yc[i]+top
                ps:=ptsize(data.mi[i])
                IF data.editable AND (data.selptind=i)
                    IF data.xormode
                        SetWriteMask(_rp(obj),data.selectcolor)
                    ELSE
                        SetAPen(_rp(obj),data.selectcolor)
                    ENDIF
                    RectFill(_rp(obj),x-ps!!VALUE,y-ps!!VALUE,x+ps!!VALUE,y+ps!!VALUE)
                    IF data.xormode
                        SetWriteMask(_rp(obj),data.curvecolor)
                    ELSE
                        SetAPen(_rp(obj),data.curvecolor)
                    ENDIF
                ELSE
                    RectFill(_rp(obj),x-ps!!VALUE,y-ps!!VALUE,x+ps!!VALUE,y+ps!!VALUE)
                ENDIF
            ENDFOR
        ENDIF
    ELSE
        IF data.xormode
            SetWriteMask(_rp(obj),data.curvecolor)
        ELSE
            SetAPen(_rp(obj),data.curvecolor)
        ENDIF
    ENDIF

    index:=0

    FOR i:=0 TO data.numpts-1
        IF i=data.selptind THEN firstindex:=index
        FOR j:=1 TO data.mi[i]
            xcb[index +1]:=data.xc[i]
            ycb[index +1]:=data.yc[i]
            index:=index+1
        ENDFOR
        IF i=data.selptind THEN lastindex:=index-1
    ENDFOR

    n:=index-1

    xcb[-1 +1]:=(2*xcb[0 +1])-xcb[1 +1]
    ycb[-1 +1]:=(2*ycb[0 +1])-ycb[1 +1]

    xcb[n+1 +1]:=(2*xcb[n +1])-xcb[n-1 +1]
    ycb[n+1 +1]:=(2*ycb[n +1])-ycb[n-1 +1]

    ox:=-1

    IF lazydraw
        istart:=firstindex-2
        IF istart<0 THEN istart:=0
        iend:=lastindex+2
        IF iend>n THEN iend:=n
        istart:=istart*subdiv
        iend:=iend*subdiv
    ELSE
        istart:=0
        iend:=n*subdiv
    ENDIF

    IF(n>=1)
        FOR j:=istart TO iend
            t:=j!!FLOAT/subdiv
            x:=0.0
            y:=0.0
            FOR i:=Ffloor(t-1.0)!!VALUE TO Fceil(t+1.0)!!VALUE
                x:=x+(xcb[i +1]*bfunc(t-i))
                y:=y+(ycb[i +1]*bfunc(t-i))
            ENDFOR
            IF ox<>-1
                Move(_rp(obj),ox+left!!INT,oy+top!!INT)
                Draw(_rp(obj),x+left!!VALUE,y+top!!VALUE)
            ENDIF
            ox:=x!!VALUE
            oy:=y!!VALUE
            IF data.xormode AND (j<>istart) AND (j<>iend) THEN WritePixel(_rp(obj),ox+left,oy+top)
        ENDFOR
    ENDIF

    Mui_RemoveClipping(muiRenderInfo(obj),cliphandle)

    SetDrMd(_rp(obj),1)
    SetWriteMask(_rp(obj),-1)
ENDPROC 0


PROC mSetup(cl:PTR TO iclass,obj:PTR TO mydata,msg:PTR TO muip_handleinput)
    DEF data:PTR TO mydata
    data:=INST_DATA(cl,obj)::mydata

    IF (doSuperMethodA(cl,obj!!PTR,msg)=FALSE) THEN RETURN FALSE

    data.backgroundcolor:=_dri(obj).pens[SHINEPEN]
    data.drawcurvecolor:=_dri(obj).pens[SHADOWPEN]
    data.drawselectcolor:=_dri(obj).pens[FILLPEN]

    setcurvemode(data,DRAW)

    Mui_RequestIDCMP(obj!!PTR,IDCMP_MOUSEBUTTONS OR IDCMP_RAWKEY)
ENDPROC MUI_TRUE

PROC mCleanup(cl:PTR TO iclass,obj:PTR TO INTUIOBJECT,msg:PTR TO muip_handleinput)
    Mui_RejectIDCMP(obj,IDCMP_MOUSEBUTTONS OR IDCMP_RAWKEY)
ENDPROC doSuperMethodA(cl,obj,msg)

PROC mHandleInput(cl:PTR TO iclass,obj:PTR TO mydata,msg:PTR TO muip_handleinput) RETURNS value
    DEF data:PTR TO mydata
    DEF x,y,i
    DEF class
    DEF ievent:inputevent
    DEF str[80]:ARRAY OF CHAR
    DEF key

    data:=INST_DATA(cl,obj)::mydata    

    IF (msg.imsg <> NIL)
        class:=msg.imsg.class

        IF data.dragging
            SELECT class
                CASE IDCMP_MOUSEBUTTONS
                    IF (msg.imsg.code=SELECTUP) OR (msg.imsg.code=MENUDOWN)
                        IF data.lazydraw
                            data.lazydraw:=FALSE
                            setcurvemode(data,RUBBERBAND)
                            Mui_Redraw(obj!!PTR,MADF_DRAWUPDATE)
                            IF msg.imsg.code=MENUDOWN
                                data.xc[data.selptind]:=data.ox
                                data.yc[data.selptind]:=data.oy
                            ENDIF
                            setcurvemode(data,DRAW)
                            Mui_Redraw(obj!!PTR,MADF_DRAWUPDATE)
                        ENDIF
                        stopdragging(cl,obj)
                    ENDIF
                CASE IDCMP_MOUSEMOVE
                    x:=msg.imsg.mousex-_mleft(obj)+data.dx
                    y:=msg.imsg.mousey-_mtop(obj)+data.dy
                    IF x<0 THEN x:=0
                    IF x>=_mwidth(obj) THEN x:=_mwidth(obj)-1
                    IF y<0 THEN y:=0
                    IF y>=_mheight(obj) THEN y:=_mheight(obj)-1
                    i:=data.selptind
                    IF (data.xc[i]<>x) OR (data.yc[i]<>y)
                        IF data.lazydraw
                            setcurvemode(data,RUBBERBAND)
                        ELSE
                            setcurvemode(data,ERASE)
                        ENDIF
                        Mui_Redraw(obj!!PTR,MADF_DRAWUPDATE)
                        data.xc[i]:=x
                        data.yc[i]:=y
                        setcurvemode(data,RUBBERBAND)
                        Mui_Redraw(obj!!PTR,MADF_DRAWUPDATE)
                        data.lazydraw:=TRUE
                    ENDIF
            ENDSELECT
        ELSE
            IF data.showpts AND data.editable
                SELECT class
                    CASE IDCMP_RAWKEY
                        x:=msg.imsg.mousex-_mleft(obj)
                        y:=msg.imsg.mousey-_mtop(obj)
                        ievent.nextevent:=NIL
                        ievent.class:=IECLASS_RAWKEY
                        ievent.code:=msg.imsg.code
                        ievent.qualifier:=msg.imsg.qualifier
                        ievent.eventaddress:=msg.imsg.iaddress
                        IF RawKeyConvert(ievent, str, 80, NIL)=1
                            key:=str[0]
                            SELECT key
                                CASE "f"
                                    addptfirst(cl,obj,x,y)
                                CASE "l"
                                    addptlast(cl,obj,x,y)
                                CASE "b"
                                    addptbefore(cl,obj,x,y)
                                CASE "a"
                                    addptafter(cl,obj,x,y)
                                CASE "m"
                                    changeselptmultind(cl,obj)
                                CASE "d"
                                    removeselpt(cl,obj)
                            ENDSELECT
                        ENDIF
                    CASE IDCMP_MOUSEBUTTONS
                        IF (msg.imsg.code=SELECTDOWN)
                            x:=msg.imsg.mousex-_mleft(obj)
                            y:=msg.imsg.mousey-_mtop(obj)
                            IF ((x >= 0) AND (x < _mwidth(obj)) AND (y >= 0)  AND (y < _mheight(obj)))
                                i:=getindex(data,x,y)
                                IF data.selptind<>i
                                    data.selptind:=i
                                    Mui_Redraw(obj!!PTR,MADF_DRAWUPDATE)
                                ENDIF
                                IF i<>-1
                                    data.ox:=data.xc[i]
                                    data.oy:=data.yc[i]
                                    data.dx:=data.xc[i]-x
                                    data.dy:=data.yc[i]-y
                                    startdragging(cl,obj)
                                ENDIF
                            ENDIF
                        ENDIF
                ENDSELECT
            ENDIF
        ENDIF
    ENDIF

    RETURN 0
ENDPROC


/*
** Class dispatcher
*/

PROC myDispatcher(cl:PTR TO iclass,obj:PTR TO INTUIOBJECT,msg:PTR TO msg) RETURNS value
    DEF methodID

    methodID:=msg.methodid
    SELECT methodID
        CASE OM_NEW;            RETURN mNew        (cl,obj,msg!!PTR)
        CASE OM_SET;            RETURN mSet        (cl,obj,msg!!PTR) BUT 0
        CASE MUIM_AskMinMax;    RETURN mAskMinMax  (cl,obj,msg!!PTR)
        CASE MUIM_Draw     ;    RETURN mDraw       (cl,obj!!PTR,msg!!PTR)
        CASE MUIM_HandleInput;  RETURN mHandleInput(cl,obj!!PTR,msg!!PTR)
        CASE MUIM_Setup;        RETURN mSetup      (cl,obj!!PTR,msg!!PTR)
        CASE MUIM_Cleanup;      RETURN mCleanup    (cl,obj!!PTR,msg!!PTR)
    ENDSELECT

    RETURN doSuperMethodA(cl,obj,msg)
ENDPROC


/*
** Main
*/

PROC main()
    DEF app:PTR TO INTUIOBJECT,window:ARRAY,slider1:PTR TO INTUIOBJECT,slider2:PTR TO INTUIOBJECT,check1:PTR TO INTUIOBJECT,check2:PTR TO INTUIOBJECT,myobj,sigs REF_TO VALUE,
        mcc:PTR TO mui_customclass,ioreq:io
	
	app := NIL
	sigs[0] := 0
	
    IF (utilitybase:=OpenLibrary(UTILITYNAME, 39))=NIL THEN Throw("ERR",'Failed to open utility.library')

    IF (muimasterbase:=OpenLibrary(MUIMASTER_NAME, MUIMASTER_VMIN))=NIL THEN Throw("ERR",'Failed to open muimaster.library')

    IF (mcc:=eMui_CreateCustomClass(NIL,MUIC_Area,NIL,SIZEOF mydata,CALLBACK myDispatcher()))=NIL THEN Throw("ERR",'Failed to create custom class')

    IF OpenDevice('console.device', -1, ioreq, 0)<>0 THEN Throw("ERR",'Failed to open console.device')
    consoledevice:=ioreq.device

    app:=ApplicationObject,
        MUIA_Application_Title      , 'B-Spline',
        MUIA_Application_Version    , '$VER: BSpline 1.0 (12.04.96)',
        MUIA_Application_Copyright  , '©1996, Kristofer Maad',
        MUIA_Application_Author     , 'Kristofer Maad',
        MUIA_Application_Description, 'B-Spline editor with MUI in AmigaE.',
        MUIA_Application_Base       , 'BSPLINE',

        SubWindow, window := WindowObject,
            MUIA_Window_Title, 'B-Spline example with MUI in AmigaE',
            MUIA_Window_ID   , "BSPL",
            WindowContents, VGroup,
                Child, ScrollgroupObject,
                    MUIA_CycleChain, MUI_TRUE,
                    MUIA_Scrollgroup_Contents, VirtgroupObject,
                        Child, myobj := NewObjectA(mcc.mcc_class,NILA,
                            [
                            TextFrame,
                            MUIA_FillArea, FALSE,
                            End,
                        End,
                    End,
                Child, GroupObject,
                    MUIA_Group_Columns, 4,
                    MUIA_Frame, MUIV_Frame_Group,
                    MUIA_FrameTitle, 'Curve settings',
                    Child, Label2('Subdivision:'),
                    Child, slider1 := SliderObject,
                        MUIA_CycleChain, MUI_TRUE,
                        MUIA_Slider_Min, 1,
                        MUIA_Slider_Max, 20,
                        End,
                    Child, Label1('Show points:'),
                    Child, check1 := CheckMark(MUI_TRUE),

                    Child, Label2('Drag subdiv.:'),
                    Child, slider2 := SliderObject,
                        MUIA_CycleChain, MUI_TRUE,
                        MUIA_Slider_Min, 1,
                        MUIA_Slider_Max, 20,
                        End,
                    Child, Label1('Editable:'),
                    Child, check2 := CheckMark(MUI_TRUE),
                    End,
                End,
            End,
        End

    IF app=NIL THEN Throw("ERR",'Failed to create Application.')

    set(window,MUIA_Window_DefaultObject,myobj);

    doMethodA(window,[MUIM_Notify,MUIA_Window_CloseRequest,MUI_TRUE,
              app,2,MUIM_Application_ReturnID,MUIV_Application_ReturnID_Quit])

    doMethodA(slider1,[MUIM_Notify,MUIA_Slider_Level,MUIV_EveryTime,
              myobj,3,MUIM_Set,MUIA_BSpline_Subdivision,MUIV_TriggerValue])

    doMethodA(slider2,[MUIM_Notify,MUIA_Slider_Level,MUIV_EveryTime,
              myobj,3,MUIM_Set,MUIA_BSpline_DragSubdivision,MUIV_TriggerValue])

    doMethodA(check1,[MUIM_Notify,MUIA_Selected,MUIV_EveryTime,
              myobj,3,MUIM_Set,MUIA_BSpline_ShowPoints,MUIV_TriggerValue])

    doMethodA(check2,[MUIM_Notify,MUIA_Selected,MUIV_EveryTime,
              myobj,3,MUIM_Set,MUIA_BSpline_Editable,MUIV_TriggerValue])

    doMethodA(check1,[MUIM_Notify,MUIA_Selected,FALSE,
              check2,3,MUIM_Set,MUIA_Disabled,MUI_TRUE])

    doMethodA(check1,[MUIM_Notify,MUIA_Selected,MUI_TRUE,
              check2,3,MUIM_Set,MUIA_Disabled,FALSE])

    set(slider1,MUIA_Slider_Level,10)
    set(slider2,MUIA_Slider_Level,5)

    set(window,MUIA_Window_Open,MUI_TRUE)

    WHILE (doMethodA(app,[MUIM_Application_NewInput,sigs]) <> MUIV_Application_ReturnID_Quit)
        IF sigs[0] THEN IF ((sigs[0]:=Wait(sigs[0] OR SIGBREAKF_CTRL_C)) AND SIGBREAKF_CTRL_C) THEN Throw("ERR",'Break! - Exiting');
    ENDWHILE

    set(window,MUIA_Window_Open,FALSE)

FINALLY
    IF app THEN Mui_DisposeObject(app)                /* dispose all objects. */
    IF mcc THEN Mui_DeleteCustomClass(mcc)            /* delete the custom class. */
    IF muimasterbase THEN CloseLibrary(muimasterbase) /* close libraries */
    IF utilitybase THEN CloseLibrary(utilitybase)
    IF consoledevice THEN CloseDevice(ioreq)          /* close device */
    IF exception THEN Print('\s\n',exception)
ENDPROC
