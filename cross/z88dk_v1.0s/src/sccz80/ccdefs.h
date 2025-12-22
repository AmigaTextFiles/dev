/*
 *      Small C+ Compiler
 *
 *      The master header file
 *      Includes everything else!!!
 *
 *      $Id: ccdefs.h 1.5 1999/03/18 01:14:26 djm8 Exp $
 */

/*
 *      System wide definitions
 */


#include "define.h"
#include "lvalue.h"

/*
 *      Now some system files for good luck
 */

#include <stdio.h>
#include <stdlib.h>
#include <string.h>

/*
 *      Prototypes
 */


#include "callfunc.h"
#include "codegen.h"
#include "const.h"
#include "data.h"
#include "declvar.h"
#include "declfunc.h"
#include "declinit.h"
#include "error.h"
#include "expr.h"
#include "float.h"
#include "io.h"
#include "lex.h"
#include "main.h"
#include "misc.h"
#include "plunge.h"
#include "preproc.h"
#include "primary.h"
#include "stmt.h"
#include "sym.h"
#include "while.h"

