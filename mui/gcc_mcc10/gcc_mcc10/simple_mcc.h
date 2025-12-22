/*
  simple.mcp (c) Copyright 1996 by Gilles NASSON
  Registered MUI class, Serial Number: 1d51
  *** use only YOUR OWN Serial Number for your public custom class ***
  Simple_mcp.h
*/

#ifndef MUI_SIMPLE_MCC_H
#define MUI_SIMPLE_MCC_H

#ifndef LIBRARIES_MUI_H
#include <libraries/mui.h>
#endif

/* ****************************************************** */
/* ATTENTION:  The FIRST LETTER of NAME MUST be UPPERCASE */
/* ****************************************************** */

/* ******************  Public Part  ******************* */

#define MUIC_Simple "Simple.mcc"
#define SimpleObject MUI_NewObject(MUIC_Simple






/* ******************  Private Part  ****************** */

struct Simple_MCC_Data
{
  APTR mcc_group;
};

#endif /* MUI_SIMPLE_MCC_H */

