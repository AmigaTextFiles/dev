
NAME
	SortTree -- Sort a binary tree

SYNOPSIS
	SortTree(tree)
	         a0

FUNCTION
	Rearrange the order of nodes within a tree such that the
	tree becomes sorted.

INPUTS
	struct TreeHeader *tree - The address of a binary tree header.

RESULT
	None
	
NOTES
	You will almost never need to call this function, since the
	trees maintained by earth.library are always sorted anyway.
	The only way to create an unsorted tree is by (mis)using the
	function AddTreeNodeAll(). SortTree() is merely provided for
	completeness.
	
SEE ALSO
	InitTree(), FindTreeNode(), AddTreeNode(), AddTreeNodeAll()
	RemoveTreeNode(), RemoveTreeNodeAll(), BalanceTree(),
	TreeNodeParent(), TreeNodeSuccessor(), TreeNodePredecessor(),
	ForEachTreeNode()
