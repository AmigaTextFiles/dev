// BibliArchi: Mercredi 10-Fév-93 par Gilles Dridi

#include <exec/typesF.h>
#include <debogue/ES.h>
#include <exec/bibliArchi.h>

BibliArchi::BibliArchi(TEXTE *nomBibli, MOTN nbrDeFonc, TEXTE *chaineId):
                       Nulle(asmNulleBibli),
                       Epure(asmEpureBibli),
                       Ferme(asmFermeBibli),
                       Ouvre(asmOuvreBibli),
                       LaBibliotheque(nomBibli, nbrDeFonc+4, chaineId) {
#if DEBOGUE
   sode->puisJe();
   *sode<<long(this)<<": BibliArchi.BibliArchi(\""<<Nom<<
          ", "<<nbrDeFonc<<", \""<<chaineId<<"\") {}\n";
   sode->vasY();
#endif
}

