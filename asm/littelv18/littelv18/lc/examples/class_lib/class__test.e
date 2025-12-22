MODULE '*class'
MODULE 'utility/hooks'

RAISE "LIB" IF OpenLibrary()=NIL,
      "ADM" IF Cl_AddMethod()=NIL

OBJECT myobj
   class
   x
   y
ENDOBJECT

CONST CLM_MYMETHOD=10

PROC main() HANDLE
   DEF a4, obj=NIL, class=NIL

   LEA a4store(PC), A0
   MOVE.L A4, (A0)

   classbase := OpenLibrary('class.library', 37)
   WriteF('opened library \h\n', classbase)
   class := Cl_NewClass('myclass', SIZEOF myobj, CLM_MYMETHOD, NIL, NIL)
   WriteF('Newed Class \h\n', class)
   IF (class < 1) THEN Raise("NCL")
   Cl_AddMethod(class, CLM_MYMETHOD, {entry}, {mymethod}, NIL)
   WriteF('Added Method \n')
   obj := Cl_NewObject(class)
   WriteF('Newed Object \h\n', obj)
   IF (obj < 1) THEN Raise("NOB")
   Cl_DoMethod(obj, CLM_MYMETHOD, NIL)
   WriteF('Did Method \n')
EXCEPT DO
   SELECT exception
   CASE "LIB"
      WriteF('couldnt open library\n')
   CASE "NCL"
      WriteF('couldnt NewClass : \d\n', class)
   CASE "ACL"
      WriteF('couldnt AddClass : \n')
   CASE "NOB"
      WriteF('couldnt NewObject : \d\n', obj)
   CASE "ADM"
      WriteF('couldnt AddMethod \n')
   ENDSELECT
   IF obj > NIL THEN Cl_EndObject(obj)
   WriteF('ending class\n', obj)
   IF class > NIL THEN Cl_EndClass(class)
   WriteF('closing library\n', obj)
   IF classbase > NIL THEN CloseLibrary(classbase)
ENDPROC

PROC mymethod(obj, args)
   WriteF('mymethod : HI THERE!\n')  -> needs A4
ENDPROC NIL



entry:

   /* get A4 */
   LEA a4store(PC), A3
   MOVE.L (A3), A4

   /* push params */
   MOVE.L A1, -(A7) ->args
   MOVE.L A2, -(A7) ->obj

   /* call our method */
   MOVE.L 12(A0), A0
   JSR (A0)

   /* fix stack */
   LEA 8(A7), A7

   /* return */
   RTS

a4store:
LONG 0


