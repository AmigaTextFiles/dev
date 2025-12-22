// NEFO: Vendredi 15-Jan-93 par Gilles Dridi

#include <exec/typesF.h>
#include <debogue/ES.h>
#include <exec/NEFO.h>

NEFO::NEFO(): Nulle(asmNulle),
              Epure(asmEpure),
              Ferme(asmFerme),
              Ouvre(asmOuvre) {
#if DEBOGUE_NEFO
   sode->puisJe();
   *sode<<long(this)<<": NEFO.NEFO() {}\n";
   sode->vasY();
#endif
}
