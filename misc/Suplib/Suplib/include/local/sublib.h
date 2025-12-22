
/*
 *  SUBLIB.H
 *
 */

#define SUBHDR	struct _SUBHDR

#define SUBMAGIC    0x4D44

SUBHDR {
    NODE    Node;	/*  link node + name	*/
    uword   DSize;	/*  size of header	*/
    uword   Magic;	/*  Magic		*/
    uword   NameLen;
    uword   RefCnt;	/*  # of references	*/
    uword   Flags;
    uword   Version;
};

