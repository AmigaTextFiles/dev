
MODULE 'grio/qsort'
MODULE 'grio/link'

DEF old


PROC main()
DEF s,co[50]:STRING
old:=StrCopy(co,'bla')
strlnk('gra')
strlnk('fuck')
strlnk('cos lub nic')
strlnk('jeden')
strlnk('drwa')
strlnk('hola')
strlnk('brrr')
strlnk('morze')
strlnk('zero')
strlnk('woda')
strlnk('dupcia')
strlnk('kolejny')
strlnk('xen')
strlnk('ivo')
strlnk('paczka')
strlnk('len')
strlnk('ufo')
WriteF('\nprzed sortowaniem\n-----------------------\n')
s:=show(co)
qsort({co},0,s-1,{comp},{swap})
WriteF('po sortowaniu\n----------------------\n')
show(co)
ENDPROC


RAISE "MEM" IF String()=0

PROC strlnk(text) HANDLE
DEF s
Link(old,StrCopy(s:=String(50),text))
old:=s
EXCEPT
IF exception="MEM" THEN WriteF('String() failed!\n')
ENDPROC


PROC show(c)
DEF i=0,s
WriteF('\n')
WHILE s:=Forward(c,i)
  INC i
  WriteF('[\d[2]] = {\s}\n',i,s)
ENDWHILE
WriteF('\n')
ENDPROC i


PROC comp(head,p1,p2) IS OstrCmp(Forward(^head,p1),Forward(^head,p2))


PROC swap(headptr,p1,p2) IS gSwapItems(headptr,p1,p2)


