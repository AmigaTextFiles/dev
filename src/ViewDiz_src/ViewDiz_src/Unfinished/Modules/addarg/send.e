OBJECT modarg
  abe
  kat
ENDOBJECT

PROC main()
  DEF cmd[100]:STRING, a:PTR TO modarg
 
  a:=New(SIZEOF modarg)
  a.kat:=100
  a.abe:=String(10)
  StrCopy( a.abe, 'Mikael!!!' )

  StringF(cmd, 'rx recieve.rx \d', a )
  Execute(cmd,0,0)
ENDPROC
