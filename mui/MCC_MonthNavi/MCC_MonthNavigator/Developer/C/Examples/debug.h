 /* Copyright © 1999 Dipl.-Inform. Kai Hofmann. All rights reserved. */


 #ifndef DEBUG_H
   #define DEBUG_H


   #include <exec/types.h>
   #include <string.h>


   void debug_inc_nest_level(void);
   void debug_dec_nest_level(void);
   void debug_print_nest(void);


   #ifdef DEBUG

     void __far kprintf(UBYTE *fmt, ...);
     /* void dprintf(UBYTE *fmt,...); */

     /* Left in beta release */
     #define DEBUG_PRINT_NEST		kprintf("  ");
     #define DEBUG_PCHECK(cond)		if (!(cond)) {debug_print_nest(); kprintf("PCHECK: %s:%5lu " #cond "\n",__FILE__,(unsigned long)__LINE__);}

     #if DEBUG > 1
       /* No output in normal code path */
       #define DEBUG_ASSERT(cond)	if (!(cond)) {debug_print_nest(); kprintf("ASSERT: %s:%5lu " #cond "\n",__FILE__,(unsigned long)__LINE__);}

       #if DEBUG > 2
         /* Very basic output */
         /* enter/exit output + parameters/return */
         #define DEBUG_ENTER(name)		debug_print_nest(); kprintf("ENTER : %s:%5lu %s()\n",__FILE__,(unsigned long)__LINE__,name); debug_inc_nest_level();
         #define DEBUG_EXIT(name,fmt,ret_val)	debug_dec_nest_level(); debug_print_nest(); kprintf("EXIT  : %s:%5lu %s()%s" fmt "\n",__FILE__,(unsigned long)__LINE__,name,(strlen(fmt) != 0) ? " -> " : "",ret_val);
         #define DEBUG_VARDUMP(name,fmt,val)	debug_print_nest(); kprintf("%s=" fmt "\n",name,val);
         #define DEBUG_POS			debug_print_nest(); kprintf(stderr,"POS: %s:%5lu\n",__FILE__,(unsigned long)__LINE__);

         #if DEBUG > 3
           /* Moderate output */
           /* debug output for ANSI C/C++ functions */
           #define DEBUG_ALLOC(name,adr,size)	debug_print_nest(); kprintf("MALLOC: %s=%lx, %lu\n",name,adr,size);
           #define DEBUG_FREE(name,adr)		debug_print_nest(); kprintf("FREE: %s=%lx\n",name,adr);

           #if DEBUG > 4
             /* Verbose output */
             /* TestAll(heap,stack,null,freespace) */
           #else
             /* No verbose output */
           #endif
         #else
           #define DEBUG_ALLOC(name,adr,size)
           #define DEBUG_FREE(name,adr)
           /* No moderate output */
           /* No verbose output */
         #endif
       #else
         /* No basic output */
         #define DEBUG_ENTER(name)
         #define DEBUG_EXIT(name,fmt,ret_val)
         #define DEBUG_VARDUMP(name,fmt,val)
         #define DEBUG_POS
         #define DEBUG_ALLOC(name,adr,size)
         #define DEBUG_FREE(name,adr)
         /* No moderate output */
         /* No verbose output */
       #endif
     #else
       /* No output in normal code path */
       #define DEBUG_PRINT_NEST
       #define DEBUG_ASSERT(cond)
       #define DEBUG_ENTER(name)
       #define DEBUG_EXIT(name,fmt,ret_val)
       #define DEBUG_VARDUMP(name,fmt,val)
       #define DEBUG_POS
       #define DEBUG_ALLOC(name,adr,size)
       #define DEBUG_FREE(name,adr)
       /* No moderate output */
       /* No verbose output */
     #endif
   #else
     /* No debugging */
     #define DEBUG_PRINT_NEST
     #define DEBUG_PCHECK(cond)
     #define DEBUG_ASSERT(cond)
     #define DEBUG_ENTER(name)
     #define DEBUG_EXIT(name,fmt,ret_val)
     #define DEBUG_VARDUMP(name,fmt,val)
     #define DEBUG_POS
     #define DEBUG_ALLOC(name,adr,size)
     #define DEBUG_FREE(name,adr)
     /* No moderate output */
     /* No verbose output */
   #endif

 #endif
