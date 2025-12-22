OPT MODULE
OPT EXPORT

/*
    Description: Most of the program strings have been isolated here to ease
                 localisation.

    Quick Notes:

    1. DO NOT ALTER texts.e DIRECTLY! ALL CHANGES SHOULD BE MADE TO texts.sd
       This is because texts.sd is parsed by FlexCat as part of the localisation
       process and texts.e is generated automatically.
*/


MODULE  'locale',
        'libraries/locale'

DEF catalog:PTR TO catalog,
    txt_MainWindow_Title,
    txt_LookWindow_Title,
    txt_PrefsWindow_Title,
    txt_BookmarkWindow_Title,
    txt_CustomrangeWindow_Title,
    txt_HelperWindow_Title,
    txt_MenuTitle_Project,
    txt_MenuTitle_Settings,
    txt_MenuItem_About,
    txt_MenuItem_AboutMUI,
    txt_MenuItem_MuiSettings,
    txt_MenuItem_Prefs,
    txt_MenuItem_Bookmarks,
    txt_MenuItem_ServiceLook,
    txt_MenuItem_Iconify,
    txt_MenuItem_Quit,
    txt_MenuItem_PrefSave,
    txt_Face_Scan,
    txt_Face_Resolve,
    txt_Face_Abort,
    txt_Face_Dragbar,
    txt_Face_Workingon1,
    txt_Face_Workingon2,
    txt_Face_Workingon3,
    txt_Face_Workingon4,
    txt_Face_Workingon5,
    txt_Face_Workingon6,
    txt_Face_Workingon7,
    txt_Face_Workingon8,
    txt_Face_Workingon9,
    txt_Face_Workingon10,
    txt_Face_Lookup,
    txt_Face_PrefSave,
    txt_Face_PrefUse,
    txt_Face_PrefCancel,
    txt_Face_Bookmarkadd,
    txt_Face_Bookmarkdel,
    txt_Face_Ping,
    txt_Face_UDPPing,
    txt_Face_Traceroute,
    txt_Face_OK,
    txt_Face_Cancel,
    txt_Face_Pingsweep,
    txt_Face_PortCyc1,
    txt_Face_PortCyc2,
    txt_Face_PortCyc3,
    txt_Face_PortCyc4,
    txt_Face_PortCyc5,
    txt_Face_LookupCyc1,
    txt_Face_LookupCyc2,
    txt_Face_LookupCyc3,
    txt_Face_ScanTypeCyc1,
    txt_Face_ScanTypeCyc2,
    txt_Face_ScanTypeCyc3,
    txt_Face_ScanTypeCyc4,
    txt_Face_PingSweepCyc1,
    txt_Face_PingSweepCyc2,
    txt_Face_Pages1,
    txt_Face_Pages2,
    txt_Face_Pages3,
    txt_Face_Pages4,
    txt_Bubble_Server,
    txt_Bubble_Savepath,
    txt_Bubble_Portrange,
    txt_Bubble_Workingon,
    txt_Bubble_OutputLV,
    txt_Bubble_Timeout,
    txt_Bubble_Scan,
    txt_Bubble_Abort,
    txt_Bubble_Readcheck,
    txt_Bubble_Servicecheck,
    txt_Bubble_Wakeup,
    txt_Bubble_Portrangecyc,
    txt_Bubble_Opencustom,
    txt_Bubble_Lookupstring1,
    txt_Bubble_Lookupstring2,
    txt_Bubble_Lookup,
    txt_Bubble_Lookupcyc1,
    txt_Bubble_Lookupcyc2,
    txt_Bubble_Lookupcyc3,
    txt_Bubble_PrefTel,
    txt_Bubble_PrefSave,
    txt_Bubble_PrefUse,
    txt_Bubble_PrefCancel,
    txt_Bubble_PingNum,
    txt_Bubble_BookmarkLV,
    txt_Bubble_Bookmarkstr,
    txt_Bubble_Bookmarkadd,
    txt_Bubble_Bookmarkdel,
    txt_Bubble_Openbookmarks,
    txt_Bubble_Showtrojan,
    txt_Bubble_Prefservice,
    txt_Bubble_Customok,
    txt_Bubble_Customcancel,
    txt_Bubble_Customstr,
    txt_Bubble_PrefFTP,
    txt_Bubble_PrefWeb,
    txt_Bubble_PrefOther,
    txt_Bubble_Delay,
    txt_Bubble_Scantype,
    txt_Bubble_Ping,
    txt_Bubble_Resolve,
    txt_Bubble_Traceroute,
    txt_Bubble_Pingsweepnum,
    txt_Bubble_Tracemaxhops,
    txt_Bubble_Tracedns,
    txt_Bubble_Pingsweepdns,
    txt_Bubble_Pingsweepshowicmp,
    txt_Bubble_Pingsweeptype,
    txt_Bubble_Logviewbutton,
    txt_Bubble_Freq,
    txt_Bubble_Pingsweep,
    txt_Bubble_TrouteType,
    txt_Bubble_UDPPing,
    txt_Bubble_Blocking_Chk,
    txt_Bubble_Stealth_Chk,
    txt_Bubble_Closed_Chk,
    txt_Label_Host,
    txt_Label_Ports,
    txt_Label_Range,
    txt_Label_Log,
    txt_Label_Readports,
    txt_Label_Servicecheck,
    txt_Label_Wakeup,
    txt_Label_Timeout,
    txt_Label_Workingon,
    txt_Label_Telnet,
    txt_Label_Showtrojan,
    txt_Label_Customrange,
    txt_Label_FTP,
    txt_Label_Other,
    txt_Label_Web,
    txt_Label_Scantype,
    txt_Label_Ping,
    txt_Label_Service,
    txt_Label_Dnslookup,
    txt_Label_Numaddresses,
    txt_Label_Reportnonecho,
    txt_Label_Sweeptype,
    txt_Label_Maxhops,
    txt_Label_TrouteType,
    txt_Label_Blocking_Chk,
    txt_Label_Stealth_Chk,
    txt_Label_Closed_Chk,
    txt_Error_NoMUI,
    txt_Error_NoApp,
    txt_Error_NoTCP,
    txt_Error_NoLog,
    txt_Error_Badport,
    txt_Error_NoAsl,
    txt_Error_NoSocket,
    txt_Error_NoIcon,
    txt_Error_NoDNSRes,
    txt_Error_NoMem,
    txt_Error_Exception,
    txt_Error_NoLocale,
    txt_Error_Netunreach,
    txt_Error_Hostunreach,
    txt_Error_Timedout,
    txt_Text_Main,
    txt_Text_Customrange,
    txt_Text_WrittenToLog,
    txt_HelpFile

CONST
LOC_MAINWIN_TITLE=1,
LOC_LOOKWIN_TITLE=2,
LOC_PREFSWIN_TITLE=3,
LOC_BOOKMARKWIN_TITLE=4,
LOC_CUSTOMRANGEWIN_TITLE=5,
LOC_HELPERWIN_TITLE=6,
LOC_PROJECT_MENU=100,
LOC_SETTINGS_MENU=101,
LOC_ABOUT_MENUITEM=102,
LOC_ABOUTMUI_MENUITEM=103,
LOC_PREFERENCES_MENUITEM=104,
LOC_BOOKMARKS_MENUITEM=105,
LOC_MUISETTINGS_MENUITEM=106,
LOC_SERVICELOOK_MENUITEM=107,
LOC_ICONIFY_MENUITEM=108,
LOC_QUIT_MENUITEM=109,
LOC_PREFSAVE_MENUITEM=110,
LOC_SCAN_FACE=201,
LOC_RESOLVE_FACE=202,
LOC_ABORT_FACE=203,
LOC_DRAGME_FACE=204,
LOC_WORKINGON1_FACE=205,
LOC_WORKINGON2_FACE=206,
LOC_WORKINGON3_FACE=207,
LOC_WORKINGON4_FACE=208,
LOC_WORKINGON5_FACE=209,
LOC_WORKINGON6_FACE=210,
LOC_WORKINGON7_FACE=211,
LOC_WORKINGON8_FACE=212,
LOC_WORKINGON9_FACE=213,
LOC_WORKINGON10_FACE=214,
LOC_LOOKUP_FACE=215,
LOC_PREFSAVE_FACE=216,
LOC_PREFUSE_FACE=217,
LOC_PREFCANCEL_FACE=218,
LOC_BOOKMARKADD_FACE=219,
LOC_BOOKMARKDEL_FACE=220,
LOC_PING_FACE=221,
LOC_UDPPING_FACE=222,
LOC_TRACEROUTE_FACE=223,
LOC_OK_FACE=224,
LOC_CANCEL_FACE=225,
LOC_PINGSWEEP_FACE=226,
LOC_PORTCYC1_FACE=227,
LOC_PORTCYC2_FACE=228,
LOC_PORTCYC3_FACE=229,
LOC_PORTCYC4_FACE=230,
LOC_PORTCYC5_FACE=231,
LOC_LOOKUPCYC1_FACE=232,
LOC_LOOKUPCYC2_FACE=233,
LOC_LOOKUPCYC3_FACE=234,
LOC_SCANTYPECYC1_FACE=235,
LOC_SCANTYPECYC2_FACE=236,
LOC_SCANTYPECYC3_FACE=237,
LOC_SCANTYPECYC4_FACE=238,
LOC_PINGSWEEPCYC1_FACE=239,
LOC_PINGSWEEPCYC2_FACE=240,
LOC_PAGES1_FACE=241,
LOC_PAGES2_FACE=242,
LOC_PAGES3_FACE=243,
LOC_PAGES4_FACE=244,
LOC_SERVER_BUBBLE=300,
LOC_SAVEPATH_BUBBLE=301,
LOC_PORTRANGE_BUBBLE=302,
LOC_WORKINGON_BUBBLE=303,
LOC_OUTPUTLV_BUBBLE=304,
LOC_TIMEOUT_BUBBLE=305,
LOC_SCAN_BUBBLE=308,
LOC_RESOLVE_BUBBLE=309,
LOC_ABORT_BUBBLE=310,
LOC_READCHECK_BUBBLE=311,
LOC_SERVICECHECK_BUBBLE=312,
LOC_WAKEUP_BUBBLE=313,
LOC_PORTRANGECYC_BUBBLE=314,
LOC_OPENCUSTOM_BUBBLE=315,
LOC_LOOKUPSTRING1_BUBBLE=316,
LOC_LOOKUPSTRING2_BUBBLE=317,
LOC_LOOKUP_BUBBLE=318,
LOC_LOOKUPCYC1_BUBBLE=319,
LOC_LOOKUPCYC2_BUBBLE=320,
LOC_LOOKUPCYC3_BUBBLE=321,
LOC_PREFTEL_BUBBLE=322,
LOC_PREFSAVE_BUBBLE=323,
LOC_PREFUSE_BUBBLE=324,
LOC_PREFCANCEL_BUBBLE=325,
LOC_PINGNUM_BUBBLE=326,
LOC_BOOKMARKLV_BUBBLE=327,
LOC_BOOKMARKSTR_BUBBLE=328,
LOC_BOOKMARKADD_BUBBLE=329,
LOC_BOOKMARKDEL_BUBBLE=330,
LOC_SHOWTROJAN_BUBBLE=331,
LOC_CUSTOMOK_BUBBLE=332,
LOC_CUSTOMCANCEL_BUBBLE=333,
LOC_CUSTOMSTR_BUBBLE=334,
LOC_PREFFTP_BUBBLE=335,
LOC_PREFWEB_BUBBLE=336,
LOC_PREFOTHER_BUBBLE=337,
LOC_DELAY_BUBBLE=338,
LOC_SCANTYPE_BUBBLE=339,
LOC_PING_BUBBLE=340,
LOC_UDPPING_BUBBLE=341,
LOC_TRACEROUTE_BUBBLE=342,
LOC_PREFSERVICE_BUBBLE=343,
LOC_PINGSWEEPNUM_BUBBLE=344,
LOC_TRACEMAXHOPS_BUBBLE=345,
LOC_TRACEDNS_BUBBLE=346,
LOC_PINGSWEEPDNS_BUBBLE=347,
LOC_PINGSWEEPSHOWICMP_BUBBLE=348,
LOC_PINGSWEEPTYPE_BUBBLE=349,
LOC_LOGVIEWBUTTON_BUBBLE=350,
LOC_FREQ_BUBBLE=351,
LOC_PINGSWEEP_BUBBLE=352,
LOC_OPENBOOKMARKS_BUBBLE=353,
LOC_TROUTETYPE_BUBBLE=354,
LOC_BLOCKING_CHK_BUBBLE=355,
LOC_STEALTH_CHK_BUBBLE=356,
LOC_CLOSED_CHK_BUBBLE=357,
LOC_HOST_LABEL=400,
LOC_PORTS_LABEL=401,
LOC_RANGE_LABEL=402,
LOC_LOG_LABEL=403,
LOC_READPORTS_LABEL=404,
LOC_SERVICECHECK_LABEL=405,
LOC_WAKEUP_LABEL=406,
LOC_TIMEOUT_LABEL=407,
LOC_WORKINGON_LABEL=408,
LOC_TELNET_LABEL=409,
LOC_SHOWTROJAN_LABEL=410,
LOC_CUSTOMRANGE_LABEL=411,
LOC_FTP_LABEL=412,
LOC_WEB_LABEL=413,
LOC_OTHER_LABEL=414,
LOC_SCANTYPE_LABEL=415,
LOC_PING_LABEL=416,
LOC_SERVICE_LABEL=417,
LOC_DNSLOOKUP_LABEL=418,
LOC_NUMADDRESSES_LABEL=419,
LOC_REPORTNONECHO_LABEL=420,
LOC_SWEEPTYPE_LABEL=421,
LOC_MAXHOPS_LABEL=422,
LOC_TROUTETYPE_LABEL=423,
LOC_BLOCKING_CHK_LABEL=424,
LOC_STEALTH_CHK_LABEL=425,
LOC_CLOSED_CHK_LABEL=426,
LOC_MAIN_TEXT=500,
LOC_CUSTOMRANGE_TEXT=501,
LOC_WRITTENTOLOG_TEXT=502,
LOC_NOMUI_ERROR=600,
LOC_NOAPP_ERROR=601,
LOC_NOTCP_ERROR=602,
LOC_NOLOG_ERROR=603,
LOC_BADPORT_ERROR=604,
LOC_NOASL_ERROR=605,
LOC_NOSOCKET_ERROR=606,
LOC_NOICON_ERROR=607,
LOC_NODNSRES_ERROR=608,
LOC_NOMEM_ERROR=609,
LOC_EXCEPTION_ERROR=610,
LOC_NOLOCALE_ERROR=611,
LOC_NETUNREACH_ERROR=612,
LOC_HOSTUNREACH_ERROR=613,
LOC_TIMEDOUT_ERROR=614,
LOC_HELPFILE=700

PROC inittexts()

IF (localebase:=OpenLibrary('locale.library',38))=NIL THEN Raise(1000)
catalog:=OpenCatalogA(NIL, 'GoPortscan.catalog', [OC_BUILTINLANGUAGE, 'english', NIL, NIL])


->These texts describe window titles
txt_MainWindow_Title:= GetCatalogStr(catalog, LOC_MAINWIN_TITLE, 'Go Portscan! by Ian Chapman')
txt_LookWindow_Title:= GetCatalogStr(catalog, LOC_LOOKWIN_TITLE, 'Service Lookup')
txt_PrefsWindow_Title:= GetCatalogStr(catalog, LOC_PREFSWIN_TITLE, 'Preferences')
txt_BookmarkWindow_Title:= GetCatalogStr(catalog, LOC_BOOKMARKWIN_TITLE, 'BookMarks')
txt_CustomrangeWindow_Title:= GetCatalogStr(catalog, LOC_CUSTOMRANGEWIN_TITLE, 'Add Custom Range')
txt_HelperWindow_Title:= GetCatalogStr(catalog, LOC_HELPERWIN_TITLE, 'Choose Helper')

->These texts describe menus
txt_MenuTitle_Project:= GetCatalogStr(catalog, LOC_PROJECT_MENU, 'Project')
txt_MenuTitle_Settings:= GetCatalogStr(catalog, LOC_SETTINGS_MENU, 'Settings')
txt_MenuItem_About:= GetCatalogStr(catalog, LOC_ABOUT_MENUITEM, 'About...')
txt_MenuItem_AboutMUI:= GetCatalogStr(catalog, LOC_ABOUTMUI_MENUITEM, 'About MUI...')
txt_MenuItem_Prefs:= GetCatalogStr(catalog, LOC_PREFERENCES_MENUITEM, 'Preferences')
txt_MenuItem_Bookmarks:= GetCatalogStr(catalog, LOC_BOOKMARKS_MENUITEM, 'Bookmarks')
txt_MenuItem_MuiSettings:= GetCatalogStr(catalog, LOC_MUISETTINGS_MENUITEM, 'MUI Settings')
txt_MenuItem_ServiceLook:= GetCatalogStr(catalog, LOC_SERVICELOOK_MENUITEM, 'Service Lookup')
txt_MenuItem_Iconify:= GetCatalogStr(catalog, LOC_ICONIFY_MENUITEM, 'Iconify')
txt_MenuItem_Quit:= GetCatalogStr(catalog, LOC_QUIT_MENUITEM, 'Quit')
txt_MenuItem_PrefSave:= GetCatalogStr(catalog, LOC_PREFSAVE_MENUITEM, 'Save Preferences')

->These Texts describe what is printed on gadget faces
txt_Face_Scan:= GetCatalogStr(catalog, LOC_SCAN_FACE, 'Go Scan!')
txt_Face_Resolve:= GetCatalogStr(catalog, LOC_RESOLVE_FACE, 'Resolve')
txt_Face_Abort:= GetCatalogStr(catalog, LOC_ABORT_FACE, 'ABORT')
txt_Face_Dragbar:= GetCatalogStr(catalog, LOC_DRAGME_FACE, 'Drag Me')
txt_Face_Workingon1:= GetCatalogStr(catalog, LOC_WORKINGON1_FACE, 'Done!')
txt_Face_Workingon2:= GetCatalogStr(catalog, LOC_WORKINGON2_FACE, 'User Aborted!')
txt_Face_Workingon3:= GetCatalogStr(catalog, LOC_WORKINGON3_FACE, 'Host Unknown!')
txt_Face_Workingon4:= GetCatalogStr(catalog, LOC_WORKINGON4_FACE, 'Searching...')
txt_Face_Workingon5:= GetCatalogStr(catalog, LOC_WORKINGON5_FACE, '  (Reading Port)')
txt_Face_Workingon6:= GetCatalogStr(catalog, LOC_WORKINGON6_FACE, 'Sending Ping')
txt_Face_Workingon7:= GetCatalogStr(catalog, LOC_WORKINGON7_FACE, 'Received Echo')
txt_Face_Workingon8:= GetCatalogStr(catalog, LOC_WORKINGON8_FACE, 'DNS Lookup...')
txt_Face_Workingon9:= GetCatalogStr(catalog, LOC_WORKINGON9_FACE, 'Tracing...')
txt_Face_Workingon10:= GetCatalogStr(catalog, LOC_WORKINGON10_FACE, 'Ready')
txt_Face_Lookup:= GetCatalogStr(catalog, LOC_LOOKUP_FACE, 'Lookup')
txt_Face_PrefSave:= GetCatalogStr(catalog, LOC_PREFSAVE_FACE, 'Save')
txt_Face_PrefUse:= GetCatalogStr(catalog, LOC_PREFUSE_FACE, 'Use')
txt_Face_PrefCancel:= GetCatalogStr(catalog, LOC_PREFCANCEL_FACE, 'Cancel')
txt_Face_Bookmarkadd:= GetCatalogStr(catalog, LOC_BOOKMARKADD_FACE, 'Add')
txt_Face_Bookmarkdel:= GetCatalogStr(catalog, LOC_BOOKMARKDEL_FACE, 'Delete')
txt_Face_Ping:= GetCatalogStr(catalog, LOC_PING_FACE, 'ICMP Ping')
txt_Face_UDPPing:= GetCatalogStr(catalog, LOC_UDPPING_FACE, 'UDP Ping')
txt_Face_Traceroute:= GetCatalogStr(catalog, LOC_TRACEROUTE_FACE, 'Traceroute')
txt_Face_OK:= GetCatalogStr(catalog, LOC_OK_FACE, 'OK')
txt_Face_Cancel:= GetCatalogStr(catalog, LOC_CANCEL_FACE, 'Cancel')
txt_Face_Pingsweep:= GetCatalogStr(catalog, LOC_PINGSWEEP_FACE, 'Ping Sweep')
txt_Face_PortCyc1:= GetCatalogStr(catalog, LOC_PORTCYC1_FACE, 'Default')
txt_Face_PortCyc2:= GetCatalogStr(catalog, LOC_PORTCYC2_FACE, 'Common')
txt_Face_PortCyc3:= GetCatalogStr(catalog, LOC_PORTCYC3_FACE, 'Well Known')
txt_Face_PortCyc4:= GetCatalogStr(catalog, LOC_PORTCYC4_FACE, 'Registered')
txt_Face_PortCyc5:= GetCatalogStr(catalog, LOC_PORTCYC5_FACE, 'ALL')
txt_Face_LookupCyc1:= GetCatalogStr(catalog, LOC_LOOKUPCYC1_FACE, 'Port')
txt_Face_LookupCyc2:= GetCatalogStr(catalog, LOC_LOOKUPCYC2_FACE, 'Keyword (case)')
txt_Face_LookupCyc3:= GetCatalogStr(catalog, LOC_LOOKUPCYC3_FACE, 'Keyword (no case)')
txt_Face_ScanTypeCyc1:= GetCatalogStr(catalog, LOC_SCANTYPECYC1_FACE, 'TCP Only')
txt_Face_ScanTypeCyc2:= GetCatalogStr(catalog, LOC_SCANTYPECYC2_FACE, 'UDP Only')
txt_Face_ScanTypeCyc3:= GetCatalogStr(catalog, LOC_SCANTYPECYC3_FACE, 'TCP then UDP')
txt_Face_ScanTypeCyc4:= GetCatalogStr(catalog, LOC_SCANTYPECYC4_FACE, 'UDP then TCP')
txt_Face_PingSweepCyc1:= GetCatalogStr(catalog, LOC_PINGSWEEPCYC1_FACE, 'Incremental')
txt_Face_PingSweepCyc2:= GetCatalogStr(catalog, LOC_PINGSWEEPCYC2_FACE, 'Decremental')
txt_Face_Pages1:= GetCatalogStr(catalog, LOC_PAGES1_FACE, 'Portscan')
txt_Face_Pages2:= GetCatalogStr(catalog, LOC_PAGES2_FACE, 'Traceroute')
txt_Face_Pages3:= GetCatalogStr(catalog, LOC_PAGES3_FACE, 'Pingsweep')
txt_Face_Pages4:= GetCatalogStr(catalog, LOC_PAGES4_FACE, 'Other')

->These Texts describe what is printed in Bubblehelp
txt_Bubble_Server:= GetCatalogStr(catalog, LOC_SERVER_BUBBLE, 'Host name or IP address')
txt_Bubble_Savepath:= GetCatalogStr(catalog, LOC_SAVEPATH_BUBBLE, 'Path and filename for the log file')
txt_Bubble_Portrange:= GetCatalogStr(catalog, LOC_PORTRANGE_BUBBLE, 'Scan these port ranges')
txt_Bubble_Workingon:= GetCatalogStr(catalog, LOC_WORKINGON_BUBBLE, 'Current status')
txt_Bubble_OutputLV:= GetCatalogStr(catalog, LOC_OUTPUTLV_BUBBLE, 'Scanning results and general output')
txt_Bubble_Timeout:= GetCatalogStr(catalog, LOC_TIMEOUT_BUBBLE, 'Time (secs) to wait for a response\nwhen reading a port')
txt_Bubble_Scan:= GetCatalogStr(catalog, LOC_SCAN_BUBBLE, 'Start the port scan')
txt_Bubble_Resolve:= GetCatalogStr(catalog, LOC_RESOLVE_BUBBLE, 'Looks up IP and all hostnames\nand aliases for the host')
txt_Bubble_Abort:= GetCatalogStr(catalog, LOC_ABORT_BUBBLE, 'Abort the current operation')
txt_Bubble_Readcheck:= GetCatalogStr(catalog, LOC_READCHECK_BUBBLE, 'Attempt to read open ports\nVery time consuming')
txt_Bubble_Servicecheck:= GetCatalogStr(catalog, LOC_SERVICECHECK_BUBBLE, 'Perform service lookup for open ports')
txt_Bubble_Wakeup:= GetCatalogStr(catalog, LOC_WAKEUP_BUBBLE, 'Attempt to provoke a response from open ports\nUse with care!')
txt_Bubble_Portrangecyc:= GetCatalogStr(catalog, LOC_PORTRANGECYC_BUBBLE, 'Default ranges for scanning')
txt_Bubble_Opencustom:= GetCatalogStr(catalog, LOC_OPENCUSTOM_BUBBLE, 'Add ports as a user defined range')
txt_Bubble_Lookupstring1:= GetCatalogStr(catalog, LOC_LOOKUPSTRING1_BUBBLE, 'Enter port number')
txt_Bubble_Lookupstring2:= GetCatalogStr(catalog, LOC_LOOKUPSTRING2_BUBBLE, 'Enter keyword')
txt_Bubble_Lookup:= GetCatalogStr(catalog, LOC_LOOKUP_BUBBLE, 'Start lookup')
txt_Bubble_Lookupcyc1:= GetCatalogStr(catalog, LOC_LOOKUPCYC1_BUBBLE, 'Search by port number')
txt_Bubble_Lookupcyc2:= GetCatalogStr(catalog, LOC_LOOKUPCYC2_BUBBLE, 'Search by keyword\n\ec(Case Insensitive)')
txt_Bubble_Lookupcyc3:= GetCatalogStr(catalog, LOC_LOOKUPCYC3_BUBBLE, 'Search by keyword\n\ec(Case Sensitive)')
txt_Bubble_PrefTel:= GetCatalogStr(catalog, LOC_PREFTEL_BUBBLE, 'Telnet helper with parameters')
txt_Bubble_PrefSave:= GetCatalogStr(catalog, LOC_PREFSAVE_BUBBLE, 'Save preferences permanently.')
txt_Bubble_PrefUse:= GetCatalogStr(catalog, LOC_PREFUSE_BUBBLE, 'Use preferences. Changes lost after reboot')
txt_Bubble_PrefCancel:= GetCatalogStr(catalog, LOC_PREFCANCEL_BUBBLE, 'Discard preference changes')
txt_Bubble_PingNum:= GetCatalogStr(catalog, LOC_PINGNUM_BUBBLE, 'Number of pings to send')
txt_Bubble_BookmarkLV:= GetCatalogStr(catalog, LOC_BOOKMARKLV_BUBBLE, 'Host Bookmarks\nDouble click to select the host')
txt_Bubble_Bookmarkstr:= GetCatalogStr(catalog, LOC_BOOKMARKSTR_BUBBLE, 'Enter hostname to bookmark')
txt_Bubble_Bookmarkadd:= GetCatalogStr(catalog, LOC_BOOKMARKADD_BUBBLE, 'Add host to bookmarks')
txt_Bubble_Bookmarkdel:= GetCatalogStr(catalog, LOC_BOOKMARKDEL_BUBBLE, 'Delete host from bookmarks')
txt_Bubble_Showtrojan:= GetCatalogStr(catalog, LOC_SHOWTROJAN_BUBBLE, 'Show possible trojans during a port scan')
txt_Bubble_Customok:= GetCatalogStr(catalog, LOC_CUSTOMOK_BUBBLE, 'Save user defined range')
txt_Bubble_Customcancel:= GetCatalogStr(catalog, LOC_CUSTOMCANCEL_BUBBLE, 'Discard user defined range')
txt_Bubble_Customstr:= GetCatalogStr(catalog, LOC_CUSTOMSTR_BUBBLE, 'Name of user defined range')
txt_Bubble_PrefFTP:= GetCatalogStr(catalog, LOC_PREFFTP_BUBBLE, 'FTP helper with parameters')
txt_Bubble_PrefWeb:= GetCatalogStr(catalog, LOC_PREFWEB_BUBBLE, 'Web helper with parameters')
txt_Bubble_PrefOther:= GetCatalogStr(catalog, LOC_PREFOTHER_BUBBLE, 'Other helper with parameters')
txt_Bubble_Delay:= GetCatalogStr(catalog, LOC_DELAY_BUBBLE, 'Delay in seconds between each scan or ping')
txt_Bubble_Scantype:= GetCatalogStr(catalog, LOC_SCANTYPE_BUBBLE, 'Select the type of scan to perform')
txt_Bubble_Ping:= GetCatalogStr(catalog, LOC_PING_BUBBLE, 'Perform standard ICMP Ping\nBroadcast addresses can also be used')
txt_Bubble_UDPPing:= GetCatalogStr(catalog, LOC_UDPPING_BUBBLE, 'Perform non-standard UDP Ping')
txt_Bubble_Traceroute:= GetCatalogStr(catalog, LOC_TRACEROUTE_BUBBLE, 'Start traceroute')
txt_Bubble_Prefservice:= GetCatalogStr(catalog, LOC_PREFSERVICE_BUBBLE, 'Choose internal service lookup\nor use your TCP/IP stacks')
txt_Bubble_Pingsweepnum:= GetCatalogStr(catalog, LOC_PINGSWEEPNUM_BUBBLE, 'Number of IP addresses to attempt to ping')
txt_Bubble_Tracemaxhops:= GetCatalogStr(catalog, LOC_TRACEMAXHOPS_BUBBLE, 'Maximum number of hops to trace')
txt_Bubble_Tracedns:= GetCatalogStr(catalog, LOC_TRACEDNS_BUBBLE, 'Perform DNS lookup for traced hops')
txt_Bubble_Pingsweepdns:= GetCatalogStr(catalog, LOC_PINGSWEEPDNS_BUBBLE, 'Perform DNS lookup for ping swept hosts')
txt_Bubble_Pingsweepshowicmp:= GetCatalogStr(catalog, LOC_PINGSWEEPSHOWICMP_BUBBLE, 'Show non-echo ICMP responses')
txt_Bubble_Pingsweeptype:= GetCatalogStr(catalog, LOC_PINGSWEEPTYPE_BUBBLE, 'Incremental = Ping addresses => host\nDecremental = Ping addresses <= host')
txt_Bubble_Logviewbutton:= GetCatalogStr(catalog, LOC_LOGVIEWBUTTON_BUBBLE, 'Write listview contents to logfile')
txt_Bubble_Freq:= GetCatalogStr(catalog, LOC_FREQ_BUBBLE, 'Choose logfile location')
txt_Bubble_Pingsweep:= GetCatalogStr(catalog, LOC_PINGSWEEP_BUBBLE, 'Start the Ping Sweep')
txt_Bubble_Openbookmarks:= GetCatalogStr(catalog, LOC_OPENBOOKMARKS_BUBBLE, 'Open the bookmarks window')
txt_Bubble_TrouteType:=GetCatalogStr(catalog, LOC_TROUTETYPE_BUBBLE, 'Choose ICMP or UDP traceroute')
txt_Bubble_Blocking_Chk:=GetCatalogStr(catalog, LOC_BLOCKING_CHK_BUBBLE, 'Use non-blocking sockets')
txt_Bubble_Stealth_Chk:=GetCatalogStr(catalog, LOC_STEALTH_CHK_BUBBLE, 'Show stealthed ports')
txt_Bubble_Closed_Chk:=GetCatalogStr(catalog, LOC_CLOSED_CHK_BUBBLE, 'Show closed ports')

->These describe what is printed in labelling.
txt_Label_Host:= GetCatalogStr(catalog, LOC_HOST_LABEL, 'Host:')
txt_Label_Ports:= GetCatalogStr(catalog, LOC_PORTS_LABEL, 'Ports:')
txt_Label_Range:= GetCatalogStr(catalog, LOC_RANGE_LABEL, 'Range:')
txt_Label_Log:= GetCatalogStr(catalog, LOC_LOG_LABEL, 'Log:')
txt_Label_Readports:= GetCatalogStr(catalog, LOC_READPORTS_LABEL, 'Read Ports:')
txt_Label_Servicecheck:= GetCatalogStr(catalog, LOC_SERVICECHECK_LABEL, 'Service Lookup:')
txt_Label_Wakeup:= GetCatalogStr(catalog, LOC_WAKEUP_LABEL, 'Wakeup:')
txt_Label_Timeout:= GetCatalogStr(catalog, LOC_TIMEOUT_LABEL, 'Timeout:')
txt_Label_Workingon:= GetCatalogStr(catalog, LOC_WORKINGON_LABEL, 'Status:')
txt_Label_Telnet:= GetCatalogStr(catalog, LOC_TELNET_LABEL, 'Telnet:')
txt_Label_Showtrojan:= GetCatalogStr(catalog, LOC_SHOWTROJAN_LABEL, 'Show Trojans:')
txt_Label_Customrange:= GetCatalogStr(catalog, LOC_CUSTOMRANGE_LABEL, 'Range name:')
txt_Label_FTP:= GetCatalogStr(catalog, LOC_FTP_LABEL, 'FTP:')
txt_Label_Web:= GetCatalogStr(catalog, LOC_WEB_LABEL, 'Web:')
txt_Label_Other:= GetCatalogStr(catalog, LOC_OTHER_LABEL, 'Other:')
txt_Label_Scantype:= GetCatalogStr(catalog, LOC_SCANTYPE_LABEL, 'Scan Type:')
txt_Label_Ping:= GetCatalogStr(catalog, LOC_PING_LABEL, 'Pings to send:')
txt_Label_Service:= GetCatalogStr(catalog, LOC_SERVICE_LABEL, 'Internal Service Table: ')
txt_Label_Dnslookup:= GetCatalogStr(catalog, LOC_DNSLOOKUP_LABEL, 'DNS Lookup:')
txt_Label_Numaddresses:= GetCatalogStr(catalog, LOC_NUMADDRESSES_LABEL, 'Num Addresses:')
txt_Label_Reportnonecho:= GetCatalogStr(catalog, LOC_REPORTNONECHO_LABEL, 'Non-Echo Replies:')
txt_Label_Sweeptype:= GetCatalogStr(catalog, LOC_SWEEPTYPE_LABEL, 'Sweep Type:')
txt_Label_Maxhops:= GetCatalogStr(catalog, LOC_MAXHOPS_LABEL, 'Max Hops:')
txt_Label_TrouteType:=GetCatalogStr(catalog, LOC_TROUTETYPE_LABEL, 'Type:')
txt_Label_Blocking_Chk:=GetCatalogStr(catalog, LOC_BLOCKING_CHK_LABEL, 'Non-Blocking Sockets:')
txt_Label_Stealth_Chk:=GetCatalogStr(catalog, LOC_STEALTH_CHK_LABEL,' Show Stealthed:')
txt_Label_Closed_Chk:=GetCatalogStr(catalog, LOC_CLOSED_CHK_LABEL,' Show Closed:')

->These describe text objects
txt_Text_Main:= GetCatalogStr(catalog, LOC_MAIN_TEXT, '\ecGo Portscan! V1.1\nMain Window')
txt_Text_Customrange:= GetCatalogStr(catalog, LOC_CUSTOMRANGE_TEXT, '\ecEnter a name for the user defined range\nIt will only appear once Go Portscan! is restarted')
txt_Text_WrittenToLog:= GetCatalogStr(catalog, LOC_WRITTENTOLOG_TEXT, '\ecListview contents written to logfile')

->These describe errors
txt_Error_NoMUI:= GetCatalogStr(catalog, LOC_NOMUI_ERROR, 'Unable to open muimaster.library V19+\n')
txt_Error_NoApp:= GetCatalogStr(catalog, LOC_NOAPP_ERROR, 'Unable to create application\nOut of memory?\n')
txt_Error_NoTCP:= GetCatalogStr(catalog, LOC_NOTCP_ERROR, '\ebUnable to open bsdsocket.library V2+. Is TCP/IP running?\en')
txt_Error_NoLog:= GetCatalogStr(catalog, LOC_NOLOG_ERROR, '\ebUnable to open log file\en')
txt_Error_Badport:= GetCatalogStr(catalog, LOC_BADPORT_ERROR, '\ebIncorrect port range specification\en')
txt_Error_NoAsl:= GetCatalogStr(catalog, LOC_NOASL_ERROR, 'Unable to open reqtools.library V38+\n')
txt_Error_NoSocket:= GetCatalogStr(catalog, LOC_NOSOCKET_ERROR, 'Error creating socket\n')
txt_Error_NoIcon:= GetCatalogStr(catalog, LOC_NOICON_ERROR, 'Unable to open icon.library V33+\n')
txt_Error_NoDNSRes:= GetCatalogStr(catalog, LOC_NODNSRES_ERROR, 'Unknown host or unable to contact DNS')
txt_Error_NoMem:= GetCatalogStr(catalog, LOC_NOMEM_ERROR, 'Unable to allocate memory for operation')
txt_Error_Exception:= GetCatalogStr(catalog, LOC_EXCEPTION_ERROR, 'Internal Exception in \s Code:(\d). Please report problem to author\n')
txt_Error_NoLocale:= GetCatalogStr(catalog, LOC_NOLOCALE_ERROR, 'Unable to open locale.library V38+\n')
txt_Error_Netunreach:= GetCatalogStr(catalog, LOC_NETUNREACH_ERROR, 'Remote network unreachable from this machine')
txt_Error_Hostunreach:= GetCatalogStr(catalog, LOC_HOSTUNREACH_ERROR, 'Remote host unreachable from this machine')
txt_Error_Timedout:= GetCatalogStr(catalog, LOC_TIMEDOUT_ERROR, 'Connection timed out')


txt_HelpFile:= GetCatalogStr(catalog, LOC_HELPFILE, 'PROGDIR:GoPortscan!_en.guide')

->Termination Stuff
CloseCatalog(catalog)
IF (localebase) THEN CloseLibrary(localebase)
ENDPROC
