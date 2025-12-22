{
 ==
 == Operations on the command shell environment
 == Version 1.0 (3.1.1993, JvH)
 ==
}

SPEC SysShell =

{ == While calling a program the user may give some parameters which are   }
{ == split by the command shell into several call arguments. These may be  }
{ == obtained by call_argument. The index is the number of the argument    }
{ == ranging from 1 upwards - results in "" on illegal indices.            }

  OPNS EXTERN call_argument :: integer -> system -> (string,system).


{ == How many arguments are available?                                     }

  OPNS EXTERN call_arguments :: system -> (integer,system).


{ == Combine all arguments to a single string (deliminated by ' ')         }

  OPNS call_argument :: system -> (string,system).
  EQNS { see LOCAL }


{ == the name (path) how the currently running program has been invoced    }

  OPNS EXTERN call_name :: system -> (string,system).


{ == The command shell gives the possibility to set environment variables  }
{ == Their values may be determined by getenv.                             }

  OPNS EXTERN getenv :: string -> system -> (boolean,string,system).


{ == On return a program normally returns a integer to the shell which is  }
{ == used to state an error. set_returnvalue sets this returnvalue which   }
{ == is initially set to 0.                                                }

  OPNS EXTERN set_returnvalue :: integer -> system -> system.


{ == running a program in the shell and wait until its ready. The result   }
{ == is its returnvalue and a boolean to determine if everything is ok     }
{ == refer to SysProcess for non-waiting executions                        }

  OPNS EXTERN execute :: string -> system -> (boolean,integer,system).


{ == get the current working directories name                              }

  OPNS EXTERN getwd :: system -> (boolean,string,system).


{ ======================================================================== }


 LOCAL

  Boolean +
  Integer +
  String +

{ OPNS call_argument :: system -> (string,system). }
  EQNS call_argument S = let (I,S) = call_arguments S. in call_argument0 S I.


  OPNS call_argument0 :: system -> integer -> (string,system).
  EQNS call_argument0 S N = if N < 0 then ("",S) else
          let (Arg,     S) = call_argument N S.
              (PrevArgs,S) = call_argument0 S (N-1).
          in if PrevArgs == ""
             then (Arg,S)
             else (PrevArgs++" "++Arg,S).


END.
