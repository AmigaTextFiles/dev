IMPLEMENTATION MODULE Commodities ;

FROM SYSTEM	 IMPORT STRING, LONGSET ;
FROM Exec	 IMPORT TaskPtr, MsgPortPtr ;
FROM InputEvent	 IMPORT InputEventPtr, IECLASS_NULL ;

IMPORT M2Lib, Commodities ;

PROCEDURE CxCustom( action : PROC ; id : LONGINT ) : CxObjPtr ;
BEGIN RETURN Commodities.CreateCxObj( CX_CUSTOM, action, id ) ;
END CxCustom ;

PROCEDURE CxDebug( id : LONGINT ) : CxObjPtr ;
BEGIN RETURN Commodities.CreateCxObj( CX_DEBUG, id, 0 ) ;
END CxDebug ;

PROCEDURE CxFilter( d : STRING ) : CxObjPtr ;
BEGIN RETURN Commodities.CreateCxObj( CX_FILTER, d, 0 ) ;
END CxFilter ;

PROCEDURE CxSender( port : MsgPortPtr ; id : LONGINT ) : CxObjPtr ;
BEGIN RETURN Commodities.CreateCxObj( CX_SEND, port, id ) ;
END CxSender ;

PROCEDURE CxSignal( task : TaskPtr ; sig : LONGSET ) : CxObjPtr ;
BEGIN RETURN Commodities.CreateCxObj( CX_SIGNAL, task , sig ) ;
END CxSignal ;

PROCEDURE CxTranslate( ie : InputEventPtr ) : CxObjPtr ;
BEGIN RETURN Commodities.CreateCxObj( CX_TRANSLATE, ie, 0 )
END CxTranslate ;

PROCEDURE NULL_IX( ix : InputXpressionPtr ) : BOOLEAN ;
BEGIN RETURN ix^.ix_Class = IECLASS_NULL
END NULL_IX ;

BEGIN CxBase := M2Lib.OpenLib( "commodities.library" , VERSION )
END Commodities.

