external;

Function SetSignal(newSignals, signalMask : Integer) : Integer;
    External;

const
    SIGBREAKF_CTRL_C = 4096;

{ Tastatureingaben; keyboard inputs }

function Break : boolean;
begin
   if (SetSignal(0, 0) and SIGBREAKF_CTRL_C) = SIGBREAKF_CTRL_C then
      Break := true
   else
      Break := false;
end;
                                           
                        
