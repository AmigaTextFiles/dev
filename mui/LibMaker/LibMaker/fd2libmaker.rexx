/* $VER: fd2libmaker 0.2 $
 * Convert FD to LibMaker functions
 * © by Stefan Haubenthal 2015
 * Example:
 * rx fd2libmaker <foo_lib.fd >foo_lib.libmaker
 */
say 'LIBMAKER 0.11'
do forever
	parse pull a b .
	if eof(stdin) then leave
	if a="##base" then do
		say 'LIBRARY NAME="foo.library" BASE="'||strip(b, L, _)'" VER=0 REV=0 DATE="'translate(date(E), ".", "/")'" COPYRIGHT=""'
		say 'GENERATOR TYPE="MorphOS" DEST="RAM:" INSTALL="LIBS:" INCDIR="libraries"'
	end
	if abbrev(a, ##) | abbrev(a, "*") then iterate
	parse value a with a "(" b ")" "(" c ")"
	say 'FUNCTION NAME="'a'" RETTYPE="LONG"'
	b=translate(b, , ",")
	c=translate(c, , ",")
	do i=1 to words(c)
		if b~="" then say 'ARGUMENT TYPE="'convert(word(c, i))'" NAME="'word(b, i)'" M68KREG="'word(c, i)'"'
	end
	say 'ENDFUNCTION'
end
say 'ENDLIBRARY'
exit

convert:
arg r 2 n
if r="D" then return LONG
if r="A" then return IPTR
return ""
