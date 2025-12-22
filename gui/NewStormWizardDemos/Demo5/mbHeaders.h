/*
 *	Datei: mbHeaders.h
 *	Aufgabe: Bereitstellen von Compilerinformationen,
 *		 Einbinden der benötigten #includes
 *
 */

/* Einbinden der benötigten System-Headerdateien        */
/* Shell-Ausgabe (Standard-IO), String-Manipulationen, math. Funktionen für float */
#ifndef __STORMGCC__
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
// #include <math.h>
#endif

/* Amiga Systembibliotheken usw. */
#ifndef __GNUC__
#include	<proto/exec.h>
#include	<proto/intuition.h>
#include	<proto/utility.h>
#include	<proto/graphics.h>
#include	<proto/dos.h>
#include	<proto/asl.h>
#include	<proto/wizard.h>
#endif

#ifdef __STORMGCC__
#include	<proto/exec.h>
#include	<proto/intuition.h>
#include	<proto/utility.h>
#include	<proto/graphics.h>
#include	<proto/dos.h>
#include	<proto/asl.h>
#include	<proto/wizard.h>
#endif

/* alle anderen Compiler: */
#include	<clib/alib_protos.h>

#include	<pragma/exec_lib.h>
#include	<pragma/intuition_lib.h>
#include	<pragma/utility_lib.h>
#include 	<pragma/asl_lib.h>
#include	<pragma/wizard_lib.h>

#include	<libraries/wizard.h>
#include	<intuition/gadgetclass.h>
#include	<intuition/intuition.h>
#include	<libraries/asl.h>
