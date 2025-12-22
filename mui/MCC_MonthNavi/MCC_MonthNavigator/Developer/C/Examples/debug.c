
 #include "debug.h"


 static nest_level = 0;


 void debug_inc_nest_level(void)
  {
   nest_level++;
  }


 void debug_dec_nest_level(void)
  {
   nest_level--;
  }


 void debug_print_nest(void)
  {
   unsigned short i = nest_level;

   while (i>0)
    {
     DEBUG_PRINT_NEST
     i--;
    }
  }
