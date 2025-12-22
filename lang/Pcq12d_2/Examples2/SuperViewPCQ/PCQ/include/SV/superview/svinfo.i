{  superview/svinfo.h               }
{  Version    : 9.1                 }
{  Date       : 25.09.1994          }
{  Written by : Andreas R. Kleinert }
{  PCQ-Konvertierung by Andreas Neumann }

{$I "Include:SV/Superview/Superview.i" }


{  *************************************************** }
{  *                                                 * }
{  * Information structures (SVObjects & SVDrivers)  * }
{  *                                                 * }
{  *************************************************** }

    { the following have been introduced with V6 : }

TYPE

    SVObjectInfo    =   RECORD

        soi_Type    :   INTEGER;        { valid SubTypeCode value       }
        soi_Flags   :   INTEGER;        { Copy of Flags from svo_Flags  }
        soi_TypeName :  ^Byte;          { Copy of svo_TypeID and
                                          svo_SubTypeID[x]              }

        soi_NextEntry : ^SVObjectInfo;  { Pointer to next entry or NULL }

                        END;
    SVObjectInfoPtr =   ^SVObjectInfo;


    SVDriverInfo    =   RECORD

        sdi_Flags   :   INTEGER;        { Copy of Flags from svd_Flags  }
        sdi_Name    :   ADDRESS;        { Pointer to svd_ID             }

        sdi_NextEntry : ^SVDriverInfo;  { Pointer to next entry or NULL }

                        END;
    SVDriverInfoPtr =   ^SVDriverInfo;

    { the following has been introduced with V9 : }


    SVOperatorInfo  =   RECORD

        spi_Flags   :   INTEGER;        { Copy of Flags from svp_Flags  }
        spi_Desc    :   Address;        { Pointer to svd_Description    }
        spi_Author  :   Address;        { Pointer to svd_Author         }

        spi_NextEntry : ^SVOperatorInfo; { Pointer to next entry or NULL }

                        END;
    SVOperatorInfoPtr   =   ^SVOperatorInfo;

