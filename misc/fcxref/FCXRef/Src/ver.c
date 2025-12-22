/* :ts=4								ver.c
 *
 *    ver - Version update util
 *    Copyright (C) 1998 Gáti Gergely
 *
 *    This program is free software; you can redistribute it and/or modify
 *    it under the terms of the GNU General Public License as published by
 *    the Free Software Foundation; either version 2 of the License, or
 *    (at your option) any later version.
 *
 *    This program is distributed in the hope that it will be useful,
 *    but WITHOUT ANY WARRANTY; without even the implied warranty of
 *    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 *    GNU General Public License for more details.
 *
 *    You should have received a copy of the GNU General Public License
 *    along with this program; if not, write to the Free Software Foundation,
 *    Inc., 59 Temple Place - Suite 330, Boston, MA 02111-1307, USA.
 *
 *    e-mail: gatig@dragon.klte.hu
 *
 *
 * usage:
 * 			filename		- basename of app.
 * 			none			- update date only
 * 			-r				- update rev
 * 			-v				- update ver
 */

#include <stdio.h>
#include <string.h>
#include <stdlib.h>
#include <time.h>

char fname[300];
char vname[300];
char vers[100];
char revs[100];
char copyright[]="©1998 by gega (Gáti Gergely)";

int main(int argc, char **argv) {
	FILE *f,*v;
	time_t tval;
	char *ts;
	int ver,rev;
	int day,month,year;
	int hour,minute;

	if(argc<2) return(-1);
	strcpy(fname,argv[1]);
	strcat(fname,"_ver.c");
	strcpy(vname,argv[1]);
	strcat(vname,"_ver.data");
	v=fopen(vname,"rb");	
	if(v!=NULL) {
		fgets(vers,100,v);
		ver=atoi(vers);
		fgets(revs,100,v);
		rev=atoi(revs);
		fclose(v);
	} else rev=ver=0;

	tval=time(NULL);
	ts=ctime(&tval);
	ts[strlen(ts)-1]='\0';

	if(argc>2) {
		if(strcmp(argv[2],"-r")==0) rev++;
		if(strcmp(argv[2],"-v")==0) { ver++; rev=0; }
	}

	v=fopen(vname,"wb");
	if(v==NULL) return(-1);
	fprintf(v,"%d\n%d\n",ver,rev);
	fclose(v);

	f=fopen(fname,"wb");
	if(f==NULL) return(-1);

	fprintf(f,"#define VERSION         %d\n",ver);
	fprintf(f,"#define REVISION        %d\n",rev);
	fprintf(f,"#define DATE            \"%s\"\n",ts);
	ts[3]=' ';
	ts[7]=' ';
	if(ts[8]==' ') ts[8]=' ';
	ts[10]=' ';
	fprintf(f,"#define VERSTAG         \"\\0$VER: %s V%d.%d %s %s\"\n",argv[1],ver,rev,ts,copyright);
	fprintf(f,"\nchar *%s_Version=VERSTAG;\n",argv[1]);
	fclose(f);
}
