IMPLEMENTATION MODULE MuiClassSupport ;

(****** MuiClassSupport/---information--- ************************************
*
*   VERSION
*        $Id: MuiClassSupport.mod 1.4 1996/08/14 01:39:07 olf Exp olf $
*
*   COPYRIGHT
*        written and (c) 1996 by Olaf 'Olf' Peters
*
*        report bugs, suggestions, comments to
*
*          olf@informatik.uni-bremen.de
*          op@hb2.maus.de (no mail larger than 16 KB to this address!)
*
******************************************************************************
*
*)

(*$ Align- *)

FROM SYSTEM     IMPORT  ADDRESS, ADR, LONGSET, TAG ;
FROM AmigaLib   IMPORT  DoSuperMethodA, SetSuperAttrsA ;

IMPORT
    mc : MuiClasses,
    md : MuiD,
    ml : MuiL,

    ed : ExecD,
    el : ExecL,
    id : IntuitionD,
    il : IntuitionL,

    ud : UtilityD ;

(****** MuiClassSupport/DoSuperNew *******************************************
*
*   NAME
*        DoSuperNew - create an instance of your superclass.
*
*   SYNOPSIS
*        DoSuperNew(cl       : IClassPtr;
*                   obj      : ObjectPtr ;
*                   attrList : TagItemPtr) : ADDRESS ;
*
*   FUNCTION
*        calls the OM_NEW method for the superclass to create an instance
*        of your custom-class. Most likely you will call this in the
*        NEW-Method of your customclass.
*
*   INPUTS
*        cl       - a pointer to a customclass structure, if DoSuperMethod
*                   ist called from the NEW method of your customclass, use
*                   the ClassPtr you got as parameter for your NEW method.
*
*        obj      - also use the ObjectPtr you got as parameter for your
*                   NEW method.
*
*        attrList - a taglist to set attributes of the superclass your
*                   customclass is an instance of.
*
*   RESULT
*        an instance of your customclass.
*
*   SEE ALSO
*        amiga.lib/DoSuperMethodA
*
******************************************************************************
*
*)

(*/// "DoSuperNew(cl : id.IClassPtr; obj : id.ObjectPtr ; attrList : ud.TagItemPtr) : ADDRESS" *)

PROCEDURE DoSuperNew(cl : id.IClassPtr; obj : id.ObjectPtr ; attrList : ud.TagItemPtr) : ADDRESS ;

VAR
  opSet : id.OpSet ;

BEGIN
  opSet.methodID := id.omNEW ;
  opSet.attrList := attrList ;
  opSet.gInfo := NIL ;

  RETURN DoSuperMethodA(cl, obj, ADR(opSet)) ;
END DoSuperNew ;

(*\\\*)

(****** MuiClassSupport/setSuper *********************************************
*
*   NAME
*        setSuper -- set attribute of a superclass
*
*   SYNOPSIS
*        setSuper(cl     : IClassPtr ;
*                 obj    : ObjectPtr ;
*                 attr   : LONGCARD ;
*                 value  : LONGINT) ;
*
*   FUNCTION
*        Set an attribute of the superclass of an object.
*
*   INPUTS
*        cl    - pointer to the customclass structure of your class.
*        obj   - pointer to the instance of your customclass on which's
*                superclass the attribute should be set.
*        attr  - the attribute of your superclass to be set
*        value - the attribute value
*
*
*   SEE ALSO
*        amiga.lib/SetSuperAttrs
*
******************************************************************************
*
*)


(*/// "setSuper(obj : id.ObjectPtr; attr : LONGCARD; value : LONGINT)" *)

PROCEDURE setSuper(cl : id.IClassPtr ; obj : id.ObjectPtr; attr : LONGCARD; value : LONGINT) ;

VAR
  dummy : ADDRESS ;
  tags  : ARRAY [0..3] OF LONGINT ;

BEGIN
  dummy := SetSuperAttrsA(cl, obj, TAG(tags, attr, value, ud.tagDone)) ;
END setSuper ;

(*\\\*)

(****** MuiClassSupport/InitClass ********************************************
*
*   NAME
*        InitClass -- init MUI-CustomClass structure
*
*   SYNOPSIS
*        InitClass(VAR mcc        : mCustomClassPtr;
*                      base       : LibraryPtr ;
*                      supername  : StrPtr ;
*                      supermcc   : mCustomClassPtr ;
*                      datasize   : LONGINT ;
*                      dispatcher : DispatcherDef) : BOOLEAN ;
*
*   FUNCTION
*        Easily allocate and initialize a MUI-CustomClass structure.
*
*        Be sure to call RemoveClass when you're done with the class (most
*        likely InitClass() will be called from the startup-code of a
*        module whereas RemoveClass will be called from the closing code.)
*
*   INPUTS
*        mcc        -
*
*                     the structure to be initialized. It will also be
*                     allocated for you, so be sure to not handle a valid
*                     pointer to InitClass(), it will be overwritten!
*        base,
*        supername,
*        supermcc,
*        datasize   - see muimaster.library/MUI_CreateCustomClass
*        dispatcher - this is the dispatcher function of your customclass,
*                     it must match the following prototype:
*
*                     PROCEDURE ( (* class   *) id.IClassPtr,
*                                 (* object  *) ADDRESS,
*                                 (* message *) ADDRESS) : ADDRESS;
*
*                     No need to call MakeDispatcher as InitClass does this
*                     for you.
*
*   RESULT
*        TRUE if the initialization was successful, FALSE otherwise
*
*   EXAMPLE
*        IMPLEMENTATION MODULE TestClass ;
*
*        [...]
*
*        BEGIN
*          IF NOT (InitClass(class1, NIL, ADR(mcPopobject), NIL,
*                            SIZE(Class1Data), Class1Dispatcher) AND
*                  InitClass(class2, NIL, NIL,              class1,
*                            SIZE(Class2Data), Class2Dispatcher)) THEN
*            [Fail]
*          END ;
*        CLOSE
*          RemoveClass(class2) ;
*          RemoveClass(class1) ;
*        END TestClass .
*
*        This will create the to classes class1 and class2 where class1 is
*        a subclass of mcPopobject and class2 is a subclass of class1.
*
*   SEE ALSO
*        MuiClassSupport/RemoveClass
*        muimaster.library/MUI_CreateCustomClass
*
******************************************************************************
*
*)

(*/// "InitClass(mcc, base, supername, supermcc, datasize, dispatcher) : BOOLEAN" *)

PROCEDURE InitClass(VAR mcc        : mc.mCustomClassPtr;
                        base       : ed.LibraryPtr ;
                        supername  : md.StrPtr ;
                        supermcc   : mc.mCustomClassPtr ;
                        datasize   : LONGINT ;
                        dispatcher : mc.DispatcherDef) : BOOLEAN ;
BEGIN
  mcc := ml.moCreateCustomClass(base, supername, supermcc, datasize, NIL) ;
  IF mcc = NIL THEN RETURN FALSE END ;
  mc.MakeDispatcher(dispatcher, mcc^.class) ;
  RETURN TRUE ;
END InitClass ;

(*\\\*)

(****** MuiClassSupport/RemoveClass ******************************************
*
*   NAME
*        RemoveClass - dispose of a MUI-CustomClass
*
*   SYNOPSIS
*        RemoveClass(VAR mcc : mCustomClassPtr) ;
*
*   FUNCTION
*        dispose of aMUI-CustomClass that has been initialised with
*        InitClass()
*
*   INPUTS
*        mcc - the customclass to dispose of, may also be NIL.
*
*        Note that this is a VAR parameter, it will be set to NIL after the
*        call, so it is safe to call RemoveClass() more often on the same
*        structure without any bad results.
*
*   SEE ALSO
*        MuiClassSupport/InitClass
*
******************************************************************************
*
*)

(*/// "RemoveClass(VAR mcc : mc.mCustomClassPtr)" *)

PROCEDURE RemoveClass(VAR mcc : mc.mCustomClassPtr) ;
BEGIN
  IF mcc # NIL THEN
    IF ml.moDeleteCustomClass(mcc) THEN END ;
    mcc := NIL ;
  END (* IF *) ;
END RemoveClass ;

(*\\\*)

END MuiClassSupport.

