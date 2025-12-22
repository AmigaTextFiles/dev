#include "Tiger_class.h"
#include "Tiger_fonctions.h"
#include <iostream.h>

#define AMONTMAX 15
#define AVALMAX 8
#define XOFFSET 40
#define YOFFSET 40

ULONG noir=0;
ULONG blanc=0;
ULONG gris1=0;
ULONG gris2=0;
ULONG gris3=0;
ULONG gris4=0;
ULONG gris5=0;
ULONG gris6=0;
ULONG gris7=0;
ULONG gris8=0;
ULONG gris9=0;
ULONG gris10=0;
ULONG gris11=0;
ULONG gris12=0;
ULONG gris13=0;
ULONG gris14=0;

struct Window *win=NULL;
struct RastPort *winport=NULL;
struct RastPort winport_noir;
struct RastPort winport_blanc;
struct RastPort winport_gris1;
struct RastPort winport_gris2;
struct RastPort winport_gris3;
struct RastPort winport_gris4;
struct RastPort winport_gris5;
struct RastPort winport_gris6;
struct RastPort winport_gris7;
struct RastPort winport_gris8;
struct RastPort winport_gris9;
struct RastPort winport_gris10;
struct RastPort winport_gris11;
struct RastPort winport_gris12;
struct RastPort winport_gris13;
struct RastPort winport_gris14;

Object *winobj=NULL;

void Startup(void)
{
    pente=0.4;
    pluie=450;
    termite=0;
    rayon=0;
    imax=40;
    jmax=40;
    kmax=5;
    zoom=1;
    SetGadgetAttrs(Fuelgauge2, Window1, NULL, FUELGAUGE_Max, jmax, TAG_DONE);
    SetGadgetAttrs(Fuelgauge3, Window1, NULL, FUELGAUGE_Max, kmax, TAG_DONE);
    SetGadgetAttrs(Fuelgauge2, Window1, NULL, FUELGAUGE_Level, 0 , TAG_DONE);
    SetGadgetAttrs(Fuelgauge3, Window1, NULL, FUELGAUGE_Level, 0 , TAG_DONE);
    SetGadgetAttrs(Button3, Window1, NULL, GA_Disabled, TRUE, TAG_DONE);
    SetGadgetAttrs(Button6, Window1, NULL, GA_Disabled, TRUE, TAG_DONE);
    SetGadgetAttrs(Button7, Window1, NULL, GA_Disabled, TRUE, TAG_DONE);
    SetGadgetAttrs(Button8, Window1, NULL, GA_Disabled, TRUE, TAG_DONE);
    noir = ObtainBestPen(Screen1->ViewPort.ColorMap, 0x0FFFFFFF, 0x0FFFFFFF, 0x0FFFFFFF, OBP_Precision, PRECISION_EXACT, TAG_DONE);
    blanc = ObtainBestPen(Screen1->ViewPort.ColorMap, 0xFFFFFFFF, 0xFFFFFFFF, 0xFFFFFFFF, OBP_Precision, PRECISION_EXACT, TAG_DONE);
    gris1 = ObtainBestPen(Screen1->ViewPort.ColorMap, 0xeFFFFFFF, 0xeFFFFFFF, 0xeFFFFFFF, OBP_Precision, PRECISION_EXACT, TAG_DONE);
    gris2 = ObtainBestPen(Screen1->ViewPort.ColorMap, 0xdfffffff, 0xdfffffff, 0xdfffffff, OBP_Precision, PRECISION_EXACT, TAG_DONE);
    gris3 = ObtainBestPen(Screen1->ViewPort.ColorMap, 0xcfffffff, 0xcfffffff, 0xcfffffff, OBP_Precision, PRECISION_EXACT, TAG_DONE);
    gris4 = ObtainBestPen(Screen1->ViewPort.ColorMap, 0xbfffffff, 0xbfffffff, 0xbfffffff, OBP_Precision, PRECISION_EXACT, TAG_DONE);
    gris5 = ObtainBestPen(Screen1->ViewPort.ColorMap, 0xafffffff, 0xafffffff, 0xafffffff, OBP_Precision, PRECISION_EXACT, TAG_DONE);
    gris6 = ObtainBestPen(Screen1->ViewPort.ColorMap, 0x9fffffff, 0x9fffffff, 0x9fffffff, OBP_Precision, PRECISION_EXACT, TAG_DONE);
    gris7 = ObtainBestPen(Screen1->ViewPort.ColorMap, 0x8fffffff, 0x8fffffff, 0x8fffffff, OBP_Precision, PRECISION_EXACT, TAG_DONE);
    gris8 = ObtainBestPen(Screen1->ViewPort.ColorMap, 0x7fffffff, 0x7fffffff, 0x7fffffff, OBP_Precision, PRECISION_EXACT, TAG_DONE);
    gris9 = ObtainBestPen(Screen1->ViewPort.ColorMap, 0x6fffffff, 0x6fffffff, 0x6fffffff, OBP_Precision, PRECISION_EXACT, TAG_DONE);
    gris10 = ObtainBestPen(Screen1->ViewPort.ColorMap, 0x5fffffff, 0x5fffffff, 0x5fffffff, OBP_Precision, PRECISION_EXACT, TAG_DONE);
    gris11 = ObtainBestPen(Screen1->ViewPort.ColorMap, 0x4fffffff, 0x4fffffff, 0x4fffffff, OBP_Precision, PRECISION_EXACT, TAG_DONE);
    gris12 = ObtainBestPen(Screen1->ViewPort.ColorMap, 0x3fffffff, 0x3fffffff, 0x3fffffff, OBP_Precision, PRECISION_EXACT, TAG_DONE);
    gris13 = ObtainBestPen(Screen1->ViewPort.ColorMap, 0x2fffffff, 0x2fffffff, 0x2fffffff, OBP_Precision, PRECISION_EXACT, TAG_DONE);
    gris14 = ObtainBestPen(Screen1->ViewPort.ColorMap, 0x1fffffff, 0x1fffffff, 0x1fffffff, OBP_Precision, PRECISION_EXACT, TAG_DONE);
}

void Shutdown(void)
{
    ReleasePen(Screen1->ViewPort.ColorMap, noir);
    ReleasePen(Screen1->ViewPort.ColorMap, blanc);
    ReleasePen(Screen1->ViewPort.ColorMap, gris1);
    ReleasePen(Screen1->ViewPort.ColorMap, gris2);
    ReleasePen(Screen1->ViewPort.ColorMap, gris3);
    ReleasePen(Screen1->ViewPort.ColorMap, gris4);
    ReleasePen(Screen1->ViewPort.ColorMap, gris5);
    ReleasePen(Screen1->ViewPort.ColorMap, gris6);
    ReleasePen(Screen1->ViewPort.ColorMap, gris7);
    ReleasePen(Screen1->ViewPort.ColorMap, gris8);
    ReleasePen(Screen1->ViewPort.ColorMap, gris9);
    ReleasePen(Screen1->ViewPort.ColorMap, gris10);
    ReleasePen(Screen1->ViewPort.ColorMap, gris11);
    ReleasePen(Screen1->ViewPort.ColorMap, gris12);
    ReleasePen(Screen1->ViewPort.ColorMap, gris13);
    ReleasePen(Screen1->ViewPort.ColorMap, gris14);
}

void Window1_ShowWindow_Event(void)
{
}

void Window1_CloseWindow_Event(void)
{
    Emperor_QuitProgram();
}

void Menu_Quit1_MenuPick_Event(void)
{
    Emperor_QuitProgram();
}

void Menu_Information1_MenuPick_Event(void)
{
    Inforequest1();
}

void String1_GadgetUp_Event(void)
{
    pente = atof(Emperor_GetGadgetAttr(String1));
    if (pente<0.1 || pente >1.5)
    {
        Emperor_SetGadgetAttr(String1, "0.0");
        pente=0.0;
    }
    SetGadgetAttrs(Fuelgauge2, Window1, NULL, FUELGAUGE_Level, 0 , TAG_DONE);
    SetGadgetAttrs(Fuelgauge3, Window1, NULL, FUELGAUGE_Level, 0 , TAG_DONE);
}

void Integer1_GadgetUp_Event(void)
{
    pluie = atoi(Emperor_GetGadgetAttr(Integer1));
    SetGadgetAttrs(Fuelgauge2, Window1, NULL, FUELGAUGE_Level, 0 , TAG_DONE);
    SetGadgetAttrs(Fuelgauge3, Window1, NULL, FUELGAUGE_Level, 0 , TAG_DONE);
}

void Integer2_GadgetUp_Event(void)
{
    termite = atoi(Emperor_GetGadgetAttr(Integer2));
    SetGadgetAttrs(Fuelgauge2, Window1, NULL, FUELGAUGE_Level, 0 , TAG_DONE);
    SetGadgetAttrs(Fuelgauge3, Window1, NULL, FUELGAUGE_Level, 0 , TAG_DONE);
}

void Integer3_GadgetUp_Event(void)
{
    rayon = atoi(Emperor_GetGadgetAttr(Integer3));
    SetGadgetAttrs(Fuelgauge2, Window1, NULL, FUELGAUGE_Level, 0 , TAG_DONE);
    SetGadgetAttrs(Fuelgauge3, Window1, NULL, FUELGAUGE_Level, 0 , TAG_DONE);
}

void Integer4_GadgetUp_Event(void)
{
    imax = atoi(Emperor_GetGadgetAttr(Integer4));
    SetGadgetAttrs(Fuelgauge2, Window1, NULL, FUELGAUGE_Level, 0 , TAG_DONE);
    SetGadgetAttrs(Fuelgauge3, Window1, NULL, FUELGAUGE_Level, 0 , TAG_DONE);
}

void Integer5_GadgetUp_Event(void)
{
    jmax = atoi(Emperor_GetGadgetAttr(Integer5));
    SetGadgetAttrs(Fuelgauge2, Window1, NULL, FUELGAUGE_Max, jmax, TAG_DONE);
    SetGadgetAttrs(Fuelgauge2, Window1, NULL, FUELGAUGE_Level, 0 , TAG_DONE);
    SetGadgetAttrs(Fuelgauge3, Window1, NULL, FUELGAUGE_Level, 0 , TAG_DONE);
}

void Integer6_GadgetUp_Event(void)
{
    kmax = atoi(Emperor_GetGadgetAttr(Integer6));
    SetGadgetAttrs(Fuelgauge3, Window1, NULL, FUELGAUGE_Max, kmax, TAG_DONE);  
    SetGadgetAttrs(Fuelgauge2, Window1, NULL, FUELGAUGE_Level, 0 , TAG_DONE);
    SetGadgetAttrs(Fuelgauge3, Window1, NULL, FUELGAUGE_Level, 0 , TAG_DONE);
}

void Checkbox1_GadgetUp_Event(void)         //sauver MNA
{
    if(Emperor_GetGadgetAttr(Checkbox1))
    {
        MNA=TRUE;
    }
}

void Checkbox2_GadgetUp_Event(void)
{
    if(Emperor_GetGadgetAttr(Checkbox2))
    {
        previsual=TRUE;
    }
}

void Slider1_GadgetUp_Event(void)
{
    STRPTR temp=0;
    temp=Emperor_GetGadgetAttr(Slider1);
    Emperor_SetGadgetAttr(String2, temp);
    zoom=stringtoint(temp)
}

void Button2_GadgetUp_Event(void)            //valeurs moyennes
{
    pente=0.4;
    pluie=450;
    imax=40;
    jmax=40;
    kmax=5;
    zoom=1;
    Emperor_SetGadgetAttr(String1, "0.4");
    SetGadgetAttrs(Integer1, Window1, NULL, INTEGER_Number, 450, TAG_DONE);
    SetGadgetAttrs(Integer4, Window1, NULL, INTEGER_Number, 40, TAG_DONE);
    SetGadgetAttrs(Integer5, Window1, NULL, INTEGER_Number, 40, TAG_DONE);
    SetGadgetAttrs(Integer6, Window1, NULL, INTEGER_Number, 5, TAG_DONE);
    SetGadgetAttrs(Fuelgauge2, Window1, NULL, FUELGAUGE_Max, jmax, TAG_DONE);
    SetGadgetAttrs(Fuelgauge3, Window1, NULL, FUELGAUGE_Max, kmax, TAG_DONE);
    SetGadgetAttrs(Fuelgauge2, Window1, NULL, FUELGAUGE_Level, 0 , TAG_DONE);
    SetGadgetAttrs(Fuelgauge3, Window1, NULL, FUELGAUGE_Level, 0 , TAG_DONE);
    SetGadgetAttrs(Slider1, Window1, NULL, SLIDER_Level, 1, TAG_DONE);
    STRPTR temp2=0;
    temp2=Emperor_GetGadgetAttr(Slider1);
    Emperor_SetGadgetAttr(String2, temp2);
}

void Button1_GadgetUp_Event(void)
{   
    int i=0, j=0, k=0, l=0, ii=0, jj=0,
    rayon_max=0, random=0, valeur_max=0, resolution=0, a=0, b=0, kk=0, max_tick=0,
    temp=0, combien=0, memoire=0, loop_tick=0, temp_tick=0, amont=0, aval=0, voisins=0;
    float nelevation=0.0, hauteur=0.0, temp_float=0.0, coef_prox=0.0;
    STRPTR tick=0;
    BOOL fermer=FALSE, interrupt=FALSE;
    FILE *fz;

    valeur_max=15;
    hauteur=5.0;
    resolution=2;

    Tableau <Cellule> C(imax, jmax, kmax+1);

    winobj = (Object*) WindowObject,
            WA_Left,    100,
            WA_Top,     100,
            WA_Width,   (imax*zoom)+XOFFSET,
            WA_Height,  (jmax*zoom)+YOFFSET,
            WA_DragBar, TRUE,
            //WA_Title,   "Sortie graphique",
            WA_PubScreen, Screen1,
            //WA_CloseGadget,  TRUE,
            WA_DepthGadget, TRUE,
            WA_SuperBitMap, TRUE,
            WA_IDCMP,  IDCMP_GADGETDOWN | IDCMP_GADGETUP | IDCMP_GADGETHELP | IDCMP_MENUPICK | IDCMP_MENUHELP | IDCMP_CLOSEWINDOW | IDCMP_ACTIVEWINDOW | IDCMP_INACTIVEWINDOW | IDCMP_RAWKEY | IDCMP_VANILLAKEY | IDCMP_MOUSEBUTTONS | IDCMP_MOUSEMOVE | IDCMP_NEWSIZE | IDCMP_CHANGEWINDOW | IDCMP_SIZEVERIFY | IDCMP_REFRESHWINDOW | IDCMP_INTUITICKS,
            WA_RMBTrap, TRUE,
    EndWindow;

    SetGadgetAttrs(Fuelgauge2, Window1, NULL, FUELGAUGE_Level, 0 , TAG_DONE);
    SetGadgetAttrs(Fuelgauge3, Window1, NULL, FUELGAUGE_Level, 0 , TAG_DONE);
    if(previsual)
    {
        SetGadgetAttrs(Button3, Window1, NULL, GA_Disabled, FALSE, TAG_DONE);
    }
    else
    {
        SetGadgetAttrs(Button3, Window1, NULL, GA_Disabled, TRUE, TAG_DONE);
    }
    SetGadgetAttrs(String1, Window1, NULL, GA_Disabled, TRUE, TAG_DONE);
    SetGadgetAttrs(Integer1, Window1, NULL, GA_Disabled, TRUE, TAG_DONE);
    SetGadgetAttrs(Integer2, Window1, NULL, GA_Disabled, TRUE, TAG_DONE);
    SetGadgetAttrs(Integer3, Window1, NULL, GA_Disabled, TRUE, TAG_DONE);
    SetGadgetAttrs(Integer4, Window1, NULL, GA_Disabled, TRUE, TAG_DONE);
    SetGadgetAttrs(Integer5, Window1, NULL, GA_Disabled, TRUE, TAG_DONE);
    SetGadgetAttrs(Integer6, Window1, NULL, GA_Disabled, TRUE, TAG_DONE);
    SetGadgetAttrs(Button1, Window1, NULL, GA_Disabled, TRUE, TAG_DONE);
    SetGadgetAttrs(Button2, Window1, NULL, GA_Disabled, TRUE, TAG_DONE);
    SetGadgetAttrs(Slider1, Window1, NULL, GA_Disabled, TRUE, TAG_DONE);
    SetGadgetAttrs(Checkbox1, Window1, NULL, GA_Disabled, TRUE, TAG_DONE);
    SetGadgetAttrs(Checkbox2, Window1, NULL, GA_Disabled, TRUE, TAG_DONE);

    if(previsual)
    {
        win = RA_OpenWindow (winobj);
        winport = win->RPort;
        winport_noir = *win->RPort;
        winport_blanc = *win->RPort;
        winport_gris1 = *win->RPort;
        winport_gris2 = *win->RPort;
        winport_gris3 = *win->RPort;
        winport_gris4 = *win->RPort;
        winport_gris5 = *win->RPort;
        winport_gris6 = *win->RPort;
        winport_gris7 = *win->RPort;
        winport_gris8 = *win->RPort;
        winport_gris9 = *win->RPort;
        winport_gris10 = *win->RPort;
        winport_gris11 = *win->RPort;
        winport_gris12 = *win->RPort;
        winport_gris13 = *win->RPort;
        winport_gris14 = *win->RPort;
        SetAPen( &winport_noir, noir );
        SetAPen( &winport_blanc, blanc );
        SetAPen( &winport_gris1, gris1 );
        SetAPen( &winport_gris2, gris2 );
        SetAPen( &winport_gris3, gris3 );
        SetAPen( &winport_gris4, gris4 );
        SetAPen( &winport_gris5, gris5 );
        SetAPen( &winport_gris6, gris6 );
        SetAPen( &winport_gris7, gris7 );
        SetAPen( &winport_gris8, gris8 );
        SetAPen( &winport_gris9, gris9 );
        SetAPen( &winport_gris10, gris10 );
        SetAPen( &winport_gris11, gris11 );
        SetAPen( &winport_gris12, gris12 );
        SetAPen( &winport_gris13, gris13 );
        SetAPen( &winport_gris14, gris14 );
    }

/*appel au constructeur*/
    
    for(k=0; k<=kmax; k++)
    {                                     
        for(j=0; j<jmax; j++)             
        {                                 
            for(i=0; i<imax; i++)         
            {                             
                C(i,j,k);
            }                             
        }                                 
    }

/*remplissage aléatoire de la génération 0*/  

    srand((unsigned) time(NULL));
    for(j=0; j<jmax; j++)                     
    {                                         
        for(i=0; i<imax; i++)                 
        {                                     
            random=rand()%valeur_max;         
            C(i,j,0).set_valeur(random);      
        }                                                              
    }

/*termitisation et élévation*/  

    int x=0, y=0, r=0, tempr=0;
    float alpha=0.0; //tempx=0.0, tempy=0.0, arrx=0.0, arry=0.0;
    rayon_max=(int)rayon;
    //cout <<"début des termites" <<endl;
    for(int t=0; t<termite; t++)  
    {                             
        escape:
        temp=0;
        r=0;
        temp=imax-(2*rayon_max);              //prendre les coordonnées i et j
        i=(rand()%temp)+rayon_max;                   //aléatoirement pour chaque termitière
        cout <<i <<endl;
        temp=jmax-(2*rayon_max);
        j=(rand()%temp)+rayon_max;
        cout <<j <<endl;
        random=rand()%kmax;
        for(tempr=1; tempr<=rayon_max; tempr++)
        {
            for(alpha=0.0; alpha<2*PI; alpha+=(2*PI)/(tempr*8))     //8 -> facteur qui permet d'avoir une couverture suffisante
            {
                circle_param(tempr, i, j, x, y, alpha);
                //cout <<x <<" " <<y <<endl;
                if(C(x,y,k).retour_influence())
                {
                    goto escape;
                }
            }
        }
        for(k=0; k<=kmax; k++)
        {
            C(i,j,k).set_termite(TRUE);
            C(i,j,k).set_elevation(10/resolution);
            C(i,j,k).set_normal(FALSE);
            if(r!=0)
            {
                for(tempr=1; tempr<=r; tempr++)
                {
                    for(alpha=0.0; alpha<2*PI; alpha+=(2*PI)/(tempr*8))
                    {
                        circle_param(tempr, i, j, x, y, alpha);
                        C(x,y,k).set_influence(TRUE);
                        C(x,y,k).set_normal(FALSE);
                        C(x,y,k).set_elevation(5/(resolution*tempr));
                        for(ii=x-1; ii<=x+1; ii++)
                        {
                            for(jj=y-AMONTMAX; jj<=y+AVALMAX; jj++)
                            {
                                C(ii,jj,k).set_normal(FALSE);
                            }
                        }
                    }
                }
            }
            if(k!=0 && (k%10)==0)                //toutes les 10 générations
            {
                //cout <<"incrémentation à " <<k <<endl;
                if(r==rayon_max)       //tout remettre à zéro
                {
                    //cout <<"rayon max atteint" <<endl;
                    C(i,j,k).set_termite(FALSE);
                    C(i,j,k).set_elevation(0);
                    C(i,j,k).set_normal(TRUE);
                    for(tempr=1; tempr<=r; tempr++)
                    {
                        for(alpha=0.0; alpha<2*PI; alpha+=(2*PI)/(tempr*8))
                        {
                            circle_param(tempr, i, j, x, y, alpha);
                            C(x,y,k).set_influence(FALSE);
                            C(x,y,k).set_normal(TRUE);
                            C(x,y,k).set_elevation(0);
                            for(ii=x-1; ii<=x+1; ii++)
                            {
                                for(jj=y-AMONTMAX; jj<=y+AVALMAX; jj++)
                                {
                                    C(ii,jj,k).set_normal(TRUE);
                                }
                            }
                        }
                    }
                    goto escape2;
                }
                r++;
            }
        }
        escape2:
        //cout <<"fin des termites" <<endl;
    }

/*sortie test*/

    //k=choix_gen[l];
    /*char test[]="test.pgm";
    //strcpy(MNA, pioche_MNA(k));
    fz = fopen(test, "w");
    fputs ("P2\n", fz);
    fputs ("# ", fz);
    fputs(test, fz);
    fputs ("  \n", fz);
    fputs (inttostring(imax), fz);
    fputs ("  ", fz);
    fputs (inttostring(jmax), fz);
    fputs ("  \n255\n", fz);
    for(j=0; j<jmax; j++)
    {
        for(i=0; i<imax; i++)
        {
            if(C(i,j,40).retour_normal())
            {
                fputs(inttostring(0), fz);
            }
            else
            {
                fputs(inttostring(255), fz);
            }
            fputs("  ", fz);
        }
        fputs(" \n", fz);
    }
    //delete [] test;
    fclose(fz);*/

/*fin de sortie test*/

/*calcul des pentes et MNA*/   

    for(k=0; k<=kmax; k++)
    {                                                             
        for(j=0; j<jmax; j++)                                     
        {                                                         
            for(i=0; i<imax; i++)                                 
            {                                                                
                C(i,j,k).set_pente(pente);                    
                C(i,j,k).set_altitude(j, resolution);         
                if(C(i,j,k).retour_influence()==1)      
                {                                             
                    temp_float=0.0;
                    temp_float=C(i,j,k).retour_altitude()-C(i,j-1,k)
                    .retour_altitude();                           
                    C(i,j,k).set_pente(temp_float);
                }
                if(C(i,j-1,k).retour_influence()==TRUE &&
                C(i,j,k).retour_influence()==FALSE)
                {                                        
                    temp_float=0.0;
                    temp_float=C(i,j,k).retour_altitude()-
                    C(i,j-1,k).retour_altitude();        
                    C(i,j,k).set_pente(temp_float);
                }                                        
            }
        }
    }
    if(MNA)
    {               
        int choix_gen[101]={0}, buffer=0;
        char *MNA=0;
        float minimum=0.0, maximum=0.0, difference=0.0;
        minimum=10000.0;                           //sinon minimum reste à 0
        for(k=0; k<=kmax; k++)                                
        {                                                     
            for(j=0; j<jmax; j++)                             
            {                                                 
                for(i=0; i<imax; i++)                         
                {                                             
                    temp_float=C(i,j,k).retour_altitude();
                    if(temp_float>maximum)
                        maximum=temp_float;
                    if(temp_float<minimum)
                        minimum=temp_float;
                }                                             
            }                                                                
        }                                                            
        difference=maximum-minimum;                           
        
        for(i=0; i<=kmax; i++)    
        {                         
            choix_gen[i]=i;       
        }                         
        for(l=0; l<kmax; l++)
        {                                                           
            k=choix_gen[l];                                         
            MNA=new char[10];                                       
            strcpy(MNA, pioche_MNA(k));                             
            fz = fopen(MNA, "w");
            fputs ("P2\n", fz);
            fputs ("# ", fz);
            fputs(MNA, fz);
            fputs ("  \n", fz);
            fputs (inttostring(imax), fz);
            fputs ("  ", fz);
            fputs (inttostring(jmax), fz);
            fputs ("  \n255\n", fz);
            for(j=0; j<jmax; j++)
            {
                for(i=0; i<imax; i++)
                {
                    fputs(inttostring(int(((C(i,j,k).retour_altitude()-minimum)/difference)*255)), fz);
                    fputs("  ", fz);
                }
                fputs(" \n", fz);
            }
            delete [] MNA;
            fclose(fz);
        }
    }

/*début de la fonction de transition*/  

    if(kmax!=0)
    {                                 
        int n=0, somme1=0, nvaleur=0, coef_amont=-1, coef_aval=1;
        BOOL interrupt1=FALSE, interrupt2=FALSE, sens1=FALSE, sens2=FALSE;
        max_tick=200;

        for(k=0; k<kmax; k++)   
        {                                                              
            for(j=0; j<jmax; j++)
            {                                                          
                for(i=0;i<imax; i++)                                   
                {                    
                    if(C(i,j,k).retour_termite() || C(i,j,k).retour_influence()!=0)
                    {
                        //C(i,j,k).set_valeur(0);
                        C(i,j,k+1).set_valeur(0);
                        goto escape_termite;
                    }
                    
                    if(j<AMONTMAX)
                    {
                        for(ii=i-1; ii<=i+1; ii++)
                        {
                            for(jj=-1; jj>=j-AMONTMAX; jj--)
                            {
                                C(ii,jj,k).set_altitude(C(ii,jj+1,k)
                                .retour_altitude()+(pente/resolution));
                                //cout <<C(ii,jj,k).retour_altitude() <<endl;
                            }
                        }
                    }

                    if(j>(jmax-1-AVALMAX))
                    {
                        for(ii=i-1; ii<=i+1; ii++)
                        {
                            for(jj=jmax; jj<=j+AVALMAX; jj++)
                            {
                                C(ii,jj,k).set_altitude(C(ii,jj-1,k)
                                .retour_altitude()-(pente/resolution));
                            }
                        }
                    }

                    /*si la cellule est normale -> matrice de convolution */

                    if(C(i,j,k).retour_normal())
                    {

                        /*partie en amont*/
                        coef_aval=1;

                        amont=0;
                        for(ii=i-1; ii<=i+1; ii++)
                        {
                            for(jj=j; jj>j-AMONTMAX; jj--)
                            {
                                if(jj<=0)
                                {
                                    coef_prox=(float(AMONTMAX)-float(j+abs(jj)))/float(AMONTMAX);
                                }
                                if(jj>0)
                                {
                                    coef_prox=(float(AMONTMAX)-float(j-jj))/float(AMONTMAX);
                                }
                                if(C(ii,jj,k).retour_altitude()<C(ii,jj-1,k).retour_altitude())             //la pente va en montant
                                {
                                    if((ii==-1 && jj==-1) || (ii==1 && jj==-1))
                                    {
                                        coef_amont=0;
                                    }
                                    else
                                    {
                                        coef_amont=-1;
                                    }
                                    amont+=(C(ii,jj-1,k).retour_valeur()+norm_pente(C(ii,jj-1,k).retour_pente())+norm_pluie(pluie))*(coef_amont)*(coef_prox);
                                }
                                /*if(C(ii,jj,k).retour_altitude()>C(ii,jj-1,k).retour_altitude() )             //la pente va en descendant
                                {
                                    amont+=(C(ii,jj-1,k).retour_valeur()+norm_pente(C(ii,jj-1,k).retour_pente())+norm_pluie(pluie))*(coef_amont)*(coef_prox);
                                }*/
                            }
                        }
                        //cout <<amont <<endl;

                        /*fin d'amont*/

                        /*voisins*/

                        voisins=0;
                        for(ii=i-2; ii<=i+2; ii++)
                        {
                            if(ii!=i)
                            {
                                voisins+=C(ii,jj,k).retour_valeur();
                            }
                        }
                        //cout <<voisins <<endl;

                        /*fin de voisins*/

                        /*partie en aval*/

                        aval=0;
                        for(ii=i-1; ii<=i+1; ii++)
                        {
                            for(jj=j; jj<j+AVALMAX; jj++)
                            {
                                coef_prox=(float(AVALMAX)-(float(jj)-float(j)))/float(AVALMAX);
                                if(C(ii,jj+1,k).retour_altitude()<C(ii,jj,k).retour_altitude())                //la pente va en descendant
                                {
                                    aval+=(C(ii,jj+1,k).retour_valeur()+norm_pente(C(ii,jj+1,k).retour_pente())+norm_pluie(pluie))*(coef_aval)*(coef_prox);
                                }
                                /*if(C(ii,jj+1,k).retour_altitude()>C(ii,jj,k).retour_altitude())                 //la pente va en montant
                                {
                                    aval+=(C(ii,jj+1,k).retour_valeur()+norm_pente(C(ii,jj+1,k).retour_pente())+norm_pluie(pluie))*(coef_aval)*(coef_prox);
                                }*/
                            }
                        }
                        //cout <<aval <<endl;

                        /*fin d'aval*/
                    }

                    /* si la cellule n'est pas normale -> changement des coefficients */

                    else
                    {
                        coef_amont=1;
                        coef_aval=-1;
                        //cout <<"cellule pas normale" <<endl;
                        /*partie en amont*/

                        amont=0;
                        for(ii=i-1; ii<=i+1; ii++)  
                        {
                            for(jj=j; jj>j-AMONTMAX; jj--)
                            {
                                /*if((ii==-1 && jj==-1) || (ii==1 && jj==-1))
                                {
                                    coef_amont=0;
                                }
                                else
                                {
                                    coef_amont=-1;
                                }*/
                                if(jj<=0)
                                {
                                    coef_prox=(float(AMONTMAX)-float(j+abs(jj)))/float(AMONTMAX);
                                }
                                if(jj>0)
                                {
                                    coef_prox=(float(AMONTMAX)-float(j-jj))/float(AMONTMAX);
                                }
                                if(C(ii,jj,k).retour_altitude()<C(ii,jj-1,k).retour_altitude())             //la pente va en montant
                                {
                                    //cout <<"termitière amont" <<endl;
                                    if(C(ii,jj-1,k).retour_normal())  //si les cellules voisines deviennent normales -> arrêt
                                    {
                                        goto hop1;
                                    }
                                    amont+=(C(ii,jj-1,k).retour_valeur()+norm_pente(C(ii,jj-1,k).retour_pente())+norm_pluie(pluie))*(1);//(coef_prox);
                                }
                                /*if(C(ii,jj,k).retour_altitude()>C(ii,jj-1,k).retour_altitude() )             //la pente va en descendant
                                {
                                    if(C(ii,jj-1,k).retour_normal())  //si les cellules voisines deviennent normales -> arrêt
                                    {
                                        goto hop1;
                                    }
                                    amont+=(C(ii,jj-1,k).retour_valeur()+norm_pente(C(ii-1,jj,k).retour_pente())+norm_pluie(pluie))*(coef_amont)*(coef_prox);
                                }*/
                            }
                        }
                        hop1:

                        /*fin d'amont*/

                        /*voisins*/

                        voisins=0;
                        for(ii=i-2; ii<=i+2; ii++)
                        {
                            if(ii!=i)
                            {
                                voisins+=C(ii,jj,k).retour_valeur();
                            }
                        }

                        /*fin de voisins*/

                        /*partie en aval*/

                        aval=0;
                        for(ii=i-1; ii<=i+1; ii++)
                        {
                            for(jj=j; jj<j+AVALMAX; jj++)
                            {
                                coef_prox=(float(AVALMAX)-(float(jj)-float(j)))/float(AVALMAX);
                                if(C(ii,jj+1,k).retour_altitude()<C(ii,jj,k).retour_altitude())                //la pente va en descendant
                                {
                                    //cout <<"termitière aval" <<endl;
                                    if(C(ii,jj+1,k).retour_normal())           //si la pente change de signe ->arret
                                    {
                                        goto hop2;
                                    }
                                    aval+=(C(ii,jj+1,k).retour_valeur()+norm_pente(C(ii,jj+1,k).retour_pente())+norm_pluie(pluie))*(-1);//(coef_prox);
                                }
                                /*if(C(ii,jj+1,k).retour_altitude()>C(ii,jj,k).retour_altitude())                 //la pente va en montant
                                {
                                    if(C(ii,jj,k).retour_altitude()>C(ii,jj+1,k).retour_altitude())
                                    {
                                        goto hop2;
                                    }
                                    aval+=(C(ii,jj+1,k).retour_valeur()+norm_pente(C(ii,jj+1,k).retour_pente())+norm_pluie(pluie))*(coef_aval)*(coef_prox);
                                }*/
                            }
                        }
                        hop2:

                        /*fin d'aval*/
                    }

                    somme1=amont+voisins+aval;    //addition finale

                    nvaleur=C(i,j,k).retour_valeur()+normalisation(somme1);
                    C(i,j,k+1).set_valeur(nvaleur);

                    if(C(i,j,k+1).retour_valeur()<0)   
                        C(i,j,k+1).set_valeur(0);
                    if(C(i,j,k+1).retour_valeur()>valeur_max)
                        C(i,j,k+1).set_valeur(valeur_max);

                    if(j<AMONTMAX)
                    {
                        for(ii=i-1; ii<=i+1; ii++)
                        {
                            for(jj=j-AMONTMAX; jj<=-1; jj++)
                            {
                                C(ii,jj,k).set_altitude(C(ii,jj-1,k)
                                .retour_altitude()-(pente/resolution));
                            }
                        }
                    }

                    if(j>(jmax-1-AVALMAX))
                    {
                        for(ii=i-1; ii<=i+1; ii++)
                        {
                            for(jj=j+AVALMAX; jj>=jmax; jj--)
                            {
                                C(ii,jj,k).set_altitude(C(ii,jj+1,k)
                                .retour_altitude()+(pente/resolution));
                            }
                        }
                    }

                    if(previsual)
                    {
                        switch(C(i,j,k).retour_valeur())
                        {
                            case(0):
                            {
                                RectFill ( &winport_blanc, (i*zoom)+20, (j*zoom)+20, (i*zoom)+zoom+20, (j*zoom)+zoom+20);
                            }
                                break;
                            case(1):
                            {
                                RectFill ( &winport_gris1, (i*zoom)+20, (j*zoom)+20, (i*zoom)+zoom+20, (j*zoom)+zoom+20);
                            }
                                break;
                            case(2):
                            {
                                RectFill ( &winport_gris2, (i*zoom)+20, (j*zoom)+20, (i*zoom)+zoom+20, (j*zoom)+zoom+20);
                            }
                                break;
                            case(3):
                            {
                                RectFill ( &winport_gris3, (i*zoom)+20, (j*zoom)+20, (i*zoom)+zoom+20, (j*zoom)+zoom+20);
                            }
                                break;
                            case(4):
                            {
                                RectFill ( &winport_gris4, (i*zoom)+20, (j*zoom)+20, (i*zoom)+zoom+20, (j*zoom)+zoom+20);
                            }
                                break;
                            case(5):
                            {
                                RectFill ( &winport_gris5, (i*zoom)+20, (j*zoom)+20, (i*zoom)+zoom+20, (j*zoom)+zoom+20);
                            }
                                break;
                            case(6):
                            {
                                RectFill ( &winport_gris6, (i*zoom)+20, (j*zoom)+20, (i*zoom)+zoom+20, (j*zoom)+zoom+20);
                            }
                                break;
                            case(7):
                            {
                                RectFill ( &winport_gris7, (i*zoom)+20, (j*zoom)+20, (i*zoom)+zoom+20, (j*zoom)+zoom+20);
                            }
                                break;
                            case(8):
                            {
                                RectFill ( &winport_gris8, (i*zoom)+20, (j*zoom)+20, (i*zoom)+zoom+20, (j*zoom)+zoom+20);
                            }
                                break;
                            case(9):
                            {
                                RectFill ( &winport_gris9, (i*zoom)+20, (j*zoom)+20, (i*zoom)+zoom+20, (j*zoom)+zoom+20);
                            }
                                break;
                            case(10):
                            {
                                RectFill ( &winport_gris10, (i*zoom)+20, (j*zoom)+20, (i*zoom)+zoom+20, (j*zoom)+zoom+20);
                            }
                                break;
                            case(11):
                            {
                                RectFill ( &winport_gris11, (i*zoom)+20, (j*zoom)+20, (i*zoom)+zoom+20, (j*zoom)+zoom+20);
                            }
                                break;
                            case(12):
                            {
                                RectFill ( &winport_gris12, (i*zoom)+20, (j*zoom)+20, (i*zoom)+zoom+20, (j*zoom)+zoom+20);
                            }
                                break;
                            case(13):
                            {
                                RectFill ( &winport_gris13, (i*zoom)+20, (j*zoom)+20, (i*zoom)+zoom+20, (j*zoom)+zoom+20);
                            }
                                break;
                            case(14):
                            {
                                RectFill ( &winport_gris14, (i*zoom)+20, (j*zoom)+20, (i*zoom)+zoom+20, (j*zoom)+zoom+20);
                            }
                                break;
                            case(15):
                            {
                                RectFill ( &winport_noir, (i*zoom)+20, (j*zoom)+20, (i*zoom)+zoom+20, (j*zoom)+zoom+20);
                            }
                                break;
                            default:
                                break;
                        }
                    }                    
                    escape_termite:
                }
                interrupt=IO_boucle();
                if(interrupt)
                {
                    printf("interruption\n");
                    goto interruption;
                }
                temp_tick=j+1;
                tick=inttostring(temp_tick);
                Emperor_SetGadgetAttr(Fuelgauge2, tick);
            }
            temp_tick=k+1;
            tick=inttostring(temp_tick);
            Emperor_SetGadgetAttr(Fuelgauge3, tick);
        }
    }
    interruption:
    if(interrupt)
    {
        SetGadgetAttrs(Fuelgauge2, Window1, NULL, FUELGAUGE_Level, 0 , TAG_DONE);
        SetGadgetAttrs(Fuelgauge3, Window1, NULL, FUELGAUGE_Level, 0 , TAG_DONE);
        DoMethod(winobj, WM_CLOSE);
        win=NULL;
        winobj=NULL;
    }

/*mettre à jour les gadgets concernés pour la seconde phase*/

    SetGadgetAttrs(Fuelgauge2, Window1, NULL, FUELGAUGE_Level, 0 , TAG_DONE);
    SetGadgetAttrs(Fuelgauge3, Window1, NULL, FUELGAUGE_Level, 0 , TAG_DONE);
    SetGadgetAttrs(Button3, Window1, NULL, GA_Disabled, TRUE, TAG_DONE);
    SetGadgetAttrs(Button6, Window1, NULL, GA_Disabled, FALSE, TAG_DONE);
    SetGadgetAttrs(Button7, Window1, NULL, GA_Disabled, FALSE, TAG_DONE);
    SetGadgetAttrs(Button8, Window1, NULL, GA_Disabled, FALSE, TAG_DONE);

/*fin de mise à jour*/

/*reception des signaux après calcul*/

    if(!previsual)
    {
        win = RA_OpenWindow (winobj);
        winport = win->RPort;
        winport_noir = *win->RPort;
        winport_blanc = *win->RPort;
        winport_gris1 = *win->RPort;
        winport_gris2 = *win->RPort;
        winport_gris3 = *win->RPort;
        winport_gris4 = *win->RPort;
        winport_gris5 = *win->RPort;
        winport_gris6 = *win->RPort;
        winport_gris7 = *win->RPort;
        winport_gris8 = *win->RPort;
        winport_gris9 = *win->RPort;
        winport_gris10 = *win->RPort;
        winport_gris11 = *win->RPort;
        winport_gris12 = *win->RPort;
        winport_gris13 = *win->RPort;
        winport_gris14 = *win->RPort;
        SetAPen( &winport_noir, noir );
        SetAPen( &winport_blanc, blanc );
        SetAPen( &winport_gris1, gris1 );
        SetAPen( &winport_gris2, gris2 );
        SetAPen( &winport_gris3, gris3 );
        SetAPen( &winport_gris4, gris4 );
        SetAPen( &winport_gris5, gris5 );
        SetAPen( &winport_gris6, gris6 );
        SetAPen( &winport_gris7, gris7 );
        SetAPen( &winport_gris8, gris8 );
        SetAPen( &winport_gris9, gris9 );
        SetAPen( &winport_gris10, gris10 );
        SetAPen( &winport_gris11, gris11 );
        SetAPen( &winport_gris12, gris12 );
        SetAPen( &winport_gris13, gris13 );
        SetAPen( &winport_gris14, gris14 );
    }
    fermer=FALSE;
    Emperor_Input=0L;
    do
    {
        while((Emperor_Input = RA_HandleInput(WindowObject1, &Emperor_Code)) != WMHI_LASTMSG)
        {
            //printf("input reçu: %d\n", Emperor_Input);
            switch(Emperor_Input & WMHI_CLASSMASK)
            {
                case WMHI_GADGETUP:
                    switch(Emperor_Input & WMHI_GADGETMASK)
                    {
                        case 39:
                            Button3_GadgetUp_Event();
                            break;
                        case 42:
                            //Button6_GadgetUp_Event();
                            //printf("case fermer: %d\n");
                            DoMethod(winobj, WM_CLOSE);
                            win=NULL;
                            winobj=NULL;
                            fermer=TRUE;
                            break;
                        case 46:
                            //Button7_GadgetUp_Event();
                            for(k=kmax-1; k>=0; k--)
                            {
                                for(j=0; j<jmax; j++)
                                {
                                    for(i=0;i<imax; i++)
                                    {
                                        switch(C(i,j,k).retour_valeur())
                                        {
                                            case(0):
                                            {
                                                RectFill ( &winport_blanc, (i*zoom)+20, (j*zoom)+20, (i*zoom)+zoom+20, (j*zoom)+zoom+20);
                                            }
                                                break;
                                            case(1):
                                            {
                                                RectFill ( &winport_gris1, (i*zoom)+20, (j*zoom)+20, (i*zoom)+zoom+20, (j*zoom)+zoom+20);
                                            }
                                                break;
                                            case(2):
                                            {
                                                RectFill ( &winport_gris2, (i*zoom)+20, (j*zoom)+20, (i*zoom)+zoom+20, (j*zoom)+zoom+20);
                                            }
                                                break;
                                            case(3):
                                            {
                                                RectFill ( &winport_gris3, (i*zoom)+20, (j*zoom)+20, (i*zoom)+zoom+20, (j*zoom)+zoom+20);
                                            }
                                                break;
                                            case(4):
                                            {
                                                RectFill ( &winport_gris4, (i*zoom)+20, (j*zoom)+20, (i*zoom)+zoom+20, (j*zoom)+zoom+20);
                                            }
                                                break;
                                            case(5):
                                            {
                                                RectFill ( &winport_gris5, (i*zoom)+20, (j*zoom)+20, (i*zoom)+zoom+20, (j*zoom)+zoom+20);
                                            }
                                                break;
                                            case(6):
                                            {
                                                RectFill ( &winport_gris6, (i*zoom)+20, (j*zoom)+20, (i*zoom)+zoom+20, (j*zoom)+zoom+20);
                                            }
                                                break;
                                            case(7):
                                            {
                                                RectFill ( &winport_gris7, (i*zoom)+20, (j*zoom)+20, (i*zoom)+zoom+20, (j*zoom)+zoom+20);
                                            }
                                                break;
                                            case(8):
                                            {
                                                RectFill ( &winport_gris8, (i*zoom)+20, (j*zoom)+20, (i*zoom)+zoom+20, (j*zoom)+zoom+20);
                                            }
                                                break;
                                            case(9):
                                            {
                                                RectFill ( &winport_gris9, (i*zoom)+20, (j*zoom)+20, (i*zoom)+zoom+20, (j*zoom)+zoom+20);
                                            }
                                                break;
                                            case(10):
                                            {
                                                RectFill ( &winport_gris10, (i*zoom)+20, (j*zoom)+20, (i*zoom)+zoom+20, (j*zoom)+zoom+20);
                                            }
                                                break;
                                            case(11):
                                            {
                                                RectFill ( &winport_gris11, (i*zoom)+20, (j*zoom)+20, (i*zoom)+zoom+20, (j*zoom)+zoom+20);
                                            }
                                                break;
                                            case(12):
                                            {
                                                RectFill ( &winport_gris12, (i*zoom)+20, (j*zoom)+20, (i*zoom)+zoom+20, (j*zoom)+zoom+20);
                                            }
                                                break;
                                            case(13):
                                            {
                                                RectFill ( &winport_gris13, (i*zoom)+20, (j*zoom)+20, (i*zoom)+zoom+20, (j*zoom)+zoom+20);
                                            }
                                                break;
                                            case(14):
                                            {
                                                RectFill ( &winport_gris14, (i*zoom)+20, (j*zoom)+20, (i*zoom)+zoom+20, (j*zoom)+zoom+20);
                                            }
                                                break;
                                            case(15):
                                            {
                                                RectFill ( &winport_noir, (i*zoom)+20, (j*zoom)+20, (i*zoom)+zoom+20, (j*zoom)+zoom+20);
                                            }
                                                break;
                                            default:
                                                break;
                                        }
                                    }
                                }
                                temp_tick=k;
                                tick=inttostring(temp_tick);
                                Emperor_SetGadgetAttr(Fuelgauge3, tick);
                            }
                            break;
                        case 47:
                            //Button8_GadgetUp_Event();
                            for(k=0; k<kmax; k++)
                            {
                                for(j=0; j<jmax; j++)
                                {
                                    for(i=0;i<imax; i++)
                                    {
                                        switch(C(i,j,k).retour_valeur())
                                        {                                            
                                            case(0):
                                            {
                                                RectFill ( &winport_blanc, (i*zoom)+20, (j*zoom)+20, (i*zoom)+zoom+20, (j*zoom)+zoom+20);
                                            }
                                                break;
                                            case(1):
                                            {
                                                RectFill ( &winport_gris1, (i*zoom)+20, (j*zoom)+20, (i*zoom)+zoom+20, (j*zoom)+zoom+20);
                                            }
                                                break;
                                            case(2):
                                            {
                                                RectFill ( &winport_gris2, (i*zoom)+20, (j*zoom)+20, (i*zoom)+zoom+20, (j*zoom)+zoom+20);
                                            }
                                                break;
                                            case(3):
                                            {
                                                RectFill ( &winport_gris3, (i*zoom)+20, (j*zoom)+20, (i*zoom)+zoom+20, (j*zoom)+zoom+20);
                                            }
                                                break;
                                            case(4):
                                            {
                                                RectFill ( &winport_gris4, (i*zoom)+20, (j*zoom)+20, (i*zoom)+zoom+20, (j*zoom)+zoom+20);
                                            }
                                                break;
                                            case(5):
                                            {
                                                RectFill ( &winport_gris5, (i*zoom)+20, (j*zoom)+20, (i*zoom)+zoom+20, (j*zoom)+zoom+20);
                                            }
                                                break;
                                            case(6):
                                            {
                                                RectFill ( &winport_gris6, (i*zoom)+20, (j*zoom)+20, (i*zoom)+zoom+20, (j*zoom)+zoom+20);
                                            }
                                                break;
                                            case(7):
                                            {
                                                RectFill ( &winport_gris7, (i*zoom)+20, (j*zoom)+20, (i*zoom)+zoom+20, (j*zoom)+zoom+20);
                                            }
                                                break;
                                            case(8):
                                            {
                                                RectFill ( &winport_gris8, (i*zoom)+20, (j*zoom)+20, (i*zoom)+zoom+20, (j*zoom)+zoom+20);
                                            }
                                                break;
                                            case(9):
                                            {
                                                RectFill ( &winport_gris9, (i*zoom)+20, (j*zoom)+20, (i*zoom)+zoom+20, (j*zoom)+zoom+20);
                                            }
                                                break;
                                            case(10):
                                            {
                                                RectFill ( &winport_gris10, (i*zoom)+20, (j*zoom)+20, (i*zoom)+zoom+20, (j*zoom)+zoom+20);
                                            }
                                                break;
                                            case(11):
                                            {
                                                RectFill ( &winport_gris11, (i*zoom)+20, (j*zoom)+20, (i*zoom)+zoom+20, (j*zoom)+zoom+20);
                                            }
                                                break;
                                            case(12):
                                            {
                                                RectFill ( &winport_gris12, (i*zoom)+20, (j*zoom)+20, (i*zoom)+zoom+20, (j*zoom)+zoom+20);
                                            }
                                                break;
                                            case(13):
                                            {
                                                RectFill ( &winport_gris13, (i*zoom)+20, (j*zoom)+20, (i*zoom)+zoom+20, (j*zoom)+zoom+20);
                                            }
                                                break;
                                            case(14):
                                            {
                                                RectFill ( &winport_gris14, (i*zoom)+20, (j*zoom)+20, (i*zoom)+zoom+20, (j*zoom)+zoom+20);
                                            }
                                                break;
                                            case(15):
                                            {
                                                RectFill ( &winport_noir, (i*zoom)+20, (j*zoom)+20, (i*zoom)+zoom+20, (j*zoom)+zoom+20);
                                            }
                                                break;
                                            default:
                                                break;
                                        }
                                    }
                                }
                                temp_tick=k+1;
                                tick=inttostring(temp_tick);
                                Emperor_SetGadgetAttr(Fuelgauge3, tick);
                            }
                            break;
                        default:
                            fermer=FALSE;
                            break;
                    }
                default:
                    break;
            }
        }
    }
    while(fermer==FALSE);

    SetGadgetAttrs(String1, Window1, NULL, GA_Disabled, FALSE, TAG_DONE);
    SetGadgetAttrs(Integer1, Window1, NULL, GA_Disabled, FALSE, TAG_DONE);
    SetGadgetAttrs(Integer2, Window1, NULL, GA_Disabled, FALSE, TAG_DONE);
    SetGadgetAttrs(Integer3, Window1, NULL, GA_Disabled, FALSE, TAG_DONE);
    SetGadgetAttrs(Integer4, Window1, NULL, GA_Disabled, FALSE, TAG_DONE);
    SetGadgetAttrs(Integer5, Window1, NULL, GA_Disabled, FALSE, TAG_DONE);
    SetGadgetAttrs(Integer6, Window1, NULL, GA_Disabled, FALSE, TAG_DONE);
    SetGadgetAttrs(Button1, Window1, NULL, GA_Disabled, FALSE, TAG_DONE);
    SetGadgetAttrs(Button2, Window1, NULL, GA_Disabled, FALSE, TAG_DONE);
    SetGadgetAttrs(Slider1, Window1, NULL, GA_Disabled, FALSE, TAG_DONE);
    SetGadgetAttrs(Checkbox1, Window1, NULL, GA_Disabled, FALSE, TAG_DONE);
    SetGadgetAttrs(Checkbox2, Window1, NULL, GA_Disabled, FALSE, TAG_DONE);

/*fin de reception*/

    /*int choix_gen[101]={0};
    char *pgm=0;
    for(i=0; i<=kmax; i++)
    {
        choix_gen[i]=i;
    }
    for(l=0; l<kmax; l++)
    {
        k=choix_gen[l];
        pgm=new char[10];
        strcpy(pgm, pioche_pgm(k));
        fz = fopen(pgm, "w");
        fputs ("P2\n", fz);
        fputs ("# ", fz);
        fputs(pgm, fz);
        fputs ("  \n", fz);
        fputs (inttostring(imax), fz);
        fputs ("  ", fz);
        fputs (inttostring(jmax), fz);
        fputs ("  \n", fz);
        fputs (inttostring(valeur_max+1), fz);
        fputs ("  \n", fz);
        for(j=0; j<jmax; j++)
        {
            for(i=0; i<imax; i++)
            {
                fputs (inttostring((C(i,j,k).retour_valeur()-valeur_max)*(-1)), fz);
                fputs ("  ", fz);
            }
            fputs (" \n", fz);
        }
        delete [] pgm;
        fclose(fz);
    }*/
    SetGadgetAttrs(Button3, Window1, NULL, GA_Disabled, TRUE, TAG_DONE);
    SetGadgetAttrs(Button6, Window1, NULL, GA_Disabled, TRUE, TAG_DONE);
    SetGadgetAttrs(Button7, Window1, NULL, GA_Disabled, TRUE, TAG_DONE);
    SetGadgetAttrs(Button8, Window1, NULL, GA_Disabled, TRUE, TAG_DONE);
}  

void Window1_Iconify_Event(void)
{
    Emperor_IconifyWindow_Window1();
}

void Window1_Uniconify_Event(void)
{    
    Emperor_UniconifyWindow_Window1();
}

void Button3_GadgetUp_Event(void)
{
}

void Button4_GadgetUp_Event(void)
{
}

void Button5_GadgetUp_Event(void)
{
}

void Button6_GadgetUp_Event(void)
{
}

void Button7_GadgetUp_Event(void)
{
}

void Button8_GadgetUp_Event(void)
{
}

