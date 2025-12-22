/*--------------------------------------------------------------------------*
                                 main 0.1
                     copyright © 1992 by sam hepworth
 *--------------------------------------------------------------------------*/




	/* Include
	 */
#include "syms.c"



	/* name and idstring of library
	 */
global TEXT __far LibName[] = "taglist.library";
global TEXT __far LibID[] = "TagList 1.0 (15 Jul 1992) Copyright © 1992 by Sam Hepworth";




	/* library functions
	 */
extern ULONG LibTL_GetTagData;
extern ULONG LibTL_FindTagData;
extern ULONG LibTL_FindTagItem;
extern ULONG LibTL_MapTagList;

global APTR LibFunc[] = {
	&LibOpen,&LibClose,&LibExpunge,&LibExtFunc,
	&LibTL_GetTagData,
	&LibTL_FindTagData,
	&LibTL_FindTagItem,
	&LibTL_MapTagList,
	(APTR)-1
};




	/* library seglist
	 */
global LONG __far LibSegList					=NULL;




	/* Init
	 */
global struct Library *  __asm LibInit(
	REGISTER __a0 LONG seglist
)
{
	REGISTER struct Library *libbase;
	libbase=(struct Library *)MakeLibrary(LibFunc,NULL,NULL,sizeof(struct Library),NULL);
	libbase->lib_Node.ln_Type	=NT_LIBRARY;
	libbase->lib_Node.ln_Name	=LibName;
	libbase->lib_Flags			=LIBF_SUMUSED | LIBF_CHANGED;
	libbase->lib_Version		=1;
	libbase->lib_Revision		=0;
	libbase->lib_IdString		=LibID;
	LibSegList					=seglist;
	AddLibrary((struct Library *)libbase);
	return(libbase);
}



	/* Open
	 */
global struct Library * __asm LibOpen(
	REGISTER __a6 struct Library *libbase
)
{
	libbase->lib_OpenCnt++;
	libbase->lib_Flags&=~LIBF_DELEXP;
	return(libbase);
}



	/* Close
	 */
global LONG __asm LibClose(
	REGISTER __a6 struct Library *libbase
)
{
	if((--libbase->lib_OpenCnt==0) && (libbase->lib_Flags&LIBF_DELEXP)) {
		return(LibExpunge(libbase));
	}
	return(0);
}



	/* Expunge
	 */
global LONG __asm LibExpunge(
	REGISTER __a6 struct Library *libbase
)
{
	REGISTER LONG seglist=0;
	REGISTER LONG negsize;
	REGISTER LONG libsize;

	libbase->lib_Flags|=LIBF_DELEXP;
	if(libbase->lib_OpenCnt==0) {
		seglist=LibSegList;
		Remove((struct Node *)libbase);
		libsize=(negsize=libbase->lib_NegSize)+libbase->lib_PosSize;
		FreeMem((UBYTE *)libbase-negsize,libsize);
	}
	return(seglist);
}



	/* ExtFunc
	 */
global LONG __asm LibExtFunc(
	VOID
)
{
	return(0);
}




	/* main - Entry if started form cli
	 */
global LONG __asm main(
	VOID
)
{
#if 0
	struct TagMapItem tagmap[] = {
		TAGMAP(WA_Left,NewWindow,LeftEdge,0,REAL,WORD,DEFAULT,0),
		TAGMAP(WA_Top,NewWindow,TopEdge,0,REAL,WORD,DEFAULT,0),
		TAGMAP(WA_Width,NewWindow,Width,1,REAL,WORD,NODEFAULT,0),
		TAGMAP(WA_Height,NewWindow,Height,2,REAL,WORD,NODEFAULT,0),
		TAGMAP(WA_Flags,NewWindow,Flags,0,REAL,LONG,DEFAULT,0),
		TAGMAP(WA_SuperBitMap,NewWindow,Flags,0,BOOL,LONG,NODEFAULT,WFLG_SUPER_BITMAP),
		TAGMAP(WA_SuperBitMap,NewWindow,BitMap,0,REAL,LONG,NODEFAULT),
		TAG_DONE
	};
	struct NewWindow new = {NULL};
	struct TagItem tags[] = {
		WA_SuperBitMap,(ULONG)"BitMap",
		TAG_DONE
	};
	REGISTER struct Library *TagListBase;
	LibInit(NULL);
	TagListBase=OpenLibrary("taglist.library",0);
	TL_MapTagList(&tagmap[0],&new,&tags[0]);
	RemLibrary(TagListBase);
	CloseLibrary(TagListBase);
#endif
	return(0);
}



