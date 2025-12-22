#ifndef __HOLLYWOOD_ERRORS_H
#define __HOLLYWOOD_ERRORS_H
/*
**
**	$VER: errors.h 10.0 (25.02.23)
**
**	Standard errors registered by Hollywood
**
**	(C) Copyright 2002-2023 Andreas Falkenhahn
**	    All Rights Reserved
**
*/

enum {
	ERR_NONE,                        /* [0000] No error occurred! */
	ERR_MEM = 1000,                  /* [1000] Out of memory! */
	ERR_UNIMPLCMD,                   /* [1001] Unimplemented command! */
	ERR_NORETVAL,                    /* [1002] No return value specified! */
	ERR_USERABORT,                   /* [1003] User abort! */
	ERR_SCREEN,                      /* [1004] Error opening screen! */
	ERR_WRITE,                       /* [1005] Could not write all characters to file! Check if there is enough free space! */
	ERR_UNTERMINTDSTR,               /* [1006] Unterminated string! */
	ERR_UNKNOWNCOND,                 /* [1007] Unknown condition! */
	ERR_MISSINGSEPARTR,              /* [1008] Multiple commands in one line have to be separated by a colon! */
	ERR_READ,                        /* [1009] Could not read all characters from file! Check if it is read protected! */
	ERR_WINDOW,                      /* [1010] Unable to open window! */
	ERR_ELSEWOIF,                    /* [1011] ELSE without IF! */
	ERR_ENDIFWOIF,                   /* [1012] ENDIF without IF! */
	ERR_IFWOENDIF,                   /* [1013] IF without ENDIF! */
	ERR_MISSINGPARAMTR,              /* [1014] Not enough arguments! */
	ERR_FORWONEXT,                   /* [1015] FOR without NEXT! */
	ERR_NEXTWOFOR,                   /* [1016] NEXT without FOR! */
	ERR_WHILEWOWEND,                 /* [1017] WHILE without WEND! */
	ERR_SYNTAXERROR,                 /* [1018] General syntax error! */
	ERR_WRONGDTYPE,                  /* [1019] Wrong data type specified! */
	ERR_VARSYNTAX,                   /* [1020] Syntax error in variable name! */
	ERR_WENDWOWHILE,                 /* [1021] WEND without WHILE! */
	ERR_UNKNOWNCMD,                  /* [1022] Unknown command %s ! */
	ERR_MISSINGBRACKET,              /* [1023] You specified too many arguments or forgot a close bracket! */
	ERR_VALUEEXPECTED,               /* [1024] Value expected! */
	ERR_OPENLIB,                     /* [1025] Cannot open %s ! */
	ERR_VAREXPECTED,                 /* [1026] Variable expected! */
	ERR_LABINFOR,                    /* [1027] Labels within a For() loop are not allowed! */
	ERR_LABINIF,                     /* [1028] Labels inside If() conditions are not allowed! */
	ERR_LABINWHILE,                  /* [1029] Labels within a While() loop are not allowed! */
	ERR_WRONGOP,                     /* [1030] Wrong operator for this type! */
	ERR_GETDISKOBJ,                  /* [1031] Cannot open icon! */
	ERR_EVNTEXPCTED,                 /* [1032] You need to specify a Hollywood event! */
	ERR_EMPTYOBJ,                    /* [1033] Cannot create empty text objects! */
	ERR_EMPTYSCRIPT,                 /* [1034] Your script is empty! */
	ERR_COMMENTSTRUCT,               /* [1035] Incoherent comment structure! */
	ERR_ALRDYDECLRD,                 /* [1036] This variable was already used and initialized! */
	ERR_WRONGFLOAT,                  /* [1037] Illegal float number format! */
	ERR_REQUIREFIELD,                /* [1038] You need to specify an array field! */
	ERR_OUTOFRANGE,                  /* [1039] Specified array field is out of range! */
	ERR_RETWOGOSUB,                  /* [1040] Return without Gosub! */
	ERR_FINDARRAY,                   /* [1041] Requested object not found! */
	ERR_FINDCST,                     /* [1042] Constant not found! */
	ERR_LOCK,                        /* [1043] Error locking directory! */
	ERR_LOADPICTURE,                 /* [1044] Cannot load picture %s! Make sure that you have a datatype for this format! */
	ERR_READFILE,                    /* [1045] Cannot read file %s ! */
	ERR_NOTPROTRACKER,               /* [1046] Module is not in Protracker format! */
	ERR_UNKNOWNSEQ,                  /* [1047] Unknown sequence character after backslash! */
	ERR_DIRLOCK,                     /* [1048] Error locking directory %s ! */
	ERR_KEYWORD,                     /* [1049] Unknown keyword! */
	ERR_KICKSTART,                   /* [1050] You need at least Kickstart 3.0! */
	ERR_FREEABGPIC,                  /* [1051] You cannot free the background picture that is currently displayed! */
	ERR_WRITEFILE,                   /* [1052] Cannot write to file %s ! */
	ERR_VERSION,                     /* [1053] This script requires at least Hollywood %s ! */
	ERR_NOFUNCTION,                  /* [1054] This command does not return anything! */
	ERR_WRONGUSAGE,                  /* [1055] Wrong usage/parameters for this command! Read the documentation! */
	ERR_SELECTBG,                    /* [1056] This command cannot be used when SelectBGPic() is active! */
	ERR_ARRAYDECLA,                  /* [1057] Array "%s[]" was not declared! */
	ERR_CMDASVAR,                    /* [1058] This variable name is already used by a command! */
	ERR_CONFIG,                      /* [1059] No script filename specified! */
	ERR_ARGS,                        /* [1060] Wrong arguments specified! */
	ERR_DOUBLEDECLA,                 /* [1061] Double declaration! Number already assigned previously! */
	ERR_EQUALEXPECTED,               /* [1062] Equal sign expected! */
	ERR_OPENANIM,                    /* [1063] Cannot load animation! Make sure that you got at least version 40 of animation.datatype and realtime.library! Please note that MorphOS does not have a datatype for IFF ANIM files currently. So if you want to use IFF ANIM files, you need to install a datatype first, e.g. the IFF ANIM datatype of OS3.1! */
	ERR_OPENFONT,                    /* [1064] (for internal use) */
	ERR_OPENSOUND,                   /* [1065] Cannot load sample %s ! Make sure you have a datatype for this sample format!  If you tried to load a 16-bit sample and get this error, you need to install a sound.datatype replacement because the OS 3.x datatype does only support 8-bit samples. You can get the sound.datatype replacement from http://www.stephan-rupprecht.de/ or from the Hollywood CD-ROM. You do NOT need the replacement on MorphOS 1.x because that already uses a new sound.datatype which supports 16-bit samples! */
	
	/* === new in Hollywood 1.5 === */	
	ERR_INTERNAL,                    /* [1066] Internal limit encountered! Contact the author... */
	ERR_PUBSCREEN,                   /* [1067] Cannot find the specified public screen! */
	ERR_BRUSHLINK,                   /* [1068] This command cannot handle linked brushes! */
	ERR_WRONGID,                     /* [1069] Please use only positive integers for your objects! */
	ERR_AHI,                         /* [1070] General AHI error! Check your AHI installation and settings! */
	ERR_VARLENGTH,                   /* [1071] Variable length is limited to 64 characters! */
	ERR_LABELDECLA,                  /* [1072] Cannot find label "%s" ! */
	ERR_LABELDOUBLE,                 /* [1073] Label "%s" was already defined! */
	ERR_NOKEYWORDS,                  /* [1074] Keywords are not allowed here! */
	ERR_NOCONSTANTS,                 /* [1075] Constants are not allowed here! */
	ERR_SEEK,                        /* [1076] Invalid seek position specified! */
	ERR_CSTDOUBLEDEF,                /* [1077] Constant #%s was already declared! */
	ERR_NOLAYERS,                    /* [1078] This function requires enabled layers! */
	ERR_LAYERSUPPORT,                /* [1079] This layer is not supported by GetBrushLink()! */
	ERR_UNKNOWNATTR,                 /* [1080] Unknown attribute specified! */
	ERR_LAYERRANGE,                  /* [1081] Specified layer is out of range! */
	ERR_SELECTBRUSH,                 /* [1082] This command cannot be used when SelectBrush() is active! */
	ERR_POINTERFORMAT,               /* [1083] Pointer image must be in 4 colors and not wider than 16 pixels! */
	ERR_CREATEDIR,                   /* [1084] Error creating directory %s ! */
	ERR_DISPLAYSIZE,                 /* [1085] Unable to change display size to %s ! */
	ERR_DISPLAYDESKTOP,              /* [1086] You cannot specify an initial BGPic together with DISPLAYDESKTOP! */
	ERR_GUIGFX,                      /* [1087] Cannot open guigfx.library version 20! Make sure that you have at least version 20 installed! */
	ERR_RENDER,                      /* [1088] Cannot open render.library version 30! Make sure that you have at least version 30 installed! */
	
	/* === new in Hollywood 1.9 === */	
	ERR_ZERODIVISION,                /* [1089] Division by zero! */
	ERR_WARPOS,                      /* [1090] You need at least WarpUP v5.1 for this program! */
	
	/* === new in Hollywood 2.0 === */	
	ERR_UNKNOWN,                     /* [1091] Unknown error code! */
	ERR_STRINGCST,                   /* [1092] You cannot specify string constants here! */
	ERR_LABINFUNC,                   /* [1093] Labels are not allowed in functions! */
	ERR_ANIMFRAME,                   /* [1094] Specified animation frame is out of range! */
	ERR_REPEATWOUNTIL,               /* [1095] REPEAT without UNTIL! */
	ERR_UNTILWOREPEAT,               /* [1096] UNTIL without REPEAT! */
	ERR_FUNCWOENDFUNC,               /* [1097] FUNCTION without ENDFUNCTION! */
	ERR_ENDFUNCWOFUNC,               /* [1098] ENDFUNCTION without FUNCTION! */
	ERR_UNEXPECTEDSYM,               /* [1099] Unexpected symbol! */
	ERR_FUNCARGS,                    /* [1100] Variable, closing bracket or "..." expected! */
	ERR_NOLOOP,                      /* [1101] No loop to break! */
	ERR_TOKENEXPECTED,               /* [1102] "%s" expected! */
	ERR_BRACKETOPEN,                 /* [1103] Opening bracket expected! */
	ERR_BRACKETCLOSE,                /* [1104] Closing bracket expected! */
	ERR_BRACEOPEN,                   /* [1105] Opening brace expected! */
	ERR_BRACECLOSE,                  /* [1106] Closing brace expected! */
	ERR_SQBRACKETOPEN,               /* [1107] Opening square bracket expected! */
	ERR_SQBRACKETCLOSE,              /* [1108] Closing square bracket expected! */
	ERR_NOCOMMA,                     /* [1109] Comma expected! */
	ERR_SYNTAXLEVELS,                /* [1110] Too many syntax levels! */
	ERR_COMPLEXWHILE,                /* [1111] WHILE condition too complex! */
	ERR_NOCHAR,                      /* [1112] ASCII code specification is out of range! */
	ERR_CHRCSTLEN,                   /* [1113] Character constant too long! */
	ERR_CHRCSTEMPTY,                 /* [1114] Empty character constant not allowed! */
	ERR_HEXPOINT,                    /* [1115] Decimal point used in hexadecimal value! */
	ERR_NUMCONCAT,                   /* [1116] A space is necessary between number concatenations! */
	ERR_MAXLOCALS,                   /* [1117] Too many local variables! */
	ERR_MAXUPVALS,                   /* [1118] Too many upvalues! */
	ERR_MAXPARAMS,                   /* [1119] Too many parameters! */
	ERR_CONITEMS,                    /* [1120] Too many items in a constructor! */
	ERR_MAXLINES,                    /* [1121] Too many lines in a chunk! */
	ERR_COMPLEXEXPR,                 /* [1122] Expression or function too complex! */
	ERR_CTRLSTRUCT,                  /* [1123] Control structure too long! */
	ERR_NOCOLON,                     /* [1124] Colon expected! */
	ERR_CASECST,                     /* [1125] Case expression must be constant! */
	ERR_SWCHWOENDSWCH,               /* [1126] SWITCH without ENDSWITCH! */
	ERR_ENDSWCHWOSWCH,               /* [1127] ENDSWITCH without SWITCH! */
	ERR_BLKWOENDBLK,                 /* [1128] BLOCK without ENDBLOCK! */
	ERR_ENDBLKWOBLK,                 /* [1129] ENDBLOCK without BLOCK! */
	ERR_NUMSTRCMP,                   /* [1130] Attempt to compare a number with a string! */
	ERR_CONCAT,                      /* [1131] Wrong data types for concatenation! */
	ERR_TABLEDECLA,                  /* [1132] Table %s not found! */
	ERR_FUNCDECLA,                   /* [1133] Function %s not found! */
	ERR_INTERNAL1,                   /* [1134] Internal limit reached! Error code %s. */
	ERR_STACK,                       /* [1135] Stack overflow! */
	ERR_MEMCODE,                     /* [1136] Code size overflow! */
	ERR_MEMCST,                      /* [1137] Constant table overflow! */
	ERR_NUMEXPECTED,                 /* [1138] Number expected in argument %ld! */
	ERR_STREXPECTED,                 /* [1139] String expected in argument %ld! */
	ERR_TABEXPECTED,                 /* [1140] Table expected in argument %ld! */
	ERR_READONLY,                    /* [1141] File was opened in read-only mode! */
	ERR_WRITEONLY,                   /* [1142] File was opened in write-only mode! */
	ERR_DELETEFILE,                  /* [1143] Could not delete file! */
	ERR_EXAMINE,                     /* [1144] Could not examine %s! */
	ERR_RENAME,                      /* [1145] Could not rename file! */
	ERR_MEMRANGE,                    /* [1146] Specified offset is out of range! */
	ERR_SELECTMASK,                  /* [1147] This command cannot be used when SelectMask() is active! */
	ERR_MODIFYABG,                   /* [1148] Attempt to modify the active background picture! */
	ERR_MODIFYABR,                   /* [1149] Attempt to modify the active brush! */
	ERR_FUNCJMP,                     /* [1150] You cannot use GOTO/GOSUB inside functions! */
	ERR_REVDWORD,                    /* [1151] You cannot use this reserved word here! */
	ERR_LOCKBMAP,                    /* [1152] Could not lock bitmap! */
	ERR_PALSCREEN,                   /* [1153] Hollywood does not run on palette screens! Please switch to a high or true color mode! */
	ERR_NEGCOORDS,                   /* [1154] Negative coordinates are not allowed here! */
	ERR_NOANMLAYER,                  /* [1155] Specified layer is not an anim layer! */
	ERR_BRUSHSIZE,                   /* [1156] Brush size does not match specified arguments! */
	ERR_ENDWITHWOWITH,               /* [1157] ENDWITH without WITH! */
	ERR_WITHWOENDWITH,               /* [1158] WITH without ENDWITH! */
	ERR_FIELDINIT,                   /* [1159] Table field %s was not initialized! */
	ERR_LABMAINBLK,                  /* [1160] Labels are only allowed in the main script block! */
	ERR_NAMEUSED,                    /* [1161] Layer name was already assigned! */
	ERR_LAYERSOFF,                   /* [1162] Layers must be turned off when using this function! */
	ERR_LAYERSON,                    /* [1163] Layers cannot be turned on/off while off-screen rendering is active! */
	ERR_NOLOOPCONT,                  /* [1164] No loop to continue! */
	ERR_LOOPRANGE,                   /* [1165] Loop number is out of range! */
	ERR_INTEXPECTED,                 /* [1166] Integer value expected! */
	ERR_SELECTALPHACHANNEL,          /* [1167] This command cannot be used when SelectAlphaChannel() is active! */
	ERR_PIXELRANGE,                  /* [1168] Specified pixel is out of range! */
	ERR_DATATYPEALPHA,               /* [1169] Your picture.datatype does not support alpha channel! */
	ERR_NOALPHA,                     /* [1170] Image "%s" does not have an alpha channel! */
	ERR_PIXELFORMAT,                 /* [1171] Unknown pixel format detected! Hollywood cannot run on this screen! */
	ERR_NOMASKBRUSH,                 /* [1172] This brush does not have a mask! */
	ERR_FOREVERWOREPEAT,             /* [1173] FOREVER without REPEAT! */
	ERR_FINDBRUSH,                   /* [1174] Could not find brush %ld! */
	ERR_FINDTEXTOBJECT,              /* [1175] Could not find text object %ld! */
	ERR_FINDANIM,                    /* [1176] Could not find anim %ld! */
	ERR_FINDBGPIC,                   /* [1177] Could not find BGPic %ld! */
	ERR_FINDSAMPLE,                  /* [1178] Could not find sample %ld! */
	ERR_FINDFILE,                    /* [1179] Could not find file handle %ld! */
	ERR_FINDMEMBLK,                  /* [1180] Could not find memory block %ld! */
	ERR_FINDTIMER,                   /* [1181] Could not find timer %ld! */
	ERR_FINDMOVE,                    /* [1182] Could not find move queue %ld! */
	ERR_STRORNUM,                    /* [1183] String or number expected in argument %ld! */
	ERR_PERCENTFORMAT,               /* [1184] Invalid percent format in argument %ld! */
	ERR_FUNCEXPECTED,                /* [1185] Function expected in argument %ld! */
	ERR_UNMPARENTHESES,              /* [1186] Unmatched parentheses! */
	ERR_WRONGOPCST,                  /* [1187] This operator cannot be used here! */
	ERR_FINDBUTTON,                  /* [1188] Could not find button %ld! */
	ERR_NUMTABLEARG,                 /* [1189] Number expected in table argument "%s"! */
	ERR_NUMCALLBACK,                 /* [1190] Callback function was expected to return a number! */
	ERR_BGPICBUTTON,                 /* [1191] A BGPic needs to be active while calling button functions! */
	ERR_WRONGHEX,                    /* [1192] Invalid hexadecimal specification! */
	ERR_TOOMANYARGS,                 /* [1193] Too many arguments for this function! */
	ERR_FINDINTERVAL,                /* [1194] Could not find interval function %ld! */
	ERR_FINDTIMEOUT,                 /* [1195] Could not find timeout function %ld! */
	ERR_LOADSOUND,                   /* [1196] Error loading sample to sound card! */
	ERR_STRINGEXPECTED,              /* [1197] String expected! */
	ERR_UNEXPECTEDEOF,               /* [1198] Unexpected end of file! */
	ERR_VMMISMATCH,                  /* [1199] Virtual machine data type mismatch! */
	ERR_BADINTEGER,                  /* [1200] Bad integer in bytecode! */
	ERR_BADUPVALUES,                 /* [1201] Bad upvalues in bytecode! */
	ERR_BADCONSTANT,                 /* [1202] Bad constant type in bytecode! */
	ERR_BADBYTECODE,                 /* [1203] Bad bytecode! */
	ERR_BADSIGNATURE,                /* [1204] Bad bytecode signature! */
	ERR_UNKNUMFMT,                   /* [1205] Unknown number format in bytecode! */
	ERR_INVNEXTKEY,                  /* [1206] Invalid key for next table item! */
	ERR_TABLEOVERFLOW,               /* [1207] Table overflow! */
	ERR_TABLEINDEX,                  /* [1208] Table index is NaN! */
	ERR_APPLETVERSION,               /* [1209] This applet requires at least Hollywood %s! */
	ERR_UNKNOWNSEC,                  /* [1210] Unknown section in applet! */
	ERR_NOAPPLET,                    /* [1211] %s is no Hollywood applet! */
	ERR_PLAYERCOMP,                  /* [1212] Compilation is not possible with HollywoodPlayer! */
	ERR_FILEEXIST,                   /* [1213] File %s does not exist! */
	ERR_MAGICKEY,                    /* [1214] Cannot locate magic key in player file! */
	ERR_FINDCLIPREGION,              /* [1215] Could not find clip region %ld! */
	ERR_FUNCREMOVED,                 /* [1216] This function is not supported any longer! */
	ERR_COORDSRANGE,                 /* [1217] Specified coordinates are out of range! */
	ERR_BADDIMENSIONS,               /* [1218] Width/height values must be greater than 0! */
	ERR_FINDSPRITE,                  /* [1219] Could not find sprite %ld! */
	ERR_SPRITEONSCREEN,              /* [1220] Sprite %ld is not on screen! */
	ERR_PREPROCSYM,                  /* [1221] Unknown preprocessor command @%s! */
	ERR_UNKNOWNTAG,                  /* [1222] Unknown tag "%s"! */
	ERR_MASKNALPHA,                  /* [1223] Mask and alpha channel are mutually exclusive! */
	ERR_NOSPRITES,                   /* [1224] Please remove all sprites first! */
	ERR_WRONGCLIPREG,                /* [1225] Clip region does not fit into the output device's dimensions! */
	ERR_NOCLIPREG,                   /* [1226] Please remove clip region before enabling layers! */
	ERR_MODIFYSPRITE,                /* [1227] Cannot modify a sprite that is on screen! */
	ERR_MODIFYSPRITE2,               /* [1228] Cannot modify a linked sprite! */
	ERR_ENDDOUBLEBUFFER,             /* [1229] Please end double buffering first! */
	ERR_DBTRANSWIN,                  /* [1230] Double buffering is currently not supported for transparent displays! */
	ERR_FINDMUSIC,                   /* [1231] Could not find music %ld! */
	ERR_MUSNOTPLYNG,                 /* [1232] Music %ld is not currently playing! */
	ERR_SEEKRANGE,                   /* [1233] Specified seek position is out of range! */
	ERR_MIXMUSMOD,                   /* [1234] Music and tracker modules cannot be played at the same time! */
	ERR_UNKNOWNMUSFMT,               /* [1235] Unknown music format! */
	ERR_MUSFMTSUPPORT,               /* [1236] Music format does not support this function! */
	ERR_TABLEORNIL,                  /* [1237] Table or Nil expected! */
	ERR_PROTMETATABLE,               /* [1238] Cannot change a protected metatable! */
	ERR_ERRORCALLED,                 /* [1239] (for internal use) */
	ERR_ADDTASK,                     /* [1240] Error adding task to the system! */
	ERR_TASKSETUP,                   /* [1241] Error setting up task! (%s) */
	ERR_READRANGE,                   /* [1242] Cannot read beyond end of file! */
	ERR_BACKFILL,                    /* [1243] Wrong backfill configuration! */
	ERR_NODOUBLEBUFFER,              /* [1244] Double buffering mode is not currently active! */
	ERR_STRTOOSHORT,                 /* [1245] Specified length exceeds string length! */
	ERR_CACHEERROR,                  /* [1246] An error occurred while processing the gfx cache! */
	ERR_STRTABLEARG,                 /* [1247] String expected in table argument "%s"! */
	ERR_APPLET,                      /* [1248] No applet filename specified! */
	ERR_KEYFILE,                     /* [1249] Keyfile error! */
	
	/* === new in Hollywood 2.5 === */
	ERR_NOTADIR,                     /* [1250] %s is not a directory! */
	ERR_UNKTEXTFMT,                  /* [1251] Text format tag after square bracket not recognized! */
	ERR_TEXTSYNTAX,                  /* [1252] Syntax error in text format specification! */
	ERR_TEXTARG,                     /* [1253] Not enough arguments to this text format tag! */
	ERR_DEFFONT,                     /* [1254] Error opening default font! */
	ERR_ANTIALIAS,                   /* [1255] This font type does not support anti-aliased output! */
	ERR_CREATEPORT,                  /* [1256] Could not create message port! */
	ERR_NOREXX,                      /* [1257] ARexx server is not running! */
	ERR_REXXERR,                     /* [1258] Rexx interpreter returned an error! (%s) */
	ERR_STRCALLBACK,                 /* [1259] Callback function was expected to return a string! */
	ERR_PORTNOTAVAIL,                /* [1260] There is already a port with the name %s! */
	ERR_BAD8SVX,                     /* [1261] Bad data in IFF 8SVX or IFF 16SV file! */
	ERR_CMPUNSUPPORTED,              /* [1262] This sound file uses an unsupported compression format! */
	ERR_BADWAVE,                     /* [1263] Bad data in RIFF WAVE file! */
	ERR_MUSNOTPAUSED,                /* [1264] This music is not in pause state! */
	ERR_CONFIG2,                     /* [1265] (for internal use) */
	ERR_EXETYPE,                     /* [1266] Unknown executable type specified! */
	ERR_OPENAUDIO,                   /* [1267] Cannot open audio device! */
	ERR_DATATYPESAVE,                /* [1268] Cannot open specified datatype for saving! */
	ERR_DATATYPESAVE2,               /* [1269] Datatype used for saving returned an error code! */
	ERR_LOADFRAME,                   /* [1270] Error loading animation frame! */
	ERR_LAYERSUPPORT2,               /* [1271] This function cannot be used with layers enabled! */
	ERR_SHORTIF,                     /* [1272] Short IF statement must be on a single line! */
	ERR_SYSTOOOLD,                   /* [1273] Your Hollywood.sys version is too old! */
	ERR_KEYNOTFOUND,                 /* [1274] Key "%s" not found in system base! */
	ERR_FINDPORT,                    /* [1275] Port "%s" could not be found! */
	
	/* === new in Hollywood 3.0 === */		
	ERR_TOOSMALL2,                   /* [1276] The active screen is not large enough to hold a %s display! */
	ERR_SAVEPNG,                     /* [1277] Error saving PNG picture! */
	ERR_NOTIGER,                     /* [1278] Hollywood requires at least version 10.4 (Tiger) of Mac OS! */
	ERR_STREAMASSAMPLE,              /* [1279] Cannot load audio stream as a sample! */
	ERR_AUDIOCONVERTER,              /* [1280] Error creating an audio converter for this format! */
	ERR_RENDERCALLBACK,              /* [1281] Error installing render callback on mixer bus! */
	ERR_SETFILEATTR,                 /* [1282] Error setting file attributes! */
	ERR_SETFILEDATE,                 /* [1283] Error setting file date! */
	ERR_SETFILECOMMENT,              /* [1284] Error setting file comment! */
	ERR_INVALIDDATE,                 /* [1285] Invalid date format specification! */
	ERR_LOCK2,                       /* [1286] Error locking %s! */
	ERR_THREAD,                      /* [1287] Error setting up thread! */
	ERR_UNSUPPORTEDFEAT,             /* [1288] This feature is currently not supported on this platform! */
	ERR_NOCHANNEL,                   /* [1289] Could not allocate audio channel for this sound! */
	ERR_CREATEEVENT,                 /* [1290] Error creating unnamed event object! */
	ERR_DSOUNDNOTIFY,                /* [1291] Error obtaining sound notification interface! */
	ERR_DSOUNDNOTIPOS,               /* [1292] Error setting sound buffer notification positions! */
	ERR_DSOUNDPLAY,                  /* [1293] Error starting sound buffer playback! */
	ERR_AFILEPROP,                   /* [1294] Error getting audio file properties! */
	ERR_DIRECTSHOW,                  /* [1295] Error setting up DirectShow environment! (#%ld) */
	ERR_REGCLASS,                    /* [1296] Error registering window class! */
	ERR_TIMER,                       /* [1297] Error setting up timer function! */
	ERR_SEMAPHORE,                   /* [1298] Error allocating semaphore object! */
	ERR_8OR16BITONLY,                /* [1299] Hollywood currently only supports 8 or 16 bit sounds! */
	ERR_DISPMINIMIZED,               /* [1300] This function cannot be used with a minimized display! */
	ERR_COMMODITY,                   /* [1301] Error creating commodity object! */
	ERR_MSGPORT,                     /* [1302] Error setting up message port! */
	
	/* === new in Hollywood 3.1 === */	
	ERR_TEXTCONVERT,                 /* [1303] Error converting text to Unicode! */
	ERR_ATSUI,                       /* [1304] Error in text operation (ATSUI error)! */
	ERR_LFSYNTAX,                    /* [1305] Syntax error in link file database! */
	
	/* === new in Hollywood 4.0 === */		
	ERR_ZLIBIO,                      /* [1306] A zlib IO error occurred! */
	ERR_ZLIBSTREAM,                  /* [1307] A zlib stream error occurred! */
	ERR_ZLIBVERSION,                 /* [1308] Invalid zlib version detected! */
	ERR_ZLIBDATA,                    /* [1309] Invalid or incomplete deflate data (zlib)! */
	ERR_PAKFORMAT,                   /* [1310] Unknown compression format! */
	ERR_NOTXTLAYER,                  /* [1311] Specified layer is not a text layer! */
	ERR_DDAUTOSCALE,                 /* [1312] Autoscale cannot be used together with DisplayDesktop! */
	ERR_NODISLAYERS,                 /* [1313] Layers cannot be disabled when the layer scaling engine is used! */
	ERR_LOCKEDOBJ,                   /* [1314] Cannot modify object while it is locked! */
	ERR_WRITEJPEG,                   /* [1315] Error writing JPEG image! */
	ERR_DDRECVIDEO,                  /* [1316] Scripts using DisplayDesktop cannot be recorded! */
	ERR_WRONGCMDRECVIDEO,            /* [1317] This command cannot be used while in video recording mode! */
	ERR_FINDDIR,                     /* [1318] Could not find directory handle %ld! */
	ERR_MUSNOTPLYNG2,                /* [1319] Music is not currently playing! */
	ERR_FINDPOINTER,                 /* [1320] Could not find pointer image %ld! */
	ERR_POINTERIMG,                  /* [1321] Error creating pointer from image! */
	ERR_READFUNC,                    /* [1322] Cannot find Hollywood function at this offset! */
	ERR_BADBASE64,                   /* [1323] Invalid Base64 encoding! */
	ERR_NOHWFUNC,                    /* [1324] Specified function is not a user function! */
	ERR_SPRITEONSCREEN2,             /* [1325] Sprite is not on screen! */
	ERR_FINDASYNCDRAW,               /* [1326] Could not find async draw function %ld! */
	ERR_FREECURPOINTER,              /* [1327] Cannot free currently active pointer! */
	ERR_READTABLE,                   /* [1328] Cannot find Hollywood table at this offset! */
	ERR_LAYERSWITCH,                 /* [1329] Cannot switch layer mode while async draw is active! */
	ERR_VIDEOSTRATEGY,               /* [1330] Unknown video strategy specified! */
	ERR_WRONGVSTRATEGY,              /* [1331] Invalid video strategy configuration! */
	
	/* === new in Hollywood 4.5 === */	
	ERR_FINDFONT,                    /* [1332] Cannot find font %s on this system! */
	ERR_LINKFONT,                    /* [1333] Font %s cannot be linked because it is of a wrong type! */
	ERR_FINDFONT2,                   /* [1334] Could not find font %ld! */
	ERR_FONTPATH,                    /* [1335] Font specification must not be a file! */
	ERR_FONTFORMAT,                  /* [1336] Font is in an unsupported format! */
	ERR_NOCOORDCST,                  /* [1337] You cannot use coordinate constants here! */
	ERR_ANIMDISK,                    /* [1338] This function cannot be used with disk-based animations! */
	ERR_SELECTANIM,                  /* [1339] This command cannot be used when SelectAnim() is active! */
	ERR_MODIFYAANIM,                 /* [1340] Attempt to modify the active anim! */
	ERR_FINDANIMSTREAM,              /* [1341] Could not find anim stream %ld! */
	ERR_NEEDMORPHOS2,                /* [1342] This feature requires at least MorphOS 2.0! */
	ERR_SMODEALPHA,                  /* [1343] Screen doesn't support alpha transparent windows! */
	ERR_FINDDISPLAY,                 /* [1344] Could not find display %ld! */
	ERR_MULTIBGPIC,                  /* [1345] Cannot use the a single BGPic for multiple displays! */
	ERR_FREEADISPLAY,                /* [1346] Cannot free the active display! */
	ERR_CLOSEDDISPLAY,               /* [1347] Cannot use this function while display is closed! */
	ERR_ADDAPPICON,                  /* [1348] Error adding app icon to Workbench! */
	ERR_SCREENSIZE,                  /* [1349] Screen size %s not supported by current monitor settings! */
	ERR_DIFFDEPTH,                   /* [1350] Cannot switch display mode because of different color resolution! */
	ERR_VIDRECMULTI,                 /* [1351] Cannot use multiple displays while in video recording mode! */
	ERR_VIDRECTRANS,                 /* [1352] Cannot use transparent displays while in video recording mode! */
	ERR_NEEDOS41,                    /* [1353] This feature requires at least AmigaOS 4.1! */
	ERR_SYSIMAGE,                    /* [1354] Error obtaining system image! */
	ERR_SYSBUTTON,                   /* [1355] Error creating system button! */
	ERR_OPENANIM2,                   /* [1356] Animation file "%s" is in an unknown/unsupported format! */
	ERR_OPENSOUND2,                  /* [1357] Sample file "%s" is in an unknown/unsupported format! */
	ERR_LOADPICTURE2,                /* [1358] Image file "%s" is in an unknown/unsupported format! */
	ERR_SIGNAL,                      /* [1359] Error allocating signal! */
	ERR_ADDAPPWIN,                   /* [1360] Error adding app window to Workbench! */
	ERR_CLIPFORMAT,                  /* [1361] Unknown data format in clipboard! */
	ERR_SORTFUNC,                    /* [1362] Invalid order function for sorting! */
	ERR_INISYNTAX,                   /* [1363] Syntax error in configuration file! */
	ERR_CLIPOPEN,                    /* [1364] Failed to open clipboard! */
	ERR_CLIPREAD,                    /* [1365] Error reading from clipboard! */
	ERR_SCALEBGPIC,                  /* [1366] Cannot change size of a BGPic that is selected into a display! */
	ERR_SELECTBGPIC,                 /* [1367] You need to select the BGPic's display before modifying the BGPic! */
	ERR_CLIPWRITE,                   /* [1368] Error writing to clipboard! */
	ERR_FINDLAYER,                   /* [1369] Cannot find layer "%s" in current BGPic! */
	ERR_INVINSERT,                   /* [1370] Invalid insert position specified! */
	ERR_ALREADYASYNC,                /* [1371] Specified layer already has an async draw object attached! */
	ERR_REMADLAYER,                  /* [1372] Cannot remove layer while it is used by an async draw object! */
	ERR_NAMETOOLONG,                 /* [1373] Specified name is too long! */
	ERR_GROUPNAMEUSED,               /* [1374] Specified group name already assigned to a layer! */
	ERR_REGISTRYREAD,                /* [1375] Error reading from registry key %s! */
	ERR_REGISTRYWRITE,               /* [1376] Error writing to registry key %s! */
	ERR_SELECTBGPIC2,                /* [1377] Cannot modify the graphics of a BGPic associated with a display! */
	ERR_MODIFYABGPIC,                /* [1378] Attempt to modify the BGPic currently selected as output device! */
	ERR_ADFWRONGDISP,                /* [1379] Asynchronous drawing object is not associated with current display! */
	ERR_ADFFREEDISP,                 /* [1380] Cannot free display before associated async draw objects have been freed! */
	ERR_SPRITELINK,                  /* [1381] Cannot create sprite link from sprite link! */
	ERR_WRONGSPRITESIZE,             /* [1382] Specified sprites must have the same dimensions! */
	
	/* === new in Hollywood 4.6 === */	
	ERR_TRANSBRUSH,                  /* [1383] Cannot trim brush because it is fully transparent! */
	ERR_DINPUT,                      /* [1384] Error opening DirectInput! */
	ERR_JOYSTICK,                    /* [1385] Cannot acquire joystick! */
	
	/* === new in Hollywood 4.7 === */	
	ERR_FT2,                         /* [1386] Error initializing freetype2! */
	ERR_ICONDIMS,                    /* [1387] Specified image does not match required icon dimensions (%s)! */
	ERR_BRUSHTYPE,                   /* [1388] This operation is not supported by the specified brush type! */
	ERR_TFVBRUSH,                    /* [1389] Cannot insert a transformed vector brush as a layer! Use draw tags instead of transforming the brush directly! */
	ERR_BGPICTYPE,                   /* [1390] This operation is not supported by the specified BGPic type! */
	ERR_TFVBRUSHBGPIC,               /* [1391] Cannot convert a transformed vector brush into a BGPic! */
	ERR_TFVBGPICBRUSH,               /* [1392] Cannot convert a transformed vector BGPic into a brush! */
	ERR_FINDPATH,                    /* [1393] Could not find path %ld! */
	ERR_EMPTYPATH,                   /* [1394] Cannot draw empty path! */
	ERR_VFONTTYPE,                   /* [1395] You must use the inbuilt font engine for vector text! */
	ERR_VFONT,                       /* [1396] Error setting up vector font! */
	ERR_CREATESHORTCUT,              /* [1397] Error creating shortcut! */
	ERR_NOACCESS,                    /* [1398] Access denied! */
	ERR_BADPLATFORM,                 /* [1399] Compiling for architecture "%s" not supported by this version! */
	ERR_NEWHWPLUGIN,                 /* [1400] This plugin requires at least Hollywood %s! */
	ERR_PLUGINVER,                   /* [1401] Version %s is required at minimum! */
	ERR_PLUGINARCH,                  /* [1402] Plugin is incompatible with current platform! (%s) */
	ERR_IMAGEERROR,                  /* [1403] Error in image data in file %s! */
	ERR_RENDERADLAYER,               /* [1404] Cannot render layer because it is attached to async draw object! */
	ERR_NOJOYATPORT,                 /* [1405] No joystick found at specified game port! */
	
	/* === new in Hollywood 4.71 === */	
	ERR_DEMO,                        /* [1406] This feature is not available in the demo version of Hollywood! */
	ERR_DEMO2,                       /* [1407] Demo version script size is limited to 800 lines and/or 32 kilobyte! */
	ERR_DEMO3,                       /* [1408] This demo version has expired! Please buy the full version! */
	
	/* === new in Hollywood 5.0 === */	
	ERR_FINDCLIENT,                  /* [1409] Could not find connection %ld! */
	ERR_SOCKET,                      /* [1410] The following network error occurred: %s */
	ERR_OPENSOCKET,                  /* [1411] Could not initialize base socket interface! */
	ERR_FINDSERVER,                  /* [1412] Could not find server %ld! */
	ERR_SOCKOPT,                     /* [1413] Error setting socket options! */
	ERR_PEERNAME,                    /* [1414] Error obtaining peer name! */
	ERR_HOSTNAME,                    /* [1415] Error obtaining host name! */
	ERR_UNKPROTOCOL,                 /* [1416] Unknown protocol in URL! */
	ERR_BADURL,                      /* [1417] Invalid URL specified! */
	ERR_HTTPERROR,                   /* [1418] HTTP error %ld occurred! */
	ERR_HTTPTE,                      /* [1419] Unsupported HTTP transfer mode! */
	ERR_SENDDATA,                    /* [1420] An error occurred during data send! */
	ERR_FTPERROR,                    /* [1421] FTP error %ld occurred! */
	ERR_RECVTIMEOUT,                 /* [1422] Receive timeout reached! */
	ERR_RECVCLOSED,                  /* [1423] Remote server has closed the connection! */
	ERR_RECVUNKNOWN,                 /* [1424] Unknown error occurred during data receive! */
	ERR_FILENOTFOUND,                /* [1425] File %s not found on this server! */
	ERR_FTPAUTH,                     /* [1426] Access denied for specified user/password! */
	ERR_UPLOADFORBIDDEN,             /* [1427] No permission to upload file to %s! */
	ERR_SOCKNAME,                    /* [1428] Error obtaining socket name! */
	ERR_FINDUDPOBJECT,               /* [1429] Could not find UDP object %ld! */
	ERR_BADIP,                       /* [1430] Invalid IP specified! */
	ERR_XDISPLAY,                    /* [1431] Error opening connection to X server! */
	ERR_CREATEGC,                    /* [1432] Error creating graphics context! */
	ERR_PIPE,                        /* [1433] Error creating pipe! */
	ERR_GTK,                         /* [1434] Error opening GTK! */
	ERR_NEEDCOMPOSITE,               /* [1435] Compositing must be enabled for displays with alpha transparency! */
	ERR_NOARGBVISUAL,                /* [1436] Error obtaining a visual info that can handle ARGB graphics! */
	ERR_XFIXES,                      /* [1437] The Xfixes extension is required for this feature! */
	ERR_XCURSOR,                     /* [1438] The Xcursor extension is required for this feature! */
	ERR_ALSAPCM,                     /* [1439] Error configuring ALSA PCM output stream! (#%ld) */
	ERR_SETENV,                      /* [1440] Error setting environment variable! */
	ERR_UNSETENV,                    /* [1441] Error removing environment variable! */
	ERR_XF86VIDMODEEXT,              /* [1442] Screen mode switching requires the XFree86-VidModeExtension! */
	ERR_NODISPMODES,                 /* [1443] No display modes found! */
	ERR_UNKNOWNFILTER,               /* [1444] Filter "%s" not recognized! */
	ERR_NOFILTERNAME,                /* [1445] Missing filter name in table field %s! */
	ERR_TABEXPECTED2,                /* [1446] Subtable expected in table "%s"! */
	ERR_SMPRANGE,                    /* [1447] Specified sample value is out of range! */
	ERR_NOTENOUGHPIXELS,             /* [1448] Table does not contain enough pixels for specified size! */
	ERR_FINDVIDEO,                   /* [1449] Could not find video %ld! */
	ERR_LOADVIDEO,                   /* [1450] File "%s" not recognized as a video stream! */
	ERR_VIDNOTPLAYING,               /* [1451] Cannot pause video because it is not playing! */
	ERR_VIDNOTPAUSED,                /* [1452] Cannot resume video because it is not paused! */
	ERR_COLORSPACE,                  /* [1453] Error obtaining colorspace! */
	ERR_QUICKTIME,                   /* [1454] This function requires QuickTime to be installed! */
	ERR_VIDATTACHED,                 /* [1455] This functionality is not available while videos are attached to the display! */
	ERR_FGRABVIDSTATE,               /* [1456] Cannot grab frame while video is playing or paused! */
	ERR_VIDEOFRAME,                  /* [1457] Specified video frame is out of range! */
	ERR_VIDEOTRANS,                  /* [1458] Videos cannot be played on top of transparent BGPics! */
	ERR_LOADPLUGIN,                  /* [1459] Error loading plugin "%s"! */
	ERR_VECGFXPLUGIN,                /* [1460] This functionality requires a vectorgraphics plugin to be installed! */
	ERR_INVCAPIDX,                   /* [1461] Invalid capture index! */
	ERR_INVPATCAP,                   /* [1462] Invalid pattern capture! */
	ERR_MALFORMPAT1,                 /* [1463] Malformed pattern! (ends with "%%") */
	ERR_MALFORMPAT2,                 /* [1464] Malformed pattern! (missing "]") */
	ERR_UNBALANCEDPAT,               /* [1465] Unbalanced pattern! */
	ERR_TOOMANYCAPTURES,             /* [1466] Too many captures! */
	ERR_MISSINGOPBRACK,              /* [1467] Missing "[" after "%%f" in pattern! */
	ERR_UNFINISHEDCAPTURE,           /* [1468] Unfinished capture! */
	ERR_TFIMAGE,                     /* [1469] Error transforming image! */
	ERR_DRAWPATH,                    /* [1470] Error drawing path! */
	ERR_MOBILE,                      /* [1471] This command is not available in the mobile version of Hollywood! */
	ERR_DDMOBILE,                    /* [1472] Scripts using DisplayDesktop not supported on mobile devices! */
	ERR_MULDISMOBILE,                /* [1473] Multiple displays not supported in the mobile version of Hollywood! */
	ERR_TRANSBGMOBILE,               /* [1474] Transparent BGPics not supported in the mobile version of Hollywood! */
	ERR_MODIFYPSMP,                  /* [1475] Cannot modify a sample that is currently playing! */
	ERR_TABCALLBACK,                 /* [1476] Callback was expected to return a table! */
	ERR_BADCALLBACKRET,              /* [1477] Invalid callback return value! */
	ERR_NOCALLBACK,                  /* [1478] This command must not be called from a callback function! */
	ERR_LOWFREQ,                     /* [1479] Specified pitch value is too low! */
	ERR_FINDLAYERDATA,               /* [1480] Data item "%s" not found in specified layer! */
	ERR_NODIRPATTERN,                /* [1481] Filter patterns can only be used on directories! */
	ERR_SEEKFORMAT,                  /* [1482] Source file format does not support seeking! */
	ERR_PLUGINTYPE,                  /* [1483] Plugin type not recognized! (%s) */
	ERR_NOMUSICCB,                   /* [1484] This command must only be called while in a music callback! */
	ERR_NOFMBHANDLER,                /* [1485] You have to install a "FillMusicBuffer" event handler first! */
	ERR_UNKNOWNIMGOUT,               /* [1486] Unknown image format specified! */
	ERR_SAVEIMAGE,                   /* [1487] Error saving image! */
	ERR_UNKNOWNANMOUT,               /* [1488] Unknown anim format specified! */
	ERR_SAVEANIM,                    /* [1489] Error saving anim! */
	ERR_UNKNOWNSMPOUT,               /* [1490] Unknown sample format specified! */
	ERR_SAVESAMPLE,                  /* [1491] Error saving sample! */
	ERR_UDEXPECTED,                  /* [1492] Userdata expected in argument %ld! */
	ERR_ASSERTFAILED,                /* [1493] Assertion failed! */
	ERR_REQUIREPLUGIN,               /* [1494] This program requires %s! */
	ERR_NOABSPATH,                   /* [1495] Absolute path specifications are not allowed here! */
	ERR_FINDOBJECTDATA,              /* [1496] Data item "%s" not found in specified object! */
	ERR_HWBRUSH,                     /* [1497] Hardware brushes cannot be used here! */
	ERR_HWBRUSHFUNC,                 /* [1498] This functionality is currently not supported for hardware brushes! */
	
	/* === new in Hollywood 5.1 === */	
	ERR_SAVERALPHA,                  /* [1499] Format saver does not support alpha channel ! */
	ERR_VIDPAUSED,                   /* [1500] Video is paused. Use ResumeVideo() to resume playback! */
	ERR_VIDPLAYING,                  /* [1501] Video is already playing! */
	ERR_PERCENTFORMATSTR,            /* [1502] Invalid percent format in table argument "%s"! */
	
	/* === new in Hollywood 5.2 === */	
	ERR_SCRPIXFMT,                   /* [1503] Incompatible screen pixel format detected! */
	ERR_SATFREEDISP,                 /* [1504] Cannot free display before attached satellites have been detached! */
	ERR_CREATEICON,                  /* [1505] Error creating icon from image! */
	ERR_GETSHORTCUT,                 /* [1506] Error retrieving full path from shortcut file! */
	ERR_UNKNOWNMIMETYPE,             /* [1507] Unknown MIME type for extension *.%s! */
	ERR_NOMIMEVIEWER,                /* [1508] Cannot find viewer for extension *.%s! */
	
	/* === new in Hollywood 5.3 === */	
	ERR_JAVA,                        /* [1509] Cannot attach thread to Java VM! */
	ERR_FINDACTIVITY,                /* [1510] Cannot find activity "%s"! */
	ERR_BEGINREFRESH,                /* [1511] Cannot call this command while in BeginRefresh() mode! */
	
	/* === new in Hollywood 6.0 === */	
	ERR_DBVIDEOLAYER,                /* [1512] Video object is already in use as a layer on a BGPic! */
	ERR_VIDEOLAYER,                  /* [1513] This functionality is not supported for video layers! */
	ERR_VIDEOLAYERDRV,               /* [1514] Video layers are only supported by Hollywood's platform independent video renderer! */
	ERR_BADLAYERTYPE,                /* [1515] Specified layer type does not support this functionality! */
	ERR_VIDSTOPPED,                  /* [1516] Video is already stopped! */
	ERR_VIDLAYERFUNC,                /* [1517] Use functions from layers library to change attributes of video layers! */ 
        ERR_SETADAPTER,                  /* [1518] Cannot set adapter! */
        ERR_DISPLAYADAPTERSUPPORT,       /* [1519] This functionality is not available with this display adapter! */
        ERR_DLOPEN,                      /* [1520] Cannot load plugin: %s */
        ERR_PLUGINSYMBOL,                /* [1521] Error loading plugin symbol: %s */
        ERR_BITMAP,                      /* [1522] Error allocating bitmap! */
        ERR_SATELLITE,                   /* [1523] This functionality is not available when using display satellites! */
        ERR_READVIDEOPIXELS,             /* [1524] Error reading pixels from hardware bitmap! */
        ERR_HWDBFREEDISP,                /* [1525] Cannot free display while hardware double buffering is active! */
        ERR_HWBMCLOSEDISP,               /* [1526] Cannot allocate hardware bitmap while display has not been realized! */
        ERR_INCOMPATBRUSH,               /* [1527] Hardware brush is incompatible with the current display! */
        ERR_ADDSYSEVENT,                 /* [1528] Error adding system event! */
        ERR_SEEKFILE,                    /* [1529] This file adapter does not support seeking! */
        ERR_CLOSEFILE,                   /* [1530] Error closing file handle! */
        ERR_FINDPLUGIN,                  /* [1531] Cannot find plugin %s! */
        ERR_PLUGINDOUBLET,               /* [1532] Plugin %s has already been loaded! */
        ERR_APPLICATION,                 /* [1533] Error registering application! */
        ERR_NEEDAPPLICATION,             /* [1534] This functionality is only available for system-registered applications! */
        ERR_FINDAPPLICATION,             /* [1535] Cannot find application %s! */
        ERR_SENDMESSAGE,                 /* [1536] Error sending message! */
        ERR_FINDMENU,                    /* [1537] Could not find menu %ld! */
        ERR_MENUCOMPLEXITY,              /* [1538] Menu tree definition is too complex! */
        ERR_CREATEMENU,                  /* [1539] Error creating menu! */
        ERR_VISUALINFO,                  /* [1540] Error obtaining visual info! */
        ERR_SETMENU,                     /* [1541] Error setting menu strip! */
        ERR_MENUATTACHED,                /* [1542] Cannot free menu while it is still attached to a display! */
        ERR_FINDMENUITEM,                /* [1543] Cannot find menu item %s! */
        ERR_NOMENU,                      /* [1544] Specified display does not have a menu attached! */
        ERR_EMPTYMENUTREE,               /* [1545] Empty menu trees are not allowed! */
        ERR_TAGEXPECTED,                 /* [1546] Tag expected! */
        ERR_FULLSCREEN,                  /* [1547] This functionality is not supported in full screen mode! */
        ERR_CREATEDOCKY,                 /* [1548] Error creating application docky! */
        ERR_UPDATEICON,                  /* [1549] Error updating dock icon! */
        ERR_DOUBLEMENU,                  /* [1550] Tree has already been defined for this menu! */
        ERR_CONTEXTMENU,                 /* [1551] Context menus must only contain a single tree! */
        ERR_VECTORBRUSH,                 /* [1552] This functionality is not available for vector brushes! */
        ERR_NOCONTEXTMENU,               /* [1553] Application does not expose a context menu! */
        ERR_ACCELERATOR,                 /* [1554] Error creating accelerator table! */
        ERR_FINDMONITOR,                 /* [1555] Cannot find monitor %ld! */
        ERR_MONITORFULLSCREEN,           /* [1556] Monitor %ld is already in fullscreen mode! */
        ERR_MONITORRANGE,                /* [1557] Specified monitor is out of range! */
        ERR_GETMONITORINFO,              /* [1558] Error obtaining monitor information! */
        ERR_SCREENMODE,                  /* [1559] Cannot find an appropriate screen mode for this display! */
        ERR_NOCOMPRESS,                  /* [1560] The Hollywood Player only supports compressed applets! */
        ERR_GRABSCREEN,                  /* [1561] Error grabbing screen pixels! */
        ERR_ALLOCCHANNEL,                /* [1562] Error allocating audio channel! */	       
        ERR_REQUIRETAGFMT,               /* [1563] Syntax error in tag format! */
        ERR_ALLOCALPHA,                  /* [1564] Error allocating alpha channel! */
        ERR_ALLOCMASK,                   /* [1565] Error allocating mask! */
        ERR_OLDAPPLET,                   /* [1566] This functionality is only available to applets compiled by Hollywood %s or higher! */
        ERR_MUSPAUSED,                   /* [1567] Music is paused. Use ResumeMusic() to resume playback! */
        ERR_MUSPLAYING,                  /* [1568] Music is already playing! */
        ERR_CONSOLEARG,                  /* [1569] Invalid parameter for console argument! */
        ERR_FILESIZE,                    /* [1570] Error determining file size! */
        ERR_STAT,                        /* [1571] Error examining file system object! */
        ERR_REQAUTH,                     /* [1572] This server requires user authentification! */
        ERR_MISSINGFIELD,                /* [1573] Table field \"%s\" must be specified! */
        ERR_NOTRANSPARENCY,              /* [1574] Image \"%s\" does not have a transparent pen! */
        
	/* === new in Hollywood 6.1 === */	        
        ERR_LEGACYPTMOD,                 /* [1575] Legacy audio driver does not support playing multiple Protracker modules at once! */
        ERR_CHANNELRANGE,                /* [1576] Specified audio channel is out of range! */
        ERR_FILEFORMAT,                  /* [1577] File format error! */
        ERR_LINKPLUGIN,                  /* [1578] Error linking plugin %s! */
        ERR_EXECUTE,                     /* [1579] Failed to execute program! */
        ERR_AMIGAGUIDE,                  /* [1580] Error opening AmigaGuide file %s! */
        
	/* === new in Hollywood 7.0 === */	        
        ERR_COMPLEXPATTERN,              /* [1581] Pattern too complex! */
        ERR_ESCREPLACE,                  /* [1582] Invalid use of escape character in replacement string! */
        ERR_INVREPLACE,                  /* [1583] Invalid replacement value! */
        ERR_BADENCODING,                 /* [1584] Encoding not recognized! */
        ERR_INVALIDUTF8,                 /* [1585] Invalid UTF-8 sequence encountered! */
        ERR_DIFFENCODING,                /* [1586] Cannot include applet because it uses a different encoding than the current script! */
        ERR_DBLENCODING,                 /* [1587] Conflicting encodings specified! */
        ERR_INVALIDUTF8ARG,              /* [1588] Invalid UTF-8 string in argument %d! */
        ERR_CORETEXT,                    /* [1589] Error drawing string using Core Text! */
        ERR_COREFOUNDATION,              /* [1590] A Core Foundation allocation error has occurred! */
        ERR_FRAMEGRABBER,                /* [1591] Error grabbing frame from video stream! */
        ERR_FINDSELECTOR,                /* [1592] Cannot find selector %s! */
        ERR_FIRSTPREPROC,                /* [1593] Conditional compile preprocessor commands must be first in line! */
        ERR_ELSEIFAFTERELSE,             /* [1594] ELSEIF after ELSE! */
        ERR_ELSETWICE,                   /* [1595] ELSE used twice! */
        ERR_NOBLOCKBREAK,                /* [1596] No block to break! */
        ERR_NOFALLTHROUGH,               /* [1597] No block to fall through! */
        ERR_TABEXPECTED3,                /* [1598] Table expected! */
        ERR_EMPTYTABLE,                  /* [1599] Table needs to have at least one item! */

	/* === new in Hollywood 7.1 === */	        
        ERR_MOVEFILE,                    /* [1600] Error moving file! */
        ERR_RADIOTOGGLEMENU,             /* [1601] Radio and toggle menu flags cannot be combined! */
        ERR_RANDOMIZE,                   /* [1602] Error generating random number! */
        ERR_TRIALCOMPILE,                /* [1603] Compiling applets or executables isn't supported in the trial version! */
        ERR_TRIALSAVEVID,                /* [1604] Video recording isn't supported in the trial version! */
        ERR_TRIALLIMIT,                  /* [1605] The trial version doesn't support scripts bigger than 16kb! */
        ERR_TRIALINCLUDE,                /* [1606] Including files isn't supported in the trial version! */   
        
	/* === new in Hollywood 8.0 === */
        ERR_VIDEOINIT,                   /* [1607] Error initializing video device! */
        ERR_FINDICON,                    /* [1608] Could not find icon %d! */
        ERR_ICONPARMS,                   /* [1609] Selected image parameters don't match normal image parameters! */
        ERR_ICONSIZE,                    /* [1610] Icon size used twice! */
        ERR_LOADICON,                    /* [1611] Icon file \"%s\" is in an unknown/unsupported format! */
        ERR_ICONSTANDARD,                /* [1612] There can be only one standard icon size! */
        ERR_ICONENTRY,                   /* [1613] Specified icon entry is out of range! */
        ERR_ICONVECTOR,                  /* [1614] Vector brushes must be the only icon entry! */
        ERR_MULTIDISPLAYS,               /* [1615] Hollywood only supports a single display on this platform! */
        ERR_TEXTURE,                     /* [1616] Error creating texture! */
        ERR_SURFACE,                     /* [1617] Error creating surface! */
        ERR_RENDERER,                    /* [1618] Error creating renderer! */
        ERR_FINDSERIAL,                  /* [1619] Could not find serial %d! */
        ERR_INITSERIAL,                  /* [1620] Error initializing serial interface! */
        ERR_OPENSERIAL,                  /* [1621] Error opening serial port %s! */
        ERR_SERIALIO,                    /* [1622] Serial I/O error! */
        ERR_SENDTIMEOUT,                 /* [1623] Send timeout reached! */
        ERR_SENDUNKNOWN,                 /* [1624] Unknown error occurred during data send! */			             
        ERR_PLUGINSUPPORT,               /* [1625] Plugin doesn't support this feature! */
        ERR_REWINDDIR,                   /* [1626] Error rewinding directory! */
        ERR_MONITORDIR,                  /* [1627] Error monitoring directory! */
        ERR_JAVAMETHOD,                  /* [1628] Java method \"%s\" not found! */       
        ERR_NUMBEREXPECTED,              /* [1629] Number expected! */
        
	/* === new in Hollywood 9.0 === */         
        ERR_CHANGEDIR,                   /* [1630] Error changing directory to %s! */
        ERR_FUNCTABLEARG,                /* [1631] Function expected in table argument \"%s\"! */
        ERR_BADYIELD,                    /* [1632] Attempt to yield across metamethod/C-call boundary! */
        ERR_CYIELD,                      /* [1633] Cannot yield a C function! */
        ERR_THREADEXPECTED,              /* [1634] Coroutine expected in argument %d! */
        ERR_YIELD,                       /* [1635] This error is for internal use only. */  
        ERR_DEADRESUME,                  /* [1636] Cannot resume dead coroutine! */
        ERR_NONSUSPENDEDRESUME,          /* [1637] Cannot resume non-suspended coroutine! */
        ERR_FORBIDMODAL,                 /* [1638] This command has been disabled by a plugin! */
        ERR_SERIALIZE,                   /* [1639] Error serializing item! */
        ERR_SERIALIZETYPE,               /* [1640] This data type cannot be serialized! */
        ERR_DESERIALIZE,                 /* [1641] Error deserializing item! */
        ERR_FINDASYNCOBJ,                /* [1642] Could not find async operation %d! */
        ERR_NOPALETTE,                   /* [1643] Image file \"%s\" does not have a palette! */
        ERR_NEEDPALETTEIMAGE,            /* [1644] Image data does not have a palette! */
        ERR_NOPALETTEIMAGE,              /* [1645] This function cannot be used with palette images! */
        ERR_PENRANGE,                    /* [1646] Palette pen is out of range! */
        ERR_DEPTHMISMATCH,               /* [1647] Incompatible pixel color depth! */
        ERR_ALLOCCHUNKY,                 /* [1648] Error allocating palette bitmap! */
        ERR_FINDPALETTE,                 /* [1649] Could not find palette %d! */
        ERR_DEPTHRANGE,                  /* [1650] Specified palette depth is out of range! */
        ERR_BGPICPALETTE,                /* [1651] Current BGPic does not have a palette! */
        ERR_UNKNOWNPALETTE,              /* [1652] Unknown standard palette type specified! */
        ERR_PALETTEFILL,                 /* [1653] Specified fill style cannot be used with palette images! */
        ERR_DISPLAYDESKTOPPAL,           /* [1654] Palettes cannot be used together with a desktop display! */
        ERR_DBPALETTE,                   /* [1655] Hardware double buffers cannot be used in palette mode! */
        ERR_UNKNOWNICNOUT,               /* [1656] Unknown icon format specified! */
        ERR_SAVEICON,                    /* [1657] Error saving icon! */
        ERR_PALETTEMODE,                 /* [1658] This function can only be used in palette mode! */
        ERR_NOPALETTEMODE,               /* [1659] This function cannot be used in palette mode! */
        ERR_NORTG,                       /* [1660] Cannot find CyberGraphX or Picasso96! To use Hollywood without either\nCyberGraphX or Picasso96, you need to install the Plananarama plugin! */
        ERR_GETMENUATTR,                 /* [1661] Error getting menu attributes! */
        ERR_SETMENUATTR,                 /* [1662] Error setting menu attributes! */
        ERR_TRAYICON,                    /* [1663] Error setting tray icon! */
        ERR_FONTPATH2,                   /* [1664] You must use the inbuilt font engine when specifying font files directly! */
        ERR_MEDIAFOUNDATION,             /* [1665] A Media Foundation error has occurred! */
        ERR_GETIFADDRS,                  /* [1666] Error getting interface addresses! */
        ERR_TFVANIM,                     /* [1667] Cannot insert a transformed vector anim as a layer!\nUse draw tags instead of transforming the anim directly! */
        ERR_VECTORANIM,                  /* [1668] This functionality is not available for vector anims! */
        ERR_PLAYVIDEO,                   /* [1669] Error starting video playback! */
        ERR_TEXTCONVERT2,                /* [1670] Error during text conversion! */ 
        
	/* === new in Hollywood 10.0 === */              
        ERR_TFVTEXTOBJ,                  /* [1671] Cannot insert a transformed vector text object as a layer! Use draw tags instead of transforming the text object directly! */
        ERR_GROUPNOTFOUND,               /* [1672] Specified layer group doesn't exist! */
        ERR_MERGEDLAYER,                 /* [1673] This functionality isn't supported for merged layers! */
        ERR_REMMERGEDLAYER,              /* [1674] Cannot remove layer that is part of a merged layer! */
        ERR_ALLOCIMAGE,                  /* [1675] Error allocating image! */
        ERR_ADVANCEDCONSOLE,             /* [1676] This function is only available in advanced console mode! */
        ERR_COLORTERMINAL,               /* [1677] Terminal doesn't support color mode! */
        ERR_CONSOLE,                     /* [1678] A console error has occurred! */
        ERR_FINDCONWIN,                  /* [1679] Could not find console window %d! */
        ERR_CONWIN,                      /* [1680] Error creating console window! */
        ERR_FREEPARENT,                  /* [1681] Attempt to free parent before child! */
        ERR_AMIGAINPUT,                  /* [1682] Error initializing AmigaInput! */      

	ERR_ERRORSEND
};	

#endif
