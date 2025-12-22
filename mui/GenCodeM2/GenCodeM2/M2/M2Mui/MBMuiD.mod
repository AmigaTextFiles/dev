IMPLEMENTATION MODULE MuiD;


(* Implementation-Module for MuiD
** done in 1993 by Christian "Kochtopf" Scholz
*)


        PROCEDURE mvWindowTopEdgeDelta(p:LONGINT): LONGINT;
            BEGIN;
               RETURN (-3-(p));
            END mvWindowTopEdgeDelta;
        PROCEDURE mvWindowWidthMinMax(p:LONGINT): LONGINT;
            BEGIN;
               RETURN (0-(p)); 
            END mvWindowWidthMinMax;
        PROCEDURE mvWindowWidthVisible(p:LONGINT): LONGINT; 
            BEGIN; 
               RETURN (-100-(p)); 
            END mvWindowWidthVisible;
        PROCEDURE mvWindowWidthScreen(p:LONGINT): LONGINT; 
            BEGIN; 
               RETURN (-200-(p)); 
            END mvWindowWidthScreen;
        PROCEDURE mvWindowHeightMinMax(p:LONGINT): LONGINT; 
            BEGIN; 
               RETURN (0-(p)); 
            END mvWindowHeightMinMax;
        PROCEDURE mvWindowHeightVisible(p:LONGINT): LONGINT; 
            BEGIN; 
               RETURN (-100-(p)); 
            END mvWindowHeightVisible;
        PROCEDURE mvWindowHeightScreen(p:LONGINT): LONGINT; 
            BEGIN; 
               RETURN (-200-(p)); 
            END mvWindowHeightScreen;
        PROCEDURE mvWindowAltTopEdgeDelta(p:LONGINT): LONGINT; 
            BEGIN; 
               RETURN (-3-(p)); 
            END mvWindowAltTopEdgeDelta ;
        PROCEDURE mvWindowAltWidthMinMax(p:LONGINT): LONGINT; 
            BEGIN; 
               RETURN (0-(p)); 
            END mvWindowAltWidthMinMax;
        PROCEDURE mvWindowAltWidthVisible(p:LONGINT): LONGINT; 
            BEGIN; 
               RETURN (-100-(p)); 
            END mvWindowAltWidthVisible;
        PROCEDURE mvWindowAltWidthScreen(p:LONGINT): LONGINT; 
            BEGIN; 
               RETURN (-200-(p));
            END mvWindowAltWidthScreen;
        PROCEDURE mvWindowAltHeightMinMax(p:LONGINT): LONGINT; 
            BEGIN; 
               RETURN (0-(p))
            END mvWindowAltHeightMinMax;
        PROCEDURE mvWindowAltHeightVisible(p:LONGINT): LONGINT; 
            BEGIN; 
               RETURN (-100-(p))
            END mvWindowAltHeightVisible;
        PROCEDURE mvWindowAltHeightScreen(p:LONGINT): LONGINT; 
            BEGIN; 
               RETURN (-200-(p))
            END mvWindowAltHeightScreen;


END MuiD.
