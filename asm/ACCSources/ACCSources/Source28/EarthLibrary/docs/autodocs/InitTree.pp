
NAME
	InitTree -- Initialise a binary tree header.

SYNOPSIS
	InitTree(tree,hook)
	         a0   a1

FUNCTION
	Initialise a binary tree header, making it ready for use.
	(It is forbidden to use an uninitialised tree header). This
	function is analogous to exec.library's NewList() function.

INPUTS
	struct TreeHeader *tree - The address of a binary tree header.

	struct Hook *hook - This is the address of a callback hook
		which will be used as a function to compare two nodes.
		The comparison function will get called like this:

		result = comparefn(hook,node2,node1)
		d0                 a0   a2    a1

		INPUTS
			hook  - The hook itself
			node2 - Node for comparison
			node1 - Node for comparison

		RESULTS
			result - A value which is:
				negative if node2 is less than node1
				zero if node2 is equal to node1
				positive if node2 is greater than node1

RESULT
	None

NOTES
	Unlike exec lists, binary trees are ALWAYS sorted. Therefore,
	a comparison routine must be supplied.
	
	It is quite possible to supply several comparison functions in
	series. This is because the tree header contains an exec list
	header (a MinList) which contains a list of callback hooks. If
	a given hook decides that the two nodes are equal then the
	next hook in the list is called, and so on until the list is
	exhausted. This allows you to (for instance) compare first by
	name, then by some other field, then by some other field still.

	To achieve this, perhaps the easiest way is to call
	InitTree(tree,NULL), and then to use the exec AddTail()
	function (or macro) several times to link the sequence of
	hooks. Don't forget to pass the address of th_HookList to
	AddTail(), rather than the address of the tree header itself!

MORE NOTES
	Hooks are defined in the release 2.0 include files utility/hooks.h
	and utility/hooks.i. However, release 2.0 is NOT a requirement.
	If you do not have release 2.0+, then the structures will be
	defined in earth/earthbase.h and earth/earthbase.i.

SEE ALSO
	InitLibraryHook(),

	FindTreeNode(), AddTreeNode(), AddTreeNodeAll(),
	RemoveTreeNode(), RemoveTreeNodeAll(), TreeNodeParent(),
	TreeNodeSuccessor(), TreeNodePredecessor(), BalanceTree(),
	SortTree(), ForEachTreeNode()
