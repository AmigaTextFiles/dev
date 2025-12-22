
NAME
	TreeNodeSuccessor -- Find the successor node of a given node

SYNOPSIS
	next = TreeNodeSuccessor(tree,node)
	d0,a0,Z                  a0   a1

FUNCTION
	Find the successor of a given node within a given tree,
	according to the tree's sort criteria.

INPUTS
	struct TreeHeader *tree - The address of a binary tree header.

	struct MinTreeNode *node - The address of a tree node. This
		may be either a MinTreeNode or a fully featured TreeNode.

RESULT
	struct MinTreeNode *next - The address of the successor node.
		This will be either a MinTreeNode or a fully featured
		TreeNode, depending on the source node.
	
SEE ALSO
	InitTree(), FindTreeNode(), AddTreeNode(), AddTreeNodeAll()
	RemoveTreeNode(), RemoveTreeNodeAll(), BalanceTree(),
	TreeNodeParent(), TreeNodePredecessor(), ForEachTreeNode()
