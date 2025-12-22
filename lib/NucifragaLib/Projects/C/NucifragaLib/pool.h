typedef struct
{
	APTR			  handle;
	ULONG			  memflags;
	BOOL			  v39;
	struct Library	* nofrag;

#if 0
	struct Library	* intuition;
#endif
} Pool;

BOOL poolcreate(Pool *, ULONG, ULONG);
void pooldestroy(Pool *);

APTR poolalloc(Pool *, ULONG);
void poolfree(Pool *, APTR, ULONG);

APTR poolallocvec(Pool *, ULONG);
void poolfreevec(Pool *, APTR);

#if 0
void pooladdhandler(struct Hook *, BYTE);
void poolremhandler(struct Hook *);
#endif
