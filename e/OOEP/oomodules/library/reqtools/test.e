MODULE 'oomodules/library/reqtools',
      'reqtools','libraries/reqtools'

PROC main() HANDLE
DEF req:PTR TO reqtools

  NEW req.new(["name",'reqtools.library',"vers",37])

  req.ez('Nice to see ya!','Ah.|So what?',0,0,[RTEZ_REQTITLE,'Just a test',RT_REQPOS,REQPOS_POINTER])
  req.string('Just enter a string:')
  WriteF('\s\n',req.stringbuf)
  req.string('Just enter a string:')
  WriteF('\s\n',req.stringbuf)

  req.long('just enter a number:')
  WriteF('\d\n', req.number)

  req.palette('just choose a colour:')
  WriteF('\d\n', req.number)

  req.file('FILE?')
  WriteF('\s\n', req.filebuf)
  WriteF('\s\n', req.dirbuf)


EXCEPT
  WriteF('no lib, sorry (base=\d).\n',reqtoolsbase)
ENDPROC
