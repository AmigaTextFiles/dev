/* libdl.a wrapper for elf.library DLOpen() etc
 * (c) 2009 Chris Young <chris@unsatisfactorysoftware.co.uk>
 *
 * to use, you must compile with -ldl -lauto -use-dynld
*/

#ifndef __DLFCN_H
#define __DLFCN_H

#define RTLD_LAZY 0
#define RTLD_LOCAL ELF32_RTLD_LOCAL
#define RTLD_GLOBAL ELF32_RTLD_GLOBAL

#ifdef __cplusplus
extern "C" {
#endif

void *dlopen(const char *,int);
void *dlsym(void *,const char *);
int dlclose(void *);
char *dlerror(void);

#ifdef __cplusplus
}
#endif

#endif
