/*****************************************************************************

 ReadArgs support

 *****************************************************************************/

OPT MODULE
OPT EXPORT

MODULE 'dos/rdargs'

OBJECT funcArgs
    rdArgs:PTR TO rdargs        -> RDArgs structure
    rdArgsRes:PTR TO rdargs     -> Return from ReadArgs()
    argString:PTR TO CHAR       -> Copy of argument string (with newline)
    argArray:PTR TO LONG        -> Argument array pointer
    arguments:PTR TO LONG       -> Argument array you should use
    count:INT                   -> Number of arguments
    doneArgs:INT                -> DOpus uses this flag for its own purposes
ENDOBJECT
