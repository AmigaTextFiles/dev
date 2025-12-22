// Moniteur: Jeudi 12-Nov-92 par Gilles Dridi

#include <exec/typesF.h>
#include <debogue/ES.h>
#include <exec/moniteur.h>
#include <exec/tacMin.h>

Moniteur::Moniteur(): (), SemSignale(0), CptSignale(0) {
#if DEBOGUE
   sode->puisJe();
   *sode<<long(this)<<": Moniteur.Moniteur() {}\n";
   sode->vasY();
#endif
}
/*
NEANT Moniteur::entre() {
#if DEBOGUE
   sode->puisJe();
   *sode<<long(this)<<": Moniteur.entre() \""<<
          TrouveTache(NULLE)->nom()<<"\" {\n";
   sode->vasY();
#endif
   puisJe();
#if DEBOGUE
   sode->puisJe();
   *sode<<"}\n";
   sode->vasY();
#endif
}
*/
NEANT Moniteur::sors() {
#if DEBOGUE
   sode->puisJe();
   *sode<<long(this)<<": Moniteur.sors() \""<<
          TrouveTache(NULLE)->nom()<<"\" {\n";
   sode->vasY();
#endif
   // Remarque importante: au plus un processus dans le moniteur.
   // s'il E un processus signaleur, bloqué après avoir signalé la condition,
   // il est réveillé, sinon le processus libère ses droits sur le moniteur.
   si ( CptSignale ) SemSignale.vasY();
   sinon vasY();
#if DEBOGUE
   sode->puisJe();
   *sode<<"}\n";
   sode->vasY();
#endif
}
/*
Moniteur::~Moniteur() {
#if DEBOGUE
   sode->puisJe();
   *sode<<long(this)<<": Moniteur.~Moniteur() Moniteur.Processus "<<
          Processus<<"\n          Moniteur.SemSignale.Processus "<<
          SemSignale.processus()<<" Moniteur.CptSignale "<<
          CptSignale<<" {}\n";
   sode->vasY();
#endif
}
*/
