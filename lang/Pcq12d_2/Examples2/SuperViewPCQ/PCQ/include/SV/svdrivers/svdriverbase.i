{  svdrivers/svdriverbase.h         }
{  Version    : 3.5                 }
{  Date       : 28.03.1994          }
{  Written by : Andreas R. Kleinert }
{  PCQ-Konvertierung by Andreas Neumann }

{  SVDriver-Version V1.x+ }

{$I "Include:SV/svdrivers/svdrivers.i" }

{$I "include:exec/lists.i" }

{$I "include:exec/libraries.i" }

    { An external Driver-Library (for graphics cards, framebuffers, etc.)
      for the superview.library is called a "svdriver".
      Each svdriver has to contain a "SVD_DriverNode" structure (as follows)
      in its Library-Header, which later will be READ and MODIFIED by
      the superview.library.
    }

    { The Construction of a svdriver :
      ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

      The Library Base
      ----------------

      Version MUST be 1 yet, Revision can be set freely

      (see structure described below)


      The Function Table
      ------------------

      (see <pragmas/svdrivers.h> or Reference_ENG.doc)

    }

{  *************************************************** }
{  *                                                 * }
{  * Library base Definition for svdrivers           * }
{  *                                                 * }
{  *************************************************** }

TYPE
    SVDriverBaseType    =   RECORD

        svb_LibNode :   Library;        { Exec LibNode                  }
        svb_SVDriver :  SVD_DriverNodePtr;  { POINTER to initialized
                                              SVD_DriverNode
                                              Define it somewhere else,
                                              then initialize this pointer. }

        svd_Reserved :  ARRAY [1..32] OF INTEGER; { Reserved for future expansion.
                                                    Always NULL yet (Version 1).   }

 {
   Private data of the svdriver, not to be accessed
   by superview.library, may follow.
 }

                        END;
    SVDriverBasePtr =   ^SVDriverBaseType;
