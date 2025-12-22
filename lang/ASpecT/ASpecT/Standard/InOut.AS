{
 ==
 == Useful combinations of file operations
 == Version 1.0 (26.12.1992, JvH)
 ==
}

SPEC InOut =

 FORMAL

  SORTS data.


 GLOBAL 
  
  StreamRW +


  OPNS in  :: (string,data,system) -> (boolean,data,system).
  EQNS in (FileName,ErrData,Sys) = 
         let (Ok,In,Sys) = open FileName Sys.
         in if Ok
            then let (Ok,Data,_) = read(ErrData,In).
                 in (Ok,Data,Sys)
            else (Ok,ErrData,Sys).


  OPNS out :: (string,data,system) -> (boolean,system).
  EQNS out (FileName,Data,Sys) =
         let (Ok,Out,Sys) = create FileName Sys.
         in if Ok
            then let (Ok,_) = write(Data,Out).
                 in (Ok,Sys)
            else (Ok,Sys).

END.
