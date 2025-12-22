#include <stdio.h>
main()
{
int a,b,c;

   for (a=0;a<10;a++)
   {
      printf("OUTSIDE LOOP\n");  
      for (b=0;b<10;b++)
      {
         printf("MIDDLE LOOP\n");
         for (c=0;c<10;c++)
         {
            printf("INSIDE LOOP\n");
         }
      }      
   }
}    