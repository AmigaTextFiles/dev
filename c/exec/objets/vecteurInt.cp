// VecteurInt: Lundi 19-Avr-93 par Gilles Dridi

#include <exec/typesF.h>
#include <debogue/ES.h>
#include <exec/vecteurInt.h>

VecteurInt::VecteurInt(Procedure code, PTRNEANT donnee, Noeud *adrNoeud):
                       Code(code), Donnee(donnee), AdrNoeud(adrNoeud) {
#if DEBOGUE
   sode->puisJe();
   *sode<<long(this)<<": VecteurInt.VecteurInt("<<long(code)<<", "<<
          long(donnee)<<", "<<long(adrNoeud)<<") {}\n";
   sode->vasY();
#endif
}
