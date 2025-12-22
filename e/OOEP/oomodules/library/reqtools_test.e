MODULE '*reqtools','libraries/reqtools'

-> Only need 'libraries/reqtools' for the CONST now.

-> NOTE: Some modifications by JEVR3 to reflect enhancements

PROC main()
DEF req:PTR TO reqtools

-> JEVR3: Now uses 'new()' to set up library.

  NEW req.new()

-> JEVR3: uncommented this part.

  req.ez('Nice to see ya!','Ah.|So what?',0,0,[RTEZ_REQTITLE,'Just a test',RT_REQPOS,REQPOS_POINTER,0])

-> JEVR3: compressed some lines a little bit.

  WriteF('\s\n',req.string('Just enter a string:'))
  WriteF('\s\n',req.string('Just enter a string:'))

  WriteF('\d\n', req.long('Just enter a number:'))

  
  WriteF('\d\n', req.palette('just choose a colour:'))

  req.file('FILE?')
  WriteF('\s\n', req.filebuf)
  WriteF('\s\n', req.dirbuf)
  END req
  -> automatically closes the library!
ENDPROC
