/* simple requêtes ... */

OPT OSVERSION=37

PROC main()
  DEF r
  r:=request('Euh...','Voui|Pas question',NIL)
  request('Votre séléction: \d','Pourquoi y faire attention ...',[r])
ENDPROC

PROC request(body,gadgets,args)
ENDPROC EasyRequestArgs(0,[20,0,0,body,gadgets],0,args)
