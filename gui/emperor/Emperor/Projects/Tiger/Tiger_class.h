/*classe cellule*/
class Cellule
{
    private:

        int valeur;                 //valeur de la cellule
        BOOL termite;                //si il y a une termitière
        //int age_termite;
        //int Crayon;                  //rayon d'influence de la termitière
        float pente;                //valeur de la pente
        BOOL influence;              //influence de la termitière sur une cellule éloignée
        float elevation;              //forme de la termitiere
        float altitude;
        BOOL normal;           //s'il y a un changement de signe de la pente
        //int sens;
        //int origine;                //0 pour Idrisi32, 1 pour utilisateur, 2 pour MNA


    public:

        Cellule()                  //constructeur
        {
            valeur=0;
            termite=FALSE;
            //age_termite=0;
            //Crayon=0;
            pente=0.0;
            influence=FALSE;
            normal=TRUE;
            elevation=0.0;
            altitude=200.0;
            //sens=0;
            //origine=0;
        };

        ~Cellule() {};                      //destructeur

        void set_valeur(int nvaleur)        //changement de la valeur
        {
            valeur=nvaleur;
        };

        void set_termite(BOOL ntermite)               //changement de la termitière
        {
            termite=ntermite;
        };

        /*void set_age_termite(int nage_termite)
        {
            age_termite=nage_termite;
        };

        void set_Crayon(int nrayon)          //changement du rayon
        {
            Crayon=nrayon;
        };*/

        void set_pente(float npente)           //changement de la pente
        {
            pente=npente;
        };

        void set_influence(BOOL ninfluence)
        {
            influence=ninfluence;
        };

        void set_elevation(float nelevation)
        {
            elevation=nelevation;
        };

        void set_altitude(int j, int resolution)
        {
            float naltitude=0;
            naltitude=altitude-((pente/resolution)*j)+elevation;
            altitude=naltitude;
        };

        void set_altitude(float naltitude)
        {
            /*float naltitude=0;
            naltitude=altitude-((pente/100)*j)+elevation;*/
            altitude=naltitude;
        };

        void set_normal(BOOL stuff)
        {
            normal=stuff;
        };

        /*void set_sens(int stuff)
        {
            sens=stuff;
        };

        void set_origine(int norigine)
        {
            origine=norigine;
        };*/

        /*void show_valeur() const         //affichage de la valeur
        {
            cout <<valeur;
        };*/

        int retour_valeur() const       //retour de la valeur
        {
            return valeur;
        };

        /*int retour_origine() const
        {
            return origine;
        }

        int retour_age() const
        {
            return age_termite;
        };*/

        float retour_pente() const
        {
            return pente;
        };

        float retour_altitude() const
        {
            return altitude;
        };

        BOOL retour_termite() const
        {
            return termite;
        };

        /*int retour_Crayon() const
        {
            return Crayon;
        };*/

        BOOL retour_influence() const
        {
            return influence;
        };

        BOOL retour_normal() const
        {
            return normal;
        };

        /*int retour_sens() const
        {
            return sens;
        };*/

        float retour_elevation() const
        {
            return elevation;
        };
};
/*fin de classe cellule*/

/*modèle de classe*/
template <class T> class Tableau
{
    public:
        Tableau(int i, int j, int k)
            :ptr(new T [i*j*k]), imax(i), jmax(j), kmax(k) {}
        ~Tableau() { delete [] ptr; }
        T& operator () (int i, int j, int k)
        {
            //assert(i>=0 && i<imax && j>=0 && j<jmax && k>=0 && k<=kmax);
            return ptr[(((i+imax)%imax)*jmax+(j+jmax)%jmax)*kmax+(k+kmax)%kmax];
        }
    private:
        int imax, jmax, kmax;
        T *ptr;
};
/*fin de modèle*/
