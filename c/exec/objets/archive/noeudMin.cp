// NoeudMin: Vendredi 14-Août-92 par Gilles Dridi

#include <exec/typesF.h>
#include <debogue/ES.h>
#include <exec/noeudMin.h>

NoeudMin::NoeudMin(): Succ(NUL), Pred(NUL) {
#if DEBOGUE
   sode->puisJe();
   *sode<<long(this)<<": NoeudMin.NoeudMin() {}\n";
   sode->vasY();
#endif
}
