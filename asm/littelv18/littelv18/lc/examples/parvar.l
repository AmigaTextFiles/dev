;//  new feautures in LITTEL 0.17 //
;//  'CODESTART' MUST BE IN ANY PROC USING LOCALS OR PARAMS!! //

PROC main
   VAR nisse  ;// declare local
   CODESTART
   copy 5     nisse
   dpr  eva   nisse ;// send nisse along
ENDPROC

PROC eva   %myparam  ;// receive param in %myparam (must begin with %) max 7 for now
   CODESTART
   mul 5   %myparam
ENDPROC    %myparam

END  ;// program returns 25 in D0 ! //


