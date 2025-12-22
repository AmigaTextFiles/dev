IMPLEMENTATION MODULE options;

(*

   by : Greg Mumm

   This module deals with the various user adjustable options available
   to anyone using the program. It's purpose is twofold:  

                1) To allow other modules information as to what the options 
                   are ( i.e. should the "begin" keyword go on the next
                   line ? )

              * 2) To set the option information ("Enter line-length: " )

                    * Future implementation
*)

BEGIN
   
    (* Right now the options are set in m2pascal.mod from the CLI.
       This probably shouldn't be. Oh well. The settings below are
       defaults.
     *) 
   

    OptionsRec . BeginNewLine := FALSE;

END options.
