/* -----------------------------------------------------------------------------

 mirror.api ©1999 Dietmar Eilert
 Improved and optimized to NewMirror.api by Christian Hattemer

 API plug-in. Highlights matching bracket if cursor is moved over a bracket.

 Compiles with StormC

 So muß ein Source aussehen, dann klappts auch mitm Nachbarn.

 -------------------------------------------------------------------------------

*/

#include "defs.h"

// macros

/* Parameter: UBYTE c
   Result   : TRUE if c is a bracket
*/
#define IsABracket(c) (((c) == '(' || (c) == ')' || (c) == '{' || (c) == '}' || (c) == '[' || (c) == ']') ? TRUE : FALSE)

/* Parameter: struct EditConfig *config
   Result   : TRUE if there is no user-defined block, i.e. either no block at all or a
              marked bracket only (possibly marked by us).
*/
#define NoUserBlock(config) (((config->Marker == BLOCKMODE_NONE) || FindMarkedBracket(config)) ? TRUE : FALSE)

/// "prototypes"

// library functions

Prototype struct APIClient * LibCall APIMountClient(REG(a0) struct APIMessage *apiMsg, REG(a1) char *args);
Prototype void               LibCall APICloseClient(REG(a0) struct APIClient *handle, REG(a1) struct APIMessage *apiMsg);
Prototype void               LibCall APIBriefClient(REG(a0) struct APIClient *handle, REG(a1) struct APIMessage *apiMsg);
Prototype void               LibCall APIFree       (REG(a0) struct APIClient *handle, REG(a1) struct APIOrder *apiOrder);

// private functions

Prototype void Dispatch         (struct APIMessage *apiMsg);
Prototype BOOL FindMarkedBracket(struct EditConfig *config);
Prototype BOOL MatchingBracket  (struct APIMessage *apiMsg, UBYTE examine);

// the following line determines if online checks are enabled

#undef ONLINECHECK
//#define ONLINECHECK
///
/// "library functions"

struct APIClient * LibCall APIMountClient(REG(a0) struct APIMessage *apiMsg, REG(a1) char *args)
{
   static struct APIClient apiClient;

   apiClient.api_APIVersion = API_INTERFACE_VERSION;
   apiClient.api_Version    = 3;
   apiClient.api_Name       = "NewMirror";
   apiClient.api_Info       = "Bracket highlighting";
   apiClient.api_Commands   = NULL;
   apiClient.api_Serial     = 0;
   apiClient.api_Classes    = API_CLASS_SYSTEM | API_CLASS_KEY;
   apiClient.api_Area       = NULL;

   return &apiClient;
}

void LibCall APICloseClient(REG(a0) struct APIClient *handle, REG(a1) struct APIMessage *apiMsg)
{
   // no ressources to be freed
}

void LibCall APIBriefClient(REG(a0) struct APIClient *handle, REG(a1) struct APIMessage *apiMsg)
{
   struct APIMessage *msg;

   // handle host's command notify

   for (msg = apiMsg; msg; msg = msg->api_Next)
   {
      if (msg->api_State == API_STATE_NOTIFY)
      {
         switch (msg->api_Class)
         {
            case API_CLASS_KEY:
               Dispatch(msg); // useless fallthru, but it's short...

            case API_CLASS_SYSTEM:
               break;

            default:
               msg->api_Error = API_ERROR_UNKNOWN;
         }
      }
   }
}

void LibCall APIFree(REG(a0) struct APIClient *handle, REG(a1) struct APIOrder *apiOrder)
{
   // no ressources to be freed
}

///
/// "private functions"

/* --------------------------------- Dispatch ----------------------------------

 Dispatch incoming API event

*/

void Dispatch(struct APIMessage *apiMsg)
{
   struct EditConfig *config = (struct EditConfig *)apiMsg->api_Instance->api_Environment;

   if (NoUserBlock(config))
   {
      UBYTE ascii = config->CurrentBuffer[config->Column];

      if (IsABracket(ascii))
      {
         if (MatchingBracket(apiMsg, ascii) == FALSE)
         {
            if (FindMarkedBracket(config))
            {
               apiMsg->api_Refresh |= API_REFRESH_NOMARKER;
            }
         }
      }
      #ifndef ONLINECHECK
      else if (FindMarkedBracket(config))
      {
         apiMsg->api_Refresh |= API_REFRESH_NOMARKER;
      }
      #endif
      #ifdef ONLINECHECK
      else
      {
         if (apiMsg->api_Action == API_ACTION_VANILLAKEY)
         {
            if (config->Column)
            {
               ascii = (UBYTE)apiMsg->api_Data;

               // check character next to cursor

               config->Column--;

               // just typed by user?

               if (config->CurrentBuffer[config->Column] == ascii)
               {
                  if (MatchingBracket(apiMsg, ascii) == FALSE)
                  {
                     if (FindMarkedBracket(config))
                     {
                        apiMsg->api_Refresh |= API_REFRESH_NOMARKER;
                     }
                  }
               }
               else if (FindMarkedBracket(config))
               {
                  apiMsg->api_Refresh |= API_REFRESH_NOMARKER;
               }

               config->Column++;
            }
         }
         else if (FindMarkedBracket(config))
         {
            apiMsg->api_Refresh |= API_REFRESH_NOMARKER;
         }
      }
      #endif
   }
}
/* ----------------------------- FindMarkedBracket -----------------------------

 Return TRUE if a single bracket has been marked (probably by us)

*/

BOOL FindMarkedBracket(struct EditConfig *config)
{
   if (config->Marker == BLOCKMODE_CHAR)
   {
      if (config->BlockStartY == config->BlockEndY)
      {
         if (config->BlockStartX == config->BlockEndX)
         {
            UWORD pos = config->BlockStartX;

            if (config->BlockStartY == config->Line)
            {
               if (pos < config->CurrentLen)
               {
                  return IsABracket(config->CurrentBuffer[pos]);
               }
            }
            else
            {
               struct LineNode *lineNode = config->TextNodes + config->BlockStartY;

               if (pos < lineNode->Len)
               {
                  return IsABracket(lineNode->Text[pos]);
               }
            }
         }
      }
   }

   return FALSE;
}


/* ------------------------------- MatchingBracket -----------------------------

 Find matching bracket. Ignore brackets preceeded by '\' (ASCII 92, TeX
 style construction used to insert a bracket into text).

 Return TRUE if matching bracket was found, else FALSE.

 \} ............ ignored      (TEX constant)
 \\} ........... not ignored  (TEX bracket)

*/

BOOL MatchingBracket(struct APIMessage *apiMsg, UBYTE examine)
{
   UBYTE *known = "(){}[]";
   WORD   step;

   struct EditConfig *config = (struct EditConfig *)apiMsg->api_Instance->api_Environment;

   for (step = 1; *known; known++, step = -step)
   {
      if (examine == *known)
      {
         WORD   column;
         UBYTE *current;
         BOOL   isTEX;

         column  = config->Column;
         current = config->CurrentBuffer;

         if ((column > 0) && (current[column - 1] == '\\'))
         {
            if ((column > 1) && (current[column - 2] == '\\'))
            {
                isTEX = FALSE;
            }
            else
            {
                isTEX = TRUE;
            }
         }
         else
         {
            isTEX = FALSE;
         }

         if (isTEX == FALSE)
         {
            WORD   len, level, count, distance;
            BOOL   success, inString;
            ULONG  line;
            UBYTE  twin;

            inString = FALSE;
            success  = FALSE;

            line     = config->Line;
            len      = config->CurrentLen;

            twin = *(known + step);

            count    =  0;
            level    = -1;

            // modify the scan depth (default: 50 lines) to speed up the client
            #define DIST_START 50

            for (distance = DIST_START; distance; distance--)
            {
               while ((column >= 0) && (column < len))
               {
                  UBYTE *next = current + column;

                  if ((*next == '\"') || (*next == '\''))
                  {
                     inString = !inString;
                  }
                  else if (!inString)
                  {
                     if ((column > 0) && (*(next - 1) == '\\'))
                     {
                        if ((column > 1) && (*(next - 2) == '\\'))
                        {
                           isTEX = FALSE;
                        }
                        else
                        {
                           isTEX = TRUE;
                        }
                     }
                     else
                     {
                        isTEX = FALSE;
                     }

                     if (!isTEX)
                     {
                        if (*next == twin)
                        {
                           if (level)
                           {
                              level--;
                           }
                           else
                           {
                              success = TRUE;
                              break;
                           }
                        }
                        else if (*next == *known)
                        {
                           level++;
                           count++;
                        }
                     }
                  }

                  column += step;
               }

               if (success)
               {
                  BOOL adjacent = FALSE;

                  if (line == config->Line)
                  {
                     adjacent = (column == (config->Column + step));
                  }

                  if (adjacent)
                  {
                     apiMsg->api_Refresh |= API_REFRESH_NOMARKER;
                  }
                  else
                  {
                     // block markers may not be used in fold headers

                     if (GET_FOLD(config->TextNodes + line))
                     {
                        return FALSE;
                     }
                     else
                     {
                        if ((distance == DIST_START) && ((config->Marker == BLOCKMODE_NONE) || ((line == config->BlockStartY) && (line == config->BlockEndY))))
                        {
                           apiMsg->api_Refresh = API_REFRESH_LINE;
                        }
                        else
                        {
                           if (config->Marker == BLOCKMODE_NONE)
                           {
                              apiMsg->api_Refresh = API_REFRESH_MARKER;
                           }
                           else
                           {
                              apiMsg->api_Refresh = API_REFRESH_DISPLAY;
                           }
                        }

                        config->Marker = BLOCKMODE_CHAR;

                        config->BlockStartX = config->BlockEndX = column;
                        config->BlockStartY = config->BlockEndY = line;

                        return TRUE;
                     }
                  }
               }
               else
               {
                  line += step;
                  inString = FALSE;

                  if ((line >= 0) && (line < config->Lines))
                  {
                     struct LineNode *lineNode = config->TextNodes + line;

                     current = lineNode->Text;
                     len     = lineNode->Len;

                     column = (step == -1) ? len - 1 : 0;
                  }
                  else
                  {                         // no matching bracket
                     break;
                  }
               }
            }

            break;
         }
      }
   }

   return FALSE;
}

