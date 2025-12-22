/* commodity Class $VER: 00.12 (16.11.1995)
**          © Aris Basic 1995
** Constructor:
**       commodity()
** Destructor:
**       end()
** Methods:
**       addHotkey()
**       replaceHotkey()
**       removeHotkey()
**       sig()
**       sigA()
**       handlemsg()
**       changeFunc()
**
** For Arguments And Formats of methods look
**
** Explanation of Constants:
**       CX_           -> Errors                 Ex. CX_NOBROKER
**       CXT_          -> Tags (Value)           Ex. CXT_HOTKEYS,[...]
**       CXF_          -> StdCx Commands         Ex. CXF_APPEAR,{cx_appear}
**       CXC_          -> Values                 Ex. CXT_UNIQUE,CXC_UNQNOTIFY
**
** Histroy:
**       00.10 : 13.11.1995    first release
**       00.11 : 14.11.1995    changed Hotkey List Format -> [hotkey,hotkey_id,hotkey_func]
**                             added new tag CXT_CMDFUNCS
**                             added new method handlemsg()
**                             added new argument to method addHotkey()
**       00.12 : 16.11.1995    added new method changeFunc()
**                             changed arguments in method replaceHotkey()
**
*/
OPT MODULE
OPT PREPROCESS
OPT EXPORT

MODULE 'commodities','libraries/commodities',
       'exec/memory','exec/ports','exec/nodes','exec/lists',
       'amigalib/cx','amigalib/ports','amigalib/lists',
       'utility','utility/tagitem'


-> Commodities Errors
CONST CX_NOERROR = 0

ENUM CX_ERRHOTKEY = 25,
     CX_NOHOTKEYS,
     CX_NOHOTKEY,
     CX_NOBROKER,
     CX_NOBROKERPORT,
     CX_ERRDUP,
     CX_ERRSYS

-> Commodities Tags
CONST CXT_NAME   = TAG_USER+1      -> STRING Commodity Name (Will Apear in Exchange)
                                   -> Example CXT_NAME,'TestCx'
                                   -> Default argument name
ENUM  CXT_CXNAME = CXT_NAME,       -> alias for CXT_NAME
      CXT_TITLE,                   -> STRING Commodity Title
                                   -> Example: CXT_TITLE,'TestCx © Aris Basic'
                                   -> Default argument name
      CXT_DESCRIPTION,             -> STRING Commodity Description
                                   -> Example: CXT_DESCRIPTION,'Small Cx'
                                   -> Default argument name
      CXT_UNIQUE,                  -> LONG Commodity Unique Flags
                                   -> Example: CXT_UNIQUE,NBU_UNIQUE OR NBU_NOTIFY
                                   -> Deafult 0
      CXT_FLAGS,                   -> LONG Commodity Flags
                                   -> For Flags look at libraries/commodites.m
                                   -> Example: CXT_FLAGS,COF_SHOW_HIDE
                                   -> Default 0
      CXT_PRI,                     -> CHAR Commodity Priority
                                   -> Example: CXT_PRI,-1
                                   -> Default 0
      CXT_HOTKEYS,                 -> LIST with Format [hotkeystring,hotkey_id,hotkey_func] must end with NIL
                                   -> !! This will be changed !!
                                   -> Example: CXT_HOTKEYS,['lalt n',1,NIL,'lalt p',2,NIL,NIL]
                                   -> Default NIL
      CXT_CMDFUNCS                 -> LIST with Format [cx_cmd,cx_func]
                                   -> This is Subject of Change
                                   -> Example: CXT_CMDFUNCS,[CXF_APPEAR,{cx_apear},...,NIL]

-> Commodities Short Constants
CONST CXC_UNQNOTIFY = 3            -> Short For (NBU_UNIQUE OR NBU_NOTIFY)

-> Commodities Functions
ENUM CXF_APPEAR=1,
     CXF_DISAPPEAR,
     CXF_SHOW,
     CXF_HIDE,
     CXF_DISABLE,
     CXF_ENABLE,
     CXF_KILL,
     CXF_UNIQUE

-> HotkeysList Node Object
-> Note: This Object is Subject To Change
OBJECT hotkeys
    list:ln
    hotkey:PTR TO LONG
    hotkey_id
    hotkey_func
    ENDOBJECT

-> Main Object
OBJECT commodity
    broker
    brokerport:PTR TO mp
    hotkeylist:PTR TO lh
    cxcmd_funcs[10]:ARRAY OF LONG
    error:CHAR
    ENDOBJECT
->FOLDER commodity()
-> commodity method commodity(name,taglist)
-> ** commodity Class Constructor **
-> Input:
->       name          -> Name of Commodity
->       taglist = NIL -> TagList with Attributes For Commodity
-> OutPut:
->       None
-> Example:
->       DEF cx:PTR TO commodity
->       NEW cx.commodity('Test',[CXT_TITLE,'Test Cx © Aris Basic',
->                                CXT_DESCRIPTION,'Commodity Class Test Cx',
->                                CXT_HOTKEYS,['lalt p',1,NIL,
->                                             NIL,NIL,NIL],
->                                TAG_DONE])
-> Bugs:
->      None known
-> Notes:
->      Class Dosn`t checks are utilty and commodity library opened
->      so you must do that yourself
->      Look in commodity.error to see was there some errors
-> History:
->       00.10 : 13.11.95      first release
->       00.11 : 14.11.95      addapted to new hotkeyformat
->                             added parsing of CXT_CMDFUNCS tag
-> CopyRight © Aris Basic 1995
-> $VER: 00.11 14.11.1995
->
PROC commodity(name,taglist=NIL:PTR TO tagitem) OF commodity
    DEF a=0,unique,flags,pri,cxname[255]:STRING,title[255]:STRING,desc[255]:STRING
    DEF htag:PTR TO LONG,error,cmdtags:PTR TO LONG

    self.error:=0
    self.brokerport:=CreateMsgPort()
    IF self.brokerport=NIL
        self.error:=CX_NOBROKERPORT
        RETURN
        ENDIF
    StrCopy(cxname,GetTagData(CXT_NAME,name,taglist))
    StrCopy(cxname,GetTagData(CXT_CXNAME,name,taglist))
    StrCopy(title,GetTagData(CXT_TITLE,name,taglist))
    StrCopy(desc,GetTagData(CXT_DESCRIPTION,name,taglist))
    unique:=GetTagData(CXT_UNIQUE,0,taglist)
    pri:=GetTagData(CXT_PRI,0,taglist)
    flags:=GetTagData(CXT_FLAGS,0,taglist)
    self.broker:=CxBroker([NB_VERSION,0,
                           cxname,
                           title,
                           desc,
                           unique,
                           flags,
                           pri,
                           0,
                           self.brokerport,0]:newbroker,{error})
    IF self.broker=NIL
        SELECT error
            CASE CBERR_SYSERR
                self.error:=CX_ERRSYS
            CASE CBERR_DUP
                self.error:=CX_ERRDUP
            DEFAULT
                self.error:=CX_NOBROKER
            ENDSELECT
        RETURN
        ENDIF
    ActivateCxObj(self.broker,TRUE)
    NEW self.hotkeylist
    newList(self.hotkeylist)
    htag:=GetTagData(CXT_HOTKEYS,NIL,taglist)
    IF htag
        WHILE htag[a]
            self.addHotkey(htag[a],htag[a+1],htag[a+2])
            a:=a+3
            ENDWHILE
        ENDIF
    cmdtags:=GetTagData(CXT_CMDFUNCS,NIL,taglist)
    a:=0
    IF cmdtags
        WHILE cmdtags[a]
            self.cxcmd_funcs[cmdtags[a]]:=cmdtags[a+1]
            a:=a+2
            ENDWHILE
        ENDIF
    ENDPROC
->END
->FOLDER addHotkey()
-> commodity method addHotkey(hotkey,hotkey_id,hotkey_func)
-> ** Adds Hotkey To List Of Hotkeys of Commodity **
-> Input:
->       hotkey        -> String Which Descripts Hotkey (Ex. 'lalt b')
->       hotkey_id     -> Id of hotkey (LONG) (Ex. ENUM HOTKEY1,HOTKEY2,... ;)
->       hotkey_func   -> Pointer to function to run if this hotkey comes (can be NIL)
-> OutPut:
->         None
-> Example:
->         DEF cx:PTR TO commodity
->         cx.addHotkey('lalt r',1,NIL)
-> Bugs:
->         None known
-> Note:
->         Look in commodity.error to see was there some errors
-> History:
->       00.10 : 13.11.95      first release
->       00.11 : 14.11.95      added new argument hotkey_func
-> CopyRight © Aris Basic 1995
-> $VER: 00.11 14.11.1995
->
PROC addHotkey(hotkey,hotkey_id,hotkey_func=NIL) OF commodity
    DEF hotkeynode:PTR TO hotkeys
    self.error:=0
    NEW hotkeynode
    hotkeynode.list.name:=String(StrLen(hotkey))
    StrCopy(hotkeynode.list.name,hotkey)
    hotkeynode.list.type:=NT_UNKNOWN
    hotkeynode.list.pri:=0
    hotkeynode.hotkey_id:=hotkey_id
    IF hotkey_func THEN hotkeynode.hotkey_func:=hotkey_func ELSE hotkeynode.hotkey_func:=NIL
    hotkeynode.hotkey:=hotKey(hotkey,self.brokerport,hotkey_id)
    AttachCxObj(self.broker,hotkeynode.hotkey)
    AddHead(self.hotkeylist,hotkeynode)
    ENDPROC
->END
->FOLDER replaceHotkey()
-> commodity method replaceHotkey(oldhotkey,newhotkey,newfunc=NIL)
-> ** Replaces Old Hotkey With NewOne **
-> Input:
->       oldhotkey     -> String With OldHotkey Description (Ex. 'lalt o')
->       newhotkey     -> String With NewHotkey Description (Ex. 'lalt n')
->       newfunc       -> Pointer to new HotkeyFunc if needed
-> Output:
->        None
-> Example:
->        DEF cx:PTR TO commodity
->        cx.replaceHotkey('lalt o','lalt n')
-> Bugs:
->        None known
-> Note:
->        Old Hotkey ID and function Will be keeped for new hotkey (if newfunc=NIL "default")!!
->        Look commodity.error to see if there was some error
-> History:
->       00.10 : 13.11.95      first release
->       00.11 : 14.11.95      addpted to new hotkey format
->       00.12 : 16.11.95      added new argument newfunc
-> CopyRight © Aris Basic 1995
-> $VER: 00.12 16.11.1995
->
PROC replaceHotkey(oldhotkey,newhotkey,newfunc=NIL) OF commodity
    DEF ohotkeynode:PTR TO hotkeys,hotkey_id,hotkey_func
    DEF rhotkeynode:PTR TO hotkeys
    self.error:=0
    IF self.hotkeylist.tailpred=self.hotkeylist
        self.error:=CX_NOHOTKEYS
    ELSE
        ohotkeynode:=FindName(self.hotkeylist,oldhotkey)
        IF ohotkeynode
            hotkey_id:=ohotkeynode.hotkey_id
            hotkey_func:=ohotkeynode.hotkey_func
            IF newfunc THEN hotkey_func:=newfunc
            RemoveCxObj(ohotkeynode.hotkey)
            DeleteCxObj(ohotkeynode.hotkey)
            Remove(ohotkeynode)
            END ohotkeynode
            NEW rhotkeynode
            rhotkeynode.list.name:=String(StrLen(newhotkey))
            StrCopy(rhotkeynode.list.name,newhotkey)
            rhotkeynode.list.type:=NT_UNKNOWN
            rhotkeynode.list.pri:=0
            rhotkeynode.hotkey_id:=hotkey_id
            rhotkeynode.hotkey_func:=hotkey_func
            rhotkeynode.hotkey:=hotKey(newhotkey,self.brokerport,hotkey_id)
            AttachCxObj(self.broker,rhotkeynode.hotkey)
            AddHead(self.hotkeylist,rhotkeynode)
        ELSE
            self.error:=CX_NOHOTKEY
            ENDIF
        ENDIF
    ENDPROC
->END
->FOLDER removeHotkey()
-> commodity method removeHotkey(hotkey)
-> ** Removes Hotkey From the List of Hotkeys **
-> Input:
->       hotkey        -> hotkey Description String (Ex. 'lalt h')
-> Output:
->        None
-> Example:
->        DEF cx:PTR TO commodity
->        cx.removeHotkey('lalt r')
-> Bugs:
->        None known
-> Note:
->        None
-> History:
->       00.10 : 13.11.95      first release
-> CopyRight © Aris Basic 1995
-> $VER: 00.10 13.11.1995
->
PROC removeHotkey(hotkey) OF commodity
    DEF hotkeynode:PTR TO hotkeys
    self.error:=0
    IF self.hotkeylist.tailpred=self.hotkeylist
        self.error:=CX_NOHOTKEYS
    ELSE
        hotkeynode:=FindName(self.hotkeylist,hotkey)
        IF hotkeynode
            RemoveCxObj(hotkeynode.hotkey)
            DeleteCxObj(hotkeynode.hotkey)
            Remove(hotkeynode)
            END hotkeynode
        ELSE
            self.error:=CX_NOHOTKEY
            ENDIF
        ENDIF
    ENDPROC
->END
->FOLDER sig() & sigA()
-> commodity methods sig() and sigA()
-> ** Gets SignalBits of Commodity Broker Port **
-> Input:
->       None
-> Output:
->       LONG signalbit=sig(),LONG Shl(1,signalbit)=sigA()
-> Example:
->       DEF cx:PTR TO commodity
->       Wait(cx.sigA())  -> Wait(Shl(1,cx.sig()))
-> Note:
->       None
-> Bugs:
->       None known
-> History:
->       00.10 : 13.11.95      first release
-> CopyRight © Aris Basic 1995
-> $VER: 00.10 13.11.1995
->
PROC sigA() OF commodity IS Shl(1,self.brokerport.sigbit)
PROC sig() OF commodity IS self.brokerport.sigbit
->END
->FOLDER end()
-> commodity method end()
-> ** commodity Class Destructor **
-> Input:
->       None
-> Output:
->       None
-> Example:
->       DEF cx:PTR TO commodity
->       END cx -> cx.end()
-> Note:
->       None
-> Bugs:
->       None known
-> History:
->       00.10 : 13.11.95      first release
-> CopyRight © Aris Basic 1995
-> $VER: 00.10 13.11.1995
->
PROC end() OF commodity
    DEF hotkeynode:PTR TO hotkeys,nextnode
    DeleteCxObjAll(self.broker)
    hotkeynode:=self.hotkeylist.head
    WHILE nextnode:=hotkeynode.list.succ
        END hotkeynode
        hotkeynode:=nextnode
        ENDWHILE
    ENDPROC
->END
->FOLDER handlemsg()
-> commodity method handlemsg()
-> ** handles incoming CxMsg **
-> Input:
->       None
-> Output:
->       HOTKEY_ID,CMD_ID,Return Of Func or Nothing
-> Example:
->       DEF cx:PTR TO commodity
->       SELECT cx.handlemsg()
->              CASE 0
->              CASE HOTKEY_1
->                   ...somthing...
->              CASE CXCMD_DISABLE
->                   ...somthing...
->              :
->              :
-> Note:
->       CXCMD_LIST_CHG Not Implemented
-> Bugs:
->       None known
-> History:
->       00.10 : 14.11.95      first release
-> CopyRight © Aris Basic 1995
-> $VER: 00.10 14.11.1995
PROC handlemsg() OF commodity
    DEF msg,msgid,msgtype,func,hotkeynode:PTR TO hotkeys,done=TRUE
    WHILE msg:=GetMsg(self.brokerport)
        msgid:=CxMsgID(msg)
        msgtype:=CxMsgType(msg)
        ReplyMsg(msg)
        SELECT msgtype
            CASE CXM_IEVENT
                 hotkeynode:=self.hotkeylist.head
                 WHILE hotkeynode.list.succ
                     IF hotkeynode.hotkey_id=msgid
                         func:=hotkeynode.hotkey_func
                         RETURN func()
                         ENDIF
                     hotkeynode:=hotkeynode.list.succ
                     ENDWHILE
                 RETURN msgid
            CASE CXM_COMMAND
                SELECT msgid
                    CASE CXCMD_DISABLE
                        IF self.cxcmd_funcs[CXF_DISABLE]
                            func:=self.cxcmd_funcs[CXF_DISABLE]
                            RETURN func()
                            ENDIF
                        RETURN CXCMD_DISABLE
                    CASE CXCMD_ENABLE
                        IF self.cxcmd_funcs[CXF_ENABLE]
                            func:=self.cxcmd_funcs[CXF_ENABLE]
                            RETURN func()
                            ENDIF
                        RETURN CXCMD_ENABLE
                    CASE CXCMD_KILL
                        IF self.cxcmd_funcs[CXF_KILL]
                            func:=self.cxcmd_funcs[CXF_KILL]
                            RETURN func()
                            ENDIF
                        RETURN CXCMD_KILL
                    CASE CXCMD_UNIQUE
                        IF self.cxcmd_funcs[CXF_UNIQUE]
                            func:=self.cxcmd_funcs[CXF_UNIQUE]
                            RETURN func()
                            ENDIF
                        RETURN CXCMD_UNIQUE
                    CASE CXCMD_APPEAR
                        IF self.cxcmd_funcs[CXF_APPEAR]
                            func:=self.cxcmd_funcs[CXF_APPEAR]
                            RETURN func()
                            ENDIF
                        RETURN CXCMD_APPEAR
                    CASE CXCMD_DISAPPEAR
                        IF self.cxcmd_funcs[CXF_DISAPPEAR]
                            func:=self.cxcmd_funcs[CXF_DISAPPEAR]
                            RETURN func()
                            ENDIF
                        RETURN CXCMD_DISAPPEAR
                    ENDSELECT
            ENDSELECT
        ENDWHILE
    ENDPROC
->END
->FOLDER changeFunc()
-> commodity method changeFunc(hotkey,newfunc)
-> ** Simple it changes old On Key Function with newone **
-> Input:
->       hotkey        -> hotkey description String Or Commodity Function Value
->       newfunc       -> pointer to new function
-> Output:
->       None
-> Example:
->       DEF c:PTR TO commodity
->       cx.changeFunc('lalt t',{newkeyfunc})
-> Bugs:
->       None known
-> Note:
->       None
-> History:
->       00.10 : 16.11.1995    first release
-> CopyRight © Aris Basic 1995
-> $VER: 00.10 16.11.1995
PROC changeFunc(hotkey,newfunc) OF commodity
    DEF hotkeynode:PTR TO hotkeys
    self.error:=0
    IF hotkey>CXF_APPEAR AND hotkey<CXF_UNIQUE
        self.cxcmd_funcs[hotkey]:=newfunc
        RETURN
        ENDIF
    IF self.hotkeylist.tailpred=self.hotkeylist
        self.error:=CX_NOHOTKEYS
    ELSE
        IF hotkeynode:=FindName(self.hotkeylist,hotkey)
            hotkeynode.hotkey_func:=newfunc
        ELSE
            self.error:=CX_NOHOTKEY
            ENDIF
        ENDIF
    ENDPROC
->END

