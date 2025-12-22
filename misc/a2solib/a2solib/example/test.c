#include <proto/exec.h>
#include <stdio.h>
#include "dbg.h"

int some_number = 1234;
int *some_number_ref = &some_number;

void __testlib_init(void) __attribute__((constructor));

void __testlib_init(void)
{
	IExec->DebugPrintF("some test.so constructor\n");
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

