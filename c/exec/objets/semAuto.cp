// SemAuto: Lundi 05-Oct-92 par Gilles Dridi

#include <exec/typesF.h>
#include <debogue/ES.h>
#include <exec/SemAuto.h>

SemAuto::SemAuto(TEXTE *nomSem, OCTET priSem):
               (nomSem, priSem) {
#if DEBOGUE
   sode->puisJe();
   *sode<<long(this)<<": SemAuto.SemAuto(\""<<Nom<<"\", "<<
          Pri<<") {\n";
   sode->vasY();
#endif
   if ( nomSem ) SemSig::ajoute();
#if DEBOGUE
   sode->puisJe();
   *sode<<"}\n";
   sode->vasY();
#endif
}

SemAuto::~SemAuto() {
#if DEBOGUE
   sode->puisJe();
   *sode<<long(this)<<": SemAuto.~SemAuto() \""<<Nom<<"\" {\n";
   sode->vasY();
#endif
   if ( Nom ) SemSig::enleve();
#if DEBOGUE
   sode->puisJe();
   *sode<<"}\n";
   sode->vasY();
#endif
}

