PROGRAM AslTest;

uses Exec, Utility, Asl, vartags,msgbox;


{    
     History:
     Now use TAGS and pas2c.
     Removed the opening of asl.library,
     handled by unit asl.
     1 Nov 1998.

     Added MessageBox for report.
     31 Jul 2000.

     nils.sjoholm@mailbox.swipnet.se
}

VAR
    fr    : pFileRequester;
    dummy : BOOLEAN;
BEGIN

    fr := AllocAslRequest(ASL_FileRequest,TAGS(
                          ASLFR_InitialPattern,Longstr('#?'),
                          ASLFR_TitleText,Longstr('Test av ASL-Requester by NS'),
                          ASLFR_DoPatterns,ltrue,
                          TAG_DONE));

    IF fr <> nil THEN BEGIN
        dummy := AslRequest(fr,NIL);
        if dummy then begin
           MessageBox('Test of Asl',
                      ' The path is :' +
                      strpas(fr^.rf_Dir) +
                      chr(10) +
                      'And the file is :' +
                      strpas(fr^.rf_File),
                      'OK');
        end else MessageBox('Test of Asl','You canceled','OK');
        FreeAslRequest(fr);
    END;
END.



