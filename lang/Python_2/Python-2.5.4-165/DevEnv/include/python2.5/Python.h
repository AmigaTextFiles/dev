#ifndef Py_PYTHON_H
#define Py_PYTHON_H
/* Since this is a "meta-include" file, no #ifdef __cplusplus / extern "C" { */

/* Include nearly all Python header files */

#include "patchlevel.h"
#include "pyconfig.h"

/* Cyclic gc is always enabled, starting with release 2.3a1.  Supply the
 * old symbol for the benefit of extension modules written before then
 * that may be conditionalizing on it.  The core doesn't use it anymore.
 */
#ifndef WITH_CYCLE_GC
#define WITH_CYCLE_GC 1
#endif

#include <limits.h>

#ifndef UCHAR_MAX
#error "Something's broken.  UCHAR_MAX should be defined in limits.h."
#endif

#if UCHAR_MAX != 255
#error "Python's source code assumes C's unsigned char is an 8-bit type."
#endif

#if defined(__sgi) && defined(WITH_THREAD) && !defined(_SGI_MP_SOURCE)
#define _SGI_MP_SOURCE
#endif

#include <stdio.h>
#ifndef NULL
#   error "Python.h requires that stdio.h define NULL."
#endif

#include <string.h>
#ifdef HAVE_ERRNO_H
#include <errno.h>
#endif
#include <stdlib.h>
#ifdef HAVE_UNISTD_H
#include <unistd.h>
#endif

/* For uintptr_t, intptr_t */
#ifdef HAVE_STDDEF_H
#include <stddef.h>
#endif

/* CAUTION:  Build setups should ensure that NDEBUG is defined on the
 * compiler command line when building Python in release mode; else
 * assert() calls won't be removed.
 */
#include <assert.h>

#include "pyport.h"

/* pyconfig.h or pyport.h may or may not define DL_IMPORT */
#ifndef DL_IMPORT   /* declarations for DLL import/export */
#define DL_IMPORT(RTYPE) RTYPE
#endif
#ifndef DL_EXPORT   /* declarations for DLL import/export */
#define DL_EXPORT(RTYPE) RTYPE
#endif

/* Debug-mode build with pymalloc implies PYMALLOC_DEBUG.
 *  PYMALLOC_DEBUG is in error if pymalloc is not in use.
 */
#if defined(Py_DEBUG) && defined(WITH_PYMALLOC) && !defined(PYMALLOC_DEBUG)
#define PYMALLOC_DEBUG
#endif
#if defined(PYMALLOC_DEBUG) && !defined(WITH_PYMALLOC)
#error "PYMALLOC_DEBUG requires WITH_PYMALLOC"
#endif
#include "pymem.h"

#include "object.h"
#include "objimpl.h"

#include "pydebug.h"

#include "unicodeobject.h"
#include "intobject.h"
#include "boolobject.h"
#include "longobject.h"
#include "floatobject.h"
#ifndef WITHOUT_COMPLEX
#include "complexobject.h"
#endif
#include "rangeobject.h"
#include "stringobject.h"
#include "bufferobject.h"
#include "tupleobject.h"
#include "listobject.h"
#include "dictobject.h"
#include "enumobject.h"
#include "setobject.h"
#include "methodobject.h"
#include "moduleobject.h"
#include "funcobject.h"
#include "classobject.h"
#include "fileobject.h"
#include "cobject.h"
#include "traceback.h"
#include "sliceobject.h"
#include "cellobject.h"
#include "iterobject.h"
#include "genobject.h"
#include "descrobject.h"
#include "weakrefobject.h"

#include "codecs.h"
#include "pyerrors.h"

#include "pystate.h"

#include "pyarena.h"
#include "modsupport.h"
#include "pythonrun.h"
#include "ceval.h"
#include "sysmodule.h"
#include "intrcheck.h"
#include "import.h"

#include "abstract.h"

#include "compile.h"
#include "eval.h"

#include "pystrtod.h"

/* _Py_Mangle is defined in compile.c */
PyAPI_FUNC(PyObject*) _Py_Mangle(PyObject *p, PyObject *name);

/* PyArg_GetInt is deprecated and should not be used, use PyArg_Parse(). */
#define PyArg_GetInt(v, a)  PyArg_Parse((v), "i", (a))

/* PyArg_NoArgs should not be necessary.
   Set ml_flags in the PyMethodDef to METH_NOARGS. */
#define PyArg_NoArgs(v)     PyArg_Parse(v, "")

/* Convert a possibly signed character to a nonnegative int */
/* XXX This assumes characters are 8 bits wide */
#ifdef __CHAR_UNSIGNED__
#define Py_CHARMASK(c)      (c)
#else
#define Py_CHARMASK(c)      ((c) & 0xff)
#endif

#include "pyfpe.h"

/* These definitions must match corresponding definitions in graminit.h.
   There's code in compile.c that checks that they are the same. */
#define Py_single_input 256
#define Py_file_input 257
#define Py_eval_input 258

#ifdef HAVE_PTH
/* GNU pth user-space thread support */
#include <pth.h>
#endif

/* Define macros for inline documentation. */
#define PyDoc_VAR(name) static char name[]
#define PyDoc_STRVAR(name,str) PyDoc_VAR(name) = PyDoc_STR(str)
#ifdef WITH_DOC_STRINGS
#define PyDoc_STR(str) str
#else
#define PyDoc_STR(str) ""
#endif

#if defined(__MORPHOS__)

#ifdef __cplusplus
extern "C" {
#endif

#ifndef Py_BUILD_CORE
#include <frameobject.h>
#include <libraries/python2_gvars.h>
extern struct Library *PythonBase;

/* From python_gvars.c */
PyAPI_FUNC(void) PyMorphOS_InitGVars( struct PyMorphOS_GVar_STRUCT * );
#endif

/* From morphos.c */
PyAPI_FUNC(int) PyMorphOS_SetConfigA(int, struct TagItem *);
PyAPI_FUNC(void) PyMorphOS_Term(void);
PyAPI_FUNC(int) PyMorphOS_HandleArgv(int *, char ***); /* replace the old PyMorphOS_Init() */
PyAPI_FUNC(APTR) PyMorphOS_GetGVars(void);
PyAPI_FUNC(LONG) PyMorphOS_GetFullPath(const char *, char *, ULONG);
PyAPI_FUNC(LONG) PyMorphOS_AddTermFunc(void (*func)(void), CONST_STRPTR);
PyAPI_FUNC(APTR) PyMorphOS_InitThread(void);
PyAPI_FUNC(void) PyMorphOS_TermThread(void);

#include <utility/tagitem.h> /* For TAG_USER */
#define PYMOSATTR_DUMMY         (TAG_USER|0xa68f0000)
#define PYMOSATTR_GVARS_STORAGE (PYMOSATTR_DUMMY+0)
// DEPRECATED #define PYMOSATTR_LIBNIXMEMPOOL (PYMOSATTR_DUMMY+1)
#define PYMOSATTR_EXIT_FUNC     (PYMOSATTR_DUMMY+2)
#define PYMOSATTR__EXIT_FUNC    (PYMOSATTR_DUMMY+3)
#define PYMOSATTR_STDIN         (PYMOSATTR_DUMMY+4)
#define PYMOSATTR_STDOUT        (PYMOSATTR_DUMMY+5)
#define PYMOSATTR_STDERR        (PYMOSATTR_DUMMY+6)
#define PYMOSATTR_MALLOC_FUNC   (PYMOSATTR_DUMMY+7)
#define PYMOSATTR_FREE_FUNC     (PYMOSATTR_DUMMY+8)

#define PyMorphOS_Init PyMorphOS_HandleArgv /* for compatibility */

#ifdef __cplusplus
}
#endif

#endif /* __MORPHOS__ */

#endif /* !Py_PYTHON_H */
