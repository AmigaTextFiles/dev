/* sample.h
 * prototypes and pragmas for our functions
 * Note - the linker lib (sample.lib) is not required
 * if pragmas are used.
 */

#ifndef SAMPLE_H
#define SAMPLE_H

/* protos for our sample.library functions */
LONG AddThese(LONG,LONG);
LONG Double(LONG);
/* pragmas for our sample.library functions */
#pragma libcall SampleBase Double 1e 1
#pragma libcall SampleBase AddThese 24 1002

#endif
