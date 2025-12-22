MODULE  'oomodules/library/asl',

        'libraries/asl'

PROC main()
DEF asl:PTR TO asl


  NEW asl.new()

  asl.open()

  WriteF('You chose \s.\n', asl.getFileWithPattern('*.e',[ASL_HAIL, 'huhu']))

  asl.close()

ENDPROC
