OPT NATIVE
MODULE 'target/arossupport' /*, 'target/exec', 'target/exec/tasks', 'target/exec/alerts'*/
/*{#include <aros/debug.h>}*/

   NATIVE {DEBUG} CONST
   NATIVE {SDEBUG} CONST
   NATIVE {ADEBUG} CONST
   NATIVE {MDEBUG} CONST


	NATIVE {SDEBUG_INDENT} CONST


   NATIVE {SDInit} CONST	->SDInit()
   NATIVE {Indent} DEF
   NATIVE {EnterFunc} PROC	->EnterFunc(x...) D(x)
   NATIVE {ExitFunc} DEF


   NATIVE {ASSERT} CONST	->ASSERT(x)
   NATIVE {ASSERT_VALID_PTR} CONST	->ASSERT_VALID_PTR(x)
   NATIVE {ASSERT_VALID_PTR_OR_NULL} CONST	->ASSERT_VALID_PTR_OR_NULL(x)
   NATIVE {ASSERT_VALID_TASK} CONST	->ASSERT_VALID_TASK(t)
   NATIVE {ASSERT_VALID_PROCESS} CONST	->ASSERT_VALID_PROCESS(p)
   NATIVE {KASSERT} CONST	->KASSERT(x)


/* Memory munging macros
 */
 
NATIVE {MUNGWALL_SIZE} CONST

NATIVE {MUNGWALLHEADER_SIZE} CONST

    NATIVE {MEMFILL_FREE} CONST
    NATIVE {MEMFILL_ALLOC} CONST
    NATIVE {MEMFILL_WALL} CONST


    NATIVE {MUNGE_BLOCK} CONST	->MUNGE_BLOCK(ptr, size, fill)
    NATIVE {CHECK_WALL} CONST	->CHECK_WALL(ptr, fill, size)
    NATIVE {MungWallCheck} PROC	->MungWallCheck()


   NATIVE {D} PROC	->D(x)     /* eps */
   NATIVE {DB2} CONST	->DB2(x)     /* eps */

   NATIVE {ReturnVoid} PROC	->ReturnVoid(name)                 return
   NATIVE {ReturnPtr} PROC	->ReturnPtr(name,type,val)         return val
   NATIVE {ReturnStr} PROC	->ReturnStr(name,type,val)         return val
   NATIVE {ReturnInt} PROC	->ReturnInt(name,type,val)         return val
   NATIVE {ReturnXInt} PROC	->ReturnXInt(name,type,val)        return val
   NATIVE {ReturnFloat} PROC	->ReturnFloat(name,type,val)       return val
   NATIVE {ReturnSpecial} PROC	->ReturnSpecial(name,type,val,fmt) return val
   NATIVE {ReturnBool} PROC	->ReturnBool(name,val)             return val


NATIVE {AROS_DEBUG_H} CONST

NATIVE {bug}	CONST
NATIVE {rbug} PROC	->rbug(main,sub,lvl,fmt,args...) rkprintf (DBG_MAINSYSTEM_ # #main, DBG_ # #main # #_SUBSYSTEM_ # #sub, lvl, fmt, ##args)

/* Debugging constants. These should be defined outside and this
   part should be generated. */
NATIVE {DBG_MAINSYSTEM_INTUITION} CONST
NATIVE {DBG_INTUITION_SUBSYSTEM_INPUTHANDLER} CONST
		
NATIVE {AROS_FUNCTION_NOT_IMPLEMENTED} CONST	->AROS_FUNCTION_NOT_IMPLEMENTED(library) kprintf(#'The function %s/%s() is not implemented.\n', (library), __FUNCTION__)

NATIVE {AROS_METHOD_NOT_IMPLEMENTED} CONST	->AROS_METHOD_NOT_IMPLEMENTED(CLASS, name) kprintf(#'The method %s::%s() is not implemented.\n', (CLASS), (name))

NATIVE {aros_print_not_implemented} PROC	->aros_print_not_implemented(name) kprintf(#'The function %s() is not implemented.\n', (name))

NATIVE {ALIVE} CONST
