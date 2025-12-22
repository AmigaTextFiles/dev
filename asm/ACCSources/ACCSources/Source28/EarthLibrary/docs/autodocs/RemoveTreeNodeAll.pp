
NAME
	RemoveTreeNodeAll -- Remove a node and all of its subnodes
		from a binary tree

SYNOPSIS
	RemoveTreeNode(tree,node)
	               a0   a1

FUNCTION
	Remove a node and all of its subnodes from a binary tree.

INPUTS
	struct TreeHeader *tree - The address of a binary tree header.

	struct MinTreeNode *newnode - The address of a binary tree node.
		This can be either a MinTreeNode or a fully featured
		TreeNode (although the lib supplied compare functions
		all require a full TreeNodes). This MUST be a node on
		the specified tree.

RESULT
	None

NOTES
	Once disconnected, the node will have its subnodes still
	attached. It is then your responsibility to keep track of
	all the subnodes and to ensure that all memory allocated for
	these nodes eventually gets freed.

SEE ALSO
	InitTree(), FindTreeNode(), AddTreeNode(), AddTreeNodeAll()
	RemoveTreeNode(), BalanceTree(), SortTree(),
	TreeNodeParent(), TreeNodeSuccessor(), TreeNodePredecessor(),
	ForEachTreeNode()
