#ifndef DOS_NOTIFY_H
#define DOS_NOTIFY_H

#ifndef EXEC_TYPES_H
MODULE  'exec/types'
#endif
#ifndef EXEC_PORTS_H
MODULE  'exec/ports'
#endif
#ifndef EXEC_TASKS_H
MODULE  'exec/tasks'
#endif


#define NOTIFY_CLASS	$40000000

#define NOTIFY_CODE	$1234

OBJECT NotifyMessage
 
      ExecMessage:Message
    Class:LONG
    Code:UWORD
      NReq:PTR TO NotifyRequest	
    DoNotTouch:LONG		
    DoNotTouch2:LONG		
ENDOBJECT



OBJECT NotifyRequest
 
	Name:PTR TO UBYTE
	FullName:PTR TO UBYTE		
	UserData:LONG		
	Flags:LONG
	 UNION stuff

	     OBJECT Msg

		  Port:PTR TO MsgPort	
	     ENDOBJECT
	     OBJECT Signal

		  Task:PTR TO Task		
		SignalNum:UBYTE		
		pad[3]:UBYTE
	     ENDOBJECT
	 ENDUNION
	Reserved[4]:LONG		
	
	MsgCount:LONG		
	  Handler:PTR TO MsgPort	
ENDOBJECT


#define NRF_SEND_MESSAGE	1
#define NRF_SEND_SIGNAL		2
#define NRF_WAIT_REPLY		8
#define NRF_NOTIFY_INITIAL	16

#define NRF_MAGIC	$80000000

#define NRB_SEND_MESSAGE	0
#define NRB_SEND_SIGNAL		1
#define NRB_WAIT_REPLY		3
#define NRB_NOTIFY_INITIAL	4
#define NRB_MAGIC		31

#define NR_HANDLER_FLAGS	$ffff0000
#endif 
