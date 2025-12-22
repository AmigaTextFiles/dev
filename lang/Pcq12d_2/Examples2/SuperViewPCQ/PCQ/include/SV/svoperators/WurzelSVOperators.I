{
        SVOperators - Include  by Andreas "Wurzelsepp" <:-) Neumann

        für SuperView-Library von Andreas R. Kleinert

        basierend auf den C-Includes von Andreas R. Kleinert

        letzte Bearbeitung  :   23.11.1994

        Linkeraufruf    :   blink MyProgram.o lib PCQ.Lib,Wurzel.Lib to
                            MyProgram

        dieses Includefile darf frei kopiert werden, solange alle
        Hinweise erhalten bleiben
                                                                        }

{$I "Include:SV/SVOperators/SVOperators.i" }

VAR
    SVOperatorBase   :   Address;

{ Functions available since Version 1 :                                 }

FUNCTION SVP_AllocHandle (future : Address) : Address; EXTERNAL;

PROCEDURE SVP_FreeHandle (future : Address); EXTERNAL;

FUNCTION SVP_DoOperation (handle : Address; source : SV_GfxBufferPtr;
                          dest : ^SV_GfxBufferPtr; future : Address) : Integer; EXTERNAL;
