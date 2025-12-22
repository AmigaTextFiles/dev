/* Small program to test PoolWatch
 */

#define _USE_SYSBASE
#include <exec/types.h>
#include <exec/execbase.h>
#include <exec/memory.h>

#include <clib/exec_protos.h>

#include <pragmas/exec_pragmas.h>

#include <dos.h>

void kprintf(STRPTR, ...);

void main(void)
{
	APTR	pool, mem2;

	putreg(REG_D0, 0x12345678);
	putreg(REG_D1, 0x23456781);
	putreg(REG_D2, 0x34567812);
	putreg(REG_D3, 0x45678123);
	putreg(REG_D4, 0x56781234);
	putreg(REG_D5, 0x67812345);
	putreg(REG_D6, 0x78123456);
	putreg(REG_D7, 0x81234567);
	putreg(REG_A0, 0x12345678);
	putreg(REG_A1, 0x23456781);
	putreg(REG_A2, 0x34567812);
	putreg(REG_A3, 0x45678123);
	putreg(REG_A4, 0x56781234);
	putreg(REG_A5, 0x45678123);
	putreg(REG_A6, 0x56781234);

	if(pool = CreatePool(MEMF_PUBLIC, 2048, 1024))
	{
		mem2 = AllocPooled(pool, 123);

		((UBYTE *)mem2)[123] = 44;
		((UBYTE *)mem2)[-23] = 4;
		((UBYTE *)mem2)[142] = 55;
		FreePooled(pool, mem2, 321);
		DeletePool(pool);
	}
	else kprintf("argh\n");
}
