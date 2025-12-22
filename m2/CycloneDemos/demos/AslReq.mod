(*#-- BEGIN AutoRevision header, please do NOT edit!
*
*   Program         :   aslreq.mod
*   Copyright       :   © 1995 by Marcel Timmermans
*   Author          :   Marcel Timmermans
*   Address         :   A. DekenStraat 22 6836 RM Arnhem
*   Creation Date   :   17-04-1995 (Original 14-02-92)
*   Current version :   1.0
*   Translator      :   AMC V 0.45
*
*   REVISION HISTORY
*
*   Date          Version         Comment
*   ---------     -------         ------------------------------------------
*   17-04-1995     0.1            Translate to Amc Modula-2 compiler        
*
*-- END AutoRevision header --*)

MODULE AslReq;

FROM	SYSTEM		IMPORT ADR,CAST,TAG;
FROM  AslL      IMPORT AllocFileRequest,AllocAslRequest,FreeAslRequest,AslRequest;
FROM 	Terminal	IMPORT WriteString,WriteLn;

IMPORT ud:UtilityD,A:ModulaLib,AslD;


TYPE
    TagItemPtr=POINTER TO ARRAY[0..2] OF ud.TagItem;
VAR
    FReq:AslD.FileRequesterPtr;
    BufferTags: ARRAY[0..50] OF LONGINT; (* 50 * 4 bytes *)

(* A very simple demo program to see how to work with tags *)

BEGIN
  WriteString("Example to call aslrequester in Kick2.0");
  WriteLn;

  FReq:=AllocAslRequest(AslD.fileRequest,NIL);
  A.Assert(FReq#NIL,ADR("No FileRequest Memory"));

  IF AslRequest(FReq,TAG(BufferTags,AslD.pattern,ADR("#?"),
                                    AslD.hail,ADR("Test ASL-Requester by DigiSoft"),
                                    AslD.leftEdge,10,
                                    AslD.height,200,
                                    AslD.topEdge,10,
                                    AslD.width,340,ud.tagEnd)) THEN END;

 CLOSE
  IF FReq#NIL THEN FreeAslRequest(FReq); END;
END AslReq.
