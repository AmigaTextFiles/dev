DIM button$


// This is a COMAL95 source file. The compiled executable is called MAN.
// This program requires AmigaGuide to be in sys:utilities, and the ENV
// variables DOSRTPATH and MUINTPATH to be present. Run the installer first
// to get the ENV variables set. MUI must be installed.

// Once this program has been run, it is not used again. MUInt does 
// the work.

check'files  // These two PROCedure calls run the entire program
gen'gui

PROC check'files

     IF NOT exists#("env:DOSRTPATH") THEN
          ErrorMessage("DOSReqTools is not installed.\\nPlease read the docs.")
     ENDIF

     IF NOT exists#("env:MUINTPATH") THEN
          ErrorMessage("DOSReqTools is not installed.\\nPlease read the docs.")
     ENDIF
     
     IF NOT exists#("sys:utilities/Amigaguide") THEN
          ErrorMessage("AmigaGuide is not installed.\\nPlease read the docs.")
     ENDIF

     IF NOT exists#("MUI:libs/muimaster.library") THEN
          ErrorMessage("MUI is not installed.\\nPlease read the docs.")
     ENDIF
     
ENDPROC

PROC gen'gui

     RESTORE COMMANDLINE                    // read the command line and buttons
     write'file("ram:MAN.cl","END")         // and write them to ram
     RESTORE BUTTONS
     write'file("ram:MAN.buttons","QUIT")

     PASS "MUInt ram:MAN.cl"                // start up the gui
                     
ENDPROC

PROC write'file(fname$,last$)

     OPEN FILE 6, fname$,WRITE

     REPEAT
          READ button$
          PRINT FILE 6:button$
     UNTIL last$ IN button$

     CLOSE 6
      
ENDPROC

COMMANDLINE:

DATA "BEGIN"
DATA "TITLE \"Quick Reference Guide For MUInt DOSReqTools\"" 
DATA "BUTTONS ram:MAN.buttons"
DATA "NAME    MAN"
DATA "END"

BUTTONS:

DATA "  rtEZrequest   ;RUN >NIL: SYS:utilities/AmigaGuide $DOSRTPATH/DOSrt.guide DOCUMENT rtez"
DATA "  rtGetString   ;RUN >NIL: SYS:utilities/AmigaGuide $DOSRTPATH/DOSrt.guide DOCUMENT rtgs"
DATA "   rtGetLong    ;RUN >NIL: SYS:utilities/AmigaGuide $DOSRTPATH/DOSrt.guide DOCUMENT rtgl"
DATA " rtFileRequest  ;RUN >NIL: SYS:utilities/AmigaGuide $DOSRTPATH/DOSrt.guide DOCUMENT rtfl"
DATA "rtPaletteRequest;RUN >NIL: SYS:utilities/AmigaGuide $DOSRTPATH/DOSrt.guide DOCUMENT rtpr"
DATA " rtFontRequest  ;RUN >NIL: SYS:utilities/AmigaGuide $DOSRTPATH/DOSrt.guide DOCUMENT rtfo"
DATA " DRT Extensions ;RUN >NIL: SYS:utilities/AmigaGuide $DOSRTPATH/DOSrt.guide DOCUMENT dosx"
DATA " MUInt Keywords ;RUN >NIL: SYS:utilities/Amigaguide $MUINTpath/Muint.guide DOCUMENT muin "
DATA "MUInt Extensions;RUN >NIL: SYS:utilities/Amigaguide $MUINTpath/Muint.guide DOCUMENT exts"
DATA "     Advice     ;RUN >NIL: SYS:utilities/AmigaGuide $MUINTpath/Advice/advice.guide DOCUMENT ad"
DATA "    Textwin     ;RUN >NIL: SYS:utilities/AmigaGuide $MUINTpath/TextWin/TextWin.guide DOCUMENT ad"
DATA "      QUIT      ;DELETE >nil: ram:MAN*#*?"


PROC ErrorMessage(text$)
     DIM dummy$
     dummy$:="rtEZrequest TITLE \"MAN Error Message\" BODY "+"\""+text$+"\""
     PASS dummy$
     STOP
ENDPROC

FUNC exists#(fname$)
     DIM test$
     test$:= "list >ram:MAN.dummy "+fname$
     PASS test$
     IF STATUS THEN
          RETURN FALSE
     ELSE
          RETURN TRUE
     ENDIF
ENDFUNC


