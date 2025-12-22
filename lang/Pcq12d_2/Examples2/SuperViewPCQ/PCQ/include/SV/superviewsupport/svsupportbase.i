{  superviewsupport/svsupportbase.h }
{  Version    : 2.1                 }
{  Date       : 22.05.1994          }
{  Written by : Andreas R. Kleinert }
{  PCQ-Konvertierung by Andreas Neumann }


{$I "Include:sv/superviewsupport/superviewsupport.i" }

{$I "Include:exec/lists.i" }

{$I "include:exec/libraries.i" }

{$I "Include:sv/svdrivers/svdrivers.i" }

{ PCQ : für ExecBasePtr }
{$I "Include:exec/execbase.i" }

{ PCQ : für DOSLibraryPtr }
{$I "Include:libraries/dosextens.i" }

{ PCQ : für IntuitionBasePtr }
{$I "Include:Intuition/Intuitionbase.i" }

{ PCQ : für GfxBasePtr }
{$I "Include:Graphics/GfxBase.i" }

TYPE
    SVSupportBaseType   =   RECORD

        svb_LibNode :   Library;
        svb_SegList :   ADDRESS;
        svb_SysBase :   ExecBasePtr;
        svb_DOSBase :   DOSLibraryPtr;
        svb_IntuitionBase   :   IntuitionBasePtr;
        svb_GfxBase :   GfxBasePtr;
        svb_UtilityBase     :   LibraryPtr;

                        END;
    SVSupportBasePtr    =   ^SVSupportBaseType;
