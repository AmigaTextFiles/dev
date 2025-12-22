/*
  seg1.s

  Compile with -T option.

  reading the segment length and mirror segment
  Uros Platise (c) 1999
*/

/* prepeare new mirror segment in flash memory */
	seg abs=0x100 align=2 flash.gcc_data

/* declare original segment in extended RAM and specify mirror */
	seg mirror=flash.gcc_data eram.gcc_data

/* Program */
	seg flash.code
	reti
	reti
	reti
	reti
	dc.w _eram_gcc_data

/* The first is hardcoded eram.gcc_data segment length */
	seg eram.gcc_data
	dc.w _eram_gcc_data_T - _eram_gcc_data
	ds.b 1

/* Higher order segment used as terminator */
	seg eram.gcc_data.T
