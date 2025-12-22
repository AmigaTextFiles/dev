/* application Class $VER: 00.13 (16.11.1995)
**            © Aris Basic
** Constructor:
**       application()
** Destructor:
**       end()
** Methods:
**       sigBitsA()
**       handleInput()
**
** For Arguments And Formats of methods look
**
** Explanation of Constants:
**       APP_          -> Errors                 Ex. APP_DOUBLE
**       APPT_         -> Tags (Value)           Ex. APPT_CXTAGS,[...]
**
**
** History:
**       00.10 : 13.11.1995    first release
**       00.11 : 14.11.1995    added method hadleInput()
**       00.12 : 15.11.1995    added Tag List Parsing
**       00.13 : 16.11.1995    changed TagList Pasing to other objects
**
*/
OPT MODULE
OPT EXPORT
OPT PREPROCESS

MODULE 'commodities','libraries/commodities',
       'exec/memory','exec/ports','exec/nodes','exec/lists',
       'amigalib/cx','amigalib/ports','amigalib/lists',
       'utility','utility/tagitem',
       '*cx'

-> Some Macro ShortCuts
#define CXSIGBIT cx.sigA()
#define CXERROR cx.error
#define CXBROKER cx.broker

-> Application Errors
ENUM APP_NOERROR = 0,
     APP_NOCX,
     APP_NOUTIL,
     APP_DOUBLE

-> Application Input Types
ENUM APPI_CX = 1,
     APPI_REXX,
     APPI_GUI

-> Application Tags
CONST APPT_CX=TAG_USER+$100        -> BOOL This Application Will Be Commodity
                                   -> Example APPT_CX,FALSE
                                   -> Default TRUE
ENUM APPT_COMMODITY=APPT_CX,       -> Alias for APPT_CX
     APPT_CXTAGS,                  -> LIST Commodity Tag List
     APPT_REXX,                    -> BOOL This Application will have ARexx Port
                                   -> Example APPT_REXX,TRUE
                                   -> Default FALSE (!! Not yet available !!)
     APPT_REXXTAGS,                -> LIST ARexx Tag List
     APPT_MSGPORT,                 -> BOOL This Application has own MSG Port
                                   -> Example APPT_MSGPORT,TRUE
                                   -> Default FALSE (!! Not yet available !!)
     APPT_MSGPORTNAME,             -> STRING Application MSG Port Name
                                   -> Example: APPT_MSGPORTNAME,'Test'
                                   -> Default argument name (!! Not yet available !!)
     APPT_SEMAPHORE,               ->
     APPT_SEMAPHORENAME,
     APPT_MORENAME

-> Main Object
OBJECT application
    name
    cx:PTR TO commodity
    error
    addSigs
    ENDOBJECT
->FOLDER application()
-> application method application(name,tags)
-> ** application Class Constructor **
-> Input:
->       name          -> Name of Application
->       tags = NIL    -> TagList with Attributes For Application
-> OutPut:
->       None
-> Example:
->
-> Bugs:
->       None known
-> Notes:
->       Class opens and closes utility and commodity library for you
->       Look in application.error to see was there some errors
->       commodity class errors will be passed as application error !!
-> History:
->       00.10 : 13.11.95      first release
->       00.11 : 15.11.95      added Application Tags Parsing
->       00.12 : 16.11.95      changed pasing tags to objects
-> CopyRight © Aris Basic 1995
-> $VER: 00.12 16.11.1995
->
PROC application(name,tags=NIL:PTR TO tagitem) OF application
    DEF cx,cxtags:PTR TO tagitem,rexxtags
 
    self.error:=0
    IF cx
        IF cxbase=NIL
            cxbase:=OpenLibrary('commodities.library',0)
            IF cxbase=NIL
                self.error:=APP_NOCX
                RETURN
                ENDIF
            ENDIF
        ENDIF
    IF utilitybase=NIL
        utilitybase:=OpenLibrary('utility.library',0)
        IF utilitybase=NIL
            self.error:=APP_NOUTIL
            RETURN
            ENDIF
        ENDIF
    self.name:=String(255)
    StrCopy(self.name,name)
    cx:=GetTagData(APPT_CX,TRUE,tags)
    cx:=GetTagData(APPT_COMMODITY,TRUE,tags)
    cxtags:=GetTagData(APPT_CXTAGS,NIL,tags)
    IF cx THEN NEW self.cx.commodity(name,cxtags)
    self.error:=self.cx.error
    IF self.error=CX_ERRDUP THEN self.error:=APP_DOUBLE
    ENDPROC
->END
->FOLDER sigBitsA()
-> application method sigBitsA()
-> ** Gets SignalBits of Application **
-> Input:
->       None
-> Output:
->       LONG Shl(1,signalsbits)=sigBitsA()
-> Example:
->       DEF app:PTR TO application
->       Wait(app.sigBitsA())
-> Note:
->       Signal Bits Are only from elements of Application Class
->       (commodity port , ?arexx port? , ?GUI? , ...)
-> Bugs:
->       None known
-> History:
->       00.10 : 13.11.95      first release
-> CopyRight © Aris Basic 1995
-> $VER: 00.10 13.11.1995
PROC sigBitsA() OF application
    DEF sigs
    IF self.cx THEN sigs:=self.cx.sigA()
    IF self.addSigs THEN sigs:=sigs OR self.addSigs
    ENDPROC sigs
->END
->FOLDER end()
-> application method end()
-> ** application Class Destructor **
-> Input:
->       None
-> Output:
->       None
-> Example:
->       DEF app:PTR TO application
->       END app -> app.end()
-> Note:
->       None
-> Bugs:
->       None known
-> History:
->       00.10 : 13.11.95      first release
-> CopyRight © Aris Basic 1995
-> $VER: 00.10 13.11.1995
->
PROC end() OF application
    END self.cx
    IF cxbase THEN CloseLibrary(cxbase)
    IF utilitybase THEN CloseLibrary(utilitybase)
    ENDPROC
->END
->FOLDER handleInput()
-> application method handleInput()
-> ** Handles Input Msgs on Application Ports **
-> Input:
->       None
-> Output:
->       type       -> Type Of Port
->       id         -> Id (like HotKey ID or Somthing other)
->       ...
-> Example:
->       DEF app:PTR TO application
->       type,id:=app.handleInput()
-> Note:
->       None
-> Bugs:
->       None known
-> Histroy:
->       00.10 : 14.11.95      first release
-> CopyRight © Aris Basic 1995
-> $VER: 00.10 14.11.1995
PROC handleInput() OF application
    DEF signal
    signal:=Wait(self.sigBitsA())
    IF signal AND self.CXSIGBIT THEN RETURN APPI_CX,self.cx.handlemsg()
    ENDPROC
->END
