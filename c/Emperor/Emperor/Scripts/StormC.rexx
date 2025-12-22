/* $VER: Emperor_StormC.script 4.5  (7.10.2002)  */
/* written anno 2000-2002 by Matthias Gietzelt   */
/* script to:                                    */
/* + open                                        */
/* + compile                                     */
/* + debug                                       */
/* + run a program by CLI                        */
/* + run a program by StormC                     */

PARSE ARG mode file

/* defined procedures */
open_project        = 0
compile_project     = 1
debug_project       = 2
execute_by_CLI      = 3
execute_by_StormRun = 4

if show('P', "STORMSHELL") then do
   select
      when mode = open_project then do
         address stormshell 'OPEN ' || file || '.¶'
         end
      when mode = compile_project then do
         address stormshell 'MAKE'
         end
      when mode = debug_project then do
         address stormshell 'DEBUG FILE ' || file || '.c'
         end
      when mode = execute_by_CLI then do
         address command "Run >NIL: " || file
         end
      when mode = execute_by_StormRun then do
         address stormrun 'RUN ' || file
         end
      otherwise nop
   end
end

exit
