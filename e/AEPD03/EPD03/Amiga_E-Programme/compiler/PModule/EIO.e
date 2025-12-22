
PROC writeString(s)
     Fputs(code,s)
ENDPROC

PROC writeLn()
     FputC(code,10)
ENDPROC

PROC writeInt(c)
DEF s[10]:STRING
     StringF(s,'\d',c)
     writeString(s)
ENDPROC

PROC writeHex(c)
DEF s[10]:STRING
    StringF(s,'\h',c)
    writeString(s)
ENDPROC


