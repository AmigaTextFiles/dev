
CALLBACK FUNCTIONS
~~~~~~~~~~~~~~~~~~

From time to time, "earth.library" will need to call a function
specified by an application. For instance, the function ForEachWildCard()
requires you to specify a function to be called. ForEachWildCard() is
called like this:

	failcode = ForEachWildCard( pattern, &myfunction, userdata );

In this case, the library will expand the wildcard pattern and then
call the user specified function once for each file which matches the
pattern. This is the simplest type of "callback function". In this
example, the function "myfunction" must be written by the user. It can
be written either in assembler or C. In C it would look like this:

	myfunction(filename,userdata)
	STRPTR filename;
	LONG userdata;
	{
	    /* Function body goes here... */
	    /* Return zero for success, non-zero for failure */
	}

In machine code, it would look like this:

	myfunction
	; On Entry: a0 = address of null-terminated filename
	;           a2 = userdata
	;
	; Function body goes here...
	;
	; On Exit:  d0 = zero for success, non-zero for failure.

Now, it is interesting to note that the callback function can be
written in either C or assembler. This is possible because the entry
parameters are passed BOTH on the stack (where a C program would
expect to find them), AND in registers (where an assembler program
would expect to find them).

HOOKS
~~~~~

The new callback "Hooks" defined in Workbench 2.0+, however, take
this concept one stage further. Hooks have two main advantages over
doing things the old way (ForEachWildCard() does things the old way).
Firstly, they allow the function to be written in ANY language - not
just C or assembler (and in particular, in all variations of C, since
some compilers may have different parameter passing conventions).
Secondly, they allow several different functions to be chained together
in series.

Now, it is important to note, that even though hooks are defined in
the release 2 include files, IT IS NOT NECCESSARY TO USE WB2.0 IN
ORDER TO USE HOOKS. They work perfectly well, under WB1.3 or less.
This is because a Hook is just a structure. Providing that you use
the correct parameter passing conventions, hooks will work ON ALL
MACHINES.

The original definition of a Hook structure is found in the release 2
include files "utility/hooks.h" and "utility/hooks.i". However, in
order to facilitate their use on older machines the structure is also
defined in "earth/earthbase.h" and "earth/earthbase.i". The earthbase
definition is conditionally defined, so that it does NOT conflict
with the release 2 definition.

The Hook structure is as follows:

struct Hook
{
  struct MinNode	h_MinNode;
  APTR			h_Entry;
  APTR			h_SubEntry;
  APTR			h_Data;
};

The MinNode at the start of the structure allows hooks to be linked
together in a linked list. The remaining fields more or less correspond
to the old way of doing things.

h_Entry is the (machine code) entry point of the user function. If the
function is written in machine code, then this field is the function
address. If the function is written in C or some other high level
language then this field is the address of a routine supplied by your
compiler vendor, usually to be found in a link-time library. For
example, there is a function called "HookEntryC" in "earth.lib" which
serves this purpose. This routine will transfer entry parameters from
registers to the stack before calling the C routine.

h_SubEntry is not used if the user function is written in machine code.
Otherwise it is the (high-level language) function entry point. When
the Hook is called, h_Entry routine is called, which in turn will call
the h_SubEntry routine after having transferred the entry parameters
to where they are needed.

h_Data is the userdata field. If you are using base-relative addressing
(for example in a PURE program) then you would put the base address
here. Alternatively, you can put ABSOLUTELY ANYTHING here. It's user
data, for your use.

HOW TO WRITE A HOOKABLE FUNCTION
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

A "hookable" function is a function which can be represented by a Hook
structure. Any function which gets called like this:

	HookableFunction( hook, object, parameters );
			  a0    a2      a1

is a "hookable" function.

In general "object" can be anything, while "parameters" is the address
of further parameters, contained in a structure. Often, the first
longword of this structure is used to switch between various possible
courses of action.

Because the first parameter passed to a hookable function is always
the hook itself, it is therefore possible for the function to extract
the value of the h_Data field before proceeding. This would be
desirable if, for instance, h_Data contained the address of a private
data area used for data-relative addressing.

Note the rather curious register ordering.

HOOK EXAMPLE
~~~~~~~~~~~~

Let's give a concrete example. Suppose you have written a function
called MyFunction() in C. You could represent this function by filling
in a Hook structure, as follows:

	/* Declarations */
	MyFunction(); /* Defined below */
	HookEntryC(); /* Defined in "earth.lib" */
	struct Hook myHook;

	/* How to fill in the structure */
	myHook->h_Entry = &HookEntryC;
	myHook->h_SubEntry = &MyFunction;
	myHook->h_Data = NULL; /* could be anything */

"earth.library" makes use of hooks when dealing with binary trees. See
the document "Trees.doc" in this directory for more information on
binary trees. The function InitTree() requires the address of an
initialised hook as one of its entry parameters. You can pass NULL if
you like, and then link in the hook(s) later, but you will definately
need to attach at least one Hook structure before you can use the tree.

The user function, in this case, serves to compare two nodes of a
binary tree, to determine whether one node is "less than", "equal to"
or "greater than" the other. Such a user function would be called
like this:

	result = MyFunction( hook, node2, node1 )
        d0                   a0    a2     a1

Note that, for hook-functions used by InitTree(), the "object" and
"parameters" entry values are in fact both addresses of binary tree
nodes. This is not quite standard, but the exact meaning of these
variables is always considered "context specific", and our meanings
are certainly allowed.

If two or more hook functions are linked into the tree's Hook-list
then each function may be called in turn, until one of the functions
returns non-zero (meaning nodes are non-equal). This means that you
can apply a sequence of comparison routines - for instance, sorting
first by priority, then by name.

HOOKABLE LIBRARY FUNCTIONS
~~~~~~~~~~~~~~~~~~~~~~~~~~

There are three functions in "earth.library" which are "hookable" -
that is to say, they can be represented by a hook structure. The
three functions are:

	NodeNameCmp(  hook, node2, node1 )
	NodeNameICmp( hook, node2, node1 )
	NodeValueCmp( hook, node2, node1 )

Each of these functions is designed to compare two binary tree nodes,
and thus is suitable for using in a Hook structure passed to InitTree().
A Hook structure which represents a library function looks like this:

	h_Entry		contains a private address within "earth.library".
	h_SubEntry	contains the address of the function vector
	h_Data		contains the library base address
			(in this case EarthBase).

Initialising a Hook structure to represent a library function is easy,
because the "earth.library" function InitLibraryHook() exists to do
all of the hard work for you (and protects you from needing to know the
private address required in h_Entry). Thus, to initialise a Hook to
represent NodeNameCmp(), do this:

	/* Declarations */
	struct EarthBase *EarthBase;
	struct Hook myHook;
	extern LVO LVONodeNameCmp;

	/* Initialise the Hook structure */
	InitLibraryHook( myHook, EarthBase, LVONodeNameCmp );

(Notice how the LVO constant was declared. You can do this for any
function vector). In this way you can create a Hook to describe any
library function in any library (providing, of course, that that
function has been suitably written).

You can do much the same thing in machine code, thus:
(this example assumes you are writing a PURE program, but you can
modify it if you're not)

	lea.l	myHook(_data),a0
	move.l	_EarthBase(_data),a1
	move.l	#_LVONodeNameCmp,d0
	BSREARTH InitLibraryHook

The private code at h_Entry effectively just stacks a6, copies h_Data
into a6, calls h_SubEntry, and then restores a6.

SEE ALSO:
~~~~~~~~~

	Trees.doc, InitTree(), InitLibraryHook(), HookEntryC().
