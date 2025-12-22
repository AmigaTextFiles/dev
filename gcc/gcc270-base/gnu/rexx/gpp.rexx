/*rx
 *  gpp.rexx --- Compile programs, treating .c files as C++.
 *  Translated from /bin/sh script to ARexx for use under the AmigaOS.
 *  By Loren J. Rittle (l-rittle@uiuc.edu)   Sun Mar  1 20:58:36 1992
 *  Updated to work with any AmigaOS shell - Wed Mar  4 00:51:57 1992
 *
 *  In order to keep this file in usr:bin (instead of REXX: or S:)
 *  you must:
 *	; If this file is not in usr:bin, then preform this step.
 *	copy <this_file> usr:bin/gpp.rexx
 *
 *	; Preform this step if your shell needs the script bit set
 *	; in order to recognize ARexx programs.
 *	protect usr:bin/gpp.rexx +s
 *
 *	alias gpp usr:bin/gpp.rexx ;[and/or]
 *	alias g++ usr:bin/gpp.rexx ;[and/or]
 *	alias c++ usr:bin/gpp.rexx ;[whatever suits your fancy... :-]
 */

/* This ARexx scripts assumes that you are also using the gcc.rexx
 * stack setting wrapper script installed in usr:bin.  If this is
 * not the case, change the next line to the correct path to gcc. */
gcc_command = 'usr:bin/gcc.rexx'

/* NO GENERAL USER MODIFIABLE PARTS BELOW THIS COMMENT. */

if address() == 'REXX' then /* running from dumb (wrt ARexx) shell, better */
  address 'COMMAND'         /* redirect where command get issued to */

newargs = ''
quote = 'no'
library = '-lg++'
havefiles = 'no'
speclang = 'no'

do i = 1 to words(arg(1))
  arg = word(arg(1), i)
  if quote == 'yes' then
    do
      newargs = newargs arg
      quote = 'no'
    end
  else
    do
      quote = 'no'
      select
        when arg == '-nostdlib' then
	  do
	    /* Inhibit linking with -lg++. */
	    newargs = newargs arg
	    library = ''
	  end
	when arg == '-Tdata' | arg == '-b' | arg == '-B' | arg == '-V' | ,
	     arg == '-D' | arg == '-U' | arg == '-o' | arg == '-e' | ,
	     arg == '-T' | arg == '-u' | arg == '-I' | arg == '-Y' | ,
	     arg == '-m' | arg == '-L' | arg == '-i' | arg == '-A'  then
	  do
	    newargs = newargs arg
	    /* these switches take following word as argument,
	       so don't treat it as a file name. */
	    quote = 'yes'
	  end
	when arg == '-c' | arg == '-S' | arg == '-E' then
	  do
	    /* Don't specify libraries if we won't link,
	       since that would cause a warning. */
	    newargs = newargs arg
	    library = ''
	  end
	when arg == '-xnone' then
	  do
	    newargs = newargs arg
	    speclang = 'no'
	  end
	when compare(substr(arg,1,2),'-x') == 0 then
	  do
	    newargs = newargs arg
	    speclang = 'yes'
	  end
	when compare(substr(arg,1,1),'-') == 0 then
	  /* Pass other options through; they don't need -x and aren't inputs. */
	  newargs = newargs arg
	otherwise
	  do
	    havefiles = 'yes'
	    /* If file ends in .c or .i, put options around it.
	       But not if a specified -x option is currently active. */
	    if speclang == 'yes' then
	      newargs = newargs arg
	    else
	      do
	        if compare(substr(arg,length(arg)-1),'.c') == 0 then
	          newargs = newargs '-xc++' arg '-xnone'
	        else if compare(substr(arg,length(arg)-1),'.i') == 0 then
	          newargs = newargs '-xc++' arg '-xnone'
	        else
	          newargs = newargs arg
	      end
	  end
      end
    end
end

if havefiles == 'no' then
  do
    parse source . . program_name .
    say program_name ': no input files specified'
    exit 1
  end

gcc_command newargs library
