pattern iconPrivate1 is
	push a6;
	a6:=IconBase; jsr [a6-30];
	pop a6;
endp;															# ICONPRIVATE1

pattern iconPrivate2 is
	push a6;
	a6:=IconBase; jsr [a6-36];
	pop a6;
endp;															# ICONPRIVATE2

pattern iconPrivate3 is
	push a6;
	a6:=IconBase; jsr [a6-42];
	pop a6;
endp;															# ICONPRIVATE3

pattern iconPrivate4 is
	push a6;
	a6:=IconBase; jsr [a6-48];
	pop a6;
endp;															# ICONPRIVATE4

pattern FreeFreeList(_freelist) is
	push a6;
	a0:=_freelist;
	a6:=IconBase; jsr [a6-54];
	pop a6;
endp;															# FREEFREELIST

pattern iconPrivate5 is
	push a6;
	a6:=IconBase; jsr [a6-60];
	pop a6;
endp;															# ICONPRIVATE5

pattern iconPrivate6 is
	push a6;
	a6:=IconBase; jsr [a6-66];
	pop a6;
endp;															# ICONPRIVATE6

pattern AddFreeList(_freelist,_mem,_size) is
	push a2\a6;
	safe a0:=_freelist; a1:=_mem; a2:=_size;;
	a6:=IconBase; jsr [a6-72];
	pop a2\a6;
endp;															# ADDFREELIST

pattern GetDiskObject(_name) is
	push a6;
	a0:=_name;
	a6:=IconBase; jsr [a6-78];
	pop a6;
endp;															# GETDISKOBJECT

pattern PutDiskObject(_name,_diskobj) is
	push a6;
	safe a0:=_name; a1:=_diskobj;;
	a6:=IconBase; jsr [a6-84];
	pop a6;
endp;															# PUTDISKOBJECT

pattern FreeDiskObject(_diskobj) is
	push a6;
	a0:=_diskobj;
	a6:=IconBase; jsr [a6-90];
	pop a6;
endp;															# FREEDISKOBJECT

pattern FindToolType(_toolTypeArray,_typeName) is
	push a6;
	safe a0:=_toolTypeArray; a1:=_typeName;;
	a6:=IconBase; jsr [a6-96];
	pop a6;
endp;															# FINDTOOLTYPE

pattern MatchToolValue(_typeString,_value) is
	push a6;
	safe a0:=_typeString; a1:=_value;;
	a6:=IconBase; jsr [a6-102];
	pop a6;
endp;															# MATCHTOOLVALUE

pattern BumpRevision(_newname,_oldname) is
	push a6;
	safe a0:=_newname; a1:=_oldname;;
	a6:=IconBase; jsr [a6-108];
	pop a6;
endp;															# BUMPREVISION

pattern iconPrivate7 is
	push a6;
	a6:=IconBase; jsr [a6-114];
	pop a6;
endp;															# ICONPRIVATE7

pattern GetDefDiskObject(_type) is
	push a6;
	d0.l:=_type;
	a6:=IconBase; jsr [a6-120];
	pop a6;
endp;															# GETDEFDISKOBJECT

pattern PutDefDiskObject(_diskObject) is
	push a6;
	a0:=_diskObject;
	a6:=IconBase; jsr [a6-126];
	pop a6;
endp;															# PUTDEFDISKOBJECT

pattern GetDiskObjectNew(_name) is
	push a6;
	a0:=_name;
	a6:=IconBase; jsr [a6-132];
	pop a6;
endp;															# GETDISKOBJECTNEW

pattern DeleteDiskObject(_name) is
	push a6;
	a0:=_name;
	a6:=IconBase; jsr [a6-138];
	pop a6;
endp;															# DELETEDISKOBJECT

