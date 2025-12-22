OBJECT BB|BootBlock
	id|ID[4]:UBYTE,
	chksum:LONG,
	dosblock:LONG

CONST	BOOTSECTS=2,
		BBNAME_DOS=$444F5300,
		BBNAME_KICK=$4B49434B

#define BBID_DOS	{ 'D', 'O', 'S', '\0' }
#define BBID_KICK	{ 'K', 'I', 'C', 'K' }
