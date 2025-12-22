
MODULE 'grio/str/strdup','grio/str/estrdup',
       'grio/str/strcat','grio/str/strcpy','grio/str/stricmp',
       'grio/str/decstr2num','grio/str/binstr2num','grio/str/hexstr2num',
       'grio/str/num2decstr','grio/str/num2hexstr','grio/str/num2binstr'
       


PROC main()

DEF str,x,buf[100]:STRING

IF str:=New(100)

   strcpy(str,'cos-niecos')

   strcat(str,' fuck')

   WriteF('\s\n',str)

   x:=strdup(str)

   WriteF('\s\n',x)

   num2DecStr(str,123456)

   WriteF('\s\n',str)

   num2HexStr(str,123456)

   WriteF('$\s\n',str)
   
   num2BinStr(str,123456)

   WriteF('%\s\n',str)
   
   StrCopy(buf,'cos nie tak co',ALL)
   
   x:=estrdup(buf)
   
   WriteF('\s\n',x)

   IF stricmp('fuck','FUCK') THEN WriteF('rozne\n')

ENDIF

ENDPROC
