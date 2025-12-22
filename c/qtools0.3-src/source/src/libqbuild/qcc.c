/*
 * <one line to give the program's name and a brief idea of what it does.>
 * Copyright (C) 1998  Niels Froehling <Niels.Froehling@Informatik.Uni-Oldenburg.de>
 *
 * This program is free software; you can redistribute it and/or modify
 * it under the terms of the GNU General Public License as published by
 * the Free Software Foundation; either version 2 of the License, or
 * (at your option) any later version.
 *
 * This program is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU General Public License for more details.
 *
 * You should have received a copy of the GNU General Public License
 * along with this program; if not, write to the Free Software
 * Foundation, Inc., 675 Mass Ave, Cambridge, MA 02139, USA.
 */

#define	LIBQBUILD_CORE
#include "../include/libqbuild.h"
#include "qcc.h"

staticvar char placeh_string[] = "%s";
staticvar char placeh_strsstr[] = "%s %s";
staticvar char placeh_strstr[] = "%s%s";
staticvar char placeh_intstr[] = "%i(%s)";
staticvar char placeh_intunk[] = "%i(???)";
staticvar char placeh_ifstr [] = "if (%s) {\n";

staticvar char string_void[] = "void";
staticvar char string_string[] = "string";
staticvar char string_float[] = "float";
staticvar char string_vector[] = "vector";
staticvar char string_entity[] = "entity";
staticvar char string_immediate[] = "IMMEDIATE";

staticvar char string_braced[] = "}\n";
staticvar char string_return[] = "\n";

/*=========================================================================== */

staticvar char sourcedir[NAMELEN_PATH];					/* 256 */
staticvar char destfile[NAMELEN_PATH];					/* 256 */

staticvar vec1D *pr_globals = 0;					/*[MAX_REGS];           // 65536 */
staticvar int numpr_globals;						/* 4 */

staticvar char *strings = 0;						/*[MAX_STRINGS];        // 500000 */
staticvar int strofs;							/* 4 */

staticvar dstatement_t *statements = 0;					/*[MAX_STATEMENTS];     // 65536 * 8 = 524288 */
staticvar int numstatements;						/* 4 */
staticvar int *statement_linenums = 0;					/*[MAX_STATEMENTS];     // 65536 * 4 = 262144 */

staticvar dfunction_t *functions = 0;					/*[MAX_FUNCTIONS];      // 8192 * (28 + 8) = 294912 */
staticvar int numfunctions;						/* 4 */

staticvar ddef_t *globals = 0;						/*[MAX_GLOBALS];        // 16384 * 10 = 163840 */
staticvar int numglobaldefs;						/* 4 */

staticvar ddef_t *fields = 0;						/*[MAX_FIELDS];         // 1024 * 10 = 10240 */
staticvar int numfielddefs;						/* 4 */

staticvar struct {
  char *sound;								/* 1024 * 64 = 65536 */
  int block;								/* 1024 * 4 = 4096 */
} *precache_sounds;
staticvar int numsounds;						/* 4 */

staticvar struct {
  char *model;								/* 1024 * 64 = 65536 */
  int block;								/* 1024 * 4 = 4096 */
} *precache_models;							/* 1024 * 64 = 65536 */
staticvar int nummodels;						/* 4 */

staticvar struct {
  char *file;								/* 1024 * 64 = 65536 */
  int block;								/* 1024 * 4 = 4096 */
} *precache_files;							/* 1024 * 64 = 65536 */
staticvar int numfiles;							/* 4 */

/*=========================================================================== */

staticvar int pr_source_line;

staticvar char *pr_file_p;

/* start of current source line */
staticvar char *pr_line_start;

staticvar int pr_bracelevel;

staticvar char pr_token[2048];
staticvar token_type_t pr_token_type;
staticvar type_t *pr_immediate_type;
staticvar eval_t pr_immediate;

staticvar char pr_immediate_string[2048];

staticvar int pr_error_count;

staticvar char *pr_punctuation[] =
/* longer symbols must be before a shorter partial match */
{"&&", "||", "<=", ">=", "==", "!=", ";", ",", "!", "*", "/", "(", ")", "-", "+", "=", "[", "]", "{", "}", "...", ".", "<", ">", "#", "&", "|", NULL};

extern def_t def_void;
extern def_t def_string;
extern def_t def_float;
extern def_t def_vector;
extern def_t def_entity;
extern def_t def_field;
extern def_t def_function;
extern def_t def_pointer;

/* simple types.  function types are dynamically allocated */
staticvar type_t type_void =
{ev_void, &def_void};
staticvar type_t type_string =
{ev_string, &def_string};
staticvar type_t type_float =
{ev_float, &def_float};
staticvar type_t type_vector =
{ev_vector, &def_vector};
staticvar type_t type_entity =
{ev_entity, &def_entity};
staticvar type_t type_field =
{ev_field, &def_field};
staticvar type_t type_function =
{ev_function, &def_function, NULL, &type_void};

/* type_function is a void() function used for state defs */
staticvar type_t type_pointer =
{ev_pointer, &def_pointer};

staticvar type_t type_floatfield =
{ev_field, &def_field, NULL, &type_float};

staticvar int type_size[8] =
{1, 1, 1, 3, 1, 1, 1, 1};

def_t def_void =
{&type_void, "temp"};
def_t def_string =
{&type_string, "temp"};
def_t def_float =
{&type_float, "temp"};
def_t def_vector =
{&type_vector, "temp"};
def_t def_entity =
{&type_entity, "temp"};
def_t def_field =
{&type_field, "temp"};
def_t def_function =
{&type_function, "temp"};
def_t def_pointer =
{&type_pointer, "temp"};

staticvar def_t def_ret, def_parms[MAX_PARMS];

staticvar def_t *def_for_type[8] =
{&def_void, &def_string, &def_float, &def_vector, &def_entity, &def_field, &def_function, &def_pointer};

/*=========================================================================== */

staticvar pr_info_t pr;
staticvar def_t **pr_global_defs;		       /* to find def for a global variable */
staticvar int pr_edict_size;
staticvar char *pr_parm_names[MAX_PARMS];

/*======================================== */

/* the function being parsed, or NULL */
staticvar def_t *pr_scope;

staticvar bool pr_dumpasm;

/* filename for function definition */
staticvar string_t s_file;

/* for tracking local variables vs temps */
staticvar int locals_end;

/* longjump with this on parse error */
staticvar jmp_buf pr_parse_abort;

staticvar char pr_framemacros[MAX_FRAMES][16];
staticvar int pr_nummacros;

/*======================================== */

staticvar opcode_t pr_opcodes[] =
{
  {"<DONE>", "DONE", -1, FALSE, &def_entity, &def_field, &def_void},

  {"*", "MUL_F", 2, FALSE, &def_float, &def_float, &def_float},
  {"*", "MUL_V", 2, FALSE, &def_vector, &def_vector, &def_float},
  {"*", "MUL_FV", 2, FALSE, &def_float, &def_vector, &def_vector},
  {"*", "MUL_VF", 2, FALSE, &def_vector, &def_float, &def_vector},

  {"/", "DIV", 2, FALSE, &def_float, &def_float, &def_float},

  {"+", "ADD_F", 3, FALSE, &def_float, &def_float, &def_float},
  {"+", "ADD_V", 3, FALSE, &def_vector, &def_vector, &def_vector},

  {"-", "SUB_F", 3, FALSE, &def_float, &def_float, &def_float},
  {"-", "SUB_V", 3, FALSE, &def_vector, &def_vector, &def_vector},

  {"==", "EQ_F", 4, FALSE, &def_float, &def_float, &def_float},
  {"==", "EQ_V", 4, FALSE, &def_vector, &def_vector, &def_float},
  {"==", "EQ_S", 4, FALSE, &def_string, &def_string, &def_float},
  {"==", "EQ_E", 4, FALSE, &def_entity, &def_entity, &def_float},
  {"==", "EQ_FNC", 4, FALSE, &def_function, &def_function, &def_float},

  {"!=", "NE_F", 4, FALSE, &def_float, &def_float, &def_float},
  {"!=", "NE_V", 4, FALSE, &def_vector, &def_vector, &def_float},
  {"!=", "NE_S", 4, FALSE, &def_string, &def_string, &def_float},
  {"!=", "NE_E", 4, FALSE, &def_entity, &def_entity, &def_float},
  {"!=", "NE_FNC", 4, FALSE, &def_function, &def_function, &def_float},

  {"<=", "LE", 4, FALSE, &def_float, &def_float, &def_float},
  {">=", "GE", 4, FALSE, &def_float, &def_float, &def_float},
  {"<", "LT", 4, FALSE, &def_float, &def_float, &def_float},
  {">", "GT", 4, FALSE, &def_float, &def_float, &def_float},

  {".", "INDIRECT", 1, FALSE, &def_entity, &def_field, &def_float},
  {".", "INDIRECT", 1, FALSE, &def_entity, &def_field, &def_vector},
  {".", "INDIRECT", 1, FALSE, &def_entity, &def_field, &def_string},
  {".", "INDIRECT", 1, FALSE, &def_entity, &def_field, &def_entity},
  {".", "INDIRECT", 1, FALSE, &def_entity, &def_field, &def_field},
  {".", "INDIRECT", 1, FALSE, &def_entity, &def_field, &def_function},

  {".", "ADDRESS", 1, FALSE, &def_entity, &def_field, &def_pointer},

  {"=", "STORE_F", 5, TRUE, &def_float, &def_float, &def_float},
  {"=", "STORE_V", 5, TRUE, &def_vector, &def_vector, &def_vector},
  {"=", "STORE_S", 5, TRUE, &def_string, &def_string, &def_string},
  {"=", "STORE_ENT", 5, TRUE, &def_entity, &def_entity, &def_entity},
  {"=", "STORE_FLD", 5, TRUE, &def_field, &def_field, &def_field},
  {"=", "STORE_FNC", 5, TRUE, &def_function, &def_function, &def_function},

  {"=", "STOREP_F", 5, TRUE, &def_pointer, &def_float, &def_float},
  {"=", "STOREP_V", 5, TRUE, &def_pointer, &def_vector, &def_vector},
  {"=", "STOREP_S", 5, TRUE, &def_pointer, &def_string, &def_string},
  {"=", "STOREP_ENT", 5, TRUE, &def_pointer, &def_entity, &def_entity},
  {"=", "STOREP_FLD", 5, TRUE, &def_pointer, &def_field, &def_field},
  {"=", "STOREP_FNC", 5, TRUE, &def_pointer, &def_function, &def_function},

  {"<RETURN>", "RETURN", -1, FALSE, &def_void, &def_void, &def_void},

  {"!", "NOT_F", -1, FALSE, &def_float, &def_void, &def_float},
  {"!", "NOT_V", -1, FALSE, &def_vector, &def_void, &def_float},
  {"!", "NOT_S", -1, FALSE, &def_vector, &def_void, &def_float},
  {"!", "NOT_ENT", -1, FALSE, &def_entity, &def_void, &def_float},
  {"!", "NOT_FNC", -1, FALSE, &def_function, &def_void, &def_float},

  {"<IF>", "IF", -1, FALSE, &def_float, &def_float, &def_void},
  {"<IFNOT>", "IFNOT", -1, FALSE, &def_float, &def_float, &def_void},

  /* calls returns REG_RETURN */
  {"<CALL0>", "CALL0", -1, FALSE, &def_function, &def_void, &def_void},
  {"<CALL1>", "CALL1", -1, FALSE, &def_function, &def_void, &def_void},
  {"<CALL2>", "CALL2", -1, FALSE, &def_function, &def_void, &def_void},
  {"<CALL3>", "CALL3", -1, FALSE, &def_function, &def_void, &def_void},
  {"<CALL4>", "CALL4", -1, FALSE, &def_function, &def_void, &def_void},
  {"<CALL5>", "CALL5", -1, FALSE, &def_function, &def_void, &def_void},
  {"<CALL6>", "CALL6", -1, FALSE, &def_function, &def_void, &def_void},
  {"<CALL7>", "CALL7", -1, FALSE, &def_function, &def_void, &def_void},
  {"<CALL8>", "CALL8", -1, FALSE, &def_function, &def_void, &def_void},

  {"<STATE>", "STATE", -1, FALSE, &def_float, &def_float, &def_void},

  {"<GOTO>", "GOTO", -1, FALSE, &def_float, &def_void, &def_void},

  {"&&", "AND", 6, FALSE, &def_float, &def_float, &def_float},
  {"||", "OR", 6, FALSE, &def_float, &def_float, &def_float},

  {"&", "BITAND", 2, FALSE, &def_float, &def_float, &def_float},
  {"|", "BITOR", 2, FALSE, &def_float, &def_float, &def_float},

  {NULL}
};

staticfnc def_t *PR_Expression(register int priority);

staticvar def_t junkdef;

/*
 * ===========================================================================
 * qcc
 * ===========================================================================
 */

/* CopyString returns an offset from the string heap */
staticfnc int CopyString(register char *str)
{
  int old;

  old = strofs;
  __strcpy(strings + strofs, str);
  strofs += __strlen(str) + 1;
  return old;
}

staticfnc void PrintStrings(void)
{
  int i, l, j;

  for (i = 0; i < strofs; i += l) {
    l = __strlen(strings + i) + 1;
    mprintf("%5i : ", i);
    for (j = 0; j < l; j++) {
      if (strings[i + j] == '\n') {
	putchar('\\');
	putchar('n');
      }
      else
	putchar(strings[i + j]);
    }
    mprintf(string_return);
  }
}

staticfnc void PrintFunctions(void)
{
  int i, j;
  dfunction_t *d;

  for (i = 0; i < numfunctions; i++) {
    d = &functions[i];
    mprintf("%s : %s : %i %i (", strings + d->s_file, strings + d->s_name, d->first_statement, d->parm_start);
    for (j = 0; j < d->numparms; j++)
      mprintf("%i ", d->parm_size[j]);
    mprintf(")\n");
  }
}

staticfnc void PrintFields(void)
{
  int i;
  ddef_t *d;

  for (i = 0; i < numfielddefs; i++) {
    d = &fields[i];
    mprintf("%5i : (%i) %s\n", d->ofs, d->type, strings + d->s_name);
  }
}

staticfnc void PrintGlobals(void)
{
  int i;
  ddef_t *d;

  for (i = 0; i < numglobaldefs; i++) {
    d = &globals[i];
    mprintf("%5i : (%i) %s\n", d->ofs, d->type, strings + d->s_name);
  }
}

/*=========================================================================== */

staticfnc void PrecacheSound(register def_t * e, register int ch)
{
  char *n;
  int i;

  if (!e->ofs)
    return;
  n = G_STRING(e->ofs);
  for (i = 0; i < numsounds; i++)
    if (!__strcmp(n, precache_sounds[i].sound))
      return;
  if (numsounds == MAX_SOUNDS)
    eprintf("PrecacheSound: numsounds == MAX_SOUNDS");
  precache_sounds[i].sound = smalloc(n);	/* TODO: check */
  if (ch >= '1' && ch <= '9')
    precache_sounds[i].block = ch - '0';
  else
    precache_sounds[i].block = 1;
  numsounds++;
}

staticfnc void PrecacheModel(register def_t * e, register int ch)
{
  char *n;
  int i;

  if (!e->ofs)
    return;
  n = G_STRING(e->ofs);
  for (i = 0; i < nummodels; i++)
    if (!__strcmp(n, precache_models[i].model))
      return;
  if (numsounds == MAX_SOUNDS)
    eprintf("PrecacheModels: numsounds == MAX_SOUNDS");
  precache_models[i].model = smalloc(n);	/* TODO: check */
  if (ch >= '1' && ch <= '9')
    precache_models[i].block = ch - '0';
  else
    precache_models[i].block = 1;
  nummodels++;
}

staticfnc void PrecacheFile(register def_t * e, register int ch)
{
  char *n;
  int i;

  if (!e->ofs)
    return;
  n = G_STRING(e->ofs);
  for (i = 0; i < numfiles; i++)
    if (!__strcmp(n, precache_files[i].file))
      return;
  if (numfiles == MAX_FILES)
    eprintf("PrecacheFile: numfiles == MAX_FILES");
  precache_files[i].file = smalloc(n);	/* TODO: check */
  if (ch >= '1' && ch <= '9')
    precache_files[i].block = ch - '0';
  else
    precache_files[i].block = 1;
  numfiles++;
}

/*
 * 
 * ============
 * WriteFiles
 * 
 * Generates files.dat, which contains all of the
 * data files actually used by the game, to be
 * processed by qfiles.exe
 * ============
 */
staticfnc void WriteFiles(void)
{
  FILE *f;
  int i;
  char filename[NAMELEN_PATH];

  sprintf(filename, "%sfiles.dat", sourcedir);
  f = __fopen(filename, "w");
  if (!f)
    eprintf("Couldn't open %s", filename);
  else {
    fprintf(f, "%i\n", numsounds);
    for (i = 0; i < numsounds; i++)
      fprintf(f, "%i %s\n", precache_sounds[i].block, precache_sounds[i].sound);

    fprintf(f, "%i\n", nummodels);
    for (i = 0; i < nummodels; i++)
      fprintf(f, "%i %s\n", precache_models[i].block, precache_models[i].model);

    fprintf(f, "%i\n", numfiles);
    for (i = 0; i < numfiles; i++)
      fprintf(f, "%i %s\n", precache_files[i].block, precache_files[i].file);

    __fclose(f);
  }
}

/*=========================================================================== */

/*
 * ============
 * PR_ParseError
 * 
 * Aborts the current file load
 * ============
 */
staticfnc void PR_ParseError(char *error,...)
{
  va_list argptr;
  char string[1024];

  va_start(argptr, error);
  vsprintf(string, error, argptr);
  va_end(argptr);

  mprintf("%s:%i:%s\n", strings + s_file, pr_source_line, string);

  longjmp(pr_parse_abort, 1);
}

/*
 * ==============
 * PR_PrintNextLine
 * ==============
 */
staticfnc void PR_PrintNextLine(void)
{
  char *t;

  mprintf("%3i:", pr_source_line);
  for (t = pr_line_start; *t && *t != '\n'; t++)
    mprintf("%c", *t);
  mprintf(string_return);
}

/*
 * ==============
 * PR_NewLine
 * 
 * Call at start of file and when *pr_file_p == '\n'
 * ==============
 */
staticfnc void PR_NewLine(void)
{
  bool m;

  if (*pr_file_p == '\n') {
    pr_file_p++;
    m = TRUE;
  }
  else
    m = FALSE;

  pr_source_line++;
  pr_line_start = pr_file_p;

/*if (pr_dumpasm) */
/*  PR_PrintNextLine (); */
  if (m)
    pr_file_p--;
}

/*
 * ==============
 * PR_LexString
 * 
 * Parses a quoted string
 * ==============
 */
staticfnc void PR_LexString(void)
{
  int c;
  int len;

  len = 0;
  pr_file_p++;
  do {
    c = *pr_file_p++;
    if (!c)
      PR_ParseError("EOF inside quote");
    if (c == '\n')
      PR_ParseError("newline inside quote");
    if (c == '\\') {						/* escape char */
      c = *pr_file_p++;
      if (!c)
	PR_ParseError("EOF inside quote");
      if (c == 'n')
	c = '\n';
      else if (c == '"')
	c = '\"';
      else
	PR_ParseError("Unknown escape char");
    }
    else if (c == '\"') {
      pr_token[len] = 0;
      pr_token_type = tt_immediate;
      pr_immediate_type = &type_string;
      __strcpy(pr_immediate_string, pr_token);
      return;
    }
    pr_token[len] = c;
    len++;
  } while (1);
}

/*
 * ==============
 * PR_LexNumber
 * ==============
 */
staticfnc vec1D PR_LexNumber(void)
{
  int c;
  int len;

  len = 0;
  c = *pr_file_p;
  do {
    pr_token[len] = c;
    len++;
    pr_file_p++;
    c = *pr_file_p;
  } while ((c >= '0' && c <= '9') || c == '.');
  pr_token[len] = 0;
  return atof(pr_token);
}

/*
 * ==============
 * PR_LexWhitespace
 * ==============
 */
staticfnc void PR_LexWhitespace(void)
{
  int c;

  while (1) {
    /* skip whitespace */
    while ((c = *pr_file_p) <= ' ') {
      if (c == '\n')
	PR_NewLine();
      if (c == 0)
	return;							/* end of file */

      pr_file_p++;
    }

    /* skip // comments */
    if (c == '/' && pr_file_p[1] == '/') {
      while (*pr_file_p && *pr_file_p != '\n')
	pr_file_p++;
      PR_NewLine();
      pr_file_p++;
      continue;
    }

    /* skip * * comments */
    if (c == '/' && pr_file_p[1] == '*') {
      do {
	pr_file_p++;
	if (pr_file_p[0] == '\n')
	  PR_NewLine();
	if (pr_file_p[1] == 0)
	  return;
      } while (pr_file_p[-1] != '*' || pr_file_p[0] != '/');
      pr_file_p++;
      continue;
    }
    break;							/* a real character has been found */

  }
}

/*
 * ==============
 * PR_LexVector
 * 
 * Parses a single quoted vector
 * ==============
 */
staticfnc void PR_LexVector(void)
{
  int i;

  pr_file_p++;
  pr_token_type = tt_immediate;
  pr_immediate_type = &type_vector;
  for (i = 0; i < 3; i++) {
    pr_immediate.vector[i] = PR_LexNumber();
    PR_LexWhitespace();
  }
  if (*pr_file_p != '\'')
    PR_ParseError("Bad vector");
  pr_file_p++;
}

/*
 * ==============
 * PR_LexName
 * 
 * Parses an identifier
 * ==============
 */
staticfnc void PR_LexName(void)
{
  int c;
  int len;

  len = 0;
  c = *pr_file_p;
  do {
    pr_token[len] = c;
    len++;
    pr_file_p++;
    c = *pr_file_p;
  } while ((c >= 'a' && c <= 'z') || (c >= 'A' && c <= 'Z') || c == '_' || (c >= '0' && c <= '9'));
  pr_token[len] = 0;
  pr_token_type = tt_name;
}

/*
 * ==============
 * PR_LexPunctuation
 * ==============
 */
staticfnc void PR_LexPunctuation(void)
{
  int i;
  int len;
  char *p;

  pr_token_type = tt_punct;

  for (i = 0; (p = pr_punctuation[i]) != NULL; i++) {
    len = __strlen(p);
    if (!__strncmp(p, pr_file_p, len)) {
      __strcpy(pr_token, p);
      if (p[0] == '{')
	pr_bracelevel++;
      else if (p[0] == '}')
	pr_bracelevel--;
      pr_file_p += len;
      return;
    }
  }

  PR_ParseError("Unknown punctuation");
}

staticfnc void PR_ClearGrabMacros(void)
{
  pr_nummacros = 0;
}

staticfnc void PR_FindMacro(void)
{
  int i;

  for (i = 0; i < pr_nummacros; i++)
    if (!__strcmp(pr_token, pr_framemacros[i])) {
      sprintf(pr_token, "%d", i);
      pr_token_type = tt_immediate;
      pr_immediate_type = &type_float;
      pr_immediate._float = i;
      return;
    }
  PR_ParseError("Unknown frame macro $%s", pr_token);
}

/* just parses text, returning FALSE if an eol is reached */
staticfnc bool PR_SimpleGetToken(void)
{
  int c;
  int i;

  /* skip whitespace */
  while ((c = *pr_file_p) <= ' ') {
    if (c == '\n' || c == 0)
      return FALSE;
    pr_file_p++;
  }

  i = 0;
  while ((c = *pr_file_p) > ' ' && c != ',' && c != ';') {
    pr_token[i] = c;
    i++;
    pr_file_p++;
  }
  pr_token[i] = 0;
  return TRUE;
}

staticfnc void PR_ParseFrame(void)
{
  while (PR_SimpleGetToken()) {
    __strcpy(pr_framemacros[pr_nummacros], pr_token);
    pr_nummacros++;
  }
}

/*
 * ==============
 * PR_Lex
 * 
 * Sets pr_token, pr_token_type, and possibly pr_immediate and pr_immediate_type
 * ==============
 */
staticfnc void PR_LexGrab(void);
staticfnc void PR_Lex(void)
{
  int c;

  pr_token[0] = 0;

  if (!pr_file_p) {
    pr_token_type = tt_eof;
    return;
  }

  PR_LexWhitespace();

  c = *pr_file_p;

  if (!c) {
    pr_token_type = tt_eof;
    return;
  }

  /* handle quoted strings as a unit */
  if (c == '\"') {
    PR_LexString();
    return;
  }

  /* handle quoted vectors as a unit */
  if (c == '\'') {
    PR_LexVector();
    return;
  }

  /* if the first character is a valid identifier, parse until a non-id */
  /* character is reached */
  if ((c >= '0' && c <= '9') || (c == '-' && pr_file_p[1] >= '0' && pr_file_p[1] <= '9')) {
    pr_token_type = tt_immediate;
    pr_immediate_type = &type_float;
    pr_immediate._float = PR_LexNumber();
    return;
  }

  if ((c >= 'a' && c <= 'z') || (c >= 'A' && c <= 'Z') || c == '_') {
    PR_LexName();
    return;
  }

  if (c == '$') {
    PR_LexGrab();
    return;
  }

  /* parse symbol strings until a non-symbol is found */
  PR_LexPunctuation();
}

/*
 * ==============
 * PR_LexGrab
 * 
 * Deals with counting sequence numbers and replacing frame macros
 * ==============
 */
staticfnc void PR_LexGrab(void)
{
  pr_file_p++;							/* skip the $ */

  if (!PR_SimpleGetToken())
    PR_ParseError("hanging $");

  /* check for $frame */
  if (!__strcmp(pr_token, "frame")) {
    PR_ParseFrame();
    PR_Lex();
  }
  /* ignore other known $commands */
  else if (   !__strcmp(pr_token, "cd")
	   || !__strcmp(pr_token, "origin")
	   || !__strcmp(pr_token, "base")
	   || !__strcmp(pr_token, "flags")
	   || !__strcmp(pr_token, "scale")
	   || !__strcmp(pr_token, "skin")) {			/* skip to end of line */

    while (PR_SimpleGetToken());
    PR_Lex();
  }
  /* look for a frame name macro */
  else
    PR_FindMacro();
}

/*
 * =============
 * PR_Expect
 * 
 * Issues an error if the current token isn't equal to string
 * Gets the next token
 * =============
 */
staticfnc void PR_ExpectString(register char *string)
{
  if (!__strcmp(string, pr_token))
    PR_Lex();
  else
    PR_ParseError("expected %s, found %s", string, pr_token);
}

staticfnc void PR_ExpectCharacter(register char character)
{
  if ((character == pr_token[0]) && !pr_token[1])
    PR_Lex();
  else
    PR_ParseError("expected %c, found %c", character, *pr_token);
}

/*
 * =============
 * PR_CheckString
 * 
 * Returns TRUE and gets the next token if the current token equals string
 * Returns FALSE and does nothing otherwise
 * =============
 */
staticfnc bool PR_CheckString(register char *string)
{
  if (!__strcmp(string, pr_token)) {
    PR_Lex();
    return TRUE;
  }
    return FALSE;
}

staticfnc bool PR_CheckCharacter(register char character)
{
  if ((character == pr_token[0]) && !pr_token[1]) {
    PR_Lex();
    return TRUE;
  }
  else
    return FALSE;
}

/*
 * ============
 * PR_ParseName
 * 
 * Checks to see if the current token is a valid name
 * ============
 */
staticfnc char *PR_ParseName(void)
{
  char *ident;

  if (pr_token_type != tt_name)
    PR_ParseError("not a name");
  ident = skmalloc(pr_token);	/* TODO: check */
  PR_Lex();

  return ident;
}

/*
 * ============
 * PR_FindType
 * 
 * Returns a preexisting complex type that matches the parm, or allocates
 * a new one and copies it out.
 * ============
 */
staticfnc type_t *PR_FindType(register type_t * type)
{
  def_t *def;
  type_t *check;
  int i;

  for (check = pr.types; check; check = check->next) {
    if (check->type != type->type ||
	check->aux_type != type->aux_type ||
	check->num_parms != type->num_parms)
      continue;

    for (i = 0; i < type->num_parms; i++)
      if (check->parm_types[i] != type->parm_types[i])
	break;

    if (i == type->num_parms)
      return check;
  }

  /* allocate a new one */
  check = (type_t *)kmalloc(sizeof(type_t));	/* TODO: check */
  *check = *type;
  check->next = pr.types;
  pr.types = check;

  /* allocate a generic def for the type, so fields can reference it */
  def = (def_t *)kmalloc(sizeof(def_t));
  def->name = "COMPLEX TYPE";
  def->type = check;
  check->def = def;
  return check;
}

/*
 * ============
 * PR_SkipToSemicolon
 * 
 * For error recovery, also pops out of nested braces
 * ============
 */
staticfnc void PR_SkipToSemicolon(void)
{
  do {
    if (!pr_bracelevel && PR_CheckCharacter(';'))
      return;
    PR_Lex();
  } while (pr_token[0]);					/* eof will return a null token */

}

/*
 * ============
 * PR_ParseType
 * 
 * Parses a variable type, including field and functions types
 * ============
 */
staticfnc type_t *PR_ParseType(void)
{
  type_t new;
  type_t *type;

  if (PR_CheckCharacter('.')) {
    __bzero(&new, sizeof(new));
    new.type = ev_field;
    new.aux_type = PR_ParseType();
    return PR_FindType(&new);
  }

  if (!__strcmp(pr_token, string_float))
    type = &type_float;
  else if (!__strcmp(pr_token, string_vector))
    type = &type_vector;
  else if (!__strcmp(pr_token, string_float))
    type = &type_float;
  else if (!__strcmp(pr_token, string_entity))
    type = &type_entity;
  else if (!__strcmp(pr_token, string_string))
    type = &type_string;
  else if (!__strcmp(pr_token, string_void))
    type = &type_void;
  else {
    PR_ParseError("\"%s\" is not a type", pr_token);
    type = &type_float;						/* shut up compiler warning */
  }
  PR_Lex();

  if (!PR_CheckCharacter('('))
    return type;

  /* function type */
  __bzero(&new, sizeof(new));
  new.type = ev_function;
  new.aux_type = type;						/* return type */

  new.num_parms = 0;
  if (!PR_CheckCharacter(')')) {
    if (PR_CheckString("..."))
      new.num_parms = -1;					/* variable args */
    else
      do {
	new.parm_types[new.num_parms] = PR_ParseType();
	pr_parm_names[new.num_parms] = PR_ParseName();
	new.num_parms++;
      } while (PR_CheckCharacter(','));

    PR_ExpectCharacter(')');
  }

  return PR_FindType(&new);
}
/*
 * ============
 * PR_Statement
 * 
 * Emits a primitive statement, returning the var it places it's value in
 * ============
 */
staticfnc def_t *PR_Statement(register opcode_t * op, register def_t * var_a, register def_t * var_b)
{
  dstatement_t *statement;
  def_t *var_c;

  statement = &statements[numstatements];
  numstatements++;

  statement_linenums[statement - statements] = pr_source_line;
  statement->op = op - pr_opcodes;
  statement->a = var_a ? var_a->ofs : 0;
  statement->b = var_b ? var_b->ofs : 0;

  if (op->type_c == &def_void || op->right_associative) {
    var_c = NULL;
    statement->c = 0;						/* ifs, gotos, and assignments */
    /* don't need vars allocated */
  }
  else {							/* allocate result space */
    var_c = (def_t *)kmalloc(sizeof(def_t));
    var_c->ofs = numpr_globals;
    var_c->type = op->type_c->type;

    statement->c = numpr_globals;
    numpr_globals += type_size[op->type_c->type->type];
  }

  if (op->right_associative)
    return var_a;
  return var_c;
}

/*
 * ============
 * PR_ParseImmediate
 * 
 * Looks for a preexisting constant
 * ============
 */
#if NO_CACHE
staticfnc def_t *PR_ParseImmediate(void)
{
  def_t *cn;

  /* check for a constant with the same value */
  for (cn = pr.def_head.next; cn; cn = cn->next) {
    if (!cn->initialized)
      continue;
    if (cn->type != pr_immediate_type)
      continue;
    if (pr_immediate_type == &type_string) {
      if (!__strcmp(G_STRING(cn->ofs), pr_immediate_string)) {
	PR_Lex();
	return cn;
      }
    }
    else if (pr_immediate_type == &type_float) {
      if (G_FLOAT(cn->ofs) == pr_immediate._float) {
	PR_Lex();
	return cn;
      }
    }
    else if (pr_immediate_type == &type_vector) {
      if ((G_FLOAT(cn->ofs) == pr_immediate.vector[0])
	  && (G_FLOAT(cn->ofs + 1) == pr_immediate.vector[1])
	  && (G_FLOAT(cn->ofs + 2) == pr_immediate.vector[2])) {
	PR_Lex();
	return cn;
      }
    }
    else
      PR_ParseError("weird immediate type");
  }

  /* allocate a new one */
  cn = (def_t *)kmalloc(sizeof(def_t));
  cn->next = NULL;

  pr.def_tail->next = cn;
  pr.def_tail = cn;

  cn->search_next = pr.search;

  pr.search = cn;

  cn->type = pr_immediate_type;
  cn->name = string_immediate;
  cn->initialized = 1;
  cn->scope = NULL;						/* always share immediates */

  /* copy the immediate to the global area */
  cn->ofs = numpr_globals;
  pr_global_defs[cn->ofs] = cn;
  numpr_globals += type_size[pr_immediate_type->type];
  if (pr_immediate_type == &type_string)
    pr_immediate.string = CopyString(pr_immediate_string);

  __memcpy(pr_globals + cn->ofs, &pr_immediate, 4 * type_size[pr_immediate_type->type]);

  PR_Lex();

  return cn;
}
#else
staticfnc def_t *PR_ParseImmediate(void)
{
#undef cacheSize
#undef cacheMask
#define cacheSize  32
#define cacheMask  (cacheSize - 1)
  static def_t *stringCache[cacheSize];
  static int stringTop = 0;
  static def_t *floatCache[cacheSize];
  static int floatTop = 0;
  static def_t *vectorCache[cacheSize];
  static int vectorTop = 0;
  int sub;
  def_t *cn;

  if (pr_immediate_type == &type_string) {
    /* See if constant is in cache. */
    sub = stringTop;
    do {
      cn = stringCache[sub];
      if (!cn)
	break;
      if (!__strcmp(G_STRING(cn->ofs), pr_immediate_string)) {
	PR_Lex();
	stringCache[sub] = stringCache[stringTop];
	stringCache[stringTop] = cn;
	return cn;
      }
      sub = (sub - 1) & cacheMask;
    }
    while (sub != stringTop);

    /* See if constant is in main list. */
    for (cn = pr.def_tail; cn; cn = cn->prev) {
      if (!cn->initialized || cn->type != pr_immediate_type)
	continue;
      if (!__strcmp(G_STRING(cn->ofs), pr_immediate_string)) {
	PR_Lex();
	stringTop = (stringTop + 1) & cacheMask;
	stringCache[stringTop] = cn;
	return cn;
      }
    }
  }
  else if (pr_immediate_type == &type_float) {
    /* See if constant is in cache. */
    sub = floatTop;
    do {
      cn = floatCache[sub];
      if (!cn)
	break;
      if (G_FLOAT(cn->ofs) == pr_immediate._float) {
	PR_Lex();
	floatCache[sub] = floatCache[floatTop];
	floatCache[floatTop] = cn;
	return cn;
      }
      sub = (sub - 1) & cacheMask;
    }
    while (sub != floatTop);

    /* See if constant is in main list. */
    for (cn = pr.def_tail; cn; cn = cn->prev) {
      if (!cn->initialized || cn->type != pr_immediate_type)
	continue;
      if (G_FLOAT(cn->ofs) == pr_immediate._float) {
	PR_Lex();
	floatTop = (floatTop + 1) & cacheMask;
	floatCache[floatTop] = cn;
	return cn;
      }
    }
  }
  else if (pr_immediate_type == &type_vector) {
    /* See if constant is in cache. */
    sub = vectorTop;
    do {
      cn = vectorCache[sub];
      if (!cn)
	break;
      if ((G_FLOAT(cn->ofs) == pr_immediate.vector[0])
	  && (G_FLOAT(cn->ofs + 1) == pr_immediate.vector[1])
	  && (G_FLOAT(cn->ofs + 2) == pr_immediate.vector[2])) {
	PR_Lex();
	vectorCache[sub] = vectorCache[vectorTop];
	vectorCache[vectorTop] = cn;
	return cn;
      }
      sub = (sub - 1) & cacheMask;
    }
    while (sub != vectorTop);

    /* See if constant is in main list. */
    for (cn = pr.def_tail; cn; cn = cn->prev) {
      if (!cn->initialized || cn->type != pr_immediate_type)
	continue;
      if ((G_FLOAT(cn->ofs) == pr_immediate.vector[0])
	  && (G_FLOAT(cn->ofs + 1) == pr_immediate.vector[1])
	  && (G_FLOAT(cn->ofs + 2) == pr_immediate.vector[2])) {
	PR_Lex();
	vectorTop = (vectorTop + 1) & cacheMask;
	vectorCache[vectorTop] = cn;
	return cn;
      }
    }
  }
  else
    PR_ParseError("weird immediate type");

  /* allocate a new one */
  cn = (def_t *)kmalloc(sizeof(def_t));
  cn->next = NULL;
  if (!pr.def_head) {
    cn->prev = NULL;
    pr.def_head = pr.def_tail = cn;
  }
  else {
    pr.def_tail->next = cn;
    cn->prev = pr.def_tail;
    pr.def_tail = cn;
  }
  cn->type = pr_immediate_type;
  cn->name = string_immediate;
  cn->initialized = 1;
  cn->scope = NULL;						/* always share immediates */

  /* Copy the immediate to the global area */
  cn->ofs = numpr_globals;
  pr_global_defs[cn->ofs] = cn;

  /* Put immediate into cache. */
  if (pr_immediate_type == &type_string) {
    stringTop = (stringTop + 1) & cacheMask;
    stringCache[stringTop] = cn;
  }
  else if (pr_immediate_type == &type_float) {
    floatTop = (floatTop + 1) & cacheMask;
    floatCache[floatTop] = cn;
  }
  else {
    vectorTop = (vectorTop + 1) & cacheMask;
    vectorCache[vectorTop] = cn;
  }

  numpr_globals += type_size[pr_immediate_type->type];
  if (pr_immediate_type == &type_string)
    pr_immediate.string = CopyString(pr_immediate_string);

  __memcpy(pr_globals + cn->ofs, &pr_immediate, 4 * type_size[pr_immediate_type->type]);

  PR_Lex();

  return cn;
}
#endif

/*
 * ============
 * PR_ParseFunctionCall
 * ============
 */
staticfnc def_t *PR_ParseFunctionCall(register def_t * func)
{
  def_t *e;
  int arg;
  type_t *t;

  t = func->type;

  if (t->type != ev_function)
    PR_ParseError("not a function");

  /* copy the arguments to the global parameter variables */
  arg = 0;
  if (!PR_CheckCharacter(')')) {
    do {
      if (t->num_parms != -1 && arg >= t->num_parms)
	PR_ParseError("too many parameters");
      e = PR_Expression(TOP_PRIORITY);

      if (arg == 0 && func->name) {
        if (!__strncmp(func->name, "precache_", 9)) {
	  /* save information for model and sound caching */
	  if (!__strncmp(func->name + 9, "sound", 5))
	    PrecacheSound(e, func->name[14]);
	  else if (!__strncmp(func->name + 9, "model", 5))
	    PrecacheModel(e, func->name[14]);
	  else if (!__strncmp(func->name + 9, "file", 4))
	    PrecacheFile(e, func->name[13]);
	}
      }

      if (t->num_parms != -1 && (e->type != t->parm_types[arg]))
	PR_ParseError("type mismatch on parm %i", arg);
      /* a vector copy will copy everything */
      def_parms[arg].type = t->parm_types[arg];
      PR_Statement(&pr_opcodes[OP_STORE_V], e, &def_parms[arg]);
      arg++;
    } while (PR_CheckCharacter(','));

    if (t->num_parms != -1 && arg != t->num_parms)
      PR_ParseError("too few parameters");
    PR_ExpectCharacter(')');
  }
  if (arg > 8)
    PR_ParseError("More than eight parameters");

  PR_Statement(&pr_opcodes[OP_CALL0 + arg], func, 0);

  def_ret.type = t->aux_type;
  return &def_ret;
}

/*
 * ============
 * PR_GetDef
 * 
 * If type is NULL, it will match any type
 * If allocate is TRUE, a new def will be allocated if it can't be found
 * ============
 */
#ifdef NO_CACHE
staticfnc def_t *PR_GetDef(register type_t * type, register char *name, register def_t * scope, register bool allocate)
{
  def_t *def, **old;
  char *element;

  /* see if the name is already in use */
  old = &pr.search;
  for (def = *old; def; old = &def->search_next, def = *old)
    if (!__strcmp(def->name, name)) {
      if (def->scope && def->scope != scope)
	continue;						/* in a different function */

      if (type && def->type != type)
	PR_ParseError("Type mismatch on redeclaration of %s", name);

      /* move to head of list to find fast next time */
      *old = def->search_next;

      def->search_next = pr.search;

      pr.search = def;

      return def;
    }

  if (!allocate)
    return NULL;

  /* allocate a new def */
  def = (def_t *)kmalloc(sizeof(def_t));
  def->next = NULL;
  pr.def_tail->next = def;
  pr.def_tail = def;
  def->search_next = pr.search;
  pr.search = def;
  def->name = name;
  def->type = type;
  def->scope = scope;
  def->ofs = numpr_globals;
  pr_global_defs[numpr_globals] = def;

  /*
   * make automatic defs for the vectors elements
   * .origin can be accessed as .origin_x, .origin_y, and .origin_z
   */
  if (type->type == ev_vector) {
    element = kmalloc(__strlen(name) + 3);	/* TODO: check */
    sprintf(element, "%s_x", name);
    PR_GetDef(&type_float, element, scope, TRUE);

    element = kmalloc(__strlen(name) + 3);	/* TODO: check */
    sprintf(element, "%s_y", name);
    PR_GetDef(&type_float, element, scope, TRUE);

    element = kmalloc(__strlen(name) + 3);	/* TODO: check */
    sprintf(element, "%s_z", name);
    PR_GetDef(&type_float, element, scope, TRUE);
  }
  else
    numpr_globals += type_size[type->type];

  if (type->type == ev_field) {
    *(int *)&pr_globals[def->ofs] = pr.size_fields;

    if (type->aux_type->type == ev_vector) {
      element = kmalloc(__strlen(name) + 3);	/* TODO: check */
      sprintf(element, "%s_x", name);
      PR_GetDef(&type_floatfield, element, scope, TRUE);

      element = kmalloc(__strlen(name) + 3);	/* TODO: check */
      sprintf(element, "%s_y", name);
      PR_GetDef(&type_floatfield, element, scope, TRUE);

      element = kmalloc(__strlen(name) + 3);	/* TODO: check */
      sprintf(element, "%s_z", name);
      PR_GetDef(&type_floatfield, element, scope, TRUE);
    }
    else
      pr.size_fields += type_size[type->aux_type->type];
  }

/*if (pr_dumpasm) */
/*  PR_PrintOfs (def->ofs); */

  return def;
}
#else
staticfnc def_t *PR_GetDef(register type_t * type, register char *name, register def_t * scope, register bool allocate)
{
#undef cacheSize
#undef cacheMask
#define cacheSize  128
#define cacheMask  (cacheSize - 1)
  static def_t *cache[cacheSize];
  static int top = 0;
  def_t *def;
  char *element;

  /* See if name is in cache. */
  int sub = top;

  do {
    def = cache[sub];
    if (!def)
      break;
    if (!def->scope || def->scope == scope) {
      if (!__strcmp(def->name, name)) {
	if (type && def->type != type)
	  PR_ParseError("Type mismatch on redeclaration of %s", name);
	cache[sub] = cache[top];
	cache[top] = def;
	return def;
      }
    }
    sub = (sub - 1) & cacheMask;
  }
  while (sub != top);

  /* See if name is in main list. */
  for (def = pr.def_tail; def; def = def->prev) {
    if (!def->scope || def->scope == scope) {
      if (!__strcmp(def->name, name)) {
	if (type && def->type != type)
	  PR_ParseError("Type mismatch on redeclaration of %s", name);

	/* Put entry in cache. */
	top = (top + 1) & cacheMask;
	cache[top] = def;
	return def;
      }
    }
  }

  if (!allocate)
    return NULL;

  /* allocate a new def */
  def = (def_t *)kmalloc(sizeof(def_t));
  def->next = NULL;
  if (!pr.def_head) {
    def->prev = NULL;
    pr.def_head = pr.def_tail = def;
  }
  else {
    pr.def_tail->next = def;
    def->prev = pr.def_tail;
    pr.def_tail = def;
  }
  def->name = name;
  def->type = type;
  def->initialized = 0;
  def->scope = scope;
  def->ofs = numpr_globals;
  pr_global_defs[numpr_globals] = def;

  /* Put entry in cache. */
  top = (top + 1) & cacheMask;
  cache[top] = def;

  /*
   * make automatic defs for the vectors elements
   * .origin can be accessed as .origin_x, .origin_y, and .origin_z
   */
  if (type->type == ev_vector) {
    element = kmalloc(__strlen(name) + 3);	/* TODO: check */
    sprintf(element, "%s_x", name);
    PR_GetDef(&type_float, element, scope, TRUE);

    element = kmalloc(__strlen(name) + 3);	/* TODO: check */
    sprintf(element, "%s_y", name);
    PR_GetDef(&type_float, element, scope, TRUE);

    element = kmalloc(__strlen(name) + 3);	/* TODO: check */
    sprintf(element, "%s_z", name);
    PR_GetDef(&type_float, element, scope, TRUE);
  }
  else
    numpr_globals += type_size[type->type];

  if (type->type == ev_field) {
    *(int *)&pr_globals[def->ofs] = pr.size_fields;

    if (type->aux_type->type == ev_vector) {
      element = kmalloc(__strlen(name) + 3);	/* TODO: check */
      sprintf(element, "%s_x", name);
      PR_GetDef(&type_floatfield, element, scope, TRUE);

      element = kmalloc(__strlen(name) + 3);	/* TODO: check */
      sprintf(element, "%s_y", name);
      PR_GetDef(&type_floatfield, element, scope, TRUE);

      element = kmalloc(__strlen(name) + 3);	/* TODO: check */
      sprintf(element, "%s_z", name);
      PR_GetDef(&type_floatfield, element, scope, TRUE);
    }
    else
      pr.size_fields += type_size[type->aux_type->type];
  }

/*if (pr_dumpasm) */
/*  PR_PrintOfs (def->ofs); */

  return def;
}
#endif

/*
 * ============
 * PR_ParseValue
 * 
 * Returns the global ofs for the current token
 * ============
 */
staticfnc def_t *PR_ParseValue(void)
{
  def_t *d;
  char *name;

  /* if the token is an immediate, allocate a constant for it */
  if (pr_token_type == tt_immediate)
    return PR_ParseImmediate();

  /* look through the defs */
  name = PR_ParseName();
  d = PR_GetDef(NULL, name, pr_scope, FALSE);

  if (!d)
    PR_ParseError("Unknown value \"%s\"", name);

  return d;
}

/*
 * ============
 * PR_Term
 * ============
 */
staticfnc def_t *PR_Term(void)
{
  def_t *e, *e2;
  etype_t t;

  if (PR_CheckCharacter('!')) {
    e = PR_Expression(NOT_PRIORITY);
    t = e->type->type;
    if (t == ev_float)
      e2 = PR_Statement(&pr_opcodes[OP_NOT_F], e, 0);
    else if (t == ev_string)
      e2 = PR_Statement(&pr_opcodes[OP_NOT_S], e, 0);
    else if (t == ev_entity)
      e2 = PR_Statement(&pr_opcodes[OP_NOT_ENT], e, 0);
    else if (t == ev_vector)
      e2 = PR_Statement(&pr_opcodes[OP_NOT_V], e, 0);
    else if (t == ev_function)
      e2 = PR_Statement(&pr_opcodes[OP_NOT_FNC], e, 0);
    else {
      e2 = NULL;						/* shut up compiler warning; */

      PR_ParseError("type mismatch for !");
    }
    return e2;
  }

  if (PR_CheckCharacter('(')) {
    e = PR_Expression(TOP_PRIORITY);
    PR_ExpectCharacter(')');
    return e;
  }

  return PR_ParseValue();
}

/*
 * ==============
 * PR_Expression
 * ==============
 */
staticfnc def_t *PR_Expression(register int priority)
{
  opcode_t *op, *oldop;
  def_t *e, *e2;
  etype_t type_a, type_b, type_c;

  if (priority == 0)
    return PR_Term();

  e = PR_Expression(priority - 1);

  while (1) {
    if (priority == 1 && PR_CheckCharacter('('))
      return PR_ParseFunctionCall(e);

    for (op = pr_opcodes; op->name; op++) {
      if (op->priority != priority)
	continue;
      if (!PR_CheckString(op->name))
	continue;
      if (op->right_associative) {
	/* if last statement is an indirect, change it to an address of */
	if ((unsigned)(statements[numstatements - 1].op - OP_LOAD_F) < 6) {
	  statements[numstatements - 1].op = OP_ADDRESS;
	  def_pointer.type->aux_type = e->type;
	  e->type = def_pointer.type;
	}
	e2 = PR_Expression(priority);
      }
      else
	e2 = PR_Expression(priority - 1);

      /* type check */
      type_a = e->type->type;
      type_b = e2->type->type;

      if (op->name[0] == '.') {					/* field access gets type from field */
	if (e2->type->aux_type)
	  type_c = e2->type->aux_type->type;
	else
	  type_c = -1;						/* not a field */
      }
      else
	type_c = ev_void;

      oldop = op;
      while (type_a != op->type_a->type->type
	     || type_b != op->type_b->type->type
	     || (type_c != ev_void && type_c != op->type_c->type->type)) {
	op++;
	if (!op->name || __strcmp(op->name, oldop->name))
	  PR_ParseError("type mismatch for %s", oldop->name);
      }

      if (type_a == ev_pointer && type_b != e->type->aux_type->type)
	PR_ParseError("type mismatch for %s", op->name);

      if (op->right_associative)
	e = PR_Statement(op, e2, e);
      else
	e = PR_Statement(op, e, e2);

      if (type_c != ev_void)					/* field access gets type from field */
	e->type = e2->type->aux_type;

      break;
    }

    if (!op->name)
      break;							/* next token isn't at this priority level */
  }

  return e;
}

/*
 * ============
 * PR_ParseStatement
 * 
 * ============
 */
staticfnc void PR_ParseDefs(void);
staticfnc void PR_ParseStatement(void)
{
  def_t *e;
  dstatement_t *patch1, *patch2;

  if (PR_CheckCharacter('{')) {
    do {
      PR_ParseStatement();
    } while (!PR_CheckCharacter('}'));
    return;
  }

  if (PR_CheckString("return")) {
    if (PR_CheckCharacter(';')) {
      PR_Statement(&pr_opcodes[OP_RETURN], 0, 0);
      return;
    }
    e = PR_Expression(TOP_PRIORITY);
    PR_ExpectCharacter(';');
    PR_Statement(&pr_opcodes[OP_RETURN], e, 0);
    return;
  }

  if (PR_CheckString("while")) {
    PR_ExpectCharacter('(');
    patch2 = &statements[numstatements];
    e = PR_Expression(TOP_PRIORITY);
    PR_ExpectCharacter(')');
    patch1 = &statements[numstatements];
    PR_Statement(&pr_opcodes[OP_IFNOT], e, 0);
    PR_ParseStatement();
    junkdef.ofs = patch2 - &statements[numstatements];
    PR_Statement(&pr_opcodes[OP_GOTO], &junkdef, 0);
    patch1->b = &statements[numstatements] - patch1;
    return;
  }

  if (PR_CheckString("do")) {
    patch1 = &statements[numstatements];
    PR_ParseStatement();
    PR_ExpectString("while");
    PR_ExpectCharacter('(');
    e = PR_Expression(TOP_PRIORITY);
    PR_ExpectCharacter(')');
    PR_ExpectCharacter(';');
    junkdef.ofs = patch1 - &statements[numstatements];
    PR_Statement(&pr_opcodes[OP_IF], e, &junkdef);
    return;
  }

  if (PR_CheckString("local")) {
    PR_ParseDefs();
    locals_end = numpr_globals;
    return;
  }

  if (PR_CheckString("if")) {
    PR_ExpectCharacter('(');
    e = PR_Expression(TOP_PRIORITY);
    PR_ExpectCharacter(')');

    patch1 = &statements[numstatements];
    PR_Statement(&pr_opcodes[OP_IFNOT], e, 0);

    PR_ParseStatement();

    if (PR_CheckString("else")) {
      patch2 = &statements[numstatements];
      PR_Statement(&pr_opcodes[OP_GOTO], 0, 0);
      patch1->b = &statements[numstatements] - patch1;
      PR_ParseStatement();
      patch2->a = &statements[numstatements] - patch2;
    }
    else
      patch1->b = &statements[numstatements] - patch1;

    return;
  }

  PR_Expression(TOP_PRIORITY);
  PR_ExpectCharacter(';');
}

/*
 * ==============
 * PR_ParseState
 * 
 * States are special functions made for convenience.  They automatically
 * set frame, nextthink (implicitly), and think (allowing forward definitions).
 * 
 * // void() name = [framenum, nextthink] {code}
 * // expands to:
 * // function void name ()
 * // {
 * //           self.frame=framenum;
 * //           self.nextthink = time + 0.1;
 * //           self.think = nextthink
 * //           <code>
 * // };
 * ==============
 */
staticfnc void PR_ParseState(void)
{
  char *name;
  def_t *s1, *def;

  if (pr_token_type != tt_immediate || pr_immediate_type != &type_float)
    PR_ParseError("state frame must be a number");
  s1 = PR_ParseImmediate();

  PR_ExpectCharacter(',');

  name = PR_ParseName();
  def = PR_GetDef(&type_function, name, 0, TRUE);

  PR_ExpectCharacter(']');

  PR_Statement(&pr_opcodes[OP_STATE], s1, def);
}

/*
 * ============
 * PR_ParseImmediateStatements
 * 
 * Parse a function body
 * ============
 */
staticfnc function_t *PR_ParseImmediateStatements(register type_t * type)
{
  int i;
  function_t *f;
  def_t *defs[MAX_PARMS];

  f = (function_t *)kmalloc(sizeof(function_t));

  /*
   * check for builtin function definition #1, #2, etc
   */
  if (PR_CheckCharacter('#')) {
    if (pr_token_type != tt_immediate ||
	pr_immediate_type != &type_float ||
	pr_immediate._float != (int)pr_immediate._float)
      PR_ParseError("Bad builtin immediate");
    f->builtin = (int)pr_immediate._float;
    PR_Lex();
    return f;
  }

  f->builtin = 0;
  /*
   * define the parms
   */
  for (i = 0; i < type->num_parms; i++) {
    defs[i] = PR_GetDef(type->parm_types[i], skmalloc(pr_parm_names[i]), pr_scope, TRUE);
    f->parm_ofs[i] = defs[i]->ofs;
    if (i > 0 && f->parm_ofs[i] < f->parm_ofs[i - 1])
      PR_ParseError("bad parm order");
  }

  f->code = numstatements;

  /*
   * check for a state opcode
   */
  if (PR_CheckCharacter('['))
    PR_ParseState();

  /*
   * parse regular statements
   */
  PR_ExpectCharacter('{');

  while (!PR_CheckCharacter('}'))
    PR_ParseStatement();

  /* emit an end of statements opcode */
  PR_Statement(pr_opcodes, 0, 0);

  return f;
}

/*
 * ================
 * PR_ParseDefs
 * 
 * Called at the outer layer and when a local statement is hit
 * ================
 */
staticfnc void PR_ParseDefs(void)
{
  char *name;
  type_t *type;
  def_t *def;
  function_t *f;
  dfunction_t *df;
  int i;
  int locals_start;

  type = PR_ParseType();

  if (pr_scope && (type->type == ev_field || type->type == ev_function))
    PR_ParseError("Fields and functions must be global");

  do {
    name = PR_ParseName();
    def = PR_GetDef(type, name, pr_scope, TRUE);

    /* check for an initialization */
    if (PR_CheckCharacter('=')) {
      if (def->initialized)
	PR_ParseError("%s redeclared", name);

      if (type->type == ev_function) {
	locals_start = locals_end = numpr_globals;
	pr_scope = def;
	f = PR_ParseImmediateStatements(type);
	pr_scope = NULL;
	def->initialized = 1;
	G_FUNCTION(def->ofs) = numfunctions;
	f->def = def;

     /* if (pr_dumpasm) */
     /*   PR_PrintFunction (def); */

	/* fill in the dfunction */
	df = &functions[numfunctions];
	numfunctions++;
	if (f->builtin)
	  df->first_statement = -f->builtin;
	else
	  df->first_statement = f->code;
	df->s_name = CopyString(f->def->name);
	df->s_file = s_file;
	df->numparms = f->def->type->num_parms;
	df->locals = locals_end - locals_start;
	df->parm_start = locals_start;
	for (i = 0; i < df->numparms; i++)
	  df->parm_size[i] = type_size[f->def->type->parm_types[i]->type];

	continue;
      }
      else if (pr_immediate_type != type)
	PR_ParseError("wrong immediate type for %s", name);

      def->initialized = 1;
      memcpy(pr_globals + def->ofs, &pr_immediate, 4 * type_size[pr_immediate_type->type]);
      PR_Lex();
    }
  } while (PR_CheckCharacter(','));

  PR_ExpectCharacter(';');
}

/*
 * ============
 * PR_CompileFile
 * 
 * compiles the 0 terminated text, adding defintions to the pr structure
 * ============
 */
staticfnc bool PR_CompileFile(register char *string, register char *filename)
{
#if 0
  if (!pr.memory) {
    eprintf("PR_CompileFile: Didn't clear");
    return FALSE;
  }
#endif

  PR_ClearGrabMacros();						/* clear the frame macros */

  pr_file_p = string;
  s_file = CopyString(filename);

  pr_source_line = 0;

  PR_NewLine();
  PR_Lex();							/* read first token */

  while (pr_token_type != tt_eof) {
    if (setjmp(pr_parse_abort)) {
      if (++pr_error_count > MAX_ERRORS)
	return FALSE;
      PR_SkipToSemicolon();
      if (pr_token_type == tt_eof)
	return FALSE;
    }

    pr_scope = NULL;						/* outside all functions */

    PR_ParseDefs();
  }

  return (pr_error_count == 0);
}

/*
 * ===============
 * PR_String
 * 
 * Returns a string suitable for printing (no newlines, max 60 chars length)
 * ===============
 */
staticvar char PR_StringBuf[1024];
staticfnc char *PR_String(register char *string)
{
  char *s;

  s = PR_StringBuf;
  *s++ = '\"';
  if (string)
    while (*string) {
      if (*string == '\n') {
        *s++ = '\\';
        *s++ = 'n';
      }
      else if (*string == '\"') {
        *s++ = '\\';
        *s++ = '"';
      }
      else
        *s++ = *string;
      string++;
    }
  *s++ = '\"';
  *s++ = 0;

  return PR_StringBuf;
}

staticfnc def_t *PR_DefForFieldOfs(register gofs_t ofs)
{
  def_t *d;

  for (d = pr.def_head; d; d = d->next) {
    if (d->type->type != ev_field)
      continue;
    if (*((int *)&pr_globals[d->ofs]) == ofs)
      return d;
  }
  eprintf("PR_DefForFieldOfs: couldn't find %i", ofs);
  return NULL;
}

/*
 * ============
 * PR_ValueString
 * 
 * Returns a string describing *data in a type specific manner
 * =============
 */
staticfnc char *PR_ValueString(register etype_t type, register void *val)
{
  char *retline = PR_StringBuf;
  def_t *def;
  dfunction_t *f;

  switch (type) {
    case ev_string:
      retline = PR_String(strings + *(int *)val);
      break;
    case ev_entity:
      sprintf(retline, "entity %i", *(int *)val);
      break;
    case ev_function:
      f = functions + *(int *)val;
      if (!f)
	retline = "undefined function";
      else
	sprintf(retline, "%s()", strings + f->s_name);
      break;
    case ev_field:
      def = PR_DefForFieldOfs(*(int *)val);
      retline[0] = '.';
      __strcpy(retline + 1, def->name);
      break;
    case ev_void:
      retline = string_void;
      break;
    case ev_float:
      sprintf(retline, VEC_CONV1D, *(vec1D *)val);
      break;
    case ev_vector:
      sprintf(retline, "'" VEC_CONV3D "'", ((vec1D *)val)[0], ((vec1D *)val)[1], ((vec1D *)val)[2]);
      break;
    case ev_pointer:
      retline = "pointer";
      break;
    default:
      sprintf(retline, "bad type %i", type);
      break;
  }

  return retline;
}

/*
 * ============
 * PR_GlobalString
 * 
 * Returns a string with a description and the contents of a global,
 * padded to 20 field width
 * ============
 */
staticfnc char *PR_GlobalStringNoContents(register gofs_t ofs)
{
  int i;
  def_t *def;
/*void *val; */
  static char line[128];

/*val = (void *)&pr_globals[ofs]; */
  def = pr_global_defs[ofs];
  if (!def)
 /* Error("PR_GlobalString: no def for %i", ofs); */
    sprintf(line, placeh_intunk, ofs);
  else
    sprintf(line, placeh_intstr, ofs, def->name);

  i = __strlen(line);
  for (; i < 16; i++)
    line[i] = ' ';
  line[i++] = ' ';
  line[i] = '\0';

  return line;
}

staticfnc char *PR_GlobalString(register gofs_t ofs)
{
  char *s;
  int i;
  def_t *def;
/*void *val; */
  static char line[128];

/*val = (void *)&pr_globals[ofs]; */
  def = pr_global_defs[ofs];
  if (!def)
    return PR_GlobalStringNoContents(ofs);

  if (def->initialized && def->type->type != ev_function)
    s = PR_ValueString(def->type->type, &pr_globals[ofs]);
  else
    s = def->name;
  sprintf(line, placeh_intstr, ofs, s);

  i = __strlen(line);
  for (; i < 16; i++)
    line[i] = ' ';
  line[i++] = ' ';
  line[i] = '\0';

  return line;
}

/*
 * ============
 * PR_PrintOfs
 * ============
 */
staticfnc void PR_PrintOfs(register gofs_t ofs)
{
  mprintf("%s\n", PR_GlobalString(ofs));
}

/*
 * =================
 * PR_PrintStatement
 * =================
 */
staticfnc void PR_PrintStatement(register dstatement_t * s)
{
  int i;

  mprintf("%4i : %4i : %s ", (int)(s - statements), statement_linenums[s - statements], pr_opcodes[s->op].opname);
  i = __strlen(pr_opcodes[s->op].opname);
  for (; i < 10; i++)
    mprintf(" ");

  if (s->op == OP_IF || s->op == OP_IFNOT)
    mprintf("%sbranch %i", PR_GlobalString(s->a), s->b);
  else if (s->op == OP_GOTO) {
    mprintf("branch %i", s->a);
  }
  else if ((unsigned)(s->op - OP_STORE_F) < 6) {
    mprintf(placeh_string, PR_GlobalString(s->a));
    mprintf(placeh_string, PR_GlobalStringNoContents(s->b));
  }
  else {
    if (s->a)
      mprintf(placeh_string, PR_GlobalString(s->a));
    if (s->b)
      mprintf(placeh_string, PR_GlobalString(s->b));
    if (s->c)
      mprintf(placeh_string, PR_GlobalStringNoContents(s->c));
  }
  mprintf(string_return);
}

/*
 * ============
 * PR_PrintDefs
 * ============
 */
staticfnc void PR_PrintDefs(void)
{
  def_t *d;

  for (d = pr.def_head; d; d = d->next)
    PR_PrintOfs(d->ofs);
}

/*
 * ==============
 * PR_BeginCompilation
 * 
 * called before compiling a batch of files, clears the pr struct
 * ==============
 */
/* staticfnc void PR_BeginCompilation(register void *memory, register int memsize) */
staticfnc void PR_BeginCompilation(void)
{
  int i;

#if 0
  pr.memory = memory;
  pr.max_memory = memsize;
#endif

  numpr_globals = RESERVED_OFS;
  pr.def_tail = NULL;

  for (i = 0; i < RESERVED_OFS; i++)
    pr_global_defs[i] = &def_void;

  /* link the function type in so state forward declarations match proper type */
  pr.types = &type_function;
  type_function.next = NULL;
  pr_error_count = 0;
}

/*
 * ==============
 * PR_FinishCompilation
 * 
 * called after all files are compiled to check for errors
 * Returns FALSE if errors were detected.
 * ==============
 */
staticfnc bool PR_FinishCompilation(void)
{
  def_t *d;
  bool errors;

  errors = FALSE;

  /* check to make sure all functions prototyped have code */
  for (d = pr.def_head; d; d = d->next) {
    /* function parms are ok */
    if (d->type->type == ev_function && !d->scope) {
      /* f = G_FUNCTION(d->ofs); */
      /* if (!f || (!f->code && !f->builtin) ) */
      if (!d->initialized) {
	eprintf("function %s was not defined\n", d->name);
	errors = TRUE;
      }
    }
  }

  return !errors;
}

/*============================================================================= */

/*
 * ============
 * PR_WriteProgdefs
 * 
 * Writes the global and entity structures out
 * Returns a crc of the header, to be stored in the progs file for comparison
 * at load time.
 * ============
 */
staticfnc int PR_WriteProgdefs(register char *filename)
{
  def_t *d;
  FILE *f;
  unsigned short int crc;
  int c;

  mprintf("writing %s\n", filename);
  f = fopen(filename, "w");

  /* print global vars until the first field is defined */
  fprintf(f, "\n/* file generated by qcc, do not modify */\n\ntypedef struct\n{\tint\tpad[%i];\n", RESERVED_OFS);
  for (d = pr.def_head; d; d = d->next) {
    if (!__strcmp(d->name, "end_sys_globals"))
      break;

    switch (d->type->type) {
      case ev_float:
	fprintf(f, "\tfloat\t%s;\n", d->name);
	break;
      case ev_vector:
	fprintf(f, "\tvec3_t\t%s;\n", d->name);
	d = d->next->next->next;				/* skip the elements */

	break;
      case ev_string:
	fprintf(f, "\tstring_t\t%s;\n", d->name);
	break;
      case ev_function:
	fprintf(f, "\tfunc_t\t%s;\n", d->name);
	break;
      case ev_entity:
	fprintf(f, "\tint\t%s;\n", d->name);
	break;
      default:
	fprintf(f, "\tint\t%s;\n", d->name);
	break;
    }
  }
  fprintf(f, "} globalvars_t;\n\n");

  /* print all fields */
  fprintf(f, "typedef struct\n{\n");
  for (d = pr.def_head; d; d = d->next) {
    if (!__strcmp(d->name, "end_sys_fields"))
      break;

    if (d->type->type != ev_field)
      continue;

    switch (d->type->aux_type->type) {
      case ev_float:
	fprintf(f, "\tfloat\t%s;\n", d->name);
	break;
      case ev_vector:
	fprintf(f, "\tvec3_t\t%s;\n", d->name);
	d = d->next->next->next;				/* skip the elements */

	break;
      case ev_string:
	fprintf(f, "\tstring_t\t%s;\n", d->name);
	break;
      case ev_function:
	fprintf(f, "\tfunc_t\t%s;\n", d->name);
	break;
      case ev_entity:
	fprintf(f, "\tint\t%s;\n", d->name);
	break;
      default:
	fprintf(f, "\tint\t%s;\n", d->name);
	break;
    }
  }
  fprintf(f, "} entvars_t;\n\n");
  fclose(f);

  /* do a crc of the file */
  CRC_Init(&crc);
  f = fopen(filename, "r+");
  while ((c = fgetc(f)) != EOF)
    CRC_ProcessByte(&crc, (unsigned char)c);

  fprintf(f, "#define PROGHEADER_CRC %i\n", crc);
  fclose(f);

  return crc;
}

staticfnc void PrintFunction(register char *name)
{
  int i;
  dstatement_t *ds;
  dfunction_t *df;

  for (i = 0; i < numfunctions; i++)
    if (!__strcmp(name, strings + functions[i].s_name))
      break;
  if (i == numfunctions)
    eprintf("No function names \"%s\"", name);
  else {
    df = functions + i;

    mprintf("Statements for %s:\n", name);
    ds = statements + df->first_statement;
    while (1) {
      PR_PrintStatement(ds);
      if (!ds->op)
	break;
      ds++;
    }
  }
}

/*============================================================================ */

staticvar char com_token[1024];
staticvar bool com_eof;

/*
 * ==============
 * COM_Parse
 * 
 * Parse a token out of a string
 * ==============
 */
staticfnc char *COM_Parse(register char *data)
{
  int c;
  int len;

  len = 0;
  com_token[0] = 0;

  if (!data)
    return NULL;

  /* skip whitespace */
skipwhite:
  while ((c = *data) <= ' ') {
    if (c == 0) {
      com_eof = TRUE;
      return NULL;						/* end of file; */

    }
    data++;
  }

  /* skip // comments */
  if (c == '/' && data[1] == '/') {
    while (*data && *data != '\n')
      data++;
    goto skipwhite;
  }

  /* handle quoted strings specially */
  if (c == '\"') {
    data++;
    do {
      c = *data++;
      if (c == '\"') {
	com_token[len] = 0;
	return data;
      }
      com_token[len] = c;
      len++;
    } while (1);
  }

  /* parse single characters */
  if (c == '{' || c == '}' || c == ')' || c == '(' || c == '\'' || c == ':') {
    com_token[len] = c;
    len++;
    com_token[len] = 0;
    return data + 1;
  }

  /* parse a regular word */
  do {
    com_token[len] = c;
    data++;
    len++;
    c = *data;
    if (c == '{' || c == '}' || c == ')' || c == '(' || c == '\'' || c == ':')
      break;
  } while (c > 32);

  com_token[len] = 0;
  return data;
}

/*=========================================================================== */
/*unqcc */
/*=========================================================================== */

staticvar FILE *DEC_ofile;
staticvar FILE *DEC_progssrc;

#ifdef	QC_PROFILE
staticvar FILE *DEC_profile;
#endif

staticvar int DEC_FileCtr = 0;
staticvar char **DEC_Profiles;
staticvar char **DEC_FilesSeen;

staticvar char *type_names[8] =
{string_void, string_string, string_float, string_vector, string_entity, "ev_field", "void()", "ev_pointer"};

staticvar char *builtins[79] =
{
  NULL,
  "void(vector ang)",
  "void(entity e, vector o)",
  "void(entity e, string m)",
  "void(entity e, vector min, vector max)",
  NULL,
  "void()",
  "float()",
  "void(entity e, float chan, string samp, float vol, float atten)",
  "vector(vector v)",
  "void(string e)",
  "void(string e)",
  "float(vector v)",
  "float(vector v)",
  "entity()",
  "void(entity e)",
  "void(vector v1, vector v2, float nomonsters, entity forent)",
  "entity()",
  "entity(entity start, .string fld, string match)",
  "string(string s)",
  "string(string s)",
  "void(entity client, string s)",
  "entity(vector org, float rad)",
  "void(string s)",
  "void(entity client, string s)",
  "void(string s)",
  "string(float f)",
  "string(vector v)",
  "void()",
  "void()",
  "void()",
  "void(entity e)",
  "float(float yaw, float dist)",
  NULL,
  "float(float yaw, float dist)",
  "void(float style, string value)",
  "float(float v)",
  "float(float v)",
  "float(float v)",
  NULL,
  "float(entity e)",
  "float(vector v)",
  NULL,
  "float(float f)",
  "vector(entity e, float speed)",
  "float(string s)",
  "void(string s)",
  "entity(entity e)",
  "void(vector o, vector d, float color, float count)",
  "void()",
  NULL,
  "vector(vector v)",
  "void(float to, float f)",
  "void(float to, float f)",
  "void(float to, float f)",
  "void(float to, float f)",
  "void(float to, float f)",
  "void(float to, float f)",
  "void(float to, string s)",
  "void(float to, entity s)",
  NULL,
  NULL,
  NULL,
  NULL,
  NULL,
  NULL,
  NULL,
  "void(float step)",
  "string(string s)",
  "void(entity e)",
  "void(string s)",
  NULL,
  "void(string var, string val)",
  "void(entity client, string s)",
  "void(vector pos, string samp, float vol, float atten)",
  "string(string s)",
  "string(string s)",
  "string(string s)",
  "void(entity e)"
};

staticfnc int DEC_GetFunctionIdxByName(register char *name)
{
  int i;

  for (i = 1; i < numfunctions; i++)
    if (!__strcmp(name, strings + functions[i].s_name))
      break;
  return i;
}

staticfnc int DEC_AlreadySeen(register char *fname)
{
  int i;

  if (DEC_FileCtr > 1000)
    eprintf("DEC_AlreadySeen - too many source files.");
  else {
    for (i = 0; i < DEC_FileCtr; i++)
      if (!__strcmp(fname, DEC_FilesSeen[i]))
	return 1;

    DEC_FilesSeen[DEC_FileCtr] = skmalloc(fname);
    DEC_FileCtr++;

    mprintf("decompiling %s\n", fname);
  }
  return 0;
}

staticfnc ddef_t *DEC_GetParameter(register gofs_t ofs)
{
  int i;
  ddef_t *def;

  def = NULL;

  for (i = 0; i < numglobaldefs; i++) {
    def = &globals[i];

    if (def->ofs == ofs)
      return def;
  }

  return NULL;
}

#if 1
/*
 * fix: same as PR_ValueString
 */
staticfnc char *DEC_ValueString(register etype_t type, register void *val)
{
  char *retline = PR_StringBuf;

  switch (type) {
    case ev_string:
      retline = PR_String(strings + *(int *)val);
      break;
    case ev_void:
      retline = string_void;
      break;
    case ev_float:
      sprintf(retline, VEC_CONV1D, *(vec1D *)val);
      break;
    case ev_vector:
      sprintf(retline, "'" VEC_CONV3D "'", ((vec1D *)val)[0], ((vec1D *)val)[1], ((vec1D *)val)[2]);
      break;
    default:
      sprintf(retline, "bad type %i", type);
      break;
  }

  return retline;
}
#else
#define	DEC_ValueString	PR_ValueString
#endif

staticfnc char *DEC_PrintParameter(register ddef_t * def)
{
  char *retline = PR_StringBuf;

  /* retline[0] = '\0'; */
  if (!__strcmp(strings + def->s_name, string_immediate))
    retline = DEC_ValueString(def->type, &pr_globals[def->ofs]);
  else
    sprintf(retline, placeh_strsstr, type_names[def->type], strings + def->s_name);

  return retline;
}

staticfnc void DEC_CalcProfiles(void)
{
  int i, j, ps;
  static char fname[1024];
  char *new;
  dfunction_t *df;
  dstatement_t *ds, *rds;
  ddef_t *par;
  unsigned short dom;

  for (i = 1; i < numfunctions; i++) {
    df = functions + i;
    /* fname[0] = '\0'; */
    DEC_Profiles[i] = NULL;

    if (df->first_statement <= 0)
      sprintf(fname, placeh_strsstr, builtins[-df->first_statement], strings + functions[i].s_name);
    else {
      ds = statements + df->first_statement;
      rds = NULL;

      /* find a return statement, to determine the result type */

      while (1) {
	dom = (ds->op) % 100;
	if (!dom)
	  break;
	if (dom == OP_RETURN) {
	  rds = ds;
       /* break;  */
	}
	ds++;
      }

      /* print the return type  */
      if ((rds != NULL) && (rds->a != 0)) {
	par = DEC_GetParameter(rds->a);

	if (par)
	  __strcpy(fname, type_names[par->type]);
	else
	  sprintf(fname, "float/* ERROR: Could not determine return type */");
      }
      else
	__strcpy(fname, string_void);
      __strcat(fname, "(");

      /* determine overall parameter size */

      for (j = 0, ps = 0; j < df->numparms; j++)
	ps += df->parm_size[j];

      if (ps > 0) {
	for (j = df->parm_start; j < (df->parm_start) + ps; j++) {
	  par = DEC_GetParameter(j);

	  if (!par)
	    eprintf("DEC_CalcProfiles - No parameter names with offset %i.", j);
	  else {
	    if (par->type == ev_vector)
	      j += 2;

	    __strcat(fname, DEC_PrintParameter(par));
	    if (j < (df->parm_start) + ps - 1)
	      __strcat(fname, ", ");
	  }
	}
      }
      __strcat(fname, ") ");
      __strcat(fname, strings + functions[i].s_name);
    }

    if (i >= MAX_FUNCTIONS)
      eprintf("DEC_CalcProfiles - too many functions.");
    else
      DEC_Profiles[i] = skmalloc(fname);
  }
}

staticfnc char *DEC_Global(register gofs_t ofs, register def_t * req_t)
{
  int i;
  ddef_t *def;
  char found = 0;

  def = NULL;

  for (i = 0; i < numglobaldefs; i++) {
    def = &globals[i];
    if (def->ofs == ofs) {
      oprintf("DEC_Global - Found %i at %i.\n", ofs, (int)def);
      found = 1;
      break;
    }
  }

  if (found) {
    char *retline = PR_StringBuf;

    /* retline[0] = '\0'; */
    if (!__strcmp(strings + def->s_name, string_immediate))
      retline = DEC_ValueString(def->type, &pr_globals[def->ofs]);
    else {
      __strcpy(retline, strings + def->s_name);
      if (def->type == ev_vector && req_t == &def_float)
	__strcat(retline, "_x");
    }

    oprintf("DEC_Global - Found \"%s\"(%i) at %i.\n", retline, ofs, (int)def);
    return smalloc(retline);
  }

  return NULL;
}

staticfnc gofs_t DEC_ScaleIndex(register dfunction_t * df, register gofs_t ofs)
{
  gofs_t nofs = 0;

  if (ofs > RESERVED_OFS)
    nofs = ofs - df->parm_start + RESERVED_OFS;
  else
    nofs = ofs;

  return nofs;
}

#define MAX_NO_LOCAL_IMMEDIATES 1024

staticfnc char *DEC_Immediate(register dfunction_t * df, register gofs_t ofs, register int fun, register char *new)
{
  int i;
  gofs_t nofs;
  static char *IMMEDIATES[MAX_NO_LOCAL_IMMEDIATES];

  /*
   * free 'em all 
   */
  if (fun == 0) {
    oprintf("DEC_Immediate - Initializing function environment.\n");
    for (i = 0; i < MAX_NO_LOCAL_IMMEDIATES; i++)
      if (IMMEDIATES[i])
	tfree(IMMEDIATES[i]);
    __bzero(&IMMEDIATES, MAX_NO_LOCAL_IMMEDIATES * sizeof(char *));

    return NULL;
  }

  nofs = DEC_ScaleIndex(df, ofs);
  oprintf("DEC_Immediate - Index scale: %i -> %i.\n", ofs, nofs);

  /*
   * check consistency 
   */
  if ((nofs <= 0) || (nofs > MAX_NO_LOCAL_IMMEDIATES - 1))
    eprintf("DEC_Immediate - Index (%i) out of bounds.\n", nofs);
  else {
    /* insert at nofs */
    if (fun == 1) {
      if (IMMEDIATES[nofs])
	tfree(IMMEDIATES[nofs]);
      IMMEDIATES[nofs] = smalloc(new);
      oprintf("DEC_Immediate - Putting \"%s\" at index %i.\n", new, nofs);
    }
    /* get from nofs */
    else if (fun == 2) {
      if (IMMEDIATES[nofs]) {
	oprintf("DEC_Immediate - Reading \"%s\" at index %i.\n", IMMEDIATES[nofs], nofs);
	return smalloc(IMMEDIATES[nofs]);
      }
      else
	eprintf("DEC_Immediate - %i not defined.", nofs);
    }
  }

  return NULL;
}

staticfnc char *DEC_Get(register dfunction_t * df, register gofs_t ofs, register def_t * req_t)
{
  char *arg1;

  if (!(arg1 = DEC_Global(ofs, req_t)))
    arg1 = DEC_Immediate(df, ofs, 2, NULL);
/*if (arg1) */
/*  mprintf("DEC_Get - found \"%s\".\n",arg1); */

  return arg1;
}

staticfnc void DEC_Indent(register int c)
{
  if ((c <<= 1) > 0) {
    char indent[1024];
    int i;

    for (i = 0; i < c;) {
      indent[i++] = ' ';
      indent[i++] = ' ';
    }
    indent[i] = 0;

    fprintf(DEC_ofile, indent);
  }
}

staticfnc void DEC_DecompileStatement(register dfunction_t * df, register dstatement_t * s, register int *indent)
{
  static char line[1024];
  static char fnam[1024];
  char *arg1, *arg2, *arg3;
  int nargs, i, j;
  dstatement_t *t;
  unsigned short dom, doc, ifc, tom;
  def_t *typ1, *typ2, *typ3;

  dstatement_t *k;
  int dum;

  arg1 = arg2 = arg3 = NULL;

  line[0] = '\0';
  fnam[0] = '\0';

  dom = s->op;

  doc = dom / 10000;
  ifc = (dom % 10000) / 100;

  /*
   * use program flow information 
   */
  for (i = 0; i < ifc; i++) {
    (*indent)--;
    DEC_Indent(*indent);
    fprintf(DEC_ofile, string_braced);
  }
  for (i = 0; i < doc; i++) {
    DEC_Indent(*indent);
    fprintf(DEC_ofile, "do {\n");
    (*indent)++;
  }

  /*
   * remove all program flow information 
   */
  s->op %= 100;

  typ1 = pr_opcodes[s->op].type_a;
  typ2 = pr_opcodes[s->op].type_b;
  typ3 = pr_opcodes[s->op].type_c;

  /*
   * mprintf("DEC_DecompileStatement - decompiling %i (%i):\n",(int)(s - statements),dom);
   * DEC_PrintStatement (s);  
   */
  /* states are handled at top level */
  if (s->op == OP_DONE || s->op == OP_STATE) {
  }
  else if (s->op == OP_RETURN) {
    DEC_Indent(*indent);
    fprintf(DEC_ofile, "return");

    if (s->a) {
      arg1 = DEC_Get(df, s->a, typ1);
      fprintf(DEC_ofile, " (%s)", arg1);
    }

    fprintf(DEC_ofile, ";\n");
  }
  else if ((OP_MUL_F <= s->op && s->op <= OP_SUB_V) ||
	   (OP_EQ_F <= s->op && s->op <= OP_GT) ||
	   (OP_AND <= s->op && s->op <= OP_BITOR)) {
    arg1 = DEC_Get(df, s->a, typ1);
    arg2 = DEC_Get(df, s->b, typ2);
    arg3 = DEC_Global(s->c, typ3);

    if (arg3) {
      DEC_Indent(*indent);
      fprintf(DEC_ofile, "%s = %s %s %s;\n", arg3, arg1, pr_opcodes[s->op].name, arg2);
    }
    else {
      sprintf(line, "(%s %s %s)", arg1, pr_opcodes[s->op].name, arg2);
      DEC_Immediate(df, s->c, 1, line);
    }
  }
  else if (OP_LOAD_F <= s->op && s->op <= OP_ADDRESS) {
    arg1 = DEC_Get(df, s->a, typ1);
    arg2 = DEC_Get(df, s->b, typ2);
    arg3 = DEC_Global(s->c, typ3);

    if (arg3) {
      DEC_Indent(*indent);
      fprintf(DEC_ofile, "%s = %s.%s;\n", arg3, arg1, arg2);
    }
    else {
      sprintf(line, "%s.%s", arg1, arg2);
      DEC_Immediate(df, s->c, 1, line);
    }
  }
  else if (OP_STORE_F <= s->op && s->op <= OP_STORE_FNC) {
    arg1 = DEC_Get(df, s->a, typ1);
    arg3 = DEC_Global(s->b, typ2);

    if (arg3) {
      DEC_Indent(*indent);
      fprintf(DEC_ofile, "%s = %s;\n", arg3, arg1);
    }
    else
      DEC_Immediate(df, s->b, 1, arg1);
  }
  else if (OP_STOREP_F <= s->op && s->op <= OP_STOREP_FNC) {
    arg1 = DEC_Get(df, s->a, typ1);
    arg2 = DEC_Get(df, s->b, typ2);

    DEC_Indent(*indent);
    fprintf(DEC_ofile, "%s = %s;\n", arg2, arg1);
  }
  else if (OP_NOT_F <= s->op && s->op <= OP_NOT_FNC) {
    arg1 = DEC_Get(df, s->a, typ1);
    line[0] = '!';
    __strcpy(line + 1, arg1);
    DEC_Immediate(df, s->c, 1, line);
  }
  else if (OP_CALL0 <= s->op && s->op <= OP_CALL8) {
    nargs = s->op - OP_CALL0;
    arg1 = DEC_Get(df, s->a, NULL);
    sprintf(line, "%s(", arg1);
    __strcpy(fnam, arg1);

    for (i = 0; i < nargs; i++) {
      typ1 = NULL;
      j = 4 + 3 * i;

      if (arg1) {
	tfree(arg1);
	arg1 = 0;
      }

      arg1 = DEC_Get(df, j, typ1);
      __strcat(line, arg1);

#ifndef DONT_USE_DIRTY_TRICKS
      if (!__strcmp(fnam, "WriteCoord"))
	if (!__strcmp(arg1, "org") ||
	    !__strcmp(arg1, "trace_endpos") ||
	    !__strcmp(arg1, "p1") ||
	    !__strcmp(arg1, "p2") ||
	    !__strcmp(arg1, "o"))
	  __strcat(line, "_x");
#endif
      if (i < nargs - 1)
	__strcat(line, ", ");
    }
    __strcat(line, ")");
    DEC_Immediate(df, 1, 1, line);

    /*
     * if ( ( ( (s+1)->a != 1) && ( (s+1)->b != 1) && 
     *      ( (s+2)->a != 1) && ( (s+2)->b != 1) ) || 
     *      ( ((s+1)->op) % 100 == OP_CALL0 ) ) {
     *   DEC_Indent(*indent);
     *   fprintf(DEC_ofile,"%s;\n",line);
     * }
     */
    /* this SUCKS!!!!!!!!!!!!! */
    if ((((s + 1)->a != 1) && ((s + 1)->b != 1) &&
	 ((s + 2)->a != 1) && ((s + 2)->b != 1)) ||
	((((s + 1)->op) % 100 == OP_CALL0) && ((((s + 2)->a != 1)) || ((s + 2)->b != 1)))) {
      DEC_Indent(*indent);
      fprintf(DEC_ofile, "%s;\n", line);
    }
  }
  else if (s->op == OP_IF || s->op == OP_IFNOT) {
    arg1 = DEC_Get(df, s->a, NULL);
    arg2 = DEC_Global(s->a, NULL);

    if (s->op == OP_IFNOT) {
      if (s->b < 1) {
	eprintf("Found a negative IFNOT jump.");
	return;
      }

      /* get instruction right before the target */
      t = s + s->b - 1;
      tom = t->op % 100;

      if (tom != OP_GOTO) {
	/* pure if */
	DEC_Indent(*indent);
	fprintf(DEC_ofile, placeh_ifstr, arg1);
	(*indent)++;
      }
      else {
	if (t->a > 0) {
	  /* ite */
	  DEC_Indent(*indent);
	  fprintf(DEC_ofile, placeh_ifstr, arg1);
	  (*indent)++;
	}
	else {
	  if ((t->a + s->b) > 1) {
	    /* pure if  */
	    DEC_Indent(*indent);
	    fprintf(DEC_ofile, placeh_ifstr, arg1);
	    (*indent)++;
	  }
	  else {
	    dum = 1;
	    for (k = t + (t->a); k < s; k++) {
	      tom = k->op % 100;
	      if (tom == OP_GOTO || tom == OP_IF || tom == OP_IFNOT)
		dum = 0;
	    }
	    if (dum) {
	      /* while  */
	      DEC_Indent(*indent);
	      fprintf(DEC_ofile, "while (%s) {\n", arg1);
	      (*indent)++;
	    }
	    else {
	      /* pure if  */
	      DEC_Indent(*indent);
	      fprintf(DEC_ofile, placeh_ifstr, arg1);
	      (*indent)++;
	    }
	  }
	}
      }
    }
    else {
      /* do ... while */
      (*indent)--;
      DEC_Indent(*indent);
      fprintf(DEC_ofile, "} while (%s);\n", arg1);
    }
  }
  else if (s->op == OP_GOTO) {
    if (s->a > 0) {
      /* else */
      (*indent)--;
      DEC_Indent(*indent);
      fprintf(DEC_ofile, string_braced);
      DEC_Indent(*indent);
      fprintf(DEC_ofile, "else {\n");
      (*indent)++;
    }
    else {
      /* while */
      (*indent)--;
      DEC_Indent(*indent);
      fprintf(DEC_ofile, string_braced);
    }
  }
  else {
    fprintf(DEC_ofile, "\n/* ERROR: UNKNOWN COMMAND */\n");
  }

  oprintf("DEC_DecompileStatement - Current line is \"%s\"\n", line);
  if (arg1) {
    tfree(arg1);
    arg1 = 0;
  }
  if (arg2) {
    tfree(arg2);
    arg2 = 0;
  }
  if (arg3) {
    tfree(arg3);
    arg3 = 0;
  }

  return;
}

staticfnc void DEC_DecompileFunction(register dfunction_t * df)
{
  dstatement_t *ds;
  int indent;

  /* Initialize */
  DEC_Immediate(df, 0, 0, NULL);

  indent = 1;

  ds = statements + df->first_statement;
  while (1) {
    DEC_DecompileStatement(df, ds, &indent);
    if (!ds->op)
      break;
    ds++;
  }

  if (indent != 1)
    fprintf(DEC_ofile, "/* ERROR : Indentiation structure corrupt */\n");
}

staticfnc ddef_t *GetField(register char *name)
{
  int i;
  ddef_t *d;

  for (i = 1; i < numfielddefs; i++) {
    d = &fields[i];

    if (!__strcmp(strings + d->s_name, name))
      return d;
  }
  return NULL;
}

staticfnc void DEC_Function(register char *name)
{
  int i, findex, ps;
  dstatement_t *ds, *ts;
  dfunction_t *df;
  ddef_t *par;
  char *arg2;
  unsigned short dom, tom;

  int j, start, end;
  dfunction_t *dfpred;
  ddef_t *ef;

  dstatement_t *k;
  int dum;

  for (i = 1; i < numfunctions; i++)
    if (!__strcmp(name, strings + functions[i].s_name))
      break;
  if (i == numfunctions) {
    eprintf("No function named \"%s\"", name);
    return;
  }

  df = functions + i;

  findex = i;

  /* Check ''local globals'' */
  dfpred = df - 1;

  for (j = 0, ps = 0; j < dfpred->numparms; j++)
    ps += dfpred->parm_size[j];

  start = dfpred->parm_start + dfpred->locals + ps;

  if (dfpred->first_statement < 0 && df->first_statement > 0)
    start -= 1;

  if (start == 0)
    start = 1;

  end = df->parm_start;

  for (j = start; j < end; j++) {
    par = DEC_GetParameter(j);

    if (par) {
      if (par->type & (1 << 15))
	par->type -= (1 << 15);

      if (par->type == ev_function) {
	if (__strcmp(strings + par->s_name, string_immediate))
	  if (__strcmp(strings + par->s_name, name))
	    fprintf(DEC_ofile, "%s;\n", DEC_Profiles[DEC_GetFunctionIdxByName(strings + par->s_name)]);
      }
      else if (par->type != ev_pointer)
	if (__strcmp(strings + par->s_name, string_immediate)) {
	  if (par->type == ev_field) {
	    ef = GetField(strings + par->s_name);

	    if (!ef) {
	      eprintf("Could not locate a field named \"%s\"", strings + par->s_name);
	      return;
	    }

	    if (ef->type == ev_vector)
	      j += 3;
#ifndef DONT_USE_DIRTY_TRICKS
	    if ((ef->type == ev_function) && !__strcmp(strings + ef->s_name, "th_pain"))
	      fprintf(DEC_ofile, ".void(entity attacker, float damage) th_pain;\n");
	    else
#endif
	      fprintf(DEC_ofile, ".%s %s;\n", type_names[ef->type], strings + ef->s_name);
	  }
	  else {
	    if (par->type == ev_vector)
	      j += 2;
	    if (par->type == ev_entity || par->type == ev_void)
	      fprintf(DEC_ofile, "%s %s;\n", type_names[par->type], strings + par->s_name);
	    else {
	      char *retline;

	      /* retline[0] = '\0'; */
	      retline = DEC_ValueString(par->type, &pr_globals[par->ofs]);

	      if ((__strlen(strings + par->s_name) > 1) &&
		  isupper((strings + par->s_name)[0]) &&
		  (isupper((strings + par->s_name)[1]) || (strings + par->s_name)[1] == '_'))
		fprintf(DEC_ofile, "%s %s = %s;\n", type_names[par->type], strings + par->s_name, retline);
	      else
		fprintf(DEC_ofile, "%s %s /* = %s */;\n", type_names[par->type], strings + par->s_name, retline);
	    }
	  }
	}
    }
  }
  /* Check ''local globals'' */
  if (df->first_statement <= 0) {
    fprintf(DEC_ofile, placeh_string, DEC_Profiles[findex]);
    fprintf(DEC_ofile, " = #%i; \n", -df->first_statement);
    return;
  }

  ds = statements + df->first_statement;

  while (1) {
    dom = (ds->op) % 100;

    if (!dom)
      break;
    else if (dom == OP_GOTO) {
      /*
       * check for i-t-e 
       */
      if (ds->a > 0) {
	ts = ds + ds->a;
	/* mark the end of a if/ite construct */
	ts->op += 100;
      }
    }
    else if (dom == OP_IFNOT) {
      /*
       * check for pure if 
       */
      ts = ds + ds->b;
      tom = (ts - 1)->op % 100;

      if (tom != OP_GOTO)
	/* mark the end of a if/ite construct */
	ts->op += 100;
      else if ((ts - 1)->a < 0) {
	/*
	 * arg2 = DEC_Global(ds->a,NULL);
	 * 
	 * if (!( ( ((ts-1)->a + ds->b) == 0)   || 
	 * ( (arg2 != NULL) && (((ts-1)->a + ds->b) == 1) ))) 
	 * (ts-1)->op += 100;
	 * 
	 * if (arg2) {
	 *   tfree(arg2);
	 *   arg2 = 0;
	 * }
	 */
	if (((ts - 1)->a + ds->b) > 1) {
	  /* pure if  */
	  /* mark the end of a if/ite construct */
	  ts->op += 100;
	}
	else {
	  dum = 1;
	  for (k = (ts - 1) + ((ts - 1)->a); k < ds; k++) {
	    tom = k->op % 100;
	    if (tom == OP_GOTO || tom == OP_IF || tom == OP_IFNOT)
	      dum = 0;
	  }
	  if (!dum) {
	    /* pure if  */
	    /* mark the end of a if/ite construct */
	    ts->op += 100;
	  }
	}
      }
    }
    else if (dom == OP_IF) {
      ts = ds + ds->b;
      /* mark the start of a do construct */
      ts->op += 10000;
    }
    ds++;
  }

  /* print the prototype */
  fprintf(DEC_ofile, "\n%s", DEC_Profiles[findex]);

  /* handle state functions */
  ds = statements + df->first_statement;

  if (ds->op == OP_STATE) {
    par = DEC_GetParameter(ds->a);
    if (!par) {
      eprintf("DEC_Function - Can't determine frame number.");
      return;
    }

    arg2 = DEC_Get(df, ds->b, NULL);
    if (!arg2) {
      eprintf("DEC_Function - No state parameter with offset %i.", ds->b);
      return;
    }

    fprintf(DEC_ofile, " = [%s, %s] {\n", DEC_ValueString(par->type, &pr_globals[par->ofs]), arg2);
    tfree(arg2);
    arg2 = 0;
  }
  else
    fprintf(DEC_ofile, " = {\n");

#ifdef	QC_PROFILE
  fprintf(DEC_profile, placeh_string, DEC_Profiles[findex]);
  fprintf(DEC_profile, ") %s;\n", name);
#endif

  /* calculate the parameter size */
  for (j = 0, ps = 0; j < df->numparms; j++)
    ps += df->parm_size[j];

  /* print the locals */
  if (df->locals > 0) {
    if ((df->parm_start) + df->locals - 1 >= (df->parm_start) + ps) {
      for (i = df->parm_start + ps; i < (df->parm_start) + df->locals; i++) {
	par = DEC_GetParameter(i);

	if (!par)
	  fprintf(DEC_ofile, "  /* ERROR: No local name with offset %i */\n", i);
	else {
	  if (par->type == ev_function)
	    fprintf(DEC_ofile, "  /* ERROR: Fields and functions must be global */\n");
	  else
	    fprintf(DEC_ofile, "  local %s;\n", DEC_PrintParameter(par));

	  if (par->type == ev_vector)
	    i += 2;
	}
      }

      fprintf(DEC_ofile, string_return);
    }
  }

  /* do the hard work */
  DEC_DecompileFunction(df);
  fprintf(DEC_ofile, "};\n");
}

staticfnc bool DEC_DecompileFunctions(register char *destDir)
{
  int i;
  dfunction_t *d;
  FILE *f;
  char fname[512];

  DEC_CalcProfiles();

  /* fname[0] = '\0'; */
  sprintf(fname, placeh_strstr, destDir, "progs.src");
  DEC_progssrc = fopen(fname, "w");
  if (!DEC_progssrc) {
    eprintf("DEC_DecompileFunctions - Could not open \"progs.src\" for output.");
    return FALSE;
  }

  fprintf(DEC_progssrc, "./progs.dat\n\n");

#ifdef	QC_PROFILE
  DEC_profile = fopen("!profile.qc", "w");
  if (!DEC_profile)
    Error("DEC_DecompileFunctions - Could not open \"!profile.qc\" for output.");
  fprintf(DEC_progssrc, "!profile.qc\n");
#endif

  for (i = 1; i < numfunctions; i++) {
    d = &functions[i];

    /* fname[0] = '\0'; */
    sprintf(fname, placeh_strstr, destDir, strings + d->s_file);
    f = fopen(fname, "a+");

    if (!DEC_AlreadySeen(fname))
      fprintf(DEC_progssrc, "%s\n", fname);

    if (!f) {
      eprintf("DEC_DecompileFunctions - Could not open \"%s\" for output.", fname);
      return FALSE;
    }
    DEC_ofile = f;
    DEC_Function(strings + d->s_name);

    if (fclose(f)) {
      eprintf("DEC_DecompileFunctions - Could not close \"%s\" properly.", fname);
      return FALSE;
    }
  }

  if (fclose(DEC_progssrc)) {
    eprintf("DEC_DecompileFunctions - Could not close \"progs.src\" properly.");
    return FALSE;
  }

#ifdef	QC_PROFILE
  if (fclose(DEC_profile))
    Error("DEC_DecompileFunctions - Could not close \"!profile.qc\" properly.");
#endif

  return TRUE;
}

staticfnc char *DEC_GlobalStringNoContents(register gofs_t ofs)
{
  int i;
  static char line[1024];

  /* line[0] = '\0'; */
  sprintf(line, placeh_intunk, ofs);

  for (i = 0; i < numglobaldefs; i++) {
    ddef_t *def;

    def = &globals[i];

    if (def->ofs == ofs) {
      /* line[0] = '\0'; */
      sprintf(line, placeh_intstr, def->ofs, strings + def->s_name);
      break;
    }
  }

  i = __strlen(line);
  for (; i < 16; i++)
    line[i] = ' ';
  line[i++] = ' ';
  line[i] = '\0';

  return line;
}

staticfnc char *DEC_GlobalString(register gofs_t ofs)
{
  int i;
  static char line[1024];

  /* line[0] = '\0'; */
  sprintf(line, placeh_intunk, ofs);

  for (i = 0; i < numglobaldefs; i++) {
    char *s;
    ddef_t *def;

    def = &globals[i];

    if (def->ofs == ofs) {
      /* line[0] = '\0'; */
      if (!__strcmp(strings + def->s_name, string_immediate))
	s = PR_ValueString(def->type, &pr_globals[ofs]);
      else
        s = strings + def->s_name;

      sprintf(line, placeh_intstr, def->ofs, s);
      break;	/* FIXED???, added 'cause otherwise it looks like absolute bogus */
    }
  }

  i = __strlen(line);
  for (; i < 16; i++)
    line[i] = ' ';
  line[i++] = ' ';
  line[i] = '\0';

  return line;
}

/*
 * fix: same as PR_PrintStatement
 *  mprintf("%4i : %4i : %s ", (int)(s - statements), statement_linenums[s - statements], pr_opcodes[s->op].opname);
 */
staticfnc void DEC_PrintStatement(register dstatement_t * s)
{
  int i;

  mprintf("%4i : %s ", (int)(s - statements), pr_opcodes[s->op].opname);
  i = __strlen(pr_opcodes[s->op].opname);
  for (; i < 10; i++)
    mprintf(" ");

  if (s->op == OP_IF || s->op == OP_IFNOT)
    mprintf("%sbranch %i", DEC_GlobalString(s->a), s->b);
  else if (s->op == OP_GOTO) {
    mprintf("branch %i", s->a);
  }
  else if ((unsigned)(s->op - OP_STORE_F) < 6) {
    mprintf(placeh_string, DEC_GlobalString(s->a));
    mprintf(placeh_string, DEC_GlobalStringNoContents(s->b));
  }
  else {
    if (s->a)
      mprintf(placeh_string, DEC_GlobalString(s->a));
    if (s->b)
      mprintf(placeh_string, DEC_GlobalString(s->b));
    if (s->c)
      mprintf(placeh_string, DEC_GlobalStringNoContents(s->c));
  }
  mprintf(string_return);
}

/*
 * fix: same as PrintFunction
 */
staticfnc void DEC_PrintFunction(register char *name)
{
  int i;
  dstatement_t *ds;
  dfunction_t *df;

  for (i = 0; i < numfunctions; i++)
    if (!__strcmp(name, strings + functions[i].s_name))
      break;
  if (i == numfunctions)
    eprintf("No function names \"%s\"", name);
  else {
    df = functions + i;

    mprintf("Statements for %s:\n", name);
    ds = statements + df->first_statement;
    while (1) {
      DEC_PrintStatement(ds);

      if (!ds->op)
	break;

      ds++;
    }
  }
}

/*=========================================================================== */
/*interface */
/*=========================================================================== */

staticfnc bool ExitData(bool decode)
{
  int i;

  if (!decode) {
 /* if (pr_parm_names) */
      for (i = 0; i < MAX_PARMS; i++)
        if (pr_parm_names[i])
          tfree(pr_parm_names[i]);
    if (precache_sounds)
      for (i = 0; i < numsounds; i++)
        if (precache_sounds[i].sound)
          tfree(precache_sounds[i].sound);
    if (precache_models)
      for (i = 0; i < nummodels; i++)
        if (precache_models[i].model)
          tfree(precache_models[i].model);
    if (precache_files)
      for (i = 0; i < numfiles; i++)
        if (precache_files[i].file)
          tfree(precache_files[i].file);
  }

  kfree();

  return FALSE;
}

staticfnc bool InitData(bool decode)
{
  int i;

  __bzero(pr_parm_names, sizeof(pr_parm_names));

  if (!(pr_globals = (vec1D *)kmalloc(MAX_REGS * sizeof(float))))
    return ExitData(decode);
  if (!(pr_global_defs = (def_t **)kmalloc(MAX_REGS * sizeof(def_t *))))
    return ExitData(decode);

  if (!decode) {
    if (!(precache_sounds = kmalloc(sizeof(precache_sounds[0]))))
      return ExitData(decode);
    numsounds = 0;
    if (!(precache_models = kmalloc(sizeof(precache_models[0]))))
      return ExitData(decode);
    nummodels = 0;
    if (!(precache_files = kmalloc(sizeof(precache_files[0]))))
      return ExitData(decode);
    numfiles = 0;

    if (!(strings = (char *)kmalloc(MAX_STRINGS * sizeof(char))))
      return ExitData(decode);
    strofs = 1;

    if (!(statements = (dstatement_t *)kmalloc(MAX_STATEMENTS * sizeof(dstatement_t))))
      return ExitData(decode);
    if (!(statement_linenums = (int *)kmalloc(MAX_STATEMENTS * sizeof(int))))
      return ExitData(decode);
    numstatements = 1;

    if (!(functions = (dfunction_t *)kmalloc(MAX_FUNCTIONS * sizeof(dfunction_t))))
      return ExitData(decode);
    numfunctions = 1;

    if (!(globals = (ddef_t *)kmalloc(MAX_GLOBALS * sizeof(ddef_t))))
      return ExitData(decode);
    numglobaldefs = 1;

    if (!(fields = (ddef_t *)kmalloc(MAX_FIELDS * sizeof(ddef_t))))
      return ExitData(decode);
    numfielddefs = 1;

    def_ret.ofs = OFS_RETURN;
    for (i = 0; i < MAX_PARMS; i++)
      def_parms[i].ofs = OFS_PARM0 + 3 * i;
  }
  else {
    if (!(DEC_Profiles = (char **)kmalloc(MAX_FUNCTIONS * sizeof(char *))))
      return ExitData(decode);
    if (!(DEC_FilesSeen = (char **)kmalloc(MAX_FUNCTIONS * sizeof(char *))))
      return ExitData(decode);
  }

  return TRUE;
}

staticfnc void WriteData(register int crc)
{
  def_t *def;
  ddef_t *dd;
  dprograms_t progs;
  HANDLE h;
  int i;

  for (def = pr.def_head; def; def = def->next) {
    if (def->type->type == ev_function) {
      /*
       * df = &functions[numfunctions];
       * numfunctions++;
       */
    }
    else if (def->type->type == ev_field) {
      dd = &fields[numfielddefs];
      numfielddefs++;
      dd->type = def->type->aux_type->type;
      dd->s_name = CopyString(def->name);
      dd->ofs = G_INT(def->ofs);
    }
    dd = &globals[numglobaldefs];
    numglobaldefs++;
    dd->type = def->type->type;
    if (!def->initialized
	&& def->type->type != ev_function
	&& def->type->type != ev_field
	&& def->scope == NULL)
      dd->type |= DEF_SAVEGLOBGAL;
    dd->s_name = CopyString(def->name);
    dd->ofs = def->ofs;
  }

  /*
   * PrintStrings ();
   * PrintFunctions ();
   * PrintFields ();
   * PrintGlobals ();
   */
  strofs = (strofs + 3) & ~3;

  mprintf("%6i strofs\n", strofs);
  mprintf("%6i numstatements\n", numstatements);
  mprintf("%6i numfunctions\n", numfunctions);
  mprintf("%6i numglobaldefs\n", numglobaldefs);
  mprintf("%6i numfielddefs\n", numfielddefs);
  mprintf("%6i numpr_globals\n", numpr_globals);

  if ((h = __open(destfile, H_READWRITE_BINARY_OLD)) > 0) {
    __write(h, &progs, sizeof(progs));

    progs.ofs_strings = __ltell(h);
    progs.numstrings = strofs;
    __write(h, strings, strofs);

    progs.ofs_statements = __ltell(h);
    progs.numstatements = numstatements;
    for (i = 0; i < numstatements; i++) {
      statements[i].op = LittleShort(statements[i].op);
      statements[i].a = LittleShort(statements[i].a);
      statements[i].b = LittleShort(statements[i].b);
      statements[i].c = LittleShort(statements[i].c);
    }
    __write(h, statements, numstatements * sizeof(dstatement_t));

    progs.ofs_functions = __ltell(h);
    progs.numfunctions = numfunctions;
    for (i = 0; i < numfunctions; i++) {
      functions[i].first_statement = LittleLong(functions[i].first_statement);
      functions[i].parm_start = LittleLong(functions[i].parm_start);
      functions[i].s_name = LittleLong(functions[i].s_name);
      functions[i].s_file = LittleLong(functions[i].s_file);
      functions[i].numparms = LittleLong(functions[i].numparms);
      functions[i].locals = LittleLong(functions[i].locals);
    }
    __write(h, functions, numfunctions * sizeof(dfunction_t));

    progs.ofs_globaldefs = __ltell(h);
    progs.numglobaldefs = numglobaldefs;
    for (i = 0; i < numglobaldefs; i++) {
      globals[i].type = LittleShort(globals[i].type);
      globals[i].ofs = LittleShort(globals[i].ofs);
      globals[i].s_name = LittleLong(globals[i].s_name);
    }
    __write(h, globals, numglobaldefs * sizeof(ddef_t));

    progs.ofs_fielddefs = __ltell(h);
    progs.numfielddefs = numfielddefs;
    for (i = 0; i < numfielddefs; i++) {
      fields[i].type = LittleShort(fields[i].type);
      fields[i].ofs = LittleShort(fields[i].ofs);
      fields[i].s_name = LittleLong(fields[i].s_name);
    }
    __write(h, fields, numfielddefs * sizeof(ddef_t));

    progs.ofs_globals = __ltell(h);
    progs.numglobals = numpr_globals;
    for (i = 0; i < numpr_globals; i++)
      ((int *)pr_globals)[i] = LittleLong(((int *)pr_globals)[i]);
    __write(h, pr_globals, numpr_globals * 4);

    mprintf("%6i TOTAL SIZE\n", (int)__ltell(h));

    progs.entityfields = pr.size_fields;
    progs.version = PROG_VERSION;
    progs.crc = crc;

    /* unsigned char swap the header and write it out */
    for (i = 0; i < sizeof(progs) / 4; i++)
      ((int *)&progs)[i] = LittleLong(((int *)&progs)[i]);
    __lseek(h, 0, SEEK_SET);
    __write(h, &progs, sizeof(progs));

    __close(h);
  }
}

staticfnc bool ReadData(register HANDLE srcFile)
{
  dprograms_t progs;
  int i;
  bool retval = FALSE;

  while (1) {
    if (__read(srcFile, &progs, sizeof(progs)) != sizeof(progs))
      break;

    __lseek(srcFile, LittleLong(progs.ofs_strings), SEEK_SET);
    strofs = LittleLong(progs.numstrings);
    if (!(strings = (char *)kmalloc(strofs)))
      break;
    if (__read(srcFile, strings, strofs) != strofs)
      break;

    __lseek(srcFile, LittleLong(progs.ofs_statements), SEEK_SET);
    numstatements = LittleLong(progs.numstatements);
    if (!(statements = (dstatement_t *)kmalloc(numstatements * sizeof(dstatement_t))))
      break;
    if (!(statement_linenums = (int *)kmalloc(numstatements * sizeof(int))))
        break;

    if (__read(srcFile, statements, numstatements * sizeof(dstatement_t)) != (numstatements * sizeof(dstatement_t)))
      break;
    for (i = 0; i < numstatements; i++) {
      statements[i].op = LittleShort(statements[i].op);
      statements[i].a = LittleShort(statements[i].a);
      statements[i].b = LittleShort(statements[i].b);
      statements[i].c = LittleShort(statements[i].c);
    }

    __lseek(srcFile, LittleLong(progs.ofs_functions), SEEK_SET);
    numfunctions = LittleLong(progs.numfunctions);
    if (!(functions = (dfunction_t *)kmalloc(numfunctions * sizeof(dfunction_t))))
      break;
    if (__read(srcFile, functions, numfunctions * sizeof(dfunction_t)) != (numfunctions * sizeof(dfunction_t)))
      break;
    for (i = 0; i < numfunctions; i++) {
      functions[i].first_statement = LittleLong(functions[i].first_statement);
      functions[i].parm_start = LittleLong(functions[i].parm_start);
      functions[i].locals = LittleLong(functions[i].locals);
      functions[i].s_name = LittleLong(functions[i].s_name);
      functions[i].s_file = LittleLong(functions[i].s_file);
      functions[i].numparms = LittleLong(functions[i].numparms);
    }

    __lseek(srcFile, LittleLong(progs.ofs_globaldefs), SEEK_SET);
    numglobaldefs = LittleLong(progs.numglobaldefs);
    if (!(globals = (ddef_t *)kmalloc(numglobaldefs * sizeof(ddef_t))))
      break;
    if (__read(srcFile, globals, numglobaldefs * sizeof(ddef_t)) != (numglobaldefs * sizeof(ddef_t)))
      break;
    for (i = 0; i < numglobaldefs; i++) {
      globals[i].type = LittleShort(globals[i].type);
      globals[i].ofs = LittleShort(globals[i].ofs);
      globals[i].s_name = LittleLong(globals[i].s_name);
    }

    __lseek(srcFile, LittleLong(progs.ofs_fielddefs), SEEK_SET);
    numfielddefs = LittleLong(progs.numfielddefs);
    if (!(fields = (ddef_t *)kmalloc(numfielddefs * sizeof(ddef_t))))
      break;
    if (__read(srcFile, fields, numfielddefs * sizeof(ddef_t)) != (numfielddefs * sizeof(ddef_t)))
      break;
    for (i = 0; i < numfielddefs; i++) {
      fields[i].type = LittleShort(fields[i].type);
      fields[i].ofs = LittleShort(fields[i].ofs);
      fields[i].s_name = LittleLong(fields[i].s_name);
    }

    __lseek(srcFile, LittleLong(progs.ofs_globals), SEEK_SET);
    numpr_globals = LittleLong(progs.numglobals);
    if (!(pr_globals = (vec1D *)kmalloc(numpr_globals * sizeof(float))))
        break;

    if (__read(srcFile, pr_globals, numpr_globals * 4) != (numpr_globals * 4))
      break;
    for (i = 0; i < numpr_globals; i++)
      ((int *)pr_globals)[i] = LittleLong(((int *)pr_globals)[i]);

    printf("total size is %6i\n", (int)__ltell(srcFile));
    printf("version code is %i\n", LittleLong(progs.version));
    printf("crc is %i\n", LittleLong(progs.crc));
    printf("%6i strofs\n", strofs);
    printf("%6i numstatements\n", numstatements);
    printf("%6i numfunctions\n", numfunctions);
    printf("%6i numglobaldefs\n", numglobaldefs);
    printf("%6i numfielddefs\n", numfielddefs);
    printf("%6i numpr_globals\n", numpr_globals);
    printf("--------------------------\n");
    retval = TRUE;
    break;
  }

  return retval;
}

staticfnc bool ShowData(register HANDLE srcFile)
{
  dprograms_t progs;

  if (__read(srcFile, &progs, sizeof(progs)) == sizeof(progs)) {
    strofs = LittleLong(progs.numstrings);
    numstatements = LittleLong(progs.numstatements);
    numfunctions = LittleLong(progs.numfunctions);
    numglobaldefs = LittleLong(progs.numglobaldefs);
    numfielddefs = LittleLong(progs.numfielddefs);
    numpr_globals = LittleLong(progs.numglobals);

    __lseek(srcFile, 0, SEEK_END);
    printf("total size is %6i\n", (int)__ltell(srcFile));
    printf("version code is %i\n", LittleLong(progs.version));
    printf("crc is %i\n", LittleLong(progs.crc));
    printf("%6i strofs\n", strofs);
    printf("%6i numstatements\n", numstatements);
    printf("%6i numfunctions\n", numfunctions);
    printf("%6i numglobaldefs\n", numglobaldefs);
    printf("%6i numfielddefs\n", numfielddefs);
    printf("%6i numpr_globals\n", numpr_globals);
    printf("--------------------------\n");
    return TRUE;
  }
  else
    return FALSE;
}

/*=========================================================================== */

bool qcc(FILE * srcFile, char *srcDir, operation procOper)
{
  char *srcData, *srcFree = 0;
  char *srcPart;
  char fileName[1024];
/*void *freeIt = 0; */
  bool failure = FALSE;

  if (InitData(FALSE)) {
    switch (procOper) {
      case OP_ADD:
	__strcpy(sourcedir, srcDir);
	if (!(srcData = srcFree = (char *)GetVoidF(fileno(srcFile))))
	  break;

	if (!(srcData = COM_Parse(srcData))) {
	  eprintf("No destination fileName.\n");
	  tfree(srcFree);
	  srcFree = 0;
	  break;
	}

	__strcpy(destfile, com_token);
	mprintf("outputfile: %s\n", destfile);

	pr_dumpasm = FALSE;
	/*PR_BeginCompilation(freeIt = (void *)kmalloc(0x100000), 0x100000); */
	PR_BeginCompilation();

	/* compile all the files */
	do {
	  if (!(srcData = COM_Parse(srcData)))
	    break;

	  sprintf(fileName, placeh_strstr, sourcedir, com_token);
	  mprintf("compiling %s\n", fileName);
	  if (!(srcPart = (char *)GetPreProcessed(fileName))) {
	    eprintf(failed_fileopen, fileName);
	    failure = TRUE;
	    break;
	  }

	  if (!PR_CompileFile(srcPart, fileName)) {
	    eprintf("cannot compile %s\n", fileName);
	    tfree(srcPart);
	    srcPart = 0;
	    failure = TRUE;
	    break;
	  }
	  else {
	    tfree(srcPart);
	    srcPart = 0;
	  }
	} while (1);

	if (!failure) {
	  if (PR_FinishCompilation()) {
	    /* write progdefs.h */
	    sprintf(fileName, placeh_strstr, sourcedir, "progdefs.h");
	    /* write data file */
	    WriteData(PR_WriteProgdefs(fileName));
	    /* write files.dat */
	    WriteFiles();
	  }
	  else
	    eprintf("can't finish compilation\n");
	}
	else
	  eprintf("compilation errors\n");

	tfree(srcFree);
	srcFree = 0;
	break;
      default:
	break;
    }
    ExitData(FALSE);
    return TRUE;
  }
  else
    return FALSE;
}

bool unqcc(HANDLE srcFile, char *destDir, operation procOper)
{
  bool retval = FALSE;

  if (InitData(TRUE)) {
    switch (procOper) {
      case OP_EXTRACT:
        if (ReadData(srcFile)) {
	  CreatePath(destDir);
	  retval = DEC_DecompileFunctions(destDir);
        }
        else
	  eprintf("can't read %s\n", srcFile);
        break;
      case OP_LIST:
      default:
       retval = ShowData(srcFile);
       break;
    }

    ExitData(TRUE);
    return retval;
  }
  else
    return FALSE;
}
