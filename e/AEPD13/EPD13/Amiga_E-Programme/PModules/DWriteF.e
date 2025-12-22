/********************************************************************************
 * Fichier      : DWriteF.e
 * Procédures   : dWriteF(PTR TO LONG,PTR TO LONG)
 * Informations : WriteF() if DEBUG=TRUE
 *******************************************************************************/
PROC dWriteF(format,data) /*"dWriteF(format,dat)"*/
/********************************************************************************
 * Para         : PTR TO LONG like ['\s','\d'],idem like [string,address]
 * Return       : NONE
 * Description  : WriteF() if DEBUG=TRUE.
 *******************************************************************************/
    DEF p_format[10]:LIST
    DEF p_data[10]:LIST
    DEF b
    p_format:=format
    p_data:=data
    FOR b:=0 TO ListLen(p_format)-1
        IF DEBUG=TRUE THEN WriteF(p_format[b],p_data[b])
    ENDFOR
ENDPROC

