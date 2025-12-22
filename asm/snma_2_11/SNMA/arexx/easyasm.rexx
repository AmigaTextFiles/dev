/*
    EasyAsm.rexx
    This little ARexx program assembles files using SNMA Arexx host.
    This one uses direct snma output, as opposed to ShellAsm.
    To use, you must set snma to the following state:
    rx "address snma set outfile on rxerr off keepsource off"

    All the flags are not neccessarily required, but certainly useful.
    (See documents, chapter 4.2.7 Arexx/SET for more info).

    When you start snma, you can redirect output file to the "CON:..".
    This is especially important if you use snma from the different Shell
    you started it, as default output would otherwise go to the Shell
    snma was stated from.

*/

if arg() ~= 1 THEN  DO
    say 'Usage: rx ShellAsm.rexx "CMDLINE"'
    exit    5
    end
arg cmd
address SNMA
call Assemble(cmd)
'FREE'                      /* free source, errors..., just in case*/
exit


/*
   Following routine will assemble and display information about it
   Now this one takes one argument , commandline
   "Ram Disk:"
*/
Assemble:

  options RESULTS
  arg cmd
  cmd=strip(cmd,B,'"')            /* strip leading and trailing "s */
  mydir=pragma('d')
  mydir=insert('"',mydir,0)
  mydir=insert('"',mydir,length(mydir))

  'SET  outfile on rxerr off keepsource off'

  CHDIR mydir                     /* change the current directory of the snma */
  say "Calling SNMA: ASM" cmd
  ASM cmd                         /* assemble it */
return  /* End of Assembly */

