
NAME
	BalanceTree -- Balance (optimise) a binary tee.

SYNOPSIS
	BalanceTree(tree)
	            a0

FUNCTION
	Rearrange the ordering of nodes within a binary tree to as
	to reduce the depth of the tree to a minimum. For example:

	BEFORE:
		    1
		     \
		      2
		       \
			3
			 \
			  4
			   \
			    5
			     \
			      6
			       \
				7			
	AFTER:
		    4
		   / \
		  /   \
		 /     \
		2	6
	       / \     / \
	      1   3   5   7

INPUTS
	struct TreeHeader *tree - The address of a binary tree header.

RESULT
	None
	
NOTES
	
SEE ALSO
	InitTree(), FindTreeNode(), AddTreeNode(), AddTreeNodeAll()
	RemoveTreeNode(), RemoveTreeNodeAll(), SortTree(),
	TreeNodeParent(), TreeNodeSuccessor(), TreeNodePredecessor(),
	ForEachTreeNode()
