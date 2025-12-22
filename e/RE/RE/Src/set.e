/*
*/
->OPT MODULE  -> Define class 'set' in a module
->OPT EXPORT  -> Export everything

/* The data for the class */
OBJECT set PRIVATE  -> Make all the data private
  elements:PTR TO LONG
  maxsize, size
ENDOBJECT

/* Creation constructor */
/* Minimum size of 1, maximum 100000, default 100 */
PROC create(sz=100) OF set
  ->DEF p:PTR TO LONG
  IF (sz>0) AND (sz<100000) -> Check size
    self.maxsize:=sz
  ELSE
    self.maxsize:=100
  ENDIF
  self.elements:=AllocVec(self.maxsize*SIZEOF LONG,$10005)->NEW p[self.maxsize]
ENDPROC

/* Copy constructor */
PROC copy(oldset:PTR TO set) OF set
  DEF i
  self.create(oldset.maxsize)  -> Call create method!
  FOR i:=0 TO oldset.size-1  -> Copy elements
    self.elements[i]:=oldset.elements[i]
  ENDFOR
  self.size:=oldset.size
ENDPROC

/* Destructor */
PROC end() OF set
  ->DEF p:PTR TO LONG
  IF self.maxsize<>0  -> Check that it was allocated
    FreeVec(self.elements)
    /*p:=self.elements
    END p[self.maxsize]*/
  ENDIF
ENDPROC

/* Add an element */
PROC add(x) OF set
  IF self.member(x)=FALSE  -> Is it new? (Call member method!)
    IF self.size=self.maxsize
      Raise("full")  -> The set is already full
    ELSE
      self.elements[self.size]:=x
      self.size:=self.size+1
    ENDIF
  ENDIF
ENDPROC

/* Test for membership */
PROC member(x) OF set
  DEF i
  FOR i:=0 TO self.size-1
    IF self.elements[i]=x THEN RETURN TRUE
  ENDFOR
ENDPROC FALSE

/* Test for emptiness */
PROC empty() OF set IS self.size=0

/* Union (add) another set */
PROC union(other:PTR TO set) OF set
  DEF i
  FOR i:=0 TO other.size-1
    self.add(other.elements[i])  -> Call add method!
  ENDFOR
ENDPROC

/* Print out the contents */
PROC print() OF set
  DEF i
  WriteF('{ ')
  FOR i:=0 TO self.size-1
    WriteF('\d ', self.elements[i])
  ENDFOR
  WriteF('}')
ENDPROC

PROC main() HANDLE
  DEF s=NIL:PTR TO set
  NEW s.create(20)
  s.add(1)
  s.add(-13)
  s.add(91)
  s.add(42)
  s.add(-76)
  IF s.member(1) THEN WriteF('1 is a member\n')
  WriteF('11 is \s a member\n',IF s.member(11) THEN '' ELSE 'not')
  WriteF('s = ')
  s.print()
  WriteF('\n')
EXCEPT DO
  END s
  SELECT exception
  CASE "NEW"
    WriteF('Out of memory\n')
  CASE "full"
    WriteF('Set is full\n')
  ENDSELECT
ENDPROC
