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
#include "main.h"

void printheader()
{
	printf("<HTML><HEAD><TITLE>%s</TITLE>\n", NWM_SERVERNAME);
	printf("<STYLE>\n");
	printf(".JUSTIFY {text-align : justify}\n");
	printf("A {color : %s; text-decoration : none}\n", COLOR_LINKS);
#ifndef USE_FRAMES
	printf(".TBAR\n");
	printf("{\n");
	printf("	font-size: 8pt;\n");
	printf("	font-family: Geneva,Arial,Verdana,Sans-Serif;\n");
	printf("	text-decoration: none;\n");
	printf("	color: #505050;\n");
	printf("}\n");
#endif
	printf("</STYLE>\n");
	printf("</HEAD>\n");
	printf("<BODY BGCOLOR=%s COLOR=#000000 LINK=%s ALINK=%s VLINK=%s LEFTMARGIN=0 TOPMARGIN=0 MARGINHEIGHT=0 MARGINWIDTH=0>\n", COLOR_TRIMTEXT, COLOR_LINKS, COLOR_LINKS, COLOR_LINKS);
#ifndef USE_FRAMES
	printf("<CENTER>\n");
	printf("<TABLE BORDER=1 CELLPADDING=0 CELLSPACING=0 WIDTH=100%%>\n");
	printf("<TR VALIGN=middle BGCOLOR=#C0C0C0><TD ALIGN=left>&nbsp;\n");
	printf("<a class='TBAR' href=%s/maillist>%s</a>&nbsp;&middot;&nbsp;\n", request.ScriptName, NWM_TOP_INBOX);
	printf("<a class='TBAR' href=%s/mailwrite>%s</a>&nbsp;&middot;&nbsp;\n", request.ScriptName, NWM_TOP_COMPOSE);
	printf("<a class='TBAR' href=%s/mailquit TARGET=_top>%s</a>\n", request.ScriptName, NWM_TOP_LOGOUT);
	printf("</TD></TR></TABLE>\n");
	printf("</CENTER>");
#endif
	printf("<BR>\n");
	return;
}

void printfooter()
{
	printf("<CENTER>\n<EM><B><FONT SIZE=2 COLOR=#909090>");
	printf("%s", NWM_COPYRIGHT);
	printf("</FONT></B></EM>\n</CENTER>\n");
	printf("</BODY>\n</HTML>\n");
	return;
}

void printlogin()
{
	if (strlen(wmpop3server)<1) strncpy(wmpop3server, POP3_HOST, sizeof(wmpop3server)-1);
	if (strlen(wmsmtpserver)<1) strncpy(wmsmtpserver, SMTP_HOST, sizeof(wmsmtpserver)-1);
	printf("<HTML>\n<HEAD><TITLE>%s</TITLE>\n", LOGIN_TITLE);
	printf("<STYLE>\n");
	printf(".JUSTIFY {text-align : justify}\n");
	printf("A {color : %s; text-decoration : none}\n", COLOR_LINKS);
	printf("</STYLE>\n");
	printf("</HEAD>\n");
	printf("<BODY BGCOLOR=#FFFFFF>\n");
	printf("<CENTER>\n");
	printf("<TABLE WIDTH=640 CELLPADDING=5 CELLSPACING=0 BORDER=0>\n");
	printf("<TR><TD COLSPAN=2 BGCOLOR=%s><IMG SRC=%sheader.gif></TD></TR>\n", COLOR_TRIM, BASE_IMAGE_URL);
	printf("<TR VALIGN=top><TD BGCOLOR=#CCCCCC>\n");
	printf("<TABLE CELLPADDING=8><TR><TD>\n");
	printf("<FORM METHOD=POST ACTION=%s/ NAME=wmlogin>\n", request.ScriptName);
	printf("<B>%s</B><BR>\n", LOGIN_USERNAME);
	printf("<INPUT NAME=WMUSERNAME TYPE=TEXT SIZE=20 VALUE='%s'><BR>\n", wmusername);
	printf("<B>%s</B><BR>\n", LOGIN_PASSWORD);
	printf("<INPUT NAME=WMPASSWORD TYPE=PASSWORD SIZE=20><BR>\n");
#ifndef NO_USER_HOSTS
	printf("<B>%s</B><BR>\n", LOGIN_POP3HOST);
	printf("<INPUT NAME=WMPOP3SERVER TYPE=TEXT SIZE=20 VALUE=%s><BR>\n", wmpop3server);
	printf("<B>%s</B><BR>\n", LOGIN_SMTPHOST);
	printf("<INPUT NAME=WMSMTPSERVER TYPE=TEXT SIZE=20 VALUE=%s><BR>\n", wmsmtpserver);
#endif
	printf("<BR><CENTER>\n<INPUT TYPE=SUBMIT VALUE=Login>\n</CENTER>\n");
	printf("</FORM>\n");
	printf("</TD></TR></TABLE>\n");
	printf("</TD><TD WIDTH=100%%>\n");
	printf("<TABLE CELLPADDING=8><TR><TD>\n");
	printf("<P>%s</P>\n", LOGIN_MESSAGE);
	printf("</TD></TR></TABLE>\n");
	printf("</TD></TR></TABLE>\n");
	if (strlen(wmusername)<1) {
		printf("<SCRIPT LANGUAGE=JavaScript>\n<!--\ndocument.wmlogin.WMUSERNAME.focus();\n// -->\n</SCRIPT>\n");
	} else {
		printf("<SCRIPT LANGUAGE=JavaScript>\n<!--\ndocument.wmlogin.WMPASSWORD.focus();\n// -->\n</SCRIPT>\n");
	}
	printfooter();
	return;
}

void printlogout()
{
	printf("<HTML>\n<HEAD><TITLE>%s</TITLE></HEAD>\n", LOGOUT_TITLE);
	printf("<BODY BGCOLOR=#F0F0F0 COLOR=#000000 LINK=%s ALINK=%s VLINK=%s>\n", COLOR_LINKS, COLOR_LINKS, COLOR_LINKS);
	printf("<META HTTP-EQUIV=\"Refresh\" CONTENT=\"2; URL='%s/'\">\n", request.ScriptName);
	printf("<CENTER>\n<BR><BR>\n");
	printf("<TABLE BORDER=0 CELLPADDING=2 CELLSPACING=0>\n");
	printf("<TR BGCOLOR=%s><TH><FONT COLOR=%s>%s</FONT></TH></TR>\n", COLOR_TRIM, COLOR_TRIMTEXT, LOGOUT_TITLE);
	printf("<TR BGCOLOR=%s><TD>\n", COLOR_EDITFORM);
	printf("%s", LOGOUT_MESSAGE);
	printf("</TD></TR>\n");
	printf("</TABLE>\n");
	printf("<SCRIPT LANGUAGE=JavaScript>\n<!--\nwindow.close('_top');\n// -->\n</SCRIPT>\n");
	printf("</BODY>\n</HTML>\n");
}

#ifdef USE_FRAMES
void printframeset()
{
	printf("<HTML><HEAD><TITLE>%s</TITLE></HEAD>\n", SERVER_NAME);
	printf("<FRAMESET ROWS='55,*' BORDER=1 FRAMESPACING=0>\n");
	printf("<FRAME SRC=%s/topframe NAME=top SCROLLING=NO NORESIZE>\n", request.ScriptName);
	printf("<FRAMESET COLS='100,*' BORDER=1 FRAMESPACING=0>\n");
	printf("<FRAME SRC=%s/leftframe NAME=left SCROLLING=NO NORESIZE>\n", request.ScriptName);
	printf("<FRAME SRC=%s/maillist NAME=main NORESIZE>\n", request.ScriptName);
	printf("</FRAMESET>\n</FRAMESET>\n");
	printf("<NOFRAMES>\n%s\n</NOFRAMES>\n", NWM_NOFRAMES);
	printf("</HTML>\n");
}

void printtopframe()
{
	printf("<HTML><HEAD><TITLE>%s</TITLE></HEAD>\n", SERVER_NAME);
	printf("<BODY BGCOLOR=%s>\n", COLOR_TRIM);
	printf("<IMG SRC=%sheader.gif BORDER=0>", BASE_IMAGE_URL);
	printf("</BODY>\n</HTML>\n");
}

void printleftframe()
{
	printf("<HTML><HEAD><TITLE>%s</TITLE>\n", SERVER_NAME);
	printf("<SCRIPT LANGUAGE='JavaScript'>\n");
	printf("<!--\n");
	printf("if (document.images) {\n");
	printf("image1on = new Image();\n");
	printf("image1on.src = '%smenuinbox1.gif';\n", BASE_IMAGE_URL);
	printf("image2on = new Image();\n");
	printf("image2on.src = '%smenucompose1.gif';\n", BASE_IMAGE_URL);
	printf("image3on = new Image();\n");
	printf("image3on.src = '%smenulogout1.gif';\n", BASE_IMAGE_URL);
	printf("image1off = new Image();\n");
	printf("image1off.src = '%smenuinbox0.gif';\n", BASE_IMAGE_URL);
	printf("image2off = new Image();\n");
	printf("image2off.src = '%smenucompose0.gif';\n", BASE_IMAGE_URL);
	printf("image3off = new Image();\n");
	printf("image3off.src = '%smenulogout0.gif';\n", BASE_IMAGE_URL);
	printf("}\n");
	printf("function changeImages() {\n");
	printf("if (document.images) {\n");
	printf("for (var i=0; i<changeImages.arguments.length; i+=2) {\n");
	printf("document[changeImages.arguments[i]].src = eval(changeImages.arguments[i+1] + '.src');\n");
	printf("}\n}\n}\n");
	printf("// -->\n");
	printf("</SCRIPT>\n");
	printf("</HEAD>\n");
	printf("<BODY BGCOLOR=%s>\n", COLOR_TRIM);
	printf("<CENTER>\n");
	printf("<A HREF=%s/maillist TARGET=main ONMOUSEOVER=\"changeImages('image1', 'image1on')\" ONMOUSEOUT=\"changeImages('image1', 'image1off')\">\n", request.ScriptName);
	printf("<IMG NAME=image1 SRC=%smenuinbox0.gif BORDER=0></A><BR><BR>\n", BASE_IMAGE_URL);
	printf("<A HREF=%s/mailwrite TARGET=main ONMOUSEOVER=\"changeImages('image2', 'image2on')\" ONMOUSEOUT=\"changeImages('image2', 'image2off')\">\n", request.ScriptName);
	printf("<IMG NAME=image2 SRC=%smenucompose0.gif BORDER=0></A><BR><BR>\n", BASE_IMAGE_URL);
	printf("<A HREF=%s/mailquit TARGET=_top ONMOUSEOVER=\"changeImages('image3', 'image3on')\" ONMOUSEOUT=\"changeImages('image3', 'image3off')\">\n", request.ScriptName);
	printf("<IMG NAME=image3 SRC=%smenulogout0.gif BORDER=0></A><BR>\n", BASE_IMAGE_URL);
	printf("</CENTER>\n</BODY>\n</HTML>\n");
}
#endif

int main(int argc, char *argv[])
{
	if (getenv("REQUEST_METHOD")==NULL) {
		printf("This program must be run as a CGI.\n");
		exit(0);
	}
	setvbuf(stdout, NULL, _IONBF, 0);
	memset((char *)&request, 0, sizeof(request));
#ifdef WIN32
	_setmode(_fileno(stdin), _O_BINARY);
	_setmode(_fileno(stdout), _O_BINARY);
#endif
	if (getenv("CONTENT_LENGTH")!=NULL)
		request.ContentLength=atoi(getenv("CONTENT_LENGTH"));
	if (getenv("CONTENT_TYPE")!=NULL)
		strncpy(request.ContentType, getenv("CONTENT_TYPE"), sizeof(request.ContentType)-1);
	if (getenv("HTTP_COOKIE")!=NULL)
		strncpy(request.Cookie, getenv("HTTP_COOKIE"), sizeof(request.Cookie)-1);
	if (getenv("HTTP_HOST")!=NULL)
		strncpy(request.Host, getenv("HTTP_HOST"), sizeof(request.Host)-1);
	if (getenv("HTTP_USER_AGENT")!=NULL)
		strncpy(request.UserAgent, getenv("HTTP_USER_AGENT"), sizeof(request.UserAgent)-1);
	if (getenv("PATH_INFO")!=NULL)
		strncpy(request.PathInfo, getenv("PATH_INFO"), sizeof(request.PathInfo)-1);
	if (getenv("REQUEST_METHOD")!=NULL)
		strncpy(request.RequestMethod, getenv("REQUEST_METHOD"), sizeof(request.RequestMethod)-1);
	if (getenv("SCRIPT_NAME")!=NULL)
		strncat(request.ScriptName, getenv("SCRIPT_NAME"), sizeof(request.ScriptName)-1);
	if (getenv("REMOTE_ADDR")!=NULL)
		strncat(request.ClientIP, getenv("REMOTE_ADDR"), sizeof(request.ClientIP)-1);
	if (getenv("QUERY_STRING")!=NULL)
		strncat(request.QueryString, getenv("QUERY_STRING"), sizeof(request.QueryString)-1);
	strncpy(request.RequestURI, request.PathInfo, sizeof(request.RequestURI)-1);
	if (strlen(request.QueryString)>0) {
		strncat(request.RequestURI, "?", sizeof(request.RequestURI)-strlen(request.RequestURI)-1);
		strncat(request.RequestURI, request.QueryString, sizeof(request.RequestURI)-strlen(request.RequestURI)-1);
	}
	strncat(request.Host, request.ScriptName, sizeof(request.ScriptName)-strlen(request.ScriptName)-1);
	// strip trailing slashes for thttpd
	while ((request.ScriptName[strlen(request.ScriptName)-1]=='/')) {
		request.ScriptName[strlen(request.ScriptName)-1]='\0';
	}
	if (strlen(request.RequestURI)<1) strcpy(request.RequestURI, "/");
	if (strcmp(request.RequestMethod, "POST")==0) {
		if (request.ContentLength<MAX_POSTSIZE) {
			ReadPOSTData();
		} else {
			/* try to print an error : note the inbuffer is still
			 * full, so the cgi will probably just puke, and die.
			 * But at least it'll do it quickly. ;-)
			 */
			printf("Content-Type: text/html\n\n");
			printf("%s", ERR_BIGPOST);
			exit(0);
		}
	}
	printf("Expires: Sat, 1 Jan 2000 12:00:00 GMT\n");
	printf("Cache-Control: no-store\r\n");
	printf("Pragma: no-cache\r\n");
	if (strncmp(request.RequestURI, "/mailfile", 9)==0) {
		wmcookieget();
		webmailfiledl();
		fflush(stdout);
		return 0;
	}
#ifdef RAW_MESSAGES
	if (strncmp(request.RequestURI, "/mailraw", 8)==0) {
		wmcookieget();
		webmailraw();
		fflush(stdout);
		return 0;
	}
#endif
	if ((strcmp(request.RequestURI, "/")==0)&&(strcmp(request.RequestMethod, "POST")==0)) {
		if (wmcookieset()==0) {
			printf("Content-Type: text/html\n\n");
#ifdef USE_FRAMES
			printframeset();
#else
			webmaillist();
#endif
		} else {
			printf("Content-Type: text/html\n\n");
			printlogin();
		}
		fflush(stdout);
		return 0;
	}
	wmcookieget();
	if (strcmp(request.RequestURI, "/")==0) {
		printf("Content-Type: text/html\n\n");
		printlogin();
		fflush(stdout);
		return 0;
	}
	if (strncmp(request.RequestURI, "/mailquit", 9)==0) {
		wmcookiekill();
		printf("Content-Type: text/html\n\n");
		printlogout();
		fflush(stdout);
		exit(0);
	}
	printf("Content-Type: text/html\n\n");
	if (strncmp(request.RequestURI, "/maillist", 9)==0) {
		webmaillist();
	} else if (strncmp(request.RequestURI, "/mailread", 9)==0) {
		webmailread();
	} else if (strncmp(request.RequestURI, "/mailwrite", 10)==0) {
		webmailwrite();
	} else if (strncmp(request.RequestURI, "/mailsend", 9)==0) {
		webmailsend();
	} else if (strncmp(request.RequestURI, "/maildelete", 11)==0) {
		webmaildelete();
#ifdef USE_FRAMES
	} else if (strncmp(request.RequestURI, "/topframe", 9)==0) {
		printtopframe();
	} else if (strncmp(request.RequestURI, "/leftframe", 10)==0) {
		printleftframe();
#endif
	}
	fflush(stdout);
	if (request.PostData!=NULL) {
		free(request.PostData);
	}
	return 0;
}
