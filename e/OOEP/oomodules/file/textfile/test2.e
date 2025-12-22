MODULE 'oomodules/file/textfile',
         'dos/dos'

PROC main()
DEF tf:PTR TO textfile

  NEW tf.new(["suck",'ram:textfile'])

  WriteF('Proc after line 378: \d.\n', tf.findLine('PROC',378))

  WriteF('First ENDPROC in line \d.\n', tf.findLine('ENDPROC',0))


  END tf

ENDPROC
