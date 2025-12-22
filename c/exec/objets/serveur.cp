#include <exec/typesF.h>
#include <debogue/ES.h>
#include <exec/serveur.h>

Serveur::Serveur(TEXTE *nom, OCTET pri):
                 ((Pile *)&PileServeur, nom, pri),
                 PileServeur(moiMeme) {
#if DEBOGUE
   sode->puisJe();
   *sode<<long(this)<<": Serveur.Serveur(\""<<nom<<"\", "<<
          pri<<") {}\n";
   sode->vasY();
#endif
}

NEANT Serveur::sers() {
#if DEBOGUE
   sode->puisJe();
   *sode<<long(this)<<": Serveur.sers() {\n";
   sode->vasY();
#endif
   while( VRAI );
}
