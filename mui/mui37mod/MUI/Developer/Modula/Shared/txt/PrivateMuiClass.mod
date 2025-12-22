IMPLEMENTATION MODULE 低lassNameClass; (* 06-Jan-96 st *)

(* Written by S霵ke Tesch.
 * Got suggestions or problems? Contact me at <soenke.tesch@elmshorn.netsurf.de>
 *)

(* replace.......with
 * 判arentVar  = name of the VAR that contains the IClassPtr of your parent class
 * 判arentName = name of your parent class without d.mc
 * 低lassName  = name of this class
 * 低lassVar   = name of the VAR that contains the IClassPtr of this class
 *
 * Some meaningfull values have to be inserted everywhere a (** value **) appears,
 * this is the case in AskMinMax and Draw.
 * Insert your code everywhere (* insert code here *) appears. Other places might
 * lead into problems.
 * Your private class` data can be added in 低lassNameData. Implement private
 * methods as simple procedures and insert an ELSIF statement to call it in the
 * Dispatcher()-procedure.
 *
 * NOTE: Using M2Amiga? Then..
 *   - replace SaveA4+ (in Dispatcher()) with SaveA4:=TRUE
 *   - replace the line `IMPORT R:Reg` with `IMPORT R`
 *)

FROM SYSTEM IMPORT ADR,ADDRESS,CAST,TAG,SETREG,REG,LONGSET,ASSEMBLE,BYTE,SHORTSET
;
IMPORT R:Reg
;
FROM ExecL IMPORT AllocVec,FreeVec,CopyMem
;
FROM ExecD IMPORT MemReqs,MemReqSet
;
FROM IntuitionL IMPORT MakeClass,FreeClass
;
FROM IntuitionD IMPORT Msg,OpSetPtr,OpGetPtr,omGET,omSET,omNEW,omDISPOSE
;
FROM MuiL IMPORT moGetClass,moFreeClass,moRedraw
;
IMPORT d:MuiD
;
IMPORT c:MuiClasses
;
FROM UtilityL IMPORT GetTagData,FindTagItem
;
FROM UtilityD IMPORT TagItemPtr,tagEnd,HookPtr
;
FROM AmigaLib IMPORT DoSuperMethodA,CoerceMethodA,DoMethodA,Get,Set
;

VAR 判arentVarClass : ADDRESS;

TYPE 低lassNameData = RECORD
     END;
     低lassNameDataPtr = POINTER TO 低lassNameData;

(* 07-Jan-96----------------------------------------------------------------------- *)
PROCEDURE 低lassNameNew(class : ADDRESS;
                       object : ADDRESS;
                       msg : OpSetPtr):ADDRESS;

  VAR myData : 低lassNameDataPtr;
      tagItem : TagItemPtr;

      tagBuffer : ARRAY [0..2] OF ADDRESS;

  BEGIN

    (** insert code here - beware, object not yet created! **)

    object:=DoSuperMethodA(class,object,msg);
    IF object=NIL THEN
       RETURN NIL;
    END;

    myData:=c.InstData(class,object);

    (** insert code here - we`re now alive and kicking :) **)

    RETURN object;
  END 低lassNameNew;

(* 07-Jan-96----------------------------------------------------------------------- *)
PROCEDURE 低lassNameDispose(class : ADDRESS;
                           object : ADDRESS;
                           msg : Msg):ADDRESS;

  VAR myData : 低lassNameDataPtr;

  BEGIN
    myData:=c.InstData(class,object);

    (** insert code here **)

    IF DoSuperMethodA(class,object,msg)=NIL THEN
       RETURN NIL;
    END;

    RETURN NIL;
  END 低lassNameDispose;

(* 06-Jan-96----------------------------------------------------------------------- *)
PROCEDURE 低lassNameAskMinMax(class : ADDRESS;
                         object : ADDRESS;
                         msg : c.mpAskMinMaxPtr):ADDRESS;

  VAR myData : 低lassNameDataPtr;

  BEGIN
    DOSuperMethodA(class,object,msg);

    myData:=c.InstData(class,object);

    WITH msg^.MinMaxInfo^ DO
      INC(MinWidth, (** value **));
      INC(MinHeight,(** value **));
      INC(MaxWidth, (** value **));
      INC(MaxHeight,(** value **));
      INC(DefWidth, (** value **));
      INC(DefHeight,(** value **));
    END;
    RETURN NIL;
  END 低lassNameAskMinMax;

(* 06-Jan-96----------------------------------------------------------------------- *)
PROCEDURE 低lassNameSetup(class : ADDRESS;
                         object : ADDRESS;
                         msg : Msg):ADDRESS;

  VAR myData : 低lassNameDataPtr;
      tagBuffer : ARRAY [0..6] OF ADDRESS;

  BEGIN
    IF DoSuperMethodA(class,object,msg)=NIL THEN
       RETURN NIL;
    END;

    myData:=c.InstData(class,object);

    (** insert code here **)

    IF failed THEN
       COerceMethodA(class,object,TAG(tagBuffer,d.mmCleanup));
       RETURN NIL;
    END;

    RETURN CAST(ADDRESS,-1);
  END 低lassNameSetup;

(* 06-Jan-96----------------------------------------------------------------------- *)
PROCEDURE 低lassNameCleanup(class : ADDRESS;
                           object : ADDRESS;
                           msg : Msg):ADDRESS;

  VAR myData : 低lassNameDataPtr;

  BEGIN
    myData:=c.InstData(class,object);

    (** insert code here **)

    RETURN DoSuperMethodA(class,object,msg);
  END 低lassNameCleanup;

(* 07-Jan-96----------------------------------------------------------------------- *)
PROCEDURE 低lassNameGet(class : ADDRESS;
                       object : ADDRESS;
                       msg : OpGetPtr):ADDRESS;

  VAR myData : 低lassNameDataPtr;

  BEGIN
    myData:=c.InstData(class,object);

    (** insert code here **)

    RETURN ;
  END 低lassNameGet;

(* 06-Jan-96----------------------------------------------------------------------- *)
PROCEDURE 低lassNameSet(class : ADDRESS;
                       object : ADDRESS;
                       msg : OpSetPtr):ADDRESS;

  VAR tagItem : TagItemPtr;
      myData : 低lassNameDataPtr;

  BEGIN
    DOSuperMethodA(class,object,msg);

    myData:=c.InstData(class,object);

    (** insert code here **)

    moRedraw(object,c.MADFlagSet{c.(** value **)});

    RETURN NIL;
  END 低lassNameSet;

(* 06-Jan-96----------------------------------------------------------------------- *)
PROCEDURE 低lassNameDraw(class : ADDRESS;
                    object : ADDRESS;
                    msg : c.mpDrawPtr):ADDRESS;

  VAR myData : 低lassNameDataPtr;

  BEGIN
    DOSuperMethodA(class,object,msg);
    myData:=c.InstData(class,object);

    IF (c.drawObject IN msg^.flags) THEN  (* (re-)draw whole object *)
     ELSIF (c.drawUpdate IN msg^.flags) THEN (* only update *)
    END;

    RETURN NIL;
  END 低lassNameDraw;

(* 06-Jan-96----------------------------------------------------------------------- *)
PROCEDURE 低lassNameDispatcher(class{R.A0} : HookPtr;      (* HookProc *)
                          object{R.A2} : ADDRESS;
                          msg{R.A1} : ADDRESS):ADDRESS;

  (*$ SaveA4+ *)

  BEGIN
    SETREG(R.A4,class^.data);
    IF CAST(Msg,msg)^.methodID=omSET THEN		(** set/get		**)
       RETURN 低lassNameSet(class,object,msg);
     ELSIF CAST(Msg,msg)^.methodID=omGET THEN
       RETURN 低lassNameGet(class,object,msg);

     ELSIF CAST(Msg,msg)^.methodID=omNEW THEN		(** new/dispose		**)
       RETURN 低lassNameNew(class,object,msg);
     ELSIF CAST(Msg,msg)^.methodID=omDISPOSE THEN
       RETURN 低lassNameDispose(class,object,msg);

     ELSIF CAST(Msg,msg)^.methodID=d.mmSetup THEN	(** setup/cleanup	**)
       RETURN 低lassNameSetup(class,object,msg);
     ELSIF CAST(Msg,msg)^.methodID=d.mmCleanup THEN
       RETURN 低lassNameCleanup(class,object,msg);

     ELSIF CAST(Msg,msg)^.methodID=d.mmAskMinMax THEN	(** askminmax		**)
       RETURN 低lassNameAskMinMax(class,object,msg);

     ELSIF CAST(Msg,msg)^.methodID=d.mmDraw THEN	(** draw		**)
       RETURN 低lassNameDraw(class,object,msg);

     (** your private methods **)

    END;

    RETURN DoSuperMethodA(CAST(ADDRESS,class),object,msg);
  END 低lassNameDispatcher;

(* 06-Jan-96----------------------------------------------------------------------- *)
PROCEDURE Create低lassNameClass();

  BEGIN
    IF 低lassVarClass=NIL THEN
       判arentVarClass:=moGetClass(ADR(d.mc判arentName));
       IF 判arentVarClass#NIL THEN
          低lassVarClass:=MakeClass(NIL,NIL,判arentVarClass,SIZE(低lassNameData),LONGSET{});
          IF 低lassVarClass=NIL THEN
             moFreeClass(判arentVarClass); 判arentVarClass:=NIL;
           ELSE
             WITH 低lassVarClass^.dispatcher DO
               entry:=低lassNameDispatcher;
               data:=REG(R.A4);
             END;
          END;
       END;
    END;
  END Create低lassNameClass;

(* 06-Jan-96----------------------------------------------------------------------- *)
PROCEDURE Delete低lassNameClass();

  BEGIN
    IF 低lassVarClass#NIL THEN
       IF FreeClass(低lassVarClass) THEN
          moFreeClass(判arentVarClass);
          低lassVarClass:=NIL; 判arentVarClass:=NIL;
       END;
    END;
  END Delete低lassNameClass;

END 低lassNameClass.mod


