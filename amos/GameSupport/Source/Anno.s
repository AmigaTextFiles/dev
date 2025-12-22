
;---------------------------------------------------------------------
;    **   **   **  ***   ***   ****     **    ***  **  ****
;   ****  *** *** ** ** **     ** **   ****  **    ** **  **
;  **  ** ** * ** ** **  ***   *****  **  **  ***  ** **
;  ****** **   ** ** **    **  **  ** ******    ** ** **
;  **  ** **   ** ** ** *  **  **  ** **  ** *  ** ** **  **
;  **  ** **   **  ***   ***   *****  **  **  ***  **  ****
;---------------------------------------------------------------------
; GameSupport extension code
;---------------------------------------------------------------------
; ©1996 by Alastair M. Robinson
;---------------------------------------------------------------------
;

        incdir  "text_include:"
        include "libraries/lowlevel_lib.i"

Version         MACRO
                dc.b    "1.0"
                ENDM
;
;
; This listing explains how to create an extension for AMOSPro.
; The AMOSPro compiler will be compatible with these extension.
;
;       If you have made an extension for AMOS 1.3, just read the
; file called New_In_Pro.Asc to know the difference between the
; extension format. Not many changes, only new equates, and some
; new functions.
;
; >>> What's an extension?
;
; An extension to AMOS is a machine language program that adds new
; instructions to the already huge AMOS instruction set. This system is
; designed to be as powerfull as AMOS itself: the extension includes its
; own token list, its own routines. It can even access some main AMOS
; routines via special macros. It has a total access to the internal AMOS
; data zone, and to the graphic library functions.
;
; To produce your own extension, I suggest you copy and rename this
; file, and remove the used code. This way you will not forgive one line.
; Also keep in mind that you can perfectly call AMOS from within MONAM2,
; and set some ILLEGAL instructions where you want to debug. To flip back to
; MONAM2 display, just press AMIGA-A.
;
; I have designed the extension system so that one only file works with
; both AMOS interpretor and compiler.
;       - The extension is more a compiler library than a one chunk program:
;       it is done so that the compiler can pick one routine here and there
;       to cope with the program it is compiling.
;       - AMOSPro extension loader works a little like the compiler, exept
;       that all instructions are loaded and relocated.
;
; This code was assembled with GENIM2 on a A3000 25 Mhz machine, but a
; A500 can do it very well!
; The assembled program must be ONE CHUNK only, you must not link the
; the symbol table with it. Also be sure that you program is totally
; relocatable (see later) : if not it will add a relocation chunk to
; the output code, and your extension will simply crash AMOS on loading
; (and the compiler too!).

;
; Here we go now!
;
; Here comes the number of the extension in the list of extensions in
; AMOSPro_Interpretor_Config program (minus one).
; This number is used later to reference the extension in internal AMOS
; tables...
;
ExtNb           equ     23-1

; You must include this file, it will decalre everything for you.
                Include "|AMOS_Includes.s"
; A usefull macro to find the address of data in the extension's own
; datazone (see later)...
DLea            MACRO
                move.l  ExtAdr+ExtNb*16(a5),\2
                add.w   #\1-MB,\2
                ENDM

; Another macro to load the base address of the datazone...
DLoad           MACRO
                move.l  ExtAdr+ExtNb*16(a5),\1
                ENDM

******************************************************************
*       AMOSPro TEST EXTENSION
;
; First, a pointer to the token list
Start   dc.l    C_Tk-C_Off
;
; Then, a pointer to the first library function
        dc.l    C_Lib-C_Tk
;
; Then to the title
        dc.l    C_Title-C_Lib
;
; From title to the end of the program
        dc.l    C_End-C_Title
;
; An important flag. Imagine a program does not call your extension, the
; compiler will NOT copy any routine from it in the object program. For
; certain extensions, like MUSIC, COMPACT, it is perfect.
; But for the REQUEST extension, even if it is not called, the first routine
; MUST be called, otherwise AMOS requester will not work!
; So, a value of 0 indicates to copy if needed only,
; A value of -1 forces the copy of the first library routine...
        dc.w    0

******************************************************************
*       Offset to library
;
; This list contains all informations for the compiler
; and AMOS to locate your routines, in a relocatable way.
; You can produce such tables using the MAKE_LABEL.AMOS utility, found
; on this very disc.
; All labels MUST be in order. The size of each routine MUST BE EVEN,
; as the size is divided by two. So be carefull to put an EVEN instruction
; after some text...
; You easily understand that the size of each routine can reach 128K,
; which is largely enough. You can have up to 2000 routines in the list.
; The main AMOS.Lib library has 1100 labels...

C_Off   dc.w (L1-L0)/2,(L2-L1)/2,(L3-L2)/2,(L4-L3)/2,(L5-L4)/2
        dc.w (L6-L5)/2,(L7-L6)/2,(L8-L7)/2,(L9-L8)/2,(L10-L9)/2
        dc.w (L11-L10)/2,(L12-L11)/2,(L13-L12)/2,(L14-L13)/2,(L15-L14)/2
        dc.w (L16-L15)/2,(L17-L16)/2,(L18-L17)/2,(L19-L18)/2,(L20-L19)/2
        dc.w (L21-L20)/2,(L22-L21)/2,(L23-L22)/2,(L24-L23)/2,(L25-L24)/2
        dc.w (L26-L25)/2,(L27-L26)/2,(L28-L27)/2,(L29-L28)/2,(L30-L29)/2

; Do not forget the LAST label!!!

******************************************************************
*       TOKEN TABLE
;
;
;
; This table is the crucial point of the extension! It tells
; everything the tokenisation process needs to know. You have to
; be carefull when writing it!
;
; The format is simple:
;       dc.w    Number of instruction,Number of function
;       dc.b    "instruction nam","e"+$80,"Param list",-1[or -2]
;
;       (1) Number of instruction / function
;               You must state the one that is needed for this token.
;               I suggest you keep the same method of referencing the
;               routines than mine: L_name, this label being defined
;               in the main program. (If you come from a 1.23 extension,
;               changing your program is easy: just add L_ before the
;               name of each routine.
;               A -1 means take no routine is called (example a
;               instruction only will have a -1 in the function space...)
;
;       (2) Instruction name
;               It must be finished by the letter plus $80. Be carefull
;               ARGASM assembler produces bad code if you do "a"+$80,
;               he wants $80+"a"!!!
;               - You can SET A MARK in the token table with a "!" before
;               the name. See later
;               -Using a $80 ALONE as a name definition, will force AMOS
;               to point to the previous "!" mark...
;
;       (3) Param list
;               This list tells AMOS everything about the instruction.
;
;       - First character:
;               The first character defines the TYPE on instruction:
;                       I--> instruction
;                       0--> function that returns a integer
;                       1--> function that returns a float
;                       2--> function that returns a string
;                       V--> reserved variable. In that case, you must
;                               state the type int-float-string
;       - If your instruction does not need parameters, then you stop
;       - Your instruction needs parameters, now comes the param list
;                       Type,TypetType,Type...
;               Type of the parameter (0 1 2)
;               Comma or "t" for TO
;
;       (4) End of instruction
;                       "-1" states the end of the instruction
;                       "-2" tells AMOS that another parameter list
;                            can be accepted. if so, MUST follow the
;                            complete instruction definition as explained
;                            but with another param list.
;       If so, you can use the "!" and $80 facility not to rewrite the
;       full name of the instruction...See SAM LOOP ON instruction for an
;       example...
;
;       Remember that AMOS token list comes first, so names like:
;       PRINTHELLO will never work: AMOS will tokenise PRINT first!
;       Extension token list are explored in order of number...

; The next two lines needs to be unchanged...
C_Tk:   dc.w    1,0
        dc.b    $80,-1

; Now the real tokens...
        dc.w    -1,L_GSReadPort
        dc.b    "gsreadpor","t"+$80,"00",-1
        dc.w    -1,L_GSTimer
        dc.b    "gstime","r"+$80,"0",-1
        dc.w    0

;
; Now come the big part, the library. Every routine is delimited by the
; two labels: L(N) and L(N+1).
; AMOS loads the whole extension, but the compiler works differently:
; The compiler picks each routine in the library and copy it into the
; program, INDIVIDUALLY. It means that you MUST NEVER perform a JMP, a
; BSR or get an address from one library routine to another: the distance
; between them may change!!! Use the special macros instead...
;
; Importants points to follow:
;
;       - Your code must be (pc), TOTALLY relocatable, check carefully your
;       code!
;       - You cannot directly call other library routines from one routine
;       by doing a BSR, but I have defined special macros (in S_CEQU file)
;       to allow you to easily do so. Here is the list of available macros:
;
;       RBsr    L_Routine       does a simple BSR to the routine
;       RBra    L_Routine       as a normal BRA
;       RBeq    L_Routine       as a normal Beq
;       RBne    L_Routine       ...
;       RBcc    L_Routine
;       RBcs    L_Routine
;       RBlt    L_Routine
;       RBge    L_Routine
;       RBls    L_Routine
;       RBhi    L_Routine
;       RBle    L_Routine
;       RBpl    L_Routine
;       RBmi    L_Routine
;
; I remind you that you can only use this to call an library routine
; from ANOTHER routine. You cannot do a call WITHIN a routine, or call
; the number of the routine your caling from...
; The compiler (and AMOSPro extension loading part) will manage to find
; the good addresses in your program from the offset table.
;
; You can also call some main AMOS.Lib routines, to do so, use the
; following macros:
;
;       RJsr    L_Routine
;       Rjmp    L_Routine
;
;
; As you do not have access any more to the small table with jumps to the
; routines within AMOS, here is the concordance of the routines (the numbers
; are just refecrences to the old AMOS 1.23 calling table, and is not of
; any use in AMOS1.3):
;
;
;       RJsr    L_Error
; ~~~~~~~~~~~~~~~~~~~~~
;       Jump to normal error routine. See end of listing
;
;       RJsr    L_ErrorExt
; ~~~~~~~~~~~~~~~~~~~~~~~~
;       Jump to specific error routine. See end of listing.
;
;       RJsr    L_Tests
; ~~~~~~~~~~~~~~~~~~~~~
;       Perform one AMOSPro updating procedure, update screens, sprites,
;       bobs etc. You should use it for wait loops.
;
;       RJsr    L_WaitRout
; ~~~~~~~~~~~~~~~~~~~~~~~~
;       See play instruction.
;
;       RJsr    L_GetEc
; ~~~~~~~~~~~~~~~~~~~~~
;       Get screen address: In: D0.l= number, Out: A0=address
;
;       RJsr    L_Demande
; ~~~~~~~~~~~~~~~~~~~~~~~
;       Ask for string space.
;       D3.l is the length to ask for. Return A0/A1 point to free space.
;       Poke your string there, add the length of it to A0, EVEN the
;       address to the highest multiple of two, and move it into
;       HICHAINE(a5) location...
;
;       RJsr    L_RamChip
; ~~~~~~~~~~~~~~~~~~~~~
;       Ask for PUBLIC|CLEAR|CHIP ram, size D0, return address in D0, nothing
;       changed, Z set according to the success.
;
;       RJsr    L_RamChip2
; ~~~~~~~~~~~~~~~~~~~~~~
;       Same for PUBLIC|CHIP
;
;       RJsr    L_RamFast
; ~~~~~~~~~~~~~~~~~~~~~
;       Same for PUBLIC|CLEAR
;
;       RJsr    L_RamFast2
; ~~~~~~~~~~~~~~~~~~~~~~~~
;       Same for PUBLIC
;
;       RJsr    L_RamFree
; ~~~~~~~~~~~~~~~~~~~~~~~
;       Free memory A1/D0
;
;       RJsr    L_Bnk.OrAdr
; ~~~~~~~~~~~~~~~~~~~~~~~~~
;       Find whether a number is a address or a memory bank number
;       IN:     D0.l= number
;       OUT:    D0/A0= number or start(number)
;
;       RJsr    L_Bnk.GetAdr
; ~~~~~~~~~~~~~~~~~~~~~~~~~~
;       Find the start of a memory bank.
;       IN:     D0.l=   Bank number
;       OUT:    A0=     Bank address
;               D0.w=   Bank flags
;               Z set if bank not defined.
;
;       RJsr    L_Bnk.GetBobs
; ~~~~~~~~~~~~~~~~~~~~~~~~~~~
;       Returns the address of the bob's bank
;       IN:
;       OUT:    Z       Set if not defined
;               A0=     address of bank
;
;       RJsr    L_Bnk.GetIcons
; ~~~~~~~~~~~~~~~~~~~~~~~~~~~~
;       Returns the address of the icons bank
;       IN:
;       OUT:    Z       Set if not defined
;               A0=     address of bank
;
;       RJsr    L_Bnk.Reserve
; ~~~~~~~~~~~~~~~~~~~~~~~~~~~
;       Reserve a memory bank.
;       IN:     D0.l    Number
;               D1      Flags
;               D2      Length
;               A0      Name of the bank (8 bytes)
;       OUT:    Z       Set inf not successfull
;               A0      Address of bank
;       FLAGS:
;               Bnk_BitData             Data bank
;               Bnk_BitChip             Chip bank
;               Example:        Bset    #Bnk_BitData|Bnk_BitChip,d1
;       NOTE:   you should call L_Bnk.Change after reserving/erasing a bank.
;
;       RJsr    L_Bnk.Eff
; ~~~~~~~~~~~~~~~~~~~~~~~
;       Erase one memory bank.
;       IN:     D0.l    Number
;       OUT:
;
;       RJsr    L_Bnk.EffA0
; ~~~~~~~~~~~~~~~~~~~~~~~~~
;       Erase a bank from its address.
;       IN:     A0      Start(bank)
;       OUT:
;
;       RJsr    L_Bnk.EffTemp
; ~~~~~~~~~~~~~~~~~~~~~~~~~~~
;       Erase all temporary banks
;       IN:
;       OUT:
;
;       RJsr    L_Bnk.EffAll
; ~~~~~~~~~~~~~~~~~~~~~~~~~~
;       Erase all banks
;       IN:
;       OUT:
;
;       RJsr    L_Bnk.Change
; ~~~~~~~~~~~~~~~~~~~~~~~~~~
;       Inform the extension, the bob handler that something has changed
;       in the banks. You should use this function after every bank
;       reserve / erase.
;       IN:
;       OUT:
;
;       RJsr    L_Dsk.PathIt
; ~~~~~~~~~~~~~~~~~~~~~~~~~~
;       Add the current AMOS path to a file name.
;       IN:     (Name1(a5)) contains the name, finished by zero
;       OUT:    (Name1(a5)) contains the name with new path
;       Example:
;               move.l  Name1(a5),a0
;               move.l  #"Kiki",(a0)+
;               clr.b   (a0)
;               RJsr    L_Dsk.PathIt
;               ... now I load in the current directory
;
;       RJsr     L_Dsk.FileSelector
; ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
;       Call the file selector.
;       IN:     12(a3)  Path+filter
;               8(a3)   Default name
;               4(a3)   Title 2
;               0(a3)   Title 1
;               All strings must be in AMOS string format:
;                       dc.w    Length
;                       dc.b    "String"
;       OUT:    D0.w    Length of the result. 0 if no selection
;               A0      Address of first character of the result.

;
;       HOW DOES IT WORK?
;
; Having a look at the |CEQU file, you see that I use special codes
; to show the compiler that it has to copy the asked routine and relocate
; the branch. Some remarks:
;       - The size of a Rbsr is 4 bytes, like the normal branch, it does
; not change the program (you can make some jumps over it)
;       - Although I have coded the signal, and put a lot a security,
; a mischance may lead to the compiler thinking there is a RBsr where
; there is nothing than normal data. The result may be disastrous! So if
; you have BIG parts of datas in which you do not make any special calls,
; you can put before it the macro: RDATA. It tells the compiler that
; the following code, up to the end of the library routine (up to the next
; L(N) label) is normal data: the compiler will not check for RBranches...
; Up to now, I have not been forced to do so, but if something goes wrong,
; try that!
;
;

C_Lib
******************************************************************
*               COLD START
*
; The first routine of the library will perform all initialisations in the
; booting of AMOS.
;
; I have put here all the music datazone, and all the interrupt routines.
; I suggest you put all you C-Code here too if you have some...

; ALL the following code, from L0 to L1 will be copied into the compiled
; program (if any music is used in the program) at once. All RBSR, RBRA etc
; will be detected and relocated. AMOSPro extension loader does the same.

L0      movem.l a3-a6,-(sp)
;
; Here I store the address of the extension data zone in the special area
        lea     MyBase(pc),a3
        move.l  a3,ExtAdr+ExtNb*16(a5)
;
; Here, I store the address of the routine called by DEFAULT, or RUN
        lea     MyDefault(pc),a0
        move.l  a0,ExtAdr+ExtNb*16+4(a5)
;
; Here, the address of the END routine,
        lea     MyEnd(pc),a0
        move.l  a0,ExtAdr+ExtNb*16+8(a5)
;
; And now the Bank check routine..
        lea     MyBankCheck(pc),a0
        move.l  a0,ExtAdr+ExtNb*16+12(a5)

; You are not obliged to store something in the above areas, you can leave
; them to zero if no routine is to be called...
;
; In AMOS data zone, stands 8 long words allowing you to simply
; put a patch in the VBL interrupt. The first on is at VBLRout.
; At each VBL, AMOS explores this list, and call all address <> 0
; It stops at the FIRST zero. The music patch is the first routine
; called.

; As you can see, you MUST preserve A3-A6, and return in D0 the
; Number of the extension if everything went allright. If an error has
; occured (no more memory, no file found etc...), return -1 in D0 and
; AMOS will refuse to start.

        DLoad   a3
        lea     LowLevelName-MyBase(a3),a1
        moveq   #0,d0
        move.l  4,a6
        jsr     _LVOOpenLibrary(a6)
        move.l  d0,LowLevelBase-MyBase(a3)

        movem.l (sp)+,a3-a6
        moveq   #ExtNb,d0               * NO ERRORS
        rts

******* SCREEN RESET
; This routine is called each time a DEFAULT occurs...
;
; The next instruction loads the internal datazone address. I could have
; of course done a load MB(pc),a3 as the datazone is in the same
; library chunk.

MyDefault  DLoad   a3

        rts

******* QUIT
; This routine is called when you quit AMOS or when the compiled program
; ends. If you have opend devices, reserved memory you MUST close and
; restore everything to normal.

MyEnd: DLoad   a3
        move.l  4,a6
        move.l  LowLevelBase-MyBase(a3),a1
        jsr     _LVOCloseLibrary(a6)

        rts

******* LOOK FOR MUSIC BANK
; This routine is called after any bank has been loaded, reserved or erased.
; Here, if a music is being played and if the music bank is erased, I MUST
; stop the music, otherwise it might crash the computer. That's why I
; do a checksum on the first bytes of the bank to see if they have changed...
MyBankCheck

        rts

***********************************************************
*
*       INTERRUPT ROUTINES
*
***********************************************************


*********************************************************************
*               MUSIC extension data zone

MyBase:
MyEClock
        dc.l    0,0
LowLevelBase
        dc.l    0
LowLevelName
        dc.b    "lowlevel.library",0
        EVEN
                Rdata

**********************************************************************
; Please leave 1 or two labels free for future extension. You never
; know!
L1

; Now follow all the music routines. Some are just routines called by others,
; some are instructions.
; See how a adress the internal music datazone, by using a base register
; (usually A3) and adding the offset of the data in the datazone...

; >>> How to get the parameters for the instruction?
;
; When an instruction or function is called, you get the parameters
; pushed in A3. Remember that you unpile them in REVERSE order than
; the instruction syntax.
; As you have a entry point for each set of parameters, you know
; how many are pushed...
;       - INTEGER:      move.l  (a3)+,d0
;       - STRING:       move.l  (a3)+,a0
;                       move.w  (a0)+,d0
;               A0---> start of the string.
;               D0---> length of the string
;       - FLOAT:        move.l  (a3)+,d0
;                       fast floatting point format.
;
; IMPORTANT POINT: you MUST unpile the EXACT number of parameters,
; to restore A3 to its original level. If you do not, you will not
; have a immediate error, and AMOS will certainely crash on next
; UNTIL / WEND / ENDIF / NEXT etc...
;
; So, your instruction must:
;       - Unpile the EXACT number of parameters from A3, and exit with
;       A3 at the original level it was before collecting your parameters)
;       - Preserve A4, A5 and A6
; You can use D0-D7/A0-A2 freely...
;
; You can jump to the error routine without thinking about A3 if an error
; occurs in your routine (via a RBra of course). BUT A4, A5 and A6 registers
; MUST be preserved!
;
; You end must end by a RTS.
;
; >>> Functions, how to return the parameter?
;
; To send a function`s parameter back to AMOS, you load it in D3,
; and put its type in D2:
;       moveq   #0,d2   for an integer
;       moveq   #1,d2   for a float
;       moveq   #2,d2   for a string
;

L_GSReadPort    equ     2
L2
        move.l  a6,-(a7)
        move.l  (a3)+,d0
        DLoad   a2
        move.l  LowLevelBase-MyBase(a2),a6
        jsr     _LVOReadJoyPort(a6)
        move.l  d0,d3
        moveq   #0,d2
        move.l  (a7)+,a6
        rts

L_GSTimer equ     3
L3
        move.l  a6,-(a7)
        DLoad   a2
        move.l  LowLevelBase-MyBase(a2),d0
        beq     .error
        move.l  d0,a6
        lea     MyEClock-MyBase(a2),a0
        jsr     _LVOElapsedTime(a6)
        move.l  d0,d3
        moveq   #0,d2
        move.l  (a7)+,a6
        rts

.error
        move.l  (a7)+,a6
        move.l  #0,d0
        Rbra    L_Custom

L4
L5
L6
L7
L8
L9
L10
L11
L12
L13
L14
L15
L16
L17
L18
L19
L20
L21
L22
L23
L24
L25
L26
L27
*********************************************************************
*       ERROR MESSAGES...
;
; You know that the compiler have a -E1 option (with errors) and a
; a -E0 (without errors). To achieve that, the compiler copies one of
; the two next routines, depending on the -E flag. If errors are to be
; copied along with the program, then the next next routine is used. If not,
; then the next one is copied.
; The compiler assumes that the two last routines in the library handles
; the errors: the previous last is WITH errors, the last is WITHOUT. So,
; remember:
;
; THESE ROUTINES MUST BE THE LAST ONES IN THE LIBRARY
;
; The AMOS interpretor always needs errors. So make all your custom errors
; calls point to the L_Custom routine, and everything will work fine...
;
******* "With messages" routine.
; The following routine is the one your program must call to output
; a extension error message. It will be used under interpretor and under
; compiled program with -E1

L_Custom        equ     28
L28     lea     ErrMess(pc),a0
        moveq   #0,d1                   * Can be trapped
        moveq   #ExtNb,d2               * Number of extension
        moveq   #0,d3                   * IMPORTANT!!!
        Rjmp    L_ErrorExt              * Jump to routine...
* Messages...
ErrMess dc.b    "lowlevel.library not available",0                    *0
* IMPORTANT! Always EVEN!
        even

******* "No errors" routine
; If you compile with -E0, the compiler will replace the previous
; routine by this one. This one just sets D3 to -1, and does not
; load messages in A0. Anyway, values in D1 and D2 must be valid.
;
; THIS ROUTINE MUST BE THE LAST ONE IN THE LIBRARY!
;

L29     moveq   #0,d1
        moveq   #ExtNb,d2
        moveq   #-1,d3
        Rjmp    L_ErrorExt

; Do not forget the last label to delimit the last library routine!
L30

; ---------------------------------------------------------------------
; Now the title of the extension, just the string.
;
; TITLE MESSAGE
C_Title dc.b    "AMOSPro GameSupport extension V "
        Version
        dc.b    0,"$VER: "
        Version
        dc.b    0
        Even
;
; Note : magic title!
; ~~~~~~~~~~~~~~~~~~~
; If your extension begins with "MAGIC***", AMOSPro will call the
; address located after the string (even of course!). You can do whatever
; you want to the editor screen (the current at the moment), but
; restore it.
; You also handle the user key press, and the PREVIOUS/NEXT/CANCEL
; selection, buy returning a number in D0:
;       D0=-1   Cancel
;       D0=0    Previous extension
;       D0=1    Next extension
; Example of magic title:
;       C_Title         dc.b    "MAGIC***"
;                       bra     Magic_Title


; END OF THE EXTENSION
C_End   dc.w    0
        even


