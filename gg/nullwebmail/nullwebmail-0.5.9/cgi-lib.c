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

void SwapChar(char *string, char oldchar, char newchar)
{
 	while (*string) {
 		if (*string==oldchar) *string=newchar;
		string++;
	}
}

int IntFromHex(char *pChars)
{
	int Hi;
	int Lo;
	int Result;

	Hi=pChars[0];
	if ('0'<=Hi&&Hi<='9') {
		Hi-='0';
	} else if ('a'<=Hi&&Hi<='f') {
		Hi-=('a'-10);
	} else if ('A'<=Hi&&Hi<='F') {
		Hi-=('A'-10);
	}
	Lo = pChars[1];
	if ('0'<=Lo&&Lo<='9') {
		Lo-='0';
	} else if ('a'<=Lo&&Lo<='f') {
		Lo-=('a'-10);
	} else if ('A'<=Lo&&Lo<='F') {
		Lo-=('A'-10);
	}
	Result=Lo+(16*Hi);
	return (Result);
}

void URLDecode(unsigned char *pEncoded)
{
	char *pDecoded;

	pDecoded=pEncoded;
	while (*pDecoded) {
		if (*pDecoded=='+') *pDecoded=' ';
		pDecoded++;
	};
	pDecoded=pEncoded;
	while (*pEncoded) {
		if (*pEncoded=='%') {
			pEncoded++;
			if (isxdigit(pEncoded[0])&&isxdigit(pEncoded[1])) {
				*pDecoded++=(char)IntFromHex(pEncoded);
				pEncoded+=2;
			}
		} else {
			*pDecoded++=*pEncoded++;
		}
	}
	*pDecoded='\0';
}

char *str2html(char *instring)
{
	static unsigned char buffer[8192];
	unsigned char ch;
	int bufferlength=0;
	int i=0;

	memset(buffer, 0, sizeof(buffer));
	while ((instring[i])&&(i<sizeof(buffer)-1)) {
		ch=instring[i];
		if (ch==0) break;
		if ((ch<32)||(ch>255)) { i++; continue; }
		if (ch=='\"') {
			buffer[bufferlength]='&';
			buffer[bufferlength+1]='q';
			buffer[bufferlength+2]='u';
			buffer[bufferlength+3]='o';
			buffer[bufferlength+4]='t';
			buffer[bufferlength+5]=';';
			bufferlength+=6;
			i++;
			continue;
		}
		buffer[bufferlength]=ch;
		bufferlength++;
		i++;
	}
	return buffer;
}

void ReadPOSTData() {
	int i=0;
	int x=0;

	if (request.PostData!=NULL) {
		free(request.PostData);
		request.PostData=NULL;
	}
	request.PostData=calloc(request.ContentLength+1024, sizeof(char));
	if (request.PostData==NULL) {
		exit(0);
	}
	while (i<request.ContentLength) {
		x=fgetc(stdin);
		if (x==EOF) break;
		request.PostData[i++]=x;
	}
}

char *getgetenv(char *query)
{
	char *pToken;
	char *pEquals;
	char pQuery[64];
	int loop;
	char Buffer[8192];

	if (strlen(request.QueryString)==0) return NULL;
	strncpy(Buffer, request.QueryString, sizeof(Buffer)-1);
	strncpy(pQuery, query, sizeof(pQuery)-1);
	loop=0;
	while (pQuery[loop]) {
		pQuery[loop] = toupper(pQuery[loop]);
		loop++;
	}
	pToken=strtok(Buffer,"&");
	while (pToken != NULL) {
		pEquals = strchr(pToken, '=');
		if (pEquals != NULL) {
			*pEquals++ = '\0';
			URLDecode(pToken);
			loop = 0;
			while (pToken[loop]) {
				pToken[loop] = toupper(pToken[loop]);
				loop++;
			}
			URLDecode(pEquals);
			if ((strcmp(pQuery, pToken)==0))
				return pEquals;
		}
		pToken = strtok(NULL,"&");
	}
	return NULL;
}

char *getmimeenv(char *query)
{
	static char buffer[8192];
	char boundary1[100];
	char boundary2[100];
	char pQuery[64];
	char *pPostData;
	int i=0;
	int j=0;

	if (request.PostData==NULL) return NULL;
	strncpy(pQuery, query, sizeof(pQuery)-1);
	pPostData=request.PostData;
	memset(buffer, 0, sizeof(buffer));
	memset(boundary1, 0, sizeof(boundary1));
	memset(boundary2, 0, sizeof(boundary2));
	while (pQuery[i]) {
		/* FIXME: not fatal yet, but case sensitivity needs to be removed */
		pQuery[i]=tolower(pQuery[i]);
		i++;
	}
	i=0;
	j=0;
	while ((*pPostData!='\r')&&(*pPostData!='\n')&&(i<request.ContentLength)&&(j<sizeof(boundary1)-1)) {
		boundary1[j]=*pPostData;
		pPostData++;
		i++;
		j++;
	}
	snprintf(boundary2, sizeof(boundary2)-1, "%s--", boundary1);
	while ((strncmp(pPostData, boundary2, sizeof(boundary2))!=0)&&(i<request.ContentLength)) {
		while ((*pPostData=='\r')||(*pPostData=='\n')) {
			pPostData++;
			i++;
		}
		if (strncmp(pPostData, "Content-Disposition: form-data; name=\"", 38)==0) {
			pPostData+=38;
			if (strncmp(pPostData, pQuery, strlen(pQuery)-1)==0) {
				pPostData+=strlen(pQuery)+1;
				while ((*pPostData=='\r')||(*pPostData=='\n')) {
					pPostData++;
					i++;
				}
				j=0;
				while ((strncmp(pPostData, boundary1, strlen(boundary1))!=0)&&(i<request.ContentLength)&&(j<sizeof(buffer)-1)) {
					buffer[j]=*pPostData;
					pPostData++;
					i++;
					j++;
				}
				if (buffer[strlen(buffer)-1]=='\n') {
					buffer[strlen(buffer)-1]='\0';
				}
				if (buffer[strlen(buffer)-1]=='\r') {
					buffer[strlen(buffer)-1]='\0';
				}
				return buffer;
			}
		} else {
			pPostData++;
			i++;
		}
	}
	return NULL;
}

char *getpostenv(char *query)
{
	char Buffer[8192];
	char pQuery[64];
	char *pEquals;
	char *pToken;
	int loop=0;

	if (request.PostData==NULL) return NULL;
	strncpy(Buffer, request.PostData, sizeof(Buffer)-1);
	strncpy(pQuery, query, sizeof(pQuery)-1);
	while (pQuery[loop]) {
		pQuery[loop]=toupper(pQuery[loop]);
		loop++;
	}
	pToken=strtok(Buffer, "&");
	while (pToken!=NULL) {
		pEquals=strchr(pToken, '=');
		if (pEquals!=NULL) {
			*pEquals++='\0';
			URLDecode(pToken);
			loop=0;
			while (pToken[loop]) {
				pToken[loop]=toupper(pToken[loop]);
				loop++;
			}
			URLDecode(pEquals);
			if ((strcmp(pQuery, pToken)==0))
				return pEquals;
		}
		pToken=strtok(NULL, "&");
	}
	return NULL;
}

char *get_mime_type(char *name)
{
	char *mime_types[40][2]={
		{ ".html", "text/html" },
		{ ".htm",  "text/html" },
		{ ".shtml","text/html" },
		{ ".css",  "text/css" },
		{ ".txt",  "text/plain" },
		{ ".mdb",  "application/msaccess" },
		{ ".xls",  "application/msexcel" },
		{ ".doc",  "application/msword" },
		{ ".exe",  "application/octet-stream" },
		{ ".pdf",  "application/pdf" },
		{ ".rtf",  "application/rtf" },
		{ ".tgz",  "application/x-compressed" },
		{ ".gz",   "application/x-compressed" },
		{ ".z",    "application/x-compress" },
		{ ".swf",  "application/x-shockwave-flash" },
		{ ".tar",  "application/x-tar" },
		{ ".rar",  "application/x-rar-compressed" },
		{ ".zip",  "application/x-zip-compressed" },
		{ ".ra",   "audio/x-pn-realaudio" },
		{ ".ram",  "audio/x-pn-realaudio" },
		{ ".wav",  "audio/x-wav" },
		{ ".gif",  "image/gif" },
		{ ".jpeg", "image/jpeg" },
		{ ".jpe",  "image/jpeg" },
		{ ".jpg",  "image/jpeg" },
		{ ".png",  "image/png" },
		{ ".avi",  "video/avi" },
		{ ".mp3",  "video/mpeg" },
		{ ".mpeg", "video/mpeg" },
		{ ".mpg",  "video/mpeg" },
		{ ".qt",   "video/quicktime" },
		{ ".mov",  "video/quicktime" },
		{ "",      "" }
	};
	char *extension;
	int i;

	extension=strrchr(name, '.');
	if (extension==NULL) {
		return "text/plain";
	}
	i=0;
	while (strlen(mime_types[i][0])>0) {
		if (strcasecmp(extension, mime_types[i][0])==0) {
			return mime_types[i][1];
		}
		i++;
	}
	return "application/octet-stream";
}

char *strcasestr(char *src, char *query)
{
	char *pToken;
	char Buffer[8192];
	char Query[64];
	int loop;

	if (strlen(src)==0) return NULL;
	memset(Buffer, 0, sizeof(Buffer));
	strncpy(Buffer, src, sizeof(Buffer)-1);
	strncpy(Query, query, sizeof(Query)-1);
	loop=0;
	while (Buffer[loop]) {
		Buffer[loop]=toupper(Buffer[loop]);
		loop++;
	}
	loop=0;
	while (Query[loop]) {
		Query[loop]=toupper(Query[loop]);
		loop++;
	}
	pToken=strstr(Buffer, Query);
	if (pToken!=NULL) {
		return src+(pToken-(char *)&Buffer);
	}
	return NULL;
}

void striprn(char *string)
{
	while ((string[strlen(string)-1]=='\r')||(string[strlen(string)-1]=='\n')) {
		string[strlen(string)-1]='\0';
	}
}
