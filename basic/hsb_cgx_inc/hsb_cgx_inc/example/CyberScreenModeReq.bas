'CyberScreenModeReq.bas 0.1

'Compiler: HBC 2.0+
'Includes: 3.1
'Author:   steffen.leistner@styx.in-chemnitz.de

DEFLNG a-z

' $NOWINDOW
' $NOEVENT
' $NOSTACK
' $NOARRAY
' $NOLINES
' $NOVARCHECKS
' $NOAUTODIM
' $NOLIBRARY
' $UNDERLINES

' $INCLUDE exec.bh
' $INCLUDE dos.bh
' $INCLUDE asl.bh
' $INCLUDE graphics.bh
' $INCLUDE intuition.bh
' $INCLUDE utility.bh
' $INCLUDE cybergraphics.bh

CONST minver& = 37&
CONST aslver& = 38&
CONST cgxver& = 40&


FUNCTION ModeFilter& (BYVAL hook&, BYVAL req&, BYVAL modeid&)
    ModeFilter& = IsCyberModeID&(modeid&)
END FUNCTION


FUNCTION GetScreenMode&(title$, pos$, neg$, moderes&, widthres&, heightres&, depthres%)
    SHARED workbuf&, filter&
    
    GetScreenMode& = FALSE&
    
    req& = AllocAslRequest&(ASL_ScreenModeRequest&, NULL&)
    IF req&
    
        pubscreen& = LockPubScreen&(NULL&)
        IF pubscreen&

            TAGLIST workbuf&, _
                ASLSM_Screen&,              pubscreen&, _
                ASLSM_InitialWidth&,        PEEKW(pubscreen& + ScreenWidth%) \ 3, _
                ASLSM_InitialHeight&,       PEEKW(pubscreen& + ScreenHeight%) - 50, _
                ASLSM_InitialLeftEdge&,     PEEKW(pubscreen& + ScreenWidth%) \ 6, _
                ASLSM_InitialTopEdge&,      25&, _
                ASLSM_InitialInfoLeftEdge&, 2 * (PEEKW(pubscreen& + ScreenWidth%) \ 6), _
                ASLSM_FilterFunc&,          filter&, _
                ASLSM_InitialInfoOpened&,   TRUE&, _
                ASLSM_DoWidth&,             TRUE&, _
                ASLSM_DoHeight&,            TRUE&, _
                ASLSM_DoDepth&,             TRUE&, _
                ASLSM_PositiveText&,        pos$, _
                ASLSM_NegativeText&,        neg$, _
                ASLSM_TitleText&,           title$, _   
            TAG_END&
            
            IF AslRequest&(req&, workbuf&)
                GetScreenMode& = TRUE&
                moderes&    = PEEKL(req& + sm_DisplayID%)
                widthres&   = PEEKL(req& + sm_DisplayWidth%)
                heightres&  = PEEKL(req& + sm_DisplayHeight%)
                depthres%   = PEEKW(req& + sm_DisplayDepth%)
            END IF

            UnLockPubScreen NULL&, pubscreen&
        ELSE
            PrintMessage "Error:", "Can't lock default pubscreen!", "Break"
        END IF

        FreeAslRequest req&
    ELSE
        PrintMessage "Error:", "Can't create requester!", "Break"
    END IF
END FUNCTION


SUB PrintMessage (first$, second$, gadget$)
    IF PEEKL(SYSTAB + 8%)
        reqbufsize& = es_sizeof% + LEN(first$) + LEN(second$) + LEN(gadget$) + 4&
        easystruct& = AllocVec& (reqbufsize&, MEMF_PUPLIC& OR MEMF_CLEAR&)
        IF easystruct&
            toffs& = easystruct& + es_sizeof%
            CopyMem SADD(first$), toffs&, LEN(first$)
            POKEL easystruct& + es_Title%, toffs&
            toffs& = toffs& + LEN(first$) + 1&
            CopyMem SADD(second$), toffs&, LEN(second$)
            POKEL easystruct& + es_TextFormat%, toffs&
            toffs& = toffs& + LEN(second$) + 1&
            CopyMem SADD(gadget$), toffs&, LEN(gadget$)
            POKEL easystruct& + es_GadgetFormat%, toffs&
            junk& = EasyRequestArgs& (NULL&, easystruct&, NULL&, NULL&)
            FreeVec easystruct&
        END IF
    ELSE
        con$ = first$ + CHR$(10) + second$ + CHR$(10)
        junk& = xWrite&(xOutput&, SADD(con$), LEN(con$))
    END IF
END SUB


FUNCTION Main&
    SHARED workbuf&, filter&
    LIBRARY OPEN "exec.library", minver&
    LIBRARY OPEN "dos.library", minver&
    LIBRARY OPEN "asl.library", aslver&
    LIBRARY OPEN "graphics.library", minver&
    LIBRARY OPEN "intuition.library", minver&
    LIBRARY OPEN "cybergraphics.library", cgxver&

    Main& = RETURN_ERROR&
    workbuf& = AllocVec& (512&, MEMF_PUBLIC& OR MEMF_CLEAR&)
    IF workbuf& = NULL&
        PrintMessage "Error:", "Not enough memory!", "Break"
        EXIT FUNCTION
    END IF
    
    filter& = AllocVec& (Hook_sizeof%, MEMF_PUBLIC& OR MEMF_CLEAR&)
    IF filter& = NULL&
        FreeVec workbuf&
        PrintMessage "Error:", "Not enough memory!", "Break"
        EXIT FUNCTION
    END IF
    INITHOOK filter&, VARPTRS(ModeFilter&)
    
    Main& = RETURN_WARN&
    
    IF GetScreenMode& ("CyberGraphX-Screenmodes:", "Select", "Cancel", m&, w&, h&, d%)
        
        IF GetDisplayInfoData&(NULL&, workbuf&, NameInfo_sizeof%, DTAG_NAME&, m&)
        
            body$ = "ModeName  : " + PEEK$(workbuf& + NameInfoName%) + CHR$(10) + _
                    "ModeID    : $" + HEX$(m&) + CHR$(10) + _
                    "Dimensions: " + LTRIM$(STR$(w&)) + "x" + LTRIM$(STR$(h&)) + "x" + LTRIM$(STR$(d%))
            PrintMessage "Result:", body$, "Ok"
            Main& = RETURN_OK&
        
        ELSE
            PrintMessage "Result:", "Unknown Displaymode!", "Ok"
        END IF
        
    END IF

    FreeVec filter&
    FreeVec workbuf&

END FUNCTION

STOP Main&

DATA "$VER: CyberScreenModeReq.bas 0.1 "
