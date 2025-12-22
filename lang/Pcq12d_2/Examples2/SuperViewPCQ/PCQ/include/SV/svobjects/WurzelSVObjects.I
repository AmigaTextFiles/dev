{
        SVObjects - Include  by Andreas "Wurzelsepp" <:-) Neumann

        für SuperView-Library von Andreas R. Kleinert

        basierend auf den C-Includes von Andreas R. Kleinert

        letzte Bearbeitung  :   23.11.1994

        Linkeraufruf    :   blink MyProgram.o lib PCQ.Lib,Wurzel.Lib to
                            MyProgram

        dieses Includefile darf frei kopiert werden, solange alle
        Hinweise erhalten bleiben
                                                                        }

{$I "Include:SV/SVObjects/SVObjects.i" }

VAR
    SVObjectBase   :   Address;

{ Functions available since Version 1 :                                 }

FUNCTION SVO_AllocHandle (future : Address) : Address; EXTERNAL;

PROCEDURE SVO_FreeHandle (handle : Address); EXTERNAL;

FUNCTION SVO_Show (handle : Address) : Integer; EXTERNAL;

FUNCTION SVO_Write (handle : Address) : Integer; EXTERNAL;

PROCEDURE SVO_CloseDisplay (handle : Address); EXTERNAL;

PROCEDURE SVO_FreeResources (handle : Address); EXTERNAL;

FUNCTION SVO_SetAccessMode (handle : Address ; mode : Integer) : Integer; EXTERNAL;

FUNCTION SVO_SetScreenType (handle : Address ; stype : Integer; future : Address) : Integer; EXTERNAL;

FUNCTION SVO_SetWindowFlags (handle : Address ; flags : Integer; future : Address) : Integer; EXTERNAL;

FUNCTION SVO_SetWindowIDCMP (handle : Address; idcmp : Integer; future : Address) : Integer; EXTERNAL;

FUNCTION SVO_GetScreenAddress (handle , future : Address) : ScreenPtr; EXTERNAL;

FUNCTION SVO_GetWindowAddress (handle, future : Address) : WindowPtr; EXTERNAL;

FUNCTION SVO_SetScreenAddress (handle : Address ; sc : ScreenPtr; future : Address) : Integer; EXTERNAL;

FUNCTION SVO_SetWindowAddress (handle : Address ; win : WindowPtr ; future : Address) : Integer; EXTERNAL;

FUNCTION SVO_SetWriteName (handle : Address; name : String; future : Address) : Integer; EXTERNAL;

FUNCTION SVO_SetReadName (handle : Address; name : String; future : Address) : Integer; EXTERNAL;

FUNCTION SVO_FileInfoRequest (handle : Address ; win : WindowPtr; future : Address) : Integer; EXTERNAL;

FUNCTION SVO_CheckFileType (fileh : BPTR; filename : String; svo_check : SVOCheckFilePtr) : Integer; EXTERNAL;

{ Functions added with Version 2 :                                      }

FUNCTION SVO_ReadToGfxBuffer (handle : Address) : Integer; EXTERNAL;

FUNCTION SVO_GetGfxBuffer (handle : Address; buffer : ^SV_GfxBufferPtr; future : Integer) : Integer; EXTERNAL;

FUNCTION SVO_SetGfxBuffer (handle : Address; buffer : SV_GfxBufferPtr; future : Integer) : Integer; EXTERNAL;
