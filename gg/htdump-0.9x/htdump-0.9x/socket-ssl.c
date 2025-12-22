/***************************************************************************\
**                                                                         **
**  htdump                                                                 **
**                                                                         **
**  Program to make http requests and redirect, save or pipe the output.   **
**  Ideal for automation and debugging.                                    **
**                                                                         **
**                                                                         **
**  By Ren Hoek (ren@arak.cs.hro.nl) Under Artistic License, 2000          **
**                                                                         **
\***************************************************************************/

#define SSL_ENABLED   1       /* Compile OpenSSL with htdump         */

#include "socket.c"
