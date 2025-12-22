TREE
IMPORT {#include <stdio.h>
        #include "Idents.h"
        #include "StringMem.h"}

RULE

program = block.

block   = declarations statements.

/* ------------------------------------------------------------ */

declarations = <decls0 = .
                decls1 = declaration declarations.>.

declaration = <constdefs     = consts.
               vardefs       = vars type.
               proceduredefs = ident parametersz block.
               typedefs      = ident type.>.

/* ----------------------------------------- */

consts     = <const0 = .
              const1 = Const consts.>.

Const      = ident number.

/* ----------------------------------------- */

vars       = <var0 = .
              var1 = var vars.>.

var        = ident.

/* ----------------------------------------- */

parametersz = <par0 = .
               par1 = parameters.>.

parameters  = <parameter0 = .
               parameter1 = parameter parameters.>.

parameter   = idents type [VAR : int].

/* ----------------------------------------- */

type       = <typ1 = ident.
              typ2 = number type.>.

/* ------------------------------------------------------------- */

statements = statement <stats0 = .
                        stats1 = statements.>.

statement = <stat0 = .
             stat1 = variable formula.
             stat2 = ident actuals.
             stat3 = variable.
             stat4 = <out1 = formula.
                      out2 = string.>.
             stat5 = formula statements els.
             stat6 = formula statements.>.

/* ----------------------------------------- */

els = <els0 = .
       els1 = statements.>.

/* ------------------------------------------------------------- */

formula     = <forms0 = conjunction.
               forms1 = conjunction formula.>.

conjunction = <conjs0 = relation.
               conjs1 = relation conjunction.>.

relation    = <rel0 = expression.
               rel1 = expression [vergleich : int] exp:expression.>.

expression  = [vorzeichen : int] exps term.
exps        = <exps0 = .
               exps1 = exp exps.>.
exp         = term [addsub : int].

term        = tes factor.
tes         = <tes0 = .
               tes1 = te tes.>.
te          = factor [multdiv : int].

factor      = <fact1 = variable.
               fact2 = number.
               fact3 = [oddnot : int] factor.
               fact4 = formula.>.

variable    = ident arrs.
arrs        = <arr0 = .
               arr1 = expression arrs.>.

actuals     = <act0 = .
               act1 = formula actuals.>.

/* ------------------------------------------------------------- */

string = [str : tStringRef].

idents = <ident0 = .
          ident1 = ident idents.>.

ident  = [id : tIdent].

number = [num : tStringRef].

