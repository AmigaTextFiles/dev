#ifndef EXEC_LISTS_H
#define EXEC_LISTS_H

#ifndef EXEC_NODES_H
MODULE  'exec/nodes'
#endif 

OBJECT List
 
      Head:PTR TO Node
      Tail:PTR TO Node
      TailPred:PTR TO Node
   Type:UBYTE
   pad:UBYTE
ENDOBJECT

OBJECT MinList
 
      Head:PTR TO MinNode
      Tail:PTR TO MinNode
      TailPred:PTR TO MinNode
ENDOBJECT

#define IsListEmpty(x) \
	 ( ((x).lh_TailPred) =   (x) )
#define IsMsgPortEmpty(x) \
	 ( ((x).mp_MsgList.lh_TailPred) =   (&(x).mp_MsgList) )
#endif	
