IMPLEMENTATION MODULE MCCMailtext ;

(*
**              $VER: MCCMailtext.mod (29.4.96)
**
**              Mailtext.mcc (c) 1996-1998 by Olaf Peters
**
**              Registered class of the Magic User Interface.
*)

FROM SYSTEM   IMPORT  ADR, ADDRESS ;
FROM MuiL     IMPORT  mNewObject ;
FROM UtilityD IMPORT  TagItemPtr ;

PROCEDURE MailtextObject(tags : TagItemPtr) : ADDRESS ;

BEGIN
  RETURN mNewObject(ADR(mcMailtext), tags) ;
END MailtextObject ;

END MCCMailtext .

