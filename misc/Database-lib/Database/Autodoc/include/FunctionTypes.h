@DATABASE "FunctionTypes.h"
@MASTER   "include:joinOS/database/FunctionTypes.h"
@REMARK   This file was created by ADtoHT 2.1 on 06-May-04 21:40:30
@REMARK   Do not edit
@REMARK   ADtoHT is © 1993-1995 Christian Stieber

@NODE MAIN "FunctionTypes.h"

@{"FunctionTypes.h" LINK File}


@{b}Typedefs@{ub}
	@{"DS_UPDATE_FCT" LINK File 22}
	@{"DC_CONVERT" LINK File 32}
	@{"DC_REVERT" LINK File 44}
	@{"REINDEX_PROGRESS" LINK File 54}
	@{"VALIDATE_RECORD" LINK File 61}

@ENDNODE
@NODE File "FunctionTypes.h"
#ifndef _DATABASE_FUNCTIONTYPES_H_
#define _DATABASE_FUNCTIONTYPES_H_ 1

#ifndef _DEFINES_H_
#include <joinOS/exec/defines.h>
#endif

#ifndef _DATABASE_DATASERVER_H_
#include <joinOS/database/DataServer.h>
#endif

/***************************************************************************/
/*                                                                         */
/*                      function-type defintions                           */
/*                                                                         */
/***************************************************************************/

/* This kind of function is used to access the DataServer and its subclasses.
 * Every class that is subclassed from DataServer has to implement a function
 * of this kind, referenced by 'DataServer.Update'.
 */
typedef BOOL __asm (*DS_UPDATE_FCT)(register __a0 @{"struct DataServer" LINK "DataServer.h/File" 95} *, register __d0 ULONG, register __a1 APTR);

/* This kind of function is used to convert the contents of a DataColumn into
 * a human-readable format. It expects two arguments:
 *    - a pointer to the DataColumn whichs value should be converted
 *    - a pointer to the value that should be converted
 *
 * If the function succeeds, TRUE is returned.
 * If the function fails, FALSE is returned.
 */
typedef BOOL __asm (*DC_CONVERT)(register __a0 @{"struct DataColumn" LINK "DataServer.h/File" 74} *, register __a1 APTR);

/* This kind of function is used to convert the contents of a DataColumn from
 * human-readable into raw format. It expects three arguments in registers:
 * A0 - a pointer to the DataColumn whichs value should be reverted
 * A1 - a pointer to the string representing the value that should be reverted
 * A2 - a pointer to the address, where the reverted value should be stored
 *
 * The result is returned in register D0:
 * If the function succeeds, TRUE is returned.
 * If the function fails, FALSE is returned.
 */
typedef BOOL __asm (*DC_REVERT) (register __a0 @{"struct DataColumn" LINK "DataServer.h/File" 74} *, register __a1 STRPTR, register __a2 APTR);

/* A function of this type is used as callback function of the IDX_ReIndex()
 * function to allow an user-application to show the progress to the user.
 * It has to expect three arguments in registers, see the functions -- this
 * functionpointer should be passed as argument to -- for details.
 *
 * The result has to be returned in register D0:
 * If the call back-function returns FALSE, the operation is aborted.
 */
typedef BOOL __asm (*REINDEX_PROGRESS)(register __a0 APTR, register __d0 ULONG, register __a1 APTR);

/* A function of this type is used as callback function for validating
 * records of a DataTable before they are written to the DataTable file.
 * A pointer to such a function can be passed using the Tag @{"DBF_Validate" LINK "DataTable.h/File" 185} to
 * the DBF_InitA() function.
 */
typedef BOOL __asm (*VALIDATE_RECORD)(register __a0 @{"struct DataServer" LINK "DataServer.h/File" 95} *);

#endif      /* _DATABASE_FUNCTIONTYPES_H_ */
@ENDNODE
