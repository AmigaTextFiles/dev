#include <stdio.h>
#include <exec/libraries.h>

struct glutreg
{
	int size;
	void (*func_exit)(int);
	struct Library* glbase;
	struct Library* glubase;
};
#ifdef __cplusplus
extern "C" {
#endif
#ifdef __GNUC__
void registerGLUT(struct glutreg *ptr __asm("a0"));
#else
void registerGLUT(struct glutreg *ptr);
#endif
extern void exit(int);
#ifdef __cplusplus
}
#endif
