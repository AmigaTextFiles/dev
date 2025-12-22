' *********************************************************************
'           LibTest.c by Jaca/D-CAPS -- All Rights Reserved
'
'                 C to HBASIC conversion 1.0 (1.6.02)
'               by Dámaso D. Estévez <ast_dde@yahoo.es>
'              AmiSpaTra - http://www.arrakis.es/~amidde/

'              This example opens a ReqAttack request...
'     if the StackAttack package isn't installed in your machine,
'             this program will open an AmigaOS' request.
'
'              Este ejemplo abre una petición ReqAttack...
'            si este paquete no estuviese instalado abriría
'            simplemente una petición del sistema operativo.
' *********************************************************************


REM $include intuition.bh
REM $include reqattack.bh
REM $include exec.bh

'           Allocating struct memory (easy way, but dangerous)
' Reservando memoria para las estructuras (método fácil, pero peligroso)
' ----------------------------------------------------------------------
es$  = STRING$(EasyStruct_sizeof%,CHR$(0))
da$  = STRING$(DeveloperAttack_sizeof%,CHR$(0))

LIBRARY OPEN "reqattack.library",NULL&

PRINT "lib opened!"

'      Filling some EasyStruct struct's fields
' Rellenando algunos campos de la estructura EasyStruct
' -----------------------------------------------------
POKEL SADD(es$)+es_StructSize%, EasyStruct_sizeof%
POKEL SADD(es$)+es_Title%, _
      SADD("A silly requester"+CHR$(0))
POKEL SADD(es$)+es_TextFormat%, _
      SADD("this is just a simple test"+CHR$(10)+"of my new reqattack.library!"+CHR$(0))
POKEL SADD(es$)+es_GadgetFormat%, _
      SADD("Alright|Nope|Zure"+CHR$(0))

'       Filling some DeveloperAttack struct's fields
' Rellenado algunos campos de la estructura DeveloperAttack
' ---------------------------------------------------------
POKEL SADD(da$)+da_Logo%, SADD("Logos/ic.NoRam"+CHR$(0))
POKEW SADD(da$)+da_StartButton%, 1%

'   Showing requester
' Mostrando la petición
' ---------------------
PRINT "displaying..."

dummy& = ExtendedRequestArgs&(0,SADD(es$),0,SADD(da$),0)
PRINT "returned";dummy&

LIBRARY CLOSE "reqattack.library"

END
