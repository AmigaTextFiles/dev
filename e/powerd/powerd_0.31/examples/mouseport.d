// switches mouseports

OPT	DOSONLY,OPTIMIZE

MODULE 'devices/input','exec/io'

ENUM	JOY

PROC main()
	DEF	request=NIL:PTR TO IOStd,port=NIL,rda,args=[0]:LONG,mouse
	IF rda:=ReadArgs('JOY/S',args,NIL)
		mouse:=IF args[JOY] THEN 1 ELSE 0	// 0 for original port, 1 for joyport
		IF port:=CreateMsgPort()
			IF request:=CreateIORequest(port,SIZEOF_IOStd)
				IF OpenDevice('input.device',0,request,0)=0
					request.Command:=IND_SETMPORT
//					request.Data:=[mouse]:BYTE
					request.Data:=[mouse,0]:BYTE
					request.Length:=1
					DoIO(request)
					CloseDevice(request)
				ELSE PrintF('\s: could not open input device\n','mouseport')
				DeleteIORequest(request)
			ELSE PrintF('\s: could not create iorequest\n','mouseport')
			DeleteMsgPort(port)    
		ELSE PrintF('\s: could not open port\n','mouseport')
		FreeArgs(rda)
	ELSE PrintFault(IOErr(),'mouseport')
ENDPROC
