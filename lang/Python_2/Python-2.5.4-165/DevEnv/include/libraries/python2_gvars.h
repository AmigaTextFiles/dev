/* GENERATED FILE. DO NOT EDIT IT MANUALLY */
#ifndef LIB_PYTHON_GVARS_H
#define LIB_PYTHON_GVARS_H

struct PyMorphOS_GVar_STRUCT {
    void* p_PyBaseObject_Type;
    void* p_PyBaseString_Type;
    void* p_PyBool_Type;
    void* p_PyBuffer_Type;
    void* p_PyCFunction_Type;
    void* p_PyCObject_Type;
    void* p_PyCallIter_Type;
    void* p_PyCell_Type;
    void* p_PyClassMethod_Type;
    void* p_PyClass_Type;
    void* p_PyCode_Type;
    void* p_PyComplex_Type;
    void* p_PyDict_Type;
    void* p_PyEnum_Type;
    void* p_PyExc_ArithmeticError;
    void* p_PyExc_AssertionError;
    void* p_PyExc_AttributeError;
    void* p_PyExc_BaseException;
    void* p_PyExc_DeprecationWarning;
    void* p_PyExc_EOFError;
    void* p_PyExc_EnvironmentError;
    void* p_PyExc_Exception;
    void* p_PyExc_FloatingPointError;
    void* p_PyExc_FutureWarning;
    void* p_PyExc_GeneratorExit;
    void* p_PyExc_IOError;
    void* p_PyExc_ImportError;
    void* p_PyExc_ImportWarning;
    void* p_PyExc_IndentationError;
    void* p_PyExc_IndexError;
    void* p_PyExc_KeyError;
    void* p_PyExc_KeyboardInterrupt;
    void* p_PyExc_LookupError;
    void* p_PyExc_MemoryError;
    void* p_PyExc_MemoryErrorInst;
    void* p_PyExc_NameError;
    void* p_PyExc_NotImplementedError;
    void* p_PyExc_OSError;
    void* p_PyExc_OverflowError;
    void* p_PyExc_PendingDeprecationWarning;
    void* p_PyExc_ReferenceError;
    void* p_PyExc_RuntimeError;
    void* p_PyExc_RuntimeWarning;
    void* p_PyExc_StandardError;
    void* p_PyExc_StopIteration;
    void* p_PyExc_SyntaxError;
    void* p_PyExc_SyntaxWarning;
    void* p_PyExc_SystemError;
    void* p_PyExc_SystemExit;
    void* p_PyExc_TabError;
    void* p_PyExc_TypeError;
    void* p_PyExc_UnboundLocalError;
    void* p_PyExc_UnicodeDecodeError;
    void* p_PyExc_UnicodeEncodeError;
    void* p_PyExc_UnicodeError;
    void* p_PyExc_UnicodeTranslateError;
    void* p_PyExc_UnicodeWarning;
    void* p_PyExc_UserWarning;
    void* p_PyExc_ValueError;
    void* p_PyExc_Warning;
    void* p_PyExc_ZeroDivisionError;
    void* p_PyFile_Type;
    void* p_PyFloat_Type;
    void* p_PyFrame_Type;
    void* p_PyFrozenSet_Type;
    void* p_PyFunction_Type;
    void* p_PyGen_Type;
    void* p_PyImport_FrozenModules;
    void* p_PyImport_Inittab;
    void* p_PyInstance_Type;
    void* p_PyInt_Type;
    void* p_PyList_Type;
    void* p_PyLong_Type;
    void* p_PyMethod_Type;
    void* p_PyModule_Type;
    void* p_PyOS_InputHook;
    void* p_PyOS_ReadlineFunctionPointer;
    void* p_PyProperty_Type;
    void* p_PyRange_Type;
    void* p_PyReversed_Type;
    void* p_PySTEntry_Type;
    void* p_PySeqIter_Type;
    void* p_PySet_Type;
    void* p_PySlice_Type;
    void* p_PyStaticMethod_Type;
    void* p_PyString_Type;
    void* p_PySuper_Type;
    void* p_PyTraceBack_Type;
    void* p_PyTuple_Type;
    void* p_PyType_Type;
    void* p_PyUnicode_Type;
    void* p_PyWrapperDescr_Type;
    void* p_Py_DebugFlag;
    void* p_Py_DivisionWarningFlag;
    void* p_Py_FileSystemDefaultEncoding;
    void* p_Py_FrozenFlag;
    void* p_Py_IgnoreEnvironmentFlag;
    void* p_Py_InteractiveFlag;
    void* p_Py_NoSiteFlag;
    void* p_Py_OptimizeFlag;
    void* p_Py_TabcheckFlag;
    void* p_Py_UnicodeFlag;
    void* p_Py_UseClassExceptionsFlag;
    void* p_Py_VerboseFlag;
    void* p__PyLong_DigitValue;
    void* p__PyOS_ReadlineTState;
    void* p__PyOS_optarg;
    void* p__PyOS_opterr;
    void* p__PyOS_optind;
    void* p__PyParser_TokenNames;
    void* p__PyThreadState_Current;
    void* p__PyThreadState_GetFrame;
    void* p__PyTrash_delete_later;
    void* p__PyTrash_delete_nesting;
    void* p__PyWeakref_CallableProxyType;
    void* p__PyWeakref_ProxyType;
    void* p__PyWeakref_RefType;
    void* p__Py_CheckInterval;
    void* p__Py_CheckRecursionLimit;
    void* p__Py_EllipsisObject;
    void* p__Py_NoneStruct;
    void* p__Py_NotImplementedStruct;
    void* p__Py_PackageContext;
    void* p__Py_QnewFlag;
    void* p__Py_SwappedOp;
    void* p__Py_Ticker;
    void* p__Py_TrueStruct;
    void* p__Py_ZeroStruct;
};

extern void PyMorphOS_InitGVars(struct PyMorphOS_GVar_STRUCT *);
extern struct PyMorphOS_GVar_STRUCT __pym_GVars;

#ifndef DONT_WRAP_VARS
#define PyBaseObject_Type                   (*(PyTypeObject *)__pym_GVars.p_PyBaseObject_Type)
#define PyBaseString_Type                   (*(PyTypeObject *)__pym_GVars.p_PyBaseString_Type)
#define PyBool_Type                         (*(PyTypeObject *)__pym_GVars.p_PyBool_Type)
#define PyBuffer_Type                       (*(PyTypeObject *)__pym_GVars.p_PyBuffer_Type)
#define PyCFunction_Type                    (*(PyTypeObject *)__pym_GVars.p_PyCFunction_Type)
#define PyCObject_Type                      (*(PyTypeObject *)__pym_GVars.p_PyCObject_Type)
#define PyCallIter_Type                     (*(PyTypeObject *)__pym_GVars.p_PyCallIter_Type)
#define PyCell_Type                         (*(PyTypeObject *)__pym_GVars.p_PyCell_Type)
#define PyClassMethod_Type                  (*(PyTypeObject *)__pym_GVars.p_PyClassMethod_Type)
#define PyClass_Type                        (*(PyTypeObject *)__pym_GVars.p_PyClass_Type)
#define PyCode_Type                         (*(PyTypeObject *)__pym_GVars.p_PyCode_Type)
#define PyComplex_Type                      (*(PyTypeObject *)__pym_GVars.p_PyComplex_Type)
#define PyDict_Type                         (*(PyTypeObject *)__pym_GVars.p_PyDict_Type)
#define PyEnum_Type                         (*(PyTypeObject *)__pym_GVars.p_PyEnum_Type)
#define PyExc_ArithmeticError               (*(PyObject * *)__pym_GVars.p_PyExc_ArithmeticError)
#define PyExc_AssertionError                (*(PyObject * *)__pym_GVars.p_PyExc_AssertionError)
#define PyExc_AttributeError                (*(PyObject * *)__pym_GVars.p_PyExc_AttributeError)
#define PyExc_BaseException                 (*(PyObject * *)__pym_GVars.p_PyExc_BaseException)
#define PyExc_DeprecationWarning            (*(PyObject * *)__pym_GVars.p_PyExc_DeprecationWarning)
#define PyExc_EOFError                      (*(PyObject * *)__pym_GVars.p_PyExc_EOFError)
#define PyExc_EnvironmentError              (*(PyObject * *)__pym_GVars.p_PyExc_EnvironmentError)
#define PyExc_Exception                     (*(PyObject * *)__pym_GVars.p_PyExc_Exception)
#define PyExc_FloatingPointError            (*(PyObject * *)__pym_GVars.p_PyExc_FloatingPointError)
#define PyExc_FutureWarning                 (*(PyObject * *)__pym_GVars.p_PyExc_FutureWarning)
#define PyExc_GeneratorExit                 (*(PyObject * *)__pym_GVars.p_PyExc_GeneratorExit)
#define PyExc_IOError                       (*(PyObject * *)__pym_GVars.p_PyExc_IOError)
#define PyExc_ImportError                   (*(PyObject * *)__pym_GVars.p_PyExc_ImportError)
#define PyExc_ImportWarning                 (*(PyObject * *)__pym_GVars.p_PyExc_ImportWarning)
#define PyExc_IndentationError              (*(PyObject * *)__pym_GVars.p_PyExc_IndentationError)
#define PyExc_IndexError                    (*(PyObject * *)__pym_GVars.p_PyExc_IndexError)
#define PyExc_KeyError                      (*(PyObject * *)__pym_GVars.p_PyExc_KeyError)
#define PyExc_KeyboardInterrupt             (*(PyObject * *)__pym_GVars.p_PyExc_KeyboardInterrupt)
#define PyExc_LookupError                   (*(PyObject * *)__pym_GVars.p_PyExc_LookupError)
#define PyExc_MemoryError                   (*(PyObject * *)__pym_GVars.p_PyExc_MemoryError)
#define PyExc_MemoryErrorInst               (*(PyObject * *)__pym_GVars.p_PyExc_MemoryErrorInst)
#define PyExc_NameError                     (*(PyObject * *)__pym_GVars.p_PyExc_NameError)
#define PyExc_NotImplementedError           (*(PyObject * *)__pym_GVars.p_PyExc_NotImplementedError)
#define PyExc_OSError                       (*(PyObject * *)__pym_GVars.p_PyExc_OSError)
#define PyExc_OverflowError                 (*(PyObject * *)__pym_GVars.p_PyExc_OverflowError)
#define PyExc_PendingDeprecationWarning     (*(PyObject * *)__pym_GVars.p_PyExc_PendingDeprecationWarning)
#define PyExc_ReferenceError                (*(PyObject * *)__pym_GVars.p_PyExc_ReferenceError)
#define PyExc_RuntimeError                  (*(PyObject * *)__pym_GVars.p_PyExc_RuntimeError)
#define PyExc_RuntimeWarning                (*(PyObject * *)__pym_GVars.p_PyExc_RuntimeWarning)
#define PyExc_StandardError                 (*(PyObject * *)__pym_GVars.p_PyExc_StandardError)
#define PyExc_StopIteration                 (*(PyObject * *)__pym_GVars.p_PyExc_StopIteration)
#define PyExc_SyntaxError                   (*(PyObject * *)__pym_GVars.p_PyExc_SyntaxError)
#define PyExc_SyntaxWarning                 (*(PyObject * *)__pym_GVars.p_PyExc_SyntaxWarning)
#define PyExc_SystemError                   (*(PyObject * *)__pym_GVars.p_PyExc_SystemError)
#define PyExc_SystemExit                    (*(PyObject * *)__pym_GVars.p_PyExc_SystemExit)
#define PyExc_TabError                      (*(PyObject * *)__pym_GVars.p_PyExc_TabError)
#define PyExc_TypeError                     (*(PyObject * *)__pym_GVars.p_PyExc_TypeError)
#define PyExc_UnboundLocalError             (*(PyObject * *)__pym_GVars.p_PyExc_UnboundLocalError)
#define PyExc_UnicodeDecodeError            (*(PyObject * *)__pym_GVars.p_PyExc_UnicodeDecodeError)
#define PyExc_UnicodeEncodeError            (*(PyObject * *)__pym_GVars.p_PyExc_UnicodeEncodeError)
#define PyExc_UnicodeError                  (*(PyObject * *)__pym_GVars.p_PyExc_UnicodeError)
#define PyExc_UnicodeTranslateError         (*(PyObject * *)__pym_GVars.p_PyExc_UnicodeTranslateError)
#define PyExc_UnicodeWarning                (*(PyObject * *)__pym_GVars.p_PyExc_UnicodeWarning)
#define PyExc_UserWarning                   (*(PyObject * *)__pym_GVars.p_PyExc_UserWarning)
#define PyExc_ValueError                    (*(PyObject * *)__pym_GVars.p_PyExc_ValueError)
#define PyExc_Warning                       (*(PyObject * *)__pym_GVars.p_PyExc_Warning)
#define PyExc_ZeroDivisionError             (*(PyObject * *)__pym_GVars.p_PyExc_ZeroDivisionError)
#define PyFile_Type                         (*(PyTypeObject *)__pym_GVars.p_PyFile_Type)
#define PyFloat_Type                        (*(PyTypeObject *)__pym_GVars.p_PyFloat_Type)
#define PyFrame_Type                        (*(PyTypeObject *)__pym_GVars.p_PyFrame_Type)
#define PyFrozenSet_Type                    (*(PyTypeObject *)__pym_GVars.p_PyFrozenSet_Type)
#define PyFunction_Type                     (*(PyTypeObject *)__pym_GVars.p_PyFunction_Type)
#define PyGen_Type                          (*(PyTypeObject *)__pym_GVars.p_PyGen_Type)
#define PyImport_FrozenModules              (*(struct _frozen * *)__pym_GVars.p_PyImport_FrozenModules)
#define PyImport_Inittab                    (*(struct _inittab * *)__pym_GVars.p_PyImport_Inittab)
#define PyInstance_Type                     (*(PyTypeObject *)__pym_GVars.p_PyInstance_Type)
#define PyInt_Type                          (*(PyTypeObject *)__pym_GVars.p_PyInt_Type)
#define PyList_Type                         (*(PyTypeObject *)__pym_GVars.p_PyList_Type)
#define PyLong_Type                         (*(PyTypeObject *)__pym_GVars.p_PyLong_Type)
#define PyMethod_Type                       (*(PyTypeObject *)__pym_GVars.p_PyMethod_Type)
#define PyModule_Type                       (*(PyTypeObject *)__pym_GVars.p_PyModule_Type)
#define PyOS_InputHook                      (*(int(*)(void) *)__pym_GVars.p_PyOS_InputHook)
#define PyOS_ReadlineFunctionPointer        (*(char*(*)(FILE *, FILE *, char *) *)__pym_GVars.p_PyOS_ReadlineFunctionPointer)
#define PyProperty_Type                     (*(PyTypeObject *)__pym_GVars.p_PyProperty_Type)
#define PyRange_Type                        (*(PyTypeObject *)__pym_GVars.p_PyRange_Type)
#define PyReversed_Type                     (*(PyTypeObject *)__pym_GVars.p_PyReversed_Type)
#define PySTEntry_Type                      (*(PyTypeObject *)__pym_GVars.p_PySTEntry_Type)
#define PySeqIter_Type                      (*(PyTypeObject *)__pym_GVars.p_PySeqIter_Type)
#define PySet_Type                          (*(PyTypeObject *)__pym_GVars.p_PySet_Type)
#define PySlice_Type                        (*(PyTypeObject *)__pym_GVars.p_PySlice_Type)
#define PyStaticMethod_Type                 (*(PyTypeObject *)__pym_GVars.p_PyStaticMethod_Type)
#define PyString_Type                       (*(PyTypeObject *)__pym_GVars.p_PyString_Type)
#define PySuper_Type                        (*(PyTypeObject *)__pym_GVars.p_PySuper_Type)
#define PyTraceBack_Type                    (*(PyTypeObject *)__pym_GVars.p_PyTraceBack_Type)
#define PyTuple_Type                        (*(PyTypeObject *)__pym_GVars.p_PyTuple_Type)
#define PyType_Type                         (*(PyTypeObject *)__pym_GVars.p_PyType_Type)
#define PyUnicode_Type                      (*(PyTypeObject *)__pym_GVars.p_PyUnicode_Type)
#define PyWrapperDescr_Type                 (*(PyTypeObject *)__pym_GVars.p_PyWrapperDescr_Type)
#define Py_DebugFlag                        (*(int *)__pym_GVars.p_Py_DebugFlag)
#define Py_DivisionWarningFlag              (*(int *)__pym_GVars.p_Py_DivisionWarningFlag)
#define Py_FileSystemDefaultEncoding        (*(const char * *)__pym_GVars.p_Py_FileSystemDefaultEncoding)
#define Py_FrozenFlag                       (*(int *)__pym_GVars.p_Py_FrozenFlag)
#define Py_IgnoreEnvironmentFlag            (*(int *)__pym_GVars.p_Py_IgnoreEnvironmentFlag)
#define Py_InteractiveFlag                  (*(int *)__pym_GVars.p_Py_InteractiveFlag)
#define Py_NoSiteFlag                       (*(int *)__pym_GVars.p_Py_NoSiteFlag)
#define Py_OptimizeFlag                     (*(int *)__pym_GVars.p_Py_OptimizeFlag)
#define Py_TabcheckFlag                     (*(int *)__pym_GVars.p_Py_TabcheckFlag)
#define Py_UnicodeFlag                      (*(int *)__pym_GVars.p_Py_UnicodeFlag)
#define Py_UseClassExceptionsFlag           (*(int *)__pym_GVars.p_Py_UseClassExceptionsFlag)
#define Py_VerboseFlag                      (*(int *)__pym_GVars.p_Py_VerboseFlag)
#define _PyLong_DigitValue                  (*(int* *)__pym_GVars.p__PyLong_DigitValue)
#define _PyOS_ReadlineTState                (*(PyThreadState* *)__pym_GVars.p__PyOS_ReadlineTState)
#define _PyOS_optarg                        (*(char * *)__pym_GVars.p__PyOS_optarg)
#define _PyOS_opterr                        (*(int *)__pym_GVars.p__PyOS_opterr)
#define _PyOS_optind                        (*(int *)__pym_GVars.p__PyOS_optind)
#define _PyParser_TokenNames                (*(char ** *)__pym_GVars.p__PyParser_TokenNames)
#define _PyThreadState_Current              (*(PyThreadState * *)__pym_GVars.p__PyThreadState_Current)
#define _PyThreadState_GetFrame             (*(PyThreadFrameGetter *)__pym_GVars.p__PyThreadState_GetFrame)
#define _PyTrash_delete_later               (*(PyObject * *)__pym_GVars.p__PyTrash_delete_later)
#define _PyTrash_delete_nesting             (*(int *)__pym_GVars.p__PyTrash_delete_nesting)
#define _PyWeakref_CallableProxyType        (*(PyTypeObject *)__pym_GVars.p__PyWeakref_CallableProxyType)
#define _PyWeakref_ProxyType                (*(PyTypeObject *)__pym_GVars.p__PyWeakref_ProxyType)
#define _PyWeakref_RefType                  (*(PyTypeObject *)__pym_GVars.p__PyWeakref_RefType)
#define _Py_CheckInterval                   (*(int *)__pym_GVars.p__Py_CheckInterval)
#define _Py_CheckRecursionLimit             (*(int *)__pym_GVars.p__Py_CheckRecursionLimit)
#define _Py_EllipsisObject                  (*(PyObject *)__pym_GVars.p__Py_EllipsisObject)
#define _Py_NoneStruct                      (*(PyObject *)__pym_GVars.p__Py_NoneStruct)
#define _Py_NotImplementedStruct            (*(PyObject *)__pym_GVars.p__Py_NotImplementedStruct)
#define _Py_PackageContext                  (*(char * *)__pym_GVars.p__Py_PackageContext)
#define _Py_QnewFlag                        (*(int *)__pym_GVars.p__Py_QnewFlag)
#define _Py_SwappedOp                       (*(int* *)__pym_GVars.p__Py_SwappedOp)
#define _Py_Ticker                          (*(volatile int *)__pym_GVars.p__Py_Ticker)
#define _Py_TrueStruct                      (*(PyIntObject *)__pym_GVars.p__Py_TrueStruct)
#define _Py_ZeroStruct                      (*(PyIntObject *)__pym_GVars.p__Py_ZeroStruct)
#endif /* !DONT_WRAP_VARS */
#endif /* LIB_PYTHON_GVARS_H */
