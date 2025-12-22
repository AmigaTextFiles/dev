MODULE 'oomodules/library/device/trackdisk/trackdisk'

PROC main()
DEF diskette:PTR TO trackdisk, count

  NEW diskette.new()

  IF diskette.diskindrive()

    diskette.readblock(0)

    FOR count := 0 TO 15 DO WriteF(' \z\h[2] ', diskette.buffer[count])
    WriteF('\n')
    FOR count := 0 TO 15 DO IF diskette.buffer[count] THEN WriteF(' \c  ', diskette.buffer[count]) ELSE WriteF('    ')
    WriteF('\n')
    IF diskette.diskprotected() THEN WriteF('The disk is write protected.\n')
  ELSE
    WriteF('Please insert a disk in drive zero.\n')
  ENDIF
  diskette.motor(FALSE)


ENDPROC
