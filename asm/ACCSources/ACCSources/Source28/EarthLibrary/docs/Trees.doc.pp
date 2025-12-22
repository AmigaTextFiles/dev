
BINARY TREES
~~~~~~~~~~~~

A binary tree is a method of organising structures in order to make
look-up extremely rapid. For instance, suppose you had a thousand
structures linked together in the form of an exec linked list. In the
worst possible case, it could take one thousand comparisons to locate
a node within the list. By contrast, if the structures were linked
together in the form of a balanced binary tree then even in the very
worst possible case it would only take ten comparisons.

The principle of a binary tree is very simple. Instead of being linked
together in a linear chain, each node has two descendants, called the
"left child" and the "right child". For example:

			4
                       / \
		      /   \
		     /     \
		    9       8
		   / \     / \
		  2   7   3   1

Now, the above example is not very useful because the tree is unsorted.
The binary tree structures maintained by "earth.library" are always
sorted. It is precisely because we use sorted trees that look-up can
be made so rapid. If the above example were sorted, it could look like
this:

		        4
		       / \
		      /   \
		     /	   \
		    2       9
		   / \     /
		  1   3   7
		           \
			    8

A sorted tree is a tree in which the left child, and every descendant
thereof, is less than the parent node, and in which the right child,
and every descendant thereof, is greater than the parent node. You can
see that the above example follows this rule, however, even this is
not as good as it could be. For example, to locate the "8" node would
take four comparisons (4,9,7,8). Now consider the following tree:

			4
		       / \
		      /   \
		     /     \
		    2       7
		   / \     / \
		  1   3   8   9

This contains exactly the same nodes as before, but they are organised
more efficiently. The tree is said to be "balanced", which means that
its depth is the minimum possible. Now to locate the "8" node would
take only three comparisons (4,7,8).

The trees created by "earth.library" are always sorted, but not
necessarily balanced. To make the trees more efficient, we therefore
supply the function BalanceTree() which as its name suggests will
optimise a tree by balancing it.

WHAT IS A TREE NODE?
~~~~~~~~~~~~~~~~~~~~

Each node in a tree is defined by a structure. You can define this
structure yourself, but it must BEGIN with either a struct TreeNode,
or a struct MinTreeNode. Both of these structures are defined in
"earth/earthbase.h" and "earth/earthbase.i".

A TreeNode structure looks like this:

struct TreeNode
{
  struct TreeNode	*tn_Less;	/* Address of less-than node */
  struct TreeNode	*tn_Greater;	/* Address of greater-than node */
  union
  {
    ULONG		tnu_Value;	/* Node value */
    char		*tnu_Name;	/* Node name */
  }			tn_Union;
};

#define tn_Value	tn_Union.tnu_Value
#define tn_Name		tn_Union.tnu_Name

This is a structure with three elements. The first two structures
(tn_Less and tn_Greater) represent the connections to the child nodes.
If either of these fields contain NULL then it means that the node
has no child on that side.

The third element can be called either tn_Value or tn_Name, depending
on its usage. This is possible because the third element is declared
as a union.

If you call it tn_Value, then it contains a longword integer value,
which can be used as the sort criterion for sorting the tree.

If you call it tn_Name, then it contains the address of a null-terminated
string representing the name of the node. In this case you can use the
name itself as the sort criterion, and the sort can be either case-
sensitive or case-insensitive.

A struct MinTreeNode is a shorter structure, having only two elements,
thus:

struct MinTreeNode
{
  struct MinTreeNode	*tn_Less;	/* Address of less-than node */
  struct MinTreeNode	*tn_Greater;	/* Address of greater-than node */
};

In this case the tn_Value (alias tn_Name) field is omitted. In this
case you must supply a sort criterion explicitly, which will presumably
be based on additional fields in your node's full structure.

In fact, since a MinTreeNode is exactly the same size as an exec
MinNode structure, it is quite possible to link the same structure into
either a list or a tree, and to move that structure back and forth
between the two.

THE SORT CRITERIA
~~~~~~~~~~~~~~~~~

In order to search a binary tree, the library needs to know how to
"compare" two nodes. Therefore, each tree has a "comparison" function
with which it will compare nodes. For a fully-featured TreeNode there
are three "earth.library" functions available, which will suffice as
comparison functions. These are:

	NodeNameCmp()	Sort by tn_Name field, case sensitive.
	NodeNameICmp()	Sort by tn_Name field, case insensitive.
	NodeValueCmp()	Sort by tn_Value field.

For a minimal MinTreeNode you must supply your own compare function.
(You can supply your own compare function for full TreeNodes if you
like, though it is not necessary).

A comparison function can be written in any language. This is because
comparison functions are defined using Hook structures (see the
documentation file "Hooks.doc"). A comparison function should be
called like this:

	result = compare_function( hook, node2, node1 );
	d0                         a0    a2     a1

The return value should be negative if node1 is to be considered
"less than" node2, zero if node1 is to be considered "equal to" node2,
or positive if node1 is to be considered "greater than" node2.

INITIALISING A COMPARISON HOOK
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

To declare a comparison function, you must first initialise a Hook
structure to represent that function. This is how you would initialise
a Hook structure (called myHook) to represent the library function
NodeNameCmp():

	/* Declarations */
	struct Hook myHook;
	struct EarthBase *EarthBase;
	extern LVO LVONodeNameCmp;

	/* Initialising the Hook */
	InitLibraryHook( &myHook, EarthBase, LVONodeNameCmp );

   (Note that the typedef LVO is defined in "earth/libraries.h".
   This will be included automatically when you include
   "earth/earthbase.i").

In a PURE machine code program, the same thing would look like this:

	lea.l	myHook(_data),a0
	move.l	_EarthBase(_data),a1
	move.l	#_LVONodeNameCmp,d0
	BSREARTH InitLibraryHook

   (this example assumes that _data is a register equate defining
   the base address from which your variables are offset. BSREARTH
   is defined in the include file "earth/earth.i").

To declare a comparison function which you have written yourself, you
also need to initialise a Hook structure, but it is initialised
differently. In C, do it like this:

	/* Declarations */
	struct Hook myHook;
	MyFunction();
	HookEntryC();

	/* Initialising the Hook */
	myHook->h_Entry = HookEntryC;
	myHook->h_SubEntry = MyFunction;

In a PURE machine code program, the same thing would look like this:

	lea.l	myHook(_data),a0
	lea.l	MyFunction(pc),a1
	move.l	a1,h_Entry(a0)
	move.l	_data,h_Data(a0)

   (the VERY FIRST thing your comparison function should then do is:

	MyFunction
		movem.l	_data,-(sp)		; or similar
		move.l	h_Data(a0),_data

   in order to restore your private data register.
   On exit, you must restore _data).

INITIALISING A TREE HEADER
~~~~~~~~~~~~~~~~~~~~~~~~~~

Each binary tree must have its own header structure. This is an "anchor"
by which you can represent the entire tree. The header is defined by
a TreeHeader structure (see "earth/earthbase.h" or "earth/earthbase.i").
The structure can of course be part of a larger structure which you
define. A TreeHeader structure looks like this:

struct TreeHeader
{
  struct TreeNode	*th_Head;	/* Address of first node in tree */
  struct MinList	th_MinList;	/* List of callback hooks */
};

Like an exec List header, a Tree header must be initialised before it
can be used. You initilise a TreeHeader using the "earth.library"
function InitTree(). This takes two parameters, thus:

	InitTree( tree, hook )
                  a0    a1

The first parameter is the address of the (uninitialised) TreeHeader
structure, and the second parameter is the address of a Hook structure
which has been initialised to represent a comparison function. It is
permissable to pass NULL for the second parameter, in which case the
tree will initially have no comparison routine (and will be unusable
until you supply one at a later stage).

SORTING BY MULTIPLE COMPARISON CRITERIA
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

It is possible to supply multiple comparison functions, to be called
one after another. This enables a structure to be sorted by multiple
criteria. For example, suppose you have tree nodes with both a priority
field and a name field in the structure, and you wish to compare FIRST
by priority, and THEN by name (if priorities are equal).

To do this you need a separate Hook for each comparison function.
Then you just link the Hooks into the tree's Hook list, like this:

	/* Declarations */
	struct TreeHeader myTree;
	struct Hook priorityHook;
	struct Hook nameHook;

	/* Initialising the tree */
 	InitTree( &myTree, &priorityHook );
	AddTail( &myTree->th_HookList, &nameHook);

Alternatively, you could initialise the tree without the first hook
and add the hooks later if this proves to be more convenient, thus:

	/* Initialising the tree */
	InitTree( &myTree, NULL );
	AddTail( &myTree->th_HookList, &priorityHook );
	AddTail( &myTree->th_HookList, &nameHook );

There MUST be at least one comparison function attached to the tree
before the tree can be used.

NODES CAN NEVER BE EQUAL
~~~~~~~~~~~~~~~~~~~~~~~~

In the binary tree structures created and maintained by "earth.library"
it is illegal for two nodes on the same tree to be considered "equal"
to one another. When you attempt to add a node to a tree, the operation
can only succeed if the new node is not equal to any node in the tree.
Otherwise, either the new node will be rejected, or the old node will
be displaced by the new. (You can choose which of these possibilities
you prefer - see the function AddTreeNode()).

However, there are occasions when you may wish to maintain a tree in
which there are many essentially equal nodes. To achieve this you must
create a "fake" comparison function which never comes out equal, and
link its hook to the TAIL of the tree's hook list. A good one for this
purpose is a comparison function which simply returns the difference
between the two structure addresses, like this:

	FakeCompareFunction( hook, node2, node1 )
	{
	    return (LONG)node1 - (LONG)node2;
	}


SEE ALSO
~~~~~~~~

	Hooks.doc, InitTree(),
	FindTreeNode(), AddTreeNode(), AddTreeNodeAll(),
	RemoveTreeNode(), RemoveTreeNodeAll(), BalanceTree(),
	SortTree(), ForEachTreeNode()
