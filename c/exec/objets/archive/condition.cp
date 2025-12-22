// Condition: Jeudi 12-Nov-92 par Gilles Dridi

#include <exec/typesF.h>
#include <debogue/ES.h>
#include <exec/condition.h>

Condition::Condition(Moniteur *duMoniteur): (NUL, 0, 0),
                     DuMoniteur(duMoniteur), CptAttends(0) {
#if DEBOGUE_CONDITION
   sode->puisJe();
   *sode<<long(this)<<": Condition.Condition("<<long(DuMoniteur)<<")\n";
   sode->vasY();
#endif
}

NEANT Condition::attends() {
#if DEBOGUE_CONDITION
   sode->puisJe();
   *sode<<long(this)<<": Condition.attends() \""<<
          TrouveTache(NULLE)->Nom<<"\"\n";
   sode->vasY();
#endif
   // libère les droits d'accès au moniteur, attente sur la condition
   CptAttends++;
   DuMoniteur->sors();
   puisJe();
   CptAttends--;
}

NEANT Condition::signale() {
#if DEBOGUE_CONDITION
   sode->puisJe();
   *sode<<long(this)<<": Condition.signale() \""<<
          TrouveTache(NULLE)->Nom<<"\"\n";
   sode->vasY();
#endif
   // Remarque: la condition est déjà réalisée. Elle va être signalée.
   // si aucun processus est en attente, le signal est perdu.
   if ( CptAttends ) {
      DuMoniteur->CptSignale++;
      vasY(); // le "signal", cela fait rentrer un autre processus
      // se bloque afin d'avoir un unique processus dans le moniteur
      DuMoniteur->puisJe();
      DuMoniteur->CptSignale--;
   }
}

Condition::~Condition() {
#if DEBOGUE_CONDITION
   sode->puisJe();
   *sode<<long(this)<<": Condition.~Condition() Condition.CptAttends "<<
          CptAttends<<" \n";
   sode->vasY();
#endif
}
