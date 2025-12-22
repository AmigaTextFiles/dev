/*

Memory test program for the file object. Redirect it's output to a file.
If that file is in RAM: sou have to call the program at least twice before
viewing the output.

*/

MODULE  'oomodules/file/textfile',
        'exec/memory'

PROC main()
DEF file:PTR TO textfile,
    index,
    memStart,
    memEnd

  memStart := AvailMem(MEMF_PUBLIC)

  WriteF('Textfile\n')
  WriteF('Test program for the amount of memory required.\n\n')
  WriteF('NEWing and ENDing the file a few times.\n')

  FOR index := 1 TO 5
    printMemoryAvailable('Total memory before NEWing file: ')
    NEW file.new()
    printMemoryAvailable('Total memory after NEW: ')
    END file
    printMemoryAvailable('ENDed file. free memory is now: ')
    WriteF('\n')
  ENDFOR

  WriteF('\n\n')



  printMemoryAvailable('total memory before NEWing file:\t')
  NEW file.new()

  printMemoryAvailable('total memory after NEW, before suck():\t')

  file.suck('S:Startup-sequence')

  printMemoryAvailable('sucked startup-sequence, available memory:\t')

  file.freeContents()

  printMemoryAvailable('freed memory used for text, free memory is now \t')

  END file

  printMemoryAvailable('ENDed file. free memory is now \t')

  memEnd := AvailMem(MEMF_PUBLIC)

  WriteF('\nMemory at the start of the program: \d.\n', memStart)
  WriteF('Memory at the end of the program:   \d.\n', memEnd)

  IF memStart=memEnd
    WriteF('\nNo memory was lost.\n')
  ELSE
    WriteF('\n\d bytes were lost.\n',memStart-memEnd)
  ENDIF

ENDPROC


PROC printMemoryAvailable(header)
DEF mem

  mem := AvailMem(MEMF_PUBLIC)

  WriteF('\s\d\n',header,mem)
ENDPROC
