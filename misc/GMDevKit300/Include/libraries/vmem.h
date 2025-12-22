#ifndef LIBRARIES_VMEM_H
#define	LIBRARIES_VMEM_H
/*
**	$Filename: libraries/vmem.h $
**	$Release: 1.0 Includes, V1.0 $
**	$Revision: 1.0 $
**	$Date: 21-04-92 $
**
**	External definitions for vmem.library
**
**	(C) Copyright 1992 Ch. Schneider, Relog AG
**	    All Rights Reserved
*/

#define VMEMNAME	"vmem.library"

/*----- Memory Requirement Types ---------------------------*/
/*----- See the VMAllocMem() documentation for details -----*/

/* flags for the VMAllocMem() call */
#define VMEMF_VIRTUAL   (1L<<0)  /* Force virtual memory */

#define VMEMF_VIRTPRI   (1L<<16) /* Preferably virtual memory */
#define VMEMF_PHYSPRI   (1L<<17) /* Preferably physical memory */
#define VMEMF_ALIGN     (1L<<18) /* Try to align to page base */

#endif /* LIBRARIES_VMEM_H */
