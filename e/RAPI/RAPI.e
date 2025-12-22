/* An example of usage of random numbers in E to show pattern in algorithym
probobaly not the best code.  Just cause this is my first attempt at programing
in E. */

DEF w,randuma,i,randumb,randumc  /* declaration of varibles used */

PROC main()
   IF w:=OpenW(20,11,400,100,$200,$f,'RAPI © 1993 Bryce Bockman',NIL,1,NIL)   /* Opens window to be used */
      FOR i:= 0 TO 10000         /* start loop here */
         mylabel:                /* loop reference */
         randuma:=Rnd(379)       /* gets random number to plot the x cord.  379 is max x cord of the window to be written to */
         randumb:=Rnd(98)        /* gets random number for y cord. */
         randumc:=Rnd(4)         /* gets randum color of pixel from 4 */
         IF randumb<11 THEN JUMP mylabel      /* makes sure that */ 
         IF randuma<6 THEN JUMP mylabel      /* the borders arent drawn to*/
         Plot(randuma,randumb,randumc)  /*plots point at random x,y,color*/
      ENDFOR                    /* end of for loop */
      WaitIMessage(w)           /* waits for user input close gadget */
      CloseW(w)                 /* closes window */
   ENDIF                        /* end of If block */
ENDPROC                         /* end of main function */

/* Bryce Bockman 1:350/32.2 */

