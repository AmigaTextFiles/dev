#include <string.h>
  
/* predefined exceptions */
char constraint_error = 0;
char numeric_error    = 0;
char program_error    = 0;
char storage_error    = 0;
char tasking_error    = 0;
char _abort_signal    = 1;
 
static int static_argc;
static char * *static_argv;
 
int arg_count () { return static_argc; }
 
int len_arg (arg_num)
   int arg_num;
   { return strlen(static_argv[arg_num]); }
 
int fill_arg (a, i)
   char * a;
   int i;
{ strncpy (a, static_argv[i],
     strlen(static_argv[i])); }
 
extern void (*system__tasking_soft_links__abort_defer) ();  
extern char *system__task_specific_data__get_gnat_exception ();
extern int *system__task_specific_data__get_jmpbuf_address ();
extern char debug__get_debug_flag_k (); 

void
__gnat_raise_nodefer (except)
     char *except;
{
  int *ptr = system__task_specific_data__get_jmpbuf_address ();

  system__task_specific_data__set_gnat_exception (except);
  if (ptr)
    longjmp (ptr, 1);

  else 
    {
      if (except == &constraint_error) 
        puts ("\nraised Constraint_Error\n"); 
      else if (except == &numeric_error) 
        puts ("\nraised Numeric_Error\n"); 
      else if (except == &program_error) 
        puts ("\nraised Program_Error\n"); 
      else if (except == &storage_error)
        puts ("\nraised Storage_Error\n");
      else if (except == &tasking_error)
        puts ("\nraised Tasking_Error\n");
      else if (!ptr)
        puts ("\nraised unhandled exception\n");

      exit (1);

    }
}

void 
__gnat_raise (except)
     char *except;
{
  (*system__tasking_soft_links__abort_defer) ();
  __gnat_raise_nodefer (except);
}

void
__gnat_reraise (flag)
     int flag;
{
  char *except = system__task_specific_data__get_gnat_exception ();

  if (flag)
    __gnat_raise (except);
  else
    __gnat_raise_nodefer (except);
}
void
__gnat_raise_constraint_error ()
{
  __gnat_raise (&constraint_error);
}
int __main_priority () { return -1; }
 
void main (argc, argv)
   int argc;
   char * argv[];
{
   static_argc = argc;
   static_argv = argv;
 
   ada___elabs ();
   ada__io_exceptions___elabs ();
   ada__text_io___elabs ();
   ada__text_io__aux___elabs ();
   ada__text_io___elabb ();
   interfaces___elabs ();
   interfaces__c___elabs ();
   interfaces__c___elabb ();
   system___elabs ();
   ada__text_io__aux___elabb ();
   system__img_i___elabb ();
   system__secondary_stack___elabs ();
   system__storage_elements___elabs ();
   system__storage_elements___elabb ();
   interfaces__c__strings___elabs ();
   system__task_specific_data___elabs ();
   system__secondary_stack___elabb ();
   system__tasking_soft_links___elabs ();
   interfaces__c__strings___elabb ();
   system__task_specific_data___elabb ();
   system__tasking_soft_links___elabb ();
   system__standard_library___elabs ();
   amiga___elabs ();
   incomplete_type___elabs ();
   exec_nodes___elabs ();
   exec_lists___elabs ();
   exec_ports___elabs ();
   exec_io___elabs ();
   devices_timer___elabs ();
   devices_inputevent___elabs ();
   exec_semaphores___elabs ();
   graphics_gfx___elabs ();
   graphics_gfxnodes___elabs ();
   graphics_layers___elabs ();
   graphics_rastport___elabs ();
   utility_hooks___elabs ();
   utility_tagitem___elabs ();
   utility_tagitem___elabb ();
   graphics_view___elabs ();
   graphics_graphics___elabs ();
   graphics_graphics___elabb ();
   intuition_classusr___elabs ();
   intuition_classusr___elabb ();
   intuition_classes___elabs ();
   intuition_intuition___elabs ();
   intuition_intuition___elabb ();
   exec_exec___elabs ();
   amiga_lib___elabs ();
   amiga_lib___elabb ();
   mui___elabs ();
   mui___elabb ();
   gencodec_app___elabs ();
   gencodec_app___elabb ();
   gencodec___elabb ();
 
   _ada_gencodec ();
   ada__text_io__aux__text_io_finalization ();
   exit (0);
}
/* BEGIN Object file list
/gnu/lib/gcc-lib/amigados/2.5.8/adalib/ada.o
/gnu/lib/gcc-lib/amigados/2.5.8/adalib/a-ioexce.o
/gnu/lib/gcc-lib/amigados/2.5.8/adalib/a-textio.o
/gnu/lib/gcc-lib/amigados/2.5.8/adalib/interfac.o
/gnu/lib/gcc-lib/amigados/2.5.8/adalib/i-c.o
/gnu/lib/gcc-lib/amigados/2.5.8/adalib/system.o
/gnu/lib/gcc-lib/amigados/2.5.8/adalib/a-teioau.o
/gnu/lib/gcc-lib/amigados/2.5.8/adalib/s-img_i.o
/gnu/lib/gcc-lib/amigados/2.5.8/adalib/s-stoele.o
/gnu/lib/gcc-lib/amigados/2.5.8/adalib/s-secsta.o
/gnu/lib/gcc-lib/amigados/2.5.8/adalib/i-cstrin.o
/gnu/lib/gcc-lib/amigados/2.5.8/adalib/s-taspda.o
/gnu/lib/gcc-lib/amigados/2.5.8/adalib/s-tasoli.o
/gnu/lib/gcc-lib/amigados/2.5.8/adalib/s-stalib.o
/gnu/lib/gcc-lib/amigados/2.5.8/adalib/text_io.o
/work/projects/amiga_ada/amiga.o
/work/projects/amiga_ada/incomplete_type.o
/work/projects/amiga_ada/exec_nodes.o
/work/projects/amiga_ada/exec_lists.o
/work/projects/amiga_ada/exec_ports.o
/work/projects/amiga_ada/exec_io.o
/work/projects/amiga_ada/devices_timer.o
/work/projects/amiga_ada/devices_inputevent.o
/work/projects/amiga_ada/exec_semaphores.o
/work/projects/amiga_ada/graphics_gfx.o
/work/projects/amiga_ada/graphics_gfxnodes.o
/work/projects/amiga_ada/graphics_layers.o
/work/projects/amiga_ada/graphics_rastport.o
/work/projects/amiga_ada/utility_hooks.o
/work/projects/amiga_ada/utility_tagitem.o
/work/projects/amiga_ada/graphics_view.o
/work/projects/amiga_ada/graphics_graphics.o
/work/projects/amiga_ada/intuition_classusr.o
/work/projects/amiga_ada/intuition_classes.o
/work/projects/amiga_ada/intuition_intuition.o
/work/projects/amiga_ada/exec_exec.o
/work/projects/amiga_ada/amiga_lib.o
/work/projects/amiga_ada/mui.o
gencodec_app.o
GenCodeC.o
   END Object file list */
