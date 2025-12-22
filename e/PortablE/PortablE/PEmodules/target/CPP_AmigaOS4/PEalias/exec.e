/* alias module AND patches OpenLibrary() for OS4 interfaces */
PUBLIC MODULE 'targetShared/Amiga/exec'
PUBLIC MODULE 'targetShared/CPP/Amiga/pStack'
MODULE 'target/PE/base', 'target/exec'


PRIVATE

OBJECT libNode
	libName     :ARRAY OF CHAR				->library name specified during initialisation
	library     :PTR TO lib					->actual opened library
	ifaceName   :ARRAY OF CHAR				->interface name which should be opened (usually "main")
	ifaceVersion							->interface version which should be opened (usually "1")
	ifaceAddress:ARRAY OF PTR TO interface	->address of library's interface variable
	count
	
	next:OWNS PTR TO libNode
ENDOBJECT

DEF head=NIL:OWNS PTR TO libNode

->clean-up all library nodes created by InitLibrary() calls
PROC end()
	DEF node:OWNS PTR TO libNode, next:OWNS PTR TO libNode
	
	node := PASS head
	WHILE node
		next := PASS node.next
		END node
		node := PASS next
	ENDWHILE
ENDPROC

->helper procedure
PROC findLibraryNameNode(libName:ARRAY OF CHAR, last=NIL:PTR TO libNode) RETURNS found:PTR TO libNode
	DEF node :PTR TO libNode
	
	found := NIL
	node := IF last = NIL THEN head ELSE last.next
	WHILE node
		IF StrCmpNoCase(node.libName, libName) THEN found := node
		
		node := node.next
	ENDWHILE IF found
ENDPROC

->helper procedure
PROC findLibraryNode(library:PTR TO lib, last=NIL:PTR TO libNode) RETURNS found:PTR TO libNode
	DEF node :PTR TO libNode
	
	found := NIL
	node := IF last = NIL THEN head ELSE last.next
	WHILE node
		IF node.library = library THEN found := node
		
		node := node.next
	ENDWHILE IF found
ENDPROC


PUBLIC

->this is normally called once per library, from within the relevant module's new() procedure
->but it may be called more than once, if the library has more than one interface
PROC InitLibrary(libName:ARRAY OF CHAR, ifaceAddress:ARRAY OF PTR TO interface, ifaceName=NILA:ARRAY OF CHAR, ifaceVersion=1)
	DEF node:OWNS PTR TO libNode
	
	NEW node
	node.libName := libName
	node.library := NIL
	node.ifaceName    := IF ifaceName THEN ifaceName ELSE 'main'
	node.ifaceVersion := ifaceVersion
	node.ifaceAddress := ifaceAddress
	node.count   := 0
	node.next    := PASS head
	
	node.ifaceAddress[0] := NIL		->kludge for utility.library & any other interfaces that may be automatically opened by newlib/clib2
	
	head := PASS node
ENDPROC

PROC OpenLibrary(libName:ARRAY OF CHAR, version:ULONG) RETURNS ret:PTR TO lib REPLACEMENT
	DEF node:PTR TO libNode
	
	IF ret := SUPER OpenLibrary(libName, version)
		->find relevant library node
		node := findLibraryNameNode(libName)
		IF node = NIL
			Print('BUG in PortablE: target/PEalias/exec; OpenLibrary("\s", \d); InitLibrary() has not been called for supplied library.\n', libName, version)
			Throw("BUG", 'target/PEalias/exec; OpenLibrary(); InitLibrary() has not been called for supplied library')
		ENDIF
		
		REPEAT
			->handle OS4 library interface
			node.count := node.count + 1
			IF node.ifaceAddress[0] = NIL
				->get global interface
				node.ifaceAddress[0] := GetInterface(ret, node.ifaceName, node.ifaceVersion, NILA)
				node.library := ret
				
				IF node.ifaceAddress[0] = NIL
					Print('ERROR: target/PEalias/exec; OpenLibrary("\s", \d); GetInterface(,"\s", \d) failed.\n', libName, version, node.ifaceName, node.ifaceVersion)
					Throw("lib", 'target/PEalias/exec; OpenLibrary(); GetInterface() failed')
				ENDIF
				
			ELSE IF node.library <> ret
				Throw("BUG", 'target/PEalias/exec; OpenLibrary(); SUPER call unexpectedly returned a different library compared to a previous call')
			ENDIF
			
			->search for any more interfaces associated with this library
			node := findLibraryNameNode(libName, node)
		UNTIL node = NIL
	ENDIF
ENDPROC

/*
PROC InfoLibraryInterface(library:PTR TO lib) RETURNS iface:PTR TO interface
	DEF node:PTR TO libNode
	
	->find relevant library node
	IF node := findLibraryNode(library)
		iface := node.ifaceAddress[0]
	ENDIF
ENDPROC
*/

PROC CloseLibrary(library:PTR TO lib) REPLACEMENT
	DEF node:PTR TO libNode
	
	->find relevant library node
	node := findLibraryNode(library)
	->IF node = NIL THEN Throw("BUG", 'target/PEalias/exec; CloseLibrary(); InitLibrary() has not been called for supplied library')
	
	WHILE node
		->handle OS4 library interface
		node.count := node.count - 1
		IF node.count = 0
			->drop global interface
			DropInterface(node.ifaceAddress[0])
			node.library         := NIL
			node.ifaceAddress[0] := NIL
		ENDIF
		
		->search for any more interfaces associated with this library
		node := findLibraryNode(library, node)
	ENDWHILE
	
	SUPER CloseLibrary(library)
ENDPROC
