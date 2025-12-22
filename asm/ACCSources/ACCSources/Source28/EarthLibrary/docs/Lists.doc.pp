
LINKED LISTS
~~~~~~~~~~~~

"earth.library" provides a couple of miscellaneous functions to assist
you in the management of Exec linked lists. These are:

InsertNode() - This is similar to the exec function Insert(), except
that InsertNode() inserts the new node BEFORE the old node, whereas
Insert() inserts the new node AFTER the old node. The entry parameters
are also slightly different, so see the docs.

JoinLists() - This is a nice one. This function will append all nodes
from a "source" linked list onto the end of a "destination" linked
list, preserving the order of the nodes. On return from this function,
the "source" list will always be empty (all of its nodes having been
moved to the other list).

