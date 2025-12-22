/* placeholder module */
OPT NATIVE
MODULE 'target/exec/types'
{#include <hardware/custom.h>}

NATIVE {Custom} OBJECT custom
ENDOBJECT

NATIVE {AudChannel} OBJECT audchannel
ENDOBJECT

NATIVE {SpriteDef} OBJECT spritedef
ENDOBJECT

NATIVE {VARVBLANK} CONST VARVBLANK	= $1000	/* Variable vertical blank enable */
NATIVE {LOLDIS} CONST LOLDIS		= $0800	/* long line disable */
NATIVE {CSCBLANKEN} CONST CSCBLANKEN	= $0400	/* redirect composite sync */
NATIVE {VARVSYNC} CONST VARVSYNC	= $0200	/* Variable vertical sync enable */
NATIVE {VARHSYNC} CONST VARHSYNC	= $0100	/* Variable horizontal sync enable */
NATIVE {VARBEAM} CONST VARBEAM	= $0080	/* variable beam counter enable */
NATIVE {DISPLAYDUAL} CONST DISPLAYDUAL	= $0040	/* use UHRES pointer and standard pointers */
NATIVE {DISPLAYPAL} CONST DISPLAYPAL	= $0020	/* set decodes to generate PAL display */
NATIVE {VARCSYNC} CONST VARCSYNC	= $0010	/* Variable composite sync enable */
NATIVE {CSBLANK} CONST CSBLANK	= $0008	/* Composite blank out to CSY* pin */
NATIVE {CSYNCTRUE} CONST CSYNCTRUE	= $0004	/* composite sync true signal */
NATIVE {VSYNCTRUE} CONST VSYNCTRUE	= $0002	/* vertical sync true */
NATIVE {HSYNCTRUE} CONST HSYNCTRUE	= $0001	/* horizontal sync true */
