// Tache: Jeudi 29-Avr-93 par Gilles Dridi

#include <exec/typesF.h>
#include <debogue/ES.h>
#include <exec/tache.h>

extern geta4();   // charge l'@ du segment de donnée
extern asmPrologueExc();

Tache::Tache(Pile *pile, TEXTE *nom= NUL, OCTET pri= 0):
             (pile, nom, pri) {
   // ici car une initialisation est faite par TacMin
   DonneeException= moiMeme;
   CodeException= (Procedure)asmPrologueExc;
#if DEBOGUE
   sode->puisJe();
   *sode<<long(this)<<": Tache.Tache("<<long(pile)<<", \""<<
          Nom<<"\", "<<pri<<" {}\n";
   sode->vasY();
#endif
}

NEANT Tache::prologue() {
#if DEBOGUE
   sode->puisJe();
   *sode<<long(this)<<": Tache.prologue() {\n";
   sode->vasY();
#endif
   geta4(); // nécessaire pour la nouvelle tâche
   debute();
#if DEBOGUE
   sode->puisJe();
   *sode<<"}\n";
   sode->vasY();
#endif
}
 
NEANT Tache::prologueExc(EnsSigExc exceptions) {
#if DEBOGUE
   sode->puisJe();
   *sode<<long(this)<<": Tache.prologueExc("<<exceptions.signaux()<<") {}\n";
   sode->vasY();
#endif
   interrompu(exceptions);
}

NEANT Tache::debute() {
#if DEBOGUE
   sode->puisJe();
   *sode<<long(this)<<": Tache.debute() {}\n";
   sode->vasY();
#endif
}

NEANT Tache::interrompu(EnsSigExc exceptions) {
#if DEBOGUE
   sode->puisJe();
   *sode<<long(this)<<": Tache.interrompu("<<exceptions.signaux()<<") {}\n";
   sode->vasY();
#endif
}
