// Noeud: Vendredi 14-Août-92 par Gilles Dridi

#include <exec/typesF.h>
#include <debogue/ES.h>
#include <exec/noeud.h>

Noeud::Noeud(TEXTE *nom, Type_Noeud type, OCTET prio):
             (), Nom(nom), Type(type), Pri(prio) {
#if DEBOGUE
   sode->puisJe();
   *sode<<long(this)<<": Noeud.Noeud(\""<<
          Nom<<"\", "<<Type<<", "<<Pri<<") {}\n";
   sode->vasY();
#endif
}

