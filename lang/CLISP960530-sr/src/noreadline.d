# Ein Ersatz für die GNU readline()-Library.
# Bruno Haible 23.4.1995

#include "lispbibl.c"

#if defined(GNU_READLINE) && 0 # funktioniert nur mit readline, nicht newreadline
  #define READLINE_LIBRARY # Hinweis, wo die Include-Files gesucht werden müssen
  #include "readline.h"
  #undef READLINE_LIBRARY
#else
  typedef int Function ();
  typedef void VFunction ();
  typedef char *CPFunction ();
  typedef char **CPPFunction ();
#endif

global int rl_present_p = 0; # readline()-Library nicht vorhanden

global char* rl_readline_name;
global CPPFunction* rl_attempted_completion_function;
global CPFunction* rl_completion_entry_function;

global char* rl_basic_word_break_characters;
global char* rl_basic_quote_characters;
global char* rl_completer_quote_characters;

global char* rl_line_buffer;
global int rl_already_prompted;

global char* readline(prompt)
  var reg1 char* prompt;
  { return NULL; }

global void rl_deprep_terminal()
  { ; }

global char* filename_completion_function(text,state)
  var reg1 char* text;
  var reg1 int state;
  { return NULL; }

global void add_history(line)
  var reg1 char* line;
  { ; }

global VFunction* rl_named_function(string)
  var reg1 char* string;
  { return NULL; }

global int rl_bind_key(key,function)
  var reg1 int key;
  var reg1 VFunction* function;
  { return 0; }

