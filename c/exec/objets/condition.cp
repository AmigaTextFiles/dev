// Condition: Jeudi 12-Nov-92 par Gilles Dridi

#include <exec/typesF.h>
#include <debogue/ES.h>
#include <exec/condition.h>
#include <exec/tacMin.h>

Condition::Condition(Moniteur *duMoniteur): (0),
                     DuMoniteur(duMoniteur), CptAttends(0) {
#if DEBOGUE
   sode->puisJe();
   *sode<<long(this)<<": Condition.Condition("<<long(DuMoniteur)<<") {}\n";
   sode->vasY();
#endif
}

NEANT Condition::attends() {
#if DEBOGUE
   sode->puisJe();
   *sode<<long(this)<<": Condition.attends() \""<<
          TrouveTache(NULLE)->nom()<<"\" {\n";
   sode->vasY();
#endif
   // libère les droits d'accès au moniteur, attente de la condition
   CptAttends++;
   DuMoniteur->sors(); // un autre processus rentre
   puisJe(); // se bloque ici
   CptAttends--;
#if DEBOGUE
   sode->puisJe();
   *sode<<"}\n";
   sode->vasY();
#endif
}

NEANT Condition::signale() {
#if DEBOGUE
   sode->puisJe();
   *sode<<long(this)<<": Condition.signale() \""<<
          TrouveTache(NULLE)->nom()<<"\" {\n";
   sode->vasY();
#endif
   // Remarque: la condition est réalisée. Elle va être signalée.
   // si aucun processus est en attente de condition, le signal est perdu.
   si ( CptAttends ) {
      DuMoniteur->CptSignale++;
      vasY(); // un autre processus rentre
      DuMoniteur->SemSignale.puisJe(); // se bloque ici
      DuMoniteur->CptSignale--;
   }
#if DEBOGUE
   sode->puisJe();
   *sode<<"}\n";
   sode->vasY();
#endif
}

