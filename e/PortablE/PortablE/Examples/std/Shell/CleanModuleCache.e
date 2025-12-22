/* CleanModuleCache.e 21.11.2013 by Christopher Steven Handley.
*/
/*
	This program recursively checks that all cache files correspond to source
	code that still exists, and deletes the cache files if not.  You shouldn't
	normally need to this, as PortablE automatically does this gradually anyway.
*/
MODULE '*CleanModuleCache_shared'

PROC main()
	Print('Cleaning the module cache, please wait...\n')
	cleanModuleCacheCompletely('')
	Print('Finished!\n')
FINALLY
	PrintException()
ENDPROC
