/* compile with lc -L+lib:debug.lib dsptest */

#include <exec/types.h>
#include <proto/exec.h>
#include <hardware/cia.h>
#include <stdio.h>

extern struct CIA ciaa;

union float_int {
	float f;
	int i;
};

extern unsigned int DSPstart;
extern int input1;
extern int input2;
extern int in3, in4;
extern int output1;
extern int output2;
extern int output3;
extern int output4;
extern int output5;
extern int out5, out6, out7;
extern float inf1, inf2;
extern float outf1;

/* DSP control registers. */
ULONG * volatile dsp_read = (void *) 0x00dd005C;
UBYTE * volatile dsp_write = (void *) 0x00dd0080;
ULONG * volatile zero = NULL;

//long i,j;


void InitDSP(int dspcode);

int main() {
	printf("Program initiated\n\n");
	input1 = 1900;
	input2 = -13;
	in3 = 0xC0FFEE;
	in4 = 3;
	union float_int infu1;
	union float_int infu2;
	union float_int outfu;
	infu1.f = 35.2345;
	infu2.f = 3.1415926;

	inf1 = infu1.f;
	inf2 = infu2.f;

	printf("M68k wants to know what is %d + %d?\n",input1, input2);

	//Call DSP
	InitDSP((int)&DSPstart);

	outfu.f = outf1;

	printf("DSP3210 says %d\n",(int)output1);
	if(output1==input1+input2)
		printf("M68k says: CORRECT!!\n");
	else {
		printf("M68k says: WTF?!\n");
		printf("Input1: %d, Input2: %d, Output: %d\n",input1,input2,output1);
	}

	printf("M68k wants to know what is %d - %d?\n",input1, input2);
	printf("DSP3210 says %d\n",(int)output2);

	printf("M68k wants to know what is %d * %d?\n",input1, input2);
	printf("DSP3210 says %d\n",(int)output3);

	printf("M68k wants to know what is %d / %d?\n",input1, input2);
	printf("DSP3210 says %d\n",(int)output4);

	printf("M68k wants to know what is %d %% %d?\n",input1, input2);
	printf("DSP3210 says %d\n",(int)output5);
	printf("M68k says %d %% %d is: %d\n",input1, input2, input1 % input2);

	printf("M68k wants to know what is (arithmetic) %x >> %d?\n",in3, in4);
	printf("DSP3210 says %x\n",(int)out5);

	printf("M68k wants to know what is (logical) %x >> %d?\n",in3, in4);
	printf("DSP3210 says %x\n",(int)out6);

	printf("M68k wants to know what is %x << %d?\n",in3, in4);
	printf("DSP3210 says %x\n",(int)out7);

	printf("M68k wants to know what is %d.%04d / %d.%04d?\n",(int)infu2.f,(int)((infu2.f-(int)infu2.f)*10000),(int)infu1.f,(int)((infu1.f-(int)infu1.f)*10000));
	printf("DSP3210 says %d.%04d\n",(int)outfu.f,(int)((outfu.f-(int)outfu.f)*10000));

    return 0;
}

void SetCtrl(ULONG val) {
	short i;
	ULONG mask = 0x4c;

	do {
		*dsp_write = (UBYTE)(val & 0xff);

		for (i = 0; i<256; ++i);
		if ((*dsp_read & mask) == (val & mask)) break;
		printf("**Control Write Failure: $%2lx != $%2lx\n",*dsp_read & mask,val & mask);
	} while (TRUE);
}

#define BASICWAIT 100000
#define RETRYTHRESHOLD 10

BOOL WakeupWait(int dspcode) {
	ULONG count;
	short tcnt = 0;

	do {
		count = 0;
		do {
			if (*zero != (ULONG)dspcode) break;
			++count;
		} while (count < BASICWAIT);
		if (*zero != (ULONG)dspcode) return TRUE;

		printf(" -- wakeup timeout\n");
		if (++tcnt > RETRYTHRESHOLD) return FALSE;
	} while (TRUE);
}

void InitDSP(int dspcode) {
	long i, j;

	*zero = (LONG) dspcode; //set address to execute from

	SetCtrl(0x7fL); /* Set up for DSP in reset */

	for (i = 0; i < 1000; i++) /* Give it a small but reliable pulse */
		j = ciaa.ciapra;

	SetCtrl(0xff); /* Take DSP out of reset */
	SetCtrl(0xfd); /* cause int1 on dsp */
	if (!WakeupWait(dspcode)) { /* Wait for DSP to wake up */
		printf(" ** DSP failed to wakeup\n");
		//exit(EXIT_FAILURE);
		return;
	}
	
}

