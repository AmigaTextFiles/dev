#ifndef PARMS_H
#define PARMS_H

#ifdef __SASC_60   /* SAS/C 6.0 or higher */
#define ANSI_HEADERS 1
#endif

#ifdef _DCC   /* DICE 3.0 */
#define ANSI_HEADERS 1
#endif

#ifdef __GNUC__   /* GCC 2.6.1 */
#define ANSI_HEADERS 1
#endif

#ifdef ANSI_HEADERS
#define __PARMS(s) s
#else
#define __PARMS(s) ()
#endif

#endif
