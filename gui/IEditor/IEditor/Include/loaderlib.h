#ifndef IEDIT_LOADER_H
#define IEDIT_LOADER_H
/*
**      Interface Editor loader definitions.
**
**      (C) Copyright 1996 Simone Tellini
**          All Rights Reserved
*/


/*  Error Codes    */

#define  LOADER_OK              0       /* GUI successfully loaded     */
#define  LOADER_UNKNOWN         1       /* file type not recognized    */
#define  LOADER_IOERR           2       /* read-write error            */
#define  LOADER_UNWELCOME       3       /* e.g. return it if you're    */
                                        /* asked to load a screen      */
                                        /* definition but the user     */
                                        /* selects a gadgets file      */
#define  LOADER_WRONGVERSION    4       /* data file version not       */
                                        /* supported                   */
#define  LOADER_NOMEMORY        5       /* Out of memory               */
#define  LOADER_NOTSUPPORTED    6       /* We're asked to do something */
                                        /* we cannot do                */

#endif
