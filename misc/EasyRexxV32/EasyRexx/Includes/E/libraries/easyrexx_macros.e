-> easyrexx_macros.e - source for easyrexx_macros.m
->
-> (C) 1994,1995 Ketil Hunn
->
-> Converted from C to E by Leon Woestenberg (leon@stack.urc.tue.nl)

OPT MODULE
OPT EXPORT
OPT PREPROCESS

#define ER_RecordPointer er_RecordPointer()

#define EASYREXXNAME 'easyrexx.library'
#define EASYREXXVERSION 3
#define ER_SHELLSIGNALS(c) (IF c.shell THEN Shl(1,c.shell.readport.sigbit) OR Shl(1,c.shell.commandwindow.userport.sigbit) ELSE 0)

#define ER_SIGNALS(c) (Shl(1,c.port.sigbit) OR \
                       Shl(1,c.asynchport.sigbit) OR \
                       ER_SHELLSIGNALS(c))
#define ER_SIGNAL(c) (IF c THEN ER_SIGNALS(c) ELSE 0)
#define ER_SAFETOQUIT(c) (IF c THEN (c.queue=0) ELSE 0)
#define ER_SETSIGNALS(c,s) IF c THEN c.signals:=s
#define ER_ISSHELLOPEN(c) (IF c.shell=NIL THEN 0 ELSE 1)

#define ARG(c,i) c.argv[i]
#define ARGNUMBER(c,i) c.argv[i]
#define ARGSTRING(c,i) c.argv[i]
#define ARGBOOL(c,i) (IF c.argv[i]=NIL THEN FALSE ELSE TRUE)

#define GETRC(c) (IF c THEN c.result1 ELSE NIL)
#define GETRESULT1(c) GETRC(c)
#define GETRESULT2(c) (IF c THEN c.result2 ELSE NIL)
#define TABLE_END NIL,NIL,NIL,NIL

