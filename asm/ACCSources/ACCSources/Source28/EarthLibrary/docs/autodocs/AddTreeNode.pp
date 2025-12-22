
NAME
	AddTreeNode -- Add a node to a binary tree

SYNOPSIS
	oldnode = AddTreeNode(tree,newnode,mode)
	d0,a0,Z               a0   a1      d0

FUNCTION
	Add a node to a binary tree. If a node already exists which
	compares as "equal" to the supplied newnode, using the tree's
	comparison criterion, then either remove the old node, or don't
	add the new one, depending on the supplied mode.

INPUTS
	struct TreeHeader *tree - The address of a binary tree header.

	struct MinTreeNode *newnode - The address of a binary tree node.
		This can be either a MinTreeNode or a fully featured
		TreeNode (although the lib supplied compare functions
		all require a full TreeNodes).

	BOOL mode - This value determines what happens when you
		attempt to add a node which already exists in the tree.
		(That is to say, when there exists a node which compares
		as "equal" to the new node). If mode is TRUE then the
		oldnode is unlinked from the tree, and the newnode is
		linked in its place. If mode is FALSE then the newnode
		is not added to the tree.

RESULT
	struct MinTreeNode *node - If an oldnode existed on the tree
		which was "equal" to the newnode, then this is its
		address. This oldnode may or may not have been unlinked,
		depending on the supplied node. If there was no matching
		oldnode then you get NULL here.

NOTES
	The mtn_Less and mtn_Greater fields of the newnode are
	ignored, and so may contain rubbish prior to this call.
	They will not, however, contain rubbish on return.

	For the convenience of assembler programmers, the return value
	is returned both in d0 and in a0. Furthermore, the zero flag
	will be set if there was no matching oldnode, or set if there
	was.

SEE ALSO
	InitTree(), FindTreeNode(), AddTreeNodeAll(),
	RemoveTreeNode(), RemoveTreeNodeAll(), TreeNodeParent(),
	TreeNodeSuccessor(), TreeNodePredecessor(),
	BalanceTree(), SortTree(), ForEachTreeNode()
