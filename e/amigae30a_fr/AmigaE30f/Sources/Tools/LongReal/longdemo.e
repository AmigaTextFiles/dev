/* programme exemple pour le module longreal */
/* Par EA van Breemen 1994                   */


/* !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!! */
/* Pour utiliser les fonctions de conversion, prenez le type */
/* STRING pour les tampons, pas ARRAY. Sinon les fonctions   */
/* produiront des résultats non attendus                     */

/* Notez des erreurs d'arrondi peuvent arriver ceci à cause  */
/* de l'IEEE                                                 */
/* Dans les futures distribution, ce sera réparé             */


/* Quelques notes sur les fonctions en réels longs           */

/* Beaucoup de fonctions sont décrites dans les ROMKernals.  */
/* Regardez le chapitre sur les fonctions IEEE               */
/* Il y a 3 fonctions de conversion ascii-longreal           */

/* dFormat(buffer,x,num)  -> convertis le nombre fractionnel x avec
                             num digits en une chaine du buffer

   dLFormat(buffer,x,num) -> même que dFormat, mais maintenant aussi
                             de grand nombres ie 1.2e250

   a2d(buffer,x)          -> l'inverse de dLFormat: convertis une
                             chaine ascii du buffer en longreal x
*/


/* Incluez ce module pour utilisez les longreals */

MODULE 'tools/longreal'


/* Notre petit programme Main */

PROC main()
  DEF buffer[256]:STRING     /* Très important: utilisez STRING pour le buffer !!!! */
  DEF a:longreal             /* Notre variable réel long pour les résulats          */
  DEF i                      /* Un simple compteur                                  */

  dInit()                    /* Initialise le module avant l'utilisation */

  WriteF('D'abord quelques conversions:\n')
  WriteF('Lecture de 1.234567      -> donne: ')

  a2d('1.234567',a)          /* Convertis de l'ascii en longreal */
  dFormat(buffer,a,6)        /* et retour (6 digits)             */
  WriteF('\s\n',buffer)      /* L'affiche                        */

  WriteF('Lecture de +1.234567e-2  -> donne: ')

  a2d('+1.234567e-2',a)      /* Convertis de l'ascii en longreal */
  dFormat(buffer,a,6)        /* et retour (6 digits)             */
  WriteF('\s\n',buffer)      /* L'affiche                        */


  WriteF('Lecture de -1.234567E100 -> donne: ')

  a2d('-1.234567E100',a)     /* Convertis de l'ascii en longreal */

/* Maintenant le nombre est trop grand pour dFormat, on utilise dLFormat */

  dLFormat(buffer,a,6)       /* et retour (6 digits)             */
  WriteF('\s\n',buffer)      /* L'affiche                        */

  WriteF('Maintenant, autre chose\n')

  FOR i:=1 TO 16
    WriteF('PI=\s \n',dFormat(buffer,dPi(a),i))
  ENDFOR

  WriteF('A sinus table\n')
  FOR i:=0 TO 360 STEP 45
    dFloat(i,a)              /* Convertis un entier en un longreal */
    dSin(dRad(a))
    WriteF('Sin(\d)=\s \n',i,dLFormat(buffer,a,15))
  ENDFOR

  WriteF('Find de longdemo\n')

  dCleanup()                 /* Nettoie le module après utilisation */

ENDPROC
