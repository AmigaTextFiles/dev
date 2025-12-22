/*
	test for cpuclr

*/

#include <stdio.h>
#include <time.h>
#include <proto/exec.h>
#include <proto/graphics.h>

short __chip test[8194];

struct GfxBase *GfxBase;

void main()
{
	long t1,t2;
	int c=0;

	GfxBase=OldOpenLibrary("graphics.library");
	printf("Starting 5000 BltClears()s...\n");
	test[8191]=-1;
	test[8192]=-1;
	test[8193]=-1;
	Forbid();
	time(&t1);
	for(;c<1000;c++) {
		BltClear(test,6,1);
		BltClear(test,4096,1);
		BltClear(test,128,1);
		BltClear(test,16384,5 + (0xaaaa<<16));
		BltClear(test,64 + (256<<16),3);
	}
	time(&t2);
	Permit();
	printf("needed %ld secs\n",t2-t1);
	if(test[8191]) printf("8192 hit with %lx\n",(long)test[8191]);
	if(test[8192]!=-1) printf("8193 hit\n");
	if(test[8193]!=-1) printf("8194 hit\n");
}
