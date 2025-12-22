OPT MODULE
OPT EXPORT

MODULE 'exec/types'

/*
 * Structure which is used on the PPC side to call
 * AmigaOS library functions or sub routines.
 *
 */

/*****************************/
/* About the CacheMode field */
/*****************************/

/*
 * For calling functions from the PPC under M68k AmigaOS or for
 * calling functions on the PPC Supervisor mode you have to care
 * for the cache issues. Please read the Cache chapter in the
 * docs/powerup.guide about the cache problems involved.
 * If you do something wrong here you can expect that you loose
 * data, get wrong data or simply crash the machine.
 *
 * IF_CACHEFLUSHNO:
 * You use this mode for the cpu if your function
 * touches no memory both cpus use.
 *
 * Example: Close(File)
 *          If you call this function by the PPC there`s no need
 *          to flush the cache because the PPC isn`t allowed to
 *          touch any memory which has to do with the File BPTR.
 * ATTENTION:
 *          The PPC MUST NOT be used to poke into AmigaOS system
 *          structures.
 *
 * IF_CACHEFLUSHALL:
 * You use this mode for the cpu if your function
 * touches memory both cpus use and it`s no simple memory area
 * which may be flushed individually. This should be used by default.
 *
 * Example: OpenWindowTagList(NewWindow,TagList)
 *          Here you pass a complex data structure which may use
 *          memory areas at several different areas.
 *
 * IF_CACHEFLUSHAREA:
 * You use this mode for the cpu if your function
 * touches memory both cpus use and it`s a memory area which isn`t
 * very big. It depends on the size and how many lines are dirty
 * if this is faster than IF_CACHEFLUSHALL.
 * With the Start and Length fields of each cpu you can define
 * the area.
 *
 * Example: Write(File,Address,Length)
 *          When the PPC runs this function the PPC must make sure
 *          that all data in the to be written memory area is in
 *          in the memory and not only in the cache.
 *
 * IF_CACHEINVALIDAREA: (V45)
 * You use this mode for the cpu if your function
 * touches memory both cpus use and it`s a memory area where you
 * don`t care for valid data anymore.
 * With the Start and Length fields of each cpu you can define
 * the area.
 *
 * Example: Read(File,Address,Length)
 *          When the PPC runs this function the PPC has no need
 *          anymore for anything which is in its cache for the
 *          area the Address and Length define, so you could
 *          invalidate this instead of doing a cacheflush which
 *          may write back dirty lines.
 *          Be VERY careful about this.
 *
 * ATTENTION! The Address must be 32Byte aligned, so you should always
 * use PPCAllocMem for data which is used on the M68k and PPC
 * You are NOT allowed to use normal pools for exchanging data between
 * the M68k and PPC.
 *
 * IF_ASYNC: (V45)
 * If you use this flag, the function is called asynchronous and
 * the PPC doesn`t have to wait for a result.
 * This flag is only checked in the M68kCacheMode field.
 * This also means that the result of the PPCCall#? function
 * is meaningless.
 * Normally this flag doesn`t really fit into a CacheMode flag, but
 * well..too bad i haven`t declared another flag field there.
 */

OBJECT caos

     offset:LONG
     m68kcachemode:LONG
     m68kstart:PTR TO LONG
     m68klength:LONG
     ppccachemode:LONG
     ppcstart:PTR TO LONG
     ppclength:LONG
     d0:LONG
     d1:LONG
     d2:LONG
     d3:LONG
     d4:LONG
     d5:LONG
     d6:LONG
     d7:LONG
     a0:LONG
     a1:LONG
     a2:LONG
     a3:LONG
     a4:LONG   
     a5:LONG
/*
 * here you have to put the LibBasePtr if you want
 * to call a Library.
 */
     a6:LONG
ENDOBJECT

CONST     IF_CACHEFLUSHNO =        0,
          IF_CACHEFLUSHALL =       1,   
          IF_CACHEFLUSHAREA =      2,
          IF_CACHEINVALIDAREA =    4,
          IF_ASYNC  =         $10000



/*
 * Structure which is used on the M68k side to run
 * a Kernal Supervisor ElfObject. During this time
 * the multitasking on the PPC stops
 * PPCRunKernalModule() ONLY !!!!!!!!!!!!!!!!!!!!!
 * If you set IF_CACHEASYNC in PPCCacheMode the operation
 * doesn`t return a valid result as it`s asynchron.
 */

OBJECT moduleargs

     m68kcachemode:LONG
     m68kStart:PTR TO LONG
     m68kLength:LONG
     ppccachemode:LONG
     ppcstart:PTR TO LONG
     ppclength:LONG

     arg1:LONG
     arg2:LONG
     arg3:LONG
     arg4:LONG
     arg5:LONG
     arg6:LONG
     arg7:LONG
     arg8:LONG
     farg1:LONG
     farg2:LONG
     farg3:LONG
     farg4:LONG
     farg5:LONG
     farg6:LONG
     farg7:LONG
     farg8:LONG
ENDOBJECT


