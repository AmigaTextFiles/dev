/*****************************************************************************
* 6502D Version 0.1                                                          *
* Bart Trzynadlowski, 1999                                                   *
*                                                                            *
* Feel free to do whatever you wish with this source code provided that you  *
* understand it is provided "as is" and that the author will not be held     *
* responsible for anything that happens because of this software.            *
*                                                                            *
* comline.c: Function(s) for parsing the command line.                       *
*****************************************************************************/

#include <string.h>

/*****************************************************************************
* findarg: This function takes 3 arguments: argc, argv[], and args. The      *
* argc argument contains the number of elements in the argv[] pointer array. *
* args contains the string to find. If the string is found then the argument *
* index for the argument following it is returned to the caller, else 0. If  *
* there is no next argument then 0 is returned as well.                      *
*****************************************************************************/
int findarg(int argc, char *argv[], const char *args)
{
        int i;                  

        argc--;                 /* account for argv[0]: path name */
        if (argc==0)
        {
                return 0;       /* no arguments */
        }

        for (i=1;i<=argc;i++)   /* start at 1 to avoid argv[0] */
        {
                if (!strcmp(argv[i], args))     /* if 0 strings are equal */
                        if (i+1<argc+1)        /* is there another arg? */
                                return i+1;     /* return index */
        }
        return 0;
}

/*****************************************************************************
* singlearg: All input is the same as for the above function. This function  *
* differs in that it does not return the _next_ argument after the one the   *
* programmer wants to find but instead returns 1 if the argument specifies   *
* found and 0 if it is not.                                                  *
*****************************************************************************/
int singlearg(int argc, char *argv[], const char *args)
{
        int i;                  

        argc--;                 /* account for argv[0]: path name */
        if (argc==0)
        {
                return 0;       /* no arguments */
        }

        for (i=1;i<=argc;i++)   /* start at 1 to avoid argv[0] */
        {
                if (!strcmp(argv[i], args))     /* if 0 strings are equal */
                        return 1;               /* return index */
        }
        return 0;
}

