// MonTerm: Vendredi 05-Fév-93 par Gilles Dridi
// Décès: mort naturelle d'une personne (pas un assassinat !)

#include <exec/typesF.h>
#include <debogue/ES.h>
#include <exec/monTerm.h>
#include <exec/tacMin.h>

MonTerm::MonTerm(): (), Deces(moiMeme), BoolDeces(FAUX) {
#if DEBOGUE
   sode->puisJe();
   *sode<<long(this)<<": MonTerm.MonTerm() {}\n";
   sode->vasY();
#endif
}

NEANT MonTerm::sigTerm() {
#if DEBOGUE
   sode->puisJe();
   *sode<<long(this)<<": MonTerm.sigTerm() \""<<
          TrouveTache(NULLE)->nom()<<"\" {\n";
   sode->vasY();
#endif
   entre();
   BoolDeces= VRAI;
   Deces.signale();
   sors();
#if DEBOGUE
   sode->puisJe();
   *sode<<"}\n";
   sode->vasY();
#endif
}

NEANT MonTerm::attTerm() {
#if DEBOGUE
   sode->puisJe();
   *sode<<long(this)<<": MonTerm.attTerm() \""<<
          TrouveTache(NULLE)->nom()<<"\" {\n";
   sode->vasY();
#endif
   entre();
   si ( !BoolDeces ) Deces.attends();
   BoolDeces= FAUX;
   sors();
#if DEBOGUE
   sode->puisJe();
   *sode<<"}\n";
   sode->vasY();
#endif
}

