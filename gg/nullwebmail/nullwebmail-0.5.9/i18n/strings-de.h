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
#define ERR_NOUSER	"Benutzername und Passwort k&ouml;nnen nicht leer sein"
#define ERR_NOHOST	"Fehlende Servernamen"
#define ERR_NOWINSOCK	"Winsock DLL Initialisierung schlug fehl"
#define ERR_DNS_POP3	"Kann POP3 Server nicht erreichen"
#define ERR_DNS_SMTP	"Kann SMTP Server nicht erreichen"
#define ERR_CON_POP3	"Kann POP3 Server nicht erreichen"
#define ERR_CON_SMTP	"Kann SMTP Server nicht erreichen"
#define ERR_NORECIPIENT	"Kein Empf&auml;nger angegeben - Nachricht NICHT abgeschickt"
#define ERR_BIGPOST	"Bad Request - POST too large"
#define ERR_BADURI	"Bad Request - Malformed URI"
#define ERR_INVALIDURI	"Bad Request - Invalid specification"
#define ERR_NOMESSAGE	"Bad Request - Es existiert keine solche Nachricht"
#define ERR_NOBOUNDARY	"Bad Request - Can't find the MIME boundary"
#define ERR_NOFILES	"Bad Request - No files are attached to this message"
#define ERR_NOFILE	"Bad Request - File not found"
#define ERR_NOFRAMES	"Null Webmail requires frames"
#define LOGIN_TITLE	"Null Webmail Login"
#define LOGIN_USERNAME	"Benutzername"
#define LOGIN_PASSWORD	"Passwort"
#define LOGIN_POP3HOST	"POP3 Server"
#define LOGIN_SMTPHOST	"SMTP Server"
#define LOGIN_MESSAGE \
"Wilkommen auf Null Webmail."
#define LOGOUT_TITLE	"Null Webmail Logout"
#define LOGOUT_MESSAGE \
"F&uuml;r verbesserte Sicherheit, bitte erlauben Sie, dieses Fenster zu schliessen.<BR><BR>\n"\
"Dadurch werden alf&auml;llige zwischengespeicherte Informationeninformation, die Ihre <BR>\n"\
"Zugangsdaten enthalten, gel&ouml;scht, und unauthorisierter Zugriff verhindert.<BR>\n"
#define NWM_COPYRIGHT	"&copy; 2001 <A HREF=http://nullwebmail.sourceforge.net/ TARGET=new>Dan Cahill</A>, All Rights Reserved"
#define NWM_TOP_INBOX	"POSTEINGANG"
#define NWM_TOP_COMPOSE	"NACHRICHT VERFASSEN"
#define NWM_TOP_LOGOUT	"E-MAILS VERLASSEN"
#define NWM_NOMAIL	"Sie haben keine Nachrichten in Ihrem Posteingang."
#define NWM_PREVIOUS	"Vorige"
#define NWM_NEXT	"N&auml;chste"
#define NWM_FROM	"Von"
#define NWM_TO		"An"
#define NWM_SUBJECT	"Thema"
#define NWM_DATE	"Datum"
#define NWM_SIZE	"Size"
#define NWM_SELECTALL	"Alle Nachrichten ausw&auml;hlen"
#define NWM_DELSELECTED	"Ausgew&auml;hlte Nachrichten l&ouml;schen"
#define NWM_REPLY	"Antworten"
#define NWM_FORWARD	"Weiterleiten"
#define NWM_DELETE	"L&ouml;schen"
#define NWM_VIEW_SRC	"Quellcode der Nachricht"
#define NWM_ATTACHMENTS	"Anhang;"
#define NWM_CC		"CC"
#define NWM_BCC		"BCC"
#define NWM_FILE	"File"
#define NWM_REPLYLINE	"--- %s wrote:\n"
#define NWM_FWD_FROM	"> Von:   %s\n"
#define NWM_FWD_SUBJECT	"> Thema: %s\n"
#define NWM_FWD_DATE	"> Datum: %s\n"
#define NWM_SENDMAIL	"Nachricht abschicken"
#define NWM_SENDINGFILE	"Sending file '%s' (%d bytes)<BR>\n"
#define NWM_DELETING	"Nachricht wird gel&ouml;scht: %d..."
#define NWM_DELETE_OK	"erledigt."
#define NWM_DELETE_BAD	"fehler."
#define NWM_MIME	"This is a multi-part message in MIME format."
