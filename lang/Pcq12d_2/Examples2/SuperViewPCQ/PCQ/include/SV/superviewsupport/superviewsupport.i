{  superviewsupport/superviewsupport.h }
{  Version    : 4.1                    }
{  Date       : 14.06.1994             }
{  Written by : Andreas R. Kleinert    }
{  PCQ-Konvertierung by Andreas Neumann }

{ für PCQ : }
{$I "Include:sv/SvDrivers/SVDriverBase.i" }

{  *************************************************** }
{  *                                                 * }
{  * Version Defines                                 * }
{  *                                                 * }
{  *************************************************** }

CONST
    SVSUPPORTLIB_VERSION    =   4;


{  *************************************************** }
{  *                                                 * }
{  * Includes                                        * }
{  *                                                 * }
{  *************************************************** }


{  *************************************************** }
{  *                                                 * }
{  * Custom Defines                                  * }
{  *                                                 * }
{  *************************************************** }

    N2  =   NIL;


TYPE

{   === ControlPads === }

{  see documentation for more and detailed information on ControlPad-Files }

    SV_ControlPad   =   RECORD      { These ControlPads are supplied as     }
                                    { single-chained list, where the        }
        svc_EntryName : ^BYTE;      { pointer to the last entry is NULL.    }
        svc_EntryContent : ^BYTE;   { Do not free them by Hand.             }

        svc_NextEntry : ADDRESS;

                        END;
    SV_ControlPadPtr    =   ^SV_ControlPad;


{   === Handle for SVSUP_DisplayGfxBuffer()                 === }
{  (has to be allocated, initialized and delocated by the User) }

    SVSUP_DisplayHandle =   RECORD

 { MUST be initialized : }

        Version     :   INTEGER;        { currently 4 }

        SVGfxBuffer :   SV_GfxBufferPtr;
        SVDriverNode :  SVD_DriverNodePtr;

 { MAY be initialized : }

        WinIDCMP    :   INTEGER;        { Window's IDCMP }
        WinFlags    :   INTEGER;        { Window's Flags }
        ScrType     :   INTEGER;        { Screen-Type    }

 { MUST NOT be initialized (read-only) : }

        SVDriverBase :  SVDriverBasePtr;
        SVDriverHandle : ADDRESS;

        Window      :   WindowPtr;
        Screen      :   ScreenPtr;

 { end of version 4 entries }

                            END;
    SVSUP_DisplayHandlePtr  =   ^SVSUP_DisplayHandle;

