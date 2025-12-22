// Moniteur: Jeudi 12-Nov-92 par Gilles Dridi

#include <exec/typesF.h>
#include <debogue/ES.h>
#include <exec/tache.h>
#include <exec/moniteur.h>

Moniteur::Moniteur(): (NUL, 0, 0), SemExcl(), CptSignale(0) {
#if DEBOGUE_MONITEUR
   sode->puisJe();
   *sode<<long(this)<<": Moniteur.Moniteur()\n";
   sode->vasY();
#endif
}

NEANT Moniteur::entre() {
#if DEBOGUE_MONITEUR
   sode->puisJe();
   *sode<<long(this)<<": Moniteur.entre() \""<<
          TrouveTache(NULLE)->Nom<<"\"\n";
   sode->vasY();
#endif
   SemExcl.puisJe();
}

NEANT Moniteur::sors() {
#if DEBOGUE_MONITEUR
   sode->puisJe();
   *sode<<long(this)<<": Moniteur.sors() \""<<
          TrouveTache(NULLE)->Nom<<"\"\n";
   sode->vasY();
#endif
   // Remarque importante: au plus un processus dans le moniteur.
   // s'il E un processus signaleur, bloqué après avoir signalé la condition,
   // il est réveillé, sinon le processus libère ses droits sur le moniteur.
   if ( CptSignale ) vasY();
   else SemExcl.vasY();
}

Moniteur::~Moniteur() {
#if DEBOGUE_MONITEUR
   sode->puisJe();
   *sode<<long(this)<<": Moniteur.~Moniteur() Moniteur.SemExcl.Processus "<<
          SemExcl.processus()<<" Moniteur.CptSignale "<<CptSignale<<"\n";
   sode->vasY();
#endif
}

