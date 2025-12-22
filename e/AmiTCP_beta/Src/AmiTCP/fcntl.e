OPT MODULE, PREPROCESS
OPT EXPORT

-> Setup by dosio_init() in 'amitcp/init/dosio_init'
DEF __dosio_files:PTR TO LONG

PROC read(fd, buf, len)
  IF fd<3
    RETURN Read(__dosio_files[fd], buf, len)
  ELSE
    RETURN -1
  ENDIF
ENDPROC

PROC write(fd, buf, len)
  IF fd<3
    RETURN Write(__dosio_files[fd], buf, len)
  ELSE
    RETURN -1
  ENDIF
ENDPROC

PROC lseek(fd, pos, mode)
  IF fd<3
    RETURN Seek(__dosio_files[fd], pos, mode-1)
  ELSE
    RETURN -1
  ENDIF
ENDPROC

PROC tell(x) IS lseek(x, 0, 1)

PROC unlink(name) IS Not(DeleteFile(name))

PROC isatty(fd)
  IF fd<3
    RETURN IsInteractive(__dosio_files[fd]) AND 1
  ELSE
    RETURN 0
  ENDIF
ENDPROC
