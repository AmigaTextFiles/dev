/*
 *  Testing the Requester-Module
 * -============================-
 * 
 */

MODULE  'req/reqtypes'          -> For the Types ASL and RT
MODULE  'req/requester'         -> The Requester-Module

PROC main()
 DEF    passwort[120]:STRING,   -> String for the first password
        oldpw[120]:STRING,      -> And one for the second password
        file,drawer            

  StrCopy(oldpw,passwortrequest('SECURITY','Bitte das Passwort eingeben:'),120)
                                -> Get the first Password...
   StrCopy(passwort,passwortrequest('SECURITY','Bitte eingabe wiederholen:'),120)
                                -> And the Second...
    IF StrCmp(oldpw,passwort,StrLen(oldpw))=FALSE
                                -> Compare both together...
     inforequest('WARNUNG!','Die Passwörter stimmen nicht überein!','Beenden!')
                                -> No, they are diffrent...
    ELSE                        -> But if they are absolutly the same (not case sensitive!)
     inforequest('Information','Die Passwörter stimmen überein!','OK!')
                                -> Message to the User...
    ENDIF
     drawer,file:=filerequest('Filerequester-Test (ASL)',TYPE_ASL,'ram:','~(#?.info)','OK','Ende')
      WriteF(' Dir : \s\n',drawer)
       WriteF(' File: \s\n',file)
        drawer,file:=filerequest('Filerequester-Test (RT)',TYPE_REQTOOLS,'ram:','~(#?.info)','OK','Ende')
         WriteF(' Dir : \s\n',drawer)
          WriteF(' File: \s\n',file)
ENDPROC                         -> Programm-End

