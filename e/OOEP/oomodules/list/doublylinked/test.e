/*

This is the original example program of the module that is now
oomodules/list/doublylinked. I didn't change a single byte.

Gregor Goldbach 95/7/3

Added WriteF() of length.

Gregor Goldbach 95/9/10

*/

/*=== EXAMPLE PROGRAM ===*/

MODULE 'oomodules/list/doublylinked'

OBJECT mynode OF dlln
  string
ENDOBJECT

OBJECT mylist OF dllh
ENDOBJECT

PROC new(string) OF mynode
  DEF len
  self.string:=StrCopy(String(len:=StrLen(string)), string, len)
ENDPROC

PROC end() OF mynode
  DisposeLink(self.string)
ENDPROC

PROC clear() OF mylist
  DEF node:PTR TO mynode
  WHILE self.isEmpty()=FALSE
    node:=self.remHead()
    END node
  ENDWHILE
ENDPROC

PROC insertAlphaSorted(node:PTR TO mynode) OF mylist
  DEF listnode:PTR TO mynode, done=FALSE
  listnode:=self.firstNode() ->returns lastnode or tail
  REPEAT
    IF listnode=self.tail
      done:=TRUE
    ELSEIF OstrCmp(node.string, listnode.string)>=0
      done:=TRUE
    ELSE
      listnode:=listnode.succ
    ENDIF
  UNTIL done
  self.insert(node, listnode.pred)
ENDPROC

PROC printAll() OF mylist
  DEF node:PTR TO mynode
  IF self.isEmpty()
    WriteF('*** List is empty\n')
    RETURN
  ENDIF
  node:=self.firstNode()
  WHILE node<>self.tail
    WriteF('\s\n', node.string)
    node:=node.succ
  ENDWHILE
ENDPROC


PROC main() HANDLE
  DEF l:PTR TO mylist, n:PTR TO mynode
  NEW l.new()
  l.insertAlphaSorted(NEW n.new('AC/DC'))
  l.insertAlphaSorted(NEW n.new('Megadeth'))
  l.insertAlphaSorted(NEW n.new('Alice in Chains'))
  l.insertAlphaSorted(NEW n.new('Metallica'))

EXCEPT DO
  IF exception THEN WriteF('Error occurred during initialization\n')
  IF l
    l.printAll()
    WriteF('\nThe list contains \d items.\n', l.length())
    l.clear()
    END l
  ENDIF
ENDPROC
