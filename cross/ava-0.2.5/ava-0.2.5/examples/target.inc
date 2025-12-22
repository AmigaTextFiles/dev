/*
  target.inc

  An example of how to write target specification file for
  design specific MPU boards.

  Uros Platise (c) 1999
*/

/* Declare Size of the eram segment (before device declaration!) */
#define __ERAM_SIZE	0x1002

/* Declare MCU (AT90S8515 has enabled Wrap Around Option) */
#arch AT90S8515

/* Memory mapped IO ports of my test board */
#define _IO_PORTS	0x1000

/* Declare segments. Protect eram segment to clash with
   the following port io registers. */
seg abs=_IO_PORTS size=0x2 eram.ioports

#define ADC_DATA	_IO_PORTS
#define ADC_CONTROL	_IO_PORTS+1
