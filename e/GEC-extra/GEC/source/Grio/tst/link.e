MODULE 'grio/link'

PROC main()
DEF s1[10]:STRING,s2[10]:STRING,s3[10]:STRING,s4[10]:STRING
DEF co,s5[10]:STRING,r
StrCopy(s1,'one')
StrCopy(s2,'two')
StrCopy(s3,'three')
StrCopy(s4,'four')
StrCopy(s5,'five')
co:=Link(s1,s2)
Link(s2,s3)
Link(s3,s4)
show('all',co)
r:=gRemove({co},2)
show('removed from [2]',co)
show('removed item',r)
gInsert({co},r,0)
show('iserted in [0]',co)
gInsert({co},s5,3)
show('iserted in [3]',co)
gSwapItems({co},2,3)
show('swaped [2] [3]',co)
r:=gRemoveComplex({co},1,2)
show('removed complex from [1] size=2',co)
show('removed complex',r)
gInsertComplex({co},r,2)
show('iserted complex back at [2]',co)
WriteF('\n')
ENDPROC


PROC show(t,c)
DEF i=0,s

WriteF('\n\s\n',t)
WHILE s:=Forward(c,i)
   WriteF('[\d] = {\s}\n',i,s)
   INC i
ENDWHILE
ENDPROC
