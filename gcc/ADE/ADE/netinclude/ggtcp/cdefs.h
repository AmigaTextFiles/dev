
/* Since all the standard declarations are in ixemul's sys/cdefs.h,
 * I have deleted them from here, leaving only GGTCP specific 
 * defines.  Hence, I removed the Berkeley copyrights as well.
 * L.W.
 */


#ifndef	GGTCP_CDEFS_H
#define	GGTCP_CDEFS_H

/*
 * SAVEDS should be used in all function definitions which will be called 
 * from other tasks than GGTCP/IP. Is restores the global data base pointer
 * as the first thing in the function body.
 *
 * REGARGFUN contains special keywords which should be used when functions
 * used through shared library are referenced.
 */

#define SAVEDS __saveds
#define REGARGFUN __regargs
#define STKARGFUN __stdargs
#define ALIGNED __aligned
#define ASM __asm
#define REG(x) register __##x

#endif /* !GGTCP_CDEFS_H */
