
NAME
	InsertNode -- Insert a node into an exec list.

SYNOPSIS
	InsertNode(oldnode,newnode)
	           a0      a1

FUNCTION
	Insert a node into an exec list. The new node is inserted
	immediately before <oldnode>.

INPUTS
	struct MinNode *oldnode - This is the address of an exec list
		node which is already linked into an exec list. This
		can be either a MinNode or a fully featured Node.

	struct MinNode *newnode - This is the address of the exec list
		node to be inserted into the list. This can be either
		a MinNode or a fully featured Node.

RESULT
	None

NOTES
	It is permissable to pass a list header as <oldnode> instead
	of a list node. In this case the new node will be inserted
	at the end of the list.
	
SEE ALSO
	SortList(), SortedListInsert(), JoinLists(), MergeSortedLists()
