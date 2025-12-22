
//Test prog

.global _DSPstart
.global _input1
.global _input2
.global _in3
.global _in4
.global _output1
.global _output2
.global _output3
.global _output4
.global _output5
.global _out5
.global _out6
.global _out7
.global _inf1
.global _inf2
.global _outf1
.extern DSP_do_add
.extern DSP_do_sub
.extern DSP_do_mul
.extern DSP_do_div
.extern DSP_do_mod
.extern DSP_do_ashr
.extern DSP_do_lshr
.extern DSP_do_shl
.extern DSP_do_fdiv

_DSPstart:
	nop
	sp = 0x5003e000	//move sp to safe place = RAM1
	r1 = _input1
	2*nop
	r1 = *r1
	r2 = _input2
	2*nop
	r2 = *r2
	nop
	*sp++=r2
	2*nop
	*sp++=r1
	r1=DSP_do_add
	call r1 (r18)
	nop
	sp=sp-8
	r3 = _output1
	*r3 = r1
		
	r1 = _input1
	2*nop
	r1 = *r1
	r2 = _input2
	2*nop
	r2 = *r2
	nop
	*sp++=r2
	2*nop
	*sp++=r1
	r1=DSP_do_sub
	call r1 (r18)
	nop
	sp=sp-8
	r3 = _output2
	*r3 = r1
	
	r1 = _input1
	2*nop
	r1 = *r1
	r2 = _input2
	2*nop
	r2 = *r2
	nop
	*sp++=r2
	2*nop
	*sp++=r1
	r1=DSP_do_mul
	call r1 (r18)
	nop
	sp=sp-8
	r3 = _output3
	*r3 = r1

	r1 = _input1
	2*nop
	r1 = *r1
	r2 = _input2
	2*nop
	r2 = *r2
	nop
	*sp++=r2
	2*nop
	*sp++=r1
	r1=DSP_do_div
	call r1 (r18)
	nop
	sp=sp-8
	r3 = _output4
	*r3 = r1

	r1 = _input1
	r1 = *r1
	r2 = _input2
	r2 = *r2
	nop
	*sp++=r2
	2*nop
	*sp++=r1
	r1=DSP_do_mod
	call r1 (r18)
	nop
	sp=sp-8
	r3 = _output5
	*r3 = r1

	r1 = _in3
	r1 = *r1
	r2 = _in4
	r2 = *r2
	nop
	*sp++=r2
	*sp++=r1
	r1=DSP_do_ashr
	call r1 (r18)
	nop
	sp=sp-8
	r3 = _out5
	*r3 = r1

	r1 = _in3
	r1 = *r1
	r2 = _in4
	r2 = *r2
	nop
	*sp++=r2
	*sp++=r1
	r1=DSP_do_lshr
	call r1 (r18)
	nop
	sp=sp-8
	r3 = _out6
	*r3 = r1

	r1 = _in3
	r1 = *r1
	r2 = _in4
	r2 = *r2
	nop
	*sp++=r2
	*sp++=r1
	r1=DSP_do_shl
	call r1 (r18)
	nop
	sp=sp-8
	r3 = _out7
	*r3 = r1

	r1 = _inf2
	3*nop
	a0 = dsp(*r1)
	3*nop
	*r1 = a0
	r2 = _inf1
	a0 = dsp(*r2)
	nop
	*r2 = a0
	r1 = *r1
	2*nop		//Latency 1
	r2 = *r2
	nop			//pipelined load from mem
	*sp++=r2
	*sp++=r1
	r1=DSP_do_fdiv
	call r1 (r18)
	nop
	sp=sp-8
	r3 = _outf1
	*r3 = a0 = ieee(a0)
	3*nop		//Latency 1
	waiti
	nop
	nop
	nop

_input1:	long 0
_input2:	long 0
_in3:		long 0
_in4:		long 0
_output1:	long 0
_output2:	long 0
_output3:	long 0
_output4:	long 0
_output5:	long 0
_out5:		long 0
_out6:		long 0
_out7:		long 0
_inf1:		long 0
_inf2:		long 0
_outf1:		long 0
