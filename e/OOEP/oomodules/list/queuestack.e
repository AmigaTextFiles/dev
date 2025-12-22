OPT MODULE

MODULE 'oomodules/object'

EXPORT OBJECT qsnode OF object
 right:PTR TO qsnode
 left:PTR TO qsnode
 item
ENDOBJECT

EXPORT OBJECT queuestack OF object
 baditem
 mysize
 last:PTR TO qsnode
 first:PTR TO qsnode
ENDOBJECT

DEF tmp:PTR TO qsnode,moo:PTR TO LONG
EXPORT DEF ctrlc

EXPORT PROC name() OF qsnode IS 'QSNode'

EXPORT PROC size() OF qsnode IS 16

EXPORT PROC select(opts,i) OF qsnode
 DEF item
 item:=ListItem(opts,i)
 SELECT item
  CASE "set"
   INC i
   self.item:=ListItem(opts,i)
 ENDSELECT
ENDPROC i

EXPORT PROC inject(proc,item) OF qsnode
 self.item:=proc(self.item,item)
 IF ctrlc AND CtrlC() THEN Raise("^C")
 IF self.right THEN self.right.inject(proc,self.item)
ENDPROC

EXPORT PROC injectBackwards(proc,item) OF qsnode
 self.item:=proc(self.item,item)
 IF ctrlc AND CtrlC() THEN Raise("^C")
 IF self.left THEN self.left.injectBackwards(proc,self.item)
ENDPROC

EXPORT PROC do(proc) OF qsnode
 proc(self.item)
 IF ctrlc AND CtrlC() THEN Raise("^C")
 IF self.right THEN self.right.do(proc)
ENDPROC

EXPORT PROC doBackwards(proc) OF qsnode
 proc(self.item)
 IF ctrlc AND CtrlC() THEN Raise("^C")
 IF self.left THEN self.left.doBackwards(proc)
ENDPROC

EXPORT PROC collect(proc,add:PTR TO queuestack) OF qsnode
 add.addLast(proc(self.item))
 IF ctrlc AND CtrlC() THEN Raise("^C")
 IF self.right THEN self.right.collect(proc,add)
ENDPROC

EXPORT PROC collectBackwards(proc,add:PTR TO queuestack) OF qsnode
 add.addLast(proc(self.item))
 IF ctrlc AND CtrlC() THEN Raise("^C")
 IF self.left THEN self.left.collectBackwards(proc,add)
ENDPROC

EXPORT PROC conform(proc) OF qsnode
 IF ctrlc AND CtrlC() THEN Raise("^C")
 RETURN IF self.right THEN self.right.conform(proc) AND proc(self.item) ELSE proc(self.item)
ENDPROC

EXPORT PROC detect(proc,baditem) OF qsnode
 IF ctrlc AND CtrlC() THEN Raise("^C")
 RETURN IF proc(self.item) THEN self.item ELSE IF self.right THEN self.right.detect(proc,baditem) ELSE baditem
ENDPROC

EXPORT PROC detectBackwards(proc,baditem) OF qsnode
 IF ctrlc AND CtrlC() THEN Raise("^C")
 RETURN IF proc(self.item) THEN self.item ELSE IF self.left THEN self.left.detectBackwards(proc,baditem) ELSE baditem
ENDPROC

EXPORT PROC reject(proc,add:PTR TO queuestack) OF qsnode
 IF ctrlc AND CtrlC() THEN Raise("^C")
 IF proc(self.item)<>TRUE
  add.addLast(self.item)
 ENDIF
 IF self.right THEN self.right.reject(proc,add)
ENDPROC

EXPORT PROC rejectBackwards(proc,add:PTR TO queuestack) OF qsnode
 IF ctrlc AND CtrlC() THEN Raise("^C")
 IF proc(self.item)<>TRUE
  add.addLast(self.item)
 ENDIF
 IF self.left THEN self.left.rejectBackwards(proc,add)
ENDPROC

EXPORT PROC choose(proc,add:PTR TO queuestack) OF qsnode
 IF ctrlc AND CtrlC() THEN Raise("^C")
 IF proc(self.item)
  add.addLast(self.item)
 ENDIF
 IF self.right THEN self.right.choose(proc,add)
ENDPROC

EXPORT PROC chooseBackwards(proc,add:PTR TO queuestack) OF qsnode
 IF ctrlc AND CtrlC() THEN Raise("^C")
 IF proc(self.item)
  add.addLast(self.item)
 ENDIF
 IF self.left THEN self.left.choose(proc,add)
ENDPROC

EXPORT PROC end() OF qsnode
 tmp:=self.right
 IF tmp THEN END tmp
ENDPROC

EXPORT PROC size() OF queuestack IS 20

EXPORT PROC name() OF queuestack IS 'QueueStack'

EXPORT PROC select(opts,i) OF queuestack
 DEF item
 item:=ListItem(opts,i)
 SELECT item
  CASE "bad"
   INC i
   self.baditem:=ListItem(opts,i)
  CASE "set"
   INC i
   self.set(ListItem(opts,i))
 ENDSELECT
ENDPROC i

EXPORT PROC set(item) OF queuestack
 IF (item = self.baditem) AND (self.first = NIL) THEN RETURN
 IF self.first = NIL
  self.first := NEW tmp.new(["set",item])
  self.mysize := 1
  self.last:=self.first
 ELSE
  tmp:=self.first
  END tmp
  self.first:=0
  self.last:=0
 ENDIF
ENDPROC

EXPORT PROC addFirst(item) OF queuestack
 IF item = self.baditem THEN RETURN self.error({baditem})
 self.mysize:=self.mysize+1
 IF self.first = NIL
  self.first:=NEW tmp.new(["set",item])
  self.last:=self.first
 ELSE
  self.first.left := NEW tmp.new(["set",item])
  self.first.left.right:=self.first
  self.first := self.first.left
 ENDIF
ENDPROC

EXPORT PROC addLast(item) OF queuestack
 IF item = self.baditem THEN RETURN self.error({baditem})
 self.mysize:=self.mysize+1
 IF self.first = NIL
  self.first:=NEW tmp.new(["set",item])
  self.last:=self.first
 ELSE
  self.last.right := NEW tmp.new(["set",item])
  self.last.right.left:=self.last
  self.last := self.last.right
 ENDIF
ENDPROC

EXPORT PROC getFirst() OF queuestack
 DEF out=0
 IF self.mysize
  self.mysize:=self.mysize-1
  out:=self.first.item
  tmp:=self.first
  self.first:=self.first.right
  tmp.right:=0
  END tmp
  IF self.mysize = NIL
   self.first:=NIL
   self.last:=NIL
  ENDIF
 ELSE
  out:=FALSE
  Raise("qstk")
 ENDIF
ENDPROC out

EXPORT PROC getLast() OF queuestack
 DEF out=0
 IF self.mysize
  self.mysize:=self.mysize-1
  out:=self.last.item
  tmp:=self.last
  self.last:=self.last.left
  tmp.right := 0
  END tmp
  IF self.mysize = NIL
   self.first:=NIL
   self.last:=NIL
  ENDIF
 ELSE
  out:=FALSE
  Raise("qstk")
 ENDIF
ENDPROC out

EXPORT PROC length() OF queuestack IS self.mysize

EXPORT PROC addFirstQS(in:PTR TO queuestack) OF queuestack
 IF in.first
  self.first.left:=in.last
  in.last.right:=self.first
  self.mysize := self.mysize + in.mysize
  self.first := in.first
  in.mysize := 0
  in.first := NIL;in.last := NIL
 ENDIF
ENDPROC

EXPORT PROC addLastQS(in:PTR TO queuestack) OF queuestack
 IF in.first
  self.last.right:=in.first
  in.first.left:=self.last
  self.last := in.last
  self.mysize := self.mysize + in.mysize
  in.mysize := 0
  in.first := NIL; in.last := NIL
 ENDIF
ENDPROC

EXPORT PROC inject(proc,item=0) OF queuestack
 IF self.first THEN RETURN self.first.inject(proc,item)
ENDPROC

EXPORT PROC injectBackwards(proc,item=0) OF queuestack
 IF self.last THEN RETURN self.last.injectBackwards(proc,item)
ENDPROC

EXPORT PROC do(proc) OF queuestack
 IF self.first THEN self.first.do(proc)
ENDPROC

EXPORT PROC doBackwards(proc) OF queuestack
 IF self.last THEN self.last.doBackwards(proc)
ENDPROC

EXPORT PROC collect(proc) OF queuestack
 DEF add:PTR TO queuestack
 NEW add.new(["bad",[self.baditem]])
 IF self.first THEN self.first.collect(proc,add)
 RETURN add
ENDPROC

EXPORT PROC collectBackwards(proc) OF queuestack
 DEF add:PTR TO queuestack
 NEW add.new(["bad",[self.baditem]])
 IF self.last THEN self.last.collectBackwards(proc,add)
 RETURN add
ENDPROC

EXPORT PROC conform(proc) OF queuestack
 RETURN IF self.first THEN self.first.conform(proc) ELSE FALSE
ENDPROC

EXPORT PROC detect(proc) OF queuestack
 RETURN IF self.first THEN self.first.detect(proc,self.baditem) ELSE self.baditem
ENDPROC

EXPORT PROC detectBackwards(proc) OF queuestack
 RETURN IF self.last THEN self.last.detectBackwards(proc,self.baditem) ELSE self.baditem
ENDPROC

EXPORT PROC reject(proc) OF queuestack
 DEF add:PTR TO queuestack
 NEW add
 IF self.first THEN self.first.reject(proc,add)
 RETURN add
ENDPROC

EXPORT PROC rejectBackwards(proc) OF queuestack
 DEF add:PTR TO queuestack
 NEW add
 IF self.last THEN self.last.rejectBackwards(proc,add)
 RETURN add
ENDPROC

EXPORT PROC choose(proc) OF queuestack
 DEF add:PTR TO queuestack
 NEW add
 IF self.first THEN self.first.choose(proc,add)
 RETURN add
ENDPROC

EXPORT PROC chooseBackwards(proc) OF queuestack
 DEF add:PTR TO queuestack
 NEW add
 IF self.last THEN self.last.chooseBackwards(proc,add)
 RETURN add
ENDPROC

EXPORT PROC asList() OF queuestack
 moo:=List(self.length())
 self.do({makeList})
ENDPROC moo

EXPORT PROC asListBackwards() OF queuestack
 moo:=List(self.length())
 self.doBackwards({makeList})
ENDPROC

EXPORT PROC asQueueStack(in) OF queuestack
 DEF i,mytmp
 mytmp:=in
 WHILE mytmp
  FOR i:=0 TO ListLen(mytmp)-1
   IF ListItem(mytmp,i)<>self.baditem THEN self.addLast(ListItem(mytmp,i)) ELSE RETURN self.error({baditem})
  ENDFOR
  mytmp:=Next(mytmp)
 ENDWHILE
ENDPROC

EXPORT PROC asQueueStackBackwards(in) OF queuestack
 DEF i,mytmp
 mytmp:=in
 WHILE mytmp
  FOR i:=0 TO ListLen(mytmp)-1
   IF ListItem(mytmp,i)<>self.baditem THEN self.addFirst(ListItem(mytmp,i)) ELSE RETURN self.error({baditem})
  ENDFOR
  mytmp:=Next(mytmp)
  ENDWHILE
ENDPROC

EXPORT PROC error(text=0,opt=0) OF queuestack
 SELECT text
  CASE 0
   RETURN FALSE
  CASE {baditem}
   RETURN text
  CASE {queuestackempty}
   RETURN text
  DEFAULT
   RETURN SUPER self.error(text,opt)
 ENDSELECT
ENDPROC

EXPORT PROC kill() OF queuestack
 self.do({murder})
 self.end()
 self.first:=0
 self.last:=0
 self.mysize:=0
ENDPROC

EXPORT PROC end() OF queuestack
 tmp:=self.first
 END tmp
ENDPROC

PROC murder(i)
 END i
ENDPROC

PROC makeList(i)
 ListAdd(moo,[i,0],1)
ENDPROC

baditem:
 CHAR 'Bad item\n',0
queuestackempty:
 CHAR 'Empty\n',0
