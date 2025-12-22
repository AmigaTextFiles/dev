MODULE 'oomodules/file/textfile',
         'dos/dos'

PROC main()
DEF tf:PTR TO textfile

  NEW tf.new(["suck",'ram:textfile'])

  WriteF('Number of lines: \d\n', tf.numberOfLines)

  END tf

ENDPROC
