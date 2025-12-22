#ifndef	GRAPHICS_GFXNODES_H
#define	GRAPHICS_GFXNODES_H

#ifndef EXEC_NODES_H
MODULE  'exec/nodes'
#endif
OBJECT ExtendedNode
	
		Succ:PTR TO Node
		Pred:PTR TO Node
Type:UBYTE
Pri:BYTE
Name:LONG
Subsystem:UBYTE
Subtype:UBYTE
Library:LONG
Init:LONG
ENDOBJECT

#define SS_GRAPHICS	$02
#define	VIEW_EXTRA_TYPE		1
#define	VIEWPORT_EXTRA_TYPE	2
#define	SPECIAL_MONITOR_TYPE	3
#define	MONITOR_SPEC_TYPE	4
#endif	
