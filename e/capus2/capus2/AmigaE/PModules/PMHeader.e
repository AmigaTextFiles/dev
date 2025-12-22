/********************************************************************************
 * Fichier      : PMheader.e
 * Procédures   : - p_DoReadHeader(PTR TO header)
 * Informations : Use of MHeader.m
 *******************************************************************************/
/*********************************************************************************/
/* DEF FOR MHeader (Mheader.m must be present in your source code                */
/*********************************************************************************/
DEF title_req[80]:STRING
/*"p_DoReadHeader(my_header:PTR TO prgheader)"*/
PROC p_DoReadHeader(my_header:PTR TO prgheader) 
/********************************************************************************
 * Para         : Address of a prgheader struct (MHeader.m).
 * Return       : NONE
 * Description  : Initialise the Info Prg var.
 *******************************************************************************/
    DEF prg_version
    DEF prg_revision
    DEF prg_name[20]:STRING
    DEF prg_author[20]:STRING
    prg_version:=my_header.version
    prg_revision:=my_header.revision
    StringF(prg_name,'\s',my_header.nomprg)
    StringF(prg_author,'\s',my_header.auteur)
    StringF(title_req,'\s v\d.\d © \s',prg_name,prg_version,prg_revision,prg_author)
ENDPROC
/**/
