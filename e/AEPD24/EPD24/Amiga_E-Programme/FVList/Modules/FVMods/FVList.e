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
OPT MODULE

EXPORT OBJECT fvnode					-> a node
	PRIVATE parent:PTR TO fvnode
	PRIVATE child:PTR TO fvnode
	PRIVATE root:PTR TO fvnode
ENDOBJECT

EXPORT OBJECT fvlist OF fvnode			-> the rootnode, the list's handle
	PRIVATE tail:PTR TO fvnode
ENDOBJECT
/*--------------------------------------------------------------------------*/
EXPORT PROC make(dummy) OF fvlist			-> constructor
	self.parent := NIL
	self.child := NIL
	self.root := self
	self.tail := NIL
ENDPROC
/*--------------------------------------------------------------------------*/
EXPORT PROC make(r:PTR TO fvlist) OF fvnode	-> constructor
     DEF n:PTR TO fvnode

	IF (n := r.tail)
		n.child := self
		self.parent := n
	ENDIF
	IF r.child=NIL
		r.child := self
		self.parent := r
	ENDIF
	r.tail := self						-> nodes are added at the tail anyway
	self.root := r
	self.child := NIL
ENDPROC
/*--------------------------------------------------------------------------*/
EXPORT PROC show() OF fvnode IS WriteF('Node:\n\taddress=\h\n\tparent=\h\n\tchild=\h\n\troot=\h\n-------------------\n',self,self.parent,self.child,self.root)
/*--------------------------------------------------------------------------*/
EXPORT PROC show() OF fvlist
	DEF n:PTR TO fvnode
	WriteF('Root:\n\taddress=\h\n\tparent=\h\n\tchild=\h\n\troot=\h\n\ttail=\h\n-------------------\n',self,self.parent,self.child,self.root,self.tail)
	IF (n := self.child)
		WHILE n
			n.show()
			n := n.child
		ENDWHILE
	ELSE
		WriteF('Empty list, no children linked\n-------------------\n')
	ENDIF
ENDPROC
/*--------------------------------------------------------------------------*/
EXPORT PROC giveRoot() OF fvnode IS self.root
/*--------------------------------------------------------------------------*/
EXPORT PROC giveChild() OF fvnode IS self.child
/*--------------------------------------------------------------------------*/
EXPORT PROC giveParent() OF fvnode IS self.parent
/*--------------------------------------------------------------------------*/
EXPORT PROC giveTail() OF fvnode IS self.root::fvlist.tail
/*--------------------------------------------------------------------------*/
EXPORT PROC giveTail() OF fvlist IS self.tail
/*--------------------------------------------------------------------------*/
/* this rather funny construction of ENDing a self is a solution to be able to
 implement the delete() (fvnode cannot have an end() destructor, at least not
 a recursive one).  Think about it :) */

EXPORT PROC free() OF fvnode				-> free nodes after and including self
	DEF n:PTR TO fvnode,r:PTR TO fvlist,p:PTR TO fvnode
	IF (n := self.child) THEN n.free()		-> recursively free list of children

 	p := self.parent
 	p.child := NIL						-> amputation of parent
 	r := self.root
	r.tail := p						-> update root's tail
-> 	PrintF('freeing \h\n',self)			-> for debugging purposes
	END self
ENDPROC
/*--------------------------------------------------------------------------*/
EXPORT PROC end() OF fvlist
	DEF n:PTR TO fvnode
	IF (n := self.child)
		n.free()
	ENDIF
->	PrintF('freeing root \h\n',self)		-> for debugging purposes
ENDPROC
/*--------------------------------------------------------------------------*/
EXPORT PROC delete() OF fvnode
	DEF	p:PTR TO fvnode,
		c:PTR TO fvnode,
		r:PTR TO fvlist
	p := self.parent
	c := self.child
	r := self.root
	IF p THEN p.child := c
	IF c
		c.parent := p
	ELSE
		IF r THEN r.tail := p
	ENDIF
	END self
ENDPROC
/*------------------------------ that's it folks ---------------------------*/
