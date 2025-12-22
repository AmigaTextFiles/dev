/*
 * debug.c  V3.1
 *
 * ToolManager library debugging code
 *
 * Copyright (C) 1990-98 Stefan Becker
 *
 * This source code is for educational purposes only. You may study it
 * and copy ideas or algorithms from it for your own projects. It is
 * not allowed to use any of the source codes (in full or in parts)
 * in other programs. Especially it is not allowed to create variants
 * of ToolManager or ToolManager-like programs from this source code.
 *
 */

#include "toolmanager.h"

#ifdef DEBUGPRINTTAGLIST
/* Get tag name */
const char *GetTagName(ULONG tag)
{
 const char *rc;

 switch(tag) {
  case TMOP_Arguments:  rc = "TMOP_Arguments";  break;
  case TMOP_Command:    rc = "TMOP_Command";    break;
  case TMOP_CurrentDir: rc = "TMOP_CurrentDir"; break;
  case TMOP_ExecType:   rc = "TMOP_ExecType";   break;
  case TMOP_HotKey:     rc = "TMOP_HotKey";     break;
  case TMOP_Output:     rc = "TMOP_Output";     break;
  case TMOP_Path:       rc = "TMOP_Path";       break;
  case TMOP_Priority:   rc = "TMOP_Priority";   break;
  case TMOP_PubScreen:  rc = "TMOP_PubScreen";  break;
  case TMOP_Stack:      rc = "TMOP_Stack";      break;
  case TMOP_ToFront:    rc = "TMOP_ToFront";    break;

  case TMOP_File:       rc = "TMOP_File";       break;

  case TMOP_Port:       rc = "TMOP_Port";       break;

  case TMOP_Exec:       rc = "TMOP_Exec";       break;
  case TMOP_Sound:      rc = "TMOP_Sound";      break;

  case TMOP_Image:      rc = "TMOP_Image";      break;
  case TMOP_ShowName:   rc = "TMOP_ShowName";   break;

  case TMOP_LeftEdge:   rc = "TMOP_LeftEdge";   break;
  case TMOP_TopEdge:    rc = "TMOP_TopEdge";    break;

  case TMOP_Activated:  rc = "TMOP_Activated";  break;
  case TMOP_Centered:   rc = "TMOP_Centered";   break;
  case TMOP_Columns:    rc = "TMOP_Columns";    break;
  case TMOP_Font:       rc = "TMOP_Font";       break;
  case TMOP_FrontMost:  rc = "TMOP_FrontMost";  break;
  case TMOP_Menu:       rc = "TMOP_Menu";       break;
  case TMOP_PopUp:      rc = "TMOP_PopUp";      break;
  case TMOP_Text:       rc = "TMOP_Text";       break;
  case TMOP_Tool:       rc = "TMOP_Tool";       break;
  case TMOP_Backdrop:   rc = "TMOP_Backdrop";   break;
  case TMOP_Sticky:     rc = "TMOP_Sticky";     break;
  case TMOP_Images:     rc = "TMOP_Images";     break;
  case TMOP_Border:     rc = "TMOP_Border";     break;

  case TMA_TMHandle:    rc = "TMA_TMHandle";    break;
  case TMA_ObjectType:  rc = "TMA_ObjectType";  break;
  case TMA_ObjectName:  rc = "TMA_ObjectName";  break;
  case TMA_ObjectID:    rc = "TMA_ObjectID";    break;

  case TMA_Entry:       rc = "TMA_Entry";       break;
  case TMA_Screen:      rc = "TMA_Screen";      break;
  case TMA_Font:        rc = "TMA_Font";        break;
  case TMA_Images:      rc = "TMA_Images";      break;
  case TMA_Text:        rc = "TMA_Text";        break;

  case TMA_String:      rc = "TMA_String";      break;
  case TMA_Image:       rc = "TMA_Image";       break;

  default: rc = "UNKNOWN";                    break;
 }

 return(rc);
}

/* Get tag data format */
static const char *GetTagFormat(ULONG tag)
{
 const char *rc;

 switch (tag) {
  case TMA_ObjectType:
                        rc = "%ld";     break;

  case TMA_ObjectName:
                        rc = "%s";      break;

  default:              rc = "0x%08lx"; break;
 }

 return(rc);
}
#endif

/* Include global debugging code */
#include "/global_debug.c"
