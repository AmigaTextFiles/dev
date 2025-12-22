-> binary tree implementation in E
OBJECT bintree PRIVATE
  left:PTR TO bintree
  right:PTR TO bintree
ENDOBJECT         -> subclasses can add data here

PROC is_bigger(other:PTR TO bintree) OF bintree IS EMPTY
PROC is_equal(other:PTR TO bintree) OF bintree IS EMPTY

PROC bintree(l,r) OF bintree
  self.left:=l
  self.right:=r
ENDPROC

-> folds value v with proc through the tree.
PROC traverse(proc,v) OF bintree
  v:=proc(self,v)
  IF self.left THEN v:=self.left.traverse(proc,v)
  IF self.right THEN v:=self.right.traverse(proc,v)
ENDPROC v

/*-------------------------------------------------------*/

-> integer tree

OBJECT intbintree OF bintree
  i:LONG
ENDOBJECT

PROC intbintree(l,r,i) OF intbintree
  self.bintree(l,r)         -> call super constructor
  self.i:=i
ENDPROC

PROC is_bigger(other:PTR TO intbintree) OF intbintree IS self.i>other.i
PROC is_equal(other:PTR TO intbintree) OF intbintree IS self.i=other.i

PROC total() OF intbintree IS self.traverse({sum},0)
PROC sum(t:PTR TO intbintree,v) IS t.i+v

/*-------------------------------------------------------*/

-> string tree

OBJECT strbintree OF bintree
  s:PTR TO CHAR
ENDOBJECT

PROC is_bigger(other:PTR TO strbintree) OF strbintree IS EMPTY  ->???
PROC is_equal(other:PTR TO strbintree) OF strbintree IS StrCmp(self.s,other.s)

/*-------------------------------------------------------*/

PROC main()
  DEF p:PTR TO intbintree,p1:PTR TO intbintree,p2:PTR TO intbintree
  NEW p.intbintree(NEW p1.intbintree(NIL,NIL,2),NEW p2.intbintree(NIL,NIL,3),40)
  WriteF('total=\d\n',p.total())
ENDPROC
