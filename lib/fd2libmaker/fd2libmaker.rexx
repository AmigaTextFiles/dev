/* $VER: fd2libmaker 1.0 $
 * Convert (S)FD to LibMaker functions
 * © by Stefan Haubenthal 2015-2018
 * Example:
 * rx fd2libmaker <foo_lib.fd >foo_lib.libmaker
 */
say 'LIBMAKER 0.11'
do forever
	parse pull a b c
	if eof(stdin) then leave
	if a="##base" | a="==base" then do
		base=strip(b, L, _)
		parse value base with name"Base"
		say 'LIBRARY NAME="'translate(name, xrange('a','z'), xrange('A','Z'))'.library"',
		'BASE="'base'" VER=0 REV=0 DATE="'translate(date(E), ".", "/")'" COPYRIGHT=""'
		say 'GENERATOR TYPE="MorphOS" DEST="RAM:" INSTALL="LIBS:" INCDIR="libraries"'
		fd=a="##base"
	end
	if abbrev(a, ##) | abbrev(a, "==") | abbrev(a, "*") then iterate
	if fd then do
		parse value a with a "(" b ")" "(" c ")"
		rettype=LONG /* assumption */
	end
	else
		parse value a b c with rettype a "(" b ")" "(" c ")"
	say 'FUNCTION NAME="'strip(a)'" RETTYPE="'upper(rettype)'"'
	if abbrev(b, "char  *") then b=delstr(b, 5, 2) /* hack: remove spaces */
	b=translate(b, , ",")
	c=upper(translate(c, , ",/"))
	do i=1 to words(c)
		if fd then say 'ARGUMENT TYPE="'convert(word(c, i))'" NAME="'word(b, i)'" M68KREG="'word(c, i)'"'
		      else say 'ARGUMENT TYPE="'convert(word(b, i*2-1))'" NAME="'word(b, i*2)'" M68KREG="'word(c, i)'"'
	end
	say 'ENDFUNCTION'
end
say 'ENDLIBRARY'
exit

convert:
arg r 2 n
if r="D" then return LONG
if r="A" then return IPTR
if arg(1)="char*" then return STRPTR
return arg(1)
