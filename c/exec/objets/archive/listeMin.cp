// ListeMin: Samedi 15-Août-92 par Gilles Dridi

#include <exec/typesF.h>
#include <debogue/ES.h>
#include <exec/listeMin.h>

ListeMin::ListeMin() {
#if DEBOGUE
   sode->puisJe();
   *sode<<long(this)<<": ListeMin.ListeMin() {\n";
   sode->vasY();
#endif
   NewList(moiMeme);
#if DEBOGUE
   sode->puisJe();
   *sode<<"}\n";
   sode->vasY();
#endif
}

