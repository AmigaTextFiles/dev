/*
    xa65 - 6502 cross assembler and utility suite
    printcbm - list CBM basic programs
    Copyright (C) 1997 André Fachat (a.fachat@physik.tu-chemnitz.de)

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
    Foundation, Inc., 675 Mass Ave, Cambridge, MA 02139, USA.
*/

#include <stdio.h>

char *cmd[]={ "end","for","next","data","input#","input","dim","read",
		    "let","goto","run","if","restore","gosub","return",
		    "rem","stop","on","wait","load","save","verify","def",
		    "poke","print#","print","cont","list","clr","cmd","sys",
		    "open","close","get","new","tab(","to","fn","spc(",
		    "then","not","step","+","-","*","/","^","and","or",
		    ">","=","<","sgn","int","abs","usr","fre","pos","sqr",
		    "rnd","log","exp","cos","sin","tan","atn","peek","len",
		    "str$","val","asc","chr$","left$","right$","mid$","go"};
		    
int main(int argc, char *argv[]){
	FILE *fp;
	int a,b,c;
	if(argc>1){
		fp=fopen(argv[1],"rb");
		if(fp){
			b=fgetc(fp);
			b=fgetc(fp);
			while(b!=EOF){
				a=fgetc(fp);
				a=a+256*fgetc(fp);
				if(a){
					a=fgetc(fp);
					a=a+256*fgetc(fp);
					printf("%d ",a);
					while((c=fgetc(fp))){
						if(c==EOF)
							break;
						if(c>=0x80 && c<0xcc)
							printf("%s",cmd[c-0x80]);
						else
							printf("%c",c);
					}
					printf("\n");
				} else
					break;
			}
			fclose(fp);
		} else 
			printf("File %s not found!\n",argv[1]);
	} else 
		printf("usage: listcbm file\n");
	return(0);
}
