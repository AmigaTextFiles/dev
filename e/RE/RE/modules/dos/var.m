#ifndef DOS_VAR_H
#define DOS_VAR_H

#ifndef EXEC_NODES_H
MODULE  'exec/nodes'
#endif




OBJECT LocalVar
 
	  Node:Node
	Flags:UWORD
	Value:PTR TO UBYTE
	Len:LONG
ENDOBJECT



#define LV_VAR			0	
#define LV_ALIAS		1	

#define LVB_IGNORE		7	
#define LVF_IGNORE		$80



#define GVB_GLOBAL_ONLY		8
#define GVF_GLOBAL_ONLY		$100
#define GVB_LOCAL_ONLY		9
#define GVF_LOCAL_ONLY		$200
#define GVB_BINARY_VAR		10		
#define GVF_BINARY_VAR		$400
#define GVB_DONT_NULL_TERM	11	
#define GVF_DONT_NULL_TERM	$800


#define GVB_SAVE_VAR		12	
#define GVF_SAVE_VAR		$1000
#endif 
