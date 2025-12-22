type
ÑBootBlock_tÅ=ÅstructÅ{
à[4]charÅbb_id;
àulongÅbb_chksum;
àulongÅbb_dosblock;
Ñ};

uintÅBOOTSECSÅ=Å2;

[4]char
ÑBBID_DOSÅ=Å('D',Å'O',Å'S',Å'\0'),
ÑBBID_KICKÅ=Å('K',Å'I',Å'C',Å'K');

ulong
ÑBBNAME_DOSÅ=Å(('D'-'\e')<<24)|(('O'-'\e')<<16)|(('S'-'\e')<<8),
ÑBBNAME_KICKÅ=Å(('K'-'\e')<<24)|(('I'-'\e')<<16)|(('C'-'\e')<<8)|('K'-'\e');
