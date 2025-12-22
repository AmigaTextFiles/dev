;//   test our test.library if it can handle //
;//   stackbased %params ..                  //

#include "test_lib.i"

;// All global stuff must be named with '_' in beginning! //
STRING _testname "test.library"
GVAR   _TestBase

PROC main
   openlibrary  _testname 0 _TestBase
   call _TestBase Delay100
   closelibrary _TestBase
ENDPROC
END
                       // yep! it worked! //
                       
