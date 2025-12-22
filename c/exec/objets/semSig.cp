// SemSig: Vendredi 02-Oct-92 par Gilles Dridi

#include <exec/typesF.h>
#include <debogue/ES.h>
#include <exec/semSig.h>

// remplace l'initialisation faite par InitSemaphore()
SemSig::SemSig(TEXTE *ns, OCTET ps):
               (ns, TN_SEMAPHORE, ps),
               Compteur(0), QueueDAttente(),
               LienMultiple(), QueueDAttente(),
               Proprietaire(NUL), CompteurDeQueue(-1) {
#if DEBOGUE
   sode->puisJe();
   *sode<<long(this)<<": SemSig.SemSig(\""<<Nom<<"\", "<<Pri<<") {}\n";
   sode->vasY();
#endif
}
