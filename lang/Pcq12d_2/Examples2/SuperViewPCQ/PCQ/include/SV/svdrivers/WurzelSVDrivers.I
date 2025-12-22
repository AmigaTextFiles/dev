{
        SVDrivers - Include  by Andreas "Wurzelsepp" <:-) Neumann

        für SuperView-Library von Andreas R. Kleinert

        basierend auf den C-Includes von Andreas R. Kleinert

        letzte Bearbeitung  :   23.11.1994

        Linkeraufruf    :   blink MyProgram.o lib PCQ.Lib,Wurzel.Lib to
                            MyProgram

        dieses Includefile darf frei kopiert werden, solange alle
        Hinweise erhalten bleiben
                                                                        }

{$I "Include:SV/SVDrivers/SVDrivers.i" }

VAR
    SVDriverBase   :   Address;

FUNCTION SVD_AllocHandle (future : Address) : Address; EXTERNAL;

PROCEDURE SVD_FreeHandle (handle : Address); EXTERNAL;

PROCEDURE SVD_CloseDisplay (handle : Address); EXTERNAL;

PROCEDURE SVD_FreeResources (handle : Address); EXTERNAL;

FUNCTION SVD_SetGfxBuffer (handle : Address; buffer : SV_GfxBufferPtr; future : INTEGER) : INTEGER; EXTERNAL;

FUNCTION SVD_DisplayGfxBuffer (handle, future : Address) : Integer; EXTERNAL;

FUNCTION SVD_SetScreenType (handle : Address; stype : Integer; future : Address) : Integer; EXTERNAL;

FUNCTION SVD_SetWindowFlags (handle : Address; flags : INTEGER; future : Address) : Integer; EXTERNAL;

FUNCTION SVD_SetWindowIDCMP (handle : Address; idcmp : Integer; future : Address) : Integer; EXTERNAL;

FUNCTION SVD_GetScreenAddress (handle , future : Address) : ScreenPtr; EXTERNAL;

FUNCTION SVD_GetWindowAddress (handle, future : Address) : WindowPtr; EXTERNAL;
