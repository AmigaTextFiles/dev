#define buf_size 1024 \

#define max_include_depth 10 \

#define max_file_name_length 255
#define cur_file file[include_depth]
#define cur_file_name file_name[include_depth]
#define cur_line line[include_depth]
#define web_file file[0]
#define web_file_name file_name[0] \

#define lines_dont_match (change_limit-change_buffer!=limit-buffer|| \
strncmp(buffer,change_buffer,(size_t) (limit-buffer) ) )  \

#define too_long() {include_depth--; \
err_print("! Include file name too long") ;goto restart;} \

#define spotless 0
#define harmless_message 1
#define error_message 2
#define fatal_message 3
#define mark_harmless {if(history==spotless) history= harmless_message;}
#define mark_error history= error_message \

#define fatal(s,t) { \
fprintf(stderr,s) ;err_print(t) ; \
history= fatal_message;exit(wrap_up() ) ; \
} \

#define RETURN_OK 0
#define RETURN_WARN 5
#define RETURN_ERROR 10
#define RETURN_FAIL 20 \

#define show_banner flags['b']
#define show_happiness flags['h'] \

#define update_terminal fflush(stderr)  \

#define max_path_length (BUFSIZ-2)  \

#define alloc_object(object,size,type)  \
if(!(object= (type*) malloc((size) *sizeof(type) ) ) )  \
fatal("","! Memory allocation failure") ;
#define free_object(object)  \
if(object) { \
free(object) ; \
object= NULL; \
} \

/*1:*/
#line 13 "examples/wmerge.w"

#line 4 "wmerg-p13.ch"
#include <string.h>
#include <signal.h>
#include <stdio.h>

#ifdef SEPARATORS
char separators[]= SEPARATORS;
#else
char separators[]= "://";
#endif

#define PATH_SEPARATOR   separators[0]
#define DIR_SEPARATOR    separators[1]
#define DEVICE_SEPARATOR separators[2]
#line 15 "examples/wmerge.w"
#include <stdlib.h> 
#include <ctype.h> 
/*2:*/
#line 35 "examples/wmerge.w"

typedef short boolean;
typedef unsigned char eight_bits;
typedef char ASCII;

#line 56 "wmerg-p13.ch"
/*:2*//*5:*/
#line 68 "examples/wmerge.w"

#line 66 "wmerg-p13.ch"
ASCII*buffer;
ASCII*buffer_end;
#line 71 "examples/wmerge.w"
ASCII*limit;
ASCII*loc;

/*:5*//*7:*/
#line 134 "examples/wmerge.w"

int include_depth;
#line 93 "wmerg-p13.ch"
FILE**file;
FILE*change_file;
char**file_name;
char*change_file_name;
char*alt_web_file_name;
int*line;
#line 143 "examples/wmerge.w"
int change_line;
int change_depth;
boolean input_has_ended;
boolean changing;
boolean web_file_open= 0;

/*:7*//*8:*/
#line 160 "examples/wmerge.w"

#line 112 "wmerg-p13.ch"
char*change_buffer;
#line 162 "examples/wmerge.w"
char*change_limit;

/*:8*//*23:*/
#line 478 "examples/wmerge.w"

int history= spotless;

/*:23*//*30:*/
#line 575 "examples/wmerge.w"

int argc;
char**argv;
#line 344 "wmerg-p13.ch"
char*check_file_name;
char*out_file_name;
boolean*flags;
#line 580 "examples/wmerge.w"

/*:30*//*40:*/
#line 691 "examples/wmerge.w"

#line 391 "wmerg-p13.ch"
FILE*check_file;
FILE*out_file;
#line 693 "examples/wmerge.w"

/*:40*//*43:*/
#line 419 "wmerg-p13.ch"

const char Version[]= "$VER: WMerge 3.4 [p13] ("__DATE__", "__TIME__")\n";

/*:43*//*47:*/
#line 480 "wmerg-p13.ch"

char*include_path;
char*p,*path_prefix,*next_path_prefix;

/*:47*//*49:*/
#line 517 "wmerg-p13.ch"

int i;

/*:49*/
#line 17 "examples/wmerge.w"

/*4:*/
#line 51 "examples/wmerge.w"


/*:4*//*24:*/
#line 490 "examples/wmerge.w"

#line 257 "wmerg-p13.ch"
void err_print(char*);
#line 492 "examples/wmerge.w"

/*:24*//*32:*/
#line 599 "examples/wmerge.w"

#line 361 "wmerg-p13.ch"
void scan_args(void);
#line 601 "examples/wmerge.w"

/*:32*//*44:*/
#line 425 "wmerg-p13.ch"

int get_line(void);
int input_ln(FILE*);
int main(int,char**);
int wrap_up(void);
void check_change(void);
void check_complete(void);
void prime_the_change_buffer(void);
void put_line(void);
void reset_input(void);

/*:44*//*45:*/
#line 438 "wmerg-p13.ch"

static boolean set_path(char*,char*);

/*:45*//*52:*/
#line 543 "wmerg-p13.ch"

void catch_break(int);

/*:52*/
#line 18 "examples/wmerge.w"

/*6:*/
#line 93 "examples/wmerge.w"

#line 74 "wmerg-p13.ch"
int input_ln(
FILE*fp)
#line 96 "examples/wmerge.w"
{
register int c= EOF;
register char*k;
if(feof(fp))return(0);
limit= k= buffer;
while(k<=buffer_end&&(c= getc(fp))!=EOF&&c!='\n')
if((*(k++)= c)!=' ')limit= k;
if(k>buffer_end)
if((c= getc(fp))!=EOF&&c!='\n'){
ungetc(c,fp);loc= buffer;err_print("! Input line too long");

}
if(c==EOF&&limit==buffer)return(0);

return(1);
}

/*:6*//*9:*/
#line 171 "examples/wmerge.w"

#line 119 "wmerg-p13.ch"
void prime_the_change_buffer(void)
#line 174 "examples/wmerge.w"
{
change_limit= change_buffer;
/*10:*/
#line 185 "examples/wmerge.w"

while(1){
change_line++;
if(!input_ln(change_file))return;
if(limit<buffer+2)continue;
if(buffer[0]!='@')continue;
if(isupper(buffer[1]))buffer[1]= tolower(buffer[1]);
if(buffer[1]=='x')break;
if(buffer[1]=='y'||buffer[1]=='z'||buffer[1]=='i'){
loc= buffer+2;
err_print("! Missing @x in change file");

}
}

/*:10*/
#line 176 "examples/wmerge.w"
;
/*11:*/
#line 202 "examples/wmerge.w"

do{
change_line++;
if(!input_ln(change_file)){
err_print("! Change file ended after @x");

return;
}
}while(limit==buffer);

/*:11*/
#line 177 "examples/wmerge.w"
;
/*12:*/
#line 212 "examples/wmerge.w"

{
change_limit= change_buffer-buffer+limit;
#line 125 "wmerg-p13.ch"
strncpy(change_buffer,buffer,(size_t)(limit-buffer+1));
#line 216 "examples/wmerge.w"
}

/*:12*/
#line 178 "examples/wmerge.w"
;
}

/*:9*//*13:*/
#line 230 "examples/wmerge.w"

#line 132 "wmerg-p13.ch"
void check_change(void)
#line 233 "examples/wmerge.w"
{
int n= 0;
if(lines_dont_match)return;
while(1){
changing= 1;change_line++;
if(!input_ln(change_file)){
err_print("! Change file ended before @y");

change_limit= change_buffer;changing= 0;
return;
}
if(limit>buffer+1&&buffer[0]=='@'){
if(isupper(buffer[1]))buffer[1]= tolower(buffer[1]);
/*14:*/
#line 263 "examples/wmerge.w"

if(buffer[1]=='x'||buffer[1]=='z'){
loc= buffer+2;err_print("! Where is the matching @y?");

}
else if(buffer[1]=='y'){
if(n>0){
loc= buffer+2;
fprintf(stderr,"\n! Hmm... %d ",n);
err_print("of the preceding lines failed to match");

}
change_depth= include_depth;
return;
}

/*:14*/
#line 247 "examples/wmerge.w"
;
}
/*12:*/
#line 212 "examples/wmerge.w"

{
change_limit= change_buffer-buffer+limit;
#line 125 "wmerg-p13.ch"
strncpy(change_buffer,buffer,(size_t)(limit-buffer+1));
#line 216 "examples/wmerge.w"
}

/*:12*/
#line 249 "examples/wmerge.w"
;
changing= 0;cur_line++;
while(!input_ln(cur_file)){
if(include_depth==0){
err_print("! CWEB file ended during a change");

input_has_ended= 1;return;
}
include_depth--;cur_line++;
}
if(lines_dont_match)n++;
}
}

/*:13*//*15:*/
#line 282 "examples/wmerge.w"

#line 139 "wmerg-p13.ch"
void reset_input(void)
#line 285 "examples/wmerge.w"
{
limit= buffer;loc= buffer+1;buffer[0]= ' ';
#line 146 "wmerg-p13.ch"
include_depth= 0;cur_line= 0;change_line= 0;
/*16:*/
#line 297 "examples/wmerge.w"

if((web_file= fopen(web_file_name,"r"))==NULL){
strcpy(web_file_name,alt_web_file_name);
if((web_file= fopen(web_file_name,"r"))==NULL)
fatal("! Cannot open input file ",web_file_name);
}


web_file_open= 1;
if((change_file= fopen(change_file_name,"r"))==NULL)
fatal("! Cannot open change file ",change_file_name);

/*:16*/
#line 147 "wmerg-p13.ch"
;
#line 289 "examples/wmerge.w"
change_depth= include_depth;
changing= 1;prime_the_change_buffer();changing= !changing;
limit= buffer;loc= buffer+1;buffer[0]= ' ';input_has_ended= 0;
}

/*:15*//*17:*/
#line 315 "examples/wmerge.w"

get_line()
{
restart:
if(changing&&include_depth==change_depth)
/*21:*/
#line 423 "examples/wmerge.w"
{
change_line++;
if(!input_ln(change_file)){
err_print("! Change file ended without @z");

buffer[0]= '@';buffer[1]= 'z';limit= buffer+2;
}
if(limit>buffer){
*limit= ' ';
if(buffer[0]=='@'){
if(isupper(buffer[1]))buffer[1]= tolower(buffer[1]);
if(buffer[1]=='x'||buffer[1]=='y'){
loc= buffer+2;
err_print("! Where is the matching @z?");

}
else if(buffer[1]=='z'){
prime_the_change_buffer();changing= !changing;
}
}
}
}

/*:21*/
#line 320 "examples/wmerge.w"
;
if(!changing||include_depth>change_depth){
/*20:*/
#line 407 "examples/wmerge.w"
{
cur_line++;
while(!input_ln(cur_file)){
if(include_depth==0){input_has_ended= 1;break;}
else{
fclose(cur_file);include_depth--;
if(changing&&include_depth==change_depth)break;
cur_line++;
}
}
if(!changing&&!input_has_ended)
if(limit-buffer==change_limit-change_buffer)
if(buffer[0]==change_buffer[0])
if(change_limit>change_buffer)check_change();
}

/*:20*/
#line 322 "examples/wmerge.w"
;
if(changing&&include_depth==change_depth)goto restart;
}
loc= buffer;*limit= ' ';
if(*buffer=='@'&&(*(buffer+1)=='i'||*(buffer+1)=='I')){
loc= buffer+2;
while(loc<=limit&&(*loc==' '||*loc=='\t'||*loc=='"'))loc++;
if(loc>=limit){
err_print("! Include file name not given");

goto restart;
}
if(include_depth>=max_include_depth-1){
err_print("! Too many nested includes");

goto restart;
}
include_depth++;
/*19:*/
#line 366 "examples/wmerge.w"
{
#line 182 "wmerg-p13.ch"
static char*temp_file_name;
#line 368 "examples/wmerge.w"
char*cur_file_name_end= cur_file_name+max_file_name_length-1;
char*k= cur_file_name,*kk;
int l;

#line 188 "wmerg-p13.ch"
alloc_object(temp_file_name,max_file_name_length,char);
while(*loc!=' '&&*loc!='\t'&&*loc!='"'&&k<=cur_file_name_end)*k++= *loc++;
#line 373 "examples/wmerge.w"
if(k>cur_file_name_end)too_long();

*k= '\0';
if((cur_file= fopen(cur_file_name,"r"))!=NULL){
cur_line= 0;
goto restart;
}
#line 218 "wmerg-p13.ch"
if(0==set_path(include_path,getenv("CWEBINPUTS"))){
include_depth--;goto restart;
}
path_prefix= include_path;
while(path_prefix){
for(kk= temp_file_name,p= path_prefix,l= 0;
p&&*p&&*p!=PATH_SEPARATOR;
*kk++= *p++,l++);
if(path_prefix&&*path_prefix&&*path_prefix!=PATH_SEPARATOR&&
*--p!=DEVICE_SEPARATOR&&*p!=DIR_SEPARATOR){
*kk++= DIR_SEPARATOR;l++;
}
if(k+l+2>=cur_file_name_end)too_long();
strcpy(kk,cur_file_name);
if((cur_file= fopen(temp_file_name,"r"))!=NULL){
cur_line= 0;goto restart;
}
if((next_path_prefix= strchr(path_prefix,PATH_SEPARATOR))!=NULL)
path_prefix= next_path_prefix+1;
else break;
}
#line 404 "examples/wmerge.w"
include_depth--;err_print("! Cannot open include file");goto restart;
}

/*:19*/
#line 340 "examples/wmerge.w"
;
}
return(!input_has_ended);
}

#line 153 "wmerg-p13.ch"
void put_line(void)
#line 346 "examples/wmerge.w"
{
char*ptr= buffer;
while(ptr<limit)putc(*ptr++,out_file);
putc('\n',out_file);
}

#line 168 "wmerg-p13.ch"
/*:17*//*22:*/
#line 449 "examples/wmerge.w"

#line 245 "wmerg-p13.ch"
void check_complete(void){
#line 452 "examples/wmerge.w"
if(change_limit!=change_buffer){
#line 251 "wmerg-p13.ch"
strncpy(buffer,change_buffer,(size_t)(change_limit-change_buffer+1));
#line 454 "examples/wmerge.w"
limit= buffer+(int)(change_limit-change_buffer);
changing= 1;change_depth= include_depth;loc= buffer;
err_print("! Change file entry did not match");

}
}

/*:22*//*25:*/
#line 494 "examples/wmerge.w"

#line 265 "wmerg-p13.ch"
void err_print(char*s)
#line 498 "examples/wmerge.w"
{
char*k,*l;
fprintf(stderr,*s=='!'?"\n%s":"%s",s);
if(web_file_open)/*26:*/
#line 514 "examples/wmerge.w"

{if(changing&&include_depth==change_depth)
printf(". (l. %d of change file)\n",change_line);
else if(include_depth==0)fprintf(stderr,". (l. %d)\n",cur_line);
else fprintf(stderr,". (l. %d of include file %s)\n",cur_line,cur_file_name);
l= (loc>=limit?limit:loc);
if(l>buffer){
for(k= buffer;k<l;k++)
if(*k=='\t')putc(' ',stderr);
else putc(*k,stderr);
putchar('\n');
for(k= buffer;k<l;k++)putc(' ',stderr);
}
for(k= l;k<limit;k++)putc(*k,stderr);
putc('\n',stderr);
}

/*:26*/
#line 501 "examples/wmerge.w"
;
update_terminal;mark_error;
}

/*:25*//*28:*/
#line 546 "examples/wmerge.w"

#line 297 "wmerg-p13.ch"
int wrap_up(void){
#line 303 "wmerg-p13.ch"
if(history>spotless)putchar('\n');
/*56:*/
#line 601 "wmerg-p13.ch"

if(out_file)
fclose(out_file);
if(check_file)
fclose(check_file);
if(check_file_name)
remove(check_file_name);

/*:56*/
#line 304 "wmerg-p13.ch"

/*29:*/
#line 553 "examples/wmerge.w"

switch(history){
case spotless:if(show_happiness)fprintf(stderr,"(No errors were found.)\n");break;
case harmless_message:
fprintf(stderr,"(Did you see the warning message above?)\n");break;
case error_message:
fprintf(stderr,"(Pardon me, but I think I spotted something wrong.)\n");break;
case fatal_message:fprintf(stderr,"(That was a fatal error, my friend.)\n");
}

/*:29*/
#line 305 "wmerg-p13.ch"
;
#line 312 "wmerg-p13.ch"
#ifdef __TURBOC__
{
int return_val;

switch(history){
case harmless_message:return_val= RETURN_WARN;break;
case error_message:return_val= RETURN_ERROR;break;
case fatal_message:return_val= RETURN_FAIL;break;
default:return_val= RETURN_OK;
}
return(return_val);
}
#else
switch(history){
case harmless_message:return(RETURN_WARN);break;
case error_message:return(RETURN_ERROR);break;
case fatal_message:return(RETURN_FAIL);break;
default:return(RETURN_OK);
}
#endif
#line 551 "examples/wmerge.w"
}

/*:28*//*33:*/
#line 603 "examples/wmerge.w"

#line 368 "wmerg-p13.ch"
void scan_args(void)
#line 606 "examples/wmerge.w"
{
char*dot_pos;
register char*s;
boolean found_web= 0,found_change= 0,found_out= 0;

boolean flag_change;

while(--argc>0){
if(**(++argv)=='-'||**argv=='+')/*37:*/
#line 673 "examples/wmerge.w"

{
if(**argv=='-')flag_change= 0;
else flag_change= 1;
for(dot_pos= *argv+1;*dot_pos>'\0';dot_pos++)
flags[*dot_pos]= flag_change;
}

/*:37*/
#line 614 "examples/wmerge.w"

else{
s= *argv;dot_pos= NULL;
while(*s){
if(*s=='.')dot_pos= s++;
#line 374 "wmerg-p13.ch"
else if(*s==DIR_SEPARATOR||*s==DEVICE_SEPARATOR||*s=='/')
dot_pos= NULL,++s;
#line 620 "examples/wmerge.w"
else s++;
}
if(!found_web)/*34:*/
#line 639 "examples/wmerge.w"

{
if(s-*argv>max_file_name_length-5)
/*39:*/
#line 686 "examples/wmerge.w"
fatal("! Filename too long\n",*argv);

/*:39*/
#line 642 "examples/wmerge.w"
;
if(dot_pos==NULL)
sprintf(web_file_name,"%s.w",*argv);
else{
strcpy(web_file_name,*argv);
*dot_pos= 0;
}
sprintf(alt_web_file_name,"%s.web",*argv);
*out_file_name= '\0';
found_web= 1;
}

/*:34*/
#line 622 "examples/wmerge.w"

else if(!found_change)/*35:*/
#line 654 "examples/wmerge.w"

{
if(s-*argv>max_file_name_length-4)
/*39:*/
#line 686 "examples/wmerge.w"
fatal("! Filename too long\n",*argv);

/*:39*/
#line 657 "examples/wmerge.w"
;
if(dot_pos==NULL)
sprintf(change_file_name,"%s.ch",*argv);
else strcpy(change_file_name,*argv);
found_change= 1;
}

/*:35*/
#line 623 "examples/wmerge.w"

else if(!found_out)/*36:*/
#line 664 "examples/wmerge.w"

{
if(s-*argv>max_file_name_length-5)
/*39:*/
#line 686 "examples/wmerge.w"
fatal("! Filename too long\n",*argv);

/*:39*/
#line 667 "examples/wmerge.w"
;
if(dot_pos==NULL)sprintf(out_file_name,"%s.out",*argv);
else strcpy(out_file_name,*argv);
found_out= 1;
}

/*:36*/
#line 624 "examples/wmerge.w"

else/*38:*/
#line 681 "examples/wmerge.w"

{
fatal("! Usage: wmerge webfile[.w] [changefile[.ch] [outfile[.out]]]\n","")
}

/*:38*/
#line 625 "examples/wmerge.w"
;
}
}
if(!found_web)/*38:*/
#line 681 "examples/wmerge.w"

{
fatal("! Usage: wmerge webfile[.w] [changefile[.ch] [outfile[.out]]]\n","")
}

/*:38*/
#line 628 "examples/wmerge.w"
;
#line 381 "wmerg-p13.ch"
#ifdef _DEV_NULL
if(!found_change)strcpy(change_file_name,_DEV_NULL);
#else
if(!found_change)strcpy(change_file_name,"/dev/null");
#endif
#line 630 "examples/wmerge.w"
}

/*:33*/
#line 19 "examples/wmerge.w"

#line 23 "wmerg-p13.ch"
int main(int ac,char**av)
#line 22 "examples/wmerge.w"
{
argc= ac;argv= av;
#line 29 "wmerg-p13.ch"
/*50:*/
#line 528 "wmerg-p13.ch"

if(signal(SIGINT,&catch_break)==SIG_ERR)
exit(1);

/*:50*/
#line 29 "wmerg-p13.ch"

/*48:*/
#line 500 "wmerg-p13.ch"

alloc_object(buffer,buf_size,ASCII);
buffer_end= buffer+buf_size-2;
alloc_object(file,max_include_depth,FILE*);
alloc_object(file_name,max_include_depth,char*);
for(i= 0;i<max_include_depth;i++)
alloc_object(file_name[i],max_file_name_length,char);
alloc_object(change_file_name,max_file_name_length,char);
alloc_object(alt_web_file_name,max_file_name_length,char);
alloc_object(line,max_include_depth,int);
alloc_object(change_buffer,buf_size,char);
alloc_object(check_file_name,max_file_name_length,char);
alloc_object(out_file_name,max_file_name_length,char);
alloc_object(flags,256,boolean);
alloc_object(include_path,max_path_length+2,char);
strcpy(include_path,"");

/*:48*/
#line 30 "wmerg-p13.ch"
;
/*31:*/
#line 583 "examples/wmerge.w"

show_banner= show_happiness= 1;

/*:31*/
#line 31 "wmerg-p13.ch"
;
#line 25 "examples/wmerge.w"
/*41:*/
#line 694 "examples/wmerge.w"

scan_args();
#line 400 "wmerg-p13.ch"
strcpy(check_file_name,out_file_name);
if(check_file_name[0]!='\0'){
char*dot_pos= strrchr(check_file_name,'.');
if(dot_pos==NULL)strcat(check_file_name,".mtp");
else strcpy(dot_pos,".mtp");
}
if(out_file_name[0]=='\0')out_file= stdout;
else if((out_file= fopen(check_file_name,"w"))==NULL)
fatal("! Cannot open output file ",check_file_name);
#line 699 "examples/wmerge.w"


/*:41*/
#line 25 "examples/wmerge.w"
;
reset_input();
while(get_line())
put_line();
fflush(out_file);
check_complete();
fflush(out_file);
#line 37 "wmerg-p13.ch"
if(out_file!=stdout){
fclose(out_file);out_file= NULL;
/*53:*/
#line 554 "wmerg-p13.ch"

if((out_file= fopen(out_file_name,"r"))!=NULL){
char*x,*y;
int x_size,y_size,comparison;

if((check_file= fopen(check_file_name,"r"))==NULL)
fatal("! Cannot open output file",check_file_name);

alloc_object(x,BUFSIZ,char);
alloc_object(y,BUFSIZ,char);

/*54:*/
#line 582 "wmerg-p13.ch"

do{
x_size= fread(x,1,BUFSIZ,out_file);
y_size= fread(y,1,BUFSIZ,check_file);
comparison= (x_size==y_size);
if(comparison)comparison= !memcmp(x,y,x_size);
}while(comparison&&!feof(out_file)&&!feof(check_file));

/*:54*/
#line 565 "wmerg-p13.ch"


fclose(out_file);out_file= NULL;
fclose(check_file);check_file= NULL;

/*55:*/
#line 593 "wmerg-p13.ch"

if(comparison)
remove(check_file_name);
else{
remove(out_file_name);
rename(check_file_name,out_file_name);
}

/*:55*/
#line 570 "wmerg-p13.ch"


free_object(y);
free_object(x);
}
else
rename(check_file_name,out_file_name);

check_file_name= NULL;

/*:53*/
#line 39 "wmerg-p13.ch"

}
return wrap_up();
#line 33 "examples/wmerge.w"
}

/*:1*//*46:*/
#line 450 "wmerg-p13.ch"

static boolean set_path(char*include_path,char*environment)
{
char*string;

alloc_object(string,max_path_length+2,char);

#ifdef CWEBINPUTS
strcpy(include_path,CWEBINPUTS);
#endif

if(environment){
if(strlen(environment)+strlen(include_path)>=max_path_length){
err_print("! Include path too long");
free_object(string);return(0);

}
else{
sprintf(string,"%s%c%s",environment,PATH_SEPARATOR,include_path);
strcpy(include_path,string);
}
}
free_object(string);return(1);
}

/*:46*//*51:*/
#line 536 "wmerg-p13.ch"

void catch_break(int dummy)
{
history= fatal_message;
exit(wrap_up());
}

/*:51*/
