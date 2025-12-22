IMPLEMENTATION MODULE MuiClasses;

(*************************************************************************
** Structures and Macros for creating MUI custom classes.
**
** converted for M2 by Christian 'Kochtopf' Scholz
||
|| some changes by Stefan Schulz / 20.09.94
||
**
**************************************************************************
**
** $Id: MuiClasses.mod 1.3 1994/06/30 21:03:01 Kochtopf Exp $
**
**************************************************************************)

FROM    SYSTEM      IMPORT CAST, ADR, BYTE, ADDRESS, REG, SETREG;
FROM    IntuitionD  IMPORT ObjectPtr, WindowPtr, ScreenPtr, DrawInfoPtr, IBox,
                           IntuiMessagePtr, IClassPtr, IClass;
FROM    GraphicsD   IMPORT TextFontPtr, RastPortPtr;
FROM    ExecD       IMPORT MinNode;
FROM    UtilityD    IMPORT Hook, HookPtr;
IMPORT R;
FROM    MuiD        IMPORT APTR;

(*
** first some general BOOPSI-things, which aren't defined in the normal defs.
*)

TYPE    object = RECORD
                    oNode   : MinNode;
                    oClass  : IClassPtr;
                 END;

(* get a pointer to our instance data *)

PROCEDURE InstData(cl : IClassPtr; obj : ObjectPtr) : ADDRESS;
    BEGIN
        RETURN (CAST(ADDRESS, obj) + ADDRESS(cl^.instOffset));
    END InstData;

(* get the size ... *)

PROCEDURE InstSize(cl : IClassPtr) : CARDINAL;
    BEGIN
        RETURN cl^.instOffset+cl^.instSize+SIZE(object);
    END InstSize;


(* 
** something, which we can cast your object-pointer to
** (just used iternally)
*)

TYPE    dummyXFC = RECORD
                    mnd : mNotifyData;
                    mad : mAreaData;
                   END;

        dummyXFCPtr = POINTER TO dummyXFC;


(*
** now the functions to get to some types of data of our object.
*)


PROCEDURE muiNotifyData(obj : APTR) : mNotifyDataPtr;
    BEGIN
        RETURN ADR(CAST(dummyXFCPtr, obj)^.mnd);
    END muiNotifyData;

PROCEDURE muiAreaData(obj : APTR) : mAreaDataPtr;
    BEGIN
        RETURN ADR(CAST(dummyXFCPtr, obj)^.mad);
    END muiAreaData;

PROCEDURE muiGlobalInfo(obj : APTR) : mGlobalInfoPtr;
    BEGIN
        RETURN CAST(dummyXFCPtr, obj)^.mnd.globalInfo;
    END muiGlobalInfo;

PROCEDURE muiRenderInfo(obj : APTR) : mRenderInfoPtr;
    BEGIN
        RETURN CAST(dummyXFCPtr, obj)^.mad.renderInfo;
    END muiRenderInfo;

PROCEDURE muiUserData(obj : APTR) : LONGINT;
    BEGIN
        RETURN CAST(dummyXFCPtr, obj)^.mnd.userData;
    END muiUserData;


(*
** here the macros from mui.h.
** use them to get e.g. your rastport.
*)

PROCEDURE OBJ_app(obj : APTR) : ObjectPtr;
    BEGIN
        RETURN muiGlobalInfo(obj)^.applicationObject;
    END OBJ_app;

PROCEDURE OBJ_win(obj : APTR) : ObjectPtr;
    BEGIN
        RETURN muiRenderInfo(obj)^.windowObject;
    END OBJ_win;

PROCEDURE OBJ_dri(obj : APTR) : DrawInfoPtr;
    BEGIN
        RETURN muiRenderInfo(obj)^.drawInfo;
    END OBJ_dri;

PROCEDURE OBJ_window(obj : APTR) : WindowPtr;
    BEGIN
        RETURN muiRenderInfo(obj)^.window;
    END OBJ_window;

PROCEDURE OBJ_screen(obj : APTR) : ScreenPtr;
    BEGIN
        RETURN muiRenderInfo(obj)^.screen;
    END OBJ_screen;

PROCEDURE OBJ_rp(obj : APTR) : RastPortPtr;
    BEGIN
        RETURN muiRenderInfo(obj)^.rastPort;
    END OBJ_rp;

PROCEDURE OBJ_left(obj : APTR) : INTEGER;
    BEGIN
        RETURN muiAreaData(obj)^.box.left;
    END OBJ_left;

PROCEDURE OBJ_top(obj : APTR) : INTEGER;
    BEGIN
        RETURN muiAreaData(obj)^.box.top;
    END OBJ_top;

PROCEDURE OBJ_width(obj : APTR) : INTEGER;
    BEGIN
        RETURN muiAreaData(obj)^.box.width;
    END OBJ_width;

PROCEDURE OBJ_height(obj : APTR) : INTEGER;
    BEGIN
        RETURN muiAreaData(obj)^.box.height;
    END OBJ_height;

PROCEDURE OBJ_right(obj : APTR) : INTEGER;
    BEGIN
        RETURN OBJ_left(obj)+OBJ_width(obj)-1;
    END OBJ_right;

PROCEDURE OBJ_bottom(obj : APTR) : INTEGER;
    BEGIN
        RETURN OBJ_top(obj)+OBJ_height(obj)-1;
    END OBJ_bottom;

PROCEDURE OBJ_addleft(obj : APTR) : INTEGER;
    BEGIN
        RETURN INTEGER(muiAreaData(obj)^.addLeft);
    END OBJ_addleft;

PROCEDURE OBJ_addtop(obj : APTR) : INTEGER;
    BEGIN
        RETURN INTEGER(muiAreaData(obj)^.addTop);
    END OBJ_addtop;

PROCEDURE OBJ_subwidth(obj : APTR) : INTEGER;
    BEGIN
        RETURN INTEGER(muiAreaData(obj)^.subWidth);
    END OBJ_subwidth;

PROCEDURE OBJ_subheight(obj : APTR) : INTEGER;
    BEGIN
        RETURN INTEGER(muiAreaData(obj)^.subHeight);
    END OBJ_subheight;

PROCEDURE OBJ_mleft(obj : APTR) : INTEGER;
    BEGIN
        RETURN OBJ_left(obj)+OBJ_addleft(obj);
    END OBJ_mleft;

PROCEDURE OBJ_mtop(obj : APTR) : INTEGER;
    BEGIN
        RETURN OBJ_top(obj)+OBJ_addtop(obj);
    END OBJ_mtop;

PROCEDURE OBJ_mwidth(obj : APTR) : INTEGER;
    BEGIN
        RETURN OBJ_width(obj)-OBJ_subwidth(obj);
    END OBJ_mwidth;

PROCEDURE OBJ_mheight(obj : APTR) : INTEGER;
    BEGIN
        RETURN OBJ_height(obj)-OBJ_subheight(obj);
    END OBJ_mheight;

PROCEDURE OBJ_mright(obj : APTR) : INTEGER;
    BEGIN
        RETURN OBJ_mleft(obj)+OBJ_mwidth(obj)-1;
    END OBJ_mright;

PROCEDURE OBJ_mbottom(obj : APTR) : INTEGER;
    BEGIN
        RETURN OBJ_mtop(obj)+OBJ_mheight(obj)-1;
    END OBJ_mbottom;

PROCEDURE OBJ_font(obj : APTR) : TextFontPtr;
    BEGIN
        RETURN muiAreaData(obj)^.font;
    END OBJ_font;

PROCEDURE OBJ_flags(obj : APTR) : MADFlagSet;
    BEGIN
        RETURN muiAreaData(obj)^.flags;
    END OBJ_flags;


(*
** here are some new procedures to generate dispatchers which restore A4
*)

(* first the 'real' dispatcher *)

PROCEDURE DispatchEntry(class{R.A0} : HookPtr;
                        object{R.A2}: ADDRESS;
                        msg{R.A1}   : ADDRESS)     : ADDRESS;
    (*$SaveA4:=TRUE*)
    BEGIN
        SETREG (R.A4, CAST(IClassPtr,class)^.dispatcher.data);
        RETURN CAST(DispatcherDef,CAST(IClassPtr,class)^.dispatcher.subEntry)(CAST(IClassPtr,class), object, msg);
    END DispatchEntry;

(* fill the dispatcher-record inside the class *)

PROCEDURE MakeDispatcher(entry:DispatcherDef; VAR myclass : IClassPtr);

    BEGIN
            myclass^.dispatcher.node.succ  := NIL;
            myclass^.dispatcher.node.pred  := NIL;
            myclass^.dispatcher.entry      := DispatchEntry;
            myclass^.dispatcher.subEntry   := CAST(ADDRESS,entry);
            myclass^.dispatcher.data       := REG(R.A4);
    END MakeDispatcher;



(* a useful PROCEDURE! *)

PROCEDURE FillMinMaxInfo (msg : mpAskMinMaxPtr; MinWidth   : CARDINAL;
                                                DefWidth   : CARDINAL;
                                                MaxWidth   : CARDINAL;
                                                MinHeight  : CARDINAL;
                                                DefHeight  : CARDINAL;
                                                MaxHeight  : CARDINAL);
    BEGIN                                               

        msg^.MinMaxInfo^.MinWidth  := msg^.MinMaxInfo^.MinWidth +MinWidth;
        msg^.MinMaxInfo^.DefWidth  := msg^.MinMaxInfo^.DefWidth +DefWidth;
        msg^.MinMaxInfo^.MaxWidth  := msg^.MinMaxInfo^.MaxWidth +MaxWidth;

        msg^.MinMaxInfo^.MinHeight := msg^.MinMaxInfo^.MinHeight +MinHeight;
        msg^.MinMaxInfo^.DefHeight := msg^.MinMaxInfo^.DefHeight +DefHeight;
        msg^.MinMaxInfo^.MaxHeight := msg^.MinMaxInfo^.MaxHeight +MaxHeight;

    END FillMinMaxInfo;

(*
** 2 useful procedures for testing if some coordinates are inside your object
** (converted from the ones in class3.c. So look there how to use... )
*)

PROCEDURE OBJ_between(a,x,b : INTEGER) : BOOLEAN;
    BEGIN
        RETURN ((x>=a) AND (x<=b));
    END OBJ_between;

PROCEDURE OBJ_isInObject(x, y : INTEGER; obj : ObjectPtr) : BOOLEAN;
    BEGIN
        RETURN (OBJ_between(OBJ_mleft(obj), x, OBJ_mright(obj)) AND
                OBJ_between(OBJ_mtop(obj), y, OBJ_mbottom(obj)));
    END OBJ_isInObject;




END MuiClasses.

