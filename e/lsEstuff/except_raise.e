OPT MODULE

MODULE 'diskfont'

EXPORT RAISE "LIB" IF OpenLibrary()=NIL,
             "DEV" IF OpenDevice()<>NIL,
             "ARGS" IF ReadArgs()=NIL,
             "SCR" IF OpenScreen()=NIL,
             "OPEN" IF Open()=NIL,
             "PORT" IF CreateMsgPort()=NIL,
             "SIG" IF AllocSignal()=-1,
             "WIN" IF OpenWindow()=NIL,
             "WIN" IF OpenWindowTagList()=NIL,
             "FPO" IF FindPort()=NIL,
             "EXE" IF SystemTagList()=NIL,
             "FONT" IF OpenFont()=NIL,
             "FONT" IF OpenDiskFont()=NIL


