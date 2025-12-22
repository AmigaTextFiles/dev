
NAME
	TreeNodeParent -- Find the parent node of a given node

SYNOPSIS
	parent = TreeNodeParent(tree,node)
	d0,a0,Z                 a0   a1

FUNCTION
	Find the parent of a given node within a given tree.

INPUTS
	struct TreeHeader *tree - The address of a binary tree header.

	struct MinTreeNode *node - The address of a tree node. This
		may be either a MinTreeNode or a fully featured TreeNode.

RESULT
	struct MinTreeNode *parent - The address of the parent node.
		This will be either a MinTreeNode or a fully featured
		TreeNode, depending on the source node.

		If the node has no parent then the function will
		return NULL.
	
SEE ALSO
	InitTree(), FindTreeNode(), AddTreeNode(), AddTreeNodeAll()
	RemoveTreeNode(), RemoveTreeNodeAll(), BalanceTree(),
	TreeNodeSuccessor(), TreeNodePredecessor(), ForEachTreeNode()
