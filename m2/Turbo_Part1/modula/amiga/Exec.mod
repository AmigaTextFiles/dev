IMPLEMENTATION MODULE Exec ;

FROM SYSTEM IMPORT ADR ;

PROCEDURE IsListEmpty( x : ListPtr ) : BOOLEAN ;
BEGIN RETURN x^.lh_TailPred = NodePtr( x ) ;
END IsListEmpty ;

PROCEDURE IsMsgPortEmpty( x : MsgPortPtr ) : BOOLEAN ;
BEGIN RETURN x^.mp_MsgList.lh_TailPred = NodePtr( ADR(x^.mp_MsgList)) ;
END IsMsgPortEmpty ;

(*VAR sysbase[4] : ExecBasePtr ;

BEGIN SysBase := sysbase ;*)
END Exec.
