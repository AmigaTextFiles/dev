/*============================================
 $VER: IC_Jpeg4Imagine 1.0 (17.11.95) © NasGûl
 =============================================
 Ce Script converti une image Jpeg en IFF 24
 bits,puis la copie dans un dossier particulier.
 ============================================*/

Parse Arg fichier

mapdir='Work:Graphismes/3D/im30/Maps/'

Parse var fichier nom'.'ext

Address Command

'Jpegi24 'fichier mapdir''nom'.i24'




