/*
    webmail -- simple pop3/smtp web e-mail cgi
    Copyright (C) 2000-2001 Dan Cahill

    This program is free software; you can redistribute it and/or modify
    it under the terms of the GNU General Public License as published by
    the Free Software Foundation; either version 2 of the License, or
    (at your option) any later version.

    This program is distributed in the hope that it will be useful,
    but WITHOUT ANY WARRANTY; without even the implied warranty of
    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
    GNU General Public License for more details.

    You should have received a copy of the GNU General Public License
    along with this program; if not, write to the Free Software
    Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307  USA
*/
#define ERR_NOUSER	"Nome e password non possono essere nulli"
#define ERR_NOHOST	"Nomi server mancanti"
#define ERR_NOWINSOCK	"Inizializzazione Winsock DLL fallita"
#define ERR_DNS_POP3	"Non trovo il server POP3"
#define ERR_DNS_SMTP	"Non trovo il server SMTP"
#define ERR_CON_POP3	"Non riesco a connettermi al server POP3"
#define ERR_CON_SMTP	"Non riesco a connettermi al server SMTP"
#define ERR_NORECIPIENT	"No recipient specified - Message was not sent"
#define ERR_BIGPOST	"Richiesta Errata - POST too large"
#define ERR_BADURI	"Richiesta Errata - URI non corretto"
#define ERR_INVALIDURI	"Richiesta Errata - Nome specificato non valido"
#define ERR_NOMESSAGE	"Richiesta Errata - Messaggio inesistente"
#define ERR_NOBOUNDARY	"Richiesta errata - Non trovo l'inizio"
#define ERR_NOFILES	"Richiesta Errata - Non ci sono file allegati"
#define ERR_NOFILE	"Richiesta errata - Allegato non trovato"
#define ERR_NOFRAMES	"Null Webmail requires frames"
#define LOGIN_TITLE	"Null Webmail Login"
#define LOGIN_USERNAME	"Nome Login"
#define LOGIN_PASSWORD	"Password"
#define LOGIN_POP3HOST	"POP3 Server"
#define LOGIN_SMTPHOST	"SMTP Server"
#define LOGIN_MESSAGE \
"Welcome to Null Webmail."
#define LOGOUT_TITLE	"Null Webmail Logout"
#define LOGOUT_MESSAGE \
"Per aumentare la sicurezza, permettete che questa finestra sia chiusa.<BR><BR>\n"\
"Chiudendola, rimuoverai tutte le informazioni temporanee memorizzate<BR>\n"\
"dal tuo browser web (nel tuo PC), evitando accessi non autorizzati sul tuo computer.<BR>\n"
#define NWM_COPYRIGHT	"&copy; 2001 <A HREF=http://nullwebmail.sourceforge.net/ TARGET=new>Dan Cahill</A>, All Rights Reserved"
#define NWM_TOP_INBOX	"Posta in Arrivo"
#define NWM_TOP_COMPOSE	"Nuovo Messaggio"
#define NWM_TOP_LOGOUT	"Esci"
#define NWM_NOMAIL	"Non ci sono messaggi in Posta in Arrivo."
#define NWM_PREVIOUS	"Indietro"
#define NWM_NEXT	"Avanti"
#define NWM_FROM	"Da"
#define NWM_TO		"A"
#define NWM_SUBJECT	"Oggetto"
#define NWM_DATE	"Data"
#define NWM_SIZE	"Dim."
#define NWM_SELECTALL	"Seleziona tutti i messaggi"
#define NWM_DELSELECTED	"Cancella i messaggi selezionati"
#define NWM_REPLY	"Rispondi"
#define NWM_FORWARD	"Inoltra"
#define NWM_DELETE	"Cancella"
#define NWM_VIEW_SRC	"View source"
#define NWM_ATTACHMENTS	"Attachments"
#define NWM_CC		"CC"
#define NWM_BCC		"BCC"
#define NWM_FILE	"Allega"
#define NWM_REPLYLINE	"--- %s ha scritto:\n"
#define NWM_FWD_FROM	"> Da:      %s\n"
#define NWM_FWD_SUBJECT	"> Oggetto: %s\n"
#define NWM_FWD_DATE	"> Data:    %s\n"
#define NWM_SENDMAIL	"Spedici"
#define NWM_SENDINGFILE	"Sending file '%s' (%d bytes)<BR>\n"
#define NWM_DELETING	"Deleting message %d..."
#define NWM_DELETE_OK	"success."
#define NWM_DELETE_BAD	"failure."
#define NWM_MIME	"This is a multi-part message in MIME format."
