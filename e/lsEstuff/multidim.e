OPT MODULE

MODULE 'leifoo/nm'
MODULE 'leifoo/nmIList'



->this object is node and list at the same time

->funkar äntligen!! :))) 991025 cooooolt..

->nu funkar det inte..!! :) ..  gjort om lite..gör..

-> 991030 -> ny verr igen.. raderade det gamla..

->ser bra ut.. bara addMD() remMD(), findMD(), travMD()..

->explanation :
/* one object that is node and list at the same time..
   every object has an ID. there can be only ONE
   object with a sertain ID at one certain 'depth-level'.
   or : ChildObjects to a certain motherobject
   must have different ID's.. the mdAdd() does
   nothing if it finds an already existing object
   the same ID..
   M = mother
   C = Child

   Inherit your Mother and Child Objects
   from 'multidim'

      M
      |
      +--+
     / \  \
    C1 C2 C7    THIS IS OKEY
    |  |    \
    +  +     +--+
   / \  \     \  \
  C1 C5  C2   C2 C4

  To find C5 from mother (M) :
  c5ptr := mother.mdFind([1, 5]) (remember the [] !!)

  To add a C25 to C5 :
  c5ptr.mdAdd([25], NEW multidimptr)

  OR

  c5ptr.mdAdd([25], multidimobject)
  (old multidimobject.id (if any)
  gets overwritten with in this case, 25)

  OR

  mother.mdAdd([1, 5, 25], NEW c25ptr)

  NOTE! If u pass a path that doesnt exist
  to mdAdd() the path will be created!
  (nodes (OBJECT multidim) will be created to make the path)
  ex : mother.mdAdd([1, 5, 25, 32, 89], multidimobject) WILL WORK!
                     e  e  e   f   o
  e = exists
  f = fill
  o = the object that gets added


  To delete C5 :
  END c5ptr

  OR

  mother.mdRem([1, 5])

  OR

  c5ptr := mother.mdFind([1, 5])
  END c5ptr

  If u delete a node that has childs, the childs gets
  removed also !!

  So a 'END mother' ends it all...

  There is also a special traverse method
  that traverses every node beneth the node
  u specify by the elist argument..
  mdTrav([1], proc) would in this case
  call your procedure 'proc' twice ;
  for the C1 and C5 beneath M/C1..

  Prepare your proc for receiving
  the multidim_travObj OBJECT..
  The thischild field in it is a ptr
  to the actual node..
  the mother field is the mother of this node..

  If u want to give your proc some
  own arguments, allocate your own
  OBJECT inherited from multidim_travObj
  with additional fields and pass it to
  the traversemethod :
  mdTrav(list of nmbrs, proc, mytravobject)

  bla.mdTrav([], proc) Traverses all nodes beneath
  bla.


*/

/* inherit from this one */
EXPORT OBJECT multidim OF nmIList
ENDOBJECT

PROC getObjectName() OF multidim IS 'multidim'

PROC shrink_elist(elist:PTR TO LONG, len)
   DEF a
   len--
   FOR a := 1 TO len DO elist[a-1] := elist[a]
   SetList(elist, len - 1)
ENDPROC

EXPORT OBJECT multidim_travObj
   thischild:PTR TO multidim
   mother:PTR TO multidim
ENDOBJECT

EXPORT OBJECT mdv OF multidim
   value
ENDOBJECT

PROC getObjectName() OF mdv IS 'mdv'

PROC clone_elist(elist, len)
   DEF c
   c := List(len)
   ListCopy(c, elist)
ENDPROC c

PROC mdvSet(elist, value) OF mdv
   DEF mdv:PTR TO mdv
   mdv := self.mdFind(elist)
   IF mdv = NIL THEN self.mdAdd(elist, NEW mdv)
   IF StrCmp(mdv.getObjectName(), 'mdv') <> TRUE
      self.replace(mdv, NEW mdv)
   ENDIF
   mdv.value := value
ENDPROC

PROC mdvGet(elist) OF mdv
   DEF mdv:PTR TO mdv
   mdv := self.mdFind(elist)
ENDPROC IF mdv THEN mdv.value ELSE NIL

PROC mdAdd(elist, md:PTR TO multidim) OF multidim
   DEF elen
   DEF newmd:PTR TO multidim
   DEF elcopy:PTR TO LONG
   elen := ListLen(elist)
   elcopy := clone_elist(elist, elen)

   WHILE elen <> NIL
      elen := ListLen(elcopy)
      newmd := self.find(elcopy[])
      IF newmd = NIL
         IF elen = 1
            md.id := elcopy[]
            self.addLast(md)
            self := md
         ELSE
            NEW newmd
            newmd.id := elcopy[]
            self.addLast(newmd)
            self := newmd
         ENDIF
      ELSE
         self := newmd
      ENDIF
      shrink_elist(elcopy, elen)
   ENDWHILE

   DisposeLink(elcopy)
ENDPROC self

PROC mdRem(elist) OF multidim
   DEF md:PTR TO multidim
   md := self.mdFind(elist)
   IF md THEN END md
ENDPROC

PROC mdFind(elist) OF multidim
   DEF elen
   DEF elcopy:PTR TO LONG
   elen := ListLen(elist)
   elcopy := clone_elist(elist, elen)

   WHILE elen <> NIL
      elen := ListLen(elist)
      self := self.find(elcopy[])
      EXIT self = NIL
      shrink_elist(elcopy, elen)
   ENDWHILE

   DisposeLink(elcopy)
ENDPROC self

PROC mdReplace(elist, md:PTR TO multidim) OF multidim
   DEF oldmd:PTR TO multidim
   oldmd := self.mdFind(elist)
   IF oldmd = NIL THEN RETURN NIL
   oldmd.replace(oldmd, md)
   END oldmd
ENDPROC md

PROC mdTrav(elist, proc, obj=NIL) OF multidim
   DEF md:PTR TO multidim
   DEF mto:PTR TO multidim_travObj
   IF obj = NIL THEN NEW mto ELSE mto := obj
   mto.mother := self

   IF ListLen(elist) > 0 THEN md := self.mdFind(elist) ELSE md := self

   IF md = NIL
      END mto
      RETURN NIL
   ENDIF

   md := md.first()

   WHILE md
      mto.thischild := md
      proc(mto)
      md.mdTrav([], proc, mto)
      md := md.next
   ENDWHILE

   IF obj = NIL THEN END mto
ENDPROC TRUE



 
