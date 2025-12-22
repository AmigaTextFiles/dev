
NAME
	NodeNameICmp -- Compare two names by the tn_Name field with
		case insensitivity.

SYNOPSIS
	result = NodeNameICmp(node2,node1)
	d0,ccr                a2    a1

FUNCTION
	Compare two nodes using the node name as the comparison
	criterion. Note that this comparison will be case insensitive.

INPUTS
	APTR node2 - Any structure which starts with a struct TreeNode
	APTR node1 - Any structure which starts with a struct TreeNode

RESULT
	result - This will be:
		-1 if node2's name is less than node1's name
		 0 if node2's name is equal to node1's name
		 1 if node2's name is greater than node1's name

NOTES
	For the convenience of assembler programmers, the result of
	the comparison is also returned in the condition codes register.
	This will be one of:
		lt if node2's name is less than node1's name
		eq if node2's name is equal to node1's name
		gt if node2's name is greater than node1's name

SEE ALSO
	NodeNameCmp(), NodeValueCmp(), InitLibraryHook()

