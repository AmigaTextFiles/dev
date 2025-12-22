OPT NATIVE
MODULE 'target/x86_64-linux-gnu/bits/pthreadtypes'	->guessed
MODULE 'target/x86_64-linux-gnu/bits/wordsize'
MODULE 'target/x86_64-linux-gnu/bits/types'
MODULE 'target/x86_64-linux-gnu/bits/types/__sigval_t'
{#include <x86_64-linux-gnu/bits/types/sigevent_t.h>}
->NATIVE {__sigevent_t_defined} CONST __SIGEVENT_T_DEFINED = 1

->NATIVE {__SIGEV_MAX_SIZE}	CONST __SIGEV_MAX_SIZE	= 64
 ->NATIVE {__SIGEV_PAD_SIZE}	CONST __SIGEV_PAD_SIZE	= ((__SIGEV_MAX_SIZE / sizeof (int)) - 4)

/* Forward declaration.  */
->NATIVE {pthread_attr_t} OBJECT
->TYPE pthread_attr_t IS NATIVE {pthread_attr_t} pthread_attr_t
 ->NATIVE {__have_pthread_attr_t}	CONST __HAVE_PTHREAD_ATTR_T	= 1

/* Structure to transport application-defined values with signals.  */
->NATIVE {sigevent_t} OBJECT
->TYPE sigevent_t IS NATIVE {sigevent_t} sigevent
NATIVE {sigevent_t} OBJECT sigevent_t
    {sigev_value}	sigev_value	:__sigval_t
    {sigev_signo}	sigev_signo	:VALUE
    {sigev_notify}	sigev_notify	:VALUE

->	{_sigev_un._pad}	_pad[__SIGEV_PAD_SIZE]	:ARRAY OF VALUE

	/* When SIGEV_SIGNAL and SIGEV_THREAD_ID set, LWP ID of the
	   thread to receive the signal.  */
	{_sigev_un._tid}	_tid	:PID_T__

	    {_sigev_un._sigev_thread._function}	_function	:PTR /*void (*_function) (__sigval_t)*/	/* Function to start.  */
	    {_sigev_un._sigev_thread._attribute}	_attribute	:PTR TO pthread_attr_t		/* Thread attributes.  */
ENDOBJECT 

/* POSIX names to access some of the members.  */
NATIVE {sigev_notify_function}   CONST ->SIGEV_NOTIFY_FUNCTION   = _sigev_un._sigev_thread._function
NATIVE {sigev_notify_attributes} CONST ->SIGEV_NOTIFY_ATTRIBUTES = _sigev_un._sigev_thread.
