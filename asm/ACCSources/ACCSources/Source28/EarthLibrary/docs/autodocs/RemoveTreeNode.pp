
NAME
	RemoveTreeNode -- Remove a node from a binary tree

SYNOPSIS
	RemoveTreeNode(tree,node)
	               a0   a1

FUNCTION
	Remove a node from a binary tree. Any subnodes of the
		specified node will remain connected to the tree.

INPUTS
	struct TreeHeader *tree - The address of a binary tree header.

	struct MinTreeNode *newnode - The address of a binary tree node.
		This can be either a MinTreeNode or a fully featured
		TreeNode (although the lib supplied compare functions
		all require a full TreeNodes). This MUST be a node on
		the supplied tree.

RESULT
	None

NOTES
	The specified node is completely unlinked from the tree. Any
	subnodes are unlinked from the node and then linked back into
	the tree. On return, the specified node will have its mtn_Less
	and mtn_Greater fields both cleared to NULL.

SEE ALSO
	InitTree(), FindTreeNode(), AddTreeNode(), AddTreeNodeAll()
	RemoveTreeNodeAll(), SortTree(), BalanceTree(),
	TreeNodeParent(), TreeNodeSuccessor(), TreeNodePredecessor(),
	ForEachTreeNode()
