/* FVlist: a class for handling linked-list-stuff with that little extra

This kind of linked list has a member pointer to the root of the list,
and this root has a pointer to the tail, so that:
-the root can be reached from every node in one single action (speed)
-the tail can be reached from the root, so that adding a node to this
list (which is always handled with it's root-element) is also quite
fast.

I hear you saying: 'why no normal double-linked list?', and you're
right, except for speed.
Maybe you don't give a damn, but I think it's rather handy...

Oh yes, the Disclaimer:
'Use it, but don't blame me if it blows up your dog or eats
your socks (no good idea anyway :) or some other thing.'

Hope you like it.  If you find any bugs (prey there aren't any),
please let me know immediately.
Also, tell me what you use it for.

Frank Verheyen
The RedHaired Barbarian
--- Nudge Nudge. Say no more ---
    (Monty Python)

(EMAIL) hi910097@Beta.Ufsia.ac.be

Wouter can include this into his next E-release if it's any good.

*/
/*--------------------------------------------------------------------------*/
/*--------------------------------------------------------------------------*/

MODULE 'FVMods/FVList'

/*--------------------------------------------------------------------------*/

PROC main()
	DEF	root:PTR TO fvlist,
		node:PTR TO fvnode,
		intermediate1:PTR TO fvnode,
		intermediate2:PTR TO fvnode,
		last:PTR TO fvnode

	PrintF('\n\nFVList demo coming up, beware\n')
	NEW root.make(NIL)
	intermediate1 := NEW node.make(root)
	NEW node.make(root)
	intermediate2 := NEW node.make(root)
	NEW node.make(root)
	root.show()
	PrintF('giveRoot() of root = \h\n',root.giveRoot())
	PrintF('giveRoot() of node = \h\n',node.giveRoot())
	PrintF('giveTail() of root = \h\n',root.giveTail())
	PrintF('giveTail() of node = \h\n',node.giveTail())
	PrintF('giveChild() of root = \h\n',root.giveChild())
	PrintF('giveChild() of node = \h\n',node.giveChild())
	PrintF('giveParent() of node = \h\n',node.giveParent())

	PrintF('amputation of list from-and-including node \h...\n',intermediate2)
	PrintF('(Notice how the root\as tail etc. are updated)\n')
	intermediate2.free()

	PrintF('And showing again: (list is shorter now)\n')
	root.show()

	PrintF('Adding three nodes just for fun\n')
	NEW node.make(root)
	NEW node.make(root)
	last := NEW node.make(root)

	PrintF('And showing again: (list is longer now)\n')
	root.show()

	PrintF('deleting node \h from list...\n',intermediate1)
	intermediate1.delete()

	PrintF('And showing again: (list lacks that node now)\n')
	PrintF('(Notice how the parent and child of the nodes around\n the deleted one are updated)\n')
	root.show()

	PrintF('deleting last node \h from list...\n',last)
	last.delete()

	PrintF('And showing again: (list lacks that node now)\n')
	root.show()

	PrintF('\nquitting...\nnow,root = \h\n',root)
     END root				-> frees root and all linked nodes too
	PrintF('root = \h, if it is 0, then root is also freed.\n',root)
ENDPROC
