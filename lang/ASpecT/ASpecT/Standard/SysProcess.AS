{
 ==
 == Operations to run other programs / split processes
 == Version 1.0 (3.1.1993, JvH)
 ==
}

SPEC SysProcess =

{ == A sort to 'contain' a process.                                        }

  SORTS process.


{ == Fork a process (a command with arguments)                             }

  OPNS create_process :: string -> string -> system -> (process,system).


{ == Check if a process if still running                                   }

  OPNS running :: process -> system -> (boolean,process,system).


{ == Check if a process is finished or could not be started                }

  OPNS finished :: process -> system -> (boolean,process,system).


{ == Check if a process is finished after being started. This does         }
{ == NOT check if the process succeeded (we have not idea how this can be  }
{ == done automatically.                                                   }

  OPNS succeeded :: process -> system -> (boolean,process,system).


{ == Check if a process is could not be started                            }

  OPNS failed :: process -> system -> (boolean,process,system).


{ ======================================================================== }

LOCAL

  Boolean +
  String +

  SORTS process ::= failure | ready | running integer string string.


{ OPNS create_process :: string -> string -> system -> (process,system). }
  EQNS create_process Command Arguments System =
          let (PId,System) = fork System. in
          if PId == 0
          then (ready,exec Command Arguments System)
          elsif PId == -1
          then (failure,System)
          else (running PId Command Arguments,System).


{ OPNS running :: process -> system -> (boolean,process,system). }
  EQNS running Stat Sys = let (Finished,Stat,Sys) = finished Stat Sys. in
                          (not Finished,Stat,Sys).


{ OPNS finished :: process -> system -> (boolean,process,system). }
  EQNS finished failure Sys = (true,failure,Sys).
       finished ready   Sys = (true,ready,  Sys).
      $finished Stat    Sys =
         let (Stat,Sys) = update_status Stat Sys. in
         ((Stat == ready) || (Stat == failure),Stat,Sys).


{ OPNS succeeded :: process -> system -> (boolean,process,system). }
  EQNS succeeded Stat Sys = let (Ok,Stat,Sys) = finished Stat Sys. in
         (Ok && (Stat==ready),Stat,Sys).


{ OPNS failed :: process -> system -> (boolean,process,system). }
  EQNS failed Stat Sys = let (Ok,Stat,Sys) = finished Stat Sys. in
         (Ok && (Stat==failure),Stat,Sys).


  OPNS EXTERN fork :: system -> (integer,system).


  OPNS EXTERN exec :: string -> string -> system -> system.


  OPNS EXTERN exist:: integer -> system -> (boolean,system).


  OPNS update_status :: process -> system -> (process,system).
  EQNS update_status (running PId Command Arguments) Sys =
         let (Exist,Sys) = exist PId Sys. in
         (if Exist then running PId Command Arguments else ready,Sys).
      $update_status Stat Sys = (Stat,Sys).


END.
