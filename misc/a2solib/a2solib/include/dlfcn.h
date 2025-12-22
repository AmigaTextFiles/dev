#ifndef _DLFCN_H_
#define _DLFCN_H_

#define RTLD_GLOBAL	0x01
#define RTLD_LOCAL	0x02
#define RTLD_LAZY	0x04
#define RTLD_NOW	0x08

void *dlopen (const char *filename, int flag);
const char *dlerror(void);
void *dlsym(void *handle, char *symbol);
int dlclose (void *handle);
       
#endif //_DLFCN_H_
