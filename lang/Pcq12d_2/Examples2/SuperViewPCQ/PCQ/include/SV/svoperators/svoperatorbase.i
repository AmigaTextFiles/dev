{  svoperator/svoperatorbase.h      }
{  Version    : 9.1                 }
{  Date       : 24.09.1994          }
{  Written by : Andreas R. Kleinert }
{  PCQ-Konvertierung by Andreas Neumann }

{  SVOperator-Version V1.x+ }

{$I "include:sv/svoperators/svoperators.i" }

{$I "include:exec/lists.i" }

{$I "include:exec/libraries.i" }

   {  An external support-library for the superview.library is called a
      "svoperator".
      Each svoperator has to contain a "SVP_OperatorNode" structure (as follows)
      in its Library-Header, which later will be READ and MODIFIED by
      the superview.library.
      Because the superview.library supports three different sorts
      of SVOperators at the time (internal, independent and external),
      there are three different types of this structure (might be more in
      the future), which can be identified via their "svp_OperatorType".
   }

   { The Construction of a svoperator :
      ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

      The Library Base
      ----------------

      Version MUST be 1 yet, Revision can be set freely

      (see structure described below)


      The Function Table
      ------------------

      (see <pragmas/svoperators.h> or Reference_ENG.doc)

   }

{  *************************************************** }
{  *                                                 * }
{  * Library base Definition for svoperators         * }
{  *                                                 * }
{  *************************************************** }

TYPE
    SVOperatorBaseType  =   RECORD

            svb_LibNode :   Library;    {* Exec LibNode                   }
            svb_SVOperator : SVP_OperatorNodePtr;  { POINTER to initialized
                                                     SVP_OperatorNode
                                                     Define it somewhere else,
                                                     then initialize this pointer.  }

            svp_Reserved : ARRAY [1..32] OF INTEGER; { Reserved for future expansion.
                                                       Always NULL yet (Version 1).   }

 {
   Private data of the svoperator, not to be accessed
   by superview.library, may follow.
 }
                        END;
    SVOperatorBasePtr   =   ^SVOperatorBaseType;


