/*
 * Copyright 2009 Chris Young <chris@unsatisfactorysoftware.co.uk>
 */

parse arg filename offset

address command 'readelf -e' filename '>t:addr2line.tmp'

if open('tmp','t:addr2line.tmp','R') then do
	do until index(var," .text ") > 0
		if eof('tmp') then break
		var = readln('tmp')
	end
	dummy = close('tmp')
	address command 'delete t:addr2line.tmp'
end

textaddr = x2d(substr(var,42,8))
newoffset = d2x(textaddr + x2d(offset))
address command 'addr2line -e' filename '0x' || newoffset
