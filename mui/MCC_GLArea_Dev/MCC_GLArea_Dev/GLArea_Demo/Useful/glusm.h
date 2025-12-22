#include <stdio.h>
#include <exec/libraries.h>

struct glureg
{
	int size;
	struct Library* glbase;
};
#ifdef __cplusplus
extern "C" {
#endif
#ifdef __GNUC__
void registerGLU(struct glureg *ptr __asm("a0"));
#else
void registerGLU(struct glureg *ptr);
#endif
// extern void exit(int);
#ifdef __cplusplus
}
#endif

