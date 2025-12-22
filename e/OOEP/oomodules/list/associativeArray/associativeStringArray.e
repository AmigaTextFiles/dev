OPT MODULE

MODULE 'oomodules/list/associativeArray'

EXPORT OBJECT associativeStringArray OF associativeArray
  /* key will store pointers to strings */
ENDOBJECT

PROC disposeKey(key) OF associativeStringArray IS DisposeLink(key)
PROC testKey(string1, string2) OF associativeStringArray IS OstrCmp(string1, string2)
