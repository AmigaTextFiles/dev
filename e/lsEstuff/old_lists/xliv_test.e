MODULE '*xliv'

PROC main()
   DEF ml:PTR TO xliv
   DEF ml2:PTR TO xliv
   DEF a
   DEF cpobj:xliv_CPObj

   NEW ml
   NEW ml2


   FOR a := 19 TO 0 STEP -1 DO ml.aSet(19-a, a)
   ml.trav({printnode}, cpobj) ; WriteF('\n')

   FOR a := 0 TO 19 STEP 2 DO ml2.aSet(a, a)
   ml2.trav({printnode}, cpobj) ; WriteF('\n')

   ml.aApplyAve(ml2)
   ml.trav({printnode}, cpobj) ; WriteF('\n')

   END ml
ENDPROC

PROC printnode(cpobj:PTR TO xliv_CPObj)
   DEF n:PTR TO xniv
   n := cpobj.node
   WriteF('\d[2]', n.value)
ENDPROC
