{  svdrivers/svdrivers.h            }
{  Version    : 3.5                 }
{  Date       : 25.03.1994          }
{  Written by : Andreas R. Kleinert }
{  PCQ-Konvertierung by Andreas Neumann }

{  SVDriver-Version V1.x+ }

TYPE
    SVD_DriverNode  =   RECORD

        svd_Node    :   Node;       { chaining Node
                                      (svd_Node->ln_Name MUST
                                      point to svd_FileName !)          }

        svd_Version :   INTEGER;    { Library-Version of svdriver       }

        svd_Flags   :   INTEGER;    { Flags, see below                  }

        svd_FileName :  ARRAY [1..108] OF CHAR; { use 30, as in struct FileInfoBlock    }

        svd_MaxWidth :  INTEGER;    { max. Screen Dimensions or 0xFFFFFFFF  }
        svd_MaxHeight : INTEGER;
        svd_MaxDepth :  INTEGER;

        svd_ID      :   ARRAY [1..80] OF CHAR;  { short description, e.g. "AGA Driver"  }

 { size may grow with bigger svd_Version, see below }

                        END;
    SVD_DriverNodePtr   =   ^SVD_DriverNode;


CONST
    SVD_VERSION =   1;              { If this Version, which depends on the
                                       svdriver's Library-Version, is set,
                                       it is guaranteed, that at least the
                                       above information is available.       }

   { Flags allowed for svd_Flags field. Values are "just for info" yet. }

    SVDF_INTUITION = (1 shl 0);     { Intuition compatible Display
                                      e.g. Amiga, ECS, AA
                                      or compatible Graphic Cards       }

    SVDF_FOREIGN   = (1 shl 1);     { incompatible Gfx Display
                                       e.g. EGS                         }

