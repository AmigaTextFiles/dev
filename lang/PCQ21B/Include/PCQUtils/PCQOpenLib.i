
TYPE

    OpenLibListPtr = ^OpenLibList;
    OpenLibList = RECORD
    Previous : OpenLibListPtr;
    Base : ADDRESS;
    END;
    
CONST
    HeadOpenLibList : OpenLibListPtr = NIL;


VAR
    TempOpenLibList : OpenLibListPtr;
    OldExitProcPointer : ADDRESS;


procedure pcqopenlib(libbase : ADDRESS; libname : STRING; libvers : INTEGER);
EXTERNAL;


                                                           
