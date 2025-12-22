/* Simple test for a DLL
*/

#include <windows.h>
#include <console.h>
#include <SWI-Prolog.h>
#include <stdio.h>

#define HAVE_FTIME 1

/* - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
Test for DLL entry-point handling.

load:

	load_foreign_library('d:/jan/src/pl/src/dll/windebug/dlltest.dll').

- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - */

HINSTANCE ThePceHInstance;		/* Global handle */

BOOL WINAPI
dllentry(HINSTANCE instance, DWORD reason, LPVOID reserved)
{ switch(reason)
  { case DLL_PROCESS_ATTACH:
    { /*ThePceHInstance = instance;*/
    }
  }

  return TRUE;
}


/* - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
If I don't define this, an  undefined   reference  is generated.  Who is
calling this?  Is this is MSVC++ bug?
- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - */

int
main()
{ MessageBox(NULL, "called", "main()", MB_OK|MB_TASKMODAL);

  return 0;
}


#if HAVE_FTIME
#include <sys/timeb.h>

static struct _timeb epoch;

void
initMClock()
{ _ftime(&epoch);
} 


unsigned long
mclock()
{ struct _timeb now;

  _ftime(&now);
  return (now.time - epoch.time) * 1000 +
	 (now.millitm - epoch.millitm);
}


foreign_t
pl_mclock(term_t msecs)
{ return PL_unify_atomic(msecs, PL_new_integer(mclock()));
}

#endif /*HAVE_FTIME*/


/* - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
pl_say_hello()  illustrates  a   simple    foreign   language  predicate
implementation  calling  a  Windows  function.     By  convention,  such
functions are called pl_<name_of_predicate>.  Their   type  is foreign_t
and all arguments are of type term_t.
- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - */

static foreign_t
pl_say_hello(term_t to)
{ if ( PL_is_atom(to) )
  { char *a = PL_atom_value(PL_atomic(to));

    MessageBox(NULL, a, "DLL test", MB_OK|MB_TASKMODAL);

    PL_succeed;
  }

  PL_fail;
}


static foreign_t
pl_hinstance(term_t inst, term_t mod)
{ PL_unify_atomic(mod, PL_new_integer((long)GetModuleHandle("dlltest")));

  return PL_unify_atomic(inst, PL_new_integer((long) ThePceHInstance));
}


/* - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
Interface function to modify the console:
- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - */

static foreign_t
pl_rlc_color(term_t which, term_t r, term_t b, term_t g)
{ int w;

  if ( PL_is_atom(which) )
  { char *s = PL_atom_value(PL_atomic(which));

    if ( strcmp(s, "window") == 0 )
      w = RLC_WINDOW;
    else if ( strcmp(s, "text") == 0 )
      w = RLC_TEXT;
    else if ( strcmp(s, "highlight") == 0 )
      w = RLC_HIGHLIGHT;
    else if ( strcmp(s, "highlighttext") == 0 )
      w = RLC_HIGHLIGHTTEXT;
    else
      goto usage;
  } else
    goto usage;

  if ( PL_is_int(r) &&
       PL_is_int(b) &&
       PL_is_int(g) )
  { int tr, tb, tg;

    tr = PL_integer_value(PL_atomic(r));
    tb = PL_integer_value(PL_atomic(b));
    tg = PL_integer_value(PL_atomic(g));
    if ( tr < 0 || tr > 255 || tb < 0 || tb > 255 | tg < 0 || tg > 255 )
      goto usage;

    rlc_color(w, RGB(tr,tb,tg));
    PL_succeed;
  }

usage:
  PL_warning("rlc_color({window,text,highlight,highlighttext}, R, G, B)");
  PL_fail;
}


/* - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
This function is a handle  called   from  abort/1.   The function should
perform cleanup as Prolog is going to   perform a long_jmp() back to the
toplevel.
- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - */

static void
my_abort(void)
{ MessageBox(NULL,
	     "Execution aborted", "Abort handle test",
	     MB_OK|MB_TASKMODAL);
}

  
/* - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
This function illustrates the  event-dispatching   handle  in the Prolog
main loop.  
- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - */

static int
my_dispatch(void)
{ RlcQueue q = rlc_input_queue();

  if ( rlc_is_empty_queue(q) )
  { static char title[256];
    static int titleinited = 0;

    if ( !titleinited )
    { rlc_title(NULL, title, sizeof(title));
      titleinited++;
    } else
      rlc_title(title, NULL, 0);

    while(rlc_is_empty_queue(q))
      rlc_dispatch(q);

    rlc_title("SWI-Prolog: Running", NULL, 0);
  }

  return PL_DISPATCH_INPUT;
}

/* - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
(un)install functions.  Predicates registered with PL_register_foreign()
donot  need  to  be  uninstalled   as    the   Prolog   toplevel  driver
unload_foreign_library/[1,2] will to this automatically for you.

As only hooks need to be uninstalled,  you won't need this function very
often.
- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - */

static PL_dispatch_hook_t oldhook;

install_t
install()
{ PL_register_foreign("say_hello", 1, pl_say_hello, 0);
  PL_register_foreign("rlc_color", 4, pl_rlc_color, 0);
  PL_register_foreign("hinstance", 2, pl_hinstance, 0);
  PL_register_foreign("mclock",    1, pl_mclock,    0);

/*  initMClock(); */
  malloc(1024);

  PL_abort_hook(my_abort);
  oldhook = PL_dispatch_hook(my_dispatch);
}


install_t
uninstall()
{ PL_abort_unhook(my_abort);
  PL_dispatch_hook(oldhook);
}
