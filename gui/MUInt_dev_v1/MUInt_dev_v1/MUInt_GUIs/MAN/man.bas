
{
     SCRIPT FILENAME: MAN           
     DATE           : 03-08-95 
     AUTHOR         : Colin Thompson
     DESCRIPTION    : A quick reference guide for MUInt/DOSRT   
                    : This is an ACE Basic source file. Compile this 
                      and Run the executable.

}


' ================   PRINT THE BUTTON FILE TO RAM: ====================


OPEN "O",#1,"ram:MAN.buttons"
      

PRINT #1,"MUInt Keywords  ;RUN >NIL: SYS:utilities/Amigaguide $MUINTpath/Muint.guide document muin "
PRINT #1,"MUInt Extensions;RUN >NIL: SYS:utilities/Amigaguide $MUINTpath/Muint.guide document exts"
PRINT #1,"rtEZrequest     ;RUN >NIL: SYS:utilities/AmigaGuide $DOSRTPATH/DOSrt.guide DOCUMENT rtez"
PRINT #1,"rtGetString     ;RUN >NIL: SYS:utilities/AmigaGuide $DOSRTPATH/DOSrt.guide DOCUMENT rtgs"
PRINT #1,"rtGetLong       ;RUN >NIL: SYS:utilities/AmigaGuide $DOSRTPATH/DOSrt.guide DOCUMENT rtgl"
PRINT #1,"rtFileRequest   ;RUN >NIL: SYS:utilities/AmigaGuide $DOSRTPATH/DOSrt.guide DOCUMENT rtfl"
PRINT #1,"rtPaletteRequest;RUN >NIL: SYS:utilities/AmigaGuide $DOSRTPATH/DOSrt.guide DOCUMENT rtpr"
PRINT #1,"rtFontRequest   ;RUN >NIL: SYS:utilities/AmigaGuide $DOSRTPATH/DOSrt.guide DOCUMENT rtfo"
PRINT #1,"DRT Extensions  ;RUN >NIL: SYS:utilities/AmigaGuide $DOSRTPATH/DOSrt.guide DOCUMENT dosx"
PRINT #1,"Advice          ;RUN >NIL: SYS:utilities/AmigaGuide $MUINTpath/Advice/advice.guide DOCUMENT ad"
PRINT #1,"Textwin         ;RUN >NIL: SYS:utilities/AmigaGuide $MUINTpath/TextWin/TextWin.guide DOCUMENT ad"
PRINT #1,"QUIT            ; DELETE ram:MAN*#*?"

CLOSE 1 


' ================   PRINT THE COMMAND LINE FILE TO RAM: ================


OPEN "O",#1,"ram:MAN.cl" 


PRINT #1,"BEGIN"
PRINT #1,"TITLE Quick-Reference-Guide-For-MUInt-DOSReqTools" 
PRINT #1,"BUTTONS ram:MAN.buttons"
PRINT #1,"NAME MAN"
PRINT #1,"END"

CLOSE 1


' ================   GENERATE THE MUINT GUI  ================


SYSTEM "MUInt ram:MAN.cl" 

STOP


