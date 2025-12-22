ULONG TL_GetTagData(ULONG id,ULONG defaultvalue,struct TagItem *taglist);
ULONG *TL_FindTagData(ULONG id,struct TagItem *taglist);
struct TagItem *TL_FindTagItem(ULONG id,struct TagItem *taglist);
ULONG TL_MapTagList(struct TagMapItem *tagmap,APTR buffer,struct TagItem *taglist);
