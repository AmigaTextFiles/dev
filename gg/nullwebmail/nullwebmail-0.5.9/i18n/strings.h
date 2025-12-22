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
#define ERR_NOUSER	"User name and password cannot be blank"
#define ERR_NOHOST	"Missing server names"
#define ERR_NOWINSOCK	"Winsock initialization failed"
#define ERR_DNS_POP3	"Could not find POP3 server"
#define ERR_DNS_SMTP	"Could not find SMTP server"
#define ERR_CON_POP3	"Could not connect to POP3 server"
#define ERR_CON_SMTP	"Could not connect to SMTP server"
#define ERR_NORECIPIENT	"No recipient specified - Message was not sent"
#define ERR_BIGPOST	"Bad Request - POST too large"
#define ERR_BADURI	"Bad Request - Malformed URI"
#define ERR_INVALIDURI	"Bad Request - Invalid specification"
#define ERR_NOMESSAGE	"Bad Request - No such message"
#define ERR_NOBOUNDARY	"Bad Request - Can't find the MIME boundary"
#define ERR_NOFILES	"Bad Request - No files are attached to this message"
#define ERR_NOFILE	"Bad Request - File not found"
#define ERR_NOFRAMES	"Null Webmail requires frames"
#define LOGIN_TITLE	"Null Webmail Login"
#define LOGIN_USERNAME	"Login Name"
#define LOGIN_PASSWORD	"Password"
#define LOGIN_POP3HOST	"POP3 Server"
#define LOGIN_SMTPHOST	"SMTP Server"
#define LOGIN_MESSAGE \
"Welcome to Null Webmail."
#define LOGOUT_TITLE	"Null Webmail Logout"
#define LOGOUT_MESSAGE \
"For increased security, please allow this window to be closed.<BR><BR>\n"\
"By closing this window, you will remove any temporary information stored<BR>\n"\
"by your web browser which could otherwise allow unauthorized access.<BR>\n"
#define NWM_COPYRIGHT	"&copy; 2001 <A HREF=http://nullwebmail.sourceforge.net/ TARGET=new>Dan Cahill</A>, All Rights Reserved"
#define NWM_TOP_INBOX	"INBOX"
#define NWM_TOP_COMPOSE	"COMPOSE"
#define NWM_TOP_LOGOUT	"LOG OUT"
#define NWM_NOMAIL	"You have no messages in your mailbox."
#define NWM_PREVIOUS	"Previous"
#define NWM_NEXT	"Next"
#define NWM_FROM	"From"
#define NWM_TO		"To"
#define NWM_SUBJECT	"Subject"
#define NWM_DATE	"Date"
#define NWM_SIZE	"Size"
#define NWM_SELECTALL	"Select all messages"
#define NWM_DELSELECTED	"Delete selected messages"
#define NWM_REPLY	"Reply"
#define NWM_FORWARD	"Forward"
#define NWM_DELETE	"Delete"
#define NWM_VIEW_SRC	"View source"
#define NWM_ATTACHMENTS	"Attachments"
#define NWM_CC		"CC"
#define NWM_BCC		"BCC"
#define NWM_FILE	"File"
#define NWM_REPLYLINE	"--- %s wrote:\n"
#define NWM_FWD_FROM	"> From:    %s\n"
#define NWM_FWD_SUBJECT	"> Subject: %s\n"
#define NWM_FWD_DATE	"> Date:    %s\n"
#define NWM_SENDMAIL	"Send Mail"
#define NWM_SENDINGFILE	"Sending file '%s' (%d bytes)<BR>\n"
#define NWM_DELETING	"Deleting message %d..."
#define NWM_DELETE_OK	"success."
#define NWM_DELETE_BAD	"failure."
#define NWM_MIME	"This is a multi-part message in MIME format."
