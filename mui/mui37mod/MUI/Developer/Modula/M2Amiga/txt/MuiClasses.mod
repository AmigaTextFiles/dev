IMPLEMENTATION MODULE MuiClasses;

(***************************************************************************
**
** $VER: MuiClasses.mod 3.7 (29.1.97)
**
** The following updates have been done by
**
**   Olaf "Olf" Peters <olf@informatik.uni-bremen.de>
**
** $HISTORY:
**
**  29.1.97  3.7   : updated for MUI 3.7 release
**  13.8.96  3.6   : updated for MUI 3.6 release
**  21.2.96  3.3   : updated for MUI 3.3 release
**  23.1.96  3.2   : updated for MUI 3.2 release
** 18.11.95  3.1   : updated for MUI 3.1 release
**
***************************************************************************)

(*************************************************************************
** Structures and Macros for creating MUI custom classes.
**
** converted for M2 by Christian 'Kochtopf' Scholz
**
**************************************************************************
**
** $Id: MuiClasses.mod,v 1.11 1997/01/29 15:17:40 olf Exp olf $
**
**************************************************************************)

FROM    SYSTEM      IMPORT CAST, ADR, BYTE, ADDRESS, REG, SETREG, ASSEMBLE;
FROM    MuiD        IMPORT APTR;

IMPORT
  ed : ExecD,
  gd : GraphicsD,
  id : IntuitionD,
  ud : UtilityD,
  R;

(*
** first some general BOOPSI-things, which aren't defined in the normal defs.
*)

TYPE    object = RECORD
                    oNode   : ed.MinNode;
                    oClass  : id.IClassPtr;
                 END;

(* get a pointer to our instance data *)

PROCEDURE InstData(cl : id.IClassPtr; obj : id.ObjectPtr) : ADDRESS;
    BEGIN
        RETURN (CAST(ADDRESS, obj) + ADDRESS(cl^.instOffset));
    END InstData;

(* get the size ... *)

PROCEDURE InstSize(cl : id.IClassPtr) : CARDINAL;
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

PROCEDURE muiPen(pen : LONGCARD) : LONGCARD;
VAR
  ret{R.D4} : LONGCARD;
BEGIN
    ASSEMBLE(
      MOVE.L pen(A5), D4
      AND.L  #muipenMask, D4
    END) ;
    RETURN ret ;
END muiPen ;

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
        RETURN CAST(dummyXFCPtr, obj)^.mnd.mndGlobalInfo;
    END muiGlobalInfo;

PROCEDURE muiUserData(obj : APTR) : ADDRESS ;
    BEGIN
        RETURN CAST(dummyXFCPtr, obj)^.mnd.mndUserData;
    END muiUserData;

PROCEDURE muiRenderInfo(obj : APTR) : mRenderInfoPtr;
    BEGIN
        RETURN CAST(dummyXFCPtr, obj)^.mad.madRenderInfo;
    END muiRenderInfo;


(*
** here the macros from mui.h.
** use them to get e.g. your rastport.
*)

PROCEDURE OBJ_app(obj : APTR) : id.ObjectPtr;
    BEGIN
        RETURN muiGlobalInfo(obj)^.mgiApplicationObject;
    END OBJ_app;

PROCEDURE OBJ_win(obj : APTR) : id.ObjectPtr;
    BEGIN
        RETURN muiRenderInfo(obj)^.mriWindowObject;
    END OBJ_win;

PROCEDURE OBJ_dri(obj : APTR) : id.DrawInfoPtr;
    BEGIN
        RETURN muiRenderInfo(obj)^.mriDrawInfo;
    END OBJ_dri;

PROCEDURE OBJ_screen(obj : APTR) : id.ScreenPtr;
    BEGIN
        RETURN muiRenderInfo(obj)^.mriScreen;
    END OBJ_screen;

PROCEDURE OBJ_pens(obj : APTR) : mPensPtr;
    BEGIN
        RETURN muiRenderInfo(obj)^.mriPens;
    END OBJ_pens;

PROCEDURE OBJ_window(obj : APTR) : id.WindowPtr;
    BEGIN
        RETURN muiRenderInfo(obj)^.mriWindow;
    END OBJ_window;

PROCEDURE OBJ_rp(obj : APTR) : gd.RastPortPtr;
    BEGIN
        RETURN muiRenderInfo(obj)^.mriRastPort;
    END OBJ_rp;

PROCEDURE OBJ_left(obj : APTR) : INTEGER;
    BEGIN
        RETURN muiAreaData(obj)^.madBox.left;
    END OBJ_left;

PROCEDURE OBJ_top(obj : APTR) : INTEGER;
    BEGIN
        RETURN muiAreaData(obj)^.madBox.top;
    END OBJ_top;

PROCEDURE OBJ_width(obj : APTR) : INTEGER;
    BEGIN
        RETURN muiAreaData(obj)^.madBox.width;
    END OBJ_width;

PROCEDURE OBJ_height(obj : APTR) : INTEGER;
    BEGIN
        RETURN muiAreaData(obj)^.madBox.height;
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
        RETURN INTEGER(muiAreaData(obj)^.madAddLeft);
    END OBJ_addleft;

PROCEDURE OBJ_addtop(obj : APTR) : INTEGER;
    BEGIN
        RETURN INTEGER(muiAreaData(obj)^.madAddTop);
    END OBJ_addtop;

PROCEDURE OBJ_subwidth(obj : APTR) : INTEGER;
    BEGIN
        RETURN INTEGER(muiAreaData(obj)^.madSubWidth);
    END OBJ_subwidth;

PROCEDURE OBJ_subheight(obj : APTR) : INTEGER;
    BEGIN
        RETURN INTEGER(muiAreaData(obj)^.madSubHeight);
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

PROCEDURE OBJ_font(obj : APTR) : gd.TextFontPtr;
    BEGIN
        RETURN muiAreaData(obj)^.madFont;
    END OBJ_font;

PROCEDURE OBJ_minwidth(obj : APTR) : CARDINAL;
    BEGIN
        RETURN muiAreaData(obj)^.madMinMax.MinWidth;
    END OBJ_minwidth;

PROCEDURE OBJ_minheight(obj : APTR) : CARDINAL;
    BEGIN
        RETURN muiAreaData(obj)^.madMinMax.MinHeight;
    END OBJ_minheight;

PROCEDURE OBJ_maxwidth(obj : APTR) : CARDINAL;
    BEGIN
        RETURN muiAreaData(obj)^.madMinMax.MaxWidth;
    END OBJ_maxwidth;

PROCEDURE OBJ_maxheight(obj : APTR) : CARDINAL;
    BEGIN
        RETURN muiAreaData(obj)^.madMinMax.MaxHeight;
    END OBJ_maxheight;

PROCEDURE OBJ_defwidth(obj : APTR) : CARDINAL;
    BEGIN
        RETURN muiAreaData(obj)^.madMinMax.DefWidth;
    END OBJ_defwidth;

PROCEDURE OBJ_defheight(obj : APTR) : CARDINAL;
    BEGIN
        RETURN muiAreaData(obj)^.madMinMax.DefHeight;
    END OBJ_defheight;

PROCEDURE OBJ_flags(obj : APTR) : MADFlagSet;
    BEGIN
        RETURN muiAreaData(obj)^.madFlags;
    END OBJ_flags;


(*
** here are some new procedures to generate dispatchers which restore A4
*)

(* first the 'real' dispatcher *)

PROCEDURE DispatchEntry(class{R.A0} : ud.HookPtr;
                        object{R.A2}: ADDRESS;
                        msg{R.A1}   : ADDRESS)     : ADDRESS;
    (*$SaveA4:=TRUE*)
    BEGIN
        SETREG (R.A4, CAST(id.IClassPtr,class)^.userData);
        RETURN CAST(DispatcherDef,CAST(id.IClassPtr,class)^.dispatcher.subEntry)(CAST(id.IClassPtr,class), object, msg);
    END DispatchEntry;

(* fill the dispatcher-record inside the class *)

PROCEDURE MakeDispatcher(entry:DispatcherDef; myclass : id.IClassPtr);

    BEGIN
            myclass^.dispatcher.node.succ  := NIL;
            myclass^.dispatcher.node.pred  := NIL;
            myclass^.dispatcher.entry      := DispatchEntry;
            myclass^.dispatcher.subEntry   := CAST(ADDRESS,entry);
            myclass^.userData              := REG(R.A4);
    END MakeDispatcher;



(* a useful PROCEDURE! *)

PROCEDURE FillMinMaxInfo (msg : mpAskMinMaxPtr; minWidth   : CARDINAL;
                                                defWidth   : CARDINAL;
                                                maxWidth   : CARDINAL;
                                                minHeight  : CARDINAL;
                                                defHeight  : CARDINAL;
                                                maxHeight  : CARDINAL);
    BEGIN                                               

        WITH msg^.MinMaxInfo^ DO
            INC(MinWidth, minWidth) ;
            INC(DefWidth, defWidth) ;
            INC(MaxWidth, maxWidth) ;

            INC(MinHeight, minHeight) ;
            INC(DefHeight, defHeight) ;
            INC(MaxHeight, maxHeight) ;

        END (* WITH *) ;
    END FillMinMaxInfo;

(*
** 2 useful procedures for testing if some coordinates are inside your object
** (converted from the ones in class3.c. So look there how to use... )
*)

PROCEDURE OBJ_between(a,x,b : INTEGER) : BOOLEAN;
    BEGIN
        RETURN ((x>=a) AND (x<=b));
    END OBJ_between;

PROCEDURE OBJ_isInObject(x, y : INTEGER; obj : id.ObjectPtr) : BOOLEAN;
    BEGIN
        RETURN (OBJ_between(OBJ_mleft(obj), x, OBJ_mright(obj)) AND
                OBJ_between(OBJ_mtop(obj), y, OBJ_mbottom(obj)));
    END OBJ_isInObject;




END MuiClasses.

