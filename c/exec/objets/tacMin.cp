// TacMin: Samedi 24-Avr-93 par Gilles Dridi

#include <exec/typesF.h>
#include <debogue/ES.h>
#include <exec/tacMin.h>

TacMin::TacMin(Pile *pile, TEXTE *nom, OCTET pri):
               (nom, TN_TACHE, pri),
               Natures(1<<BN_VERIFPILE), Etat(TE_INVALIDE),
               Cpt0IT(-1), Cpt0MT(-1),
               EnsSigAlloues(ENSSIGSYS), EnsSigAttendus(),
               EnsSigRecus(), EnsSigExceptions(),
               EnsTrpAllouees(ENSTRPSYS), EnsTrpPermises(),
               DonneeException(NULLE), CodeException(NUL),
               DonneeTrappe(NULLE), // pas utilisée
               CodeTrappe(NUL),
               CodePostQ(NUL), CodePreQ(NUL),
               Memoire(), DonneeUtilisateur((PTRNEANT)pile) {
#if DEBOGUE
   sode->puisJe();
   *sode<<long(this)<<": TacMin.TacMin("<<long(pile)<<", \""<<
          Nom<<"\", "<<Pri<<") {}\n";
   sode->vasY();
#endif
}

// IMPORTANT: réinitialiser "RegistrePile" avant de relancer la tâche.
// De plus, l'appels des virtuelles (pile-> ) est impossible dans le ctr.

TacMin *TacMin::ajoute(Procedure pointEntree) {
#if DEBOGUE
   sode->puisJe();
   *sode<<long(this)<<": TacMin.ajoute("<<long(pointEntree)<<") {\n";
   sode->vasY();
#endif
   BasRegPile= ((Pile *)DonneeUtilisateur)->fond();
   RegistrePile= HautRegPile= ((Pile*)DonneeUtilisateur)->sommet();
   TacMin *ptr= AddTask(moiMeme, pointEntree, 0L);
#if DEBOGUE
   sode->puisJe();
   *sode<<"}\n>"<<long(ptr)<<"\n";
   sode->vasY();
#endif
   renvoie ptr;
}

