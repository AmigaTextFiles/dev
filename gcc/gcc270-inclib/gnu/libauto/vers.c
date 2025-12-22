/* define default version symbols to be just one symbol. That way, we don't
 * blow up dataspace for symbols that aren't really used */

#define MSTRING(x) STRING(x)
#define STRING(x) #x

#define INDIRECT(name) \
  asm (".stabs \"_" STRING(name) "\",11,0,0,0"); \
  asm (".stabs \"___auto_generic_vers\",1,0,0,0");

INDIRECT(LIBRARY_VERS)
