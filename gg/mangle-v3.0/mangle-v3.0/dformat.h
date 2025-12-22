/*
 * mangle.cpp - Removes ALL comments and/or formatting from C/C++ code while
 *              keeping what is needed so that the program still operates
 *              the same exact way as before the conversion.
 *
 * This program has been vigourously tested, if you find any logic errors
 * where something should have been taken out that wasn't, please email me
 * - jnewman@oplnk.net
 *
 */

#ifndef DFORMAT_H
#define DFORMAT_H
#include "main.h"

class dformat
{
  private:
  ::io io;
  int current_arg, current_file, argc;
  char** argv;
  bool ready, test_args, tabular_result;
  // boolean variables used in the deformatting process
  bool in_line_comment, in_star_comment, in_single_quote, in_double_quote,
       in_preprocessor, append_newline, leave_newline, comments_only,
       keep_preprocessor_whitespace, no_modify;

  // Private functions
  bool load_arguments(char* str);
  void usage();
  void version();

  public:

  dformat(int argc, char** argv);
  ~dformat();
  bool next();
  void done();
  bool ok();
  bool format();
};

#endif
