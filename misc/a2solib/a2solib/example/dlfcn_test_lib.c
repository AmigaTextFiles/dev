#include <proto/exec.h>
#include <stdio.h>
#include <dlfcn.h>

int some_number = 1234;
int *some_number_ref = &some_number;
static void *libhandle = 0;

void (*set_debug_level)(int);
int (*dprintf)(int, char *, ...);

void error_func(void)
{
	fprintf(stderr, "Error: Symbol not found\n");
}

void __testlib_init(void) __attribute__((constructor));
void __testlib_term(void) __attribute__((destructor));

void __testlib_init(void)
{
	libhandle = dlopen("dbg.so", 0);
	if (libhandle)
	{
		set_debug_level = dlsym(libhandle, "set_debug_level");
		if (!set_debug_level)
			set_debug_level = (void (*)(int))error_func;
			
		dprintf = dlsym(libhandle, "dprintf");
		if (!dprintf)
			dprintf = (int (*)(int, char *, ...))error_func;
	}
	else
	{
		set_debug_level = (void (*)(int))error_func;
		dprintf = (int (*)(int, char *, ...))error_func;
	}	
}

void __testlib_term(void)
{
	dlclose(libhandle);
}

void set_number(int x)
{
	dprintf(15, "In set_number(%d)\n", x);
	some_number = x;
}

int get_number(void)
{
	return some_number;
}

int *get_number_ref(void)
{
	return some_number_ref;
}

void *get_func_ref(void)
{
	return &get_number;
}

