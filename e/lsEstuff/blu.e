PROC main()
   ->DEF a[1000]:LIST, b[10000]:STRING
   DEF a, b
   ->a := [1, 2, 3, 4, 5]
   ->b := 'hejsanhejsan'
   WriteF('LIST\n')
   WriteF('CHAR-1 : \d\n', Char(a-1))
   WriteF('CHAR-2 : \d\n', Char(a-2))
   WriteF('CHAR-3 : \d\n', Char(a-3))
   WriteF('CHAR-4 : \d\n', Char(a-4))
   WriteF('INT-2 : \d\n', Int(a-2))
   WriteF('INT-4 : \d\n', Int(a-4))
   WriteF('LONG-4 : \d\n', Long(a-4))
   WriteF('INT-6 : \d\n', Int(a-6))
   WriteF('STRING\n')
   WriteF('CHAR-1 : \d\n', Char(b-1))
   WriteF('CHAR-2 : \d\n', Char(b-2))
   WriteF('CHAR-3 : \d\n', Char(a-3))
   WriteF('CHAR-4 : \d\n', Char(a-4))
   WriteF('INT-2 : \d\n', Int(b-2))
   WriteF('INT-4 : \d\n', Int(b-4))
   WriteF('LONG-4 : \d\n', Long(b-4))
   WriteF('INT-6 : \d\n', Int(b-6))
   WriteF('\d\n', EstrLen('hejhej'))
ENDPROC

/*
DEF static list : INT - 4
DEF static string : INT - 4
List() : INT - 4
String() : INT - 4
[1, 2, 3, 4] : INT - 2
'blabla' är inte en estring!
*/


