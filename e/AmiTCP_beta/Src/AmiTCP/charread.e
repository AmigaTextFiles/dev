OPT MODULE, PREPROCESS
OPT EXPORT

MODULE 'bsdsocket'

CONST RC_BUFSIZE=1024

OBJECT charread
  fd
  size
  curr
  buffer[RC_BUFSIZE]:ARRAY
ENDOBJECT

CONST RC_DO_SELECT=-3,
      RC_EOF=-2,
      RC_ERROR=-1

PROC initCharRead(rc:PTR TO charread, fd)
  rc.fd:=fd
  rc.size:=0
  rc.curr:=1
ENDPROC

#define RC_R_E_A_D(a,b,c) Recv(a,b,c,0)

PROC charRead(rc:PTR TO charread)
  DEF curr
  rc.curr:=(curr:=rc.curr)+1
  IF curr<rc.size
    RETURN rc.buffer[curr]
  ELSEIF curr=rc.size
    RETURN RC_DO_SELECT
  ELSE
    rc.size:=RC_R_E_A_D(rc.fd, rc.buffer, RC_BUFSIZE)
    IF rc.size<=0
      RETURN IF rc.size=0 THEN RC_EOF ELSE RC_ERROR
    ELSE
      rc.curr:=1
      RETURN rc.buffer[]
    ENDIF
  ENDIF
ENDPROC
