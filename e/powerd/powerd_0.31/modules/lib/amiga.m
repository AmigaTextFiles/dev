OPT	LINK='Amiga.lib'

MODULE	'devices/timer',
			'devices/keymap',
			'libraries/commodities',
			'utility/hooks',
			'intuition/classes',
			'intuition/classusr',
			'graphics/graphint'

/*  Exec support functions */

LPROC BeginIO(ioreq:PTR TO IORequest)
LPROC CreateExtIO(port:PTR TO MsgPort,ioSize:L)(PTR TO IORequest)
LPROC CreatePort(name:PTR TO CHAR,pri:L)(PTR TO MsgPort)
LPROC CreateStdIO(port:PTR TO MsgPort)(PTR TO IOStrReq)
LPROC CreateTask(name:PTR TO CHAR,pri:L,initPC:PTR,stackSize:UL)(PTR TO Task)
LPROC DeleteExtIO(ioreq:PTR TO IORequest)
LPROC DeletePort(ioreq:PTR TO MsgPort)
LPROC DeleteStdIO(ioreq:PTR TO IOStdReq)
LPROC DeleteTask(task:PTR TO Task)
LPROC NewList(list:PTR TO List)

LPROC LibAllocPooled(poolHeader:PTR,memSize:UL)(PTR)
LPROC LibCreatePool(memFlags:UL,puddleSize:UL,threshSize:UL)(PTR)
LPROC LibDeletePool(poolHeader:PTR)
LPROC LibFreePooled(poolHeader:PTR,memory:PTR,memSize:UL)

/* Assorted functions in amiga.lib */

LPROC FastRand(seed:UL)(UL)
LPROC RangeRand(maxValue:UL)(UW)

/* Graphics support functions in amiga.lib */

LPROC AddTOF(i:PTR TO Isrvstr,p/*()*/,a:L)
LPROC RemTOF(i:PTR TO Isrvstr)
LPROC waitbeam(b:L)

/* math support functions in amiga.lib */

LPROC afp(string:PTR TO CHAR)(F)
LPROC arnd(place,exp,string:PTR TO CHAR)
LPROC dbf(exp:UL,mant:UL)(F)
LPROC fpa(fnum:F,string:PTR TO CHAR)(L)
LPROC fpbcd(fnum:F,string:PTR TO CHAR)

/* Timer support functions in amiga.lib (V36 and higher only) */

LPROC TimeDelay(unit:LONG,secs:ULONG,microsecs:ULONG)(LONG)
LPROC DoTimer(time:PTR TO TimeVal,unit:LONG,command:LONG)(LONG)

/*  Commodities functions in amiga.lib (V36 and higher only) */

LPROC ArgArrayDone()
LPROC ArgArrayInit(argc:LONG,argv:PTR TO PTR TO CHAR)(PTR TO PTR TO CHAR)
LPROC ArgInt(tt:PTR TO PTR TO CHAR,entry:PTR TO CHAR,defaultval:LONG)(LONG)
LPROC ArgString(tt:PTR TO PTR TO CHAR,entry:PTR TO CHAR,defaulstring:PTR TO CHAR)(PTR TO CHAR)
//LPROC HotKey(description:PTR TO CHAR,port:PTR TO MsgPort,id:L)(PTR TO CxObj)
LPROC InvertString(str:PTR TO CHAR,km:PTR TO KeyMap)(PTR TO InputEvent)
LPROC FreeIEvents(events:PTR TO InputEvent)

/*  ARexx support functions in amiga.lib */

LPROC CheckRexxMsg(rexxmsg:PTR TO Message)(BOOL)
LPROC GetRexxVar(rexxmsg:PTR TO Message,name:PTR TO CHAR,result:PTR TO PTR TO CHAR)(LONG)
LPROC SetRexxVar(rexxmsg:PTR TO Message,name:PTR TO CHAR,value:PTR TO CHAR,length:LONG)(LONG)

/*  Intuition hook and boopsi support functions in amiga.lib. */
/*  These functions do not require any particular ROM revision */
/*  to operate correctly, though they deal with concepts first introduced */
/*  in V36.  These functions would work with compatibly-implemented */
/*  hooks or objects under V34. */

LPROC CallHookA(hookPtr:PTR TO Hook,obj:PTR TO _Object,message:PTR TO LONG)(ULONG)
LPROC CallHook(hookPtr:PTR TO Hook,obj:PTR TO _Object,message:LIST OF LONG)(ULONG)
LPROC DoMethodA(obj:PTR TO _Object,message=NIL:PTR TO ULONG)(ULONG)
LPROC DoMethod(obj:PTR TO _Object,methodid:ULONG,message=NIL:LIST OF ULONG)(ULONG)
LPROC DoSuperMethodA(cl:PTR TO IClass,obj:PTR TO _Object,message:PTR TO Msg)(ULONG)
LPROC DoSuperMethod(cl:PTR TO IClass,obj:PTR TO _Object,MethodID:ULONG,list:LIST OF LONG)(ULONG)
LPROC CoerceMethodA(cl:PTR TO IClass,obj:PTR TO _Object,message:PTR TO Msg)(ULONG)
LPROC CoerceMethod(cl:PTR TO IClass,obj:PTR TO _Object,MethodID:ULONG,list:LIST OF LONG)(ULONG)
LPROC SetSuperAttrs(cl:PTR TO IClass,obj:PTR TO _Object,Tag1:LIST OF TagItem)(ULONG)

LPROC ACrypt(buffer:PTR TO CHAR,password:PTR TO CHAR,username:PTR TO CHAR)(PTR TO CHAR)
