#include <stdio.h>
#include <dlfcn.h>


int main(int argc, char **argv)
{
	void *test_handle;
	void *dbg_handle;
	
	test_handle = dlopen("test2.so", 0);
	if (!test_handle)
		fprintf(stderr, "Can't open test.so -- %s\n", dlerror());
		
	dbg_handle = dlopen("dbg.so", 0);
	if (!dbg_handle)
		fprintf(stderr, "Can't open dbg.so -- %s\n", dlerror());
	
	if (test_handle && dbg_handle)
	{
		int (*get_number)(void);
		void (*set_number)(int);
		int (*dprintf)(int, char *, ...);
		int (*set_debug_level)(int);
		
		get_number = dlsym(test_handle, "get_number");
		set_number = dlsym(test_handle, "set_number");
		dprintf = dlsym(dbg_handle, "dprintf");
		set_debug_level = dlsym(dbg_handle, "set_debug_level");
		
		if (!set_number || !get_number || !dprintf || !set_debug_level)
		{
			fprintf(stderr, "Can't resolve symbols -- %s\n", dlerror());
		}
		else
		{
			set_debug_level(15);
			set_number(10);
			dprintf(1, "Number is %d\n", get_number());
		}		
	}
	
	if (test_handle)
		dlclose(test_handle);
	
	if (dbg_handle);
		dlclose(dbg_handle);

}
