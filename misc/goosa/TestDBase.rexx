/*************************************************************
** TestDBase.rexx Test the DBaseManager for GOOSA
**************************************************************/

Options FailAt 5

if ~show( 'l', "rexxsupport.library" ) then do
   check = addlib( 'rexxsupport.library', 0, -30, 0 )
end

TRACE ALL

ADDRESS "GoosaDBase"

Do

TRACE ON
OPTIONS RESULTS

   'Open RAM:GoosaChk'
   'Read RAM:TempReadFile REQ Req1'
   'Last'
   'GETERRORMSG 2601'
   Str = Result
   Say "Error is:  "||Str
   'Display 5'
   'Close'

RETURN 
