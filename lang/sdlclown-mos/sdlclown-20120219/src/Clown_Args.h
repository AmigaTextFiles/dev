/*
   Clown Script Interpreter
      v0.2.5 - Public
    Written by Bl0ckeduser
*/

#ifndef _CHECKFORARG_H
#define _CHECKFORARG_H

extern int CheckForArg(int argc, char** argv, char* target);
extern char* GetFileArg(int argc, char** argv, int id);
extern int FileArgs(int argc, char** argv);
extern int ValidateClownArgs(int argc, char** argv);

#endif

