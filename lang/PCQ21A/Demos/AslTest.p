PROGRAM AslTest;

{
   This one is compiled with -s.
   That's why it's so small.
   To get the same result just use
   spmake AslTest
   {remember no writeln :))
   Jun 04 1998.
   nils.sjoholm@mailbox.swipnet.se
}

{$I "Include:Libraries/Asl.i"}

VAR
    fr    : FileRequesterPtr;
    dummy : BOOLEAN;

BEGIN
    AslBase := OpenLibrary("asl.library",37);
    IF AslBase <> NIL THEN BEGIN
       fr := AllocAslRequestTags(ASL_FileRequest,
                          ASLFR_InitialPattern,"#?",
                          ASLFR_TitleText,"Test of ASL-Requester in PCQ",
                          ASLFR_DoPatterns,True,
                          TAG_DONE);
       IF fr <> NIL THEN BEGIN
           dummy := AslRequest(fr,NIL);
           FreeAslRequest(fr);
       END;
    CloseLibrary(AslBase);
    END;
END.



