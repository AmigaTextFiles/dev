OPT MODULE

MODULE 'leifoo/nm'
MODULE 'leifoo/nmIList'
MODULE 'leifoo/nmList'
MODULE 'mymods/bits'
MODULE 'leifoo/elements'


EXPORT OBJECT network
   elements:PTR TO nmIList
   user_connects:PTR TO nmList
   user_assigns:PTR TO nmList
ENDOBJECT

PROC applyAssigns() OF network
   DEF a:PTR TO user_assign
   DEF e:PTR TO element
   a := self.user_assigns.first()
   WHILE a
      e := self.elements.find(a.toelementID)
      IF e THEN e.setInputLevel(a.toinput, a.level)
      a .= a.next
   ENDWHILE
ENDPROC


EXPORT OBJECT user_assign OF nm
   toelementID
   level
   toinput:INT
ENDOBJECT



EXPORT OBJECT user_connect OF nm
   fromelementID
   toelementID
   toinput:INT
ENDOBJECT


PROC connectElements() OF network
   DEF con:PTR TO user_connect
   DEF fe:PTR TO element
   DEF te
   self.disconnectElements()
   con := self.user_connects.first()
   WHILE con
      fe := self.elements.find(con.fromelementID)
      IF fe
         te := self.elements.find(con.toelementID)
         IF te
            fe.setTransfer(te, con.toinput)
         ENDIF
      ENDIF
   ENDWHILE
ENDPROC

PROC disconnectElements() OF network
   DEF e:PTR TO element
   e := self.elements.first()
   WHILE e
      e.clearTransfers()
      e := e.next
   ENDWHILE
ENDPROC
