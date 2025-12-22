/*rx
 *  gcc.rexx --- ARexx shell to setup needed stack for GCC.
 *  By Loren J. Rittle (l-rittle@uiuc.edu)   Sat Feb 29 21:05:54 1992
 *  Updated to work with any AmigaOS shell - Wed Mar  4 00:11:16 1992
 *
 *  In order to keep this file in usr:bin (instead of REXX: or S:)
 *  you must:
 *	; If this file is not in usr:bin, then preform this step.
 *	copy <this_file> usr:bin/gcc.rexx
 *
 *	; It is important to rename gcc so it is not called by accident
 *	; if this wrapper is not invoked before gcc (If you don't rename
 *	; gcc, this could be the case if the alias is not expanded).
 *	rename usr:bin/gcc usr:bin/gcc-driver
 *
 *	; Preform this step if your shell needs the script bit set
 *	; in order to recognize ARexx programs.
 *	protect usr:bin/gcc.rexx +s
 *
 *	; put the next line in your shell startup file.
 *	alias gcc usr:bin/gcc.rexx
 */

/* You may want to set gcc_stack_size larger or smaller.
   Markus uses 250000, I use 300000.  I would not go below 250000. */
gcc_stack_size = 300000

/* NO GENERAL USER MODIFIABLE PARTS BELOW THIS COMMENT. */

if address() == 'REXX' then /* running from dumb (wrt ARexx) shell, better */
  address 'COMMAND'         /* redirect where command get issued to */

if address() == 'COMMAND' then
  normal_stack_size = pragma('s', gcc_stack_size)
else
  do
    normal_stack_size = pragma('s', 4000)
    'stack' gcc_stack_size
  end

'usr:bin/gcc-driver' arg(1)

if address() == 'COMMAND' then
  call pragma('s', normal_stack_size)
else
  'stack' normal_stack_size
