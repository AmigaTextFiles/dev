#drinc:util.g
#draco.g
#externs.g

/* general utility routines that don't go anywhere else */

/*
 * pushDescriptor - allocate a new descriptor
 */

proc pushDescriptor()void:

    if DescNext = &DescTable[DTSIZE] then
	errorThis(9);
    fi;
    DescNext := DescNext + sizeof(DESCRIPTOR);
    BlockCopyB(pretend(DescNext, *byte) - 1,
	       pretend(DescNext, *byte) - (sizeof(DESCRIPTOR) + 1),
	       DescNext - &DescTable[1]);
corp;

/*
 * popDescriptor - free the last used descriptor (they are a stack)
 */

proc popDescriptor()void:

    BlockCopy(pretend(&DescTable[0], *byte),
	      pretend(&DescTable[1], *byte),
	      DescNext - &DescTable[1]);
    DescNext := DescNext - sizeof(DESCRIPTOR);
corp;
