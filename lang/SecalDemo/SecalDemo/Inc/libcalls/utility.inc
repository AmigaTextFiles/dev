pattern FindTagItem(_tagVal,_tagList) is
	push a6;
	safe d0.l:=_tagVal; a0:=_tagList;;
	a6:=UtilityBase; jsr [a6-30];
	pop a6;
endp;															# FINDTAGITEM

pattern GetTagData(_tagValue,_defaultVal,_tagList) is
	push a6;
	safe d0.l:=_tagValue; d1.l:=_defaultVal; a0:=_tagList;;
	a6:=UtilityBase; jsr [a6-36];
	pop a6;
endp;															# GETTAGDATA

pattern PackBoolTags(_initialFlags,_tagList,_boolMap) is
	push a6;
	safe d0.l:=_initialFlags; a0:=_tagList; a1:=_boolMap;;
	a6:=UtilityBase; jsr [a6-42];
	pop a6;
endp;															# PACKBOOLTAGS

pattern NextTagItem(_tagListPtr) is
	push a6;
	a0:=_tagListPtr;
	a6:=UtilityBase; jsr [a6-48];
	pop a6;
endp;															# NEXTTAGITEM

pattern FilterTagChanges(_changeList,_originalList,_apply) is
	push a6;
	safe a0:=_changeList; a1:=_originalList; d0.l:=_apply;;
	a6:=UtilityBase; jsr [a6-54];
	pop a6;
endp;															# FILTERTAGCHANGES

pattern MapTags(_tagList,_mapList,_mapType) is
	push a6;
	safe a0:=_tagList; a1:=_mapList; d0.l:=_mapType;;
	a6:=UtilityBase; jsr [a6-60];
	pop a6;
endp;															# MAPTAGS

pattern AllocateTagItems(_numTags) is
	push a6;
	d0.l:=_numTags;
	a6:=UtilityBase; jsr [a6-66];
	pop a6;
endp;															# ALLOCATETAGITEMS

pattern CloneTagItems(_tagList) is
	push a6;
	a0:=_tagList;
	a6:=UtilityBase; jsr [a6-72];
	pop a6;
endp;															# CLONETAGITEMS

pattern FreeTagItems(_tagList) is
	push a6;
	a0:=_tagList;
	a6:=UtilityBase; jsr [a6-78];
	pop a6;
endp;															# FREETAGITEMS

pattern RefreshTagItemClones(_clone,_original) is
	push a6;
	safe a0:=_clone; a1:=_original;;
	a6:=UtilityBase; jsr [a6-84];
	pop a6;
endp;															# REFRESHTAGITEMCLONES

pattern TagInArray(_tagValue,_tagArray) is
	push a6;
	safe d0.l:=_tagValue; a0:=_tagArray;;
	a6:=UtilityBase; jsr [a6-90];
	pop a6;
endp;															# TAGINARRAY

pattern FilterTagItems(_tagList,_filterArray,_logic) is
	push a6;
	safe a0:=_tagList; a1:=_filterArray; d0.l:=_logic;;
	a6:=UtilityBase; jsr [a6-96];
	pop a6;
endp;															# FILTERTAGITEMS

pattern CallHookPkt(_hook,_object,_paramPacket) is
	push a2\a6;
	safe a0:=_hook; a2:=_object; a1:=_paramPacket;;
	a6:=UtilityBase; jsr [a6-102];
	pop a2\a6;
endp;															# CALLHOOKPKT

pattern Amiga2Date(_seconds,_result) is
	push a6;
	safe d0.l:=_seconds; a0:=_result;;
	a6:=UtilityBase; jsr [a6-120];
	pop a6;
endp;															# AMIGA2DATE

pattern Date2Amiga(_date) is
	push a6;
	a0:=_date;
	a6:=UtilityBase; jsr [a6-126];
	pop a6;
endp;															# DATE2AMIGA

pattern CheckDate(_date) is
	push a6;
	a0:=_date;
	a6:=UtilityBase; jsr [a6-132];
	pop a6;
endp;															# CHECKDATE

pattern SMult32(_arg1,_arg2) is
	push a6;
	safe d0.l:=_arg1; d1.l:=_arg2;;
	a6:=UtilityBase; jsr [a6-138];
	pop a6;
endp;															# SMULT32

pattern UMult32(_arg1,_arg2) is
	push a6;
	safe d0.l:=_arg1; d1.l:=_arg2;;
	a6:=UtilityBase; jsr [a6-144];
	pop a6;
endp;															# UMULT32

pattern SDivMod32(_dividend,_divisor) is
	push a6;
	safe d0.l:=_dividend; d1.l:=_divisor;;
	a6:=UtilityBase; jsr [a6-150];
	pop a6;
endp;															# SDIVMOD32

pattern UDivMod32(_dividend,_divisor) is
	push a6;
	safe d0.l:=_dividend; d1.l:=_divisor;;
	a6:=UtilityBase; jsr [a6-156];
	pop a6;
endp;															# UDIVMOD32

pattern Stricmp(_string1,_string2) is
	push a6;
	safe a0:=_string1; a1:=_string2;;
	a6:=UtilityBase; jsr [a6-162];
	pop a6;
endp;															# STRICMP

pattern Strnicmp(_string1,_string2,_length) is
	push a6;
	safe a0:=_string1; a1:=_string2; d0.l:=_length;;
	a6:=UtilityBase; jsr [a6-168];
	pop a6;
endp;															# STRNICMP

pattern ToUpper(_character) is
	push a6;
	d0.l:=_character;
	a6:=UtilityBase; jsr [a6-174];
	pop a6;
endp;															# TOUPPER

pattern ToLower(_character) is
	push a6;
	d0.l:=_character;
	a6:=UtilityBase; jsr [a6-180];
	pop a6;
endp;															# TOLOWER

pattern ApplyTagChanges(_list,_changeList) is
	push a6;
	safe a0:=_list; a1:=_changeList;;
	a6:=UtilityBase; jsr [a6-186];
	pop a6;
endp;															# APPLYTAGCHANGES

pattern SMult64(_arg1,_arg2) is
	push a6;
	safe d0.l:=_arg1; d1.l:=_arg2;;
	a6:=UtilityBase; jsr [a6-198];
	pop a6;
endp;															# SMULT64

pattern UMult64(_arg1,_arg2) is
	push a6;
	safe d0.l:=_arg1; d1.l:=_arg2;;
	a6:=UtilityBase; jsr [a6-204];
	pop a6;
endp;															# UMULT64

pattern PackStructureTags(_pack,_packTable,_tagList) is
	push a2\a6;
	safe a0:=_pack; a1:=_packTable; a2:=_tagList;;
	a6:=UtilityBase; jsr [a6-210];
	pop a2\a6;
endp;															# PACKSTRUCTURETAGS

pattern UnpackStructureTags(_pack,_packTable,_tagList) is
	push a2\a6;
	safe a0:=_pack; a1:=_packTable; a2:=_tagList;;
	a6:=UtilityBase; jsr [a6-216];
	pop a2\a6;
endp;															# UNPACKSTRUCTURETAGS

pattern AddNamedObject(_nameSpace,_object) is
	push a6;
	safe a0:=_nameSpace; a1:=_object;;
	a6:=UtilityBase; jsr [a6-222];
	pop a6;
endp;															# ADDNAMEDOBJECT

pattern AllocNamedObjectA(_name,_tagList) is
	push a6;
	safe a0:=_name; a1:=_tagList;;
	a6:=UtilityBase; jsr [a6-228];
	pop a6;
endp;															# ALLOCNAMEDOBJECTA

pattern AttemptRemNamedObject(_object) is
	push a6;
	a0:=_object;
	a6:=UtilityBase; jsr [a6-234];
	pop a6;
endp;															# ATTEMPTREMNAMEDOBJECT

pattern FindNamedObject(_nameSpace,_name,_lastObject) is
	push a2\a6;
	safe a0:=_nameSpace; a1:=_name; a2:=_lastObject;;
	a6:=UtilityBase; jsr [a6-240];
	pop a2\a6;
endp;															# FINDNAMEDOBJECT

pattern FreeNamedObject(_object) is
	push a6;
	a0:=_object;
	a6:=UtilityBase; jsr [a6-246];
	pop a6;
endp;															# FREENAMEDOBJECT

pattern NamedObjectName(_object) is
	push a6;
	a0:=_object;
	a6:=UtilityBase; jsr [a6-252];
	pop a6;
endp;															# NAMEDOBJECTNAME

pattern ReleaseNamedObject(_object) is
	push a6;
	a0:=_object;
	a6:=UtilityBase; jsr [a6-258];
	pop a6;
endp;															# RELEASENAMEDOBJECT

pattern RemNamedObject(_object,_message) is
	push a6;
	safe a0:=_object; a1:=_message;;
	a6:=UtilityBase; jsr [a6-264];
	pop a6;
endp;															# REMNAMEDOBJECT

pattern GetUniqueID is
	push a6;
	a6:=UtilityBase; jsr [a6-270];
	pop a6;
endp;															# GETUNIQUEID

