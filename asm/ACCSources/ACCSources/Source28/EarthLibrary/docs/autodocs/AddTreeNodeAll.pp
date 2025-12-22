
NAME
	AddTreeNodeAll -- Add a node with subnodes to a binary tree

SYNOPSIS
	oldnode = AddTreeNode(tree,newnode,reserved)
	d0,a0,Z               a0   a1      d0

FUNCTION
	Add a node with subnodes to a binary tree.

INPUTS
	struct TreeHeader *tree - The address of a binary tree header.

	struct MinTreeNode *newnode - The address of a binary tree node.
		This can be either a MinTreeNode or a fully featured
		TreeNode (although the lib supplied compare functions
		all require a full TreeNodes).

	LONG reserved - Pass zero here always.

RESULT
	None

NOTES
	Be VERY careful with this function, as it is quite possible
	to create an unsorted tree. In general, you will probably
	never need to use this function - it is used internally by
	other earth.library functions.

SEE ALSO
	InitTree(), FindTreeNode(), AddTreeNode(),
	RemoveTreeNode(), RemoveTreeNodeAll(), TreeNodeParent(),
	TreeNodeSuccessor(), TreeNodePredecessor(), BalanceTree(),
	SortTree(), ForEachTreeNode()
