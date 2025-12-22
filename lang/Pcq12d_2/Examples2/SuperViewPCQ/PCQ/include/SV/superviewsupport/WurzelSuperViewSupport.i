{
        SVSupport - Include  by Andreas "Wurzelsepp" <:-) Neumann

        für SuperView-Library von Andreas R. Kleinert

        basierend auf den C-Includes von Andreas R. Kleinert

        letzte Bearbeitung  :   23.11.1994

        Linkeraufruf    :   blink MyProgram.o lib PCQ.Lib,Wurzel.Lib to
                            MyProgram

        dieses Includefile darf frei kopiert werden, solange alle
        Hinweise erhalten bleiben
                                                                        }

{$I "Include:SV/SuperviewSupport/SuperViewSupport.i" }

VAR
    SVSupportBase   :   Address;


{ Functions available since Version 1 :                                 }

FUNCTION SVSUP_GetMemList : Address; EXTERNAL;

PROCEDURE SVSUP_FreeMemList (handle : Address); EXTERNAL;

FUNCTION SVSUP_AddMemEntry (handle , pointer : Address) : Integer; EXTERNAL;

FUNCTION SVSUP_AllocMemEntry (handle : Address; size, mtype : INTEGER) : Address; EXTERNAL;

FUNCTION SVSUP_CheckInterleaved (sc : ScreenPtr) : Integer; EXTERNAL;

FUNCTION SVSUP_GetXAspect (sc : ScreenPtr) : Byte; EXTERNAL;

FUNCTION SVSUP_GetYAspect (sc : ScreenPtr) : Byte; EXTERNAL;

FUNCTION SVSUP_GetBitMapDepth (sc : ScreenPtr) : Integer; EXTERNAL;

FUNCTION SVSUP_GetBitMapHeight (sc : ScreenPtr) : Integer; EXTERNAL;

FUNCTION SVSUP_GetBodySize (sc : ScreenPtr) : Integer; EXTERNAL;

FUNCTION SVSUP_GetStdScreenSize (mode_id : Integer; width, height : ^Integer) : Integer; EXTERNAL;

FUNCTION SVSUP_GetBestModeID (width , height , depth : Integer) : Integer; EXTERNAL;

FUNCTION SVSUP_CopyScreenToBuffer8 (sc : ScreenPtr; buffer : Address;
                                    width, height, depth : Integer) : Integer; EXTERNAL;

{ Functions available since Version 2 :                                 }

FUNCTION SVSUP_LoadControlPad (filename : String; pad : ^SV_ControlPadPtr) : Integer; EXTERNAL;

FUNCTION SVSUP_SaveControlPad  (filename : String; pad : SV_ControlPadPtr) : Integer; EXTERNAL;

FUNCTION SVSUP_FreeControlPad (pad : SV_ControlPadPtr) : Integer; EXTERNAL;

FUNCTION SVSUP_FindControlPad (pad : SV_ControlPadPtr; name : String;
                               content : ^String) : Integer; EXTERNAL;

{ Functions available since Version 3 :                                 }

FUNCTION SVSUP_BitPlaneToOnePlane8 (gfxb : SV_GfxBufferPtr; destgfxb : ^SV_GfxBufferPtr) : Integer; EXTERNAL;

FUNCTION SVSUP_OnePlaneToBitPlane8 (gfxb : SV_GfxBufferPtr; destgfxb : ^SV_GfxBufferPtr) : Integer; EXTERNAL;

FUNCTION SVSUP_ScreenToOnePlane8 (sc : ScreenPtr; destgfxb : ^SV_GfxBufferPtr) : Integer; EXTERNAL;

FUNCTION SVSUP_ScreenToBitPlane8 (sc : ScreenPtr; destgfxb : ^SV_GfxBufferPtr) : Integer; EXTERNAL;

{ Functions available since Version 4 :                                 }

FUNCTION SVSUP_DisplayGfxBuffer (disphandle : SVSUP_DisplayHandlePtr) : Integer; EXTERNAL;

FUNCTION SVSUP_UnDisplayGfxBuffer (disphandle : SVSUP_DisplayHandlePtr) : Integer; EXTERNAL;

FUNCTION SVSUP_FreeGfxBuffer (gfxbuffer : SV_GfxBufferPtr) : Integer; EXTERNAL;

{ Functions available since Version 5 :                                 }

FUNCTION SVSUP_FindControlPadNoCase (pad : SV_ControlPadPtr; name : String ;
                                     content : ^String) : Integer; EXTERNAL;

FUNCTION SVSUP_ModifyControlPad (pad : SV_ControlPadPtr; name : String;
                                 content : String; bool : Integer) : Integer; EXTERNAL;

FUNCTION SVSUP_AddControlPad (pad : SV_ControlPadPtr; name : String;
                              content : String ; bool : Integer) : Integer; EXTERNAL;
