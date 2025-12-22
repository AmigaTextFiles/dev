
NAME
	NodeValueCmp -- Compare two nodes by the tn_Value field.

SYNOPSIS
	result = NodePriCmp(node2,node1)
	d0,ccr              a2    a1

FUNCTION
	Compare two nodes using the tn_Value field as the comparison
	criterion.

INPUTS
	APTR node2 - Any structure which starts with a struct TreeNode
	APTR node1 - Any structure which starts with a struct TreeNode

RESULT
	result - This will be:
		negative if node2's value is less than node1's value;
		zero if node2's value is equal to node1's value;
		positive if node2's value is greater than node1's value.

NOTES
	For the convenience of assembler programmers, the result of
	the comparison is also returned in the condition codes register.
	This will be one of:
		lt if node2's value is less than node1's value
		eq if node2's value is equal to node1's value
		gt if node2's value is greater than node1's value

SEE ALSO
	NodeNameCmp(), NodeNameICmp(), InitLibraryHook()

