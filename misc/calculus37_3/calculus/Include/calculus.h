#ifndef CALCULUS_H
#define CALCULUS_H

#define CalculusName   "calculus.library"
#define CalculusVer    37
#define CALCBASENAME   CalculusBase

long CalcInteger(char *,unsigned long *);

#define RESULT_OK              0     /* all ok */
#define ERROR_STACKEMPTY       1     /* internal error */
#define ERROR_SYNTAX           2     /* syntax error occured */
#define ERROR_STACKOVERFLOW    3     /* expression is to complex */
#define ERROR_VARNOTFOUND      4     /* variable name not found */
#define ERROR_SYMBOLTABLEFULL  5     /* to much vars used */
#define ERROR_LEXEMTABLEFULL   6     /* should not happen ... */
#define ERROR_VARNAMETOOLONG   7     /* variable name is to long */
#define ERROR_NOMEM            8     /* not enough memory */
#define ERROR_DIV0             9     /* Division by zero */
#define ERROR_NOT_A_PROCESS    10    /* if caller is a only a task */

#define ERROR_OK               0 /* obsolete, don't use! */

#endif
