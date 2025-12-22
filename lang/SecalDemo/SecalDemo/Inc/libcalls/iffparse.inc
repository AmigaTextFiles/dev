pattern AllocIFF is
	push a6;
	a6:=IFFParseBase; jsr [a6-30];
	pop a6;
endp;															# ALLOCIFF

pattern OpenIFF(_iff,_rwMode) is
	push a6;
	safe a0:=_iff; d0.l:=_rwMode;;
	a6:=IFFParseBase; jsr [a6-36];
	pop a6;
endp;															# OPENIFF

pattern ParseIFF(_iff,_control) is
	push a6;
	safe a0:=_iff; d0.l:=_control;;
	a6:=IFFParseBase; jsr [a6-42];
	pop a6;
endp;															# PARSEIFF

pattern CloseIFF(_iff) is
	push a6;
	a0:=_iff;
	a6:=IFFParseBase; jsr [a6-48];
	pop a6;
endp;															# CLOSEIFF

pattern FreeIFF(_iff) is
	push a6;
	a0:=_iff;
	a6:=IFFParseBase; jsr [a6-54];
	pop a6;
endp;															# FREEIFF

pattern ReadChunkBytes(_iff,_buf,_numBytes) is
	push a6;
	safe a0:=_iff; a1:=_buf; d0.l:=_numBytes;;
	a6:=IFFParseBase; jsr [a6-60];
	pop a6;
endp;															# READCHUNKBYTES

pattern WriteChunkBytes(_iff,_buf,_numBytes) is
	push a6;
	safe a0:=_iff; a1:=_buf; d0.l:=_numBytes;;
	a6:=IFFParseBase; jsr [a6-66];
	pop a6;
endp;															# WRITECHUNKBYTES

pattern ReadChunkRecords(_iff,_buf,_bytesPerRecord,_numRecords) is
	push a6;
	safe a0:=_iff; a1:=_buf; d0.l:=_bytesPerRecord; d1.l:=_numRecords;;
	a6:=IFFParseBase; jsr [a6-72];
	pop a6;
endp;															# READCHUNKRECORDS

pattern WriteChunkRecords(_iff,_buf,_bytesPerRecord,_numRecords) is
	push a6;
	safe a0:=_iff; a1:=_buf; d0.l:=_bytesPerRecord; d1.l:=_numRecords;;
	a6:=IFFParseBase; jsr [a6-78];
	pop a6;
endp;															# WRITECHUNKRECORDS

pattern PushChunk(_iff,_type,_id,_size) is
	push d2\a6;
	safe a0:=_iff; d0.l:=_type; d1.l:=_id; d2.l:=_size;;
	a6:=IFFParseBase; jsr [a6-84];
	pop d2\a6;
endp;															# PUSHCHUNK

pattern PopChunk(_iff) is
	push a6;
	a0:=_iff;
	a6:=IFFParseBase; jsr [a6-90];
	pop a6;
endp;															# POPCHUNK

pattern EntryHandler(_iff,_type,_id,_position,_handler,_object) is
	push d2\a2\a6;
	safe a0:=_iff; d0.l:=_type; d1.l:=_id; d2.l:=_position; a1:=_handler; a2:=_object;;
	a6:=IFFParseBase; jsr [a6-102];
	pop d2\a2\a6;
endp;															# ENTRYHANDLER

pattern ExitHandler(_iff,_type,_id,_position,_handler,_object) is
	push d2\a2\a6;
	safe a0:=_iff; d0.l:=_type; d1.l:=_id; d2.l:=_position; a1:=_handler; a2:=_object;;
	a6:=IFFParseBase; jsr [a6-108];
	pop d2\a2\a6;
endp;															# EXITHANDLER

pattern PropChunk(_iff,_type,_id) is
	push a6;
	safe a0:=_iff; d0.l:=_type; d1.l:=_id;;
	a6:=IFFParseBase; jsr [a6-114];
	pop a6;
endp;															# PROPCHUNK

pattern PropChunks(_iff,_propArray,_numPairs) is
	push a6;
	safe a0:=_iff; a1:=_propArray; d0.l:=_numPairs;;
	a6:=IFFParseBase; jsr [a6-120];
	pop a6;
endp;															# PROPCHUNKS

pattern StopChunk(_iff,_type,_id) is
	push a6;
	safe a0:=_iff; d0.l:=_type; d1.l:=_id;;
	a6:=IFFParseBase; jsr [a6-126];
	pop a6;
endp;															# STOPCHUNK

pattern StopChunks(_iff,_propArray,_numPairs) is
	push a6;
	safe a0:=_iff; a1:=_propArray; d0.l:=_numPairs;;
	a6:=IFFParseBase; jsr [a6-132];
	pop a6;
endp;															# STOPCHUNKS

pattern CollectionChunk(_iff,_type,_id) is
	push a6;
	safe a0:=_iff; d0.l:=_type; d1.l:=_id;;
	a6:=IFFParseBase; jsr [a6-138];
	pop a6;
endp;															# COLLECTIONCHUNK

pattern CollectionChunks(_iff,_propArray,_numPairs) is
	push a6;
	safe a0:=_iff; a1:=_propArray; d0.l:=_numPairs;;
	a6:=IFFParseBase; jsr [a6-144];
	pop a6;
endp;															# COLLECTIONCHUNKS

pattern StopOnExit(_iff,_type,_id) is
	push a6;
	safe a0:=_iff; d0.l:=_type; d1.l:=_id;;
	a6:=IFFParseBase; jsr [a6-150];
	pop a6;
endp;															# STOPONEXIT

pattern FindProp(_iff,_type,_id) is
	push a6;
	safe a0:=_iff; d0.l:=_type; d1.l:=_id;;
	a6:=IFFParseBase; jsr [a6-156];
	pop a6;
endp;															# FINDPROP

pattern FindCollection(_iff,_type,_id) is
	push a6;
	safe a0:=_iff; d0.l:=_type; d1.l:=_id;;
	a6:=IFFParseBase; jsr [a6-162];
	pop a6;
endp;															# FINDCOLLECTION

pattern FindPropContext(_iff) is
	push a6;
	a0:=_iff;
	a6:=IFFParseBase; jsr [a6-168];
	pop a6;
endp;															# FINDPROPCONTEXT

pattern CurrentChunk(_iff) is
	push a6;
	a0:=_iff;
	a6:=IFFParseBase; jsr [a6-174];
	pop a6;
endp;															# CURRENTCHUNK

pattern ParentChunk(_contextNode) is
	push a6;
	a0:=_contextNode;
	a6:=IFFParseBase; jsr [a6-180];
	pop a6;
endp;															# PARENTCHUNK

pattern AllocLocalItem(_type,_id,_ident,_dataSize) is
	push d2\d3\a6;
	safe d0.l:=_type; d1.l:=_id; d2.l:=_ident; d3.l:=_dataSize;;
	a6:=IFFParseBase; jsr [a6-186];
	pop d2\d3\a6;
endp;															# ALLOCLOCALITEM

pattern LocalItemData(_localItem) is
	push a6;
	a0:=_localItem;
	a6:=IFFParseBase; jsr [a6-192];
	pop a6;
endp;															# LOCALITEMDATA

pattern SetLocalItemPurge(_localItem,_purgeHook) is
	push a6;
	safe a0:=_localItem; a1:=_purgeHook;;
	a6:=IFFParseBase; jsr [a6-198];
	pop a6;
endp;															# SETLOCALITEMPURGE

pattern FreeLocalItem(_localItem) is
	push a6;
	a0:=_localItem;
	a6:=IFFParseBase; jsr [a6-204];
	pop a6;
endp;															# FREELOCALITEM

pattern FindLocalItem(_iff,_type,_id,_ident) is
	push d2\a6;
	safe a0:=_iff; d0.l:=_type; d1.l:=_id; d2.l:=_ident;;
	a6:=IFFParseBase; jsr [a6-210];
	pop d2\a6;
endp;															# FINDLOCALITEM

pattern StoreLocalItem(_iff,_localItem,_position) is
	push a6;
	safe a0:=_iff; a1:=_localItem; d0.l:=_position;;
	a6:=IFFParseBase; jsr [a6-216];
	pop a6;
endp;															# STORELOCALITEM

pattern StoreItemInContext(_iff,_localItem,_contextNode) is
	push a2\a6;
	safe a0:=_iff; a1:=_localItem; a2:=_contextNode;;
	a6:=IFFParseBase; jsr [a6-222];
	pop a2\a6;
endp;															# STOREITEMINCONTEXT

pattern InitIFF(_iff,_flags,_streamHook) is
	push a6;
	safe a0:=_iff; d0.l:=_flags; a1:=_streamHook;;
	a6:=IFFParseBase; jsr [a6-228];
	pop a6;
endp;															# INITIFF

pattern InitIFFasDOS(_iff) is
	push a6;
	a0:=_iff;
	a6:=IFFParseBase; jsr [a6-234];
	pop a6;
endp;															# INITIFFASDOS

pattern InitIFFasClip(_iff) is
	push a6;
	a0:=_iff;
	a6:=IFFParseBase; jsr [a6-240];
	pop a6;
endp;															# INITIFFASCLIP

pattern OpenClipboard(_unitNumber) is
	push a6;
	d0.l:=_unitNumber;
	a6:=IFFParseBase; jsr [a6-246];
	pop a6;
endp;															# OPENCLIPBOARD

pattern CloseClipboard(_clipHandle) is
	push a6;
	a0:=_clipHandle;
	a6:=IFFParseBase; jsr [a6-252];
	pop a6;
endp;															# CLOSECLIPBOARD

pattern GoodID(_id) is
	push a6;
	d0.l:=_id;
	a6:=IFFParseBase; jsr [a6-258];
	pop a6;
endp;															# GOODID

pattern GoodType(_type) is
	push a6;
	d0.l:=_type;
	a6:=IFFParseBase; jsr [a6-264];
	pop a6;
endp;															# GOODTYPE

pattern IDtoStr(_id,_buf) is
	push a6;
	safe d0.l:=_id; a0:=_buf;;
	a6:=IFFParseBase; jsr [a6-270];
	pop a6;
endp;															# IDTOSTR

