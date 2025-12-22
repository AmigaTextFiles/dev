// EnsReqMem: Jeudi 31-Déc-92 par Gilles Dridi

#include <exec/typesF.h>
#include <debogue/ES.h>
#include <exec/ensReqMem.h>

EnsReqMem::EnsReqMem(TEXTE *nomEns): (nomEns, TN_MEMOIRE) {
#if DEBOGUE
   sode->puisJe();
   *sode<<long(this)<<": EnsReqMem.EnsReqMem("<<nomEns<<") {}\n";
   sode->vasY();
#endif
}
