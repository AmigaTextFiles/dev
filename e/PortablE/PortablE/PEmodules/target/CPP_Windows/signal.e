OPT NATIVE, POINTER
MODULE 'target/_mingw'
{#include <signal.h>}
/* 
 * signal.h
 * This file has no copyright assigned and is placed in the Public Domain.
 * This file is a part of the mingw-runtime package.
 * No warranty is given; refer to the file DISCLAIMER within the package.
 *
 * A way to set handlers for exceptional conditions (also known as signals).
 *
 */

NATIVE {_SIGNAL_H_} DEF

/* All the headers include this file. */

/*
 * The actual signal values. Using other values with signal
 * produces a SIG_ERR return value.
 *
 * NOTE: SIGINT is produced when the user presses Ctrl-C.
 *       SIGILL has not been tested.
 *       SIGFPE doesn't seem to work?
 *       SIGSEGV does not catch writing to a NULL pointer (that shuts down
 *               your app; can you say "segmentation violation core dump"?).
 *       SIGTERM comes from what kind of termination request exactly?
 *       SIGBREAK is indeed produced by pressing Ctrl-Break.
 *       SIGABRT is produced by calling abort.
 * TODO: The above results may be related to not installing an appropriate
 *       structured exception handling frame. Results may be better if I ever
 *       manage to get the SEH stuff down.
 */
NATIVE {SIGINT}		CONST SIGINT		= 2	/* Interactive attention */
NATIVE {SIGILL}		CONST SIGILL		= 4	/* Illegal instruction */
NATIVE {SIGFPE}		CONST SIGFPE		= 8	/* Floating point error */
NATIVE {SIGSEGV}		CONST SIGSEGV		= 11	/* Segmentation violation */
NATIVE {SIGTERM}		CONST SIGTERM		= 15	/* Termination request */
NATIVE {SIGBREAK}	CONST SIGBREAK	= 21	/* Control-break */
NATIVE {SIGABRT}		CONST SIGABRT		= 22	/* Abnormal termination (abort) */

NATIVE {NSIG} CONST NSIG = 23     /* maximum signal number + 1 */


NATIVE {sig_atomic_t} OBJECT
->TYPE SIG_ATOMIC_T IS NATIVE {sig_atomic_t} VALUE
NATIVE {_SIG_ATOMIC_T_DEFINED} DEF

/*
 * The prototypes (below) are the easy part. The hard part is figuring
 * out what signals are available and what numbers they are assigned
 * along with appropriate values of SIG_DFL and SIG_IGN.
 */

/*
 * A pointer to a signal handler function. A signal handler takes a
 * single int, which is the signal it handles.
 */
NATIVE {__p_sig_fn_t} OBJECT
TYPE P_SIG_FN_T IS NATIVE {__p_sig_fn_t} PTR

/*
 * These are special values of signal handler pointers which are
 * used to send a signal to the default handler (SIG_DFL), ignore
 * the signal (SIG_IGN), indicate an error return (SIG_ERR),
 * get an error (SIG_SGE), or acknowledge (SIG_ACK).
 */
NATIVE {SIG_DFL}	CONST SIG_DFL	= 0!!VALUE!!P_SIG_FN_T
NATIVE {SIG_IGN}	CONST SIG_IGN	= 1!!VALUE!!P_SIG_FN_T
NATIVE {SIG_ERR} CONST SIG_ERR =-1!!VALUE!!P_SIG_FN_T
NATIVE {SIG_SGE} CONST SIG_SGE = 3!!VALUE!!P_SIG_FN_T
NATIVE {SIG_ACK} CONST SIG_ACK = 4!!VALUE!!P_SIG_FN_T


/*
 * Call signal to set the signal handler for signal sig to the
 * function pointed to by handler. Returns a pointer to the
 * previous handler, or SIG_ERR if an error occurs. Initially
 * unhandled signals defined above will return SIG_DFL.
 */
NATIVE {signal} PROC
PROC signal(param1:VALUE, param2:P_SIG_FN_T) IS NATIVE {signal( (int) } param1 {,} param2 {)} ENDNATIVE !!P_SIG_FN_T

/*
 * Raise the signal indicated by sig. Returns non-zero on success.
 */
NATIVE {raise} PROC
PROC raise(param1:VALUE) IS NATIVE {raise( (int) } param1 {)} ENDNATIVE !!VALUE
