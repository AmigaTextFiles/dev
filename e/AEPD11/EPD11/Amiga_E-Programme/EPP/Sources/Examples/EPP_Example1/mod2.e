CONST MOD2 = 2   /* Multi-line
                    comments.
                 */

/*
   Everything from the beginning of the defs
   section to the line preceding the first
   PROC statement will be copied.
*/

OBJECT objInMod2
  x, y
ENDOBJECT

DEF defInMod2   /* Multi-line
                    comments at end of defs.
                */

/* Module mod2, lines preceding first PROC statement.  This simulates */
/* comments that describe procInMod2 (), but they do not end up near  */
/* mod2 procs.                                                        */
PROC procInMod2 ()  /* Everything between the PROC and
                       ENDPROC statements are included.
                    */
ENDPROC  /* Multi-line comments
            after ENDPROC.
         */


PROC singleLineProc () RETURN TRUE
  /* Everything gets copied until the next PROC statement. */


PROC main ()
  /* mod2 */
ENDPROC
