{
        SuperView - Include  by Andreas "Wurzelsepp" <:-) Neumann

        für SuperView-Library von Andreas R. Kleinert

        basierend auf den C-Includes von Andreas R. Kleinert

        letzte Bearbeitung  :   23.11.1994

        Linkeraufruf    :   blink MyProgram.o lib PCQ.Lib,Wurzel.Lib to
                            MyProgram

        dieses Includefile darf frei kopiert werden, solange alle
        Hinweise erhalten bleiben
                                                                        }

{$I "Include:SV/SuperView/SuperView.i" }
{$I "Include:SV/SuperView/SuperViewBase.i" }
{$I "Include:SV/SuperviewSupport/WurzelSuperViewSupport.i" }
{$I "Include:SV/SVOperators/WurzelSVOperators.i" }
{$I "Include:SV/SVObjects/WurzelSVObjects.i" }
{$I "Include:SV/SVDrivers/WurzelSVDrivers.i" }


VAR
    SuperViewBase   :   SuperViewBasePtr;


FUNCTION SVL_AllocHandle (future : Address) : Address; EXTERNAL;

PROCEDURE SVL_FreeHandle (handle : Address); EXTERNAL;

PROCEDURE SVL_CloseDisplay (handle : Address); EXTERNAL;

PROCEDURE SVL_FreeResources (handle : Address); EXTERNAL;

FUNCTION SVL_SuperView (handle : Address ; char : String) : INTEGER; EXTERNAL;

FUNCTION SVL_SuperWrite (handle : Address ; source_handle : Address) : Integer; EXTERNAL;

FUNCTION SVL_InitHandleAsDOS (handle , future : Address) : Integer; EXTERNAL;

FUNCTION SVL_InitHandleAsClip (handle, future : Address) : Integer; EXTERNAL;

FUNCTION SVL_SetWriteType (handle : Address; write_type : Integer; future : Address) : Integer; EXTERNAL;

FUNCTION SVL_SetWindowIDCMP (handle : Address; idcmp : Integer; future : Address) : Integer; EXTERNAL;

FUNCTION SVL_SetWindowFlags (handle : Address; flags : Integer; future : Address) : Integer; EXTERNAL;

FUNCTION SVL_SetScreenType (handle : Address; stype : Integer; future : Address) : Integer; EXTERNAL;

FUNCTION SVL_GetWindowAddress (handle : Address; win : ^WindowPtr; future : Address) : Integer; EXTERNAL;

FUNCTION SVL_GetScreenAddress (handle : Address; scr : ^ScreenPtr; future : Address) : Integer; EXTERNAL;

FUNCTION SVL_GetErrorString (error_code : INTEGER) : String; EXTERNAL;

FUNCTION SVL_SetWriteScreen (handle : Address; scr : ScreenPtr; future : Address) : Integer; EXTERNAL;

FUNCTION SVL_SetWriteName (handle : Address; write_name : INTEGER; future : Address) : Integer; EXTERNAL;

FUNCTION SVL_FileInfoRequest (handle : Address; win : WindowPtr; future : Address) : Integer; EXTERNAL;

{ Functions added withe Version 3 - 5 :                                 }

FUNCTION SVL_GetGlobalDriver (driver : ^SVD_DriverNodePtr; future : Integer) : Integer; EXTERNAL;

FUNCTION SVL_SetGlobalDriver (driver : SVD_DriverNodePtr; future : Integer) : Integer; EXTERNAL;

FUNCTION SVL_ReadToGfxBuffer (handle : Address; filename : String) : Integer; EXTERNAL;

FUNCTION SVL_GetGfxBuffer (handle : Address; buffer : ^SV_GfxBufferPtr; future : Integer) : Integer; EXTERNAL;

FUNCTION SVL_SetGfxBuffer (handle : Address; buffer : SV_GfxBufferPtr; future : Integer) : Integer; EXTERNAL;

FUNCTION SVL_DisplayGfxBuffer (handle : Address; buffer : SV_GfxBufferPtr; future : Integer) : Integer; EXTERNAL;

{ Functions added with Version 6 :                                      }

FUNCTION SVL_GetSVObjectList (listhead : ^SVObjectInfoPtr) : Integer; EXTERNAL;

FUNCTION SVL_GetSVDriverList (listhead : ^SVDriverInfoPtr) : Integer; EXTERNAL;

FUNCTION SVL_FreeSVObjectList (listhead : SVObjectInfoPtr) : Integer; EXTERNAL;

FUNCTION SVL_FreeSVDriverList (listhead : SVDriverInfoPtr) : Integer; EXTERNAL;

{ Functions added with Version 7 :                                      }

FUNCTION SVL_RemoveSVObject (svo_node : SVO_ObjectNodePtr) : Integer; EXTERNAL;

FUNCTION SVL_RemoveSVDriver (svd_node : SVD_DriverNodePtr) : Integer; EXTERNAL;

FUNCTION SVL_AddSVObject (name : String) : Integer; EXTERNAL;

FUNCTION SVL_AddSVDriver (name : String) : Integer; EXTERNAL;

{ Functions added with Version 8 :                                      }

FUNCTION SVL_GetFileType (handle : Address; filename : String; filetype : Integer) : Integer; EXTERNAL;

{ Functions added with Version 9 :                                      }

FUNCTION SVL_DoOperation (handle : Address; source : SV_GfxBufferPtr;
                          dest : ^SV_GfxBufferPtr;
                          operator : SVP_OperatorNodePtr; future : Address) : Integer; EXTERNAL;

FUNCTION SVL_GetSVOperatorList (listhead : ^SVOperatorInfoPtr) : Integer; EXTERNAL;

FUNCTION SVL_FreeSVOperatorList (listehead : SVOperatorInfoPtr) : Integer; EXTERNAL;

FUNCTION SVL_RemoveSVOperator (svp_node : SVP_OperatorNodePtr) : Integer; EXTERNAL;

FUNCTION SVL_AddSVOperator (name : String) : Integer; EXTERNAL;
