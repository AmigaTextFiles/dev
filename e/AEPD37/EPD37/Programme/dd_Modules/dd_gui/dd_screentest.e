=0,
        mcc=NIL:PTR TO mui_customclass

    IF (muimasterbase:=OpenLibrary(MUIMASTER_NAME, MUIMASTER_VMIN))=NIL THEN
        Raise('Failed to open muimaster.library')

    /* Create the new custom class with a call to eMui_CreateCustomClass().*/

    IF (mcc:=eMui_CreateCustomClass(N