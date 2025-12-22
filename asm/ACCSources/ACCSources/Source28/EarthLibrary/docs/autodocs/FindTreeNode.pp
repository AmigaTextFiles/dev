
NAME
	FindTreeNode -- Locate a node within a binary tree

SYNOPSIS
	node = FindTreeNode(tree,newnode)
	d0,Z                a0   a1

FUNCTION
	Attempt to locate a node on the specified binary tree which
	compares as "equal" to the supplied newnode, using the tree's
	comparison criterion.

INPUTS
	struct TreeHeader *tree - The address of a binary tree header.

	struct MinTreeNode *newnode - The address of a binary tree node.
		This can be either a MinTreeNode or a fully featured
		TreeNode (although the lib supplied compare functions
		all require a full TreeNodes).

RESULT
	struct MinTreeNode *node - The node located on the tree, or
		NULL if no such node was found.

EXAMPLE
	Suppose you had a binary tree which was sorted by name, using
	the ln_Name field. Suppose you wished to know whether or not
	there was a node called "fred" on the tree. The easiest way to
	answer this question is to construct a "fake" tree node,
	as follows:

	lea.l	-tn_SIZE(sp),sp		Create fake tree node on stack
	move.l	#M_fred,tn_Name(sp)	Set name of fake node
	move.l	tree(_data),a0		a0 = address of tree
	move.l	sp,a1			a1 = address of fake node
	BSREARTH FindTreeNode
	lea.l	tn_SIZE(sp),sp		Delete fake node
	...
M_fred	dc.b	"fred",0

NOTES
	For the convenience of assembly programmers, the zero flag
	will be set if the node was not found, or reset if it was.
	
SEE ALSO
	InitTree(), AddTreeNode(), AddTreeNodeAll(),
	RemoveTreeNode(), RemoveTreeNodeAll(), TreeNodeParent(),
	TreeNodeSuccessor(), TreeNodePredecessor(), BalanceTree(),
	SortTree(), ForEachTreeNode()
