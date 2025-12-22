/*
   Clown Script Interpreter
      v0.2.5 - Public
    Written by Bl0ckeduser

	modded for fast sdlclown
*/

#include "Clown_HEADERS.h"

/* Manages char** argument lists */

int CheckForArg(int argc, char** argv, char* target)
{
    int i = 0;
    while(++i<=argc)
        if(strcmp(*argv++, target)==0)
            return 1;
    return 0;
}

int FileArgs(int argc, char** argv)
{
    int i = 1;
    int c = 0;
    argv++;		/* skip program name */
    while(++i<=argc)
    {
        if((strchr(*argv, '-')!=*argv || strcmp(*argv, "-")==0)
                && !stringRepresentsNumeral(*argv))
            ++c;
        argv++;
    }
    return c;
}

char* GetFileArg(int argc, char** argv, int id)
{
    int i = 1;
    int c = 0;
    argv++;		/* skip program name */
    while(++i<=argc)
    {
        if((strchr(*argv, '-')!=*argv || strcmp(*argv, "-")==0)
                && !stringRepresentsNumeral(*argv) && ++c==id)
            return *argv;
        argv++;
    }
    return 0;
}

int ValidateClownArgs(int argc, char** argv)
{
    int i = 1;
    argv++;	/* skip program name */
    while(++i<=argc)
    {
        if(**argv=='-')
            if(!( strcmp(*argv, "-h")==0
                    || strcmp(*argv, "-")==0
                    || strcmp(*argv, "-a")==0
                    || strcmp(*argv, "-i")==0
                    || strcmp(*argv, "--version")==0
                    || strcmp(*argv, "--help")==0))
                return i-1;
        argv++;
    }
    return 0;
}

