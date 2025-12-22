/*
  simple.mcp (c) Copyright 1996 by Gilles NASSON
  Registered MUI class, Serial Number: 1d51
  *** use only YOUR OWN Serial Number for your public custom class ***
  Simple_mcp.h
*/

#ifndef MUI_SIMPLE_MCP_H
#define MUI_SIMPLE_MCP_H

#ifndef LIBRARIES_MUI_H
#include <libraries/mui.h>
#endif

/* ****************************************************** */
/* ATTENTION:  The FIRST LETTER of NAME MUST be UPPERCASE */
/* ****************************************************** */

/* ******************  Public Part  ******************* */

#define MUIC_Simple_mcp "Simple.mcp"
#define SimpleMcpObject MUI_NewObject(MUIC_Simple_mcp






/* ******************  Private Part  ****************** */

struct Simple_MCP_Data
{
  APTR mcp_group;
};

#endif /* MUI_SIMPLE_MCP_H */

