/****h* AmigaTalk/File.h [1.5] *************************************
*
* NAME
*    File.h
*
* DESCRIPTION
*    Class File definitions - files use standard i/o package
********************************************************************
*
*/

#ifndef  FILE_H
# define FILE_H 1

# ifdef	CPLUS_PLUS

class File {

public:

  File();
  ~File();

  OBJECT *file_read( File& );
  int     putw( int, FILE * );
  int     getw( FILE * );
  void    file_err( char *message );
  void    file_open( File&, char *, char * );
  int     file_write( File&, const OBJECT& );

private:

  int   refcount;
  int   size;
  int   file_mode;
  FILE *fp;

};

# else	/* Orcinary C: */

# ifndef    AMIGATALKSTRUCTS_H
#  include "ATStructs.h"
# endif


/* files can be opened in one of three modes, modes are either
   0 - char mode    - each read gets one char
   1 - string mode  - each read gets a string
   2 - integer mode - each read gets an integer
*/

# define CHARMODE 0
# define STRMODE  1
# define INTMODE  2

# endif		/* CPLUS_PLUS!! */

#endif

/* ---------------------- END of file.h file! ----------------------- */
