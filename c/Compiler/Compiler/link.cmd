FROM	LIB:c.o*
	analyze.o*
	expr.o*
	init.o*
	optimize.o*
	register.o*
	func.o*
	intexpr.o*
	outcode.o*
	searchkw.o*
	cglbdef.o*
	gencode.o*
	list.o*
	peepgen.o*
	stmt.o*
	cmain.o*
	genstmt.o*
	memmgt.o*
	preproc.o*
	symbol.o*
	decl.o*
	getsym.o
TO	cc68k
LIBRARY	LIB:lcm.lib*
	LIB:lc.lib*
	LIB:amiga.lib
MAP	nil:
