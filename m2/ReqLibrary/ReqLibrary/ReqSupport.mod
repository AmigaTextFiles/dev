IMPLEMENTATION MODULE ReqSupport;

IMPORT rd: ReqD,
       rl: ReqL,
       SYSTEM;


VAR textR : rd.TRStructure;


PROCEDURE SimpleRequest(string       : ARRAY OF CHAR;
                        parameterlist: SYSTEM.ADDRESS);

   BEGIN
      textR.text          := SYSTEM.ADR(string);
      textR.controls      := parameterlist;
      textR.window        := NIL;
      textR.middleText    := NIL;
      textR.positiveText  := NIL;
      textR.negativeText  := SYSTEM.ADR("Resume");
      textR.title         := SYSTEM.ADR("okay?");
      textR.keyMask       := {0..15};
      textR.textcolor     := 1;
      textR.detailcolor   := 0;
      textR.blockcolor    := 0;
      textR.versionnumber := rl.reqVersion;
      textR.timeout       := 10;
      textR.abortMask     := SYSTEM.LONGSET{};
      textR.rfu1          := 0;
      IF (rl.TextRequest(SYSTEM.ADR(textR)) = 0)
         THEN
      END; (* IF *)
   END SimpleRequest;


PROCEDURE TwoGadRequest(string       : ARRAY OF CHAR;
                        parameterlist: SYSTEM.ADDRESS): INTEGER;

VAR result: INTEGER;

   BEGIN
      textR.text          := SYSTEM.ADR(string);
      textR.controls      := parameterlist;
      textR.window        := NIL;
      textR.middleText    := NIL;
      textR.positiveText  := SYSTEM.ADR("  Ok  ");
      textR.negativeText  := SYSTEM.ADR("Cancel");
      textR.title         := SYSTEM.ADR("okay?");
      textR.keyMask       := {0..15};
      textR.textcolor     := 1;
      textR.detailcolor   := 0;
      textR.blockcolor    := 0;
      textR.versionnumber := rl.reqVersion;
      textR.timeout       := 10;
      textR.abortMask     := SYSTEM.LONGSET{};
      textR.rfu1          := 0;
      result:=rl.TextRequest(SYSTEM.ADR(textR));
      RETURN(result);
   END TwoGadRequest;

END ReqSupport.
