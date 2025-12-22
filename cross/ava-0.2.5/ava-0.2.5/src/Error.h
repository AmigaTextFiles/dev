/* Error.h */

#ifndef __ERROR
#define __ERROR

#include <string.h>
#include <stdio.h>
#include "Lexer.h"
#include "Preproc.h"

/* global structure */
extern TlxData lxdata;

/* Global Error Class - Abstract Type */
class global_error{
public:
  virtual void print(FILE* fd=stderr) = 0;
  virtual ~global_error(){}
  global_error(){}
};

/* Generic Error Class */
class generic_error: public global_error{
public:
  generic_error(const char* msg){errmsg = msg;}
  ~generic_error(){}
  void print(FILE* fd=stderr){fprintf (fd, "%s\n", errmsg);}
private:
  const char* errmsg;
};

/* File Error Class */
class file_error: public global_error{
public:
  file_error (const char *msg){strcpy(errmsg, msg);}
  void print (FILE* fd=stderr){ 
    fprintf(fd, "%s: ",errmsg); perror("");}
  ~file_error (){}
private:
  char errmsg [LX_LINEBUF];
};

/* Lexer Error Class */
class lexer_error: public global_error{
public:
  lexer_error (char _invalid_ch) { invalid_ch = _invalid_ch; mode = 1; }
  lexer_error (const char *_errmsg) { errmsg = _errmsg; mode = 2; }
  void print (FILE* fd=stderr) {
    switch (mode) {
    case 1:
      fprintf (fd, "%s:%ld: Invalid character %c in column %ld.\n", 
	       preproc.name(), preproc.lxline(), invalid_ch, preproc.lxcur());
      break;
    case 2:
      fprintf (fd, "%s:%ld: %s in column %ld.\n",
	       preproc.name(), preproc.lxline(), errmsg, preproc.lxcur());
      break;
    }
  }
  ~lexer_error () {}
private:
  int mode;
  char invalid_ch;
  const char *errmsg;
};

/* Syntax Errors */
class syntax_error: public global_error {
public:
  syntax_error (const char* _errmsg): errmsg(_errmsg),op(NULL),arg(-1) {}
  syntax_error (const char* _errmsg, const char* _op): 
    errmsg(_errmsg),op(_op),arg(-1) {}
  syntax_error (int _arg, const char* _errmsg, const char* _op): 
    errmsg(_errmsg),op(_op),arg(_arg) {}
    
  void print (FILE* fd=stderr) {
    if (op==NULL) {
      fprintf (fd, "%s:%ld: %s\n",
               preproc.name(), preproc.line(), errmsg);
    } else {
      if (arg<0) {
        fprintf (fd, "%s:%ld: %s%s\n", preproc.name(), 
                 preproc.line(), errmsg, op);
      } else {
        fprintf (fd, "%s:%ld: arg(%d): %s'%s'\n", preproc.name(),
	         preproc.line(), arg+1, errmsg, op);
      }
    }
  }    
  ~syntax_error () {} 
private:
  const char* errmsg;
  const char* op;
  int arg;
};

/* Segment Errors */
class segment_error: public global_error {
public:
  segment_error (const char* _errmsg): errmsg(_errmsg),op(NULL),arg(-1) {}
  segment_error (const char* _errmsg, const char* _op): 
    errmsg(_errmsg),op(_op),arg(-1) {}
  segment_error (int _arg, const char* _errmsg, char* _op): 
    errmsg(_errmsg),op(_op),arg(_arg) {}
    
  void print (FILE* fd=stderr) {
    if (op==NULL) {
      fprintf (fd, "%s:%ld: %s\n",
               preproc.name(), preproc.line(), errmsg);
    } else {
      if (arg<0) {
        fprintf (fd, "%s:%ld: %s%s\n", preproc.name(), 
                 preproc.line(), errmsg, op);
      } else {
        fprintf (fd, "%s:%ld: arg(%d): %s'%s'\n", preproc.name(),
	         preproc.line(), arg+1, errmsg, op);
      }
    }
  }
  ~segment_error () {} 
private:
  const char* errmsg;
  const char* op;
  int arg;
};


#endif
