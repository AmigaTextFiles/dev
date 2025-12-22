
NAME
	ForEachTreeNode -- Call a function for each node in a tree.

SYNOPSIS
	failcode = ForEachTreeNode(tree,userfunc,userdata,order)
	d0                         a0   a1       a2       d0

FUNCTION
	Call the specified <userfunc> function once for each node in
	a tree. This continues until either the user-function returns
	a non-zero return value, or there are no more nodes in the
	tree.

INPUTS
	struct TreeHeader *tree - The address of tree header.

	LONG (*userfunc)() - The address of a function supplied by the
		user. This function will be called like this:

		failcode = userfunc(node,userdata,depth)
		d0                  a0   a2       d0

		INPUTS
			struct TreeNode *node - The address of a tree
				node. This may be either a MinTreeNode
				or a TreeNode.

			LONG userdata - For any purpose. See below.

			ULONG depth - The depth of the node within the
				tree. The root node has depth zero;
				children of the root node have depth
				one; grandchildren of the root node
				have depth two; and so on.

			ULONG order - A constant which specifies the
				order in which you would like the nodes
				to be processed. Legitimate values are:

				ORDER_DEPTHFIRST
					Process child nodes before parent
					nodes. Useful for functions to
					delete tree nodes, etc.
				ORDER_DEPTHLAST
					Process parent node before child
					nodes. Useful for functions to
					print tree nodes, etc.
				ORDER_ASCENDING
					Process nodes in ascending order.
				ORDER_DESCENDING
					Process nodes in descending order.

		RESULTS
			LONG failcode - Zero for success, non-zero
				for failure.

		You can write this function either in 'C' or assembler.
		You will find the entry parameters BOTH on the stack
		(for 'C' programmers) AND in registers (for assembler
		programmers). Your function should return zero if all
		went well, or non-zero to abort ForEachArgument().

	ULONG userdata - Any value whatsoever. This value will be
		passed through to the user function.

RESULT
	ULONG failcode - If all calls to the user-function succeeded
		then this will be zero, otherwise it will be the
		failcode returned by the user-function which failed.
	
SEE ALSO
	InitTree(), FindTreeNode(), AddTreeNode(), AddTreeNodeAll(),
	RemoveTreeNode(), RemoveTreeNodeAll(), TreeNodeParent(),
	TreeNodeSuccessor(), TreeNodePredecessor(), BalanceTree(),
	SortTree()
