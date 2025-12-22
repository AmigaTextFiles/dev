#include <stdio.h>
#include <dlfcn.h>


int main(int argc, char **argv)
{
	void *handle;
	char *libname;
	
	if (argc > 1)
		libname = argv[1];
	else
		libname = "test.so";
		
	handle = dlopen(libname, 0);
	
	if (handle)
	{
		int (*get_number)(void);
		void (*set_number)(int);
		
		get_number = dlsym(handle, "get_number");
		set_number = dlsym(handle, "set_number");
		
		if (set_number && get_number)
		{
			printf("Number = %d\n", get_number());
			set_number(100);
			printf("Number after set = %d\n", get_number());
		}
		else
		{
			fprintf(stderr, "Can't resolve symbols -- %s\n", dlerror());
		}
		
		dlclose(handle);
	}
	else
	{
		fprintf(stderr, "Can't open %s -- %s\n", libname, dlerror());
	}
}
