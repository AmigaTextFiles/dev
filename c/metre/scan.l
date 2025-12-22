D                       [0-9]
L                       [a-zA-Z_$]
H                       [a-fA-F0-9]
E                       [Ee][+-]?{D}+
FS                      (f|F|l|L)
IS                      (u|U|l|L)*
LWSC                    [ \t\v\f]
%{
/*************************************************************
   Copyright (c) 1993,1994 by Paul Long  All rights reserved.
**************************************************************/

/*************************************************************
   scan.l - This source file contains the lex specification
            for Metre's Standard C lexer.  It also contains
            lexical functions that can be called from the
            rules() function and replacement functions for
            lex's yywrap() and MKS lex's yygetc().
**************************************************************/


#include <stdio.h>
#include <ctype.h>
#include "ytab.h"
#include "metreint.h"


/*
   Decide which lex is being used based on whether YY_INIT and YY_INPUT are
   defined.  It is my belief that the 4 combinations of whether these two
   manifest constants are defined coincidentally indicates which lex is being
   used.  I know that this method works with MKS and AT&T lex; from reading
   John Levine's book, "lex & yacc," I also believe that it works with flex
   and pclex.  Note: Berkeley is considered same as AT&T lex, and Posix is not
   considered at all.
*/
#ifdef YY_INIT
#ifdef YY_INPUT
#define MTR_PCLEX
#else
#define MTR_MKSLEX
#endif
#else
#ifdef YY_INPUT
#define MTR_FLEX
#else
#define MTR_ATTLEX
#endif
#endif

/*
   Redefine size of miniscule yytext[].  Should have no affect on other lex's.
*/
#define MTR_YYTEXT_SIZE 500
/*
   Redefine for MKS and AT&T lex.  I don't explicitly test for MTR_MKSLEX or
   MTR_ATTLEX because YYLMAX should only be defined for them.
*/
#ifdef YYLMAX
#if YYLMAX < MTR_YYTEXT_SIZE
#undef YYLMAX
#define YYLMAX MTR_YYTEXT_SIZE
#endif
#endif
/*
   Redefine for pclex.  I don't explicitly test for MTR_PCLEX because F_BUFSIZ
   should only be defined for it.
*/
#ifdef F_BUFSIZ
#if F_BUFSIZ < MTR_YYTEXT_SIZE
#undef F_BUFSIZ
#define F_BUFSIZ MTR_YYTEXT_SIZE
#endif
#endif

/*
   Prior to version 2.4, flex defined a yywrap() macro.  Undefine it just in
   case, because I define a yywrap() function.  This shouldn't affect the other
   lex's.
*/
#ifdef yywrap
#undef yywrap
#endif


#if READ_LINE

/*
   I provide a function to replace MKS' yygetc() macro, so undefine the macro.
   Should have no affect on other lex's.  That's why I don't explicitly test
   for MTR_MKSLEX.
*/
#ifdef yygetc
#undef yygetc
#endif

/*
   AT&T lex uses stdio.h's getc() to read in characters in its input() macro.
   Assuming that getc() is a macro in stdio.h, redefine it to call my
   yygetc() macro.
*/
#ifdef MTR_ATTLEX
#ifdef getc
#undef getc
#endif
#define getc(x)   yygetc()
#endif

/*
   The following directives hopefully make Metre compatible with flex and
   pclex.  I don't have either, so I can't test this.  From reading John
   Levine's book, "lex & yacc," flex/pclex expects the YY_INPUT() macro to
   read a block of data.  If flex/pclex is used, it will use my definition.
   If flex/pclex is not used, MKS and AT&T lex will use it indirectly because
   yygetc() and getc(), respectively, also use the macro.

   This diagram shows the dependencies and how Metre achieves compatibility
   with the three lex's.

      getc()                     <-- AT&T lex uses
         yygetc()                <-- MKS lex uses
            YY_INPUT()           <-- flex/pclex uses
               my_yyinput()
*/
#ifdef YY_INPUT
#undef YY_INPUT
#endif
#define YY_INPUT(b, r, ms) (r = my_yyinput(b, ms))

/* Size of input buffer.  Must be as large as the largest expected line. */
#define INPUT_LINE_MAX_LEN    2048

#endif      /* #if READ_LINE */


/* Define how to restart lexer based on which lex is being used. */
#if defined(MTR_MKSLEX) || defined(MTR_PCLEX)
#define MTR_YY_INIT  YY_INIT
#elif defined(MTR_FLEX)
#define MTR_YY_INIT  yyrestart(yyin)
#elif defined(MTR_ATTLEX)
#define MTR_YY_INIT  yy_init()
#else
#error Unsupported version of lex
#endif


/* External variables. */

/*
   Whether to interleave the input with the output.  Set according to the
   copy-input option character from the command line.
*/
BOOLEAN display_input;

#if defined(MTR_MKSLEX) || defined(MTR_ATTLEX)
/* Do nothing--the lex takes care of it. */
#define INCR_YYLINENO
#else
/*
   I know that MKS and AT&T lex support yylineno.  Don't know about the
   others.  Here's one for them.  I use the technique described in
   John Levine's book, "lex & yacc," of simply incrementing a line counter
   whenever a newline is encountered in the input stream.  However, this is not
   as accurate as how MKS and AT&T lex do it.  They increment the line counter
   when the input() macro encounters a newline and decrement it when it is
   pushed back via the unput() macro.  This overcomes the problem of
   incrementing the line counter prematurely during look-ahead.  I took the
   easy way out for lex's other than MKS or AT&T--I didn't want to provide my
   own input() and output() macros for them.  You could modify them, though.
*/
int yylineno;
#define INCR_YYLINENO   (++yylineno)
#endif


/* Function prototypes for static functions. */
#if READ_LINE
static int yygetc(void);
static int my_yyinput(char *, int);
#endif
static void count(void);
static void comment(void);
static void fire_keyword(void);
static void fire_identifier(void);
static void found_nonstandard(void);
static BOOLEAN identifier_defined(char *);
static int check_type(void);
static unsigned extract_line_number(char *);
static char *extract_file_name(char *);
#ifdef MTR_ATTLEX
static void yy_init(void);
#endif

/* Static variables. */

#if READ_LINE
/*
   I read the input line into here then feed the lexer one character at a time
   from that.  This is so that I have the entire line available in case I
   need to print the line along with an error message.
*/
static char input_line[INPUT_LINE_MAX_LEN];
#endif

/* An input line is one of these three types. */
static enum { BLANK_LINE, COMMENT_LINE, CODE_LINE } line_type = BLANK_LINE;

/* Whether a tab or space character was found at the beginning of a line. */
static BOOLEAN found_tab;
static BOOLEAN found_space;

/*
   Pointer to current keyword or identifier as passed to rules if such a token
   is encountered.
*/
static char *current_keyword;
static char *current_identifier;
%}

%%
"/*"                    { comment();   /* Read in rest of comment. */ }
^{LWSC}*#[ \t]*("line"[ \t]+)?{D}+([ \t]+\"[^"\n]*\")?.*  {
                           char *temp_file_name;

                           count();

                           /* Don't know why had to subtract 1. Oh well. */
                           yylineno = extract_line_number(yytext) - 1;

                           /* Use new file name if present. */
                           temp_file_name = extract_file_name(yytext);
                           if (temp_file_name != NULL)
                              input_file_orig_name = temp_file_name;
                        }

"auto"                  {  /*
                              For this and the following keywords, do
                              some lexical accounting, fire the keyword
                              trigger in case a rule uses a keyword as a
                              trigger, then return token to parser.
                           */
                           count(); fire_keyword(); return(TK_AUTO); }
"break"                 { count(); fire_keyword(); return(TK_BREAK); }
"case"                  { count(); fire_keyword(); return(TK_CASE); }
"char"                  { count(); fire_keyword(); return(TK_CHAR); }
"const"                 { count(); fire_keyword(); return(TK_CONST); }
"continue"              { count(); fire_keyword(); return(TK_CONTINUE); }
"default"               { count(); fire_keyword(); return(TK_DEFAULT); }
"do"                    { count(); fire_keyword(); return(TK_DO); }
"double"                { count(); fire_keyword(); return(TK_DOUBLE); }
"else"                  { count(); fire_keyword(); return(TK_ELSE); }
"enum"                  { count(); fire_keyword(); return(TK_ENUM); }
"extern"                { count(); fire_keyword(); return(TK_EXTERN); }
"float"                 { count(); fire_keyword(); return(TK_FLOAT); }
"for"                   { count(); fire_keyword(); return(TK_FOR); }
"goto"                  { count(); fire_keyword(); return(TK_GOTO); }
"if"                    { count(); fire_keyword(); return(TK_IF); }
"int"                   { count(); fire_keyword(); return(TK_INT); }
"long"                  { count(); fire_keyword(); return(TK_LONG); }
"register"              { count(); fire_keyword(); return(TK_REGISTER); }
"return"                { count(); fire_keyword(); return(TK_RETURN); }
"short"                 { count(); fire_keyword(); return(TK_SHORT); }
"signed"                { count(); fire_keyword(); return(TK_SIGNED); }
"sizeof"                { count(); fire_keyword(); return(TK_SIZEOF); }
"static"                { count(); fire_keyword(); return(TK_STATIC); }
"struct"                { count(); fire_keyword(); return(TK_STRUCT); }
"switch"                { count(); fire_keyword(); return(TK_SWITCH); }
"typedef"               { count(); fire_keyword(); return(TK_TYPEDEF); }
"union"                 { count(); fire_keyword(); return(TK_UNION); }
"unsigned"              { count(); fire_keyword(); return(TK_UNSIGNED); }
"void"                  { count(); fire_keyword(); return(TK_VOID); }
"volatile"              { count(); fire_keyword(); return(TK_VOLATILE); }
"while"                 { count(); fire_keyword(); return(TK_WHILE); }

{L}({L}|{D})*           {
                           /*
                              If a replacement was provided on the
                              command line for this identifier, rescan
                              input which will now have the replacement
                              characters.  Otherwise, do some lexical
                              accounting, fire the identifier trigger in
                              case a rule uses an identifier in a
                              trigger, then return token to parser (this
                              is either an identifier or a typedef type
                              name).
                           */
                           if (!identifier_defined(yytext))
                           {
                              count();
                              fire_identifier();
                              return(check_type());
                           }
                        }

0[xX]{H}+{IS}?          {  /*
                              For this and the following constants and
                              string literals, do some lexical
                              accounting and return token to parser.
                           */
                           count(); return(TK_CONSTANT); }
0[xX]{H}+{IS}?          { count(); return(TK_CONSTANT); }
0{D}+{IS}?              { count(); return(TK_CONSTANT); }
0{D}+{IS}?              { count(); return(TK_CONSTANT); }
{D}+{IS}?               { count(); return(TK_CONSTANT); }
{D}+{IS}?               { count(); return(TK_CONSTANT); }
'(\\.|[^\\'])+'         { count(); return(TK_CONSTANT); }
{D}+{E}{FS}?            { count(); return(TK_CONSTANT); }
{D}*"."{D}+({E})?{FS}?  { count(); return(TK_CONSTANT); }
{D}+"."{D}*({E})?{FS}?  { count(); return(TK_CONSTANT); }
\"(\\.|[^\\"])*\"       { count(); return(TK_STRING_LITERAL); }

"\.\.\."                {  /*
                              For this and the following operators, do
                              some lexical accounting and return token
                              to parser.
                           */
                           count(); return(TK_ELIPSIS); }
">>="                   { count(); return(TK_RIGHT_ASSIGN); }
"<<="                   { count(); return(TK_LEFT_ASSIGN); }
"+="                    { count(); return(TK_ADD_ASSIGN); }
"-="                    { count(); return(TK_SUB_ASSIGN); }
"*="                    { count(); return(TK_MUL_ASSIGN); }
"/="                    { count(); return(TK_DIV_ASSIGN); }
"%="                    { count(); return(TK_MOD_ASSIGN); }
"&="                    { count(); return(TK_AND_ASSIGN); }
"^="                    { count(); return(TK_XOR_ASSIGN); }
"|="                    { count(); return(TK_OR_ASSIGN); }
">>"                    { count(); return(TK_RIGHT_OP); }
"<<"                    { count(); return(TK_LEFT_OP); }
"++"                    { count(); return(TK_INC_OP); }
"--"                    { count(); return(TK_DEC_OP); }
"->"                    { count(); return(TK_PTR_OP); }
"&&"                    { count(); return(TK_AND_OP); }
"||"                    { count(); return(TK_OR_OP); }
"<="                    { count(); return(TK_LE_OP); }
">="                    { count(); return(TK_GE_OP); }
"=="                    { count(); return(TK_EQ_OP); }
"!="                    { count(); return(TK_NE_OP); }
";"                     { count(); return(';'); }
"{"                     { count(); return('{'); }
"}"                     { count(); return('}'); }
","                     { count(); return(','); }
":"                     { count(); return(':'); }
"="                     { count(); return('='); }
"("                     { count(); return('('); }
")"                     { count(); return(')'); }
"["                     { count(); return('['); }
"]"                     { count(); return(']'); }
"."                     { count(); return('.'); }
"&"                     { count(); return('&'); }
"!"                     { count(); return('!'); }
"~"                     { count(); return('~'); }
"-"                     { count(); return('-'); }
"+"                     { count(); return('+'); }
"*"                     { count(); return('*'); }
"/"                     { count(); return('/'); }
"%"                     { count(); return('%'); }
"<"                     { count(); return('<'); }
">"                     { count(); return('>'); }
"^"                     { count(); return('^'); }
"|"                     { count(); return('|'); }
"?"                     { count(); return('?'); }

{LWSC}                  {  /* Absorb whitespace character. */
                           count(); }
\n                      { INCR_YYLINENO; count(); }

^{LWSC}*#.*             {  /* Ignore preprocessor directives. */
                           count(); }

.                       {  /* Trap any non-standard characters. */
                           count(); found_nonstandard(); }

%%

/*
   If a replacement string was specified on command line, substitute for
   this lexeme.  Return whether this identifier had a replacement string.
*/
static BOOLEAN identifier_defined(char *id)
{
   unsigned i;

   /* Look through command-line arguments for the define option character. */
   for (i = 1; i < cmd_line_argc; ++i)
      if (strchr(OPT_INTRO_CHARS, cmd_line_argv[i][0]) != NULL &&
            toupper(cmd_line_argv[i][1]) == DEFINE_OPT_CHAR)
      {
         char *repl_str;

         /* Look for equal sign after identifier. */
         repl_str = (char *)strchr(&cmd_line_argv[i][2], '=');

         /*
            If equal sign found and this is a define for this
            identifier, substitute replacement string for this lexeme.
         */
         if (repl_str != NULL && strncmp(&cmd_line_argv[i][2], id,
                                       repl_str - &cmd_line_argv[i][2]) == 0)
         {
            unsigned len;
            char *p;

            /*
               unput replacement string so that lex will scan it in as
               if it occurred in the input stream instead of the
               original identifier.  NOTE: If empty replacement string,
               the affect is that the identifier is ignored.
            */
            for (len = strlen(&repl_str[1]), p = &repl_str[len]; len > 0;
                                                                     --len, --p)
               unput(*p);

            /*
               Leave outer loop because define option character found
               and processed.
            */
            break;
         }
      }

   return i < cmd_line_argc;
}

/* Initialize lexer. */
void init_lex(void)
{
   /*
      Restart lex itself.  Note: I don't believe that this is absolutely
      necessary for this lexer.  The lexer is not left in an unusual state
      after each file, e.g., characters left in the push-back buffer or the
      lexer being in a state other than INITIAL.  It is explicitly restarted
      here just because "it's the right thing to do."  If this macro reference
      expands to something that is not compatible with your lexer, although I
      tried to make it portable, just remove it.
   */
   MTR_YY_INIT;

   /* Reset line_type for first line.  Start off assuming blank line. */
   line_type = BLANK_LINE;

   yylineno = 1;
   found_tab = FALSE;
   found_space = FALSE;
   current_keyword = "";
   current_identifier = "";
}

#ifdef MTR_ATTLEX
/* Function that restarts AT&T lexers. */
static void yy_init(void)
{
   extern int yyprevious;

   NLSTATE;
   yysptr = yysbuf;
   BEGIN INITIAL;

/* I don't think these absolutely need to be reset. */
#if 0
   extern int *yyfnd;
   yyleng = 0;
   yytchar = 0;
   yymorfg = 0;
   yyestate = 0;
   yyfnd = 0;
#endif
}
#endif

/* Fire the keyword trigger. */
static void fire_keyword(void)
{
   current_keyword = yytext;
   rules();
   current_keyword = "";
}

/* Fire the identifier trigger. */
static void fire_identifier(void)
{
   current_identifier = yytext;
   rules();
   current_identifier = "";
}


#if READ_LINE

/* Pointer to next character in input_line[]. */
static char *next_char_p;

/*
   Replacement for the out-of-the-box yygetc().  This function provides
   access to the entire input line, even the characters that have not
   yet been scanned in.
*/
static int yygetc(void)
{
   static char last_char = EOF;   /* Force subsequent getting of first line.*/
   char next_char;
   int characters_read;

   switch (last_char)
   {
   case '\n':        /* Time to get another line of input? */
   case EOF:
      YY_INPUT(input_line, characters_read, INPUT_LINE_MAX_LEN);
      if (characters_read == 0)
      {
         next_char = EOF;           /* Indicate that couldn't get another line*/
         next_char_p = input_line;  /* Set to something. */
      }
      else
      {
         next_char_p = input_line;
         next_char = *next_char_p++;   /* Get first character from input line. */
      }
      break;

   default:                         /* Get next character from input line. */
      next_char = *next_char_p++;
   }

   last_char = next_char;

   return next_char;
}

/* Read next line from input file, returning number of characters read. */
static int my_yyinput(char *buf, int max_size)
{
   int characters_read;

   if (fgets(buf, max_size, yyin) == NULL)
      buf[0] = '\0';
   else
      /* This is where the input line is printed if display_print is TRUE. */
      if (display_input)
         fputs(buf, out_fp);

   return strlen(buf);
}

#endif      /* #if READ_LINE */

/*
   Called by yacc at the end of a source file.  If there are more files to
   process, open them and continue, else stop.
*/
yywrap()
{
   int ret_val;

   /* Provide module information then fire the end-of-module trigger. */
   int_mod.decisions = mod_decisions;
   int_mod.functions = mod_functions;
   int_mod.lines.total = yylineno - 1;
   int_mod.end = TRUE;
   fire_mod();
   int_mod.end = FALSE;
   ZERO(int_mod);

   /* See whether there is another input file to process. */
   if (next_cmd_line_file < cmd_line_argc &&
         (input_file = get_next_input_file(&next_cmd_line_file)) != NULL)
      if (freopen(input_file, "r", yyin) != NULL)
      {
         /* Reinitialize yacc and lex. */
         init_yacc();
         init_lex();

         /*
            See whether to use the original file name as provided on the
            command line rather than the file name that was provided.  This
            is in case the output of the preprocessor is the input file and
            there are no line directives, but we'd like to use the name of
            the input to the preprocessor.
         */
         input_file_orig_name =
               get_next_input_file_orig_name(&next_cmd_line_file_orig_n);
         if (input_file_orig_name == NULL)
            input_file_orig_name = input_file;

         /* Fire the beginning-of-module trigger. */
         ZERO(int_mod);
         int_mod.begin = TRUE;
         fire_mod();
         int_mod.begin = FALSE;

         /* Tell yacc to continue. */
         ret_val = 0;
      }
      else
      {
         warn(W_CANNOT_OPEN_FILE, input_file);

         /* Fire the end-of-project trigger. */
         int_prj.end = TRUE;
         fire_prj();
         int_prj.end = FALSE;
         ZERO(int_prj);

         /* Tell yacc to stop. */
         ret_val = 1;
      }
   else
   {
      /* Fire the end-of-project trigger. */
      int_prj.end = TRUE;
      fire_prj();
      int_prj.end = FALSE;
      ZERO(int_prj);

#ifdef DEBUG_TYPEDEF
      /* Used for debugging typedef processing. */
      typedef_symbol_table_dump();
#endif

      /* Tell yacc to stop. */
      ret_val = 1;
   }

   return ret_val;
}

/*
   The beginning of a comment has been detected.  Handle until the entire
   comment has been consumed, then give control back over to lex.
*/
static void comment(void)
{
   char c;

   /* If this was just a blank line, it now becomes a comment line. */
   if (line_type == BLANK_LINE)
      line_type = COMMENT_LINE;

   /* Loop until input exhausted or end-of-comment reached. */
   for ( ; (c = input()) != '\0'; )
      if (c == '*')                    /* Could be end-of-comment. */
      {
         char c1;

         if ((c1 = input()) == '/')
            break;                     /* Is end-of-comment. */
         else
            unput(c1);                 /* False alarm.  Not end-of-comment. */
      }
      else if (c == '\n')
      {
         INCR_YYLINENO;

         /* Provide line information then fire the end-of-line trigger. */
         int_lin.number = yylineno;
         int_lin.is_comment = TRUE;
         int_lin.end = TRUE;
         fire_lin();
         ZERO(int_lin);

         /* Reset these BOOLEANs for the next line. */
         found_tab = FALSE;
         found_space = FALSE;

         /* Increment the number-of-comment-lines counter. */
         ++int_mod.lines.com;
      }
}

/*
   Count various things associated with input tokens.  All input, except
   for comments and preprocessor lines pass through here.
*/
static void count(void)
{
   int i;

   for (i = 0; yytext[i] != '\0'; i++)
      switch (yytext[i])
      {
      case '\n':
         /* Provide line information then fire the end-of-line trigger. */
         switch (line_type)
         {
         case BLANK_LINE:
            int_lin.is_white = TRUE;
            ++int_mod.lines.white;
            break;

         case COMMENT_LINE:
            int_lin.is_comment = TRUE;
            ++int_mod.lines.com;
            break;

         case CODE_LINE:
            int_lin.is_exec = TRUE;
            ++int_mod.lines.exec;
            break;

         default:
            fatal(E_LINE_TYPE);
         }
         /* Reset line_type for next line.  Start off assuming blank line. */
         line_type = BLANK_LINE;

         int_lin.number = yylineno;
         int_lin.end = TRUE;
         fire_lin();
         ZERO(int_lin);

         /* Reset these BOOLEANs for the next line. */
         found_tab = FALSE;
         found_space = FALSE;
         break;

      /*
         The next two cases are trying to figure out whether spaces and tabs
         are both being used for indention on the same line--a little pet peeve
         of mine.
      */
      case '\t':
         if (line_type == BLANK_LINE && found_space)
            int_lin.is_mixed_indent = TRUE;
         found_tab = TRUE;
         break;

      case ' ':
         if (line_type == BLANK_LINE && found_tab)
            int_lin.is_mixed_indent = TRUE;
         found_space = TRUE;
         break;

      default:
         /*
            If not one of the above, special characters, there must be code on
            this line.
         */
         if (isgraph(yytext[i]))
            line_type = CODE_LINE;
      }
}

/*
   Return whether the token in yytext[] is just an identifier or is a
   previously typedef'd name.
*/
static int check_type(void)
{
   int type;

   /*
      looking_for_tag is set to TRUE only when the parser is looking for a
      struct, union, or enum tag.  Since tags are in a separate name space,
      the current lexeme can never be a typedef type name and are therefore
      always an identifier.
   */
   if (looking_for_tag)
      type = TK_IDENTIFIER;
   else
      /*
         If lexeme was previously defined as a typedef type name, return
         token for type name, else return token for identifier.  Note that
         the parser puts identifiers in the typedef symbol table, not the
         lexer.
      */
      type = typedef_symbol_table_find(yytext) ? TK_TYPE_NAME : TK_IDENTIFIER;

   return type;
}

/* Return whether the specified keyword is the current keyword. */
BOOLEAN keyword(char *name)
{
   return strcmp(current_keyword, name) == 0;
}

/* Return whether the specified identifier is the current identifier. */
BOOLEAN identifier(char *name)
{
   return strcmp(current_identifier, name) == 0;
}

/* Return pointer to current input token (lexeme). */
char *token(void)
{
   return yytext;
}

/* Return pointer to input buffer which contains current line. */
char *line(void)
{
#if READ_LINE
   return input_line;
#else
   return "";
#endif
}

/*
   Return string with marker character indicating current position of parser.
   Note that this line always ends with a newline character.
*/
char *marker(void)
{
#if READ_LINE
   static char marker_str[INPUT_LINE_MAX_LEN];
   char *dst_p, *src_p;

   /* Replace all graphic characters in input buffer with space character. */
   for (dst_p = marker_str, src_p = input_line;
         src_p < next_char_p && *src_p != '\0' &&
         /* Leave room for marker character, newline, and '\0'. */
         dst_p < marker_str + sizeof marker_str - 2;
         ++dst_p, ++src_p)
      *dst_p = isgraph(*src_p) ? ' ' : *src_p;

   if (dst_p == marker_str)
      strcpy(dst_p, "\n");       /* Nothing scanned in yet, so can't mark. */
   else
      strcpy(&dst_p[-1], "-\n"); /* Terminate line with marker character. */

   return marker_str;
#else
   return "";
#endif      /* #if READ_LINE */
}

/* Fire the lex trigger with nonstandard set to TRUE. */
static void found_nonstandard(void)
{
   int_lex.nonstandard = yytext[0];
   fire_lex();
   ZERO(int_lex);
}

/* Extract and return the line number out of the #line directive. */
static unsigned extract_line_number(char *string)
{
   return (unsigned)strtol(&string[strcspn(string, "0123456789")], NULL, 10);
}

/*
   Extract and return the file name out of the #line directive. If not present,
   return NULL.
*/
static char *extract_file_name(char *string)
{
   char *start_of_file_name;

   /* File name is enclosed in quotes. Return NULL if no first quote. */
   start_of_file_name = strchr(string, '"');
   if (start_of_file_name != NULL)
   {
      char *end_of_file_name;

      ++start_of_file_name;      /* Skip past first quote. */

      /* If no trailing quote, return NULL. */
      end_of_file_name = strchr(start_of_file_name, '"');
      if (end_of_file_name == NULL)
         start_of_file_name = NULL;
      else
      {
         size_t file_name_length;
         static char return_buffer[MTR_YYTEXT_SIZE];

         file_name_length = end_of_file_name - start_of_file_name;

         /* Copy file name between quotes. */
         strncpy(return_buffer, start_of_file_name, file_name_length);
         return_buffer[file_name_length] = '\0';

         /* Buffer is static, so it's still viable after returning. */
         start_of_file_name = return_buffer;
      }
   }

   return start_of_file_name;
}
