{  svoperators/svoperators.h        }
{  Version    : 9.1                 }
{  Date       : 24.09.1994          }
{  Written by : Andreas R. Kleinert }

{  SVOperator-Version V1.x+ }


TYPE

    SVP_OperatorNode    =   RECORD

        svp_Node    :   Node;       { chaining Node
                                      (svp_Node->ln_Name is NULL
                                      by default !)                         }

        svp_Version :   INTEGER;    { Library-Version of svoperator         }

        svp_FileName :  ARRAY [1..108] OF CHAR; { use 30, as in struct FileInfoBlock    }

        svp_Description : ARRAY [1..80] OF CHAR; { e.g. "HAM8 -> HAM6"                  }
        svp_Author  :   ARRAY [1..80] OF CHAR;  { e.g. "me :-)"                         }

        svp_Flags   :   INTEGER;    { SVP_FLAG_... (see below)              }

                            END;
    SVP_OperatorNodePtr =   ^SVP_OperatorNode;

CONST

    SVP_VERSION =   1;          {   If this Version, which depends on the
                                    svobject's Library-Version, is set,
                                    it is guaranteed, that at least the
                                    above information is available.         }

    SVP_FLAGS_RESERVED = $FFFFFFFF; { none used yet }

