// Tâche: Lundi 17-Août-1992 par Gilles Dridi

#include <exec/typesF.h>
#include <debogue/ES.h>
#include <exec/tache.h>

Tache::Tache(TEXTE *nomTache, OCTET priTache,
             LONGN taillePile,
             PTRNEANT codeSpecial, PTRNEANT codeTrappe,
             NEANT (*codePostQ)(), NEANT (*codePreQ)()):
             (nomTache, TN_TACHE, priTache),
             Natures(1<<BN_NORMAL), Etat(TE_INVALIDE),
             Cpt0IT(0), Cpt0MT(0),
             SigAlloues(), SigAttendus(), SigRecus(), SigSpeciaux(),
             TrapAllouees(), TrapPermises(),
             DonneeSpeciale(NULLE), CodeSpecial(codeSpecial),
             DonneeTrappe(NULLE), CodeTrappe(codeTrappe),
             CodePostQ(codePostQ), CodePreQ(codePreQ),
             Memoire(), DonneeUtilisateur(NULLE) {
   taillePile+= 3; taillePile&= ~0x3;
   BasRegPile= construis MOTN[taillePile/2];
   HautRegPile= RegistrePile= (PTRNEANT)((unsigned long)
      BasRegPile+taillePile);
   si ( codeSpecial ) Natures|= 1<<BN_SPECIAL;
   si ( codePostQ ) Natures|= 1<<BN_POSTQUANTUM;
   si ( codePreQ ) Natures|= 1<<BN_PREQUANTUM;
#if DEBOGUE_TACHE
   sode->puisJe();
   *sode<<long(this)<<": Tache.Tache(\""<<Nom<<"\", "<<
     Pri<<", "<<taillePile<<", "<<
     long(CodeSpecial)<<", "<<long(CodeTrappe)<<", "<<
     long(CodePerd)<<", "<<long(CodeObtient)<<")\n"<<
     " Tache.BasRegPile "<<long(BasRegPile)<<
     " Tache.HautRegPile "<<long(HautRegPile)<<
     " Tache.RegistrePile "<<long(RegistrePile)<<"\n";
   sode->vasY();
#endif
}

Tache *Tache::ajoute(PTRNEANT pointEntree, PTRNEANT codeTerminal) {
#if DEBOGUE_TACHE
   sode->puisJe();
   *sode<<long(this)<<": Tache.ajoute("<<long(pointEntree)<<", "<<
     long(codeTerminal)<<") \""<<Nom<<"\"\n";
   sode->vasY();
#endif
   Tache *ptr= AddTask(this, pointEntree, codeTerminal);
#if DEBOGUE_TACHE
   sode->puisJe();
   *sode<<">"<<long(ptr)<<"\n";
   sode->vasY();
#endif
   return ptr;
}

EnsSig Tache::attends(EnsSig es) {
#if DEBOGUE_TACHE
   sode->puisJe();
   *sode<<long(this)<<": Tache.attends("<<long(es)<<")\n";
   sode->vasY();
#endif
   return es.attends();
}

NEANT Tache::signale(Tache *t, EnsSig es) {
#if DEBOGUE_TACHE
   sode->puisJe();
   *sode<<long(this)<<": Tache.signale("<<long(t)<<", "<<long(es)<<")\n";
   sode->vasY();
#endif
   es.signale(t);
}

OCTET Tache::changePri(OCTET tachePri) {
#if DEBOGUE_TACHE
   sode->puisJe();
   *sode<<long(this)<<": Tache.changePri("<<tachePri<<")\n";
   sode->vasY();
#endif
   return SetTaskPri(this, tachePri);
}

NEANT Tache::passeTour() {
#if DEBOGUE_TACHE
   sode->puisJe();
   *sode<<long(this)<<": Tache.passeTour()\n";
   sode->vasY();
#endif
   SetTaskPri(this, (OCTET)Pri-1);
}

NEANT Tache::enleve() {
#if DEBOGUE_TACHE
   sode->puisJe();
   *sode<<long(this)<<": Tache.enleve() \""<<Nom<<"\"\n";
   sode->vasY();
#endif
   if ( Etat != TE_TERMINEE ) RemTask(this);
#if DEBOGUE_TACHE
   else {
      sode->puisJe();
      *sode<<">Erreur: Tache.enleve() alors que TE_TERMINEE\n";
      sode->vasY();
   }
#endif
}

Tache::~Tache() {
#if DEBOGUE_TACHE
   sode->puisJe();
   *sode<<long(this)<<": Tache.~Tache() \""<<Nom<<"\"\n";
   sode->vasY();
#endif
   enleve();
   detruis BasRegPile;
}

