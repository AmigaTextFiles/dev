OPT MODULE

MODULE 'myoo/xl'

OBJECT xnode OF xni
   ylist:PTR TO xli
ENDOBJECT

OBJECT ynode OF xni
   zlist:PTR TO xli
ENDOBJECT

OBJECT znode OF xni
   value
ENDOBJECT

EXPORT OBJECT d3da
   PRIVATE
   xlist:PTR TO xli
   unsetvalue
ENDOBJECT

PROC d3da(unsetvalue=NIL) OF d3da
   NEW self.xlist
   self.unsetvalue:=unsetvalue
ENDPROC

PROC end() OF d3da
   DEF xnode:PTR TO xnode,
       ynode:PTR TO ynode,
       znode:PTR TO znode,
       nextx, nexty, nextz
   xnode:=self.xlist.first()
   WHILE xnode
      ynode:=xnode.ylist.first()
      WHILE ynode
         znode:=ynode.zlist.first()
         WHILE znode
            nextz:=znode.next
            FastDispose(znode, SIZEOF znode)
            znode:=nextz
         ENDWHILE
         nexty:=ynode.next
         END ynode.zlist
         FastDispose(ynode, SIZEOF ynode)
         ynode:=nexty
      ENDWHILE
      nextx:=xnode.next
      END xnode.ylist
      FastDispose(xnode, SIZEOF xnode)
      xnode:=nextx
   ENDWHILE 
   END self.xlist
ENDPROC

PROC set(x, y, z, value) OF d3da
   DEF xnode:PTR TO xnode, ynode:PTR TO ynode, znode:PTR TO znode
   xnode:=self.xlist.find(x)
   IF xnode = NIL
      xnode:=FastNew(SIZEOF xnode)
      xnode.id:=x
      NEW xnode.ylist
      self.xlist.addtail(xnode)
   ENDIF
   ynode:=xnode.ylist.find(y)
   IF ynode = NIL
      ynode:=FastNew(SIZEOF ynode)
      ynode.id:=y
      NEW ynode.zlist
      xnode.ylist.addtail(ynode)
   ENDIF
   znode:=ynode.zlist.find(z)
   IF znode = NIL
      znode:=FastNew(SIZEOF znode)
      znode.id:=z
      ynode.zlist.addtail(znode)
   ENDIF
   znode.value:=value
ENDPROC

PROC unset(x, y, z) OF d3da
   DEF xnode:PTR TO xnode, ynode:PTR TO ynode, znode:PTR TO znode
   xnode:=self.xlist.find(x)
   IF xnode = NIL THEN RETURN NIL
   ynode:=xnode.ylist.find(y)
   IF ynode = NIL THEN RETURN NIL
   znode:=ynode.zlist.find(z)
   IF znode = NIL THEN RETURN NIL
   ynode.zlist.remove(znode)
   FastDispose(znode, SIZEOF znode)
   IF ynode.zlist.count()=NIL
      xnode.ylist.remove(ynode)
      END ynode.zlist
      FastDispose(ynode, SIZEOF ynode)
   ENDIF
   IF xnode.ylist.count()=NIL
      self.xlist.remove(xnode)
      END xnode.ylist
      FastDispose(xnode, SIZEOF xnode)
   ENDIF
ENDPROC

PROC get(x, y, z) OF d3da
   DEF xnode:PTR TO xnode, ynode:PTR TO ynode, znode:PTR TO znode
   xnode:=self.xlist.find(x)
   IF x = NIL THEN RETURN self.unsetvalue
   ynode:=xnode.ylist.find(y)
   IF y = NIL THEN RETURN self.unsetvalue
   znode:=ynode.zlist.find(z)
   IF z = NIL THEN RETURN self.unsetvalue
ENDPROC znode.value





