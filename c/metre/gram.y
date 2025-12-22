/*************************************************************
   Copyright (c) 1993,1994 by Paul Long  All rights reserved.
**************************************************************/

/*************************************************************
   gram.y - This source file contains the YACC grammar and
            actions for Metre's Standard C parser.  It also
            contains main(), error-handling functions,
            trigger-firing functions, functions that
            maintain the typedef symbol table, functions
            that administer the execution of Metre,
            functions that can be called from the rules()
            function, and a replacement for YACC's
            yyerror().  As you can see, most of the grammar
            rules have no actions.  This is because the
            grammar is largely used to just skip over the
            parts of C that Metre doesn't care about.
**************************************************************/


%token TK_IDENTIFIER TK_CONSTANT TK_STRING_LITERAL TK_SIZEOF
%token TK_PTR_OP TK_INC_OP TK_DEC_OP TK_LEFT_OP TK_RIGHT_OP
%token TK_LE_OP TK_GE_OP TK_EQ_OP TK_NE_OP
%token TK_AND_OP TK_OR_OP TK_MUL_ASSIGN TK_DIV_ASSIGN TK_MOD_ASSIGN
%token TK_ADD_ASSIGN TK_SUB_ASSIGN TK_LEFT_ASSIGN TK_RIGHT_ASSIGN TK_AND_ASSIGN
%token TK_XOR_ASSIGN TK_OR_ASSIGN TK_TYPE_NAME

%token TK_TYPEDEF TK_EXTERN TK_STATIC TK_AUTO TK_REGISTER
%token TK_CHAR TK_SHORT TK_INT TK_LONG TK_SIGNED TK_UNSIGNED
%token TK_FLOAT TK_DOUBLE TK_CONST TK_VOLATILE TK_VOID
%token TK_STRUCT TK_UNION TK_ENUM TK_ELIPSIS TK_RANGE

%token TK_CASE TK_DEFAULT TK_IF TK_ELSE TK_SWITCH TK_WHILE TK_DO TK_FOR
%token TK_GOTO TK_CONTINUE TK_BREAK TK_RETURN

%start translation_unit

/* Used to disambiguate if from if/else. */
%nonassoc THEN
%nonassoc TK_ELSE

%%

primary_expr
   : identifier
   | TK_CONSTANT
   | string_list
   | '(' expr ')'
   ;

string_list
   : TK_STRING_LITERAL
   | string_list TK_STRING_LITERAL
   ;

postfix_expr
   : primary_expr
   | postfix_expr '[' expr ']'
   | postfix_expr '(' ')'
   | postfix_expr '(' argument_expr_list ')'
   | postfix_expr '.' identifier
   | postfix_expr TK_PTR_OP identifier
   | postfix_expr TK_INC_OP
   | postfix_expr TK_DEC_OP
   ;

argument_expr_list
   : assignment_expr
   | argument_expr_list ',' assignment_expr
   ;

unary_expr
   : postfix_expr
   | TK_INC_OP unary_expr
   | TK_DEC_OP unary_expr
   | unary_operator cast_expr
   | TK_SIZEOF unary_expr
   | TK_SIZEOF '(' type_name ')'
   ;

unary_operator
   : '&'
   | '*'
   | '+'
   | '-'
   | '~'
   | '!'
   ;

cast_expr
   : unary_expr
   | '(' type_name ')' cast_expr
   ;

multiplicative_expr
   : cast_expr
   | multiplicative_expr '*' cast_expr
   | multiplicative_expr '/' cast_expr
   | multiplicative_expr '%' cast_expr
   ;

additive_expr
   : multiplicative_expr
   | additive_expr '+' multiplicative_expr
   | additive_expr '-' multiplicative_expr
   ;

shift_expr
   : additive_expr
   | shift_expr TK_LEFT_OP additive_expr
   | shift_expr TK_RIGHT_OP additive_expr
   ;

relational_expr
   : shift_expr
   | relational_expr '<' shift_expr
   | relational_expr '>' shift_expr
   | relational_expr TK_LE_OP shift_expr
   | relational_expr TK_GE_OP shift_expr
   ;

equality_expr
   : relational_expr
   | equality_expr TK_EQ_OP relational_expr
   | equality_expr TK_NE_OP relational_expr
   ;

and_expr
   : equality_expr
   | and_expr '&' equality_expr
   ;

exclusive_or_expr
   : and_expr
   | exclusive_or_expr '^' and_expr
   ;

inclusive_or_expr
   : exclusive_or_expr
   | inclusive_or_expr '|' exclusive_or_expr
   ;

logical_and_expr
   : inclusive_or_expr
   | logical_and_expr TK_AND_OP inclusive_or_expr
   ;

logical_or_expr
   : logical_and_expr
   | logical_or_expr TK_OR_OP logical_and_expr
   ;

conditional_expr
   : logical_or_expr
   | logical_or_expr '?' expr ':' conditional_expr
      /* I consider the conditional operator to be a decision point. */
      { ++fcn_decisions; }
   ;

assignment_expr
   : conditional_expr
   | unary_expr assignment_operator assignment_expr
   ;

assignment_operator
   : '='
   | TK_MUL_ASSIGN
   | TK_DIV_ASSIGN
   | TK_MOD_ASSIGN
   | TK_ADD_ASSIGN
   | TK_SUB_ASSIGN
   | TK_LEFT_ASSIGN
   | TK_RIGHT_ASSIGN
   | TK_AND_ASSIGN
   | TK_XOR_ASSIGN
   | TK_OR_ASSIGN
   ;

expr
   : assignment_expr
   | expr ',' assignment_expr
   ;

constant_expr
   : conditional_expr
   ;

declaration
   /*
      Regardless of whether we were really parsing a typedef, indicate that
      we are no longer by setting is_typedef to FALSE.
   */
   : declaration_specifiers ';'
      { is_typedef = FALSE; }
   | declaration_specifiers init_declarator_list ';'
      { is_typedef = FALSE; }
   ;

declaration_specifiers
   /*
      nested_decl_specs is incremented and decremented here so that the
      type name of the root-level declaration in a typedef can be
      distinguished from other identifiers in the typedef.
   */
   : storage_class_specifier
   | storage_class_specifier
      { ++nested_decl_specs; }
      declaration_specifiers
      { --nested_decl_specs; }
   | type_specifier
   | type_specifier
      { ++nested_decl_specs; }
      declaration_specifiers
      { --nested_decl_specs; }
   ;

init_declarator_list
   : init_declarator
   | init_declarator_list ',' init_declarator
   ;

init_declarator
   : declarator
   | declarator '=' initializer
   ;

storage_class_specifier
   : TK_TYPEDEF
      /*
         Indicate that we are within a typedef.  This is used to find the
         type name so that it can be added to the typedef symbol table.
      */
      { is_typedef = TRUE; }
   | TK_EXTERN
   | TK_STATIC
   | TK_AUTO
   | TK_REGISTER
   ;

type_specifier
   : TK_CHAR
   | TK_SHORT
   | TK_INT
   | TK_LONG
   | TK_SIGNED
   | TK_UNSIGNED
   | TK_FLOAT
   | TK_DOUBLE
   | TK_CONST
   | TK_VOLATILE
   | TK_VOID
   | struct_or_union_specifier
   | enum_specifier
   | TK_TYPE_NAME
   ;

struct_or_union_specifier
   /*
      In the following rules, regardless of whether there was a tag, indicate
      that we are no longer looking for one by setting looking_for_tag to FALSE.
   */
   : struct_or_union identifier
      { looking_for_tag = FALSE; }
      '{' struct_declaration_list '}'
   | struct_or_union '{'
      { looking_for_tag = FALSE; }
      struct_declaration_list '}'
   | struct_or_union identifier
      { looking_for_tag = FALSE; }
   ;

struct_or_union
   /*
      Indicate that we are looking for a tag.  This information is passed
      to the lexer.  Since tags are in a separate name space from other
      identifiers, this helps the lexer determine whether a lexeme is an
      identifier or a type name.
   */
   : TK_STRUCT
      { looking_for_tag = TRUE; }
   | TK_UNION
      { looking_for_tag = TRUE; }
   ;

struct_declaration_list
   : struct_declaration
   | struct_declaration_list struct_declaration
   ;

struct_declaration
   : type_specifier_list struct_declarator_list ';'
   ;

struct_declarator_list
   : struct_declarator
   | struct_declarator_list ',' struct_declarator
   ;

struct_declarator
   : declarator
   | ':' constant_expr
   | declarator ':' constant_expr
   ;

enum_specifier
   /*
      In the following rules, regardless of whether there was a tag, indicate
      that we are no longer looking for one by setting looking_for_tag to FALSE.
   */
   : enum '{' enumerator_list '}'
      { looking_for_tag = FALSE; }
   | enum identifier
      { looking_for_tag = FALSE; }
      '{' enumerator_list '}'
   | enum identifier
      { looking_for_tag = FALSE; }
   ;

enum
   /*
      Indicate that we are looking for a tag.  See struct_or_union for more
      info.
   */
   : TK_ENUM
      { looking_for_tag = TRUE; }
   ;

enumerator_list
   : enumerator
   | enumerator_list ',' enumerator
   ;

enumerator
   : identifier
   | identifier '=' constant_expr
   ;

declarator
   : declarator2
   | pointer declarator2
   ;

declarator2
   : identifier
      {
         /*
            If we are parsing a typedef and this is the root-level declaration,
            this identifier must be the type name that is being being defined
            by the typedef.  Therefore, add it to the typedef symbol table so
            that the lexer can distinguish type names from identifiers.
         */
         if (is_typedef && nested_decl_specs == 0)
           typedef_symbol_table_add(token());
      }
   | '(' declarator ')'
   | declarator2 '[' ']'
   | declarator2 '[' constant_expr ']'
   /*
      For the next three rules, if we are not within a function definition
      already, use the last identifier as the function name.
   */
   | declarator2 '('
      {
         if (!is_within_function)
            strcpy(function_name, last_identifier);
      }
      ')'
   /*
      nested_decl_specs is incremented and decremented in the following two
      rules so that the type name of the root-level declaration in a typedef
      can be distinguished from other identifiers in the typedef.
   */
   | declarator2 '('
      {
         ++nested_decl_specs;
         if (!is_within_function)
            strcpy(function_name, last_identifier);
      }
      parameter_type_list
      { --nested_decl_specs; }
      ')'
   | declarator2 '('
      {
         ++nested_decl_specs;
         if (!is_within_function)
            strcpy(function_name, last_identifier);
      }
      parameter_identifier_list
      { --nested_decl_specs; }
      ')'
   ;

pointer
   : '*'
   | '*' type_specifier_list
   | '*' pointer
   | '*' type_specifier_list pointer
   ;

type_specifier_list
   : type_specifier
   | type_specifier_list type_specifier
   ;

parameter_identifier_list
   : identifier_list
   | identifier_list ',' TK_ELIPSIS
   ;

identifier_list
   : identifier
   | identifier_list ',' identifier
   ;

parameter_type_list
   : parameter_list
   | parameter_list ',' TK_ELIPSIS
   ;

parameter_list
   : parameter_declaration
   | parameter_list ',' parameter_declaration
   ;

parameter_declaration
   : type_specifier_list declarator
   | type_name
   ;

type_name
   : type_specifier_list
   | type_specifier_list abstract_declarator
   ;

abstract_declarator
   : pointer
   | direct_abstract_declarator
   | pointer direct_abstract_declarator
   ;

direct_abstract_declarator
   : '(' abstract_declarator ')'
   | '[' ']'
   | '[' constant_expr ']'
   | direct_abstract_declarator '[' ']'
   | direct_abstract_declarator '[' constant_expr ']'
   | '(' ')'
   | '(' parameter_type_list ')'
   | direct_abstract_declarator '(' ')'
   | direct_abstract_declarator '(' parameter_type_list ')'
   ;

initializer
   : assignment_expr
   | '{' initializer_list '}'
   | '{' initializer_list ',' '}'
   ;

initializer_list
   : initializer
   | initializer_list ',' initializer
   ;

statement
   : labeled_statement
   | compound_statement
      {
         is_else = is_if = FALSE;

         ++int_fcn.high;      /* High-level statement. */

         /* Used to consider adjacent case labels as one decision point. */
         not_case_label();

         /*
            Indicate at the end of a compound, high-level statement, then
            fire the end-of-statement trigger.
         */
         int_stm.is_comp = int_stm.is_high = int_stm.end = TRUE;
         int_stm.depth = depth;
         fire_stm();
         ZERO(int_stm);
      }
   | expression_statement
      {
         check_multiple_statements();

         ++int_fcn.low;          /* Low-level statement. */

         /* Used to consider adjacent case labels as one decision point. */
         not_case_label();

         /*
            Indicate at the end of an expression, low-level statement, then
            fire the end-of-statement trigger.
         */
         int_stm.is_expr = int_stm.is_low = int_stm.end = TRUE;
         int_stm.depth = depth;
         fire_stm();
         ZERO(int_stm);
      }
   | selection_statement
      {
         ++int_fcn.high;      /* High-level statement. */

         /* Used to consider adjacent case labels as one decision point. */
         not_case_label();

         /*
            Indicate at the end of a selection, high-level statement, then
            fire the end-of-statement trigger.
         */
         int_stm.is_select = int_stm.is_high = int_stm.end = TRUE;
         int_stm.depth = depth;
         fire_stm();
         ZERO(int_stm);
      }
   | iteration_statement
      {
         ++int_fcn.high;      /* High-level statement. */

         /* Used to consider adjacent case labels as one decision point. */
         not_case_label();

         /*
            Indicate at the end of an iteration, high-level statement, then
            fire the end-of-statement trigger.
         */
         int_stm.is_iter = int_stm.is_high = int_stm.end = TRUE;
         int_stm.depth = depth;
         fire_stm();
         ZERO(int_stm);
      }
   | jump_statement
      {
         check_multiple_statements();

         ++int_fcn.low;          /* Low-level statement. */

         /* Used to consider adjacent case labels as one decision point. */
         not_case_label();

         /*
            Indicate at the end of a jump, low-level statement, then
            fire the end-of-statement trigger.
         */
         int_stm.is_jump = int_stm.is_low = int_stm.end = TRUE;
         int_stm.depth = depth;
         fire_stm();
         ZERO(int_stm);
      }
   ;

labeled_statement
   : identifier ':' statement
      { is_else = is_if = FALSE; }
   | TK_CASE constant_expr ':'
      {
         check_multiple_statements();

         /* Used to consider adjacent case labels as one decision point. */
         case_label();
      }
      statement
   | TK_DEFAULT ':'
      { check_multiple_statements(); }
      statement
   ;

compound_statement
   : '{' '}'
   | '{' statement_list '}'
   | '{' declaration_list '}'
   | '{' declaration_list statement_list '}'
   ;

declaration_list
   : declaration
   | declaration_list declaration
   ;

statement_list
   : statement
   | statement_list statement
   ;

expression_statement
   : ';'
   | expr ';'
   ;

selection_statement
   : TK_IF '(' expr ')'
      {
         is_if = TRUE;
         check_multiple_statements();
         ++depth;                /* Increase control depth. */
         ++fcn_decisions;        /* This is a decision point. */
      }
      statement
      { --depth;                 /* Decrease control depth. */ }
      opt_else
   | TK_SWITCH '(' expr ')'
      {
         check_multiple_statements();
         ++depth;                /* Increase control depth. */
      }
      statement
      { --depth;                 /* Decrease control depth. */ }
   ;

opt_else
   :                              %prec THEN
   | TK_ELSE
      {
         check_multiple_statements();
         is_else = TRUE;         /* Must be after check_...() */
         ++depth;                /* Increase control depth. */
      }
      statement
      { --depth;                 /* Decrease control depth. */ }
   ;

iteration_statement
   : TK_WHILE '(' expr ')'
      {
         check_multiple_statements();
         ++depth;                /* Increase control depth. */
         ++fcn_decisions;        /* This is a decision point. */
      }
      statement
      { --depth;                 /* Decrease control depth. */ }
   | TK_DO
      {
         ++depth;                /* Increase control depth. */
         ++fcn_decisions;        /* This is a decision point. */
      }
      statement
      { --depth;                 /* Decrease control depth. */ }
      TK_WHILE '(' expr ')' ';'
      { check_multiple_statements(); }
   | TK_FOR '(' opt_expr ';' ';' opt_expr ')'
      {
         check_multiple_statements();
         ++depth;                /* Increase control depth. */
         /* NOTE: This for statement does not contain a decision point. */
      }
      statement
      { --depth;                 /* Decrease control depth. */ }
   | TK_FOR '(' opt_expr ';' expr ';' opt_expr ')'
      {
         check_multiple_statements();
         ++depth;                /* Increase control depth. */
         ++fcn_decisions;        /* This is a decision point. */
      }
      statement
      { --depth;                 /* Decrease control depth. */ }
   ;

opt_expr
   :
   | expr
   ;

jump_statement
   : TK_GOTO identifier ';'
   | TK_CONTINUE ';'
   | TK_BREAK ';'
   | TK_RETURN opt_expr ';'
   ;

translation_unit
   : external_declaration
   | translation_unit external_declaration
   ;

external_declaration
   : function_definition
      { stat_func_end(); }
   | declaration
   ;

function_definition
   : declarator
      { stat_func_begin(); }
      function_body
   | declaration_specifiers declarator
      { stat_func_begin(); }
      function_body
   ;

function_body
   : compound_statement
   | declaration_list compound_statement
   ;

identifier
   : TK_IDENTIFIER
      {
         /*
            Save this identifier in case token buffer (yytext[]) gets
            overwritten by the time the identifier is needed.
         */
         strcpy(last_identifier, token());
      }
   ;
%%
/*************************************************************
   Copyright (c) 1993,1994 by Paul Long  All rights reserved.
**************************************************************/

#include <stdio.h>
#include <limits.h>
#include <stdarg.h>
#include "metreint.h"

/* External variables. */

/*
   Metre maintains statistics in the int_* structures, e.g., int_prj.  The
   structures with the unadorned names, e.g., prj, are used to communicate with
   the rules.  They are zero-filled except when a trigger is being fired.  At
   that time, the contents of the corresponding int_* structure is copied
   to it, the rules() function is called, and then the structure is zero-filed
   again.
*/
PRJ prj, int_prj;    /* Project. */
MOD mod, int_mod;    /* Module. */
FCN fcn;             /* Function. */
static FCN int_fcn;
STM stm;             /* Statement. */
static STM int_stm;
LIN lin, int_lin;    /* Line. */
LEX lex, int_lex;    /* Lexeme. */

/*
   Which command-line argument (argv) at which to start looking for the next
   file name to process and original file name, respectively.
*/
unsigned next_cmd_line_file;
unsigned next_cmd_line_file_orig_n;

/* Number of decision points and functions in module (file). */
unsigned mod_decisions;
unsigned mod_functions;

/*
   Indicates whether we are looking for a tag.  Parser writes it, lexer reads
   it.  Since tags are in a separate name space from other identifiers, this
   helps the lexer determine whether a lexeme is an identifier or a type name.
*/
BOOLEAN looking_for_tag;

/*
   Indicates whether we are within a function definition.  Used to determine
   whether to use the last identifier as the function name.
*/
BOOLEAN is_within_function;

/*
   Name of current input file and name of original file, if specified on
   command line with the substitute-file-name option.  If substitute not
   provided, input_file_orig_name points to the same name as input_file.
*/
char *input_file;
char *input_file_orig_name;

/* Where all output is written. */
FILE *out_fp;

/* Global versions of main's argc and argv. */
int cmd_line_argc;
char **cmd_line_argv;

/*
   Block within which typedef type names are held in the typedef symbol-table.
*/
typedef struct typedef_sym_blk {
   struct typedef_sym_blk *next;          /* Next block. */
   unsigned total;                        /* Total in this block. */
   char *id[TYPEDEF_SYMBOLS_PER_BLOCK]; /* Array of pointers to type names. */
} TYPEDEF_SYM_BLK;

/*
   Head of the typedef symbol-table.  NOTE: This is the only symbol table in
   Metre, and it is used just to hold typedef type names, not all symbols.
*/
TYPEDEF_SYM_BLK *typedef_sym_tbl_head = NULL;


/* Static variables. */

/* Control depth--current number of nested control structures. */
static unsigned depth;

/* Used to determine how many statements are on a line. */
static unsigned previous_statements_line_number;

/* Number of decision points in function. */
static unsigned fcn_decisions;

/*
   Metre maintains the number of statements appearing on a line.
   The is_if and is_else BOOLEANs are used principally to relax the
   criteria for what constitutes a statement.  For example, "else if,"
   is not considered two statements because this is a common idiom.
*/
static BOOLEAN is_else, is_if;

/*
   is_typedef indicates whether we are parsing a typedef.  Since typedefs
   cannot be nested, it's okay that this is just a BOOLEAN.  This is used to
   find the type name of a typedef so that it can be added to the typedef
   symbol table.  If the type name is subsequently encountered by the lexer,
   the lexer returns a token for a type name rather than for an identifier.
   This is the ugly part of C that cannot practically be expressed by a YACC
   grammar specification.
*/
static BOOLEAN is_typedef;

/*
   nested_decl_specs is used to distinguish the type name of the root-level
   declaration in a typedef from other identifiers in the typedef.
*/
static unsigned nested_decl_specs;

/*
   Whether the last statement was a case label.  Used to consider adjacent
   case labels as one decision point.  The transition from is_case_label==TRUE
   to is_case_label==FALSE is a decision point, instead of each case label
   being a decision point.  Adjacent case labels are considered one decision
   point because this is analogous to an if statement with or logical
   operators, ||.  For example,

      switch (expr) {
      case 5:
      case 10:
         a;
      }

   is, in this regard, analogous to

      if (expr == 5 || expr == 10)
         a;

   I did not want to bias the metric against the switch statement.
*/
static BOOLEAN is_case_label;

static IDENTIFIER function_name;
static IDENTIFIER last_identifier;

/* Static function declarations. */

static void fire_fcn(void);
static void fire_stm(void);
static void print_exception(int, char *, char *, va_list);
static void typedef_symbol_table_add(char *);
static void case_label(void);
static void not_case_label(void);
static void check_starting_options(void);
static void print_banner(void);
static void print_help(void);
static void stat_func_begin(void);
static void stat_func_end(void);
static void check_multiple_statements(void);
static void int_fatal(int, char *, ...);
static void int_warn(int, char *, ...);


/* Functions. */

main(int argc, char *argv[])
{
   print_banner();

   /* Save so that the argument list may be accessed globally. */
   cmd_line_argv = argv;
   cmd_line_argc = argc;

   /* Get command-line options that affect Metre at the start. */
   check_starting_options();

   /* Initialize YACC and Lex. */
   init_yacc();
   init_lex();

   /*
      Look for the first input file and first original name of that input file.
   */
   next_cmd_line_file = 0;
   next_cmd_line_file_orig_n = 0;
   if ((input_file = get_next_input_file(&next_cmd_line_file)) != NULL)
      if ((yyin = fopen(input_file, "r")) != NULL)
      {
         input_file_orig_name =
               get_next_input_file_orig_name(&next_cmd_line_file_orig_n);
         /* If no original name given, use the actual as the original, also. */
         if (input_file_orig_name == NULL)
            input_file_orig_name = input_file;

         /* Fire the beginning-of-project trigger. */
         ZERO(int_prj);
         int_prj.begin = TRUE;
         fire_prj();
         int_prj.begin = FALSE;

         /* Fire the beginning-of-module trigger. */
         ZERO(int_mod);
         int_mod.begin = TRUE;
         fire_mod();
         int_mod.begin = FALSE;

         /*
            Call the YACC-generated parser to wade through the input file(s).
            When all done, close the last input file.  yywrap() could have
            opened any number of subsequent input files.
         */
         yyparse();
         fclose(yyin);
      }
      else
         int_warn(W_CANNOT_OPEN_FILE, input_file);
   else
      /* Since no input file specified on command line, print Metre's help. */
      print_help();

/* VMS has different ideas about what constitutes a successful return value. */
#ifdef VAX
   return 1;
#else
   return 0;
#endif
}

/* Common exception-handling function. */
static void print_exception(int n, char *severity_str, char *format, va_list ap)
{
   fflush(out_fp);

   /*
      Display input line if supposed to, then display line with marker
      character in it if appropriate.
   */
   if (mod_name() != NULL && strlen(mod_name()) > 0)
   {
      if (!int_mod.end && !int_fcn.end)
      {
         if (!display_input && READ_LINE)
            fputs(line(), out_fp);

         if (!int_lin.end && READ_LINE)
            fputs(marker(), out_fp);
      }
   }

   /*
      Display module name and line number if a module name has been established.
      If one hasn't, the error must not relate to a location in the input file.
   */
   if (mod_name() != NULL && strlen(mod_name()) > 0)
      fprintf(out_fp, "%s(%u): ", mod_name(), yylineno);
   fprintf(out_fp, "%s%04u: ", severity_str, n);

   vfprintf(out_fp, format, ap);
   fputc('\n', out_fp);
}

/* Print message for internal fatal error. */
static void int_fatal(int n, char *format, ...)
{
   va_list ap;

   va_start(ap, format);

   print_exception(n, "Fatal Error ME", format, ap);

   exit(1);
}

/* Print message for fatal error that occured in the rules() function. */
void fatal(int n, char *format, ...)
{
   va_list ap;

   va_start(ap, format);

   print_exception(n, "Fatal Error E", format, ap);

   exit(1);
}

/* Print message for internal warning. */
static void int_warn(int n, char *format, ...)
{
   va_list ap;

   va_start(ap, format);

   print_exception(n, "Warning MW", format, ap);
}

/* Print message for warning that occured in the rules() function. */
void warn(int n, char *format, ...)
{
   va_list ap;

   va_start(ap, format);

   print_exception(n, "Warning W", format, ap);
}

/* Function called by YACC when it detects an error. */
void yyerror(char *s)
{
#ifdef DEBUG_TYPEDEF
   /* Used for debugging typedef processing. */
   typedef_symbol_table_dump();
#endif
   int_fatal(0, "%s", s);
}

/* Add type name to the typedef symbol table. */
static void typedef_symbol_table_add(char *p_symbol)
{
   TYPEDEF_SYM_BLK *block;
   char *str_buf = (char *)malloc(strlen(p_symbol) + 1);

   if (str_buf == NULL)
      int_fatal(E_NO_HEAP);

   /* Make copy of argument. */
   strcpy(str_buf, p_symbol);

   /* Is symbol table empty? */
   if (typedef_sym_tbl_head == NULL)
   {
      /* Allocate first block and make the head of the table list. */
      typedef_sym_tbl_head = block = (TYPEDEF_SYM_BLK *)malloc(sizeof *block);
      if (block == NULL)
         int_fatal(E_NO_HEAP);

      block->total = 0;
      block->next = NULL;
   }
   else
   {
      TYPEDEF_SYM_BLK *prev_block;

      /* Find first block in symbol-table list that isn't full. */
      for (prev_block = NULL, block = typedef_sym_tbl_head;
            block != NULL && block->total == DIM_OF(block->id);
            prev_block = block, block = block->next)
         ;

      /* If all blocks are full, allocate a new one and append to list. */
      if (block == NULL)
      {
         block = (TYPEDEF_SYM_BLK *)malloc(sizeof *block);
         if (block == NULL)
            int_fatal(E_NO_HEAP);

         block->total = 0;
         block->next = NULL;
         if (prev_block == NULL)
            typedef_sym_tbl_head = block;
         else
            prev_block->next = block;
      }
   }

   /* Save pointer to the new type name in first empty slot of this block. */
   block->id[block->total++] = str_buf;
}

/* Return TRUE if symbol exists in the typedef symbol table. */
BOOLEAN typedef_symbol_table_find(char *p_symbol)
{
   TYPEDEF_SYM_BLK *block;
   BOOLEAN found = FALSE;

   /* Loop for each block of symbols. */
   for (block = typedef_sym_tbl_head; block != NULL; block = block->next)
   {
      unsigned i;

      /* Loop for each symbol in this block. */
      for (i = 0; i < block->total; ++i)
         if (strcmp(block->id[i], p_symbol) == 0)
            found = TRUE;
   }

   return found;
}

/*
   Remove all symbols (and symbol blocks) from the symbol table--make the
   table empty.
*/
void typedef_symbol_table_flush(void)
{
   TYPEDEF_SYM_BLK *block;

   /* Loop for each block of symbols. */
   for (block = typedef_sym_tbl_head; block != NULL; )
   {
      unsigned i;
      TYPEDEF_SYM_BLK *temp_block;

      /* Loop for each symbol in this block. */
      for (i = 0; i < block->total; ++i)
         free(block->id[i]);              /* Free symbol. */

      temp_block = block->next;
      free(block);                        /* Free block now that it's empty. */
      block = temp_block;
   }

   typedef_sym_tbl_head = NULL;
}

#ifdef DEBUG_TYPEDEF
/*
   Display the contents of the typedef symbol table.  Used for debugging
   typedef processing.
*/
void typedef_symbol_table_dump(void)
{
   TYPEDEF_SYM_BLK *block;

   puts("typedef symbol table dump:");

   /* Loop for each block of symbols. */
   for (block = typedef_sym_tbl_head; block != NULL; block = block->next)
   {
      unsigned i;

      /* Loop for each symbol in this block. */
      for (i = 0; i < block->total; ++i)
         puts(block->id[i]);
   }
}
#endif

/* Record that the last statement was a case label. */
static void case_label(void)
{
   is_case_label = TRUE;
}

/*
   Record that the last statement was not a case label.  If the previous
   statement was a case label, increment the decision-point counter--this ends
   a run of adjacent case labels which count as one decision point.
*/
static void not_case_label(void)
{
   if (is_case_label)
   {
      is_case_label = FALSE;
      ++fcn_decisions;        /* This is a decision point. */
   }
}

/* Initialize parser. */
void init_yacc(void)
{
   /* Make the typedef symbol table empty. */
   typedef_symbol_table_flush();

   /*
      See the definition of each of these variables, above, for more
      information.
   */
   is_typedef = FALSE;
   nested_decl_specs = 0;
   is_case_label = FALSE;

   function_name[0] = '\0';
   last_identifier[0] = '\0';

   mod_decisions = 0;
   mod_functions = 0;
   is_else = is_if = FALSE;
   looking_for_tag = FALSE;

   is_within_function = FALSE;
}

/*
   Returns TRUE if the indicated option character was specified on the
   command line.  E.g., for -S, would return TRUE for option('S').
*/
int option(char opt_char)
{
   char *opt_str = str_option(opt_char);

   return opt_str == NULL ? 0 : strlen(opt_str) == 0 ? 1 : atoi(opt_str);
}

/*
   Returns pointer to the part of an option following the "=".  E.g.,
   for -Xabc=def, it would point to the "def" part.
*/
char *str_option(char opt_char)
{
   unsigned i;

   for (i = 1; i < cmd_line_argc; ++i)
      if (strchr(OPT_INTRO_CHARS, cmd_line_argv[i][0]) != NULL)
         if (toupper(cmd_line_argv[i][1]) == toupper(opt_char))
            break;

   return i < cmd_line_argc ? &cmd_line_argv[i][2] : NULL;
}

/*
   Return pointer to the name of the next input file in the argv array
   starting with the argument that p_i points to.  An input file name is
   distinguished from the command-line options by not starting with one of
   characters in the OPT_INTRO_CHARS string.

   NOTE: argument 0 is the name of the command, not the first argument, per se.
*/
char *get_next_input_file(unsigned *p_i)
{
   for (++*p_i; *p_i < cmd_line_argc &&
         strchr(OPT_INTRO_CHARS, cmd_line_argv[*p_i][0]) != NULL; ++*p_i)
      ;

   return *p_i < cmd_line_argc ? cmd_line_argv[*p_i] : NULL;
}

/*
   Return pointer to the original name of the next input file in the argv
   array starting with the argument that p_i points to.  An original name is
   specified as a command-line option.  That is how an original name is
   distinguished from the name of an actual input file

   NOTE: argument 0 is the name of the command, not the first argument, per se.
*/
char *get_next_input_file_orig_name(unsigned *p_i)
{
   for (++*p_i; *p_i < cmd_line_argc; ++*p_i)
      if (strchr(OPT_INTRO_CHARS, cmd_line_argv[*p_i][0]) != NULL &&
            toupper(cmd_line_argv[*p_i][1]) == SUBST_FILE_OPT_CHAR)
         break;

   return *p_i < cmd_line_argc ? &cmd_line_argv[*p_i][2] : NULL;
}

/* Returns pointer to current module (file) name. */
char *mod_name(void)
{
   return input_file_orig_name;
}

/* Process the command-line options that affect the start of Metre. */
static void check_starting_options(void)
{
   static char *output_file_name;

   /* Interleave the input with the output? */
   display_input = option(COPY_INPUT_OPT_CHAR);

   /*
      Name of listing file to contain output.  This for those OS's that don't
      support command-line redirection, e.g., VMS.
   */
   output_file_name = str_option(LISTING_OPT_CHAR);
   if (output_file_name != NULL && strlen(output_file_name) > 0)
   {
      out_fp = fopen(output_file_name, "w");
      if (out_fp == NULL)
      {
         out_fp = stdout;     /* Restore to previous, good output file. */
         int_fatal(E_CANT_OPEN_LISTING_FILE);   /* Die. */
      }
   }
   else
      out_fp = stdout;
}

/* Print name, version, and copyright notice. */
static void print_banner(void)
{
   printf("METRE Version %s  ", metre_version);
   puts("Copyright (c) 1993,1994 by Paul Long  All rights reserved.");
}

/* Print Metre command-usage information. */
static void print_help(void)
{
   puts("Syntax: METRE [ options ] file[s]   Option character in either case.  / or -");
   puts("-Dxxx=[xxx] Define identifier     -Lxxx  Name of listing file (stdout)");
   puts("-Sxxx       Substitute file name  -C     Copy input to output");
}

/* Called at the beginning of a function definition. */
static void stat_func_begin(void)
{
   /* Fire the beginning-of-function trigger. */
   ZERO(int_fcn);
   int_fcn.begin = TRUE;
   fire_fcn();
   int_fcn.begin = FALSE;

   /* Initialize variables relating to a function. */
   depth = 0;
   is_within_function = TRUE;
   fcn_decisions = 0;
   previous_statements_line_number = 0;

   /* Install starting counts.  Will replace with deltas at end-of-function. */
   int_fcn.lines.white = int_mod.lines.white;
   int_fcn.lines.com = int_mod.lines.com;
   int_fcn.lines.exec = int_mod.lines.exec;
   int_fcn.lines.total = yylineno;
}

/* Called at the end of a function definition. */
static void stat_func_end(void)
{
   /*
      Replace initial counts with their deltas to arrive at totals for
      the function.
   */
   int_fcn.lines.white = int_mod.lines.white - int_fcn.lines.white;
   int_fcn.lines.com = int_mod.lines.com - int_fcn.lines.com;
   int_fcn.lines.exec = int_mod.lines.exec - int_fcn.lines.exec;
   int_fcn.lines.total = yylineno - int_fcn.lines.total;

   ++mod_functions;                 /* Increment function count. */

   /* Accumulate function decision count into module decision count. */
   mod_decisions += fcn_decisions;

   /*
      Install the rest of the function-related information into the function
      structure and fire the end-of-function trigger.
   */
   int_fcn.decisions = fcn_decisions;
   int_fcn.end = TRUE;
   fire_fcn();
   ZERO(int_fcn);

   /*
      Clear variables that would otherwise indicate that we are still
      parsing a function.
   */
   strcpy(function_name, "");
   is_within_function = FALSE;
}

/*
   Returns pointer to current function name, or an empty string if not in a
   function.
*/
char *fcn_name(void)
{
   return function_name;
}

/*
   Increment the number of statements for the current line.  This function is
   called whenever a statement is encountered.  If the current line number is
   the same as when the last statement was encountered and if this is not the
   special situation of "else if," the counter is incremented.
*/
static void check_multiple_statements(void)
{
   if (previous_statements_line_number == yylineno)
      if (is_else && is_if)
         ;        /* do nothing */
      else
         ++int_lin.statements;
   else
      previous_statements_line_number = yylineno;

   is_else = is_if = FALSE;
}


/*
   This is true for all of the fire_*() functions: Copy the internal structure
   to the exported structure, allow the triggers to fire in the rules()
   function, then zero-fill the exported structure so that unrelated rules
   won't execute when other triggers are fired.
*/

void fire_prj(void)
{
   prj = int_prj;
   rules();
   ZERO(prj);
}

void fire_mod(void)
{
   mod = int_mod;
   rules();
   ZERO(mod);
}

static void fire_fcn(void)
{
   fcn = int_fcn;
   rules();
   ZERO(fcn);
}

static void fire_stm(void)
{
   stm = int_stm;
   rules();
   ZERO(stm);
}

void fire_lin(void)
{
   lin = int_lin;
   rules();
   ZERO(lin);
}

void fire_lex(void)
{
   lex = int_lex;
   rules();
   ZERO(lex);
}
