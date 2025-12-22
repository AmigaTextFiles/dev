/* $VER: QuitRexxM2Error.rexx V 0.2 © 1994 Fin Schuppenhauer */
/* "RexxM2Error" beenden.                                    */

OPTIONS FAILAT 6

if show('P', 'REXXM2ERROR') then do
   ADDRESS 'REXXM2ERROR' 'QUIT'
end
