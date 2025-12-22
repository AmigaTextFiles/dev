/* $Id: dosasl.h,v 1.26 2005/11/10 15:32:20 hjfrieden Exp $ */
OPT NATIVE
MODULE 'target/exec/libraries', 'target/exec/lists', 'target/dos/dos'
PUBLIC MODULE 'target/dos/anchorpath'
{#include <dos/dosasl.h>}
NATIVE {DOS_DOSASL_H} CONST

/*******************************************************************************
 * WARNING:   The V50 AnchorPath structure has moved to dos/anchorpath.h
 *
 * You MUST now allocate these with AllocDosObject() from DOS 50.76+ 
 *           MatchXXX() will simply not work if you do not heed this warning.
 ******************************************************************************/
