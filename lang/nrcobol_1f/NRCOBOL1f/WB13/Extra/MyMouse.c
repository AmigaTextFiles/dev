/* read mouse and run script if exist ... 18/12/97   */
/* very useful for ShapeShifter boot  cHArRiOTt      */

#include<stdio.h>
extern int ReadM();

int main(argc,argv)
int   argc;
char  *argv[];
{
int Mval;
FILE *tests;
char dodis[270],esc=27;


   if ((*argv[1]=='?') ||argc==1 ||(argc>5))
   {
      printf("Mymouse Usage..:%c[1mMymouse%c[0m <none.script> [right.script] [left.script] [both.script]\n",esc,esc);
      exit(0);
   }

   Mval=ReadM();
   switch(Mval)
   {
     case 0 : if ((argc>1)&&(tests=fopen(argv[1],"r")))    /* none */
                 {
                    fclose(tests);
                    sprintf(&dodis[0],"execute %s",argv[1]);
                    system(&dodis[0],0);
                 }; break;

     case 1 : if ((argc>3)&&(tests=fopen(argv[3],"r")))    /* left */
                 {
                    fclose(tests);
                    sprintf(&dodis[0],"execute %s",argv[3]);
                    system(&dodis[0],0);
                 } break;

     case 2: if ((argc>2)&&(tests=fopen(argv[2],"r")))     /* right */
                 {
                    fclose(tests);
                    sprintf(&dodis[0],"execute %s",argv[2]);
                    system(&dodis[0],0);
                 } break;

     case 3 : if ((argc>4)&&(tests=fopen(argv[4],"r")))    /* both */
                 {
                    fclose(tests);
                    sprintf(&dodis[0],"execute %s",argv[4]);
                    system(&dodis[0],0);
                 } break;
   }


   exit (0);
   return(0);
}

