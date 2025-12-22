
/***

	empty-handler.e v1.00

	By Vidar Hokstad <vidarh@rforum.no>

	This code is hereby declared public domain.

	Returns the number of ASCII NUL (0) specified as filename:
	"Copy Empty:100 Ram:test" will create a file "test" in Ram:
	containing 100 ASCII NUL

	The code uses the ReplyPkt() function of V36+ dos.library.
	To use it with 1.2/1.3, uncomment the replypkt() function, and
	change the case of the "ReplyPkt()" calls to "replypkt"

	Based on "empty-handler" in C by o.wagner@aworld-2.zer[.sub.org]

	Needs AmigaE3.1a or newer

***/

OPT OSVERSION=37,PREPROCESS

MODULE 'dos/dos','dos/dosextens','dos/filehandler','exec/ports',
		'exec/nodes'


#define Baddr(val) Shl(val,2)

PROC getpacket (p:PTR TO process)
	DEF port:PTR TO mp,
		msg:PTR TO mn

	port:= p.msgport		-> The port of our process
	WaitPort (port)			-> Wait for a message
	msg:= GetMsg (port)	
ENDPROC msg.ln::ln.name

/*
PROC replypkt (packet:PTR TO dospacket,res1,res2)

	DEF msg:PTR TO mn,
		replyport:PTR TO mp,p:PTR TO process

	p:= FindTask(0)

	->--- Set return codes

    packet.res1:=res1
    packet.res2:=res2

	->--- Find reply port

    replyport:=packet.port

	->--- Pointer to the execmessage of the packet

    msg:=packet.link

	->--- Set packet-port

    packet.port:=p.msgport

	->--- "Connect" message and packet

	msg.ln::ln.name:=packet;
    msg.ln::ln.succ:=NIL
    msg.ln::ln.pred:=NIL

	->--- ... and send message
	PutMsg(replyport,msg)
ENDPROC
*/

PROC main ()
	DEF hproc:PTR TO process,
		packet:PTR TO dospacket,
		devnode:PTR TO devicenode,
		fh:PTR TO filehandle,o:PTR TO mn

	DEF running=TRUE,
		opencount=0,
		emptylen,readlen,c,
		nump:PTR TO CHAR,
		filename[64]:STRING,typ

	->--- Initialize handler

	hproc:= FindTask(0)
	o:= wbmessage
	packet:=o.ln::ln.name  -> getpacket(hproc)
	wbmessage:=0

	devnode:= Baddr (packet.arg3)
	devnode.task:= hproc.msgport

	->--- Return startup packet

	ReplyPkt (packet,DOSTRUE,0)

	->--- Main loop

	WHILE running
		packet:= getpacket (hproc)
		typ:=packet.type
		SELECT typ

			CASE ACTION_FINDINPUT
				nump:= Baddr(packet.arg3)
				c:=0
				WHILE c<nump[]
					filename[c]:=nump[c+1]
					INC c
				ENDWHILE
				filename[c]:=0
				nump:= filename
				WHILE (nump[] AND (nump[]<>":")) DO INC nump
				IF nump[]=":" THEN INC nump
				emptylen:=Val (nump)
				INC opencount

				->--- Filehandle

				fh:= Baddr(packet.arg1)
				fh.interactive:=0 				-> Non-interactive file
				fh.args:=fh
				fh.arg2:=emptylen

				->--- Return packet
				ReplyPkt(packet,DOSTRUE,0)

			CASE ACTION_END
				->--- If no open files, end the handler

				DEC opencount
				running:= opencount<>0
				ReplyPkt(packet,DOSTRUE,0)

			CASE ACTION_READ

				->--- FileHandle from open
				fh:=packet.arg1
				nump:=packet.arg2
				emptylen:=fh.arg2
				readlen:=packet.arg3

				->--- Check for "end of file"
				readlen:=Min(readlen,emptylen)

				c:=0
				WHILE c<readlen
					nump[]:=0
					INC nump
					INC c
				ENDWHILE

				->--- Subtract lenght
				fh.arg2:=fh.arg2-readlen

				ReplyPkt (packet,readlen,0)


			CASE ACTION_WRITE
				ReplyPkt (packet,DOSFALSE,ERROR_DISK_WRITE_PROTECTED)
			DEFAULT
				ReplyPkt (packet,DOSFALSE,ERROR_ACTION_NOT_KNOWN)
		ENDSELECT
	ENDWHILE
	devnode.task:=FALSE
ENDPROC
