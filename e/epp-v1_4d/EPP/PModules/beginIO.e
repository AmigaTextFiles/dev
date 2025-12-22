OPT TURBO

PROC beginIO(iorequestptr:PTR TO ioaudio)
  MOVE.L  iorequestptr,A1
  MOVE.L  IO_DEVICE(A1),A6
  JSR     DEV_BEGINIO(A6)
ENDPROC

