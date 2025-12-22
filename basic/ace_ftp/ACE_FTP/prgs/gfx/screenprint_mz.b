{*
** ScreenPrint SUB: _ScreenDump(srcX%,srcY%,srcWidth%,srcHeight%)
**
** Author: Michael Zielinski
**
** Based upon screenpr.b, an ACE conversion of the Extras1.3:basicdemos
** screen dump program by Carolyn Scheppner and modified by David Benn. 
** The current version has been further modified using ACE structures and 
** a SUB.
*}

#include <intuition.h>
'{"struct MsgPort"
STRUCT MsgPort
    ' struct NODE
    ADDRESS ln_Succ
    ADDRESS ln_Pred
    BYTE    ln_Type
    BYTE    ln_Pri
    ADDRESS ln_Name
    'endstruct node
    BYTE    mp_Flags
    BYTE    mp_SigBit          ' signal bit number
    ADDRESS mp_SigTask         ' object to be signalled
    STRING  mp_MsgList SIZE 20  ' message linked list
end struct

'  mp_Flags: Port arrival actions (PutMsg)
const PF_ACTION    =   3     '  /* Mask */
const PA_SIGNAL    =   0     '  /* Signal task in mp_SigTask */
const PA_SOFTINT   =   1     '  /* Signal SoftInt in mp_SoftInt/mp_SigTask */
const PA_IGNORE    =   2     '  /* Ignore arrival */
'}
'{"struct IOReuest"
STRUCT IORequest
    STRING  some1  SIZE 8
    BYTE    io_Type      ' +8
    BYTE    io_Priority  ' +9
    STRING  some2  SIZE 4
    ADDRESS io_MsgPort   ' +14
    STRING  some3  SIZE 10
    SHORTINT   io_Command  '+28     /* device command */
    BYTE    io_Flags
    BYTE    io_Error       '        /* error or warning num */
    ADDRESS RastPort    ' +32
    ADDRESS ColorMap
    ADDRESS viewModes
    SHORTINT   srcX
    SHORTINT   srcY
    SHORTINT   srcWidth
    SHORTINT   srcHeight
    LONGINT    destCols
    LONGINT    destRows
    SHORTINT   special
END STRUCT
'}
'{"Sub _ScreenDump"
SUB _ScreenDump(srcX%,srcY%,srcWidth%,srcHeight%)
'{"Library-Definitionen"
LIBRARY "exec.library"
DECLARE FUNCTION AllocSignal%() LIBRARY
DECLARE FUNCTION AllocMem&()    LIBRARY
DECLARE FUNCTION FindTask&()    LIBRARY
DECLARE FUNCTION DoIO&()        LIBRARY
DECLARE FUNCTION OpenDevice&()  LIBRARY
DECLARE FUNCTION CloseDevice()  LIBRARY
DECLARE FUNCTION FreeMem()      LIBRARY
DECLARE FUNCTION FreeSignal()   LIBRARY
DECLARE FUNCTION AddPort()      LIBRARY
DECLARE FUNCTION RemPort()      LIBRARY
'}
DECLARE STRUCT WindowStruct *sWindow
    sWindow   = WINDOW(7)
DECLARE STRUCT ScreenStruct *sScreen
    sScreen   = sWindow->WScreen

    REM Set up parameters for dump command
    IF srcWidth%  = 0 AND srcX%=0 THEN srcWidth%  = sScreen->xWidth
    IF srcHeight% = 0 AND srcY%=0 THEN srcHeight% = sScreen->Height

    REM *** CreatePort ***
    sigBit% =  AllocSignal%(-1)
    ClearPublic& = 65537&
DECLARE STRUCT MsgPort *myPort
    myPort = AllocMem&(40,ClearPublic&)
    IF myPort = 0 THEN
       PRINT "Can't allocate msgPort"
       EXIT SUB
    END IF

    myPort->ln_Type    = 4 'NT_MSGPORT
    myPort->ln_Pri     = 0 'Priority
STRING portName$ SIZE 15
    portName$ = "MyPrtPort"+CHR$(0)
    myPort->ln_Name    = SADD(portName$)
    myPort->mp_Flags   = PA_SIGNAL 'Flags
    myPort->mp_SigBit  = sigBit%
    sigTask& = FindTask&(0)
    myPort->mp_SigTask = sigTask&
    CALL AddPort(myPort)  'Add the port

    REM  *** CreatExtIO ***
DECLARE STRUCT IORequest *myIO
    myIO = AllocMem&(64,ClearPublic&)
    IF myIO = 0  THEN
       PRINT "Can't allocate ioRequest"
       GOTO cleanup3
    END IF
    myIO->io_Type=5 'Type=NT_MESSAGE
    myIO->io_Priority = 0 'Priority 0
    myIO->io_MsgPort= myPort

    REM  *** Open the Printer Device ***
    devName$ = "printer.device"+CHR$(0)
    pError& = OpenDevice&(devName$,0,myIO,0)
    IF pError& <> 0  THEN
       PRINT "Can't open printer"
       GOTO cleanup2
    END IF

    REM  *** Dump the RastPort ***
    myIO->io_Command=11   'Printer command number
    myIO->RastPort=@sScreen->RastPort
    myIO->ColorMap=PEEKL(@sScreen->ViewPort + 4)
    myIO->viewModes=PEEKW(@sScreen->ViewPort + 32)
    myIO->srcX=srcX%
    myIO->srcY=srcY%
    myIO->srcWidth=srcWidth%
    myIO->srcHeight=srcHeight%
    myIO->destCols=0 'destCols& = 0 -> Dump will compute
    myIO->destRows=0 'destRows& = 0 -> Dump will compute
    myIO->special=&H84  'special = FullCol | Aspect

    ioError& = DoIO&(myIO)
    IF ioError& <> 0 THEN
       PRINT "DumpRPort error =" ioError&
       GOTO cleanup1
    END IF

    cleanup1:
       REM  *** Close Printer Device ***
       CALL CloseDevice(myIO)

    cleanup2:
       REM  *** DeleteExtIO ***
       myIO->io_Type=&HFF
       POKEL(myIO + 20), -1
       POKEL(myIO + 24), -1
       CALL FreeMem(myIO,64)

    cleanup3:
       REM  *** DeletePort ***
       CALL RemPort(myPort)
       CALL FreeSignal(sigBit%)
       CALL FreeMem(myPort,40)
END SUB
'}
