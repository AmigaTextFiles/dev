/*
 * $Id: magic.h 1.4 1998/04/13 09:16:25 olsen Exp olsen $
 *
 * :ts=4
 *
 * Wipeout -- Traces and munges memory and detects memory trashing
 *
 * Written by Olaf `Olsen' Barthel <olsen@sourcery.han.de>
 * Public Domain
 */

#ifndef _MAGIC_H
#define _MAGIC_H 1

/****************************************************************************/

/* this defines a bunch of truly magic numbers used throughout the code */

#define DEADBEEF 0xDEADBEEF	/* freed memory gets filled with this */
#define BASEBALL 0xBA5EBA11	/* this identifies a memory tracking header */
#define DEADFOOD 0xDEADF00D	/* unless MEMF_CLEAR is requested, newly allocated memory is filled with this */
#define ABADCAFE 0xABADCAFE	/* free memory gets filled with this */
#define CODEDBAD 0xC0DEDBAD	/* address 0 is set to this */

/****************************************************************************/

#endif /* _MAGIC_H */
