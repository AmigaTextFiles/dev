/* */

MUIM_Notify = 0x8042c9cb
MUIM_Set = 0x8042549a

MUIA_NoNotify = 0x804237f9
MUIA_String_Contents = 0x80428ffd

MUIA_HTMLtext_Contents = 0x90a40001
MUIA_HTMLtext_Title = 0x90a40003
MUIA_HTMLtext_Path = 0x90a40004
MUIA_HTMLtext_OpenURLHook = 0x90a40005
MUIA_HTMLtext_URL = 0x90a40006
MUIA_HTMLtext_LoadImages = 0x90a4000c
MUIA_HTMLtext_Block = 0x90a4000d

/* TAG variable definitions */

MUIV_EveryTime = 0x49893131
MUIV_TriggerValue = 0x49893131
TRUE = 1
FALSE = 0

address DEMO

window TITLE '"HTMLtext Demo"' COMMAND '"quit"' PORT DEMO
    group FRAME
        object ID HTML CLASS '"HTMLtext.mcc"' ATTRS,
            MUIA_HTMLtext_Path '"muirexx:docs/html"',
            MUIA_HTMLtext_URL '"muirexx:docs/html/main.html"'
    endgroup
    group HORIZ
        image SPEC '"4:MUI:Images/WD/13pt/ArrowUp.mf0"' PORT INLINE COMMAND """
            options results;
            address DEMO;
            popasl ID SURL;
            getvar result;
            url = result;
            object ID HTML ATTRS "MUIA_NoNotify" 1 "MUIA_HTMLtext_URL" url;
            popasl ID SURL CONTENT url;
            """
        popasl ID SURL PORT DEMO COMMAND """object ID HTML ATTRS "MUIA_NoNotify" 1 "MUIA_HTMLtext_URL" %s""" CONTENT 'muirexx:docs/html/main.html' 
    endgroup
endwindow

callhook ID HTML TRIG MUIA_HTMLtext_URL MUIV_EveryTime PORT INLINE COMMAND """
    options results;
    address DEMO;
    object ID HTML ATTRS "MUIA_HTMLtext_URL";
    url = import(d2c(result));
    popasl ID SURL;
    setvar url result;
    popasl ID SURL CONTENT url;
    """
