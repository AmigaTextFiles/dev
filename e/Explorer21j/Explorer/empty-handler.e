/***
  Returns the number of X's specified as filename:
  "Copy Empty:100 Ram:test" will create a file "test" in Ram:
  containing 100 X's
***/

OPT OSVERSION=37, PREPROCESS

MODULE 'dos/dos',
       'dos/dosextens',
       'dos/filehandler',
       'exec/ports',
       'exec/nodes',
       'rexx/rxslib',
       'rexxsyslib',
       'amigalib/ports',
       'other/sendexplorer'

ENUM ERR_NONE, ERR_LIB

RAISE ERR_LIB IF OpenLibrary()=NIL

PROC getpacket (p:PTR TO process)
  DEF port:PTR TO mp, msg:PTR TO mn
  port:=p.msgport    -> The port of our process
  WaitPort(port)     -> Wait for a message
  msg:=GetMsg(port) 
ENDPROC msg.ln.name

PROC main() HANDLE
  DEF myrep=NIL:PTR TO mp
  rexxsysbase:=OpenLibrary(RXSNAME, 0)
  IF NIL=(myrep:=createPort(NIL,0)) THEN Raise("PORT")
  handler(myrep)
EXCEPT DO
  IF myrep THEN deletePort(myrep)
  IF rexxsysbase THEN CloseLibrary(rexxsysbase)
ENDPROC

PROC initialpacket(myrep)
  DEF proc:PTR TO process, packet:PTR TO dospacket, ln:PTR TO ln,
      dev:PTR TO devicenode
  proc:=FindTask(NIL)
  ln:=wbmessage
  packet:=ln.name
  wbmessage:=NIL
  dev:=BADDR(packet.arg3)
  dev.task:=proc.msgport
  sendExplorer(packet, 'dospacket', myrep)
  ReplyPkt(packet, DOSTRUE, 0)
ENDPROC proc, dev

PROC handler(myrep)
  DEF proc, packet:PTR TO dospacket, dev:PTR TO devicenode,
      fh:PTR TO filehandle, running=TRUE, opencount=0,
      readlen, c, s, filename[64]:STRING, type
  proc,dev:=initialpacket(myrep)
  WHILE running
    packet:=getpacket(proc)
    sendExplorer(packet, 'dospacket', myrep)
    type:=packet.type
    SELECT type
    CASE ACTION_FINDINPUT
      s:=BADDR(packet.arg3)
      c:=0
      WHILE c<s[]
        filename[c]:=s[c+1]
        INC c
      ENDWHILE
      filename[c]:=0
      s:=filename
      WHILE s[] AND (s[]<>":") DO INC s
      IF s[]=":" THEN INC s
      c:=Val(s)
      INC opencount
      fh:=BADDR(packet.arg1)
      fh.interactive:=0         -> Non-interactive file
      fh.args:=fh
      fh.arg2:=c
      ReplyPkt(packet, DOSTRUE, 0)
    CASE ACTION_READ
      fh:=packet.arg1
      s:=packet.arg2
      readlen:=Min(fh.arg2, packet.arg3)
      c:=0
      WHILE c<readlen
        s[]++:="X"
        INC c
      ENDWHILE
      fh.arg2:=fh.arg2-readlen
      ReplyPkt(packet, readlen, 0)
    CASE ACTION_WRITE
      ReplyPkt(packet, DOSFALSE, ERROR_DISK_WRITE_PROTECTED)
    CASE ACTION_END
      DEC opencount
      running:=opencount<>0
      ReplyPkt(packet, DOSTRUE, 0)
    DEFAULT
      ReplyPkt(packet, DOSFALSE, ERROR_ACTION_NOT_KNOWN)
    ENDSELECT
  ENDWHILE
  dev.task:=FALSE
ENDPROC
