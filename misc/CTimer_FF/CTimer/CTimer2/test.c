#include  "exec/types.h"
#include  "exec/nodes.h"
#include  "exec/ports.h"
#include  "exec/io.h"
#include  "exec/devices.h"
#include  "exec/memory.h"
#include  "devices/timer.h"
#include  "dos.h"

#ifdef  stdout
#undef  stdout
#endif

BPTR  stdout = 0 ;

main(argc, argv)
int   argc ;
char  *argv[] ;
{
   int i, apples= 0 ;

  if (argc == 0)  stdout = (BPTR)Open ("CON:25/5/600/200/FTest", 1006) ;
  
  apples = 0 ;
  Ctime(0) ;
  for (i = 0 ; i < 2000000 ; ++i)
    apples += 1 ;
  Cend(0) ;

  Ctime(2) ;
  Ctime(1) ;
  Cend(1) ;
  Cend(2) ;
  
  count_sheep() ;
  
  Creport() ;
  Delay(400) ;
  if (stdout)  Close (stdout) ;
}


count_sheep()
{ 
  int i = 0,  j = 100 ;
  
  Ctime(3) ; 
  while (i < 100)
   {
     if (i++ > --j)
       { Cend(3) ;
         return(0) ;
       }   
   }
  Cend(3) ;
  return(1) ;
}