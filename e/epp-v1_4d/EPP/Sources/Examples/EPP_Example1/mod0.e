/*
   See mod2.e for some interesting insight
   into how EPP reacts to your code.
*/

PMODULE 'mod1';PMODULE 'mod4';
PMODULE 'mod1';
PMODULE 'mod6'

CONST MOD0 = 0

OBJECT objInMod0
  x, y
ENDOBJECT

DEF defInMod0


PROC procInMod0 ()
ENDPROC


PMODULE 'procX';


PROC main ()
  /* mod0 */
ENDPROC
