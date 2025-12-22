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

#ifndef IO_H
#define IO_H

#include "main.h"

class io
{
  private:
  int input_line, input_column, output_line, output_column;
  double icounter, iglobal_counter, ocounter, oglobal_counter;
  bool ready;
  ifstream i;
  ofstream o;

  public:
  char i_name[FILE_NAME_LENGTH], o_name[FILE_NAME_LENGTH];
  char buf[BUF_LENGTH], last_written[LAST_WRITTEN_LENGTH], last_read;
  // io source/destination modifications
  bool input_from_stdin, output_to_stdout, write_over_original,
       first_init, file_open;

  io(char* in, char* out, bool testing=false);
  io();
  ~io();
  void init(char* in, char* out, bool testing=false);
  void done(bool testing=false);
  int get_input_line();
  int get_input_column();
  int get_output_line();
  int get_output_column();
  int in();
  double input_bytes();
  double output_bytes();
  double global_input_bytes();
  double global_output_bytes();
  void out(char c='\0');
  bool ok();
};

#endif
