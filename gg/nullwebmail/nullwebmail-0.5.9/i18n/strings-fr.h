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
#define ERR_NOUSER	"Le nom d'utilisateur et le mot de passe ne doivent pas &ecirc;tre vide"
#define ERR_NOHOST	"Nom du serveur manquant"
#define ERR_NOWINSOCK	"L'initialisation de la biblioth&egrave;que Winsock 2 &agrave; &eacute;chou&eacute;e"
#define ERR_DNS_POP3	"Ne peut pas trouver le serveur POP3"
#define ERR_DNS_SMTP	"Ne peut pas trouver le serveur SMTP"
#define ERR_CON_POP3	"Ne peut pas se connecter au serveur POP3"
#define ERR_CON_SMTP	"Ne peut pas se connecter au serveur SMTP"
#define ERR_NORECIPIENT	"Pas de destinataire sp&eacute;cifi&eacute; - Le message n'a pas &eacute;t&eacute; envoy&eacute;"
#define ERR_BIGPOST	"Mauvaise Requ&ecirc;te - POST trop long"
#define ERR_BADURI	"Mauvaise Requ&ecirc;te - URl mal form&eacute;e"
#define ERR_INVALIDURI	"Mauvaise Requ&ecirc;te - Sp&eacute;cification invalide"
#define ERR_NOMESSAGE	"Mauvaise Requ&ecirc;te - Pas de tel message"
#define ERR_NOBOUNDARY	"Mauvaise Requ&ecirc;te - Ne peut pas trouver de limite"
#define ERR_NOFILES	"Mauvaise Requ&ecirc;te - pas de fichiers attach&eacute;s &agrave; ce message"
#define ERR_NOFILE	"Mauvaise Requ&ecirc;te - Fichiers joints pas trouv&eacute;s"
#define ERR_NOFRAMES	"Null Webmail requires frames"
#define LOGIN_TITLE	"Null Webmail Login"
#define LOGIN_USERNAME	"Nom d'utilisateur"
#define LOGIN_PASSWORD	"Mot de passe"
#define LOGIN_POP3HOST	"Serveur POP3"
#define LOGIN_SMTPHOST	"Serveur SMTP"
#define LOGIN_MESSAGE \
"Bienvenue &agrave; Null Webmail."
#define LOGOUT_TITLE	"Null Webmail Logout"
#define LOGOUT_MESSAGE \
"Afin d'am&eacute;liorer la s&eacute;curit&eacute;, merci d'accepter la fermeture de cette fen&ecirc;tre.<BR><BR>\n"\
"En fermant cette fen&ecirc;tre, vous effacerez toutes les informations stock&eacute;es temporairement<BR>\n"\
"par votre navigateur web ce qui permet d'&eacute;viter tout acc&egrave;s frauduleux.<BR>\n"
#define NWM_COPYRIGHT	"&copy; 2001 <A HREF=http://nullwebmail.sourceforge.net/ TARGET=new>Dan Cahill</A>, Tous droits r&eacute;serv&eacute;s"
#define NWM_TOP_INBOX	"Bo&icirc;te de r&eacute;ception"
#define NWM_TOP_COMPOSE	"Composer"
#define NWM_TOP_LOGOUT	"Quitter"
#define NWM_NOMAIL	"Vous n'avez aucun message dans votre bo&icirc;te aux lettres."
#define NWM_PREVIOUS	"Pr&eacute;c&eacute;dent"
#define NWM_NEXT	"Suivant"
#define NWM_FROM	"De"
#define NWM_TO		"A"
#define NWM_SUBJECT	"Sujet"
#define NWM_DATE	"Date"
#define NWM_SIZE	"Taille"
#define NWM_SELECTALL	"S&eacute;lectionner tous les messages"
#define NWM_DELSELECTED	"Supprimer les messages s&eacute;lectionn&eacute;s"
#define NWM_REPLY	"R&eacute;pondre"
#define NWM_FORWARD	"Faire suivre"
#define NWM_DELETE	"Supprimer"
#define NWM_VIEW_SRC	"Voir Source"
#define NWM_ATTACHMENTS	"Fichiers joints"
#define NWM_CC		"CC"
#define NWM_BCC		"BCC"
#define NWM_FILE	"Fichier"
#define NWM_REPLYLINE	"--- %s a &eacute;crit:\n"
#define NWM_FWD_FROM	"> De:    %s\n"
#define NWM_FWD_SUBJECT	"> Sujet: %s\n"
#define NWM_FWD_DATE	"> Date:  %s\n"
#define NWM_SENDMAIL	"Envoyer courrier"
#define NWM_SENDINGFILE	"Envoi du fichier en cours '%s' (%d bytes)<BR>\n"
#define NWM_DELETING	"Suppression du message en cours %d..."
#define NWM_DELETE_OK	"succ&egrave;s."
#define NWM_DELETE_BAD	"&eacute;chec."
#define NWM_MIME	"This is a multi-part message in MIME format."
