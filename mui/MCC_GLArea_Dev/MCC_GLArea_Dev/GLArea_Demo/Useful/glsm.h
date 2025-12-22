#include <stdio.h>
#include <exec/libraries.h>

struct glreg
{
	int size;
	void (*func_exit)(int);
};

#ifdef __cplusplus
extern "C" {
#endif
#ifdef __GNUC__
void registerGL(struct glreg *ptr __asm("a0"));
#else
void registerGL(struct glreg *ptr);
#endif
// extern void exit(int);
#ifdef __cplusplus
}
#endif
