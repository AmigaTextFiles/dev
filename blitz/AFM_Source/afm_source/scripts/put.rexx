/* Arexx Script For YAM */

options results
File="T:body.tmp"

address 'YAM' 'mailwrite'
address 'YAM' 'writeto "ftp-mail@uni-paderborn.de"'
address 'YAM' 'writesubject "FTP-Email request"'
address 'YAM' 'writeletter' File
address 'YAM' 'writequeue'

address command 'delete >NIL: ' File
exit
