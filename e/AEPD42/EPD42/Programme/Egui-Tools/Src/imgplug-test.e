OPT     OSVERSION=37            /* EasyGUI arbeitet erst ab V.37*/

MODULE  'icon'                  /* Zum laden des Icons...       */
MODULE  'intuition/intuition'   /* Für das image-object...      */
MODULE  'plugin/imgplug'        /* für das image-plugin         */
MODULE  'tools/easygui'         /* für easygui                  */
MODULE  'workbench/workbench'   /* Objecte ect...               */

 DEF    p:PTR TO imgplug,       /* Pointer auf das imgplug-Obj  */
        file:PTR TO diskobject, /* Pointer auf das Diskobject   */
        icon:PTR TO gadget,     /* Pointer auf das Gadgetobj... */
        image:PTR TO image,     /* Und hier endlich der Img.PTR */
        select:PTR TO image     /* Selektiertes Image           */

PROC main()     HANDLE                                          /* MAIN-Prozedur mit EXCEPTION-HANDLING */
 DEF    ourtask                                                 /* Zeiger auf unseren Task...           */
  ourtask:=FindTask(NIL)                                        /* Unseren Task ausfindig machen...     */
   SetTaskPri(ourtask,-2)                                       /* Da wir ja praktisch nix tun sollen...*/
    IF (iconbase:=OpenLibrary('icon.library',37))=NIL THEN Raise('dummy')       /* iconlibrary öffnen   */
     IF (file:=GetDiskObject(arg))=NIL THEN Raise('dummy')      /* Icon öffnen (arg=filename)           */
      icon:=file.gadget                                         /* Gadget aus dem Image holen           */
       image:=icon.gadgetrender                                 /* Image-Daten (gadgetrender)           */
        select:=icon.selectrender                               /* Image-Daten des Selektieren Gadgets  */
         WriteF(' Click on the Image and look what happens...:-)\n\n')  /* Text ausgeben...             */
          easygui('Image-Plugintest!',                          /* EasyGUI-Prozedur                     */
                [ROWS,
                [PLUGIN, {msg}, NEW p.create(image,IMG_ALTERNATIVE,select)],    /* Imgobjekt initialisieren     */
                [SBUTTON,{dummy},'DUMMY']])
EXCEPT DO                                                       /* Exception Handling...                */
      END p                                                     /* Speicher für p wieder freigeben      */
     IF file THEN FreeDiskObject(file)                          /* Iconimage wieder freigeben           */
    IF iconbase THEN CloseLibrary(iconbase)                     /* icon.library wieder schließen        */
   IF exception THEN CleanUp(20) ELSE CleanUp(0)                /* CleanUp() DOS-Returnwert setzen      */
ENDPROC                                                         /* Ende der MainProzedur...             */

PROC msg()                                                      /* Solle normal beim anklicken des      */
 WriteF(' Pressed! \n')                                         /* Plugins ausgegeben werden ,aber das  */
ENDPROC                                                         /* akt. EasyGUI macht das (?) nicht!    */

PROC dummy()                                                    /* Ein Dummy...                         */
ENDPROC                                                         /* Ende der Prozedur                    */
