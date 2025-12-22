

// ===================================================================
// 	readargs() - Use ReadArgs() to parse a line.. 
//	will allocate a RDArgs structure and parse your command line
//	into the args pointers you provide. Returns a RDArgs structure,
//	- which *MUST* be freed after use by calling the freeargs()
//	function below - or NULL for failure.
// ===================================================================

struct RDArgs *readargs (
	LONG  args[],		// these will point to the arguments
	LONG  arg_count,	// No. of args (must be more that max arguments)
	UBYTE *buff,		// the buffer to be parsed
	UBYTE *template,	// the command line template
	struct base *bs)	// for the lib bases
{
   struct RDArgs *rdargs;
   LONG len;
   struct DosLibrary *DOSBase;     // define bases since we don't use
   struct ExecBase *SysBase;       // start-up code from the compiler
   DOSBase=bs->dosbase; SysBase=bs->sysbase;

   if (!(rdargs = (struct RDArgs *)AllocDosObject(DOS_RDARGS, NULL)))
      return (NULL);

   // RDArgs() wants the string terminated with a '\n'
   len = strlen(buff);
   buff[len] = '\n';
   rdargs->RDA_Source.CS_Buffer = buff;
   rdargs->RDA_Source.CS_Length = len + 1;
   rdargs->RDA_Buffer = NULL;

   memset ((char *)args, 0, arg_count * sizeof(char *));
   if (!(rdargs = ReadArgs(template, args, rdargs)))
       FreeDosObject (DOS_RDARGS, rdargs);

   buff[len] = '\0'; // restore null
   return (rdargs);  // will be NULL if failure
}

// ===================================================================
// 	Free rdargs which were allocated with the getargs() above
// ===================================================================

void freeargs (struct RDArgs *rdargs, struct base *bs)
{
   struct DosLibrary *DOSBase;
   struct ExecBase *SysBase;
   DOSBase=bs->dosbase; SysBase=bs->sysbase;

   if (rdargs)
   {   FreeArgs (rdargs);
       FreeDosObject (DOS_RDARGS, rdargs);
   }
}









