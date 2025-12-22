/* New OpenLibrary().
** On error the user is informed and an exception is thrown.
*/

OPT MODULE

MODULE 'intuition/intuition'


/* Opens an library
**  'stri' is the library name
**  'version' is the minimum library version
**  'excepti' is the exception to be thrown on error
**  'info' is the exceptioninfo to be thrown on error. Set it to zero if the
**         library name should be used instead
*/
EXPORT PROC __OpenLibrary(stri,version=0,excepti="LIB",info=0)
DEF base
  IF (base:=OpenLibrary(stri,version))=NIL
    EasyRequestArgs(NIL,
                    [SIZEOF easystruct,
                     0,
                     NIL,
                     'Couldn''t open "%s" v%ld.',
                     'Ok']:easystruct,
                    NIL,
                    [stri,version])
    Throw(excepti,IF info THEN info ELSE stri)
  ENDIF
ENDPROC base

