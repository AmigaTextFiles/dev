{  superview/superviewbase.h        }
{  Version    : 9.1                 }
{  Date       : 24.09.1994          }
{  Written by : Andreas R. Kleinert }
{  PCQ - Konvertierung : Andreas Neumann }


{$I "Include:SV/SuperView/Superview.i" }

{$I "Include:exec/lists.i" }

{$I "Include:Exec/libraries.i" }

{$I "include:sv/SVDrivers/SVDrivers.i" }

{ PCQ : für ExecBasePtr }
{$I "Include:exec/execbase.i" }

{ PCQ : für DOSLibraryPtr }
{$I "Include:libraries/dosextens.i" }

{ PCQ : für IntuitionBasePtr }
{$I "Include:Intuition/Intuitionbase.i" }

{ PCQ : für GfxBasePtr }
{$I "Include:Graphics/GfxBase.i" }

{ PCQ : für SVSupportBase }
{$I "Include:SV/SuperViewSupport/SvSupportbase.i" }


    {
      All entries are READ-ONLY.
      The private entries should NEVER be accessed.
    }

TYPE
    SuperViewBaseType   =   RECORD
        svb_LibNode     :   Library;
        svb_SegList     :   Address;
        svb_SysBase     :   ExecBasePtr;
        svb_DOSBase     :   DOSLibraryPtr;
        svb_IntuitionBase : IntuitionBasePtr;
        svb_GfxBase     :   GfxBasePtr;

    { next have been added with V2 : }

        svb_IFFParseBase :  LibraryPtr;     { may be NULL }
        svb_DataTypesBase : LibraryPtr;     { may be NULL }

        svb_SVObjectList :  List;    { see SVL_GetSVObjectList()      }
        svb_Private1    :   INTEGER; { DO NOT ACCESS }
        svb_Private2    :   INTEGER; { DO NOT ACCESS }
        svb_Private3    :   INTEGER; { DO NOT ACCESS }

    { next have been added with V3 : }

        svb_SVDriverList :  List;   { see SVL_GetSVDriverList()      }
        svb_GlobalDriver :  SVD_DriverNodePtr; { may be NULL for Default-Driver }

    { next have been added with V4 : }

        svb_UtilityBase :   LibraryPtr;
        svb_SVSupportBase : SVSupportBasePtr;

    { next have been added with V9 : }

        svb_SVOperatorList : List; { see SVL_GetSVOperatorList()   }

                        END;
    SuperViewBasePtr    =   ^SuperViewBaseType;

