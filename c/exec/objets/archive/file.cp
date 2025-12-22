// File: Samedi 13-Mars-93 par Gilles Dridi

#include <exec/typesF.h>
#include <debogue/ES.h>
#include <exec/file.h>

File::File(): () {
#if DEBOGUE
   sode->puisJe();
   *sode<<long(this)<<": File.File() {}\n";
   sode->vasY();
#endif
}

