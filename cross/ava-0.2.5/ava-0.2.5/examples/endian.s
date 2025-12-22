/*
	endian.s

	Note: AVA is byte oriented assembler.
	To every storage declaration you may specify the length
	and format.

	The length is specifed by the following attributes:
	 - b     8 bit (byte)
         - w/W	16 bit (word)
	 - l/L  32 bit (long) 

	Formats are:
	 - little endian (types: b/l/w)
	 - big endian (types: L/W)

	Uros Platise
*/

#arch AT90S1200

	seg eeprom.val
	dc.b 0x12
	dc.w 0x1234
	dc.W 0x1234
	dc.l 0x12345678
	dc.L 0x12345678

	seg eeprom.string
	dc.b "Ata"
	dc.w "Ata"
	dc.W "Ata"

	seg eeprom.combination
	dc.w "aaaa",13,"bbbb",0
