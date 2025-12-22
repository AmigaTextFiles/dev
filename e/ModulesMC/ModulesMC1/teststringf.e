MODULE '*interval' ,'*stringf20','*writef'
PROC  main()  HANDLE
DEF i, s[200]:STRING
writef( 'xxx%\c\l\s(3,5)xxx\l\z\h[5]\r\h[2]xxx\sxxx\c\n',
      ["Q",'ab',123,456,'def',"Q"])
WriteF('Starting to time StringF\n')
interval(TRUE)
FOR i:=1 TO 2000 DO StringF(s,
      'xxx%\c\l\s(3,5)xxx\l\z\h[5]\r\h[2]xxx\sxxx\c\n',
      "Q",'ab',123,456,'def',"Q")
WriteF('string is \s',s)
interval()
WriteF('Starting to time stringf\n')
FOR i:=1 TO 2000 DO stringf(s,
		    'xxx%\c\l\s(3,5)xxx\l\z\h[5]\r\h[2]xxx\sxxx\c\n',
		    ["Q",'ab',123,456,'def',"Q"])
WriteF('string is \s',s)
interval()
writef('binary 3,5,7,0 is xxx%lbxxx%-8.8lbxxx%08.8lbxxx%lbxxx\n',[3,5,7,0])
writef('xxx\l\d[20]xxx\r\z\d[20]xxx\n',[1,2])
writef('xxx\d[100]xxx\n',[1])
writef('xxx\dxxx\n',[-123456789])
EXCEPT
  IF exception>0 THEN WriteF(exception)
ENDPROC
