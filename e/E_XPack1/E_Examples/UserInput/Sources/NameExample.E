/* Get A Persons Name And Display It On Screen
         An Example On How To Read User Input From CLI By Edward Farrow   */

PROC main()
DEF moo[256]:STRING                  /* Memory To Store Reply In */

   WriteF('What Is Your Name? ')     /* Say The Message */
      ReadStr(stdout,moo)            /* Read The Reply  */
   WriteF('Your Name Is \s\n',moo) /* Display Answer! */

ENDPROC

