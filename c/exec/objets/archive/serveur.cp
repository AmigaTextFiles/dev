#include <exec/typesF.h>
#include <debogue/ES.h>
#include <exec/serveur.h>

Serveur::Serveur(TEXTE *nom, OCTET pri):
                 (&PileServeur, nom, pri),
                 PileServeur(moiMeme) {
#if DEBOGUE
   sode->puisJe();
   *sode<<long(this)<<": Serveur.Serveur(\""<<nom<<"\", "<<
          pri<<") {}\n";
   sode->vasY();
#endif
}

Serveur::debute() {
#if DEBOGUE
   sode->puisJe();
   *sode<<long(this)<<": Serveur.debute() {\n";
   sode->vasY();
#endif
   unite().sers(); // boucle infinie
}

