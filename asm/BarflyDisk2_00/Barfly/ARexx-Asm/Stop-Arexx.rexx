/************************************************************************
 *
 * Stop_Arexx.basm	copyright (c) 1992, Ralph Schmidt
 *
 * This is an example how to control the arexx port of BASM....
 * If you have further suggestions mail it, because it's my first
 * try with AREXX and so I'm no real expert.
 *
 * Version 1.00:  5.4.1992
 *
 ************************************************************************/



/* This command allows BASM to pass status variables */

Options FailAt 30

options results

/* Activate BASM Arexx port */
address 'rexx_BASM'


options results

	SAY 'Close BASM-Arexx Mode.......'
	bend
exit


