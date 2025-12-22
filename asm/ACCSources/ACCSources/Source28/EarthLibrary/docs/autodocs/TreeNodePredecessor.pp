
NAME
	TreeNodePredecessor -- Find the predecessor node of a given node

SYNOPSIS
	prev = TreeNodePredecessor(tree,node)
	d0,a0,Z                    a0   a1

FUNCTION
	Find the predecessor of a given node within a given tree,
	according to the tree's sort criteria.

INPUTS
	struct TreeHeader *tree - The address of a binary tree header.

	struct MinTreeNode *node - The address of a tree node. This
		may be either a MinTreeNode or a fully featured TreeNode.

RESULT
	struct MinTreeNode *prev - The address of the predecessor node.
		This will be either a MinTreeNode or a fully featured
		TreeNode, depending on the source node.
	
SEE ALSO
	InitTree(), FindTreeNode(), AddTreeNode(), AddTreeNodeAll()
	RemoveTreeNode(), RemoveTreeNodeAll(), BalanceTree(),
	TreeNodeParent(), TreeNodeSuccessor(), ForEachTreeNode()
