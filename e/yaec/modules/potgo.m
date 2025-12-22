OPT MODULE
OPT EXPORT
OPT NODEFMODS
-> Module created with E:bin/fd2mod from YAECv2.5 package.
MACRO AllocPotBits(bits) IS (D0:=bits) BUT (A6:=potgobase) BUT ASM ' jsr -6(a6)'
MACRO FreePotBits(bits) IS (D0:=bits) BUT (A6:=potgobase) BUT ASM ' jsr -12(a6)'
MACRO WritePotgo(word,mask) IS Stores(potgobase,word,mask) BUT Loads(A6,D0,D1) BUT ASM ' jsr -18(a6)'
