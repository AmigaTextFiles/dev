{  svobjects/svobjectbase.h         }
{  Version    : 3.7                 }
{  Date       : 28.04.1994          }
{  Written by : Andreas R. Kleinert }
{  PCQ-Konvertierung by Andreas Neumann }

{  SVObject-Version V2.x+ }

{$I "include:sv/svobjects/svobjects.i" }

{$I "include:exec/lists.i" }

{$I "include:exec/libraries.i" }

   {  An external support-library for the superview.library is called a
      "svobject".
      Each svobject has to contain a "SVO_ObjectNode" structure (as follows)
      in its Library-Header, which later will be READ and MODIFIED by
      the superview.library.
      Because the superview.library supports three different sorts
      of SVObjects at the time (internal, independent and external),
      there are three different types of this structure (might be more in
      the future), which can be identified via their "svo_ObjectType".
   }

   {  The Construction of a svobject :
      ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

      The Library Base
      ----------------

      Version MUST be 2 yet, Revision can be set freely

      (see structure described below)


      The Function Table
      ------------------

      (see <pragmas/svobjects.h> or Reference_ENG.doc)

   }

{  *************************************************** }
{  *                                                 * }
{  * Library base Definition for svobjects           * }
{  *                                                 * }
{  *************************************************** }

TYPE
    SVObjectBaseType    =   RECORD

            svb_LibNode :   Library;    { Exec LibNode                   }
            svb_SVObject :  SVO_ObjectNodePtr;  { POINTER to initialized
                                                  SVO_ObjectNode
                                                  Define it somewhere else,
                                                  then initialize this pointer.  }

            svo_Reserved :  ARRAY [1..32] OF INTEGER; { Reserved for future expansion.
                                                        Always NULL yet (Version 1).   }

 {
   Private data of the svobject, not to be accessed
   by superview.library, may follow.
 }

                        END;
    SVObjectBasePtr =   ^SVObjectBaseType;

