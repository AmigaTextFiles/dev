
NAME
	JoinLists -- concatenate two exec lists.

SYNOPSIS
	JoinLists(dest,source)
	          a0   a1

FUNCTION
	Move all nodes in the source list to the end of the
	destination list, preserving their order.

INPUTS
	struct MinList *dest - The address of an exec list header.
		This can be either a MinList or a fully featured List.

	struct MinList *source - The address of an exec list header.
		This can be either a MinList or a fully featured List.

RESULT
	None

NOTES
	
SEE ALSO
	SortList(), SortedListInsert(), InsertNode(), MergeSortedLists()
