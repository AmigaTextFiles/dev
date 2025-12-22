Treewalk is a function that hands allows the caller to specify a
function to be called for every file in a subtree of the AmigaDOS file
system.  While it doesn't do anything special, it does do this walk
without consuming any critical resources (other than non-stack
memory), it does it robustly, and it does it correctly. Many commands
that have their own, built-in tree traversal routines seem to fail in
one of these three areas.

usage:

#include <treewalk.h>
int treewalk(BPTR root, int (*visit)(BPTR, struct FileInfoBlock *), long flags) ;

root is a lock on the directory to root the tree walk. It is visited
just like all the other directories.

visitfunc is called to "visit" a file or directory. Returns TREE_CONT
or TREE_STOP to continue or stop the tree walk.

flags currently just specifies what order the tree walk is to happen
in.

Treewalk itself returns TRUE if everything worked ok, FALSE if it aborted
for some reason other than out of files or the users request (almost
inevitably, this means "out of memory").

When called, treewalk visits all the directories in the tree at root.
"Visiting" a directory means that it calls the visit function once
with a lock on the directory about to be visited and a NULL fib
pointer, and then once for each file in the directory with that same
lock, and a fib for that specific file.

The order that the directories is visited is controlled via flags.
Flags takes on one of three values: TREE_PRE, TREE_POST or TREE_BOTH.
TREE_PRE specifies a preorder traversal of the tree, in which a
directory is visited before it's children are visited. TREE_POST is a
postorder traversal, in which a directory is visited after all it's
children are visited. TREE_BOTH does both, meaning that all
directories are visited twice. In this case, those that have
no subdirectories are visited twice in succession.

	Copyright 1989, Mike W. Meyer
	These files may be used and redistributed under the terms
	found in the file LICENSE.
