/*
 *  LIB.C
 *
 *  Basic Library Resource Handling
 *
 *  NOTE: all data declarations should be initialized since we skip
 *        normal C startup code (unless initial value is don't care)
 *
 *  WARNING: arguments are passed in certain registers from the assembly
 *        tag file, matched to how they are declared below.  Do not change
 *        the argument declarations!
 */

#include "defs.h"

#pragma libbase APIBase

Prototype struct Library * LibCall LibInit   (REG(d0) BPTR segment);
Prototype struct Library * LibCall LibOpen   (REG(d0) long version, REG(a0) struct Library *lib);
Prototype long             LibCall LibClose  (REG(a0) struct Library *lib);
Prototype long             LibCall LibExpunge(REG(a0) struct Library *lib);

struct Library  *LibBase       = NULL;
struct ExecBase *SysBase       = NULL;
struct Library  *DOSBase       = NULL;
struct Library  *IntuitionBase = NULL;

BPTR SegList = 0;

/*
 *    The Initialization routine is given only a seglist pointer.  Since
 *    we are NOT AUTOINIT we must construct and add the library ourselves
 *    and return either NULL or the library pointer.  Exec has Forbid()
 *    for us during the call.
 *
 *    We use an extended library structure to allow identification as an
 *    API client
 */

struct Library * LibCall LibInit(REG(d0) BPTR segment)
{
    struct Library *lib;

    static const long Vectors[] = {

        (long)ALibOpen,
        (long)ALibClose,
        (long)ALibExpunge,
        (long)ALibReserved,
        (long)APIMountClient,
        (long)APICloseClient,
        (long)APIBriefClient,
        (long)APIFree,
        -1
    };

    SysBase = (struct ExecBase *)*(long *)4;

    if (DOSBase = OpenLibrary("dos.library", 0)) {

        if (IntuitionBase = OpenLibrary("intuition.library", 0)) {

            if (LibBase = lib = MakeLibrary((APTR)Vectors, NULL, NULL, sizeof(struct APIBase), NULL)) {

                lib->lib_Node.ln_Type = NT_LIBRARY;
                lib->lib_Node.ln_Name = (char *)LibName;
                lib->lib_Flags        = LIBF_CHANGED | LIBF_SUMUSED;
                lib->lib_Version      = 37;
                lib->lib_Revision     = 0;
                lib->lib_IdString     = (APTR)LibId;

                ((struct APIBase *)lib)->Magic = API_MAGIC;

                SegList = segment;

                AddLibrary(lib);

                //InitC();

                return(lib);
            }
        }
    }

    return(NULL);
}

/*
 *    Open is given the library pointer and the version request.  Either
 *    return the library pointer or NULL.  Remove the DELAYED-EXPUNGE flag.
 *    Exec has Forbid() for us during the call.
 */

struct Library * LibCall LibOpen(REG(d0) long version, REG(a0) struct Library *lib)
{
    ++lib->lib_OpenCnt;

    lib->lib_Flags &= ~LIBF_DELEXP;

    return(lib);
}

/*
 *    Close is given the library pointer and the version request.  Be sure
 *    not to decrement the open count if already zero.  If the open count
 *    is or becomes zero AND there is a LIBF_DELEXP, we expunge the library
 *    and return the seglist.  Otherwise we return NULL.
 *
 *    Note that this routine never sets LIBF_DELEXP on its own.
 *
 *    Exec has Forbid() for us during the call.
 */

long LibCall LibClose(REG(a0) struct Library *lib)
{
    if (lib->lib_OpenCnt && --lib->lib_OpenCnt)
        return(NULL);

    if (lib->lib_Flags & LIBF_DELEXP)
        return(LibExpunge(lib));

    return(NULL);
}

/*
 *    We expunge the library and return the Seglist ONLY if the open count
 *    is zero.  If the open count is not zero we set the DELAYED-EXPUNGE
 *    flag and return NULL.
 *
 *    Exec has Forbid() for us during the call.  NOTE ALSO that Expunge
 *    might be called from the memory allocator and thus we CANNOT DO A
 *    Wait() or otherwise take a long time to complete (straight from RKM).
 *
 *    Apparently RemLibrary(lib) calls our expunge routine and would
 *    therefore freeze if we called it ourselves.  As far as I can tell
 *    from RKM, LibExpunge(lib) must remove the library itself as shown
 *    below.
 */

long LibCall LibExpunge(REG(a0) struct Library *lib)
{
    if (lib->lib_OpenCnt) {

        lib->lib_Flags |= LIBF_DELEXP;
        return(NULL);
    }

    Remove(&lib->lib_Node);

    FreeMem((char *)lib - lib->lib_NegSize, lib->lib_NegSize + lib->lib_PosSize);

    if (IntuitionBase) {

        CloseLibrary((struct Library *)IntuitionBase);
        IntuitionBase = NULL;
    }

    if (DOSBase) {

        CloseLibrary((struct Library *)DOSBase);
        DOSBase = NULL;
    }

    return((long)SegList);
}

