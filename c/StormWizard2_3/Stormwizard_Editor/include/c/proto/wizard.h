#ifndef PROTO_WIZARD_H
#define PROTO_WIZARD_H

/*
**	$Id$
**	Includes Release 50.1
**
**	Prototype/inline/pragma header file combo
**
**	(C) Copyright 2003 Amiga, Inc.
**	    All Rights Reserved
*/

#ifndef EXEC_TYPES_H
#include <exec/types.h>
#endif
#ifndef UTILITY_TAGITEM_H
#include <utility/tagitem.h>
#endif
#ifndef LIBRARIES_WIZARD_H
#include <libraries/wizard.h>
#endif

/****************************************************************************/

#ifndef __NOLIBBASE__
extern struct Library * WizardBase;
#endif /* __NOLIBBASE__ */

/****************************************************************************/

#ifdef __amigaos4__
 #ifdef __USE_INLINE__
  #include <inline4/wizard.h>
 #endif /* __USE_INLINE__ */

 #include <interfaces/wizard.h>

 #ifndef __NOGLOBALIFACE__
  extern struct WizardIFace *IWizard;
 #endif /* __NOGLOBALIFACE__ */
#else /* __amigaos4__ */
 #if defined(__GNUC__)
  #include <inline/wizard.h>
 #elif defined(__VBCC__)
  #ifndef __PPC__
   #include <inline/wizard_protos.h>
  #endif /* __PPC__ */
 #else
  #include <pragmas/wizard_pragmas.h>
 #endif /* __GNUC__ */
#endif /* __amigaos4__ */

/****************************************************************************/

#endif /* PROTO_WIZARD_H */
