PROC main()
  DEF i=9,j=99
  WHILE i-- DO IF Mod(j,i)=0 THEN IF i-- THEN i:=j-- ELSE WriteF('\d ',j)
ENDPROC
