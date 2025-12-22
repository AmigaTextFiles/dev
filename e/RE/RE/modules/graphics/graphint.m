#ifndef	GRAPHICS_GRAPHINT_H
#define	GRAPHICS_GRAPHINT_H

#ifndef EXEC_NODES_H
MODULE  'exec/nodes'
#endif

OBJECT Isrvstr

      Node:Node
      Iptr:PTR TO Isrvstr   
    code:LONG
    ccode:LONG
    Carg:LONG
ENDOBJECT

#endif	
