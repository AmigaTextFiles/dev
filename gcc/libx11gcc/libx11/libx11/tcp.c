/* Copyright (c) 1996 by Terje Pedersen.  All Rights Reserved   */
/*                                                              */
/* By using this code you will agree to these terms:            */
/*                                                              */
/* 1. You may not use this code for profit in any way or form   */
/*    unless an agreement with the author has been reached.     */
/*                                                              */
/* 2. The author is not responsible for any damages caused by   */
/*    the use of this code.                                     */
/*                                                              */
/* 3. All modifications are to be released to the public.       */
/*                                                              */
/* Thats it! Have fun!                                          */
/* TP                                                           */
/*                                                              */

/***
   NAME
     tcp
   PURPOSE
     
   NOTES
     
   HISTORY
     terjepe - May 30, 1996: Created.
***/
#include <stdio.h>
#define DEBUGXEMUL_WARNING 1

listen(){/*                  File 'ftp.o' */
#if (DEBUGXEMUL_ENTRY) || (DEBUGXEMUL_WARNING)
  printf("WARNING: listen\n");
#endif
  return(0);
}

gethostbyname(){/*           File 'remote.o' */
#if (DEBUGXEMUL_ENTRY) || (DEBUGXEMUL_WARNING)
  printf("WARNING: gethostbyname\n");
#endif
  return(0);
}

accept(){/*                  File 'ftp.o' */
#if (DEBUGXEMUL_ENTRY) || (DEBUGXEMUL_WARNING)
  printf("WARNING: accept\n");
#endif
  return(0);
}

connect(){/*                 File 'tcp.o' */
#if (DEBUGXEMUL_ENTRY) || (DEBUGXEMUL_WARNING)
  printf("WARNING: connect\n");
#endif
  return(0);
}

getsockname(){/*             File 'ftp.o' */
#if (DEBUGXEMUL_ENTRY) || (DEBUGXEMUL_WARNING)
  printf("WARNING: getsockname\n");
#endif
  return(0);
}

socket(){/*                  File 'ftp.o' */
#if (DEBUGXEMUL_ENTRY) || (DEBUGXEMUL_WARNING)
  printf("WARNING: socket\n");
#endif
  return(0);
}

inet_addr(){/*               File 'tcp.o' */
#if (DEBUGXEMUL_ENTRY) || (DEBUGXEMUL_WARNING)
  printf("WARNING: inet_addr\n");
#endif
  return(0);
}

bind(){/*                    File 'ftp.o' */
#if (DEBUGXEMUL_ENTRY) || (DEBUGXEMUL_WARNING)
  printf("WARNING: bind\n");
#endif
  return(0);
}

