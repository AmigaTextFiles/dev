@database TransCat
@master //Misc/Catalogos/Transcat/TransCat_Spanish.guide
@author "zIgUS"
@remark Created with Heddley v1.1 (c) Edd Dumbill 1994

@node "Main" "TransCat.guide"


                              @{b}TransCat@{ub} v1.13
                              **************
                               [20.10.1998]


             @{"   Copyright    " link "Copyright" 0}  Información legal de TransCat.
             @{"  Instalación   " link "Installation" 0}  Como instalar TransCat.
             @{"  Introducción  " link "Introduction" 0}  Introducción a TransCat.
             @{"      Uso       " link "Use" 0}  Como usar TransCat.
             @{"   El futuro    " link "The Future" 0}  El futuro de TransCat.
             @{"    Historia    " link "History" 0}  La historia, siempre la historia...
             @{"  Traducciones  " link "Translation" 0}  Traducción de catalogos.

             @{"     Autor      " link "Contact" 0}  Mi dirección.
@endnode

@node "Copyright" "Legal Information on TransCat."

 Importante:
 ===========

 TransCat es © 1998 de zIgUS. Todos los derechos reservados.

 TransCat es Shareware. Vd. puede registrarse pagando 50 FF, 15 US$ o 25 DM
 @{"registro" link "Registration" 0}. De esta manera recibira la versión completa.

 Esta versión de demostración puede ser distribuida libremente.
 Los usuarios registrados no pueden compartir o distribuir su versión
 completa del programa.

 TransCat es proporcionado tal como es: Sin ningun tipo de garantia 
 implicita. En cualquier caso, vd. no podrá hacer responsable directa
 o indirectamente al autor por los posibles daños o perdidas de datos
 que se puedan ocasionar por el uso de este programa.
 Todos los riesgos derivados del uso de este programa son asumidos por
 el usuario en el momento en que comienza a usarlo.ç

 Todos los ficheros asociados, incluyendo este archivo, no pueden ser 
 cambiados o alterados de ninguna manera. Cualquier versión modificada
 debe ser puesta en conocimiento del autor.

 El uso de versiones manipuladas o "crackeadas" de este programa puede
 causarle serias sorpresas y poner en peligro el futuro desarrollo del
 mismo.
@endnode

@node "Registration" "Registration to TransCat."

 TransCat es Shareware. Esta versión demo tiene las siguientes restricciones:

  · No permite grabar traducciones de catálogos (.ct).
  · El autor no puede poner su nombre en el fichero.catalog

 Vd. puede recibir la versión completa registrandose. Esto es posible
 mediante el pago del registro consistente en 50 FF, 15 US$ or 25 DM
 
 Esta cantidad es valida si el autor obtiene actualmente 50 FF.
 Si se envia menos cantidad vd. no podra registrarse hasta que
 se obtenga la suma arriba indicada.

 Si vd. posee una impresora, puede usar el formulario de registro
 para regitrarse.


 Envieme el formulario de registro a la siguiente dirección :

      K L A X
      P.O Box 14
      21601 Longvic CEDEX
      Francia

 
 El registro sera llevado a cabo tan pronto como sea posible.

 Debo entonces darle las gracias por apoyar mi trabajo.
 Recuerde : Al comprar software contribuye a que siga desarrolandose y
            aparezcan nuevas versiones.
@endnode

@node "Installation" "How install it..."

 @{b}Instalación@{ub}

 ¡Nada complicado!

 Solamente copie el directorio del programa donde vd. desee y la libreria
 "fgl.library" dentro del directorio "DEVS:" de sus sistema.
@endnode

@node "Introduction" "About TransCat..."

  Programado por zIgUS  © 1998
  TransCat solo corre en un A1200 o superior.


  TransCat usa las siguientes librerias :

      - fgl.library
      - asl.library

  Asi como @{"MUI" link "mui" 0} 3.6 o superior.

  TransCat ha sido programado 100% en ensamblador optimizado. Si encuentra
  algun error o tiene alguna sugerencia para otras opciones, @{"Contacte conmigo" link "Contact" 0}.
@endnode

@node "MUI" "About of MUI..."


                     @{b}MUI - Interface Magico del Usuario@{ub}

                   (c) Copyright 1993/97 de Stefan Stuntz


 MUI is un sistema para confgurar cualquier interface grafico de usuario
 con la ayuda de un software controlado por preferencias, el usuario 
 tiene la posibildad de personalizar el interface a su gusto.

 MUI es distribuido bajo el concepto "shareware". Para obtener el archivo
 completo, que contiene gran cantidad de ejemplos y mas información, 
 consulte el archivo llamado "muiXXusr.lha" (XX para el numero de versión)
 en su BBS, dominio publico o Aminet.

      Si desea registrarse a MUI, vd. puede enviar


                            DM 30.- o US$ 20.-

                                     a

                                Stefan Stuntz
                          Eduard-Spranger-Straße 7
                                80935 München
                                   ALEMANIA
@endnode

@node "Use" "How to use TransCat..."
                        _          ._______  ___       .--.__ 
                       ¡¬\         |      / ¡  ¬\_____ |  ¦ ¬|
                       | _\  /\    ¦  ___/  |    \   / |  |  |
                       ¦  \\// \   | __)_   |  \  \ /  |  |  |
                       `---\/   \  |    ¬\  |  ¦\  /   |  ¯  |
                            l____\ l______\ `--' \/    l_____¦

                       ---------------------------------------
                       @{"Proyecto" link "project" 0}  @{"Acciones" link "actions" 0}  @{"importar" link "import" 0}  @{"exportar" link "export" 0}

 @{b}Filter@{ub} :       Permite buscar un nombre en un catalogo. Vd. puede usar
                un comodin con la tecla "*".
                Atajo: "f".

 @{b}Translated@{ub} :   Proporciona el porcentaje de elementos traducidos.

 @{b}Number@{ub} :       Muestra el numero de cadenas traducidas.

 @{b}Display@{ub} :      Permite mostrar todos, o solamente los elementos sin traducir
                en el catálogo (en este modo, la sentencia traducida
                desaparecerá)
                Atajo: "a".

 @{b}Elements@{ub} :     Muestra el numero de elementos presentes en el catálogo.

 @{b}Shortcut "e"@{ub} : Permite editar la cadena seleccionada.

 @{b}Shortcut "c"@{ub} : Permite copiar la cadena seleccionada.
@endnode

@node "Project" "Project Menu"

 @{b}Open catalog@{ub} : Permite cargar un gatálogo.

 @{b}Save catalog@{ub} : Permite un catálogo con sus modificaciones.

 @{b}Catalog information@{ub} : Muestra información sobre el catálogo:
                           - Nombre del autor (Solo versión registrada).
                           - Nombre del catálogo.
                           - Lenguaje del catálogo (Solo versión registrada).
                           - Versión del catálogo.
                           - Revisión del catálogo.

 @{b}About@{ub} : Información sobre TransCat y el usuario registrado.   


 @{b}Quit@{ub} : Permite salir de TransCat.
@endnode

@node "Actions" "Actions Menu"

 @{b}Fill empty strings@{ub} : Permite rellenar todas las cadenas vacias 
                      en el catálogo.

 @{b}Search a number@{ub} : Permite buscar un numero en el catálogo.
@endnode

@node "Import" "Import Menu"

 @{b}Catalog Description@{ub} : Carga un catálogo de descripcción (.cd),
                       generalmente proporcionado por el autor del soft.

 @{b}Catalog Translation@{ub} : Carga un catálogo de traducción (.ct), 
                       ¡¡¡ hecho por ti mismo !!!
@endnode

@node "Export" "Export Menu"

 @{b}Catalog Description@{ub} : Permite grabar un catálogo de descripción.

 @{b}Catalog Translation@{ub} : Permite grabar tu catálogo de traducción.
                       (Solo usuarios registrados)

 @{b}Constants ASM@{ub} :       Crea un fichero con constantes para ensamblador.

 @{b}Constants C@{ub} :         Crea un fichero con constantes para C.

 @{b}Constants E@{ub} :         Crea un fichero con constantes para E.

 @{b}Constants Blitz@{ub} :     Crea un fichero con constantes para Blitz.
@endnode

@node "The Future" "The return of the future..."

  - ¡¡¡ Espero sus sugerencias !!!!!!!!
@endnode

@node "History" "The Story of TransCat"

 Version 1.01 :

  - Corregido un fallo al crear un fichero de descripción (.cd).

 Version 1.00 :

  - La primera distribución en Aminet.
@endnode

@node "Translation" "Locale translation catalogs."

 TransCat esta disponible en los siguientes idiomas :

  - En Frances : Catálogo de traducción : El autor
                 Documento traducido    : El autor

  - En Ingles  : Catálogo de traducción : Pascal Rullier
                 Documento traducido    : Millot Lionel
                 Documento traducido    : Schaaij Willem

  - En Aleman  : Catálogo de traducción : Dirk Neubauer
                 Documento traducido    : Dirk Neubauer

  - En Español : Catálogo de traducción : Fermín Venegas
                 Documento traducido    : Fermín Venegas

        
 Si desea traducir el catálogo de TransCat a su lenguaje, contacte
 conmigo para que pueda enviarle el catalogo de descripción del 
 programa (.cd).
@endnode

@node "Contact" "My address..."

  Vd. puede contactar conmigo en las siguientes direcciones:

      @{b}K L A X@{ub}
      P.O Box 14
      21601 Longvic CEDEX
      Francia

   Email  : rcilm021@dial.oleane.com
  IrcName : zIgUS ( en el canal #artbas )
@endnode

