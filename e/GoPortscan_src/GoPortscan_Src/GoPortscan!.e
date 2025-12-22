OPT PREPROCESS, LARGE, OSVERSION=37

/*
    Program:     Go Portscan
    Version:     V1.1
    Author :     Ian Chapman
    Description: TCP/UDP Portscanner with service lookup, ICMP & UDP Traceroute,
                 ICMP & UDP Ping, Forward & Reverse Resolving, Ping Sweep,
                 MUI Interface, Localisation

    LICENSE: Permission is granted to use this source code in whole or in part,
             providing that the author (Ian Chapman) is credited in your project
             in either the documentation, or the program itself. This applies to
             both free and commercial software. In the case of commercial
             software (including ShareWare), I am entitled to a free, fully
             functional copy of the software.

             NO WARRANTY EITHER EXPRESSED OR IMPLIED AS TO THE FITNESS OF THIS
             CODE FOR ANY PURPOSE. ALL USE IS ENTIRELY AND WHOLLY AT YOUR OWN
             RISK

*/

MODULE  'miami/netinclude/pragmas/socket',
        'miami/netinclude/pragmas/miami',
        'amitcp/sys/socket',
        'amitcp/sys/types',
        'amitcp/sys/time',
        'amitcp/sys/errno',
        'amitcp/sys/ioctl',
        'amitcp/netdb',
        'amitcp/netinet/in',
        'amitcp/netinet/ip_icmp',
        'amitcp/netinet/ip',
        'amitcp/netinet/tcp',
        'amitcp/netinet/udp',
        'libraries/gadtools',
        'libraries/mui',
        'libraries/reqtools',
        'mui/busy_mcc',
        'mui/betterstring_mcc',
        'utility/tagitem',
        'utility/hooks',
        'exec/io',
        'exec/memory',
        'amigalib/boopsi',
        'intuition/classusr',
        'dos/dos',
        'tools/installhook',
        'oomodules/softtimer_oo',
        'devices/timer',
        'muimaster',
        'reqtools',
        'icon',
        '*servicetable',
        '*texts',
        '*newlogo',
        '*gpobjects',
        '*enums',
        'timer'

#define ibu(i)\
 ImageObject,\
    ImageButtonFrame,\
    MUIA_Background, MUII_ButtonBack,\
    MUIA_InputMode , MUIV_InputMode_RelVerify,\
    MUIA_Image_Spec, i,\
    MUIA_CycleChain, 1,\
    End

CONST ICMPIDNUM=1066, TCPSEQNUM=19901000, TH_OFFSET=5, TCP_WINDOW_SIZE=512

->Exception handlers
RAISE ERR_NOMEM IF NewM()=NIL,
      ERR_NOSOCK IF Socket()=-1

DEF app,
    mui_main_win,       -> WINDOW
    mui_lookup_win,     -> WINDOW
    mui_workingon_tb,
    mui_portrange_tb,
     mui_lookup_tb,
    mui_output_lst,
    running=TRUE,
    servicedesc[500]:STRING,
    site[81]:STRING,
    workonstr[40]:STRING,
    logpath[150]:STRING,
    trojanflag=MUI_TRUE,
    readportflag=0,
    wakeupflag=0,
    blockingflag=MUI_TRUE,
    stealthflag=0,
    closedflag=0,
    timeflag=2,
    delayflag=0,
    abortflag=FALSE,
    serviceflag=MUI_TRUE,
    tracednsflag=MUI_TRUE,
    tracemaxhopsflag=30,
    pingsweepdnsflag=FALSE,
    pingsweepshowicmpflag=FALSE,
    pingsweeptype=0,
    scantype=0,
    troutetype=0,
    helperchoice=0,
    timerdelay:PTR TO softtimer,
    servicecheckflag=MUI_TRUE,
    gplogo=NIL,
    diskobj=NIL,
    tr:PTR TO timerequest,
    timereq1:PTR TO timeval,
    timereq2:PTR TO timeval,
    start:PTR TO portentry,
    logwarnflag=0,
    bmarkchanged=0

PROC main() HANDLE
DEF mui_bookmark_win,   -> WINDOW
    mui_customrange_win,-> WINDOW
    mui_prefs_win,      -> WINDOW
    mui_helper_win,     -> WINDOW
    mui_service_chk,
    mui_readports_chk,
    mui_wakeup_chk,
    mui_trojan_chk,
    mui_blocking_chk,
    mui_stealth_chk,
    mui_closed_chk,
    mui_tracedns_chk,
    mui_sweepicmp_chk,
    mui_sweepdns_chk,
    mui_prefservice_chk,
    mui_bookmark_lst,
    mui_scantype_cyc,
    mui_portrange_cyc,
    mui_tracetype_cyc,
    mui_sweeptype_cyc,
    mui_lookup_cyc,
    mui_bookmark_lv,
    mui_output_lv,
    mui_sweepaddr_num,
    mui_ping_num,
    mui_rptimeout_sli,
    mui_delay_sli,
    mui_tracemaxhops_sli,
    mui_delayup_but,
    mui_delaydown_but,
    mui_freq_but,
    mui_scan_but,
    mui_abort_but,
    mui_showbookwin_but,
    mui_showcustomwin_but,
    mui_icmpping_but,
    mui_udpping_but,
    mui_sweep_but,
    mui_resolve_but,
    mui_trace_but,
    mui_logsave_but,
    mui_bookmarkdel_but,
    mui_bookmarkadd_but,
    mui_lookup_but,
    mui_customcancel_but,
    mui_customok_but,
    mui_ftphelp_but,
    mui_webhelp_but,
    mui_telhelp_but,
    mui_otherhelp_but,
    mui_prefsave_but,
    mui_prefuse_but,
    mui_prefcancel_but,
    mui_logpath_tb,
    mui_host_tb,
    mui_bookmark_tb,
    mui_custom_tb,
    mui_telhelp_tb,
    mui_ftphelp_tb,
    mui_webhelp_tb,
    mui_otherhelp_tb,
    mui_busy_bar,
    mui_pages,
    mui_tabs,    
    cyctxt_lookup,
    cyctxt_scantype,
    cyctxt_pingsweeptype,
    cyctxt_range[25]:ARRAY OF LONG,
    cyctxt_values[25]:ARRAY OF LONG,
    portrange_cycval,
    lookup_cycval,
    portrange[200]:STRING,    
    pingnumstr[3]:STRING,
    pingsweepnumstr[5]:STRING,
    bookstr[81]:STRING,
    bookinstr[81]:STRING,
    bookoutstr[81]:STRING,
    bentries[100]:STRING,
    lookupstr[51]:STRING,
    customname[21]:STRING,    
    preftelstr[150]:STRING,
    prefftpstr[150]:STRING,
    prefwebstr[150]:STRING,
    prefotherstr[150]:STRING,
    preftelstrtmp[150]:STRING,
    prefftpstrtmp[150]:STRING,
    prefwebstrtmp[150]:STRING,
    prefotherstrtmp[150]:STRING,
    logpathtmp[150]:STRING,
    prefvalstmp[3]:ARRAY OF LONG,
    i,
    entries,
    bookfh,
    customfh,
    customtemp,
    x=0,
    result,
    signal,
    menu

inittexts()
cyctxt_range[0]:=txt_Face_PortCyc1
cyctxt_range[1]:=txt_Face_PortCyc2
cyctxt_range[2]:=txt_Face_PortCyc3
cyctxt_range[3]:=txt_Face_PortCyc4
cyctxt_range[4]:=txt_Face_PortCyc5

->Initialise the list for safety's sake
FOR x:=5 TO 25 DO cyctxt_range[x]:=NIL

->Read the entries from the custom ranges file.
IF (customfh:=Open('envarc:goportscan.ranges', MODE_OLDFILE))>0
    customtemp:=String(21)
    x:=5
    WHILE Fgets(customfh, customtemp, 21)>NIL
        StrCopy(customtemp, customtemp, StrLen(customtemp)-1)
        StringF(customtemp, '\eb\d: \s', x-4, customtemp)
        cyctxt_range[x]:=customtemp
        customtemp:=String(200)
        Fgets(customfh, customtemp, 200)
        StrCopy(customtemp, customtemp, StrLen(customtemp)-1)
        cyctxt_values[x]:=customtemp
        customtemp:=String(21)
        x++
    ENDWHILE
    Close(customfh)
ENDIF

cyctxt_lookup:=[txt_Face_LookupCyc1, txt_Face_LookupCyc2, txt_Face_LookupCyc3, NIL]
cyctxt_scantype:=[txt_Face_ScanTypeCyc1, txt_Face_ScanTypeCyc2, txt_Face_ScanTypeCyc3, txt_Face_ScanTypeCyc4, NIL]
cyctxt_pingsweeptype:=[txt_Face_PingSweepCyc1, txt_Face_PingSweepCyc2, NIL]
mui_pages:=[txt_Face_Pages1, txt_Face_Pages2, txt_Face_Pages3, txt_Face_Pages4, NIL]

menu:=[ NM_TITLE, 0, txt_MenuTitle_Project, 0, 0, 0, 0,
        NM_ITEM,  0, txt_MenuItem_About, '?', 0, 0, ID_ABOUT,
        NM_ITEM,  0, txt_MenuItem_AboutMUI, 0, 0, 0, ID_MUIABOUT,
        NM_ITEM,  0,  NM_BARLABEL, 0, 0, 0, 0,
        NM_ITEM,  0, txt_MenuItem_ServiceLook, 'S', 0, 0, ID_OPENLOOKUP,
        NM_ITEM,  0, txt_MenuItem_Bookmarks, 'B', 0, 0, ID_OPENBOOK,
        NM_ITEM,  0, NM_BARLABEL, 0, 0, 0, 0,
        NM_ITEM,  0, txt_MenuItem_Iconify, 'I', 0, 0, ID_ICONIFY,
        NM_ITEM,  0, txt_MenuItem_Quit, 'Q', 0, 0, MUIV_Application_ReturnID_Quit,
        NM_TITLE, 0, txt_MenuTitle_Settings, 0, 0, 0, 0,
        NM_ITEM,  0, txt_MenuItem_MuiSettings, 0, 0, 0, ID_MUISET,
        NM_ITEM,  0, txt_MenuItem_Prefs, 'P', 0, 0, ID_PREFS,
        NM_ITEM,  0, NM_BARLABEL, 0, 0, 0, 0,
        NM_ITEM,  0, txt_MenuItem_PrefSave, 0, 0, 0, ID_SAVEPREF,
        NM_END,   0, NIL, 0,0,0,0]:newmenu

IF (socketbase:=OpenLibrary('bsdsocket.library', 2)) = NIL THEN Raise(ERR_NOBSD)
IF (miamibase:=OpenLibrary('miami.library', NIL)) = NIL THEN WriteF('No Miami\n')
IF (muimasterbase:=OpenLibrary('muimaster.library',19))=NIL THEN Raise(ERR_NOMUI)
IF (reqtoolsbase:=OpenLibrary('reqtools.library',38))=NIL THEN Raise(ERR_NOASL)
IF (iconbase:=OpenLibrary('icon.library', 33))=NIL THEN Raise(ERR_NOICON)

->##GADGETS FOR THE MAIN WINDOW
gplogo:=imgGplogoObject()

mui_showbookwin_but:=ibu(MUII_PopUp)
mui_showcustomwin_but:=ibu(MUII_ArrowRight)
mui_logsave_but:=ibu(MUII_Disk)

mui_host_tb:=BetterStringObject, StringFrame,
            MUIA_String_AdvanceOnCR, MUI_TRUE,
            MUIA_String_Contents, site,
            MUIA_ShortHelp, txt_Bubble_Server,
            MUIA_CycleChain, 1,
            MUIA_ObjectID, OBID_HOST_TB,
            End

mui_portrange_tb:=BetterStringObject, StringFrame,
               MUIA_String_AdvanceOnCR, MUI_TRUE,
               MUIA_String_Accept, '0123456789-,',
               MUIA_String_Reject, FALSE,
               MUIA_String_MaxLen, 199,
               MUIA_String_Contents, portrange,
               MUIA_ShortHelp, txt_Bubble_Portrange,
               MUIA_CycleChain, 1,
               MUIA_ObjectID, OBID_PORTRANGE_TB,
               End

mui_workingon_tb:=TextObject, TextFrame,
               MUIA_String_Contents, txt_Face_Workingon10,
               MUIA_ShortHelp, txt_Bubble_Workingon,
               End

mui_sweepaddr_num:=BetterStringObject, StringFrame,
                  MUIA_String_AdvanceOnCR, MUI_TRUE,
                  MUIA_String_MaxLen, 5,
                  MUIA_String_Contents, pingsweepnumstr,
                  MUIA_String_Accept, '1234567890',
                  MUIA_ShortHelp, txt_Bubble_Pingsweepnum,
                  MUIA_String_Format, MUIV_String_Format_Right,
                  MUIA_CycleChain, 1,
                  MUIA_ObjectID, OBID_SWEEPADDR_NUM,
                  End

mui_delayup_but:=ibu(MUII_ArrowUp)

mui_delay_sli:=NumericbuttonObject,
               MUIA_Numeric_Min, 0,
               MUIA_Numeric_Max, 20,
               MUIA_Numeric_Value, delayflag,
               MUIA_Numeric_Format, '%lds',
               MUIA_ShortHelp, txt_Bubble_Delay,
               MUIA_CycleChain, 1,
               MUIA_ObjectID, OBID_DELAY_SLI,
               End

mui_delaydown_but:=ibu(MUII_ArrowDown)

mui_output_lv:=ListviewObject,
              MUIA_Listview_Input, MUI_TRUE,
              MUIA_CycleChain, 1,
              MUIA_Listview_List, mui_output_lst:=ListObject,
                  ReadListFrame,
                      MUIA_List_ConstructHook, MUIV_List_ConstructHook_String,
                      MUIA_List_DestructHook, MUIV_List_DestructHook_String,
                      MUIA_ShortHelp, txt_Bubble_OutputLV,
                  End, ->ReadlistFrame
              End ->Lstviewobject

mui_busy_bar:=BusyObject,
             MUIA_Busy_Speed, MUIV_Busy_Speed_User,
             End

mui_ping_num:=BetterStringObject, StringFrame,
             MUIA_String_AdvanceOnCR, MUI_TRUE,
             MUIA_String_Accept, '0123456789',
             MUIA_String_Contents, pingnumstr,
             MUIA_String_MaxLen, 4,
             MUIA_String_Format, MUIV_String_Format_Right,
             MUIA_ShortHelp, txt_Bubble_PingNum,
             MUIA_CycleChain, 1,
             MUIA_ObjectID, OBID_PING_NUM,
             End

mui_icmpping_but:=SimpleButton(txt_Face_Ping)
mui_udpping_but:=SimpleButton(txt_Face_UDPPing)
mui_resolve_but:=SimpleButton(txt_Face_Resolve)
mui_trace_but:=SimpleButton(txt_Face_Traceroute)
mui_sweep_but:=SimpleButton(txt_Face_Pingsweep)
mui_scan_but:=SimpleButton(txt_Face_Scan)
mui_abort_but:=SimpleButton(txt_Face_Abort)
mui_readports_chk:=CheckMark(readportflag)
mui_service_chk:=CheckMark(servicecheckflag)
mui_wakeup_chk:=CheckMark(wakeupflag)
mui_trojan_chk:=CheckMark(trojanflag)
mui_stealth_chk:=CheckMark(stealthflag)
mui_closed_chk:=CheckMark(closedflag)
mui_tracedns_chk:=CheckMark(tracednsflag)
mui_sweepdns_chk:=CheckMark(pingsweepdnsflag)
mui_sweepicmp_chk:=CheckMark(pingsweepshowicmpflag)

mui_tracemaxhops_sli:=SliderObject,
                  MUIA_Slider_Min, 1,
                  MUIA_Slider_Max, 255,
                  MUIA_Slider_Level, tracemaxhopsflag,
                  MUIA_ShortHelp, txt_Bubble_Tracemaxhops,
                  MUIA_CycleChain, 1,
                  MUIA_ObjectID, OBID_TRACEMAXHOPS_SLI,
                  End

mui_tracetype_cyc:=KeyCycle(['ICMP', 'UDP', NIL, NIL], "t")
mui_portrange_cyc:=KeyCycle(cyctxt_range, "r")
mui_scantype_cyc:=KeyCycle(cyctxt_scantype, "t")
mui_sweeptype_cyc:=KeyCycle(cyctxt_pingsweeptype, "p")

->##GADGETS FOR THE BOOKMARK WINDOW
mui_bookmark_lv:=ListviewObject,
                MUIA_Listview_Input, MUI_TRUE,
                MUIA_CycleChain, 1,
                MUIA_Listview_List, mui_bookmark_lst:=ListObject,
                    ReadListFrame,
                        MUIA_List_ConstructHook, MUIV_List_ConstructHook_String,
                        MUIA_List_DestructHook, MUIV_List_DestructHook_String,
                        MUIA_ShortHelp, txt_Bubble_BookmarkLV,
                    End,
                End

mui_bookmark_tb:=BetterStringObject, StringFrame,
                 MUIA_String_AdvanceOnCR, MUI_TRUE,
                 MUIA_String_Contents, bookstr,
                 MUIA_ShortHelp, txt_Bubble_Bookmarkstr,
                 MUIA_CycleChain, 1,
                 End

mui_bookmarkadd_but:=SimpleButton(txt_Face_Bookmarkadd)
mui_bookmarkdel_but:=SimpleButton(txt_Face_Bookmarkdel)

->##THESE ARE THE GADGETS FOR THE LOOKUP WINDOW
mui_lookup_tb:=BetterStringObject, StringFrame,
                  MUIA_String_AdvanceOnCR, MUI_TRUE,
                  MUIA_String_Contents, lookupstr,
                  MUIA_String_Accept, ',-0123456789',
                  MUIA_String_MaxLen, 50,
                  MUIA_ShortHelp, txt_Bubble_Lookupstring1,
                  MUIA_CycleChain, 1,
                  End

mui_lookup_but:=SimpleButton(txt_Face_Lookup)
mui_lookup_cyc:=KeyCycle(cyctxt_lookup, "l")

->##GADGETS FOR THE CUSTOM WINDOW
mui_custom_tb:=BetterStringObject, StringFrame,
               MUIA_String_AdvanceOnCR, MUI_TRUE,
               MUIA_String_Contents, customname,
               MUIA_String_MaxLen, 20,
               MUIA_ShortHelp, 'Name',
               MUIA_CycleChain, 1,
               End

mui_customok_but:=SimpleButton(txt_Face_OK)
mui_customcancel_but:=SimpleButton(txt_Face_Cancel)

->##GADGETS FOR THE PREFS WINDOW
mui_telhelp_tb:=BetterStringObject, StringFrame,
             MUIA_String_AdvanceOnCR, MUI_TRUE,
             MUIA_String_Contents, 'miami:miamitelnet %h %p',
             MUIA_String_MaxLen, 149,
             MUIA_ShortHelp, txt_Bubble_PrefTel,
             MUIA_CycleChain, 1,
             MUIA_ObjectID, OBID_TELHELP_TB,
             End

mui_ftphelp_tb:=BetterStringObject, StringFrame,
             MUIA_String_AdvanceOnCR, MUI_TRUE,
             MUIA_String_Contents, 'aweb3:aweb-ii URL=ftp://%h:%p',
             MUIA_String_MaxLen, 149,
             MUIA_ShortHelp, txt_Bubble_PrefFTP,
             MUIA_CycleChain, 1,
             MUIA_ObjectID, OBID_FTPHELP_TB,
             End

mui_webhelp_tb:=BetterStringObject, StringFrame,
             MUIA_String_AdvanceOnCR, MUI_TRUE,
             MUIA_String_Contents, 'aweb3:aweb-ii URL=http://%h:%p',
             MUIA_String_MaxLen, 149,
             MUIA_ShortHelp, txt_Bubble_PrefWeb,
             MUIA_CycleChain, 1,
             MUIA_ObjectID, OBID_WEBHELP_TB,
             End

mui_otherhelp_tb:=BetterStringObject, StringFrame,
               MUIA_String_AdvanceOnCR, MUI_TRUE,
               MUIA_String_Contents, 'vva H=%h P=%p',
               MUIA_String_MaxLen, 149,
               MUIA_ShortHelp, txt_Bubble_PrefOther,
               MUIA_CycleChain, 1,
               MUIA_ObjectID, OBID_OTHERHELP_TB,
               End

mui_rptimeout_sli:=SliderObject,
             MUIA_Slider_Min, 1,
             MUIA_Slider_Max, 20,
             MUIA_Slider_Level, timeflag,
             MUIA_ShortHelp, txt_Bubble_Timeout,
             MUIA_CycleChain, 1,
             MUIA_ObjectID, OBID_RPTIMEOUT_SLI,
             End

mui_logpath_tb:=BetterStringObject, StringFrame,
             MUIA_String_AdvanceOnCR, MUI_TRUE,
             MUIA_String_MaxLen, 149,
             MUIA_ShortHelp, txt_Bubble_Savepath,
             MUIA_CycleChain, 1,
             MUIA_ObjectID, OBID_LOGPATH_TB,
             End

mui_freq_but:=ibu(MUII_PopFile)
mui_blocking_chk:=CheckMark(blockingflag)
mui_prefservice_chk:=CheckMark(serviceflag)
mui_prefsave_but:=SimpleButton(txt_Face_PrefSave)
mui_prefuse_but:=SimpleButton(txt_Face_PrefUse)
mui_prefcancel_but:=SimpleButton(txt_Face_PrefCancel)

->##SET FUNCTIONS FOR THE MAIN WINDOW
SetAttrsA(mui_scan_but, [MUIA_ShortHelp, txt_Bubble_Scan, MUIA_CycleChain, 1, TAG_DONE])
SetAttrsA(mui_resolve_but, [MUIA_ShortHelp, txt_Bubble_Resolve, MUIA_CycleChain, 1, TAG_DONE])
SetAttrsA(mui_abort_but, [MUIA_ShortHelp, txt_Bubble_Abort, MUIA_CycleChain, 1, TAG_DONE])
SetAttrsA(mui_readports_chk, [MUIA_ShortHelp, txt_Bubble_Readcheck, MUIA_CycleChain, 1, MUIA_ObjectID, OBID_READPORTS_CHK, TAG_DONE])
SetAttrsA(mui_service_chk, [MUIA_ShortHelp, txt_Bubble_Servicecheck, MUIA_CycleChain, 1, MUIA_ObjectID, OBID_SERVICE_CHK, TAG_DONE])
SetAttrsA(mui_wakeup_chk, [MUIA_ShortHelp, txt_Bubble_Wakeup, MUIA_CycleChain, 1, MUIA_ObjectID, OBID_WAKEUP_CHK, TAG_DONE])
SetAttrsA(mui_trojan_chk, [MUIA_ShortHelp, txt_Bubble_Showtrojan, MUIA_CycleChain, 1, MUIA_ObjectID, OBID_TROJAN_CHK, TAG_DONE])
SetAttrsA(mui_stealth_chk, [MUIA_ShortHelp, txt_Bubble_Stealth_Chk, MUIA_CycleChain, 1, MUIA_ObjectID, OBID_STEALTH_CHK, TAG_DONE])
SetAttrsA(mui_closed_chk, [MUIA_ShortHelp, txt_Bubble_Closed_Chk, MUIA_CycleChain, 1, MUIA_ObjectID, OBID_CLOSED_CHK, TAG_DONE])
SetAttrsA(mui_portrange_cyc, [MUIA_ShortHelp, txt_Bubble_Portrangecyc, MUIA_CycleChain, 1, TAG_DONE])
SetAttrsA(mui_showcustomwin_but, [MUIA_ShortHelp, txt_Bubble_Opencustom, MUIA_CycleChain, 1, TAG_DONE])
SetAttrsA(mui_scantype_cyc, [MUIA_ShortHelp, txt_Bubble_Scantype, MUIA_CycleChain, 1, MUIA_ObjectID, OBID_SCANTYPE_CYC, TAG_DONE])
SetAttrsA(mui_icmpping_but, [MUIA_ShortHelp, txt_Bubble_Ping, MUIA_CycleChain, 1, TAG_DONE])
SetAttrsA(mui_udpping_but, [MUIA_ShortHelp, txt_Bubble_UDPPing, MUIA_CycleChain, 1, TAG_DONE])
SetAttrsA(mui_trace_but, [MUIA_ShortHelp, txt_Bubble_Traceroute, MUIA_CycleChain, 1, TAG_DONE])
SetAttrsA(mui_tracedns_chk, [MUIA_ShortHelp, txt_Bubble_Tracedns, MUIA_CycleChain, 1, MUIA_ObjectID, OBID_TRACEDNS_CHK, TAG_DONE])
SetAttrsA(mui_tracetype_cyc, [MUIA_ShortHelp, txt_Bubble_TrouteType, MUIA_CycleChain, 1, MUIA_ObjectID, OBID_TROUTETYPE_CYC, TAG_DONE])
SetAttrsA(mui_sweepdns_chk, [MUIA_ShortHelp, txt_Bubble_Pingsweepdns, MUIA_CycleChain, 1, MUIA_ObjectID, OBID_SWEEPDNS_CHK, TAG_DONE])
SetAttrsA(mui_sweepicmp_chk, [MUIA_ShortHelp, txt_Bubble_Pingsweepshowicmp, MUIA_CycleChain, 1, MUIA_ObjectID, OBID_SWEEPICMP_CHK, TAG_DONE])
SetAttrsA(mui_sweeptype_cyc, [MUIA_ShortHelp, txt_Bubble_Pingsweeptype, MUIA_CycleChain, 1, MUIA_ObjectID, OBID_SWEEPTYPE_CYC, TAG_DONE])
SetAttrsA(mui_logsave_but, [MUIA_ShortHelp, txt_Bubble_Logviewbutton, MUIA_CycleChain, 1, TAG_DONE])
SetAttrsA(mui_sweep_but, [MUIA_ShortHelp, txt_Bubble_Pingsweep, MUIA_CycleChain, 1, TAG_DONE])
SetAttrsA(mui_showbookwin_but, [MUIA_ShortHelp, txt_Bubble_Openbookmarks, MUIA_CycleChain, 1, TAG_DONE])
->##SET FUNCTIONS FOR THE BOOKMARKS WINDOW
SetAttrsA(mui_bookmarkadd_but, [MUIA_ShortHelp, txt_Bubble_Bookmarkadd, MUIA_CycleChain, 1, TAG_DONE])
SetAttrsA(mui_bookmarkdel_but, [MUIA_ShortHelp, txt_Bubble_Bookmarkdel, MUIA_CycleChain, 1, TAG_DONE])
->##SET FUNCTIONS FOR THE LOOKUP WINDOW
SetAttrsA(mui_lookup_but, [MUIA_ShortHelp, txt_Bubble_Lookup, MUIA_CycleChain, 1, TAG_DONE])
SetAttrsA(mui_lookup_cyc, [MUIA_ShortHelp, txt_Bubble_Lookupcyc1, MUIA_CycleChain, 1, TAG_DONE])
->##SET FUNCTIONS FOR THE CUSTOM RANGE WINDOW
SetAttrsA(mui_customok_but, [MUIA_ShortHelp, txt_Bubble_Customok, MUIA_CycleChain, 1, TAG_DONE])
SetAttrsA(mui_customcancel_but, [MUIA_ShortHelp, txt_Bubble_Customcancel, MUIA_CycleChain, 1, TAG_DONE])
SetAttrsA(mui_custom_tb, [MUIA_ShortHelp, txt_Bubble_Customstr, MUIA_CycleChain, 1, TAG_DONE])
->##SET FUNCTIONS FOR THE PREFS WINDOW
SetAttrsA(mui_blocking_chk, [MUIA_ShortHelp, txt_Bubble_Blocking_Chk, MUIA_CycleChain, 1, MUIA_ObjectID, OBID_BLOCKING_CHK, TAG_DONE])
SetAttrsA(mui_prefsave_but, [MUIA_ShortHelp, txt_Bubble_PrefSave, MUIA_CycleChain, 1, TAG_DONE])
SetAttrsA(mui_prefuse_but, [MUIA_ShortHelp, txt_Bubble_PrefUse, MUIA_CycleChain, 1, TAG_DONE])
SetAttrsA(mui_prefcancel_but, [MUIA_ShortHelp, txt_Bubble_PrefCancel, MUIA_CycleChain, 1, TAG_DONE])
SetAttrsA(mui_prefservice_chk, [MUIA_ShortHelp, txt_Bubble_Prefservice, MUIA_CycleChain, 1, TAG_DONE])
SetAttrsA(mui_freq_but, [MUIA_ShortHelp, txt_Bubble_Freq, MUIA_CycleChain, 1, TAG_DONE])

->Simple fix if the user has decided to strip the language extention
IF FileLength(txt_HelpFile) = -1 THEN StrCopy(txt_HelpFile, 'PROGDIR:GoPortscan!.guide')

app:=ApplicationObject,
    MUIA_Application_Title      , 'Go Portscan!',
    MUIA_Application_Version    , '$VER: Go Portscan! 1.1',
    MUIA_Application_Copyright  , 'Written By Ian Chapman (2001-2003)',
    MUIA_Application_Author     , 'Ian Chapman',
    MUIA_Application_Description, 'TCP/UDP Portscanner',
    MUIA_Application_Base       , 'GOPORTSCAN',
    MUIA_Application_SingleTask , FALSE,
    MUIA_Application_DiskObject , diskobj:=GetDiskObject('ENVARC:sys/def_goportscan'),
    MUIA_Application_Menustrip  , Mui_MakeObjectA(MUIO_MenustripNM,[menu,0]),
    MUIA_Application_HelpFile   , txt_HelpFile,
    MUIA_Application_Iconified  , MUI_TRUE,
    
    SubWindow, mui_main_win:=WindowObject,
    MUIA_Window_Title           , txt_MainWindow_Title,
    MUIA_Window_ID              , "GOPO",
    MUIA_Window_Activate        , MUI_TRUE,
    MUIA_HelpNode               , 'Main Window',

    WindowContents, VGroup,
                        Child, HGroup,
                            Child, TextObject,
                                    TextFrame,
                                        MUIA_Text_Contents, txt_Text_Main,
                                        MUIA_Background, MUII_FILL,
                                    End,
                            Child, gplogo,
                        End, ->HGroup
                        Child, ColGroup(2), 
                            Child, Label(txt_Label_Host),
                            Child, HGroup,
                                Child, mui_host_tb,
                                Child, mui_showbookwin_but,
                            End, ->HGroup
                        End, ->ColGroup
                        Child, mui_tabs:=RegisterGroup(mui_pages),
                            Child, VGroup,
                                Child, ColGroup(2),
                                    Child, Label(txt_Label_Ports),
                                    Child, HGroup,
                                        Child, mui_portrange_tb,
                                        Child, mui_showcustomwin_but,
                                        Child, KeyLabel1(txt_Label_Range,"r"),
                                        Child, mui_portrange_cyc,
                                    End, ->Hgroup
                                    Child, KeyLabel1(txt_Label_Scantype, "t"),
                                    Child, mui_scantype_cyc,
                                End, ->ColGroup

                                Child, HGroup,
                                    Child, ColGroup(6),
                                        Child, Label(txt_Label_Servicecheck),
                                        Child, mui_service_chk,
                                        Child, Label(txt_Label_Readports),
                                        Child, mui_readports_chk,
                                        Child, Label(txt_Label_Wakeup),
                                        Child, mui_wakeup_chk,
                                        Child, Label(txt_Label_Showtrojan),
                                        Child, mui_trojan_chk,
                                        Child, Label(txt_Label_Stealth_Chk),
                                        Child, mui_stealth_chk,
                                        Child, Label(txt_Label_Closed_Chk),
                                        Child, mui_closed_chk,
                                    End,
                                Child, HSpace(0),
                                End, ->HGroup
                                Child, mui_scan_but,
                            End, ->VGroup

                            Child, VGroup,
                                Child, ColGroup(2),
                                    Child, Label(txt_Label_Maxhops),
                                    Child, mui_tracemaxhops_sli,
                                    Child, KeyLabel1(txt_Label_TrouteType, "t"),
                                    Child, mui_tracetype_cyc,
                                    Child, Label(txt_Label_Dnslookup),
                                    Child, HGroup,
                                        Child, mui_tracedns_chk,
                                        Child, mui_trace_but,
                                    End, ->HGroup
                                End, ->ColGroup      
                            End, ->VGroup

                            Child, VGroup,
                                Child, ColGroup(4),
                                    Child, Label(txt_Label_Numaddresses),
                                    Child, mui_sweepaddr_num,
                                    Child, Label(txt_Label_Dnslookup),
                                    Child, mui_sweepdns_chk,
                                    Child, Label(txt_Label_Sweeptype),
                                    Child, mui_sweeptype_cyc,
                                    Child, Label(txt_Label_Reportnonecho),
                                    Child, mui_sweepicmp_chk,
                                End, ->ColGroup
                                Child, mui_sweep_but,
                            End, ->VGroup

                            Child, VGroup,
                                Child, HGroup,
                                    Child, Label(txt_Label_Ping),
                                    Child, mui_ping_num,
                                End,
                                Child, HGroup,
                                    Child, mui_icmpping_but,
                                    Child, mui_udpping_but,
                                End, ->HGroup
                                Child, mui_resolve_but,
                            End, ->VGroup

                        End, ->Register
                        Child, BalanceObject,
                        End, ->BalObj
                        Child, HGroup,
                            Child, Label(txt_Label_Workingon),
                            Child, mui_workingon_tb,
                            Child, mui_busy_bar,
                        End, -> HGroup
                        Child, HGroup,
                            Child, VGroup,
                                Child, VSpace(0),
                                Child, mui_delayup_but,
                                Child, mui_delay_sli,
                                Child, mui_delaydown_but,
                                Child, VSpace(0),
                                Child, mui_logsave_but,
                            End, ->VGroup
                                Child, mui_output_lv,
                        End, ->HGroup
                        Child, mui_abort_but,
              End, ->Vgroup
    End, ->WindowContents

    SubWindow, mui_bookmark_win:=WindowObject,
    MUIA_Window_Title      , txt_BookmarkWindow_Title,
    MUIA_Window_ID         , "BOOK",
    MUIA_Window_Activate   , MUI_TRUE,
    MUIA_HelpNode          , 'Bookmarks Window',

    WindowContents, VGroup,
                        Child, mui_bookmark_lv,
                        Child, mui_bookmark_tb,
                        Child, HGroup,
                            Child, mui_bookmarkadd_but,
                            Child, mui_bookmarkdel_but,
                        End,

                    End,
              End, ->WindowContents

    SubWindow, mui_lookup_win:=WindowObject,
    MUIA_Window_Title       , txt_LookWindow_Title,
    MUIA_Window_ID          , "LOOK",
    MUIA_Window_Activate    , MUI_TRUE,
    MUIA_HelpNode           , 'Service Lookup Window',

    WindowContents, VGroup,
                        Child, HGroup,
                                Child, mui_lookup_cyc,
                                Child, mui_lookup_tb,
                                End,

                        Child, mui_lookup_but,
                    End,
    End,

    SubWindow, mui_customrange_win:=WindowObject,
    MUIA_Window_Title       , txt_CustomrangeWindow_Title,
    MUIA_Window_ID          , "CUST",
    MUIA_Window_Activate    , MUI_TRUE,
    MUIA_HelpNode           , 'Main Window',

    WindowContents, VGroup,
                        Child, Label(txt_Text_Customrange),
                        Child, HGroup,
                            Child, Label(txt_Label_Customrange),
                            Child, mui_custom_tb,
                        End, ->HGroup,
                        Child, HGroup,
                            Child, mui_customok_but,
                            Child, mui_customcancel_but,
                        End, ->HGroup
                    End,
    End,

    SubWindow, mui_helper_win:=WindowObject,
    MUIA_Window_Title       , txt_HelperWindow_Title,
    MUIA_Window_ID          , "HELP",
    MUIA_Window_Activate    , MUI_TRUE,
    MUIA_Window_DepthGadget , FALSE,
    MUIA_Window_SizeGadget  , FALSE,
    MUIA_HelpNode           , 'Helper Window',
    MUIA_Window_NoMenus     , MUI_TRUE,

    WindowContents, VGroup,
                        Child, ColGroup(2),
                        Child, mui_telhelp_but:=SimpleButton('Telnet'),
                        Child, mui_ftphelp_but:=SimpleButton('FTP'),
                        Child, mui_webhelp_but:=SimpleButton('Web (HTTP)'),
                        Child, mui_otherhelp_but:=SimpleButton('Other'),
                        End, ->ColGroup
                    End, ->VGroup
    End,

    SubWindow, mui_prefs_win:=WindowObject,
    MUIA_Window_Title       , txt_PrefsWindow_Title,
    MUIA_Window_ID          , "PREF",
    MUIA_Window_Activate    , MUI_TRUE,
    MUIA_HelpNode           , 'Preferences Window',
    ->MUIA_Window_NoMenus     , MUI_TRUE,

    WindowContents, VGroup,
                        Child, ColGroup(2),
                            Child, Label(txt_Label_Telnet),
                            Child, mui_telhelp_tb,
                            Child, Label(txt_Label_FTP),
                            Child, mui_ftphelp_tb,
                            Child, Label(txt_Label_Web),
                            Child, mui_webhelp_tb,
                            Child, Label(txt_Label_Other),
                            Child, mui_otherhelp_tb,
                            Child, Label(txt_Label_Timeout),
                            Child, mui_rptimeout_sli,
                            Child, Label(txt_Label_Log),
                            Child, HGroup,
                                Child, mui_logpath_tb,
                                Child, mui_freq_but,
                            End, ->HGroup
                        End, ->Col
                        Child, HGroup,
                            Child, Label(txt_Label_Service),
                            Child, mui_prefservice_chk,
                            Child, Label(txt_Label_Blocking_Chk),
                            Child, mui_blocking_chk,
                            Child, HSpace(0),
                        End, ->HG
                        Child, HGroup,
                            Child, mui_prefsave_but,
                            Child, mui_prefuse_but,
                            Child, mui_prefcancel_but,
                        End, -> HGroup
                    End, ->VGroup
    End, ->WindowObject

End ->Application

IF (app=NIL) THEN Raise(ERR_NOAPP)

->##DOMETHODS FOR THE MAIN WINDOW
doMethodA(mui_portrange_cyc,     [MUIM_Notify, MUIA_Cycle_Active,         MUIV_EveryTime, app,                  2, MUIM_Application_ReturnID, ID_RANGE])
doMethodA(mui_scantype_cyc,      [MUIM_Notify, MUIA_Cycle_Active,         MUIV_EveryTime, app,                  2, MUIM_Application_ReturnID, ID_SCANTYPE])
doMethodA(mui_service_chk,       [MUIM_Notify, MUIA_Selected,             MUIV_EveryTime, mui_service_chk,      3, MUIM_WriteLong,            MUIV_TriggerValue, {servicecheckflag}])
doMethodA(mui_trojan_chk,        [MUIM_Notify, MUIA_Selected,             MUIV_EveryTime, mui_trojan_chk,       3, MUIM_WriteLong,            MUIV_TriggerValue, {trojanflag}])
doMethodA(mui_stealth_chk,       [MUIM_Notify, MUIA_Selected,             MUIV_EveryTime, mui_stealth_chk,      3, MUIM_WriteLong,            MUIV_TriggerValue, {stealthflag}])
doMethodA(mui_closed_chk,        [MUIM_Notify, MUIA_Selected,             MUIV_EveryTime, mui_closed_chk,       3, MUIM_WriteLong,            MUIV_TriggerValue, {closedflag}])
doMethodA(mui_wakeup_chk,        [MUIM_Notify, MUIA_Selected,             MUIV_EveryTime, mui_wakeup_chk,       3, MUIM_WriteLong,            MUIV_TriggerValue, {wakeupflag}])
doMethodA(mui_wakeup_chk,        [MUIM_Notify, MUIA_Selected,             MUI_TRUE,       mui_readports_chk,    3, MUIM_Set,                  MUIA_Selected,     MUI_TRUE])
doMethodA(mui_tracedns_chk,      [MUIM_Notify, MUIA_Selected,             MUIV_EveryTime, mui_tracedns_chk,     3, MUIM_WriteLong,            MUIV_TriggerValue, {tracednsflag}])
doMethodA(mui_sweepdns_chk,      [MUIM_Notify, MUIA_Selected,             MUIV_EveryTime, mui_sweepdns_chk,     3, MUIM_WriteLong,            MUIV_TriggerValue, {pingsweepdnsflag}])
doMethodA(mui_sweepicmp_chk,     [MUIM_Notify, MUIA_Selected,             MUIV_EveryTime, mui_sweepicmp_chk,    3, MUIM_WriteLong,            MUIV_TriggerValue, {pingsweepshowicmpflag}])
doMethodA(mui_delay_sli,         [MUIM_Notify, MUIA_Numeric_Value,        MUIV_EveryTime, mui_delay_sli,        3, MUIM_WriteLong,            MUIV_TriggerValue, {delayflag}])
doMethodA(mui_delayup_but,       [MUIM_Notify, MUIA_Selected,             FALSE,          mui_delay_sli,        2, MUIM_Numeric_Increase,     1])
doMethodA(mui_delaydown_but,     [MUIM_Notify, MUIA_Selected,             FALSE,          mui_delay_sli,        2, MUIM_Numeric_Decrease,     1])
doMethodA(mui_tracemaxhops_sli,  [MUIM_Notify, MUIA_Slider_Level,         MUIV_EveryTime, mui_tracemaxhops_sli, 3, MUIM_WriteLong,            MUIV_TriggerValue, {tracemaxhopsflag}])
doMethodA(mui_abort_but,         [MUIM_Notify, MUIA_Pressed,              FALSE,          mui_abort_but,        3, MUIM_WriteLong,            TERM_USER,         {abortflag}])
doMethodA(mui_readports_chk,     [MUIM_Notify, MUIA_Selected,             MUIV_EveryTime, mui_readports_chk,    3, MUIM_WriteLong,            MUIV_TriggerValue, {readportflag}])
doMethodA(mui_readports_chk,     [MUIM_Notify, MUIA_Selected,             FALSE,          mui_wakeup_chk,       3, MUIM_Set,                  MUIA_Selected,     FALSE])
doMethodA(mui_main_win,          [MUIM_Notify, MUIA_Window_CloseRequest,  MUI_TRUE,       app,                  2, MUIM_Application_ReturnID, MUIV_Application_ReturnID_Quit])
doMethodA(mui_host_tb,           [MUIM_Notify, MUIA_String_Contents,      MUIV_EveryTime, mui_host_tb,          3, MUIM_WriteString,          MUIV_TriggerValue, site])
doMethodA(mui_portrange_tb,      [MUIM_Notify, MUIA_String_Contents,      MUIV_EveryTime, mui_portrange_tb,     3, MUIM_WriteString,          MUIV_TriggerValue, portrange])
doMethodA(mui_scan_but,          [MUIM_Notify, MUIA_Pressed,              FALSE,          app,                  2, MUIM_Application_ReturnID, ID_GO])
doMethodA(mui_logsave_but,       [MUIM_Notify, MUIA_Pressed,              FALSE,          app,                  2, MUIM_Application_ReturnID, ID_WRITELOG])
doMethodA(mui_icmpping_but,      [MUIM_Notify, MUIA_Pressed,              FALSE,          app,                  2, MUIM_Application_ReturnID, ID_PING])
doMethodA(mui_udpping_but,       [MUIM_Notify, MUIA_Pressed,              FALSE,          app,                  2, MUIM_Application_ReturnID, ID_UDPPING])
doMethodA(mui_sweep_but,         [MUIM_Notify, MUIA_Pressed,              FALSE,          app,                  2, MUIM_Application_ReturnID, ID_PINGSWEEP])
doMethodA(mui_sweeptype_cyc,     [MUIM_Notify, MUIA_Cycle_Active,         MUIV_EveryTime, mui_sweeptype_cyc,    3, MUIM_WriteLong,            MUIV_TriggerValue, {pingsweeptype}])
doMethodA(mui_trace_but,         [MUIM_Notify, MUIA_Pressed,              FALSE,          app,                  2, MUIM_Application_ReturnID, ID_TRACE])
doMethodA(mui_resolve_but,       [MUIM_Notify, MUIA_Pressed,              FALSE,          app,                  2, MUIM_Application_ReturnID, ID_RESOLVE])
doMethodA(mui_showbookwin_but,   [MUIM_Notify, MUIA_Pressed,              FALSE,          app,                  2, MUIM_Application_ReturnID, ID_OPENBOOK])
doMethodA(mui_showcustomwin_but, [MUIM_Notify, MUIA_Pressed,              FALSE,          app,                  2, MUIM_Application_ReturnID, ID_OPENCUSTOM])
doMethodA(mui_freq_but,          [MUIM_Notify, MUIA_Pressed,              FALSE,          app,                  2, MUIM_Application_ReturnID, ID_OPENFREQ])
doMethodA(mui_output_lv,         [MUIM_Notify, MUIA_Listview_DoubleClick, MUI_TRUE,       app,                  2, MUIM_Application_ReturnID, ID_DOUBLECLICK])
doMethodA(mui_ping_num,          [MUIM_Notify, MUIA_String_Contents,      MUIV_EveryTime, mui_ping_num,         3, MUIM_WriteString,          MUIV_TriggerValue, pingnumstr])
doMethodA(mui_sweepaddr_num,     [MUIM_Notify, MUIA_String_Contents,      MUIV_EveryTime, mui_sweepaddr_num,    3, MUIM_WriteString,          MUIV_TriggerValue, pingsweepnumstr])
->##DOMETHODS FOR THE BOOKMARKS WINDOW
doMethodA(mui_bookmark_win,    [MUIM_Notify, MUIA_Window_CloseRequest, MUI_TRUE,       app,              2, MUIM_Application_ReturnID, ID_CLOSEBOOK])
doMethodA(mui_bookmarkadd_but, [MUIM_Notify, MUIA_Pressed,             FALSE,          mui_bookmark_lst, 3, MUIM_List_InsertSingle,    bookstr,           MUIV_List_Insert_Sorted])
doMethodA(mui_bookmarkdel_but, [MUIM_Notify, MUIA_Pressed,             FALSE,          mui_bookmark_lst, 2, MUIM_List_Remove,          MUIV_List_Remove_Active])
doMethodA(mui_bookmarkadd_but, [MUIM_Notify, MUIA_Pressed,             FALSE,          mui_bookmark_lst, 3, MUIM_WriteLong,    1,          {bmarkchanged}])
doMethodA(mui_bookmarkdel_but, [MUIM_Notify, MUIA_Pressed,             FALSE,          mui_bookmark_lst, 3, MUIM_WriteLong,    1,          {bmarkchanged}])


doMethodA(mui_bookmark_lv,     [MUIM_Notify, MUIA_Listview_DoubleClick,MUI_TRUE,       app,              2, MUIM_Application_ReturnID, ID_BOOKDOUBLE])
doMethodA(mui_bookmark_tb,     [MUIM_Notify, MUIA_String_Contents,     MUIV_EveryTime, mui_bookmark_tb,  3, MUIM_WriteString,          MUIV_TriggerValue, bookstr])
->##DOMETHODS FOR THE LOOKUP WINDOW
doMethodA(mui_lookup_win, [MUIM_Notify, MUIA_Window_CloseRequest, MUI_TRUE,       app,              2, MUIM_Application_ReturnID, ID_CANCEL])
doMethodA(mui_lookup_tb,  [MUIM_Notify, MUIA_String_Contents,     MUIV_EveryTime, mui_lookup_tb,    3, MUIM_WriteString,          MUIV_TriggerValue, lookupstr])
doMethodA(mui_lookup_but, [MUIM_Notify, MUIA_Pressed,             FALSE,          app,              2, MUIM_Application_ReturnID, ID_LOOKUP])
doMethodA(mui_lookup_cyc, [MUIM_Notify, MUIA_Cycle_Active,        MUIV_EveryTime, app,              2, MUIM_Application_ReturnID, ID_LOOKUPCYC])
->##DOMETHODS FOR THE CUSTOM RANGE WINDOW
doMethodA(mui_customrange_win,  [MUIM_Notify, MUIA_Window_CloseRequest, MUI_TRUE,       app,              2, MUIM_Application_ReturnID, ID_CLOSECUSTOM])
doMethodA(mui_customcancel_but, [MUIM_Notify, MUIA_Pressed,             FALSE,          app,              2, MUIM_Application_ReturnID, ID_CLOSECUSTOM])
doMethodA(mui_customok_but,     [MUIM_Notify, MUIA_Pressed,             FALSE,          app,              2, MUIM_Application_ReturnID, ID_OKCUSTOM])
doMethodA(mui_custom_tb,        [MUIM_Notify, MUIA_String_Contents,     MUIV_EveryTime, mui_custom_tb,    3, MUIM_WriteString,          MUIV_TriggerValue, customname])
->##DOMETHODS FOR THE HELPER WINDOW
doMethodA(mui_helper_win,    [MUIM_Notify, MUIA_Window_CloseRequest, MUI_TRUE,       mui_helper_win,    3, MUIM_Set, MUIA_Window_Open, FALSE])
doMethodA(mui_helper_win,    [MUIM_Notify, MUIA_Window_CloseRequest, MUI_TRUE,       mui_helper_win,    3, MUIM_WriteLong, 100, {helperchoice}])
doMethodA(mui_telhelp_but,   [MUIM_Notify, MUIA_Pressed,             FALSE,          mui_helper_win,    3, MUIM_Set, MUIA_Window_Open, FALSE])
doMethodA(mui_telhelp_but,   [MUIM_Notify, MUIA_Pressed,             FALSE,          mui_telhelp_but,   3, MUIM_WriteLong, 1, {helperchoice}])
doMethodA(mui_ftphelp_but,   [MUIM_Notify, MUIA_Pressed,             FALSE,          mui_helper_win,    3, MUIM_Set, MUIA_Window_Open, FALSE])
doMethodA(mui_ftphelp_but,   [MUIM_Notify, MUIA_Pressed,             FALSE,          mui_ftphelp_but,   3, MUIM_WriteLong, 2, {helperchoice}])
doMethodA(mui_webhelp_but,   [MUIM_Notify, MUIA_Pressed,             FALSE,          mui_helper_win,    3, MUIM_Set, MUIA_Window_Open, FALSE])
doMethodA(mui_webhelp_but,   [MUIM_Notify, MUIA_Pressed,             FALSE,          mui_webhelp_but,   3, MUIM_WriteLong, 3, {helperchoice}])
doMethodA(mui_otherhelp_but, [MUIM_Notify, MUIA_Pressed,             FALSE,          mui_helper_win,    3, MUIM_Set, MUIA_Window_Open, FALSE])
doMethodA(mui_otherhelp_but, [MUIM_Notify, MUIA_Pressed,             FALSE,          mui_otherhelp_but, 3, MUIM_WriteLong, 4, {helperchoice}])
doMethodA(mui_helper_win,    [MUIM_Window_SetCycleChain, mui_telhelp_but, mui_ftphelp_but, mui_webhelp_but, mui_otherhelp_but, NIL])
->##DOMETHODS FOR THE PREFS WINDOW
doMethodA(mui_prefs_win,       [MUIM_Notify, MUIA_Window_CloseRequest, MUI_TRUE,       app,                 2, MUIM_Application_ReturnID, ID_CANCELPREF])
doMethodA(mui_telhelp_tb,      [MUIM_Notify, MUIA_String_Contents,     MUIV_EveryTime, mui_telhelp_tb,      3, MUIM_WriteString,          MUIV_TriggerValue, preftelstr])
doMethodA(mui_ftphelp_tb,      [MUIM_Notify, MUIA_String_Contents,     MUIV_EveryTime, mui_ftphelp_tb,      3, MUIM_WriteString,          MUIV_TriggerValue, prefftpstr])
doMethodA(mui_webhelp_tb,      [MUIM_Notify, MUIA_String_Contents,     MUIV_EveryTime, mui_webhelp_tb,      3, MUIM_WriteString,          MUIV_TriggerValue, prefwebstr])
doMethodA(mui_otherhelp_tb,    [MUIM_Notify, MUIA_String_Contents,     MUIV_EveryTime, mui_otherhelp_tb,    3, MUIM_WriteString,          MUIV_TriggerValue, prefotherstr])
doMethodA(mui_rptimeout_sli,   [MUIM_Notify, MUIA_Slider_Level,        MUIV_EveryTime, mui_rptimeout_sli,   3, MUIM_WriteLong,            MUIV_TriggerValue, {timeflag}])
doMethodA(mui_logpath_tb,      [MUIM_Notify, MUIA_String_Contents,     MUIV_EveryTime, mui_logpath_tb,      3, MUIM_WriteString,          MUIV_TriggerValue, logpath])
doMethodA(mui_logpath_tb,      [MUIM_Notify, MUIA_String_Contents,     MUIV_EveryTime, mui_logpath_tb,      3, MUIM_WriteLong,            0, {logwarnflag}])
doMethodA(mui_prefsave_but,    [MUIM_Notify, MUIA_Pressed,             FALSE,          app,                 2, MUIM_Application_ReturnID, ID_SAVEPREF])
doMethodA(mui_prefuse_but,     [MUIM_Notify, MUIA_Pressed,             FALSE,          app,                 2, MUIM_Application_ReturnID, ID_USEPREF])
doMethodA(mui_prefcancel_but,  [MUIM_Notify, MUIA_Pressed,             FALSE,          app,                 2, MUIM_Application_ReturnID, ID_CANCELPREF])
doMethodA(mui_prefservice_chk, [MUIM_Notify, MUIA_Selected,            MUIV_EveryTime, mui_prefservice_chk, 3, MUIM_WriteLong,            MUIV_TriggerValue, {serviceflag}])
doMethodA(mui_blocking_chk,    [MUIM_Notify, MUIA_Selected,            MUIV_EveryTime, mui_blocking_chk,    3, MUIM_WriteLong,            MUIV_TriggerValue, {blockingflag}])

->##SET FUNCTIONS WHICH NEED TO BE DONE, JUST BEFORE OPENING THE MAIN WINDOW
set(mui_lookup_win, MUIA_Window_ActiveObject, mui_lookup_cyc)
set(mui_abort_but, MUIA_Disabled, MUI_TRUE)
set(mui_busy_bar, MUIA_ShowMe, FALSE)
SetAttrsA(mui_main_win, [MUIA_Window_ActiveObject, mui_host_tb, MUIA_Window_Open, MUI_TRUE, TAG_DONE])

doMethodA(app, [MUIM_Application_Load, MUIV_Application_Load_ENV])
IF (StrCmp(site, '', ALL) = TRUE) THEN set(mui_host_tb, MUIA_String_Contents, 'localhost')
IF (StrCmp(portrange, '', ALL) = TRUE) THEN set(mui_portrange_tb, MUIA_String_Contents, '1-150')
IF (StrCmp(logpath, '', ALL) = TRUE) THEN set(mui_logpath_tb,  MUIA_String_Contents, 'RAM:goportscan.log')
IF (StrCmp(pingnumstr, '', ALL) = TRUE) THEN set(mui_ping_num, MUIA_String_Contents, '16')
IF (StrCmp(pingsweepnumstr, '', ALL) = TRUE) THEN set(mui_sweepaddr_num, MUIA_String_Contents, '255')
IF (StrCmp(preftelstr, '', ALL) = TRUE) THEN set(mui_telhelp_tb, MUIA_String_Contents, 'miami:miamitelnet %h %p')
IF (StrCmp(prefftpstr, '', ALL) = TRUE) THEN set(mui_ftphelp_tb, MUIA_String_Contents, 'aweb3:aweb-ii URL=ftp://%h:%p')
IF (StrCmp(prefwebstr, '', ALL) = TRUE) THEN set(mui_webhelp_tb, MUIA_String_Contents, 'aweb3:aweb-ii URL=http://%h:%p')
IF (StrCmp(prefotherstr, '', ALL) = TRUE) THEN set(mui_otherhelp_tb, MUIA_String_Contents, 'vva H=%h P=%p')

WHILE running
    result:= doMethodA(app, [MUIM_Application_Input,{signal}])

    SELECT result
       
        CASE MUIV_Application_ReturnID_Quit
            doMethodA(app, [MUIM_Application_ReturnID, ID_CLOSEBOOK])
            doMethodA(app, [MUIM_Application_ReturnID, ID_REALQUIT])

        CASE ID_REALQUIT
            running:=FALSE

        CASE ID_GO
            doMethodA(app, [MUIM_MultiSet, MUIA_Window_Sleep, MUI_TRUE, mui_bookmark_win, mui_lookup_win, mui_prefs_win, NIL])
            doMethodA(app, [MUIM_MultiSet, MUIA_Disabled, MUI_TRUE, mui_host_tb, mui_showbookwin_but, mui_tabs, mui_logsave_but, NIL])
            set(mui_abort_but, MUIA_Disabled, FALSE)
            set(mui_busy_bar, MUIA_ShowMe, MUI_TRUE)
            clearlist()
            inittcpip(parseport(portrange))
            doMethodA(app, [MUIM_MultiSet, MUIA_Window_Sleep, FALSE, mui_bookmark_win, mui_lookup_win, mui_prefs_win, NIL])
            doMethodA(app, [MUIM_MultiSet, MUIA_Disabled, FALSE, mui_host_tb, mui_showbookwin_but, mui_tabs, mui_logsave_but, NIL])
            set(mui_abort_but, MUIA_Disabled, MUI_TRUE)
            set(mui_busy_bar, MUIA_ShowMe, FALSE)

        CASE ID_PINGSWEEP
            doMethodA(app, [MUIM_MultiSet, MUIA_Window_Sleep, MUI_TRUE, mui_bookmark_win, mui_lookup_win, mui_prefs_win, NIL])
            doMethodA(app, [MUIM_MultiSet, MUIA_Disabled, MUI_TRUE, mui_host_tb, mui_showbookwin_but, mui_tabs, mui_logsave_but, NIL])
            set(mui_abort_but, MUIA_Disabled, FALSE)
            set(mui_busy_bar, MUIA_ShowMe, MUI_TRUE)
            clearlist()
            pingsweep(Val(pingsweepnumstr))
            doMethodA(app, [MUIM_MultiSet, MUIA_Window_Sleep, FALSE, mui_bookmark_win, mui_lookup_win, mui_prefs_win, NIL])
            doMethodA(app, [MUIM_MultiSet, MUIA_Disabled, FALSE, mui_host_tb, mui_showbookwin_but, mui_tabs, mui_logsave_but, NIL])
            set(mui_abort_but, MUIA_Disabled, MUI_TRUE)
            set(mui_busy_bar, MUIA_ShowMe, FALSE)

        CASE ID_PING
            doMethodA(app, [MUIM_MultiSet, MUIA_Window_Sleep, MUI_TRUE, mui_bookmark_win, mui_lookup_win, mui_prefs_win, NIL])
            doMethodA(app, [MUIM_MultiSet, MUIA_Disabled, MUI_TRUE, mui_host_tb, mui_showbookwin_but, mui_tabs, mui_logsave_but, NIL])
            set(mui_abort_but, MUIA_Disabled, FALSE)
            set(mui_busy_bar, MUIA_ShowMe, MUI_TRUE)
            clearlist()
            icmpping(Val(pingnumstr))
            doMethodA(app, [MUIM_MultiSet, MUIA_Window_Sleep, FALSE, mui_bookmark_win, mui_lookup_win, mui_prefs_win, NIL])
            doMethodA(app, [MUIM_MultiSet, MUIA_Disabled, FALSE, mui_host_tb, mui_showbookwin_but, mui_tabs, mui_logsave_but, NIL])
            set(mui_abort_but, MUIA_Disabled, MUI_TRUE)
            set(mui_busy_bar, MUIA_ShowMe, FALSE)

        CASE ID_UDPPING
            doMethodA(app, [MUIM_MultiSet, MUIA_Window_Sleep, MUI_TRUE, mui_bookmark_win, mui_lookup_win, mui_prefs_win, NIL])
            doMethodA(app, [MUIM_MultiSet, MUIA_Disabled, MUI_TRUE, mui_host_tb, mui_showbookwin_but, mui_tabs, mui_logsave_but, NIL])
            set(mui_abort_but, MUIA_Disabled, FALSE)
            set(mui_busy_bar, MUIA_ShowMe, MUI_TRUE)
            clearlist()
            udpping(Val(pingnumstr))
            doMethodA(app, [MUIM_MultiSet, MUIA_Window_Sleep, FALSE, mui_bookmark_win, mui_lookup_win, mui_prefs_win, NIL])
            doMethodA(app, [MUIM_MultiSet, MUIA_Disabled, FALSE, mui_host_tb, mui_showbookwin_but, mui_tabs, mui_logsave_but, NIL])
            set(mui_abort_but, MUIA_Disabled, MUI_TRUE)
            set(mui_busy_bar, MUIA_ShowMe, FALSE)

        CASE ID_TRACE
            doMethodA(app, [MUIM_MultiSet, MUIA_Window_Sleep, MUI_TRUE, mui_bookmark_win, mui_lookup_win, mui_prefs_win, NIL])
            doMethodA(app, [MUIM_MultiSet, MUIA_Disabled, MUI_TRUE, mui_host_tb, mui_showbookwin_but, mui_tabs, mui_logsave_but, NIL])
            set(mui_abort_but, MUIA_Disabled, FALSE)
            set(mui_busy_bar, MUIA_ShowMe, MUI_TRUE)
            clearlist()
            GetAttr(MUIA_Cycle_Active,mui_tracetype_cyc,{troutetype})
            IF troutetype=0
                traceroute()
            ELSE
                udptraceroute()
            ENDIF
            doMethodA(app, [MUIM_MultiSet, MUIA_Window_Sleep, FALSE, mui_bookmark_win, mui_lookup_win, mui_prefs_win, NIL])
            doMethodA(app, [MUIM_MultiSet, MUIA_Disabled, FALSE, mui_host_tb, mui_showbookwin_but, mui_tabs, mui_logsave_but, NIL])
            set(mui_abort_but, MUIA_Disabled, MUI_TRUE)
            set(mui_busy_bar, MUIA_ShowMe, FALSE)

        CASE ID_RESOLVE
            doMethodA(app, [MUIM_MultiSet, MUIA_Window_Sleep, MUI_TRUE, mui_bookmark_win, mui_lookup_win, mui_prefs_win, NIL])
            doMethodA(app, [MUIM_MultiSet, MUIA_Disabled, MUI_TRUE, mui_host_tb, mui_showbookwin_but, mui_tabs, mui_delay_sli, mui_logsave_but, NIL])
            set(mui_abort_but, MUIA_Disabled, FALSE)
            set(mui_busy_bar, MUIA_ShowMe, MUI_TRUE)
            clearlist()
            resolve()
            doMethodA(app, [MUIM_MultiSet, MUIA_Window_Sleep, FALSE, mui_bookmark_win, mui_lookup_win, mui_prefs_win, NIL])
            doMethodA(app, [MUIM_MultiSet, MUIA_Disabled, FALSE, mui_host_tb, mui_showbookwin_but, mui_tabs, mui_delay_sli, mui_logsave_but, NIL])
            set(mui_abort_but, MUIA_Disabled, MUI_TRUE)
            set(mui_busy_bar, MUIA_ShowMe, FALSE)

        CASE ID_RANGE
            get(mui_portrange_cyc, MUIA_Cycle_Active, {portrange_cycval})
            SELECT portrange_cycval
                CASE 0
                    StrCopy(portrange,'1-150')
                CASE 1
                    StrCopy(portrange,'7,9,11,13,15,17,19-21,23,25,37,79-80,110,137-139')
                CASE 2
                    StrCopy(portrange,'1-1023')
                CASE 3
                    StrCopy(portrange,'1024-49151')
                CASE 4
                    StrCopy(portrange,'1-65535')
                DEFAULT
                    StrCopy(portrange, cyctxt_values[portrange_cycval])
            ENDSELECT
            set(mui_portrange_tb, MUIA_String_Contents, portrange)

        CASE ID_SCANTYPE
            get(mui_scantype_cyc, MUIA_Cycle_Active, {scantype})

        CASE ID_ICONIFY
            set(app, MUIA_Application_Iconified, MUI_TRUE)

        CASE ID_UNICONIFY
            set(app, MUIA_Application_Iconified, FALSE)

        CASE ID_ABOUT
            Mui_RequestA(app, mui_main_win, 0, 'About Go Portscan!','*_OK','\ecGo Portscan! by Ian Chapman (2003)\nVersion 1.1\n\nTCP/UDP Portscanner with service lookup,\nPing, Ping Sweep, Resolve and Traceroute\n\nhttp://software.scm.tees.ac.uk\nhttp://software.electric-dreams.org',NIL)

        CASE ID_MUIABOUT
            doMethodA(app, [MUIM_Application_AboutMUI, mui_main_win])

        CASE ID_MUISET
            doMethodA(app, [MUIM_Application_OpenConfigWindow,0])

        CASE ID_OPENLOOKUP
            set(mui_lookup_win, MUIA_Window_Open, MUI_TRUE)
            set(mui_lookup_win, MUIA_Window_ActiveObject, mui_lookup_tb)
            SetAttrsA(mui_lookup_tb, [MUIA_String_BufferPos, 0, MUIA_BetterString_SelectSize, 200, TAG_DONE])

        CASE ID_PREFS
            ->Makes copies of the prefs in case the user cancels
            StrCopy(preftelstrtmp, preftelstr)
            StrCopy(prefftpstrtmp, prefftpstr)
            StrCopy(prefwebstrtmp, prefwebstr)
            StrCopy(prefotherstrtmp, prefotherstr)
            StrCopy(logpathtmp, logpath)
            prefvalstmp[0]:=timeflag
            prefvalstmp[1]:=serviceflag
            prefvalstmp[2]:=blockingflag
            set(mui_prefs_win, MUIA_Window_Open, MUI_TRUE)

        CASE ID_DOUBLECLICK
            set(mui_helper_win, MUIA_Window_Open, MUI_TRUE)
            set(mui_main_win, MUIA_Window_Sleep, MUI_TRUE)
            WHILE helperchoice = 0
                WaitTOF()
                doMethodA(app, [MUIM_Application_Input,{signal}])
            ENDWHILE
            SELECT helperchoice
                CASE 1
                    callhelper(preftelstr)
                CASE 2
                    callhelper(prefftpstr)
                CASE 3
                    callhelper(prefwebstr)
                CASE 4
                    callhelper(prefotherstr)
                DEFAULT
                    ->This is where it comes if we just want the window to close
            ENDSELECT
            set(mui_main_win, MUIA_Window_Sleep, FALSE)
            helperchoice:=0

        CASE ID_OPENFREQ
            openreq(mui_main_win)
            set(mui_logpath_tb, MUIA_String_Contents, logpath)

        ->##THESE CASE STATEMENTS ARE RELATED TO THE BOOKMARKS WINDOW

        CASE ID_OPENBOOK 
            doMethodA(mui_bookmark_lst, [MUIM_List_Clear])
            StrCopy(bookstr, site)
            set(mui_bookmark_tb, MUIA_String_Contents, bookstr)
            set(mui_bookmark_win, MUIA_Window_ActiveObject, mui_bookmarkadd_but)

            IF (bookfh:=Open('ENVARC:goportscan.bookmarks', MODE_OLDFILE))>NIL
                WHILE Fgets(bookfh, bookinstr, 81)>NIL
                    SetStr(bookinstr, StrLen(bookinstr)-1)
                    doMethodA(mui_bookmark_lst, [MUIM_List_InsertSingle, bookinstr, MUIV_List_Insert_Sorted])
                ENDWHILE
                Close(bookfh)
            ENDIF

            set(mui_bookmark_win, MUIA_Window_Open, MUI_TRUE)

        CASE ID_CLOSEBOOK
            IF bmarkchanged=1
            GetAttr(MUIA_List_Entries,mui_bookmark_lst,{entries})
            IF (bookfh:=Open('ENVARC:goportscan.bookmarks', MODE_NEWFILE))>NIL
               FOR i:=0 TO (entries-1)
                    doMethodA(mui_bookmark_lst,[MUIM_List_GetEntry,i,{bentries}])
                    Write(bookfh,bentries,StrLen(bentries))
                    Write(bookfh, '\n', 1)
                ENDFOR
                Close(bookfh)
            ENDIF
            bmarkchanged:=0
            ENDIF

            set(mui_bookmark_win, MUIA_Window_Open, FALSE)

        CASE ID_BOOKDOUBLE
            doMethodA(mui_bookmark_lst, [MUIM_List_GetEntry,MUIV_List_GetEntry_Active,{bookoutstr}])
            StrCopy(site, bookoutstr)
            doMethodA(mui_host_tb, [MUIM_Set, MUIA_String_Contents, site])
            set(mui_bookmark_win, MUIA_Window_Open, FALSE)

        CASE ID_CANCEL
            set(mui_lookup_win, MUIA_Window_Open, FALSE)

        CASE ID_LOOKUP
            clearlist()
            doMethodA(app, [MUIM_MultiSet, MUIA_Disabled, MUI_TRUE, mui_lookup_but, mui_lookup_cyc, mui_lookup_tb, NIL])
            set(mui_busy_bar, MUIA_ShowMe, MUI_TRUE)
            set(mui_workingon_tb, MUIA_Text_Contents, txt_Face_Workingon4)
            set(app, MUIA_Application_Sleep,MUI_TRUE)
            searchservices(mui_lookup_cyc, lookup_cycval, signal, lookupstr)
            doMethodA(app, [MUIM_MultiSet, MUIA_Disabled, FALSE, mui_lookup_but, mui_lookup_cyc, mui_lookup_tb, NIL])
            set(app, MUIA_Application_Sleep, FALSE)
            set(mui_busy_bar, MUIA_ShowMe, FALSE)
            set(mui_workingon_tb, MUIA_Text_Contents, 'Done!')

        CASE ID_LOOKUPCYC
            get(mui_lookup_cyc, MUIA_Cycle_Active, {lookup_cycval})
            SELECT lookup_cycval
                CASE 0
                    SetAttrsA(mui_lookup_tb, [MUIA_ShortHelp, txt_Bubble_Lookupstring1, MUIA_String_Accept, ',-0123456789', TAG_DONE])
                    set(mui_lookup_cyc, MUIA_ShortHelp, txt_Bubble_Lookupcyc1)
                CASE 1
                    SetAttrsA(mui_lookup_tb, [MUIA_ShortHelp, txt_Bubble_Lookupstring2, MUIA_String_Accept, FALSE, TAG_DONE])
                    set(mui_lookup_cyc, MUIA_ShortHelp, txt_Bubble_Lookupcyc3)
                CASE 2
                    SetAttrsA(mui_lookup_tb, [MUIA_ShortHelp, txt_Bubble_Lookupstring2, MUIA_String_Accept, FALSE, TAG_DONE])
                    set(mui_lookup_cyc, MUIA_ShortHelp, txt_Bubble_Lookupcyc2)
            ENDSELECT
            StrCopy(lookupstr, '')
            set(mui_lookup_tb, MUIA_String_Contents, lookupstr)

        CASE ID_OPENCUSTOM
            set(mui_main_win, MUIA_Window_Sleep, MUI_TRUE)
            set(mui_customrange_win, MUIA_Window_Open, MUI_TRUE)

        CASE ID_CLOSECUSTOM
            set(mui_customrange_win, MUIA_Window_Open, FALSE)
            set(mui_main_win, MUIA_Window_Sleep, FALSE)

        CASE ID_OKCUSTOM
            IF (customfh:=Open('ENVARC:goportscan.ranges', MODE_READWRITE))<>0
                IF StrLen(customname)>0
                    IF StrLen(portrange)>0
                        Seek(customfh, 0, OFFSET_END)
                        Write(customfh, customname,StrLen(customname))
                        Write(customfh, '\n', 1)
                        Write(customfh, portrange, StrLen(portrange))
                        Write(customfh, '\n', 1)
                    ENDIF
                ENDIF
                Close(customfh)
            ENDIF
            set(mui_customrange_win, MUIA_Window_Open, FALSE)
            set(mui_main_win, MUIA_Window_Sleep, FALSE)

        CASE ID_WRITELOG
            set(mui_main_win, MUIA_Window_Sleep, MUI_TRUE)
            addlog('===Manual Log Write===')
            IF savelog()=1
                addlog('===End Manual Log Write===')
                
                Mui_RequestA(app, mui_main_win, 0, '','*_OK',txt_Text_WrittenToLog,NIL)
            ELSE
                Mui_RequestA(app, mui_main_win, 0, '','*_OK', 'Cannot open logfile', NIL)
            ENDIF
            set(mui_main_win, MUIA_Window_Sleep, FALSE)
        CASE ID_SAVEPREF
            doMethodA(app, [MUIM_Application_Save, MUIV_Application_Save_ENVARC])
            doMethodA(app, [MUIM_Application_Save, MUIV_Application_Save_ENV])
            set(mui_prefs_win, MUIA_Window_Open, FALSE)

        CASE ID_USEPREF
            set(mui_prefs_win, MUIA_Window_Open, FALSE)
            doMethodA(app, [MUIM_Application_Save, MUIV_Application_Save_ENV])

        CASE ID_CANCELPREF
            ->Restores original settings when the user cancels.
            set(mui_telhelp_tb, MUIA_String_Contents, preftelstrtmp)
            set(mui_ftphelp_tb, MUIA_String_Contents, prefftpstrtmp)
            set(mui_webhelp_tb, MUIA_String_Contents, prefwebstrtmp)
            set(mui_otherhelp_tb, MUIA_String_Contents, prefotherstrtmp)
            set(mui_logpath_tb, MUIA_String_Contents, logpathtmp)
            set(mui_rptimeout_sli, MUIA_Slider_Level, prefvalstmp[0])
            set(mui_prefservice_chk, MUIA_Selected, prefvalstmp[1])
            set(mui_blocking_chk, MUIA_Selected, prefvalstmp[2])
            set(mui_prefs_win, MUIA_Window_Open, FALSE)

    ENDSELECT
    IF (running AND signal) THEN Wait(signal)
ENDWHILE


EXCEPT DO
    IF (miamibase) THEN CloseLibrary(miamibase)
    IF (socketbase) THEN CloseLibrary(socketbase)
    IF (app) THEN Mui_DisposeObject(app)
    IF (muimasterbase) THEN CloseLibrary(muimasterbase)
    IF (diskobj) THEN FreeDiskObject(diskobj)
    IF (iconbase) THEN CloseLibrary(iconbase)
    IF (reqtoolsbase) THEN CloseLibrary(reqtoolsbase)
    IF (localebase) THEN CloseLibrary(localebase)
SELECT exception
    CASE ERR_NOERROR
    -> Normal exception on exit
    CASE ERR_NOMUI
        WriteF(txt_Error_NoMUI)
    CASE ERR_NOAPP
        WriteF(txt_Error_NoApp)
    CASE ERR_NOASL
        WriteF(txt_Error_NoAsl)
    CASE ERR_NOICON
        WriteF(txt_Error_NoIcon)
    CASE ERR_NOBSD
        WriteF(txt_Error_NoTCP)
    CASE ERR_NOLOCALE
        WriteF(txt_Error_NoLocale)
    DEFAULT
        WriteF(txt_Error_Exception, 'main()', exception)
ENDSELECT

ENDPROC

    ->##Procedure to print a string to the listview and jump to the end##
PROC outlist(str:PTR TO CHAR)
    doMethodA(mui_output_lst, [MUIM_List_InsertSingle,str,MUIV_List_Insert_Bottom ])
    doMethodA(mui_output_lst, [MUIM_List_Jump, MUIV_List_Jump_Bottom])
ENDPROC

    ->##Procedure to clear the listview of entires##
PROC clearlist() IS doMethodA(mui_output_lst, [MUIM_List_Clear])


    ->##Procedure to call the appropriate helper and parse the variables
PROC callhelper(helper)
DEF line[200]:STRING,
    a[200]:STRING,
    b[200]:STRING,
    exestr[200]:STRING,
    chopped[10]:STRING,
    helperpath[150]:STRING,
    port,
    retval,
    index

    StrCopy(helperpath, helper)
    doMethodA(mui_output_lst,[MUIM_List_GetEntry,MUIV_List_GetEntry_Active,{line}])
    StrCopy(chopped, line, StrLen(line))
    chopped[0]:=32
    chopped[1]:=32
    retval:=StrToLong(chopped, {port})

    IF port>0
        index:=InStr(helperpath, '%h')
        IF (index > -1) THEN StringF(exestr, '\s\s\s', MidStr(a, helperpath, 0, index), site, MidStr(b, helperpath, index+2, ALL))
        index:=InStr(exestr, '%p')
        IF (index > -1) THEN StringF(exestr, 'run \s\d\s', MidStr(a, exestr, 0, index), port, MidStr(b, exestr, index+2, ALL))
        Execute(exestr, NIL, NIL)
    ELSE
        outlist('Helpers can only be run from a portscan.')
    ENDIF

ENDPROC

    ->##Procedure to parse the port ranges for scanning
    -> , = ASII 44  - = ASCII 45
PROC parseport(parsestring)
DEF ports[1000]:STRING,
    temp[12]:STRING,
    temp2[12]:STRING,
    q[1]:STRING,
    len=0 ,x=0, pos=0,
    next:PTR TO portentry
    

    StrCopy(ports, parsestring)
    start:=NewM(SIZEOF portentry, MEMF_PUBLIC OR MEMF_CLEAR)
    next:=start
    len:=StrLen(ports)

    FOR x:=0 TO (len-1) 
        IF ports[x] = 44
            IF (pos:=InStr(temp,'-')) > -1
                next.lower:=Val(MidStr(temp2, temp, 0, pos))
                next.upper:=Val(MidStr(temp2, temp, pos+1, ALL))
                next.next:=NewM(SIZEOF portentry, MEMF_PUBLIC OR MEMF_CLEAR)
                next:=next.next
                StrCopy(temp,'')
            ELSE
                next.upper:=Val(temp)
                next.lower:=Val(temp)
                next.next:=NewM(SIZEOF portentry, MEMF_PUBLIC OR MEMF_CLEAR)
                next:=next.next
                StrCopy(temp,'')
            ENDIF
        ELSE
            StringF(q,'\c',ports[x])
            StrAdd(temp,q)
        ENDIF
    ENDFOR

    IF (pos:=InStr(temp,'-')) > -1
        next.lower:=Val(MidStr(temp2, temp, 0, pos))
        next.upper:=Val(MidStr(temp2, temp, pos+1, ALL))
        next.next:=NIL
        StrCopy(temp,'')
    ELSE
        next.upper:=Val(temp)
        next.lower:=Val(temp)
        next.next:=NIL
        next:=next.next
        StrCopy(temp,'')
    ENDIF

    next:=start

    WHILE (next <> NIL)
        IF next.upper < 1 THEN start:=NIL
        IF next.upper > 65535 THEN start:=NIL
        IF next.lower < 1 THEN start:=NIL
        IF next.upper > 65535 THEN start:=NIL
        next:=next.next
    ENDWHILE

ENDPROC start

    ->##Procedure to select the appropriate scan type
PROC inittcpip(start:PTR TO portentry)

    IF start=NIL
        outlist(txt_Error_Badport)
        SetAttrsA(mui_portrange_tb, [MUIA_String_BufferPos, 0, MUIA_BetterString_SelectSize, 200, TAG_DONE])
    ELSE
        SELECT scantype
            CASE 0
                IF (blockingflag=FALSE) THEN block_tcpscan(start) ELSE nonblock_tcpscan(start)
            CASE 1
                udpscan(start)
            CASE 2
                IF (blockingflag=FALSE) THEN block_tcpscan(start) ELSE nonblock_tcpscan(start)
                udpscan(start)
            CASE 3
                udpscan(start)
                IF (blockingflag=FALSE) THEN block_tcpscan(start) ELSE nonblock_tcpscan(start)
            DEFAULT
                IF (blockingflag=FALSE) THEN block_tcpscan(start) ELSE nonblock_tcpscan(start)
        ENDSELECT
    ENDIF


ENDPROC

    ->##Procedure to perform a TCP scan
PROC block_tcpscan(portptr:PTR TO portentry) HANDLE
DEF port=0,
    sock,
    sain:PTR TO sockaddr_in,
    buildstr[1000]:STRING,
    err,
    signal,
    no_delay=1

    StringF(buildstr, '===New TCP Scan (Host: \s)===', site)
    addlog(buildstr)
    set(mui_workingon_tb, MUIA_Text_Contents, txt_Face_Workingon8)
    sain:=NewM(SIZEOF sockaddr_in, MEMF_PUBLIC OR MEMF_CLEAR)
    sain.family:=AF_INET
    sain.addr.addr:=giveipbyhost(site)
    IF (sain.addr.addr = NIL) THEN Raise(ERR_NODNSRESULT)

    WHILE (portptr <> NIL)
        doMethodA(app, [MUIM_Application_Input,{signal}])
        IF abortflag=TERM_USER THEN Raise(ERR_USERABORT)

        FOR port:=portptr.lower TO portptr.upper
            IF no_delay=1 THEN no_delay:=0 ELSE handle_delay() -> Stops unnecessary delay on first port.
            doMethodA(app, [MUIM_Application_Input,{signal}])
            IF abortflag=TERM_USER THEN Raise(ERR_USERABORT)
            StringF(workonstr, '\d (TCP)', port)
            set(mui_workingon_tb, MUIA_Text_Contents, workonstr)
            sock:=Socket(AF_INET, SOCK_STREAM,0)
            sain.port:=port

            IF Connect(sock, sain, SIZEOF sockaddr_in)<>-1
                scanlookup(port, 'TCP')
                scanreadport(sock, port)
            ELSE
                IF (err:=Errno())=ECONNREFUSED
                    scanclosed(port, 'TCP')
                ELSEIF (err=ETIMEDOUT)
                    scanstealth(port, 'TCP')
                ELSEIF (err=ENETUNREACH)
                    outlist(txt_Error_Netunreach)
                ELSEIF (err=EHOSTUNREACH)
                    outlist(txt_Error_Hostunreach)
                ELSE
                    outlist(txt_Error_Timedout)
                ENDIF
            ENDIF

            IF (sock) THEN CloseSocket(sock)
            
        ENDFOR
        portptr:=portptr.next
    ENDWHILE

    EXCEPT DO     
        set(mui_workingon_tb, MUIA_Text_Contents, txt_Face_Workingon1)
        IF (sock) THEN CloseSocket(sock)
        addlog('===Open Port List===')
        savelog()

        SELECT exception
            CASE ERR_NOERROR
                ->Normal Exception
            CASE ERR_NODNSRESULT
                outlist(txt_Error_NoDNSRes)
                set(mui_workingon_tb, MUIA_Text_Contents, txt_Face_Workingon3)
            CASE ERR_NOSOCK
                outlist(txt_Error_NoSocket)
            CASE ERR_NOMEM
                outlist(txt_Error_NoMem)
            CASE ERR_USERABORT
                abortflag:=TERM_NONE
                set(mui_workingon_tb, MUIA_Text_Contents, txt_Face_Workingon2)
            DEFAULT
                WriteF(txt_Error_Exception, 'block_tcpscan()', exception)
        ENDSELECT
ENDPROC


    ->##Procedure to perform a TCP scan
PROC nonblock_tcpscan(portptr:PTR TO portentry) HANDLE
DEF port=0,
    sock,
    sain:PTR TO sockaddr_in,
    buildstr[1000]:STRING,
    writefds:fd_set,
    readfds:fd_set,
    tv:timeval,
    signal,
    sockopt=1,
    no_delay=1

    StringF(buildstr, '===New TCP Scan (Host: \s)===', site)
    addlog(buildstr)
    set(mui_workingon_tb, MUIA_Text_Contents, txt_Face_Workingon8)
    sain:=NewM(SIZEOF sockaddr_in, MEMF_PUBLIC OR MEMF_CLEAR)
    sain.family:=AF_INET
    sain.addr.addr:=giveipbyhost(site)
    IF (sain.addr.addr = NIL) THEN Raise(ERR_NODNSRESULT)

    WHILE (portptr <> NIL)
        doMethodA(app, [MUIM_Application_Input,{signal}])
        IF abortflag=TERM_USER THEN Raise(ERR_USERABORT)
        FOR port:=portptr.lower TO portptr.upper
            IF no_delay=1 THEN no_delay:=0 ELSE handle_delay() -> Stops unnecessary delay on first port.
            doMethodA(app, [MUIM_Application_Input,{signal}])
            IF abortflag=TERM_USER THEN Raise(ERR_USERABORT)
            StringF(workonstr, '\d (TCP)', port)
            set(mui_workingon_tb, MUIA_Text_Contents, workonstr)
            sock:=Socket(AF_INET, SOCK_STREAM,0)
            
            sain.port:=port

            IoctlSocket(sock, FIONBIO, {sockopt})

            Connect(sock, sain, SIZEOF sockaddr_in)
            
            fd_zero(writefds)
            fd_zero(readfds)
            fd_set(sock,writefds)
            fd_set(sock,readfds)
            tv.sec:=2
            tv.usec:=5
            IF WaitSelect(sock+1, readfds, writefds, NIL, tv, NIL)>0
                IF fd_isset(sock, writefds)
                    IF fd_isset(sock, readfds)
                        scanclosed(port, 'TCP')
                    ELSE
                        scanlookup(port, 'TCP')
                        scanreadport(sock, port)
                    ENDIF
                ENDIF
            ELSE
                scanstealth(port, 'TCP')
            ENDIF
            
            IF (sock) THEN CloseSocket(sock)
            
        ENDFOR
        portptr:=portptr.next
    ENDWHILE

    EXCEPT DO
        set(mui_workingon_tb, MUIA_Text_Contents, txt_Face_Workingon1)
        IF (sock) THEN CloseSocket(sock)
        addlog('===Open Port List===')
        savelog()

        SELECT exception
            CASE ERR_NOERROR
                ->Normal Exception
            CASE ERR_NODNSRESULT
                outlist(txt_Error_NoDNSRes)
                set(mui_workingon_tb, MUIA_Text_Contents, txt_Face_Workingon3)
            CASE ERR_NOSOCK
                outlist(txt_Error_NoSocket)
            CASE ERR_NOMEM
                outlist(txt_Error_NoMem)
            CASE ERR_USERABORT
                abortflag:=TERM_NONE
                set(mui_workingon_tb, MUIA_Text_Contents, txt_Face_Workingon2)
            DEFAULT
                WriteF(txt_Error_Exception, 'nonblock_tcpscan()', exception)
        ENDSELECT

ENDPROC

    ->##Procedure to peform a UDP scan
PROC udpscan(portptr:PTR TO portentry) HANDLE
DEF port=0,
    sendsock,
    recvsock,
    sain:PTR TO sockaddr_in,
    readfds:fd_set,
    tv:timeval,
    packetbuffer[1024]:STRING,
    buildstr[1000]:STRING,
    displaystr[1024]:STRING,
    logstr[2048]:STRING,
    signal,
    recvlen,
    no_delay=1

    StringF(buildstr, '===New UDP Scan (Host: \s)===', site)
    addlog(buildstr)
    set(mui_workingon_tb, MUIA_Text_Contents, txt_Face_Workingon1)
    sain:=NewM(SIZEOF sockaddr, MEMF_PUBLIC OR MEMF_CLEAR)
    sain.family:=AF_INET
    sain.addr.addr:=giveipbyhost(site)
    IF (sain.addr.addr = NIL) THEN Raise(ERR_NODNSRESULT)

    WHILE (portptr <> NIL)
        doMethodA(app, [MUIM_Application_Input,{signal}])
        IF abortflag=TERM_USER THEN Raise(ERR_USERABORT)
        FOR port:=portptr.lower TO portptr.upper
            IF no_delay=1 THEN no_delay:=0 ELSE handle_delay() -> Stops unnecessary delay on first port.
            doMethodA(app, [MUIM_Application_Input,{signal}])
            IF abortflag=TERM_USER THEN Raise(ERR_USERABORT)
            StringF(workonstr, '\d (UDP)', port)
            set(mui_workingon_tb, MUIA_Text_Contents, workonstr)
            sendsock:=Socket(AF_INET, SOCK_DGRAM, 0)
            recvsock:=Socket(AF_INET, SOCK_RAW, IPPROTO_ICMP)
            sain.port:=port
            Sendto(sendsock, '\n\n',2, NIL, sain, SIZEOF sockaddr_in)
            fd_zero(readfds)
            fd_set(recvsock, readfds)
            tv.sec:=2
            tv.usec:=500
            IF WaitSelect(recvsock+1, readfds, NIL, NIL, tv, NIL)>0
                ->These section waits for an ICMP message, if it arrives then the port is closed.
                Recvfrom(recvsock, packetbuffer, 1024, NIL, NIL, NIL)
                scanclosed(port, 'UDP')
            ELSE
                fd_zero(readfds)
                fd_set(sendsock, readfds)
                tv.sec:=2
                tv.usec:=5
                IF WaitSelect(sendsock+1, readfds, NIL, NIL, tv, NIL)>0
                    ->This section waits for a UDP message, only if an ICMP message
                    ->has not arrived. If a UDP message does arrive then the port is open
                    ->recvlen:=Recvfrom(sendsock, packetbuffer, 1024, NIL, sain, SIZEOF sockaddr_in)
                    recvlen:=Recvfrom(sendsock, packetbuffer, 1024, NIL, NIL, NIL)
                    scanlookup(port, 'UDP')
                    IF readportflag=MUI_TRUE
                        StrAdd(workonstr, txt_Face_Workingon5)
                        set(mui_workingon_tb, MUIA_Text_Contents, workonstr)
                        StrCopy(displaystr, packetbuffer, recvlen)
                        StringF(logstr, '##BEGIN \d##\n\s##END \d##\n', port, displaystr, port)
                        addlog(logstr)
                    ENDIF
                ELSE
                    udp_maybe_open(port)
                ENDIF
            ENDIF
            IF (sendsock) THEN CloseSocket(sendsock)
            IF (recvsock) THEN CloseSocket(recvsock)
            Delay(60)
        ENDFOR
        portptr:=portptr.next
    ENDWHILE

    EXCEPT DO
        set(mui_workingon_tb, MUIA_Text_Contents, txt_Face_Workingon1)
        IF (sendsock) THEN CloseSocket(sendsock)
        IF (recvsock) THEN CloseSocket(recvsock)
        addlog('===Open Port List===')
        savelog()

        SELECT exception
            CASE ERR_NOERROR
                ->Normal Exception
            CASE ERR_NODNSRESULT
                outlist(txt_Error_NoDNSRes)
                set(mui_workingon_tb, MUIA_Text_Contents, txt_Face_Workingon3)
            CASE ERR_NOSOCK
                outlist(txt_Error_NoSocket)
            CASE ERR_NOMEM
                outlist(txt_Error_NoMem)
            CASE ERR_USERABORT
                abortflag:=TERM_NONE
                set(mui_workingon_tb, MUIA_Text_Contents, txt_Face_Workingon2)
            DEFAULT
                WriteF(txt_Error_Exception, 'udpscan()', exception)
        ENDSELECT
ENDPROC


    ->##Procedure to save entries in the listview to the logfile.
PROC savelog()
DEF entries,
    i,
    ent[500]:STRING,
    entry[500]:STRING,
    success=0

    GetAttr(MUIA_List_Entries,mui_output_lst,{entries})

    FOR i:=0 TO (entries-1)
        doMethodA(mui_output_lst, [MUIM_List_GetEntry, i, {ent}])
        StringF(entry,'\s',ent)
        success:=addlog(entry)
    ENDFOR
ENDPROC success

    ->##Procedure to open the log file requester
PROC openreq(window)
DEF req:PTR TO rtfilerequester,
    fname[108]:STRING,
    q,
    ret,
    wptr

    StrCopy(fname, 'goportscan.log')
    set(app, MUIA_Application_Sleep,MUI_TRUE)
    req:=RtAllocRequestA(RT_FILEREQ,NIL)
    GetAttr(MUIA_Window_Window, window, {wptr})
    RtChangeReqAttrA(req, [RTFI_DIR, 'ram:', TAG_END])
    ret:=RtFileRequestA(req, fname, 'Choose Logfile', [RT_WINDOW, wptr, RTFI_FLAGS, FREQF_SAVE OR FREQF_PATGAD, TAG_END])

    IF ret<>FALSE
        StrCopy(logpath, req.dir)
        q:=EstrLen(logpath)
        IF (logpath[q-1]<>47)
            IF (logpath[q-1]<>58) THEN StrAdd(logpath,'/', ALL)
        ENDIF
        StrAdd(logpath,fname, ALL)
    ENDIF

    IF req THEN RtFreeRequest(req)
    set(app, MUIA_Application_Sleep, FALSE)
ENDPROC

    ->##Procedure to resolve a hostname or IP address
PROC resolve() HANDLE
DEF hstblock:PTR TO hostent,
    buildstr[200]:STRING,
    ipaddr:PTR TO in_addr,
    address:in_addr,
    x=0

    set(mui_workingon_tb, MUIA_Text_Contents, txt_Face_Workingon8)
    IF (site[0] > 47) AND (site[0] < 58)
        address.addr:=Inet_addr(site)
        IF address.addr = INADDR_NONE THEN Raise(ERR_NODNSRESULT)
        IF (hstblock:=Gethostbyaddr(address, SIZEOF in_addr, AF_INET)) = NIL THEN Raise(ERR_NODNSRESULT)
    ELSE
        IF (hstblock:=Gethostbyname(site)) = NIL THEN Raise(ERR_NODNSRESULT)
    ENDIF

    StringF(buildstr, '\ebOfficial Name:\en \s', hstblock.name)
    outlist(buildstr)
    x:=0
    WHILE (ipaddr:=hstblock.addr_list[x]) <> NIL
        StringF(buildstr, '\ebIP Address:\en \s', Inet_NtoA(ipaddr.addr))
        outlist(buildstr)
        x++
    ENDWHILE
    x:=0
    IF hstblock.aliases[x] <> 0
        StringF(buildstr, '\ebAlias:\en \s', hstblock.aliases[x])
        outlist(buildstr)
        x++
        WHILE hstblock.aliases[x] <> 0
            StringF(buildstr, '\ebAlias:\en \s', hstblock.aliases[x])
            outlist(buildstr)
            x++
        ENDWHILE
    ENDIF

    EXCEPT DO
        set(mui_workingon_tb, MUIA_Text_Contents, txt_Face_Workingon1)

        SELECT exception
            CASE ERR_NOERROR
                ->Normal exception on exit
            CASE ERR_NODNSRESULT
                outlist(txt_Error_NoDNSRes)
            DEFAULT
                WriteF(txt_Error_Exception, 'resolve()', exception)
        ENDSELECT

ENDPROC

    ->##Procedure to add a line of text to the log file
PROC addlog(txt)
DEF logfh,
    text[2048]:STRING,
    len,
    success=0

    StrCopy(text, txt)
    StrAdd(text, '\n')
    len:=StrLen(text)

    IF logfh:=Open(logpath, MODE_READWRITE)
        Seek(logfh, 0, OFFSET_END)
        Write(logfh,text,len)
        Close(logfh)
        success:=1
    ELSE
        IF logwarnflag=0
            outlist(txt_Error_NoLog)
            logwarnflag:=1
        ENDIF
        success:=0
    ENDIF

ENDPROC success

    ->##Procedure to perform an ICMP ping
PROC icmpping(pingcount) HANDLE
DEF icmphdr:PTR TO icmp,
    ricmp:PTR TO icmp,
    sain:PTR TO sockaddr_in,
    riphdr:PTR TO ip,
    readfds:fd_set,
    tv:compatible_timeval,
    buildstr[200]:STRING,
    lost=0,
    cnt=0,
    type,
    rcvbuffer,
    sock,
    recvlen,
    loop,
    hops=NIL,
    signal,
    no_delay=1

    NEW tr
    
    IF OpenDevice('timer.device', UNIT_VBLANK, tr, 0)<>NIL THEN Raise(ERR_NOTIMER)
    timerbase:=tr.node.device

    set(mui_workingon_tb, MUIA_Text_Contents, txt_Face_Workingon8)
    sock:=Socket(AF_INET, SOCK_RAW, IPPROTO_ICMP)
    sain:=NewM(SIZEOF sockaddr, MEMF_PUBLIC OR MEMF_CLEAR)
    sain.family:=AF_INET
    sain.addr.addr:=giveipbyhost(site)
    IF (sain.addr.addr=NIL) THEN Raise(ERR_NODNSRESULT)

    StringF(buildstr, 'ICMP Ping : \s : Sending \d bytes', site, (SIZEOF ip) + (SIZEOF icmp))
    outlist(buildstr)

    FOR loop:=1 TO pingcount
        NEW timereq1, timereq2
        doMethodA(app, [MUIM_Application_Input,{signal}])
        IF abortflag=TERM_USER THEN Raise(ERR_USERABORT)
        icmphdr:=NewM(SIZEOF icmp, MEMF_PUBLIC OR MEMF_CLEAR)
        riphdr:=NewM(SIZEOF ip, MEMF_PUBLIC OR MEMF_CLEAR)
        icmphdr.type:=ICMP_ECHO
        icmphdr.code:=0
        icmphdr.idseq.id:=ICMPIDNUM
        icmphdr.idseq.seq:=loop
        icmphdr.cksum:=cksum(icmphdr, SIZEOF icmp)
        set(mui_workingon_tb, MUIA_Text_Contents, txt_Face_Workingon6)
        GetSysTime(timereq1)
        Sendto(sock, icmphdr, SIZEOF icmp, NIL, sain, SIZEOF sockaddr_in)
        cnt++
        fd_zero(readfds)
        fd_set(sock, readfds)
        tv.sec:=3
        tv.usec:=500

        IF WaitSelect(sock+1, readfds, NIL, NIL, tv, NIL)>0
            IF no_delay=1 THEN no_delay:=0 ELSE handle_delay() -> Stops unnecessary delay on first port.
            GetSysTime(timereq2)
            SubTime(timereq2, timereq1)
            set(mui_workingon_tb, MUIA_Text_Contents, txt_Face_Workingon7)
            rcvbuffer:=NewM((SIZEOF ip) + (SIZEOF icmp), MEMF_PUBLIC OR MEMF_CLEAR)
            recvlen:=Recvfrom(sock, rcvbuffer, (SIZEOF ip) + (SIZEOF icmp), NIL, NIL, NIL)
            riphdr:=rcvbuffer
            ricmp:=rcvbuffer + (SIZEOF ip)

            IF (riphdr.ttl < 32)
                hops:=32-(riphdr.ttl)
            ELSEIF (riphdr.ttl < 64)
                hops:=64-(riphdr.ttl)
            ELSEIF (riphdr.ttl < 128)
                hops:=128-(riphdr.ttl)
            ELSE
                hops:=255-(riphdr.ttl)
            ENDIF

            type:=ricmp.type
            ->IF ricmp.idseq.id = ICMPIDNUM
                SELECT type
                    CASE ICMP_ECHOREPLY
                        StringF(buildstr,'\d Bytes From \s : PN=\d : TTL=\d : ENH=\d : TPL=\d (\d%) : Time=\dms',recvlen, Inet_NtoA(riphdr.src.addr), ricmp.idseq.seq, riphdr.ttl, hops, lost, (lost*100)/ricmp.idseq.seq, timereq2.micro/1000)
                    CASE ICMP_UNREACH
                        StringF(buildstr,'[Destination Unreachable] From \s : TTL=\d : ENH=\d : TPL=\d', Inet_NtoA(riphdr.src.addr), riphdr.ttl, hops, lost)
                    CASE ICMP_TIMXCEED
                        StringF(buildstr,'[Time To Live Exceeded] From \s : TTL=\d : ENH=\d : TPL=\d', Inet_NtoA(riphdr.src.addr), riphdr.ttl, hops, lost)
                    DEFAULT
                        StringF(buildstr,'[ICMP type \d] From \s : TTL=\d : ENH=\d : TPL=\d', type, Inet_NtoA(riphdr.src.addr), riphdr.ttl, hops, lost)
                ENDSELECT

                outlist(buildstr)
            ->ENDIF
            doMethodA(app, [MUIM_Application_Input,{signal}])
        ELSE
            lost++
            StringF(buildstr,'Received No Reply [Packet Lost] : PN=\d : TPL=\d (\d%)', cnt, lost, (lost*100)/cnt)
            outlist(buildstr)
        ENDIF

        IF (icmphdr) THEN Dispose(icmphdr)
        IF (riphdr) THEN Dispose(riphdr)
        IF (rcvbuffer) THEN Dispose(rcvbuffer)
        END timereq1, timereq2

    ENDFOR

    EXCEPT DO
        CloseDevice(tr)
        set(mui_workingon_tb, MUIA_Text_Contents, txt_Face_Workingon1)
        END timereq1, timereq2
        IF (icmphdr) THEN Dispose(icmphdr)
        IF (riphdr) THEN Dispose(riphdr)
        IF (rcvbuffer) THEN Dispose(rcvbuffer)
        IF (sock) THEN CloseSocket(sock)
        SELECT exception
            CASE ERR_NOERROR
                ->Normal Exception
            CASE ERR_NODNSRESULT
                outlist(txt_Error_NoDNSRes)
                set(mui_workingon_tb, MUIA_Text_Contents, txt_Face_Workingon3)
            CASE ERR_NOSOCK
                outlist(txt_Error_NoSocket)
            CASE ERR_NOMEM
                outlist(txt_Error_NoMem)
            CASE ERR_USERABORT
                abortflag:=TERM_NONE
                set(mui_workingon_tb, MUIA_Text_Contents, txt_Face_Workingon2)
            CASE ERR_NOTIMER
                outlist('Unable to open timer.device')
            DEFAULT
                WriteF(txt_Error_Exception, 'icmpping()', exception)
        ENDSELECT
ENDPROC

    ->##Procedure for doing a UDP ping
PROC udpping(pingcount) HANDLE
DEF udpheader:PTR TO udphdr,
    ricmp:PTR TO icmp,
    sain:PTR TO sockaddr_in,
    stamp:datestamp,
    riphdr:PTR TO ip,
    readfds:fd_set,
    tv:compatible_timeval,
    buildstr[200]:STRING,
    lost=0,
    cnt=0,
    type,
    subtype,
    rcvbuffer,
    sock,
    rsock,
    recvlen=0,
    loop,
    hops=NIL,
    signal,
    no_delay=1

    NEW tr

    IF OpenDevice('timer.device', UNIT_VBLANK, tr, 0)<>NIL THEN Raise(ERR_NOTIMER)
    timerbase:=tr.node.device

    set(mui_workingon_tb, MUIA_Text_Contents, txt_Face_Workingon8)
    sock:=Socket(AF_INET, SOCK_RAW, IPPROTO_UDP)
    rsock:=Socket(AF_INET, SOCK_RAW, IPPROTO_ICMP)
    sain:=NewM(SIZEOF sockaddr, MEMF_PUBLIC OR MEMF_CLEAR)
    sain.family:=AF_INET
    sain.addr.addr:=giveipbyhost(site)
    IF (sain.addr.addr=NIL) THEN Raise(ERR_NODNSRESULT)

    StringF(buildstr, 'UDP Ping : \s : Sending \d bytes', site, (SIZEOF ip) + (SIZEOF udphdr))
    outlist(buildstr)

    FOR loop:=1 TO pingcount

        NEW timereq1, timereq2
        doMethodA(app, [MUIM_Application_Input,{signal}])
        IF abortflag=TERM_USER THEN Raise(ERR_USERABORT)
        udpheader:=NewM(SIZEOF udphdr, MEMF_PUBLIC OR MEMF_CLEAR)
        riphdr:=NewM(SIZEOF ip, MEMF_PUBLIC OR MEMF_CLEAR)
        DateStamp(stamp)
        Rnd(stamp.tick * -1 )
        udpheader.sport:=(Rnd(9999) + 40000)
        DateStamp(stamp)
        Rnd(stamp.tick * -1 )
        udpheader.dport:=(Rnd(9998) + 40000)
        udpheader.ulen:=(SIZEOF udphdr)
        udpheader.sum:=0

        set(mui_workingon_tb, MUIA_Text_Contents, txt_Face_Workingon6)
        GetSysTime(timereq1)
        Sendto(sock, udpheader, SIZEOF udphdr, NIL, sain, SIZEOF sockaddr_in)
        cnt++
        fd_zero(readfds)
        fd_set(rsock,readfds)
        tv.sec:=3
        tv.usec:=500

        IF WaitSelect(rsock+1, readfds, NIL, NIL, tv,NIL)>0
            IF no_delay=1 THEN no_delay:=0 ELSE handle_delay() -> Stops unnecessary delay on first port.
            GetSysTime(timereq2)
            SubTime(timereq2, timereq1)
            set(mui_workingon_tb, MUIA_Text_Contents, txt_Face_Workingon7)
            rcvbuffer:=NewM((SIZEOF ip) + (SIZEOF icmp) +28, MEMF_PUBLIC OR MEMF_CLEAR)
            recvlen:=Recvfrom(rsock, rcvbuffer, (SIZEOF ip) + (SIZEOF icmp) + 28, NIL, NIL, NIL)
            riphdr:=rcvbuffer
            ricmp:=rcvbuffer + (SIZEOF ip)

            IF (riphdr.ttl < 32)
                hops:=32-(riphdr.ttl)
            ELSEIF (riphdr.ttl < 64)
                hops:=64-(riphdr.ttl)
            ELSEIF (riphdr.ttl < 128)
                hops:=128-(riphdr.ttl)
            ELSE
                hops:=255-(riphdr.ttl)
            ENDIF

            type:=ricmp.type
            subtype:=ricmp.code

            SELECT type
                CASE ICMP_TIMXCEED
                    StringF(buildstr, '\s [Time To Live Exceeded]', Inet_NtoA(riphdr.src.addr))
                CASE ICMP_UNREACH
                    SELECT subtype
                        CASE ICMP_UNREACH_NET
                            StringF(buildstr, '\s [Network Unreachable]', Inet_NtoA(riphdr.src.addr))
                        CASE ICMP_UNREACH_HOST
                            StringF(buildstr, '\s [Host Unreachable]', Inet_NtoA(riphdr.src.addr))
                        CASE ICMP_UNREACH_PROTOCOL
                            StringF(buildstr, '\s [Protocol Not Supported]', Inet_NtoA(riphdr.src.addr))
                        CASE ICMP_UNREACH_NEEDFRAG
                            StringF(buildstr, '\s [IP Needs Fragmenting]', Inet_NtoA(riphdr.src.addr))
                        CASE ICMP_UNREACH_SRCFAIL
                            StringF(buildstr, '\s [Source Route Failure]', Inet_NtoA(riphdr.src.addr))
                        CASE ICMP_UNREACH_PORT
                            StringF(buildstr, '\d Bytes From \s : PN=\d : TTL=\d : ENH=\d : TPL=\d (\d%) : Time=\dms', recvlen, Inet_NtoA(riphdr.src.addr), cnt, riphdr.ttl, hops, lost, (lost*100)/cnt, timereq2.micro/1000)
                        DEFAULT
                            StringF(buildstr, '\s [Reply Code=\d]', Inet_NtoA(riphdr.src.addr), subtype)
                    ENDSELECT
                DEFAULT
                    StringF(buildstr, '\s [Sent Reply Type \d]', Inet_NtoA(riphdr.src.addr), type)
            ENDSELECT

            outlist(buildstr)
            doMethodA(app, [MUIM_Application_Input,{signal}])
        ELSE
            lost++
            StringF(buildstr,'Received No Reply [Packet Lost] : PN=\d : TPL=\d (\d%)', cnt, lost, (lost*100)/cnt)
            outlist(buildstr)
        ENDIF
        IF (udpheader) THEN Dispose(udpheader)
        IF (riphdr) THEN Dispose(riphdr)
        IF (rcvbuffer) THEN Dispose(rcvbuffer)
        END timereq1, timereq2
    ENDFOR

    EXCEPT DO
        CloseDevice(tr)
        set(mui_workingon_tb, MUIA_Text_Contents, txt_Face_Workingon1)
        END timereq1, timereq2
        IF (udpheader) THEN Dispose(udpheader)
        IF (riphdr) THEN Dispose(riphdr)
        IF (rcvbuffer) THEN Dispose(rcvbuffer)
        IF (sain) THEN Dispose(sain)
        IF (sock) THEN CloseSocket(sock)
        IF (rsock) THEN CloseSocket(rsock)
        SELECT exception
            CASE ERR_NOERROR
                ->Normal Exception
            CASE ERR_NODNSRESULT
                outlist(txt_Error_NoDNSRes)
                set(mui_workingon_tb, MUIA_Text_Contents, txt_Face_Workingon3)
            CASE ERR_NOSOCK
                outlist(txt_Error_NoSocket)
            CASE ERR_NOMEM
                outlist(txt_Error_NoMem)
            CASE ERR_USERABORT
                abortflag:=TERM_NONE
                set(mui_workingon_tb, MUIA_Text_Contents, txt_Face_Workingon2)
            CASE ERR_NOTIMER
                outlist('Unable to open timer.device')
            DEFAULT
                WriteF(txt_Error_Exception, 'udpping()', exception)
         ENDSELECT
ENDPROC

    ->##Procedure for calculation the IP and TCP checksums
PROC cksum(hdr:PTR TO intfold, hdrsize:LONG)
DEF accumulator=0:LONG,
    loop

    FOR loop:=0 TO ((hdrsize-1)/2) DO accumulator:=accumulator+hdr.arr[loop]
    accumulator:=(Shr(accumulator, 16)) + (Eor(accumulator, $FFFF))
    accumulator:=accumulator + (Shr(accumulator, 16))

ENDPROC accumulator

    ->##Procedure for looking up a service by port number using the TCP/IP stacks own service table
PROC servbyport(prt:PTR TO LONG)
DEF serv:PTR TO servent,
    buildstr[200]:STRING,
    x=0

    IF (serv:=Getservbyport(prt, NIL)) <> NIL
        StringF(buildstr, '\s : ', serv.name)
        x:=0
        WHILE serv.aliases[x] <> NIL
            StrAdd(buildstr, serv.aliases[x])
            StrAdd(buildstr, ' ; ')
            x++
        ENDWHILE
        StrCopy(servicedesc, buildstr)
    ELSE
        StrCopy(servicedesc, 'UNKNOWN')
    ENDIF
ENDPROC

    ->##Procedure for looking up a service by port using the internal service table
PROC findservice(portnum:LONG)

    IF serviceflag=MUI_TRUE
        IF portnum < 201
            service(portnum)
        ELSEIF portnum < 401
            service2(portnum)
        ELSEIF portnum < 601
            service3(portnum)
        ELSEIF portnum < 801
            service4(portnum)
        ELSEIF portnum < 1124
            service5(portnum)
        ELSEIF portnum < 1401
            service6(portnum)
        ELSEIF portnum < 1601
            service7(portnum)
        ELSEIF portnum < 2101
            service8(portnum)
        ELSEIF portnum < 2601
            service9(portnum)
        ELSEIF portnum < 3101
            service10(portnum)
        ELSEIF portnum < 7001
            service11(portnum)
        ELSE
            service12(portnum)
        ENDIF
    ELSE
        servbyport(portnum)
    ENDIF

ENDPROC


    ->##Procedure for performing an ICMP traceroute
PROC traceroute() HANDLE
DEF iphdr:PTR TO ip,
    riphdr:PTR TO ip,
    icmphdr:PTR TO icmp,
    ricmphdr:PTR TO icmp,
    sain:PTR TO sockaddr_in,
    readfds:fd_set,
    srchost[81]:STRING,
    srcip[15]:STRING,
    tv:compatible_timeval,
    buildstr[1024]:STRING,
    sock,
    rsock,
    rcvbuffer,
    type,
    subtype,
    on:PTR TO CHAR,
    signal,
    ttl,
    ipaddr:in_addr,
    no_delay=1
    
    sock:=Socket(AF_INET, SOCK_RAW, IPPROTO_RAW)
    rsock:=Socket(AF_INET, SOCK_RAW, IPPROTO_ICMP)
    Setsockopt(sock, IPPROTO_IP, IP_HDRINCL, {on}, 4)
    sain:=NewM(SIZEOF sockaddr, MEMF_PUBLIC OR MEMF_CLEAR)
    sain.family:=AF_INET
    sain.addr.addr:=giveipbyhost(site)
    IF (sain.addr.addr = NIL) THEN Raise(ERR_NODNSRESULT)
    tv.sec:=3
    tv.usec:=500

    FOR ttl:=1 TO tracemaxhopsflag
        IF no_delay=1 THEN no_delay:=0 ELSE handle_delay() -> Stops unnecessary delay on first port.
        doMethodA(app, [MUIM_Application_Input,{signal}])
        IF abortflag=TERM_USER THEN Raise(ERR_USERABORT)
        set(mui_workingon_tb, MUIA_Text_Contents, txt_Face_Workingon9)
        iphdr:=NewM((SIZEOF ip + (SIZEOF icmp)), MEMF_PUBLIC OR MEMF_CLEAR)
        icmphdr:=iphdr + (SIZEOF ip)
        iphdr.id:=500
        ipaddr.addr:=giveipbyhost(site)
        iphdr.p:=IPPROTO_ICMP
        ->We dont need to specify src address as this is filled in by the stack
        ->and made appropriate to outgoing interface
        iphdr.dst.addr:=ipaddr.addr
        icmphdr.type:=ICMP_ECHO
        icmphdr.code:=0
        icmphdr.idseq.seq:=ttl+1
        set_ip_hl(iphdr, 5)
        set_ip_v(iphdr, IPVERSION)
        iphdr.ttl:=ttl
        iphdr.sum:=cksum(iphdr, SIZEOF ip)
        icmphdr.idseq.id:=ICMPIDNUM
        icmphdr.cksum:=cksum(icmphdr, SIZEOF icmp)

        Sendto(sock, iphdr, (SIZEOF ip) + (SIZEOF icmp), NIL, sain, SIZEOF sockaddr)
        fd_zero(readfds)
        fd_set(rsock, readfds)

        IF WaitSelect(rsock+1, readfds, NIL, NIL, tv, NIL)>0
            rcvbuffer:=NewM((SIZEOF ip) + (SIZEOF icmp), MEMF_PUBLIC OR MEMF_CLEAR)
            Recvfrom(rsock, rcvbuffer, (SIZEOF ip) + (SIZEOF icmp), NIL, NIL, NIL)
            riphdr:=rcvbuffer
            ricmphdr:=rcvbuffer + (SIZEOF ip)
            type:=ricmphdr.type
            subtype:=ricmphdr.code

            IF tracednsflag=MUI_TRUE
                StrCopy(srchost, givehostbyip(Inet_NtoA(riphdr.src.addr)))
            ELSE
                StrCopy(srchost, '(-)')
            ENDIF

            StrCopy(srcip, Inet_NtoA(riphdr.src.addr))

            SELECT type
                CASE ICMP_TIMXCEED
                    StringF(buildstr, '\d: \s (\s)', ttl, srchost, srcip)
                CASE ICMP_ECHOREPLY
                    StringF(buildstr, '\d: \s (\s) [Final Destination]', ttl, srchost, srcip)
                    outlist(buildstr)
                    Raise(ERR_NOERROR)
                CASE ICMP_UNREACH
                    SELECT subtype
                        CASE ICMP_UNREACH_NET
                            StringF(buildstr, '\d: \s (\s) [Network Unreachable]', ttl, srchost, srcip)
                        CASE ICMP_UNREACH_HOST
                            StringF(buildstr, '\d: \s (\s) [Host Unreachable]', ttl, srchost, srcip)
                        CASE ICMP_UNREACH_PROTOCOL
                            StringF(buildstr, '\d: \s (\s) [Protocol Not Supported]', ttl, srchost, srcip)
                        CASE ICMP_UNREACH_NEEDFRAG
                            StringF(buildstr, '\d: \s (\s) [IP Needs Fragmenting]', ttl, srchost, srcip)
                        CASE ICMP_UNREACH_SRCFAIL
                            StringF(buildstr, '\d: \s (\s) [Source Route Failure]', ttl, srchost, srcip)
                        DEFAULT
                            StringF(buildstr, '\d: \s (\s) [Destination Unreachable]', ttl, srchost, srcip)
                    ENDSELECT

                    outlist(buildstr)
                    Raise(ERR_NOERROR)
                DEFAULT
                    StringF(buildstr, '\d: \s (\s) [Sent Reply Type \d]', ttl, srchost, type, srcip)
            ENDSELECT

            outlist(buildstr)

        ELSE
            StringF(buildstr, '\d: - (-) [Host failed to respond]', ttl)
            outlist(buildstr)
        ENDIF
    ENDFOR

    EXCEPT DO
        set(mui_workingon_tb, MUIA_Text_Contents, txt_Face_Workingon1)
        IF (sock) THEN CloseSocket(sock)
        IF (rsock) THEN CloseSocket(rsock)

        SELECT exception
            CASE ERR_NOERROR
                ->Normal Exit
            CASE ERR_NODNSRESULT
                outlist(txt_Error_NoDNSRes)
                set(mui_workingon_tb, MUIA_Text_Contents, txt_Face_Workingon3)
            CASE ERR_NOSOCK
                outlist(txt_Error_NoSocket)
            CASE ERR_NOMEM
                outlist(txt_Error_NoMem)
            CASE ERR_USERABORT
                abortflag:=TERM_NONE
                set(mui_workingon_tb, MUIA_Text_Contents, txt_Face_Workingon2)
        ENDSELECT

ENDPROC


    ->##Procedure for performing a UDP traceroute
PROC udptraceroute() HANDLE
DEF iphdr:PTR TO ip,
    riphdr:PTR TO ip,
    udpheader:PTR TO udphdr,
    ricmphdr:PTR TO icmp,
    sain:PTR TO sockaddr_in,
    readfds:fd_set,
    stamp:datestamp,
    srchost[81]:STRING,
    srcip[15]:STRING,
    tv:compatible_timeval,
    buildstr[1024]:STRING,
    sock,
    rsock,
    rcvbuffer,
    type,
    subtype,
    on:PTR TO CHAR,
    signal,
    ttl,
    ipaddr:in_addr,
    no_delay=1

    sock:=Socket(AF_INET, SOCK_RAW, IPPROTO_RAW)
    rsock:=Socket(AF_INET, SOCK_RAW, IPPROTO_ICMP)
    Setsockopt(sock, IPPROTO_IP, IP_HDRINCL, {on}, 4)
    sain:=NewM(SIZEOF sockaddr, MEMF_PUBLIC OR MEMF_CLEAR)
    sain.family:=AF_INET
    sain.addr.addr:=giveipbyhost(site)
    IF (sain.addr.addr =NIL) THEN Raise(ERR_NODNSRESULT)
    tv.sec:=3
    tv.usec:=500

    FOR ttl:=1 TO tracemaxhopsflag
        IF no_delay=1 THEN no_delay:=0 ELSE handle_delay() -> Stops unnecessary delay on first port.
        doMethodA(app, [MUIM_Application_Input,{signal}])
        IF abortflag=TERM_USER THEN Raise(ERR_USERABORT)
        set(mui_workingon_tb, MUIA_Text_Contents, txt_Face_Workingon9)
        iphdr:=NewM((SIZEOF ip + (SIZEOF udphdr) + 10), MEMF_PUBLIC OR MEMF_CLEAR)
        udpheader:=iphdr + (SIZEOF ip)
        iphdr.id:=500
        ipaddr.addr:=giveipbyhost(site)
        iphdr.p:=IPPROTO_UDP
        ->We don't need to specify src address as this is filled in by the stack
        ->and made appropriate to outgoing interface
        iphdr.dst.addr:=ipaddr.addr
        DateStamp(stamp)
        Rnd(stamp.tick * -1 )
        udpheader.sport:=40001 + Rnd(3000)
        DateStamp(stamp)
        Rnd(stamp.tick * -1 )
        udpheader.dport:=30001 + Rnd(3000)
        udpheader.ulen:=SIZEOF udphdr + 10
        udpheader.sum:=0
        set_ip_hl(iphdr, 5)
        set_ip_v(iphdr, IPVERSION)
        iphdr.ttl:=ttl
        iphdr.sum:=cksum(iphdr, SIZEOF ip)
        Sendto(sock, iphdr, (SIZEOF ip) + (SIZEOF udphdr) +10, NIL, sain, SIZEOF sockaddr)
        fd_zero(readfds)
        fd_set(rsock, readfds)

        IF WaitSelect(rsock+1, readfds, NIL, NIL, tv,NIL)>0
            rcvbuffer:=NewM((SIZEOF ip) + (SIZEOF icmp) +10, MEMF_PUBLIC OR MEMF_CLEAR)
            Recvfrom(rsock, rcvbuffer, (SIZEOF ip) + (SIZEOF icmp) +10, NIL,NIL,NIL)
            riphdr:=rcvbuffer
            ricmphdr:=rcvbuffer + (SIZEOF ip)
            type:=ricmphdr.type
            subtype:=ricmphdr.code

            IF tracednsflag=MUI_TRUE
                StrCopy(srchost, givehostbyip(Inet_NtoA(riphdr.src.addr)))
            ELSE
                StrCopy(srchost, '(-)')
            ENDIF

            StrCopy(srcip, Inet_NtoA(riphdr.src.addr))

            SELECT type
                CASE ICMP_TIMXCEED
                    StringF(buildstr, '\d: \s (\s)', ttl, srchost, srcip)
                CASE ICMP_UNREACH
                    SELECT subtype
                        CASE ICMP_UNREACH_NET
                            StringF(buildstr, '\d: \s (\s) [Network Unreachable]', ttl, srchost, srcip)
                        CASE ICMP_UNREACH_HOST
                            StringF(buildstr, '\d: \s (\s) [Host Unreachable]', ttl, srchost, srcip)
                        CASE ICMP_UNREACH_PROTOCOL
                            StringF(buildstr, '\d: \s (\s) [Protocol Not Supported]', ttl, srchost, srcip)
                        CASE ICMP_UNREACH_NEEDFRAG
                            StringF(buildstr, '\d: \s (\s) [IP Needs Fragmenting]', ttl, srchost, srcip)
                        CASE ICMP_UNREACH_SRCFAIL
                            StringF(buildstr, '\d: \s (\s) [Source Route Failure]', ttl, srchost, srcip)
                        CASE ICMP_UNREACH_PORT
                            StringF(buildstr, '\d: \s (\s) [Final Destination]', ttl, srchost, srcip)
                        DEFAULT
                            StringF(buildstr, '\d: \s (\s) [Destination Unreachable]', ttl, srchost, srcip)
                    ENDSELECT

                    outlist(buildstr)
                    Raise(ERR_NOERROR)

                DEFAULT
                    StringF(buildstr, '\d: \s (\s) [Sent Reply Type \d]', ttl, srchost, type, srcip)
            ENDSELECT

            outlist(buildstr)
        ELSE
            StringF(buildstr, '\d: - (-) [Host failed to respond]', ttl)
            outlist(buildstr)
        ENDIF
    ENDFOR

    EXCEPT DO
        set(mui_workingon_tb, MUIA_Text_Contents, txt_Face_Workingon1)
        IF (sock) THEN CloseSocket(sock)
        IF (rsock) THEN CloseSocket(rsock)

        SELECT exception
            CASE ERR_NOERROR
                ->Normal Exit
            CASE ERR_NODNSRESULT
                outlist(txt_Error_NoDNSRes)
                set(mui_workingon_tb, MUIA_Text_Contents, txt_Face_Workingon3)
            CASE ERR_NOSOCK
                outlist(txt_Error_NoSocket)
            CASE ERR_NOMEM
                outlist(txt_Error_NoMem)
            CASE ERR_USERABORT
                abortflag:=TERM_NONE
                set(mui_workingon_tb, MUIA_Text_Contents, txt_Face_Workingon2)
        ENDSELECT
ENDPROC

    ->##Procedure for returning the hostname if given IP
PROC givehostbyip(txtip)
DEF hstblock:PTR TO hostent,
    machinename[81]:STRING,
    machineip[15]:STRING,
    address:in_addr

    set(mui_workingon_tb, MUIA_Text_Contents, txt_Face_Workingon8)
    StrCopy(machineip, txtip)
    address.addr:=Inet_addr(machineip)
    IF (hstblock:=Gethostbyaddr(address, SIZEOF in_addr, AF_INET)) = NIL
        StrCopy(machinename, machineip)
    ELSE
        StrCopy(machinename, hstblock.name)
    ENDIF

ENDPROC machinename

    ->##Procedure for returning the IP if given the hostname
PROC giveipbyhost(host)
DEF hstblock:PTR TO hostent,
    machinename[81]:STRING,
    address:in_addr

    StrCopy(machinename, host)

    IF (hstblock:=Gethostbyname(machinename))=NIL
        address.addr:=NIL
    ELSE
        address:=hstblock.addr_list[0]
    ENDIF

ENDPROC address.addr

    ->##Procedure for performing a ping sweep.
PROC pingsweep(maxsweep) HANDLE
DEF icmphdr:PTR TO icmp,
    ricmp:PTR TO icmp,
    sain:PTR TO sockaddr_in,
    iphdr:PTR TO ip,
    readfds:fd_set,
    tv:compatible_timeval,
    hostname[81]:STRING,
    buildstr[200]:STRING,
    type,
    rcvbuffer,
    sock,
    loop,
    signal,
    ipadd,
    srchost[81]:STRING,
    srcip[15]:STRING,
    no_delay=1

    set(mui_workingon_tb, MUIA_Text_Contents, txt_Face_Workingon8)
    sock:=Socket(AF_INET, SOCK_RAW, IPPROTO_ICMP)
    StrCopy(hostname, site)
    IF (ipadd:=giveipbyhost(hostname)) = NIL THEN Raise(ERR_NODNSRESULT)

    FOR loop:=0 TO maxsweep
        IF no_delay=1 THEN no_delay:=0 ELSE handle_delay() -> Stops unnecessary delay on first port.
        sain:=NewM(SIZEOF sockaddr, MEMF_PUBLIC OR MEMF_CLEAR)
        sain.family:=AF_INET

        IF pingsweeptype=0
            sain.addr.addr:=ipadd+loop
        ELSE 
            sain.addr.addr:=ipadd-loop
        ENDIF

        doMethodA(app, [MUIM_Application_Input,{signal}])
        IF abortflag=TERM_USER THEN Raise(ERR_USERABORT)
        icmphdr:=NewM(SIZEOF icmp, MEMF_PUBLIC OR MEMF_CLEAR)
        iphdr:=NewM(SIZEOF ip, MEMF_PUBLIC OR MEMF_CLEAR)
        icmphdr.type:=ICMP_ECHO
        icmphdr.code:=0
        icmphdr.idseq.id:=ICMPIDNUM
        icmphdr.idseq.seq:=loop
        icmphdr.cksum:=cksum(icmphdr, SIZEOF icmp)

        StringF(buildstr, '\s \d (\s)', txt_Face_Workingon6, loop, Inet_NtoA(sain.addr.addr))
        set(mui_workingon_tb, MUIA_Text_Contents, buildstr)
        Sendto(sock, icmphdr, SIZEOF icmp, NIL, sain, SIZEOF sockaddr_in)
        fd_zero(readfds)
        fd_set(sock, readfds)
        tv.sec:=0
        tv.usec:=500

        WHILE WaitSelect(sock+1, readfds, NIL, NIL, tv, NIL)>0
            set(mui_workingon_tb, MUIA_Text_Contents, txt_Face_Workingon7)
            rcvbuffer:=NewM((SIZEOF ip) + (SIZEOF icmp), MEMF_PUBLIC OR MEMF_CLEAR)
            Recvfrom(sock, rcvbuffer, (SIZEOF ip) + (SIZEOF icmp), NIL, NIL, NIL)
            iphdr:=rcvbuffer
            ricmp:=rcvbuffer + (SIZEOF ip)
            type:=ricmp.type

            IF (type = ICMP_ECHOREPLY)
                IF (pingsweepdnsflag = MUI_TRUE)
                    StrCopy(srchost, givehostbyip(Inet_NtoA(iphdr.src.addr)))
                ELSE
                    StrCopy(srchost, '(-)')
                ENDIF
                StrCopy(srcip, Inet_NtoA(iphdr.src.addr))
                StringF(buildstr, '\s (\s) is alive', srchost, srcip)
                outlist(buildstr)
            ELSE
                IF (pingsweepshowicmpflag = MUI_TRUE)
                    IF (pingsweepdnsflag = MUI_TRUE)
                        StrCopy(srchost, givehostbyip(Inet_NtoA(iphdr.src.addr)))
                    ELSE
                        StrCopy(srchost, '(-)')
                    ENDIF
                    StrCopy(srcip, Inet_NtoA(iphdr.src.addr))
                    SELECT type
                        CASE ICMP_UNREACH
                            StringF(buildstr,'\s (\s) [Destination Unreachable]', srchost, srcip)
                        CASE ICMP_TIMXCEED
                            StringF(buildstr,'\s (\s) [TTL Expired]', srchost, srcip)
                        DEFAULT
                            StringF(buildstr,'\s (\s) [Reply Type \d]', srchost, srcip, type)
                    ENDSELECT
                    outlist(buildstr)
                 ENDIF
            ENDIF
            
            doMethodA(app, [MUIM_Application_Input,{signal}])

        ENDWHILE
    ENDFOR

    EXCEPT DO
        set(mui_workingon_tb, MUIA_Text_Contents, txt_Face_Workingon1)
        IF (sock) THEN CloseSocket(sock)

        SELECT exception
            CASE ERR_NOERROR
                ->Normal Exception
            CASE ERR_NODNSRESULT
                outlist(txt_Error_NoDNSRes)
                set(mui_workingon_tb, MUIA_Text_Contents, txt_Face_Workingon3)
            CASE ERR_NOSOCK
                outlist(txt_Error_NoSocket)
            CASE ERR_NOMEM
                outlist(txt_Error_NoMem)
            CASE ERR_USERABORT
                abortflag:=TERM_NONE
                set(mui_workingon_tb, MUIA_Text_Contents, txt_Face_Workingon2)
            DEFAULT
                WriteF(txt_Error_Exception, 'pingsweep()', exception)
        ENDSELECT

ENDPROC

PROC searchservices(mui_lookup_cyc, lookup_cycval, signal, lookupstr)
DEF buildstr[51]:STRING,
    lookupport,
    index,
    portptr:PTR TO portentry,
    matches=0

    get(mui_lookup_cyc, MUIA_Cycle_Active, {lookup_cycval})
    SELECT lookup_cycval
        CASE 0
            portptr:=parseport(lookupstr)
            IF portptr=NIL
                outlist(txt_Error_Badport)
                SetAttrsA(mui_lookup_tb, [MUIA_String_BufferPos, 0, MUIA_BetterString_SelectSize, 200, TAG_DONE])
            ELSE
                WHILE (portptr<>NIL)
                    FOR lookupport:=portptr.lower TO portptr.upper
                        doMethodA(app, [MUIM_Application_Input,{signal}])
                        findservice(lookupport)
                        doMethodA(app, [MUIM_Application_Input,{signal}])
                        IF (StrCmp(servicedesc, 'UNKNOWN') = FALSE)
                            matches++
                            StringF(buildstr, '\eb\d\en - \s',lookupport, servicedesc)
                            outlist(buildstr)
                        ENDIF
                    ENDFOR
                portptr:=portptr.next
                ENDWHILE
                IF matches=1
                    StringF(buildstr,'\eb\d Match.\en', matches)
                ELSE
                    StringF(buildstr,'\eb\d Matches.\en', matches)
                ENDIF
                outlist(buildstr)
            ENDIF
        DEFAULT
        IF lookup_cycval=2 THEN LowerStr(lookupstr)
        FOR lookupport:=1 TO 65535
            doMethodA(app, [MUIM_Application_Input,{signal}])
            findservice(lookupport)
            IF lookup_cycval=2 THEN LowerStr(servicedesc)
            index:=InStr(servicedesc, lookupstr)
            IF index >-1
                matches++
                StringF(buildstr, '\eb\d\en - \s',lookupport, servicedesc)
                outlist(buildstr)
            ENDIF
        ENDFOR
        StringF(buildstr, '\eb\d Matches.\en', matches)
        outlist(buildstr)
    ENDSELECT

ENDPROC

PROC scanlookup(port, proto)
DEF buildstr[1024]:STRING,
    index

    IF servicecheckflag=MUI_TRUE
        findservice(port)
        IF trojanflag=FALSE
            index:=InStr(servicedesc, '[TROJAN',0)
            IF (index>-1) THEN StrCopy(servicedesc, servicedesc, index)
        ENDIF
        StringF(buildstr, '\eb\d\en \s - \s',port, proto, servicedesc)
        outlist(buildstr)
    ELSE
        StringF(buildstr,'\eb\d\en \s - OPEN',port, proto)
        outlist(buildstr)
    ENDIF

ENDPROC

PROC scanreadport(sock, port)
DEF readfds:fd_set,
    tv:timeval,
    recvlen=0,
    displaystr[1024]:STRING,
    logstr[2048]:STRING,
    buf[1024]:STRING

    IF readportflag=MUI_TRUE
        StrAdd(workonstr, txt_Face_Workingon5)
        set(mui_workingon_tb, MUIA_Text_Contents, workonstr)
        IF (wakeupflag=MUI_TRUE) THEN Send(sock, '\n\n',2, MSG_WAITALL)
        fd_zero(readfds)
        fd_set(sock, readfds)
        tv.sec:=timeflag
        tv.usec:=5
        IF WaitSelect(sock+1, readfds, NIL, NIL, tv, NIL)>0
            recvlen:=Recv(sock, buf, 1024 ,0)
            IF (recvlen=0) THEN StrCopy(displaystr, '') ELSE StrCopy(displaystr, buf, recvlen)
            StringF(logstr, '##BEGIN \d##\n\s##END \d##\n', port, displaystr, port)
            addlog(logstr)
        ELSE
            StringF(logstr, '##PORT \d NO REPLY##\n', port)
            addlog(logstr)
        ENDIF
            StrCopy(buf, '', ALL)
    ENDIF
ENDPROC

PROC scanstealth(port, proto)
DEF buildstr[1024]:STRING

    IF stealthflag=MUI_TRUE
        StringF(buildstr, '\eb\d\en \s - STEALTHED', port, proto)
        outlist(buildstr)
    ENDIF
ENDPROC

PROC udp_maybe_open(port)
    scanlookup(port, 'UDP \eb(!!)\en')
ENDPROC


PROC scanclosed(port, proto)
DEF buildstr[1024]:STRING

    IF closedflag=MUI_TRUE
        StringF(buildstr, '\eb\d\en \s - CLOSED', port, proto)
        outlist(buildstr)
    ENDIF
ENDPROC

PROC handle_delay() HANDLE
DEF signal

    NEW timerdelay.softtimer()
    IF delayflag > 0
        timerdelay.startTimer(delayflag)
        StringF(workonstr, '\s (Delaying \d secs)', workonstr, delayflag)
        set(mui_workingon_tb, MUIA_Text_Contents, workonstr)
        WHILE timerdelay.getTimerMsg()<>TRUE
            doMethodA(app, [MUIM_Application_Input,{signal}])
            IF abortflag=TERM_USER THEN Raise(ERR_USERABORT)
        ENDWHILE
        timerdelay.stopTimer()
    ENDIF
    
EXCEPT DO
StrCopy(workonstr, '')
END timerdelay

ENDPROC
