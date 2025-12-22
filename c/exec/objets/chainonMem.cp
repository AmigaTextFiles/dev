// ChainonMem: Jeudi 31-Déc-92 par Gilles Dridi

#include <exec/typesF.h>
#include <debogue/ES.h>
#include <exec/chainonMem.h>

ChainonMem::ChainonMem(): Suivant(NUL), Taille(tailleDe(ChainonMem)) {
#if DEBOGUE
   sode->puisJe();
   *sode<<long(this)<<": ChainonMem.ChainonMem() {}\n";
   sode->vasY();
#endif
}

