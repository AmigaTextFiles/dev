/* An endian-agnostic CRC32, converted to PortablE, based upon C implementations of ISO 3309:
	http://www.w3.org/TR/2003/REC-PNG-20031110/#D-CRCAppendix
	http://rosettacode.org/wiki/CRC-32#Implementation_2
	https://tools.ietf.org/html/rfc1952#page-11
*/
/* Notes on CRC32:
	https://en.wikipedia.org/wiki/Computation_of_CRC
	The algorithm could be speeded-up by using a 16-bit table.
*/
MODULE 'std/pUnsigned'

PROC main()
	DEF crc:PTR TO crc32, string:ARRAY OF CHAR, expected
	NEW crc.new()
	
	string := 'The quick brown fox jumps over the lazy dog' ; expected := $414FA339
	Print('input = "\s"\noutput   = $\z\h[8]\nexpected = $\z\h[8]\n', string, crc.calc(string, StrLen(string)), expected)
FINALLY
	PrintException()
	END crc
ENDPROC


CLASS crc32
	table[256]:ARRAY OF ULONG	->table of CRCs for all 8-bit messages
ENDCLASS

PROC new(polynomial=$EDB88320:ULONG) OF crc32
	DEF i:ULONG, j, rem:ULONG, table:ARRAY OF ULONG
	
	->pre-calculate 8-bit CRC table for speed
	table := self.table
	FOR i := 0 TO 256-1
		rem := i		->remainder from polynomial division
		FOR j := 0 TO 8-1
			IF rem AND 1
				rem := rem SHR 1 XOR polynomial
			ELSE
				rem := rem SHR 1
			ENDIF
		ENDFOR
		table[i] := rem
	ENDFOR
ENDPROC

->calculate CRC32 of the buffer, optionally taking the CRC value from a preceeding buffer (so it can be computed in chunks, as the data arrives).
->NOTE: The initial CRC bits are all 0s, as given by the default, but these are inverted before being used (so really all 1s).
PROC calc(buffer:ARRAY, length, lastCRC=0:ULONG) OF crc32 RETURNS crc:ULONG
	DEF i, buf:ARRAY OF UBYTE, table:ARRAY OF ULONG
	
	table := self.table		->optimisation
	buf := buffer			->get UBYTE access to buffer
	crc := NOT lastCRC
	FOR i := 0 TO length-1
		crc := crc SHR 8 XOR table[crc XOR buf[i] AND $FF]
	ENDFOR
	
	crc := NOT crc
ENDPROC
