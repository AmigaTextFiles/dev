/*******************************************************************************
+
+  LEDA  3.1c
+
+
+  stream.h
+
+
+  Copyright (c) 1994  by  Max-Planck-Institut fuer Informatik
+  Im Stadtwald, 6600 Saarbruecken, FRG     
+  All rights reserved.
+ 
*******************************************************************************/


#ifndef LEDA_STREAM_H
#define LEDA_STREAM_H

#include <LEDA/basic.h>


#if defined (__ZTC__) 

#include <fstream.hpp>
#include <strstream.hpp>

/* bug in ZORTECH library ? 
   cannot derive from streams */

typedef ifstream   file_istream;
typedef ofstream   file_ostream;
typedef istrstream string_istream;
typedef ostrstream string_ostream;


#else  

#include <fstream.h>
#include <strstream.h>

struct file_ostream : public ofstream 
{ file_ostream(string s) : ofstream(~s) {}
  file_ostream(char*  s) : ofstream(s) {}
  bool open(string s)  { ofstream::open(~s); return !fail(); }
 };

struct file_istream : public ifstream
{ file_istream(string s) : ifstream(~s) {}
  file_istream(char*  s) : ifstream(s) {}
  bool open(string s)  { ifstream::open(~s); return !fail(); }
 };

struct string_istream : public istrstream 
{ string_istream(string s) : istrstream(~s) {}
  string_istream(char* s)  : istrstream(s) {}
  string_istream(int argc, char** argv) 
                           : istrstream(~string(argc,argv)) {}

 };


struct string_ostream : public ostrstream 
{ string_ostream() {};
  string str()     { return ostrstream::str(); };
 };


#endif


#if defined(__MSDOS__)

typedef file_ostream cmd_ostream;
typedef file_istream cmd_istream;

#else

struct cmd_ostream : public ofstream 
{ cmd_ostream(string cmd) : ofstream(fileno(popen(~cmd,"w"))) {}
  cmd_ostream(char*  cmd) : ofstream(fileno(popen(cmd,"w"))) {} 
 };

struct cmd_istream : public ifstream 
{ cmd_istream(string cmd) : ifstream(fileno(popen(~cmd,"r"))) {}
  cmd_istream(char*  cmd) : ifstream(fileno(popen(cmd,"r"))) {} 
 };

#endif

#endif

