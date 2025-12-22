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

/* FUNCTION LIST
 * void send_header(int cacheable, int status, char *title, char *extra_header, char *mime_type, int length, time_t mod);
 * int  wmprintf(const char *format, ...);
 * int  wmfgets(char *buffer, int max, int fd);
 * void wmclose();
 * void wmexit();
 * void wmcookieget();
 * int  wmcookieset();
 * void wmcookiekill();
 * int  printhex(const char *format, ...);
 * int  printht(const char *format, ...);
 * void printline(char *msgtext);
 * int  EncodeBase64(char *src, int srclen);
 * int  DecodeBase64(char *src);
 * int  DecodeQP(char *src);
 * int  Decode7bit(char *src);
 * int  Decode8bit(char *src);
 * int  webmailconnect();
 * wmheader *webmailheader();
 * void webmaillist();
 * int  retardedOEmime(int reply, char *ctype);
 * void webmailread();
 * void webmailwrite();
 * void webmailfiledl();
 * char *webmailfileul(char *xfilename, char *xfilesize);
 * void webmailsend();
 * void webmaildelete();
 */
#include "main.h"

#define RFC1123FMT "%a, %d %b %Y %H:%M:%S GMT"

static struct sockaddr_in server;
static struct hostent *hp;
static int wmsocket;
static int connected=0;
#ifdef WIN32
static WSADATA wsaData;
#endif

typedef struct {
	char From[128];
	char Replyto[128];
	char To[128];
	char Date[128];
	char Subject[128];
	char CC[1024];
	char contenttype[128];
	char boundary[128];
	char encoding[128];
} wmheader;

void send_header(int cacheable, int status, char *title, char *extra_header, char *mime_type, int length, time_t mod)
{
	char timebuf[100];
	time_t t;

	t=time((time_t*)0);
	strftime(timebuf, sizeof(timebuf), RFC1123FMT, gmtime(&t));
	if (length>=0) {
		printf("Content-Length: %d\r\n", length);
	}
	if (mod!=(time_t)-1) {
		strftime(timebuf, sizeof(timebuf), RFC1123FMT, gmtime(&mod));
		printf("Last-Modified: %s\r\n", timebuf);
	}
	if (!cacheable) {
		printf("Expires: %s\r\n", timebuf);
		printf("Cache-Control: no-store\r\n");
		printf("Pragma: no-cache\r\n");
	}
	printf("Date: %s\r\n", timebuf);
	printf("Connection: close\r\n");
	if (extra_header!=(char*)0) {
		printf("Content-Type: %s\r\n", mime_type);
	} else {
		printf("Content-Type: text/html\r\n");
	}
	printf("\r\n");
}

int wmprintf(const char *format, ...)
{
	char buffer[1024];
	va_list ap;

	va_start(ap, format);
	vsnprintf(buffer, sizeof(buffer)-1, format, ap);
	send(wmsocket, buffer, strlen(buffer), 0);
	return 0;
}

int wmfgets(char *buffer, int max, int fd)
{
	char *pbuffer=buffer;
	char temp[2];
	int n=0;
	int rc=0;

	memset(temp, 0, sizeof(temp));
	while (n<max) {
		rc=recv(fd, temp, 1, 0);
		if (rc<0) {
			connected=0;
			wmexit();
		} else if (rc!=1) {
			n=-n;
			break;
		}
		n++;
		if (temp[0]==13) continue;
		*buffer=temp[0];
		buffer++;
		if (temp[0]==10) break;
	}
	*buffer=0;
	striprn(pbuffer);
	return n;
}

void wmclose()
{
	char junk[10];

#ifdef WIN32
	shutdown(wmsocket, 2);
#endif
	while (recv(wmsocket, junk, sizeof(junk), 0)>0) {
	};
#ifdef WIN32
	closesocket(wmsocket);
#else
	close(wmsocket);
#endif
	fflush(stdout);
	return;
}

void wmexit()
{
	webmaildisconnect();
	wmclose();
#ifdef WIN32
	WSACleanup();
#endif
	exit(0);
}

/* see http://www.netscape.com/newsref/std/cookie_spec.html for cookie handling stuff */
void wmcookieget()
{
	char timebuffer[100];
	char *ptemp;
	time_t t;

	memset(wmusername, 0, sizeof(wmusername));
	memset(wmpassword, 0, sizeof(wmpassword));
	memset(wmpop3server, 0, sizeof(wmpop3server));
	memset(wmsmtpserver, 0, sizeof(wmsmtpserver));
	ptemp=strcasestr(request.Cookie, "wminfo=");
	if (ptemp==NULL) return;
	ptemp+=7;
	while ((*ptemp)&&(*ptemp!=':')&&(*ptemp!=';')&&(strlen(wmusername)<sizeof(wmusername)))
		wmusername[strlen(wmusername)]=*ptemp++;
#ifdef NO_USER_HOSTS
	snprintf(wmpop3server, sizeof(wmpop3server)-1, "%s", POP3_HOST);
	snprintf(wmsmtpserver, sizeof(wmsmtpserver)-1, "%s", SMTP_HOST);
#else
	ptemp++;
	while ((*ptemp)&&(*ptemp!=':')&&(*ptemp!=';')&&(strlen(wmpop3server)<sizeof(wmpop3server)))
		wmpop3server[strlen(wmpop3server)]=*ptemp++;
	ptemp++;
	while ((*ptemp)&&(*ptemp!=':')&&(*ptemp!=';')&&(strlen(wmsmtpserver)<sizeof(wmsmtpserver)))
		wmsmtpserver[strlen(wmsmtpserver)]=*ptemp++;
#endif
	ptemp=strcasestr(request.Cookie, "wmpass=");
	if (ptemp==NULL) return;
	ptemp+=7;
	while ((*ptemp)&&(*ptemp!=':')&&(*ptemp!=';')&&(strlen(wmpassword)<sizeof(wmpassword)))
		wmpassword[strlen(wmpassword)]=*ptemp++;
	t=time((time_t*)0)+604800;
	strftime(timebuffer, sizeof(timebuffer), RFC1123FMT, gmtime(&t));
	printf("Set-Cookie: wminfo=%s:%s:%s; path=%s/; expires=%s\r\n", wmusername, wmpop3server, wmsmtpserver, request.ScriptName, timebuffer);
	printf("Set-Cookie: wmpass=%s; path=%s/\r\n", wmpassword, request.ScriptName);
}

int wmcookieset()
{
	time_t t;
	char timebuffer[100];

	if (strcasecmp(request.RequestMethod, "POST")==0) {
		if (getpostenv("WMUSERNAME")!=NULL)
			strncpy(wmusername, getpostenv("WMUSERNAME"), sizeof(wmusername)-1);
		if (getpostenv("WMPASSWORD")!=NULL)
			strncpy(wmpassword, getpostenv("WMPASSWORD"), sizeof(wmpassword)-1);
#ifdef NO_USER_HOSTS
		snprintf(wmpop3server, sizeof(wmpop3server)-1, "%s", POP3_HOST);
		snprintf(wmsmtpserver, sizeof(wmsmtpserver)-1, "%s", SMTP_HOST);
#else
		if (getpostenv("WMPOP3SERVER")!=NULL)
			strncpy(wmpop3server, getpostenv("WMPOP3SERVER"), sizeof(wmpop3server)-1);
		if (getpostenv("WMSMTPSERVER")!=NULL)
			strncpy(wmsmtpserver, getpostenv("WMSMTPSERVER"), sizeof(wmsmtpserver)-1);
#endif
	}
	if (webmailconnect()!=0) return -1;
	t=time((time_t*)0)+604800;
	strftime(timebuffer, sizeof(timebuffer), RFC1123FMT, gmtime(&t));
	printf("Set-Cookie: wminfo=%s:%s:%s; path=%s/; expires=%s\r\n", wmusername, wmpop3server, wmsmtpserver, request.ScriptName, timebuffer);
	printf("Set-Cookie: wmpass=%s; path=%s/\r\n", wmpassword, request.ScriptName);
	return 0;
}

void wmcookiekill()
{
	char timebuffer[100];
	time_t t;

	t=time((time_t*)0)+604800;
	strftime(timebuffer, sizeof(timebuffer), RFC1123FMT, gmtime(&t));
	printf("Set-Cookie: wmpass=; path=%s/\r\n", request.ScriptName);
	return;
}

int printhex(const char *format, ...)
{
	char *hex="0123456789ABCDEF";
	unsigned char buffer[1024];
	int offset=0;
	va_list ap;

	va_start(ap, format);
	vsnprintf(buffer, sizeof(buffer)-1, format, ap);
	while (buffer[offset]) {
		if ((buffer[offset]>32)&&(buffer[offset]<128)) {
			printf("%c", buffer[offset]);
		} else {
			printf("%%%c%c", hex[(unsigned int)buffer[offset]/16], hex[(unsigned int)buffer[offset]&15]);
		}
		offset++;
	}
	return 0;
}

int printht(const char *format, ...)
{
	unsigned char buffer[1024];
	int offset=0;
	va_list ap;

	va_start(ap, format);
	vsnprintf(buffer, sizeof(buffer)-1, format, ap);
	while (buffer[offset]) {
		if (buffer[offset]=='<') {
			printf("&lt;");
		} else if (buffer[offset]=='>') {
			printf("&gt;");
		} else if (buffer[offset]=='&') {
			printf("&amp;");
		} else {
			printf("%c", buffer[offset]);
		}
		offset++;
	}
	return 0;
}

void printline(char *msgtext)
{
	char *pTemp;
	char *pTemp2;
	char line[100];

	pTemp=msgtext;
	while (strlen(pTemp)>80) {
		memset(line, 0, sizeof(line));
		snprintf(line, 80, "%s", pTemp);
		if (strrchr(line, ' ')!=NULL) {
			pTemp2=strrchr(line, ' ');
			if (pTemp2!=NULL) *pTemp2='\0';
		} else {
			memset(line, 0, sizeof(line));
			snprintf(line, sizeof(line)-1, "%s", pTemp);
			pTemp2=strchr(line, ' ');
			if (pTemp2!=NULL) *pTemp2='\0';
		}
		printht("%s\r\n", line);
		pTemp+=strlen(line);
	}
	printht("%s\r\n", pTemp);
}

int EncodeBase64(char *src, int srclen)
{
	const char Base64[]="ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/";
	unsigned char a, b, c, d, *cp;
	int dst, i, enclen, remlen, linelen;

	cp=src;
	dst=0;
	linelen=0;
	enclen=srclen/3;
	remlen=srclen-3*enclen;
	for (i=0;i<enclen;i++) {
		a=(cp[0]>>2);
	        b=(cp[0]<<4)&0x30;
		b|=(cp[1]>>4);
		c=(cp[1]<<2)&0x3c;
		c|=(cp[2]>>6);
		d=cp[2]&0x3f;
		cp+=3;
		wmprintf("%c%c%c%c", Base64[a], Base64[b], Base64[c], Base64[d]);
		dst+=4;
		linelen+=4;
		if (linelen>=72) {
			wmprintf("\r\n");
			linelen=0;
		}
	}
	if (remlen==1) {
		a=(cp[0]>>2);
		b=(cp[0]<<4)&0x30;
		wmprintf("%c%c==\r\n",Base64[a],Base64[b]);
		dst+=4;
	} else if (remlen==2) {
		a=(cp[0]>>2);
		b=(cp[0]<<4)&0x30;
		b|=(cp[1]>>4);
		c=(cp[1]<<2)&0x3c;
		wmprintf("%c%c%c=\r\n",Base64[a],Base64[b],Base64[c]);
		dst+=4;
	}
	return dst;
}

int DecodeBase64(char *src)
{
	const char Base64[]="ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/";
	char dest[1024];
	int destidx, state, ch;
	int szdest;
	char *pos;

	state=0;
	destidx=0;
	szdest=sizeof(dest);
	while ((ch=*src++)!='\0') {
		if (isspace(ch)) continue;
		if (ch=='=') break;
		pos=strchr(Base64, ch);
		if (pos==0) return (-1);
		switch (state) {
			case 0:
				if (dest) {
					if (destidx>=szdest) return (-1);
					dest[destidx]=(pos-Base64)<<2;
				}
				state=1;
				break;
			case 1:
				if (dest) {
					if (destidx+1>=szdest) return (-1);
					dest[destidx]|=(pos-Base64)>>4;
					dest[destidx+1]=((pos-Base64)&0x0f)<<4;
				}
				destidx++;
				state=2;
				break;
			case 2:
				if (dest) {
					if (destidx+1>=szdest) return (-1);
					dest[destidx]|=(pos-Base64)>>2;
					dest[destidx+1]=((pos-Base64)&0x03)<<6;
				}
				destidx++;
				state=3;
				break;
			case 3:
				if (dest) {
					if (destidx>=szdest) return (-1);
					dest[destidx]|=(pos-Base64);
				}
				destidx++;
				state=0;
				break;
		}
	}
	fwrite(dest, sizeof(char), destidx, stdout);
	return (szdest);
}

int DecodeQP(char *src)
{
	char dest[1024];
	char *destidx;

	memset(dest, 0, sizeof(dest));
	destidx=dest;
	while ((*src)&&(strlen(dest)<sizeof(dest))) {
		if (*src=='=') {
			src++;
			if (isxdigit(src[0])&&isxdigit(src[1])) {
				*destidx++=(char)IntFromHex(src);
				src+=2;
			}
		} else {
			*destidx++=*src++;
		}
	}
	fwrite(dest, sizeof(char), strlen(dest), stdout);
	fwrite("\r\n", sizeof(char), 2, stdout);
	return (strlen(dest));
}

int Decode7bit(char *src)
{
	char dest[1024];
	char *destidx;

	memset(dest, 0, sizeof(dest));
	destidx=dest;
	while ((*src)&&(strlen(dest)<sizeof(dest))) {
		if (*src=='\r') {
			*destidx++=*src++;
			if (*src!='\n') *destidx++='\n';
		} else {
			*destidx++=*src++;
		}
	}
	fwrite(dest, sizeof(char), strlen(dest), stdout);
	fwrite("\r\n", sizeof(char), 2, stdout);
	return (strlen(dest));
}

int Decode8bit(char *src)
{
	return Decode7bit(src);
}

int webmailconnect()
{
	char inbuffer[1024];
	char *verbose=NULL;

	if (connected) return 0;
	if ((strlen(wmusername)==0)||(strlen(wmpassword)==0)) {
		send_header(1, 200, "OK", "1", "text/html", -1, -1);
		printf("<META HTTP-EQUIV=\"Refresh\" CONTENT=\"2; URL=%s/\">\n", request.ScriptName);
		printf("<CENTER>%s</CENTER><BR>\n", ERR_NOUSER);
		wmexit();
	}
	if ((strlen(wmpop3server)==0)||(strlen(wmsmtpserver)==0)) {
		send_header(1, 200, "OK", "1", "text/html", -1, -1);
		printf("<META HTTP-EQUIV=\"Refresh\" CONTENT=\"2; URL=%s/\">\n", request.ScriptName);
		printf("<CENTER>%s</CENTER><BR>\n", ERR_NOHOST);
		wmexit();
	}
#ifdef WIN32
	if (WSAStartup(0x101, &wsaData)) {
		send_header(1, 200, "OK", "1", "text/html", -1, -1);
		printf("<META HTTP-EQUIV=\"Refresh\" CONTENT=\"2; URL=%s/\">\n", request.ScriptName);
		printf("<CENTER>%s</CENTER><BR>\n", ERR_NOWINSOCK);
		wmexit();
	}
#endif
	if (!(hp=gethostbyname(wmpop3server))) {
		send_header(1, 200, "OK", "1", "text/html", -1, -1);
		printf("<META HTTP-EQUIV=\"Refresh\" CONTENT=\"2; URL=%s/\">\n", request.ScriptName);
		printf("<CENTER>%s '%s'</CENTER><BR>\n", ERR_DNS_POP3, wmpop3server);
		return -1;
	}
	memset((char *)&server, 0, sizeof(server));
	memmove((char *)&server.sin_addr, hp->h_addr, hp->h_length);
	server.sin_family=hp->h_addrtype;
	server.sin_port=htons(POP3_PORT);
	if ((wmsocket=socket(AF_INET, SOCK_STREAM, 0))<0) return -1;
	setsockopt(wmsocket, SOL_SOCKET, SO_KEEPALIVE, 0, 0);
	if (connect(wmsocket, (struct sockaddr *)&server, sizeof(server))<0) {
		send_header(1, 200, "OK", "1", "text/html", -1, -1);
		printf("<META HTTP-EQUIV=\"Refresh\" CONTENT=\"2; URL=%s/\">\n", request.ScriptName);
		printf("<CENTER>%s '%s'</CENTER><BR>\n", ERR_CON_POP3, wmpop3server);
		wmexit();
	}
	connected=1;
	/* Check current status */
	wmfgets(inbuffer, sizeof(inbuffer)-1, wmsocket);
	/* Send user name */
	wmprintf("USER %s\r\n", wmusername);
	wmfgets(inbuffer, sizeof(inbuffer)-1, wmsocket);
	if (strncasecmp(inbuffer, "+OK", 3)!=0) {
		verbose=strchr(inbuffer, ' ');
		send_header(1, 200, "OK", "1", "text/html", -1, -1);
		printf("<META HTTP-EQUIV=\"Refresh\" CONTENT=\"2; URL=%s/\">\n", request.ScriptName);
		if (verbose) printf("<CENTER>%s</CENTER><BR>\n", verbose);
		wmexit();
	}
	/* Send password */
	wmprintf("PASS %s\r\n", wmpassword);
	wmfgets(inbuffer, sizeof(inbuffer)-1, wmsocket);
	if (strncasecmp(inbuffer, "+OK", 3)!=0) {
		verbose=strchr(inbuffer, ' ');
		send_header(1, 200, "OK", "1", "text/html", -1, -1);
		printf("<META HTTP-EQUIV=\"Refresh\" CONTENT=\"2; URL=%s/\">\n", request.ScriptName);
		if (verbose) printf("<CENTER>%s</CENTER><BR>\n", verbose);
		wmexit();
	}
	return 0;
}

void webmaildisconnect()
{
	if (connected) {
		wmprintf("QUIT\r\n");
		wmclose();
		connected=0;
	}
	return;
}

wmheader *webmailheader()
{
	static wmheader header;
	char inbuffer[1024];
	char *pTemp;

	memset((char *)&header, 0, sizeof(header));
	if (webmailconnect()!=0) return &header;
	for (;;) {
		wmfgets(inbuffer, sizeof(inbuffer)-1, wmsocket);
		striprn(inbuffer);
		if (strcmp(inbuffer, "")==0) break;
		if (strncasecmp(inbuffer, "From:", 5)==0) {
			pTemp=inbuffer+5;
			while ((*pTemp==' ')||(*pTemp=='\t')) pTemp++;
			strncpy(header.From, pTemp, sizeof(header.From)-1);
		}
		if (strncasecmp(inbuffer, "Replyto:", 8)==0) {
			pTemp=inbuffer+8;
			while ((*pTemp==' ')||(*pTemp=='\t')) pTemp++;
			strncpy(header.Replyto, pTemp, sizeof(header.Replyto)-1);
		}
		if (strncasecmp(inbuffer, "To:", 3)==0) {
			pTemp=inbuffer+3;
			while ((*pTemp==' ')||(*pTemp=='\t')) pTemp++;
			strncpy(header.To, pTemp, sizeof(header.To)-1);
		}
		if (strncasecmp(inbuffer, "Subject:", 8)==0) {
			pTemp=inbuffer+8;
			while ((*pTemp==' ')||(*pTemp=='\t')) pTemp++;
			strncpy(header.Subject, pTemp, sizeof(header.Subject)-1);
		}
		if (strncasecmp(inbuffer, "Date:", 5)==0) {
			pTemp=inbuffer+5;
			while ((*pTemp==' ')||(*pTemp=='\t')) pTemp++;
			strncpy(header.Date, pTemp, sizeof(header.Date)-1);
		}
		if (strncasecmp(inbuffer, "Content-Type:", 13)==0) {
			pTemp=inbuffer+13;
			while ((*pTemp==' ')||(*pTemp=='\t')) pTemp++;
			strncpy(header.contenttype, pTemp, sizeof(header.contenttype)-1);
			if (strcasestr(header.contenttype, "multipart")==NULL) continue;
			if (strcasestr(header.contenttype, "boundary=")==NULL) {
				wmfgets(inbuffer, sizeof(inbuffer)-1, wmsocket);
				striprn(inbuffer);
				if (strcasestr(inbuffer, "boundary=")!=NULL) {
					strncat(header.contenttype, inbuffer, sizeof(header.contenttype)-strlen(header.contenttype)-1);
				} else {
					continue;
				}
			}
		}
		if (strncasecmp(inbuffer, "Content-Transfer-Encoding: ", 26)==0) {
			pTemp=inbuffer+26;
			while ((*pTemp==' ')||(*pTemp=='\t')) pTemp++;
			strncpy(header.encoding, pTemp, sizeof(header.encoding)-1);
		}
	}
	pTemp=strcasestr(header.contenttype, "boundary=\"");
	if (pTemp!=NULL) {
		pTemp+=10;
		while ((*pTemp)&&(*pTemp!='\"')&&(strlen(header.boundary)<sizeof(header.boundary)-1)) {
			header.boundary[strlen(header.boundary)]=*pTemp;
			pTemp++;
		}
	}
	if (strlen(header.Replyto)==0) {
		pTemp=header.From;
		while ((*pTemp)&&(*pTemp!='<')) pTemp++;
		if (*pTemp=='<') pTemp++;
		while ((*pTemp)&&(*pTemp!='>')&&(strlen(header.Replyto)<sizeof(header.Replyto))) {
			header.Replyto[strlen(header.Replyto)]=*pTemp;
			pTemp++;
		}
		if (strlen(header.Replyto)==0) {
			strncpy(header.Replyto, header.From, sizeof(header.Replyto)-1);
		}
	}
	if (strlen(header.From)==0) strcpy(header.From, "(No Sender)");
	if (strlen(header.Subject)==0) strcpy(header.Subject, "(No Subject)");
	if (strlen(header.Date)==0) strcpy(header.Date, "(No Date)");
	return &header;
}

void webmaillist()
{
	wmheader *header;
	char *pTemp;
	char inbuffer[1024];
	char status[8];
	char msgsize[100];
	signed char bgtoggle=0;
	int msize;
	int nummessages;
	int offset=0;
	int i;

	printheader();
	if (webmailconnect()!=0) return;
	wmprintf("STAT\r\n");
	wmfgets(inbuffer, sizeof(inbuffer)-1, wmsocket);
	memset(status, 0, sizeof(status));
	pTemp=inbuffer;
	while ((pTemp)&&(*pTemp!=' ')&&(strlen(status)<sizeof(status)-1)) {
		status[strlen(status)]=*pTemp;
		pTemp++;
	}
	nummessages=atoi(pTemp);
	if (nummessages<1) {
		printf("<CENTER>%s</CENTER><BR>\n", NWM_NOMAIL);
		webmaildisconnect();
		printfooter();
		return;
	}
	if (getgetenv("OFFSET")!=NULL) {
		offset=atoi(getgetenv("OFFSET"));
	}
	if (offset<0) offset=0;
	printf("<script language='JavaScript'>\n<!--\n");
	printf("function CheckAll()\n{\n");
	printf("for (var i=0;i<document.webmail.elements.length;i++) {\n");
	printf("var e = document.webmail.elements[i];\n");
	printf("if (e.name != 'allbox')\n");
	printf("e.checked = !e.checked;\n");
	printf("}\n}\n//-->\n</script>\n");
	if (nummessages>MAX_LIST_SIZE) {
		printf("<CENTER>\n");
		if (offset>0) {
			printf("[<A HREF=%s/maillist?offset=%d>%s</A>]\n", request.ScriptName, offset-MAX_LIST_SIZE, NWM_PREVIOUS);
		} else {
			printf("[%s]\n", NWM_PREVIOUS);
		}
		if (offset+MAX_LIST_SIZE<nummessages) {
			printf("[<A HREF=%s/maillist?offset=%d>%s</A>]\n", request.ScriptName, offset+MAX_LIST_SIZE, NWM_NEXT);
		} else {
			printf("[%s]\n", NWM_NEXT);
		}
		printf("</CENTER>\n");
	}
	printf("<CENTER>\n<TABLE BORDER=0 CELLPADDING=2 CELLSPACING=1 WIDTH=100%%>\n");
	printf("<FORM METHOD=POST NAME=webmail ACTION=%s/maildelete>\n", request.ScriptName);
	printf("<TR BGCOLOR=%s>\n", COLOR_TRIM);
	printf("<TD>&nbsp;</TD>");
	printf("<TD><FONT COLOR=%s><B>%s</B></FONT></TD>", COLOR_TRIMTEXT, NWM_FROM);
	printf("<TD WIDTH=100%%><FONT COLOR=%s><B>%s</B></FONT></TD>", COLOR_TRIMTEXT, NWM_SUBJECT);
	printf("<TD><FONT COLOR=%s><B>%s</B></FONT></TD>", COLOR_TRIMTEXT, NWM_DATE);
	printf("<TD><FONT COLOR=%s><B>%s</B></FONT></TD>", COLOR_TRIMTEXT, NWM_SIZE);
	printf("<TD>&nbsp;</TD>");
	printf("</TR>\n");
	for (i=nummessages-offset-1;(i>-1)&&(i>nummessages-offset-MAX_LIST_SIZE-1);i--) {
		wmprintf("LIST %d\r\n", i+1);
		wmfgets(inbuffer, sizeof(inbuffer)-1, wmsocket);
		memset(status, 0, sizeof(status));
		pTemp=inbuffer;
		while ((pTemp)&&(*pTemp!=' ')&&(strlen(status)<sizeof(status)-1)) {
			status[strlen(status)]=*pTemp;
			pTemp++;
		}
		pTemp++;
		while ((pTemp)&&(*pTemp!=' ')) {
			pTemp++;
		}
		msize=atoi(pTemp);
		if (strncasecmp(status, "+OK", 3)!=0) continue;
		if (msize>1048576) {
			snprintf(msgsize, sizeof(msgsize)-1, "%1.1f M", (float)msize/1048576.0);
		} else if (msize>1024) {
			snprintf(msgsize, sizeof(msgsize)-1, "%d K", msize/1024);
		} else {
			snprintf(msgsize, sizeof(msgsize)-1, "1 K");
		}
		wmprintf("TOP %d 0\r\n", i+1);
		wmfgets(inbuffer, sizeof(inbuffer)-1, wmsocket);
		header=webmailheader();
		for (;;) {
			wmfgets(inbuffer, sizeof(inbuffer)-1, wmsocket);
			striprn(inbuffer);
			if (strcmp(inbuffer, ".")==0) break;
		}
		if ((bgtoggle=abs(bgtoggle-1))==0) {
			printf("<TR BGCOLOR=#D0D0D0>");
		} else {
			printf("<TR BGCOLOR=#E0E0E0>");
		}
		printf("<TD NOWRAP><INPUT TYPE=checkbox NAME=%d VALUE=%d></TD>", i+1, i+1);
		printf("<TD NOWRAP>%s&nbsp;</TD>", header->From);
		printf("<TD NOWRAP><A HREF=%s/mailread?msg=%d>%s&nbsp;</A></TD>", request.ScriptName, i+1, header->Subject);
		printf("<TD NOWRAP>%s&nbsp;</TD>", header->Date);
		printf("<TD ALIGN=RIGHT NOWRAP>%s&nbsp;</TD>", msgsize);
		if (strcasestr(header->contenttype, "multipart/mixed")!=NULL) {
			printf("<TD><IMG BORDER=0 SRC=%spaperclip.gif ALT='%s'></TD>", BASE_IMAGE_URL, NWM_FILE);
		} else {
			printf("<TD>&nbsp;</TD>");
		}
		printf("</TR>\n");
	}
	printf("<TR><TD ALIGN=center COLSPAN=6>\n");
	printf("<INPUT TYPE=checkbox NAME=allbox VALUE=check_all onclick='CheckAll();'>\n");
	printf("<B>%s</B><BR>\n", NWM_SELECTALL);
	printf("<INPUT TYPE=SUBMIT VALUE='%s'>\n", NWM_DELSELECTED);
	printf("</TD></TR>\n");
	printf("</FORM>\n");
	printf("</TABLE>");
	if (nummessages>MAX_LIST_SIZE) {
		printf("<CENTER>\n");
		if (offset>0) {
			printf("[<A HREF=%s/maillist?offset=%d>%s</A>]\n", request.ScriptName, offset-MAX_LIST_SIZE, NWM_PREVIOUS);
		} else {
			printf("[%s]\n", NWM_PREVIOUS);
		}
		if (offset+MAX_LIST_SIZE<nummessages) {
			printf("[<A HREF=%s/maillist?offset=%d>%s</A>]\n", request.ScriptName, offset+MAX_LIST_SIZE, NWM_NEXT);
		} else {
			printf("[%s]\n", NWM_NEXT);
		}
		printf("</CENTER>\n");
	}
	printf("<BR>\n");
	webmaildisconnect();
	printfooter();
	return;
}

int retardedOEmime(int reply, char *ctype)
{
	char *pTemp;
	char boundary[1024];
	char inbuffer[1024];
	char msgencoding[1024];
	char msgtype[1024];
	int msgdone=0;

	memset(boundary, 0, sizeof(boundary));
	memset(msgtype, 0, sizeof(msgtype));
	memset(msgencoding, 0, sizeof(msgencoding));
	for (;;) {
		if (*ctype) {
			memcpy(inbuffer, ctype, strlen(ctype));
			*ctype='\0';
		} else {
			wmfgets(inbuffer, sizeof(inbuffer)-1, wmsocket);
			striprn(inbuffer);
		}
		if (strcmp(inbuffer, "")==0) break;
		if (strncasecmp(inbuffer, "Content-Type:", 13)==0) {
			strncpy(msgtype, (char *)&inbuffer+14, sizeof(msgtype)-1);
			if (strcasestr(msgtype, "multipart")==NULL) continue;
			if (strcasestr(msgtype, "boundary=")==NULL) {
				wmfgets(inbuffer, sizeof(inbuffer)-1, wmsocket);
				striprn(inbuffer);
				if (strcasestr(inbuffer, "boundary=")!=NULL) {
					strncat(msgtype, inbuffer, sizeof(msgtype)-strlen(msgtype)-1);
				} else {
					continue;
				}
			}
		}
	}
	pTemp=strcasestr(msgtype, "boundary=\"");
	if (pTemp!=NULL) {
		pTemp+=10;
		while ((*pTemp)&&(*pTemp!='\"')&&(strlen(boundary)<sizeof(boundary)-1)) {
			boundary[strlen(boundary)]=*pTemp;
			pTemp++;
		}
	}
	memset(msgtype, 0, sizeof(msgtype));
	memset(msgencoding, 0, sizeof(msgencoding));
	for (;;) {
		wmfgets(inbuffer, sizeof(inbuffer)-1, wmsocket);
		striprn(inbuffer);
		if (strlen(msgtype)) {
			if (strcmp(inbuffer, "")==0) break;
		}
		if (strncasecmp(inbuffer, "Content-Type:", 13)==0) {
			strncpy(msgtype, (char *)&inbuffer+14, sizeof(msgtype)-1);
			if (strcasestr(msgtype, "multipart")==NULL) continue;
		}
		if (strncasecmp(inbuffer, "Content-Transfer-Encoding:", 26)==0) {
			strncpy(msgencoding, (char *)&inbuffer+27, sizeof(msgencoding)-1);
		}
	}
	if (strncasecmp(msgtype, "text/plain", 10)==0||strncasecmp(msgtype, "text/html", 9)==0) {
		for (;;) {
			msgdone=1;
			wmfgets(inbuffer, sizeof(inbuffer)-1, wmsocket);
			if (strcasestr(inbuffer, boundary)!=NULL) return msgdone;
			if (reply) printf("> ");
			if (strncasecmp(msgencoding, "quoted-printable", 16)==0) {
				DecodeQP(inbuffer);
			} else {
				printf("%s", inbuffer);
			}
		}
	}
	return msgdone;
}

void webmailread()
{
	wmheader *header;
	char *pTemp;
	char filename[10][100];
	char inbuffer[1024];
	char ctype[100];
	char status[8];
	int file=0;
	int head=0;
	int msgdone=0;
	int numfiles=0;
	int nummessages;
	int nummessage;
	int i;

	printheader();
	if (webmailconnect()!=0) return;
	wmprintf("STAT\r\n");
	wmfgets(inbuffer, sizeof(inbuffer)-1, wmsocket);
	memset(status, 0, sizeof(status));
	pTemp=inbuffer;
	while ((pTemp)&&(*pTemp!=' ')&&(strlen(status)<sizeof(status)-1)) {
		status[strlen(status)]=*pTemp;
		pTemp++;
	}
	nummessages=atoi(pTemp);
	nummessage=atoi(getgetenv("MSG"));
	if ((nummessage>nummessages)||(nummessage<1)) {
		printf("%s<BR>", ERR_NOMESSAGE);
		webmaildisconnect();
		return;
	}
	memset(ctype, 0, sizeof(ctype));
	memset(filename, 0, sizeof(filename));
	printf("<CENTER>\n");
	if (nummessage>1) {
		printf("[<A HREF=%s/mailread?msg=%d>%s</A>]\n", request.ScriptName, nummessage-1, NWM_PREVIOUS);
	} else {
		printf("[%s]\n", NWM_PREVIOUS);
	}
	printf("[<A HREF=%s/mailwrite?replyto=%d>%s</A>]\n", request.ScriptName, nummessage, NWM_REPLY);
	printf("[<A HREF=%s/mailwrite?forward=%d>%s</A>]\n", request.ScriptName, nummessage, NWM_FORWARD);
	printf("[<A HREF=%s/maildelete?%d=%d>%s</A>]\n", request.ScriptName, nummessage, nummessage, NWM_DELETE);
	if (nummessage<nummessages) {
		printf("[<A HREF=%s/mailread?msg=%d>%s</A>]\n", request.ScriptName, nummessage+1, NWM_NEXT);
	} else {
		printf("[%s]\n", NWM_NEXT);
	}
	printf("<BR><TABLE BORDER=0 CELLPADDING=2 CELLSPACING=1 WIDTH=100%%>\n");
	wmprintf("RETR %d\r\n", nummessage);
	wmfgets(inbuffer, sizeof(inbuffer)-1, wmsocket);
	header=webmailheader();
	printf("<TR><TD BGCOLOR=%s><FONT COLOR=%s><B>%s&nbsp;&nbsp;</B></FONT></TD><TD BGCOLOR=%s WIDTH=100%%><A HREF=%s/mailwrite?msg=%d>", COLOR_TRIM, COLOR_TRIMTEXT, NWM_FROM, COLOR_FTEXT, request.ScriptName, nummessage);
	printht("%s", header->From);
	printf("</A></TD></TR>\n");
	printf("<TR><TD BGCOLOR=%s><FONT COLOR=%s><B>%s&nbsp;&nbsp;</B></FONT></TD><TD BGCOLOR=%s WIDTH=100%%>", COLOR_TRIM, COLOR_TRIMTEXT, NWM_SUBJECT, COLOR_FTEXT);
	printht("%s", header->Subject);
	printf("</TD></TR>\n");
	printf("<TR><TD BGCOLOR=%s><FONT COLOR=%s><B>%s&nbsp;&nbsp;</B></FONT></TD><TD BGCOLOR=%s WIDTH=100%%>", COLOR_TRIM, COLOR_TRIMTEXT, NWM_DATE, COLOR_FTEXT);
	printht("%s", header->Date);
	printf("</TD></TR>\n");
#ifdef RAW_MESSAGES
	printf("<TR BGCOLOR=%s><TD COLSPAN=2>[<A HREF=%s/mailraw?msg=%d>%s</A>]</TD></TR>\n", COLOR_FTEXT, request.ScriptName, nummessage, NWM_VIEW_SRC);
#endif
	printf("<TR BGCOLOR=%s><TD COLSPAN=2><PRE>\n", COLOR_FTEXT);
	if (strcasestr(header->contenttype, "multipart")==NULL) {
		for (;;) {
			wmfgets(inbuffer, sizeof(inbuffer)-1, wmsocket);
			if (strcmp(inbuffer, ".")==0) break;
			if (strncasecmp(header->encoding, "quoted-printable", 16)==0) {
				DecodeQP(inbuffer);
			} else {
				printline(inbuffer);
			}
		}
	} else {
		for (;;) {
			wmfgets(inbuffer, sizeof(inbuffer)-1, wmsocket);
			if (strcasestr(inbuffer, header->boundary)!=NULL) {
				head=1;
				break;
			}
		}
		for (;;) {
			if (strcmp(inbuffer, ".")==0) break;
			if (head) {
				memset(ctype, 0, sizeof(ctype));
				for (;;) {
					wmfgets(inbuffer, sizeof(inbuffer)-1, wmsocket);
					if (strcmp(inbuffer, ".")==0) break;
					if (strcmp(inbuffer, "")==0) {
						head=0;
						break;
					}
					if (strncasecmp(inbuffer, "Content-Type:", 13)==0) {
						pTemp=inbuffer+13;
						while ((*pTemp==' ')||(*pTemp=='\t')) pTemp++;
						strncpy(ctype, pTemp, sizeof(ctype)-1);
					}
					if (strcasestr(header->contenttype, "multipart")==NULL) continue;
					if (file) continue;
					pTemp=strcasestr(inbuffer, "name=");
					if (pTemp!=NULL) {
						pTemp+=5;
						if (*pTemp=='\"') pTemp++;
						while ((*pTemp)&&(*pTemp!='\"')&&(strlen(filename[numfiles])<sizeof(filename[numfiles])-1)) {
							filename[numfiles][strlen(filename[numfiles])]=*pTemp;
							pTemp++;
						}
						file=1;
						numfiles++;
					}
				}
			}
			if (strcmp(inbuffer, ".")==0) break;
			if (file) {
				for (;;) {
					wmfgets(inbuffer, sizeof(inbuffer)-1, wmsocket);
					if (strcmp(inbuffer, ".")==0) break;
					if (strcmp(inbuffer, "")==0) {
						file=0;
						break;
					}
					if (strcasestr(inbuffer, header->boundary)!=NULL) {
						file=0;
						head=1;
						break;
					}
				}
			}
			if (strcmp(inbuffer, ".")==0) break;
			if (head) continue;
			if (strcasestr(ctype, "multipart/alternative")!=NULL) {
				msgdone=retardedOEmime(0, inbuffer);
			} else if (strcasestr(ctype, "text/plain")!=NULL||strcasestr(ctype, "text/html")!=NULL) {
				for (;;) {
					if (strcmp(inbuffer, "")==0) break;
					wmfgets(inbuffer, sizeof(inbuffer)-1, wmsocket);
					if (strcmp(inbuffer, ".")==0) break;
				}
				for (;;) {
					wmfgets(inbuffer, sizeof(inbuffer)-1, wmsocket);
					if (strcmp(inbuffer, ".")==0) break;
					if (strcasestr(inbuffer, header->boundary)!=NULL) {
						head=1;
						break;
					}
					if (msgdone) continue;
					if (strcasestr(header->encoding, "quoted-printable")==0) {
						DecodeQP(inbuffer);
					} else {
						printline(inbuffer);
					}
				}
				msgdone=1;
			} else {
				for (;;) {
					if (strcmp(inbuffer, "")==0) break;
					wmfgets(inbuffer, sizeof(inbuffer)-1, wmsocket);
					if (strcmp(inbuffer, ".")==0) break;
				}
				if (strcmp(inbuffer, ".")==0) break;
				printf("<HR>\r\n");
				for (;;) {
					wmfgets(inbuffer, sizeof(inbuffer)-1, wmsocket);
					if (strcmp(inbuffer, ".")==0) break;
					if (strcasestr(inbuffer, header->boundary)!=NULL) {
						head=1;
						break;
					}
					if (strcasestr(header->encoding, "quoted-printable")!=NULL) {
						DecodeQP(inbuffer);
					} else {
						printline(inbuffer);
					}
				}
			}
			if (strcmp(inbuffer, ".")==0) break;
		}
	}
	printf("</PRE>\n<BR>\n");
	if (numfiles>0) {
		printf("%s<BR>\n", NWM_ATTACHMENTS);
		for (i=0;i<numfiles;i++) {
			printf("[<A HREF=%s/mailfile/%d/", request.ScriptName, nummessage);
			printhex("%s", filename[i]);
			printf(">%s</A>]<BR>\n", filename[i]);
		}
	}
	printf("</TD></TR></TABLE>\n");
	if (nummessage>1) {
		printf("[<A HREF=%s/mailread?msg=%d>%s</A>]\n", request.ScriptName, nummessage-1, NWM_PREVIOUS);
	} else {
		printf("[%s]\n", NWM_PREVIOUS);
	}
	printf("[<A HREF=%s/mailwrite?replyto=%d>%s</A>]\n", request.ScriptName, nummessage, NWM_REPLY);
	printf("[<A HREF=%s/mailwrite?forward=%d>%s</A>]\n", request.ScriptName, nummessage, NWM_FORWARD);
	printf("[<A HREF=%s/maildelete?%d=%d>%s</A>]\n", request.ScriptName, nummessage, nummessage, NWM_DELETE);
	if (nummessage<nummessages) {
		printf("[<A HREF=%s/mailread?msg=%d>%s</A>]\n", request.ScriptName, nummessage+1, NWM_NEXT);
	} else {
		printf("[%s]\n", NWM_NEXT);
	}
	printf("<BR><BR>\n");
	webmaildisconnect();
	printfooter();
	return;
}

#ifdef RAW_MESSAGES
void webmailraw()
{
	char *pTemp;
	char inbuffer[1024];
	char status[8];
	int nummessages;
	int nummessage;

	send_header(1, 200, "OK", "1", "text/plain", -1, -1);
	if (webmailconnect()!=0) return;
	wmprintf("STAT\r\n");
	wmfgets(inbuffer, sizeof(inbuffer)-1, wmsocket);
	memset(status, 0, sizeof(status));
	pTemp=inbuffer;
	while ((pTemp)&&(*pTemp!=' ')&&(strlen(status)<sizeof(status)-1)) {
		status[strlen(status)]=*pTemp;
		pTemp++;
	}
	nummessages=atoi(pTemp);
	nummessage=atoi(getgetenv("MSG"));
	if ((nummessage>nummessages)||(nummessage<1)) {
		printf("%s<BR>", ERR_NOMESSAGE);
		webmaildisconnect();
		return;
	}
	wmprintf("RETR %d\r\n", nummessage);
	wmfgets(inbuffer, sizeof(inbuffer)-1, wmsocket);
	for (;;) {
		wmfgets(inbuffer, sizeof(inbuffer)-1, wmsocket);
		if (strcmp(inbuffer, "")==0) break;
		printf("%s\r\n", inbuffer);
	}
	printf("\r\n");
	for (;;) {
		wmfgets(inbuffer, sizeof(inbuffer)-1, wmsocket);
		if (strcmp(inbuffer, ".")==0) break;
		printf("%s\r\n", inbuffer);
	}
	webmaildisconnect();
	return;
}
#endif

void webmailwrite()
{
	wmheader *header=NULL;
	char inbuffer[1024];
	char msgto[512];
	char subject[512];
	int msgdone=0;
	int replyto=0;
	int forward=0;

	printheader();
	if (webmailconnect()!=0) return;
	memset(msgto, 0, sizeof(msgto));
	memset(subject, 0, sizeof(subject));
	if (getgetenv("REPLYTO")!=NULL) {
		replyto=atoi(getgetenv("REPLYTO"));
	}
	if (getgetenv("FORWARD")!=NULL) {
		forward=atoi(getgetenv("FORWARD"));
	}
	if (getgetenv("MSGTO")!=NULL) {
		strncpy(msgto, getgetenv("MSGTO"), sizeof(msgto)-1);
	}
	if ((replyto>0)||(forward>0)) {
		if (replyto>0) {
			wmprintf("RETR %d\r\n", replyto);
		} else {
			wmprintf("RETR %d\r\n", forward);
		}
		wmfgets(inbuffer, sizeof(inbuffer)-1, wmsocket);
		header=webmailheader();
		snprintf(msgto, sizeof(msgto)-1, "%s", header->Replyto);
		if (replyto>0) {
			if (strncasecmp(header->Subject, "RE:", 3)!=0) {
				snprintf(subject, sizeof(subject)-1, "Re: %s", header->Subject);
			} else {
				snprintf(subject, sizeof(subject)-1, "%s", header->Subject);
			}
		} else if (forward>0) {
			snprintf(subject, sizeof(subject)-1, "Fwd: %s", header->Subject);
		}
	}
	printf("<CENTER>\n");
	printf("<FORM METHOD=POST ACTION=%s/mailsend NAME=wmcompose ENCTYPE=multipart/form-data>\n", request.ScriptName);
	printf("<TABLE BORDER=0 CELLPADDING=2 CELLSPACING=0>\n");
	printf("<TR BGCOLOR=%s><TD><B>%s</B></TD><TD><INPUT TYPE=TEXT NAME=msgto VALUE=\"%s\" SIZE=50></TD></TR>\n", COLOR_EDITFORM, NWM_TO, str2html(msgto));
	printf("<TR BGCOLOR=%s><TD><B>%s</B></TD><TD><INPUT TYPE=TEXT NAME=msgsubject VALUE=\"%s\" SIZE=50></TD></TR>\n", COLOR_EDITFORM, NWM_SUBJECT, str2html(subject));
	printf("<TR BGCOLOR=%s><TD><B>%s</B></TD><TD><INPUT TYPE=TEXT NAME=msgcc VALUE=\"\" SIZE=50></TD></TR>\n", COLOR_EDITFORM, NWM_CC);
	printf("<TR BGCOLOR=%s><TD><B>%s</B></TD><TD><INPUT TYPE=TEXT NAME=msgbcc VALUE=\"\" SIZE=50></TD></TR>\n", COLOR_EDITFORM, NWM_BCC);
	printf("<TR BGCOLOR=%s><TD><B>%s</B></TD><TD><INPUT TYPE=FILE NAME=fattach SIZE=50></TD></TR>\n", COLOR_EDITFORM, NWM_FILE);
	printf("<TR BGCOLOR=%s><TD COLSPAN=2><TEXTAREA NAME=msgbody COLS=70 ROWS=20 WRAP=hard>\n", COLOR_EDITFORM);
	if ((replyto>0)||(forward>0)) {
		printf(NWM_REPLYLINE, header->From);
		if (forward>0) {
			printf(NWM_FWD_FROM, header->From);
			printf(NWM_FWD_SUBJECT, header->Subject);
			printf(NWM_FWD_DATE, header->Date);
			printf(">\n");
		}
		if (strcasestr(header->contenttype, "multipart")==NULL) {
			for (;;) {
				wmfgets(inbuffer, sizeof(inbuffer)-1, wmsocket);
				if (strcmp(inbuffer, ".")==0) break;
				printf("> ");
				if (strncasecmp(header->encoding, "quoted-printable", 16)==0) {
					DecodeQP(inbuffer);
				} else {
					printf("%s\r\n", inbuffer);
				}
			}
		} else {
			for (;;) {
				wmfgets(inbuffer, sizeof(inbuffer)-1, wmsocket);
				if (strcmp(inbuffer, ".")==0) break;
				if (strcmp(inbuffer, ".\r")==0) break;
				if (msgdone) continue;
				if (strncasecmp(inbuffer, "Content-Type: multipart/alternative", 35)==0) {
					msgdone=retardedOEmime(1, inbuffer);
				} else if (strncasecmp(inbuffer, "Content-Type: text/plain", 24)==0||strncasecmp(inbuffer, "Content-Type: text/html", 23)==0) {
					for (;;) {
						wmfgets(inbuffer, sizeof(inbuffer)-1, wmsocket);
						if (strcmp(inbuffer, "")==0) break;
					}
					for (;;) {
						wmfgets(inbuffer, sizeof(inbuffer)-1, wmsocket);
						if (strcasestr(inbuffer, header->boundary)!=NULL) break;
						printf("> ");
						if (strncasecmp(header->encoding, "quoted-printable", 16)==0) {
							DecodeQP(inbuffer);
						} else {
							printf("%s\r\n", inbuffer);
						}
					}
					msgdone=1;
				} else {
					for (;;) {
						if (strcmp(inbuffer, "")==0) break;
						wmfgets(inbuffer, sizeof(inbuffer)-1, wmsocket);
					}
					for (;;) {
						wmfgets(inbuffer, sizeof(inbuffer)-1, wmsocket);
						if (strcasestr(inbuffer, header->boundary)!=NULL) break;
						if (strncasecmp(header->encoding, "quoted-printable", 16)==0) {
							DecodeQP(inbuffer);
						} else {
							printline(inbuffer);
						}
					}
				}
			}
		}
	}
	printf("</TEXTAREA></FONT></TD></TR>\n");
	printf("</TABLE>\n");
	printf("<INPUT TYPE=SUBMIT VALUE='%s'>\n", NWM_SENDMAIL);
	printf("</FORM>\n</CENTER>\n");
	printf("<SCRIPT LANGUAGE=JavaScript>\n<!--\ndocument.wmcompose.msgto.focus();\n// -->\n</SCRIPT>\n");
	webmaildisconnect();
	printfooter();
	return;
}

void webmailfiledl()
{
	char *pQueryString;
	char *pTemp;
	char boundary[1024];
	char contenttype[1024];
	char contentencoding[1024];
	char contentfilename[1024];
	char filename[1024];
	char inbuffer[1024];
	char msgtype[100];
	char status[8];
	int nummessages;
	int nummessage=0;

	memset(filename, 0, sizeof(filename));
	pQueryString=strcasestr(request.RequestURI, "/mailfile/");
	if (pQueryString==NULL) {
		send_header(1, 200, "OK", "1", "text/html", -1, -1);
		printf("<META HTTP-EQUIV=\"Refresh\" CONTENT=\"2; URL=%s/mailread?msg=%d\">\n", request.ScriptName, nummessage);
		printf("%s", ERR_BADURI);
		wmexit();
	}
	pQueryString+=10;
	nummessage=atoi(pQueryString);
	while ((isdigit(*pQueryString)!=0)&&(*pQueryString!=0)) pQueryString++;
	while (*pQueryString=='/') pQueryString++;
	strncpy(filename, pQueryString, sizeof(filename)-1);
	pTemp=filename;
	URLDecode(pTemp);
	if ((nummessage<1)||(strlen(filename)<1)) {
		send_header(1, 200, "OK", "1", "text/html", -1, -1);
		printf("<META HTTP-EQUIV=\"Refresh\" CONTENT=\"2; URL=%s/mailread?msg=%d\">\n", request.ScriptName, nummessage);
		printf("<CENTER>%s</CENTER><BR>\n", ERR_INVALIDURI);
		wmexit();
	}
	if (webmailconnect()!=0) return;
	wmprintf("STAT\r\n");
	wmfgets(inbuffer, sizeof(inbuffer)-1, wmsocket);
	memset(status, 0, sizeof(status));
	pTemp=inbuffer;
	while ((pTemp)&&(*pTemp!=' ')&&(strlen(status)<sizeof(status)-1)) {
		status[strlen(status)]=*pTemp;
		pTemp++;
	}
	nummessages=atoi(pTemp);
	if (nummessages<nummessage) {
		send_header(1, 200, "OK", "1", "text/html", -1, -1);
		printf("<META HTTP-EQUIV=\"Refresh\" CONTENT=\"2; URL=%s/mailread?msg=%d\">\n", request.ScriptName, nummessage);
		printf("<CENTER>%s</CENTER><BR>\n", ERR_NOMESSAGE);
		goto quit;
	}
	memset(msgtype, 0, sizeof(msgtype));
	wmprintf("RETR %d\r\n", nummessage);
	for (;;) {
		wmfgets(inbuffer, sizeof(inbuffer)-1, wmsocket);
		if (strcmp(inbuffer, "")==0) break;
		if (strncasecmp(inbuffer, "Content-Type:", 13)==0) {
			strncpy(msgtype, (char *)&inbuffer+14, sizeof(msgtype)-1);
			striprn(msgtype);
			if (strcasestr(msgtype, "boundary=")==NULL) {
				wmfgets(inbuffer, sizeof(inbuffer)-1, wmsocket);
				if (strcasestr(inbuffer, "boundary=")==NULL) {
					for (;;) {
						wmfgets(inbuffer, sizeof(inbuffer)-1, wmsocket);
						if (strcmp(inbuffer, ".")==0) break;
					}
					send_header(1, 200, "OK", "1", "text/html", -1, -1);
					printf("<META HTTP-EQUIV=\"Refresh\" CONTENT=\"2; URL=%s/mailread?msg=%d\">\n", request.ScriptName, nummessage);
					printf("<CENTER>%s</CENTER><BR>\n", ERR_NOBOUNDARY);
					goto quit;
				} else {
					strncat(msgtype, inbuffer, sizeof(msgtype)-strlen(msgtype)-1);
				}
			}
			striprn(msgtype);
			pTemp=msgtype;
			while (*pTemp) {
				if (*pTemp=='\t') *pTemp=' ';
				pTemp++;
			}
		}
	}
	if ((strcasestr(msgtype, "multipart/mixed")==NULL)&&(strcasestr(msgtype, "multipart/report")==NULL)) {
		for (;;) {
			wmfgets(inbuffer, sizeof(inbuffer)-1, wmsocket);
			if (strcmp(inbuffer, ".")==0) break;
		}
		send_header(1, 200, "OK", "1", "text/html", -1, -1);
		printf("<META HTTP-EQUIV=\"Refresh\" CONTENT=\"2; URL=%s/mailread?msg=%d\">\n", request.ScriptName, nummessage);
		printf("<CENTER>%s</CENTER><BR>\n", ERR_NOFILES);
		goto quit;
	}
	memset(boundary, 0, sizeof(boundary));
	pTemp=strcasestr(msgtype, "boundary=\"");
	if (pTemp!=NULL) {
		pTemp+=10;
		while ((*pTemp)&&(*pTemp!='\"')&&(strlen(boundary)<sizeof(boundary)-1)) {
			boundary[strlen(boundary)]=*pTemp;
			pTemp++;
		}
	}
	for (;;) {
		wmfgets(inbuffer, sizeof(inbuffer)-1, wmsocket);
		if (strcmp(inbuffer, ".")==0) break;
		if (strcmp(inbuffer, ".\r")==0) break;
		if (strcasestr(inbuffer, boundary)!=NULL) {
			memset(contenttype, 0, sizeof(contenttype));
			memset(contentencoding, 0, sizeof(contentencoding));
			memset(contentfilename, 0, sizeof(contentfilename));
		}
		if (strncasecmp(inbuffer, "Content-Type:", 13)==0) {
			strncpy(contenttype, (char *)&inbuffer+14, sizeof(contenttype)-1);
			striprn(contenttype);
			if (strcasestr(contenttype, "name=")==NULL) {
				wmfgets(inbuffer, sizeof(inbuffer)-1, wmsocket);
				if (strcasestr(inbuffer, "name=")==NULL) continue;
				strncat(contenttype, inbuffer, sizeof(contenttype)-strlen(contenttype)-1);
			}
			pTemp=strcasestr(contenttype, "name=");
			if (pTemp!=NULL) {
				pTemp+=5;
				if (*pTemp=='\"') pTemp++;
				while ((*pTemp)&&(*pTemp!='\"')&&(strlen(contentfilename)<sizeof(contentfilename)-1)) {
					contentfilename[strlen(contentfilename)]=*pTemp;
					pTemp++;
				}
			}
			striprn(contenttype);
			pTemp=contenttype;
			while (*pTemp) {
				if (*pTemp=='\t') *pTemp=' ';
				pTemp++;
			}
		}
		if (strncasecmp(inbuffer, "Content-Transfer-Encoding:", 26)==0) {
			strncpy(contentencoding, (char *)&inbuffer+27, sizeof(contentencoding)-1);
			if ((strncasecmp(contentencoding, "base64", 6)!=0)&&(strncasecmp(contentencoding, "quoted-printable", 16)!=0)&&
			    (strncasecmp(contentencoding, "7bit", 4)!=0)&&(strncasecmp(contentencoding, "8bit", 4)!=0)) {
				memset(contenttype, 0, sizeof(contenttype));
				memset(contentencoding, 0, sizeof(contentencoding));
				memset(contentfilename, 0, sizeof(contentfilename));
				continue;
			}
		}
		if ((strlen(contenttype))&&(strlen(contentencoding))&&(strlen(contentfilename))) {
			if (strcmp(contentfilename, filename)!=0) {
				memset(contenttype, 0, sizeof(contenttype));
				memset(contentencoding, 0, sizeof(contentencoding));
				memset(contentfilename, 0, sizeof(contentfilename));
				continue;
			}
			for (;;) {
				wmfgets(inbuffer, sizeof(inbuffer)-1, wmsocket);
				if (strcmp(inbuffer, ".")==0) goto quit;
				if (strcmp(inbuffer, "")==0) break;
			}
			if (strcmp(inbuffer, "")==0) break;
		}
	}
	if ((strlen(contenttype))&&(strlen(contentencoding))&&(strlen(contentfilename))) {
		send_header(1, 200, "OK", "1", get_mime_type(contentfilename), -1, -1);
		for (;;) {
			wmfgets(inbuffer, sizeof(inbuffer)-1, wmsocket);
			if (strcmp(inbuffer, ".")==0) goto quit;
			if (strcasestr(inbuffer, boundary)!=NULL) break;
			if (strncasecmp(contentencoding, "7bit", 4)==0) {
				Decode7bit(inbuffer);
			} else if (strncasecmp(contentencoding, "8bit", 4)==0) {
				Decode8bit(inbuffer);
			} else if (strncasecmp(contentencoding, "base64", 6)==0) {
				DecodeBase64(inbuffer);
			} else if (strncasecmp(contentencoding, "quoted-printable", 16)==0) {
				DecodeQP(inbuffer);
			}
		}
		for (;;) {
			wmfgets(inbuffer, sizeof(inbuffer)-1, wmsocket);
			if (strcmp(inbuffer, ".")==0) goto quit;
		}
	} else {
		send_header(1, 200, "OK", "1", "text/html", -1, -1);
		printf("<META HTTP-EQUIV=\"Refresh\" CONTENT=\"2; URL=%s/mailread?msg=%d\">\n", request.ScriptName, nummessage);
		printf("<CENTER>%s</CENTER><BR>\n", ERR_NOFILE);
		goto quit;
	}
quit:
	webmaildisconnect();
	return;
}

char *webmailfileul(char *xfilename, char *xfilesize)
{
	char *filebody=NULL;
	char lfilename[1024];
	int filesize=0;
	char line[1024];
	char location[1024];
	char boundary[1024];
	char boundary2[1024];
	char boundary3[1024];
	char *pPostData;
	char *pTemp;
	int i;
	unsigned int j;

	pPostData=request.PostData;
	memset(boundary, 0, sizeof(boundary));
	memset(location, 0, sizeof(location));
	i=0;
	j=0;
	/* duhh..  this should just retrieve the boundary from request.ContentType,
	 * and maybe check same to make sure this really is MIME, while it's at it.
	 */
	/* get the mime boundary */
	while ((*pPostData!='\r')&&(*pPostData!='\n')&&(i<request.ContentLength)&&(strlen(boundary)<sizeof(boundary)-1)) {
		boundary[j]=*pPostData;
		pPostData++;
		i++;
		j++;
	}
	/* eat newline garbage */
	while ((*pPostData=='\n')||(*pPostData=='\r')) {
		pPostData++;
		i++;
	}
	snprintf(boundary2, sizeof(boundary2)-1, "%s--", boundary);
	snprintf(boundary3, sizeof(boundary3)-1, "\r\n%s", boundary);
	pPostData=request.PostData;
	while ((strcmp(line, boundary2)!=0)&&(i<request.ContentLength)) {
		memset(line, 0, sizeof(line));
		j=0;
		while ((*pPostData!='\r')&&(*pPostData!='\n')&&(i<request.ContentLength)&&(strlen(line)<sizeof(line)-1)) {
			line[j]=*pPostData;
			pPostData++;
			i++;
			j++;
		}
		/* eat newline garbage */
		while ((*pPostData=='\n')||(*pPostData=='\r')) {
			pPostData++;
			i++;
		}
		pTemp=line;
		if (strncasecmp(line, "Content-Disposition: form-data; ", 32)!=0) continue;
		pTemp+=32;
		if (strncasecmp(pTemp, "name=\"fattach\"; ", 16)!=0) continue;
		pTemp+=16;
		if (strncasecmp(pTemp, "filename=\"", 10)!=0) continue;
		pTemp+=10;
		if (strrchr(pTemp, '\\')!=NULL) {
			pTemp=strrchr(pTemp, '\\')+1;
		}
		snprintf(lfilename, sizeof(lfilename)-1, "%s", pTemp);
		while (lfilename[strlen(lfilename)-1]=='\"') lfilename[strlen(lfilename)-1]='\0';
		while ((strncmp(pPostData, "\r\n\r\n", 4)!=0)&&(strncmp(pPostData, "\n\n", 2)!=0)&&(i<request.ContentLength)) {
			pPostData++;
			i++;
		}
		if (strncmp(pPostData, "\r\n\r\n", 4)==0) {
			pPostData+=4;
			i+=4;
		} else if (strncmp(pPostData, "\n\n", 2)==0) {
			pPostData+=2;
			i+=2;
		} else {
			continue;
		}
		snprintf(xfilename, 1024, "%s", lfilename);
		filebody=pPostData;
		filesize=0;
		while ((strncmp(pPostData, boundary3, strlen(boundary3))!=0)&&(i<request.ContentLength)) {
			pPostData++;
			filesize++;
		}
	}
	snprintf(xfilesize, 9, "%d", filesize);
	return filebody;
}

void webmailsend()
{
	char *filebody=NULL;
	char *msgbody=NULL;
	char *pmsgbody;
	char *pmsgcc;
	char boundary[100];
	char inbuffer[1024];
	char filename[1024];
	char cfilesize[10];
	char msgto[64];
	char msgcc[1024];
	char msgbcc[1024];
	char msgtocc[64];
	char msgsubject[64];
	char msgdate[100];
	char msgdatetz[100];
	char line[1024];
	char wmaddress[1024];
	int filesize=0;
#ifdef WIN32
	struct timeb tstruct;
#else
	struct timeval ttime;
	struct timezone tzone;
#endif
	time_t t;

	t=time((time_t*)0);
	memset(boundary, 0, sizeof(boundary));
	snprintf(boundary, sizeof(boundary)-1, "------------NWM%d", (int)t);
	printheader();
#ifdef APPEND_ADDRESS
	snprintf(wmaddress, sizeof(wmaddress)-1, "%s%s", wmusername, APPEND_ADDRESS);
#else
	strncpy(wmaddress, wmusername, sizeof(wmaddress)-1);
	if (strchr(wmusername, '@')==NULL) {
		char *ptemp;
		unsigned int i, count;

		strncat(wmaddress, "@", sizeof(wmaddress)-strlen(wmaddress)-1);
		ptemp=wmpop3server;
		do {
			for (i=0, count=0;i<strlen(ptemp);i++) if (ptemp[i]=='.') count++;
			if (count>1) ptemp=strchr(ptemp, '.')+1;
		} while (count>1);
		strncat(wmaddress, ptemp, sizeof(wmaddress)-strlen(wmaddress)-1);
	}
#endif
	while ((wmaddress[strlen(wmaddress)-1]=='\r')||(wmaddress[strlen(wmaddress)-1]=='\n')) {
		wmaddress[strlen(wmaddress)-1]='\0';
	}
	if (strcasecmp(request.RequestMethod, "POST")!=0) return;
	if (getmimeenv("MSGTO")==NULL) {
		printf("<CENTER>%s</CENTER>\n", ERR_NORECIPIENT);
		return;
	}
	memset(msgto, 0, sizeof(msgto));
	memset(msgcc, 0, sizeof(msgcc));
	memset(msgbcc, 0, sizeof(msgbcc));
	memset(msgsubject, 0, sizeof(msgsubject));
	if (msgbody!=NULL) {
		free(msgbody);
		msgbody=NULL;
	}
	msgbody=calloc(request.ContentLength+1024, sizeof(char));
	if (getmimeenv("MSGTO")!=NULL)
		strncpy(msgto, getmimeenv("MSGTO"), sizeof(msgto)-1);
	if (getmimeenv("MSGCC")!=NULL)
		strncpy(msgcc, getmimeenv("MSGCC"), sizeof(msgcc)-1);
	if (getmimeenv("MSGBCC")!=NULL)
		strncpy(msgbcc, getmimeenv("MSGBCC"), sizeof(msgbcc)-1);
	if (getmimeenv("MSGSUBJECT")!=NULL)
		strncpy(msgsubject, getmimeenv("MSGSUBJECT"), sizeof(msgsubject)-1);
	if (getmimeenv("MSGBODY")!=NULL)
		strncpy(msgbody, getmimeenv("MSGBODY"), request.ContentLength+1023);
	memset(filename, 0, sizeof(filename));
	memset(cfilesize, 0, sizeof(cfilesize));
	if (getmimeenv("FATTACH")!=NULL) {
		filebody=webmailfileul(filename, cfilesize);
		filesize=atoi(cfilesize);
		if (strlen(filename)==0) filesize=0;
	}
#ifdef WIN32
	ftime(&tstruct);
	strftime(msgdate, sizeof(msgdate), "%a, %d %b %Y %H:%M:%S", localtime(&tstruct.time));
	snprintf(msgdatetz, sizeof(msgdatetz)-1, " %+.4d", -tstruct.timezone/60*100);
	strncat(msgdate, msgdatetz, sizeof(msgdate)-strlen(msgdate)-1);
#else
	gettimeofday(&ttime, &tzone);
	strftime(msgdate, sizeof(msgdate), "%a, %d %b %Y %H:%M:%S", localtime(&ttime.tv_sec));
	snprintf(msgdatetz, sizeof(msgdatetz)-1, " %+.4d", -tzone.tz_minuteswest/60*100);
	strncat(msgdate, msgdatetz, sizeof(msgdate)-strlen(msgdate)-1);
#endif
	if ((strlen(wmusername)==0)||(strlen(wmpassword)==0)||(strlen(wmpop3server)==0)||(strlen(wmsmtpserver)==0)) {
		return;
	}
	/* some smtp servers like pop auth before smtp */
	if (webmailconnect()!=0) return;
	webmaildisconnect();
	if (!(hp=gethostbyname(wmsmtpserver))) {
		printf("<CENTER>%s '%s'</CENTER>\n", ERR_DNS_SMTP, wmsmtpserver);
		return;
	}
	memset((char *)&server, 0, sizeof(server));
	memmove((char *)&server.sin_addr, hp->h_addr, hp->h_length);
	server.sin_family=hp->h_addrtype;
	server.sin_port=(unsigned short)htons(SMTP_PORT);
	if ((wmsocket=socket(AF_INET, SOCK_STREAM, 0))<0) return;
	setsockopt(wmsocket, SOL_SOCKET, SO_KEEPALIVE, 0, 0);
	if (connect(wmsocket, (struct sockaddr *)&server, sizeof(server))<0) {
		printf("<CENTER>%s '%s'</CENTER>\n", ERR_CON_SMTP, wmsmtpserver);
		return;
	}
	wmfgets(inbuffer, sizeof(inbuffer)-1, wmsocket);
	wmprintf("HELO %s\r\n", wmsmtpserver);
	wmfgets(inbuffer, sizeof(inbuffer)-1, wmsocket);
	wmprintf("MAIL From: <%s>\r\n", wmaddress);
	wmfgets(inbuffer, sizeof(inbuffer)-1, wmsocket);
	printf("%s<BR>\n", inbuffer);
	wmprintf("RCPT To: <%s>\r\n", msgto);
	wmfgets(inbuffer, sizeof(inbuffer)-1, wmsocket);
	printf("%s<BR>\n", inbuffer);
	if (strlen(msgcc)) {
		pmsgcc=msgcc;
		while (*pmsgcc) {
			if (strcasestr(pmsgcc, "@")==NULL) break;
			memset(msgtocc, 0, sizeof(msgtocc));
			while ((*pmsgcc)&&(*pmsgcc!=',')&&(*pmsgcc!=' ')&&(strlen(pmsgcc)<sizeof(msgtocc))) {
				msgtocc[strlen(msgtocc)]=*pmsgcc;
				pmsgcc++;
			}
			while ((*pmsgcc==',')||(*pmsgcc==' ')) {
				pmsgcc++;
			}
			while (!isalpha(msgtocc[strlen(msgtocc)-1])) {
				msgtocc[strlen(msgtocc)-1]='\0';
			}
			wmprintf("RCPT To: <%s>\r\n", msgtocc);
			wmfgets(inbuffer, sizeof(inbuffer)-1, wmsocket);
		}
	}
	if (strlen(msgbcc)) {
		pmsgcc=msgbcc;
		while (*pmsgcc) {
			if (strcasestr(pmsgcc, "@")==NULL) break;
			memset(msgtocc, 0, sizeof(msgtocc));
			while ((*pmsgcc)&&(*pmsgcc!=',')&&(*pmsgcc!=' ')&&(strlen(pmsgcc)<sizeof(msgtocc))) {
				msgtocc[strlen(msgtocc)]=*pmsgcc;
				pmsgcc++;
			}
			while ((*pmsgcc==',')||(*pmsgcc==' ')) {
				pmsgcc++;
			}
			while (!isalpha(msgtocc[strlen(msgtocc)-1])) {
				msgtocc[strlen(msgtocc)-1]='\0';
			}
			wmprintf("RCPT To: <%s>\r\n", msgtocc);
			wmfgets(inbuffer, sizeof(inbuffer)-1, wmsocket);
		}
	}
	wmprintf("DATA\r\n");
	wmfgets(inbuffer, sizeof(inbuffer)-1, wmsocket);
	wmprintf("From: %s <%s>\r\n", wmusername, wmaddress);
	wmprintf("To: <%s>\r\n", msgto);
	if (strlen(msgcc)) {
		wmprintf("Cc: %s\r\n", msgcc);
	}
	wmprintf("Subject: %s\r\n", msgsubject);
	wmprintf("Date: %s\r\n", msgdate);
	if (filesize>0) {
		wmprintf("MIME-Version: 1.0\r\n");
		wmprintf("Content-Type: multipart/mixed; boundary=\"%s\"\r\n", boundary);
	}
	wmprintf("X-Mailer: %s\r\n", NWM_SERVERNAME);
	wmprintf("\r\n");
	pmsgbody=msgbody;
	if (filesize>0) {
		wmprintf("%s\r\n", NWM_MIME);
		wmprintf("--%s\r\n", boundary);
		wmprintf("Content-Type: text/plain; charset=us-ascii\r\n");
		wmprintf("Content-Transfer-Encoding: 8bit\r\n\r\n");
	}
	while (strlen(pmsgbody)>80) {
		memset(line, 0, sizeof(line));
		snprintf(line, 80, "%s", pmsgbody);
		if (strcasestr(line, "\r\n")) {
			while (line[strlen(line)-1]!='\r') {
				line[strlen(line)-1]='\0';
			}
			wmprintf("%s\r\n", line);
			pmsgbody+=strlen(line)+1;
		} else if (strchr(line, ' ')!=NULL) {
			while ((line[strlen(line)-1]!=' ')&&(strlen(line)>0)) {
				line[strlen(line)-1]='\0';
			}
			wmprintf("%s\r\n", line);
			pmsgbody+=strlen(line);
		} else {
			memset(line, 0, sizeof(line));
			while (strlen(line)<sizeof(line)-1) {
				if (line[strlen(line)-1]==' ') {
					line[strlen(line)-1]='\0';
					break;
				}
				if (line[strlen(line)-1]=='\r') {
					line[strlen(line)-1]='\0';
					break;
				}
				line[strlen(line)]=pmsgbody[strlen(line)];
			}
			wmprintf("%s\r\n", line);
			pmsgbody+=strlen(line);
		}
	}
	memset(line, 0, sizeof(line));
	snprintf(line, 80, "%s", pmsgbody);
	wmprintf("%s\r\n", line);
	pmsgbody+=strlen(line);
	free(msgbody);
	msgbody=NULL;
	if (filesize>0) {
		printf(NWM_SENDINGFILE, filename, filesize);
		fflush(stdout);
		wmprintf("\r\n--%s\r\n", boundary);
		wmprintf("Content-Type: application/octet-stream; name=\"%s\"\r\n", filename);
		wmprintf("Content-Transfer-Encoding: base64\r\n");
		wmprintf("Content-Disposition: attachment; filename=\"%s\"\r\n\r\n", filename);
		EncodeBase64(filebody, filesize);
		wmprintf("\r\n--%s--\r\n", boundary);
	}
	wmprintf("\r\n.\r\n");
	wmfgets(inbuffer, sizeof(inbuffer)-1, wmsocket);
	wmprintf("QUIT\r\n");
	wmfgets(inbuffer, sizeof(inbuffer)-1, wmsocket);
	printf("%s<BR>\n", inbuffer);
	wmfgets(inbuffer, sizeof(inbuffer)-1, wmsocket);
	wmclose();
	printf("<META HTTP-EQUIV=\"Refresh\" CONTENT=\"2; URL=%s/maillist\">\n", request.ScriptName);
	printfooter();
	return;
}

void webmaildelete()
{
	char *pTemp;
	char inbuffer[1024];
	char status[8];
	char msgnum[8];
	int nummessages;
	int deleted=0;
	int i;

	printheader();
	if (webmailconnect()!=0) return;
	wmprintf("STAT\r\n");
	wmfgets(inbuffer, sizeof(inbuffer)-1, wmsocket);
	memset(status, 0, sizeof(status));
	pTemp=inbuffer;
	while ((pTemp)&&(*pTemp!=' ')&&(strlen(status)<sizeof(status)-1)) {
		status[strlen(status)]=*pTemp;
		pTemp++;
	}
	nummessages=atoi(pTemp);
	if (nummessages>0) {
		for (i=nummessages;i>0;i--) {
			snprintf(msgnum, sizeof(msgnum)-1, "%d", i);
			if ((getpostenv(msgnum)==NULL)&&(getgetenv(msgnum)==NULL)) continue;
			deleted=i;
			printf(NWM_DELETING, i);
			wmprintf("DELE %d\r\n", i);
			wmfgets(inbuffer, sizeof(inbuffer)-1, wmsocket);
			if (strncasecmp(inbuffer, "+OK", 3)==0) {
				printf("%s<BR>\n", NWM_DELETE_OK);
			} else {
				printf("%s<BR>\n", NWM_DELETE_BAD);
			}
			fflush(stdout);
		}
	} else {
		printf("<CENTER>%s</CENTER><BR>\n", NWM_NOMAIL);
	}
	webmaildisconnect();
	snprintf(msgnum, sizeof(msgnum)-1, "%d", deleted);
	printf("<META HTTP-EQUIV=\"Refresh\" CONTENT=\"2; ");
	if ((getgetenv(msgnum)==NULL)||(nummessages<2)) {
		printf("URL=%s/maillist\">\n", request.ScriptName);
	} else {
		if (deleted<nummessages) {
			printf("URL=%s/mailread?msg=%d\">\n", request.ScriptName, deleted);
		} else {
			printf("URL=%s/mailread?msg=%d\">\n", request.ScriptName, deleted-1);
		}
	}
	printfooter();
	return;
}
