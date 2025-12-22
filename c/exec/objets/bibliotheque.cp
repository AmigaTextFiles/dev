// Utiliser lmk D=DEBOGUE bibliotheque.o
// En C, les paramètres sont toujours dans la pile sauf pragma
// La gestion du bit BS_SURSITAIRE permet au système de demander
// l'épuration d'une bibliothèque. Si, au moment où le système (exec)
// fait l'épurtion, il reste des abonnés, ce sera le dernier qui fermera
// la bibliothèque qui provoquera son épuration du système. (voir les fcts)

#include <exec/typesF.h>
#include <debogue/ES.h>
#include <exec/bibliotheque.h>

// OpenLibrary() appelle ouvre() avec la plus proche version trouvée.
Bibliotheque *Bibliotheque::ouvre() {
#if DEBOGUE
   sode->puisJe();
   *sode<<long(this)<<": Bibliotheque.ouvre() Bibliotheque.Version "<<
          Version<<" {\n";
   sode->vasY();
#endif
   Abonnes++;
   Statut&= ~(1<<BS_SURSITAIRE);
#if DEBOGUE
   sode->puisJe();
   *sode<<"}\n>"<<long(moiMeme)<<"\n";
   sode->vasY();
#endif
   renvoie moiMeme;
}

// CloseLibrary() appelle ferme()
PTRBCPL Bibliotheque::ferme() {
#if DEBOGUE
   sode->puisJe();
   *sode<<long(this)<<": Bibliotheque.ferme() {\n";
   sode->vasY();
#endif
PTRBCPL	ptr = NULLE;

   si ( ( --Abonnes == 0 ) && ( (1<<BS_SURSITAIRE) & Statut ) ) 
		ptr = epure();
	sinon 
		ptr = NULLE;
#if DEBOGUE
   sode->puisJe();
   *sode<<"}\n>"<<long(ptr)<<"\n";
   sode->vasY();
#endif
	renvoie ptr;
}

// RemLibrary() appelle epure()
PTRBCPL Bibliotheque::epure() {
#if DEBOGUE
   sode->puisJe();
   *sode<<long(this)<<": Bibliotheque.epure() {\n";
   sode->vasY();
#endif
PTRBCPL	ptr = NULLE;

   si ( Abonnes == 0 ) {
      Noeud::enleve();
      ptr = decharge();
   } 
	sinon {
		Statut|= 1<<BS_SURSITAIRE;
		ptr = NULLE;
	}
#if DEBOGUE
   sode->puisJe();
   *sode<<"}\n>"<<long(ptr)<<"\n";
   sode->vasY();
#endif
	renvoie ptr;
}

