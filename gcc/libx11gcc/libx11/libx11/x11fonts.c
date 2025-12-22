
#include <exec/types.h>
#include <exec/exec.h>
#include <exec/memory.h>
#include <libraries/dos.h>
#include <graphics/text.h>
#include <graphics/gfxbase.h>
#include <libraries/diskfont.h>
#include <intuition/intuition.h>
#include <string.h>
#include <stdio.h>
#include <intuition/intuition.h>
#include <intuition/intuitionbase.h>
#include <graphics/gfx.h>
#include <graphics/gfxbase.h>
#include <graphics/gfxmacros.h>
#include <graphics/displayinfo.h>
#include <graphics/text.h>
#include <devices/timer.h>
#include <proto/intuition.h>
#include <proto/graphics.h>
#include <proto/diskfont.h>
#include <stdlib.h>
#include <stdio.h>
#include <string.h>
#include <ctype.h>
#include "debug.h"
#include "libX11.h"
#include "x11display.h"
#include "lists.h"
#define XLIB_ILLEGAL_ACCESS 1
#include <X11/X.h>
#include <X11/Xlib.h>
#include "x11fonts.h"
extern int debugxemul;
struct RastPort FontRP;
#ifdef DEBUGXEMUL_ENTRY
extern int bInformFonts;
#endif
char *X11fontname[100]={"topaz"},*X11fontamiga[100] = {"topaz.font"};
int X11fontmapped = 1;
typedef struct {
char zName[64];
int vSize;
void *pData;
} X11FontNode;
ListNode_t *X11FontList = NULL;
int X11FontSize;
char X11FontName[256];
int nFontAccess = 0;
void
X11init_fonts( void )
{
FILE *fp;
char str1[40],str2[40];
struct Screen* Scr;
if( X11FontList )
return;
InitRastPort(&FontRP);
X11FontList = List_MakeNull();
Scr = LockPubScreen(NULL);
if( !Scr ){
fprintf(stderr,"No public screen?\n");
exit(-1);
}
sprintf(str1,"Workbench10x%d",Scr->RastPort.Font->tf_YSize);
DG.X11Font = XLoadQueryFont( NULL, str1 );
UnlockPubScreen(NULL,Scr);
fp = fopen("AmigaDefaults","r");
if( !fp ){
fclose(fp);
fp = fopen("libx11:AmigaDefaults","r");
}
if( !fp ){
fclose(fp);
return;
}
while( !feof(fp) ){
char c;
fscanf(fp,"%s %s",str1,str2);
if( str1[0]=='!' )
while( (c=fgetc(fp))!='\n' && !feof(fp) );
else
if( strstr(str1,"fontmap") ){
char *p = str1,*q;
while( *p!='.' && *p!=':' && *p ) p++;
q = ++p;
while( *q!='.' && *q!=':' && *q ) q++;
*q = 0;
X11fontname[X11fontmapped] = malloc(strlen(p)+1);
if( !X11fontname[X11fontmapped] )
X11resource_exit(FONTS3);
strcpy(X11fontname[X11fontmapped],p);
X11fontamiga[X11fontmapped] = malloc(strlen(str2)+1);
if( !X11fontamiga[X11fontmapped] )
X11resource_exit(FONTS4);
strcpy(X11fontamiga[X11fontmapped++],str2);
}
}
fclose(fp);
}
void X11exit_fonts(void){
int i;
for( i=1; i<X11fontmapped; i++ ){
free(X11fontname[i]);
free(X11fontamiga[i]);
}
X11fontmapped = 1;
List_FreeList(X11FontList);
}
struct TextFont *tfont;
struct TextAttr *tattr;
Font
XLoadFont( Display* display,
char* name )
{
FILE *fp;
char str1[128],str2[128],fontname[64];
UBYTE *fontdata;
ULONG *fontloc;
int s1,X11FontSize,s3,s4,numchars,i,width,height,perline,k,l;
int ascent,descent;
#ifdef DEBUGXEMUL_ENTRY
FunCount_Enter( XLOADFONT, bInformFonts );
#endif
nFontAccess++;
strcpy(X11FontName,"libx11:");
strcat(X11FontName,name);
strcat(X11FontName,".bdf");
fp = fopen(X11FontName,"r+");
if( !fp ){
fclose(fp);
fp = fopen(X11FontName,"r+");
}
if( !fp ){
int style = 0;
fclose(fp);
if( strstr(name,"-i-") || strstr(name,"-o-") )
style = FSF_ITALIC;
if( strstr(name,"-bold-") )
style |= FSF_BOLD;
{
char *c = name;
int vSize;
X11FontSize=8;
while( !isdigit(*c) && *c ) c++;
sscanf(c,"%d",&vSize);
while( isdigit(*c) && *c ) c++;
if( *c=='x' && c!=name )
sscanf(c+1,"%d",&X11FontSize);
else {
X11FontSize = vSize;
}
}
if( X11FontSize<4 )
return NULL;
if( DG.wb && DG.wb->RastPort.Font )
strcpy(X11FontName,DG.wb->RastPort.Font->tf_Message.mn_Node.ln_Name);
else
strcpy(X11FontName,"topaz.font");
for( i=0; i<X11fontmapped; i++ )
if( strstr(name,X11fontname[i]) )
strcpy(X11FontName,X11fontamiga[i]);
tattr = (struct TextAttr*)malloc(sizeof(struct TextAttr));
if( !tattr )
X11resource_exit(FONTS5);
#if (MEMORYTRACKING!=0)
List_AddEntry(pMemoryList,(void*)tattr);
#endif
tattr->ta_Name = X11FontName;
if( debugxemul )
printf("opening font %s size %d\n",X11FontName,X11FontSize);
tattr->ta_YSize = X11FontSize;
tattr->ta_Style = style;
tattr->ta_Flags = FPF_DISKFONT|FPF_ROMFONT|FPF_PROPORTIONAL|FPF_DESIGNED;
tfont = OpenDiskFont(tattr);
if( strstr(name,"-i-") || strstr(name,"-o-") )
tattr->ta_Style = FSF_ITALIC;
if( strstr(name,"-bold-") )
tattr->ta_Style |= FSF_BOLD;
if( !tfont ){
printf("font not found: %s size %d\n",X11FontName,X11FontSize);
return NULL;
}
{
sFont *sf = malloc(sizeof(sFont));
#if (MEMORYTRACKING!=0)
List_AddEntry(pMemoryList,(void*)sf);
#endif
if( !sf )
X11resource_exit(FONTS6);
sf->tfont = tfont;
sf->tattr = tattr;
return((Font)sf);
}
}
fgets(X11FontName,256,fp);
fgets(X11FontName,256,fp); sscanf(X11FontName,"%s %s",str1,fontname);
if( strcmp(str1,"FONT") ){
fgets(X11FontName,256,fp); sscanf(X11FontName,"%s %s",str1,fontname);
}
fgets(X11FontName,256,fp); sscanf(X11FontName,"%s %d %d %d",str1,&s1,&X11FontSize,&s3);
fgets(X11FontName,256,fp); sscanf(X11FontName,"%s %d %d %d %d",str1,&width,&height,&s3,&s4);
perline = (width+7)>>3;
fgets(X11FontName,256,fp);
fgets(X11FontName,256,fp); sscanf(X11FontName,"%s %d",str1,&descent);
fgets(X11FontName,256,fp); sscanf(X11FontName,"%s %d",str1,&ascent);
fgets(X11FontName,256,fp);
fgets(X11FontName,256,fp); sscanf(X11FontName,"%s %d",str1,&numchars);
fontdata = malloc(perline*height*256);
fontloc = malloc(256*sizeof(ULONG));
tfont = (struct TextFont*)calloc(sizeof(struct TextFont),1);
if( !fontdata || !fontloc || !tfont ){
fclose(fp);
X11resource_exit(FONTS7);
}
#if (MEMORYTRACKING!=0)
List_AddEntry(pMemoryList,(void*)tfont);
#endif
tfont->tf_Message.mn_Node.ln_Name = fontname;
tfont->tf_YSize = height;
tfont->tf_XSize = width;
tfont->tf_LoChar = 0;
tfont->tf_HiChar = 255;
tfont->tf_CharData = fontdata;
tfont->tf_CharLoc = fontloc;
tfont->tf_Modulo = perline*256;
tfont->tf_Flags = 42;
tfont->tf_BoldSmear = 1;
tfont->tf_Baseline = ascent;
for( i=0; i<numchars; i++ ){
int encode;
fgets(X11FontName,256,fp); sscanf(X11FontName,"%s %s",str1,str2);
fgets(X11FontName,256,fp); sscanf(X11FontName,"%s %d",str1,&encode);
fgets(X11FontName,256,fp); sscanf(X11FontName,"%s %d %d",str1,&s1,&X11FontSize);
fgets(X11FontName,256,fp); sscanf(X11FontName,"%s %d %d",str1,&s1,&X11FontSize);
fgets(X11FontName,256,fp); sscanf(X11FontName,"%s %d %d %d %d",str1,&s1,&X11FontSize,&s3,&s4);
fgets(X11FontName,256,fp);
*(((UWORD*)fontloc)+encode*2) = (UWORD)(encode*(((width+7)>>3)<<3));
*(((UWORD*)fontloc)+encode*2+1) = (UWORD)(width);
for( l=0; l<height; l++ ){
int val;
char vstr[3];
vstr[2] = 0;
fgets(X11FontName,256,fp);
for( k=0; k<perline; k++ ){
vstr[0] = X11FontName[k*2];
vstr[1] = X11FontName[k*2+1];
sscanf(vstr,"%x",&val);
*(fontdata+l*perline*256+encode*perline+k) = (UBYTE)val;
}
}
fgets(X11FontName,256,fp);
}
fclose(fp);
return((Font)tfont);
}
static int bOnlyFixed=0;
XFontStruct *
XLoadQueryFont( Display *display,
char *name )
{
XFontStruct* xfont;
struct TextFont* tf;
boolean bGotData=False;
X11FontNode* fnode = NULL;
#ifdef DEBUGXEMUL_ENTRY
FunCount_Enter( XLOADQUERYFONT, bInformFonts );
#endif
if( !name )
return(NULL);
#if 0
if( strcmp(name,"fixed") ) {
char *c;
c=name;
while( !isdigit(*c) && *c ) c++;
if( isdigit(*c) ){
int nWidth,nHeight;
char ch;
sscanf(c,"%d%c%d",&nWidth,&ch,&nHeight);
if( nHeight<8 )
return NULL;
}
}
#endif
xfont = calloc(sizeof(XFontStruct),1);
if( !xfont )
X11resource_exit(FONTS2);
#if (MEMORYTRACKING!=0)
List_AddEntry(pMemoryList,(void*)xfont);
#endif
if( strcmp(name,"fixed") && !bOnlyFixed ){
int style = 0;
xfont->fid = XLoadFont(display,name);
if( !xfont->fid ){
#if (MEMORYTRACKING!=0)
List_RemoveEntry(pMemoryList,(void*)xfont);
#else
free(xfont);
#endif
return NULL;
}
if( strstr(name,"-i-") || strstr(name,"-o-") )
style = FSF_ITALIC;
if( strstr(name,"-bold-") )
style |= FSF_BOLD;
} else {
char str[10];
sprintf(str,"10x%d",DG.wb->RastPort.Font->tf_YSize);
xfont->fid=XLoadFont(display,str) ;
}
{
ListNode_t *pNode=X11FontList->pNext;
while( pNode!=NULL && pNode->pData!=NULL ){
fnode = (X11FontNode*)pNode->pData;
if( strcmp(fnode->zName,X11FontName)==0
&& fnode->vSize==X11FontSize ){
bGotData = True;
break;
}
List_GetNext(&pNode);
}
}
if( xfont->fid ){
int i;
tf = (struct TextFont *)((sFont*)xfont->fid)->tfont;
xfont->min_char_or_byte2 = tf->tf_LoChar;
xfont->max_char_or_byte2 = tf->tf_HiChar;
xfont->max_bounds.width = tf->tf_XSize;
xfont->max_bounds.ascent = tf->tf_Baseline;
xfont->max_bounds.descent = tf->tf_YSize-tf->tf_Baseline;
xfont->min_bounds.lbearing = 1;
xfont->min_bounds.rbearing = tf->tf_XSize-1;
xfont->min_bounds.width = tf->tf_XSize;
xfont->min_bounds.ascent = tf->tf_Baseline;
xfont->min_bounds.descent = tf->tf_YSize-tf->tf_Baseline-1;
xfont->ascent = xfont->max_bounds.ascent;
if( 1 ){
xfont->per_char = malloc((tf->tf_HiChar-tf->tf_LoChar)*sizeof(XCharStruct));
if( !xfont->per_char )
X11resource_exit(FONTS2);
#if (MEMORYTRACKING!=0)
List_AddEntry(pMemoryList,(void*)xfont->per_char);
#endif
for( i=0; i<(tf->tf_HiChar-tf->tf_LoChar); i++ ){
char c = i+tf->tf_LoChar;
xfont->per_char[i].width = XTextWidth(xfont,&c,1);
if( xfont->per_char[i].width>xfont->max_bounds.width )
xfont->max_bounds.width = xfont->per_char[i].width;
}
xfont->min_bounds.rbearing = xfont->max_bounds.width-1;
fnode = malloc(sizeof(X11FontNode));
if( !fnode )
X11resource_exit(FONTS8);
strcpy(fnode->zName,X11FontName);
fnode->vSize = X11FontSize;
fnode->pData = xfont->per_char;
List_AddEntry(X11FontList,(void*)fnode);
} else {
assert( fnode );
xfont->per_char = fnode->pData;
}
xfont->descent = xfont->max_bounds.descent;
#if (DEBUG!=0)
printf(" font info width %d ascent %d descent %d\n",xfont->max_bounds.width,xfont->max_bounds.ascent,xfont->max_bounds.descent);
#endif
return(xfont);
}
free(xfont);
return(NULL);
}
XmFontListCreate()
{
#if (DEBUGXEMUL_ENTRY) || (DEBUGXEMUL_WARNING)
printf("WARNING: XmFontListCreate\n");
#endif
return(0);
}
XFreeFont( Display* display,
XFontStruct* font_struct )
{
struct TextFont *f = (struct TextFont*)(((sFont*)font_struct->fid)->tfont);
#ifdef DEBUGXEMUL_ENTRY
FunCount_Enter( XFREEFONT, bInformFonts );
#endif
nFontAccess--;
if( !f ){
printf("error freeing font!\n");
exit(-1);
}
if( ((struct TextFont*)((sFont*)font_struct->fid)->tfont)->tf_Flags==42 ){
free(f->tf_CharData);
free(f->tf_CharLoc);
#if (MEMORYTRACKING!=0)
List_RemoveEntry(pMemoryList,(void*)f);
#else
free(f);
#endif
} else {
if( font_struct->fid!=DG.X11GC->values.font )
CloseFont((struct TextFont*)(((sFont*)font_struct->fid)->tfont));
#if (MEMORYTRACKING!=0)
List_RemoveEntry(pMemoryList,(void*)((sFont*)font_struct->fid)->tattr);
List_RemoveEntry(pMemoryList,(void*)font_struct->fid);
#else
free(((sFont*)font_struct->fid)->tattr);
free(font_struct->fid);
#endif
}
#if (MEMORYTRACKING!=0)
List_RemoveEntry(pMemoryList,(void*)font_struct->per_char);
List_RemoveEntry(pMemoryList,(void*)font_struct);
#else
free(font_struct->per_char);
free(font_struct);
#endif
#if 0
memset(font_struct,0, sizeof(XFontStruct) );
#endif
return(0);
}
//#if( DEBUG!=0 )
XSetFont( Display* display, GC gc, Font font )
{
#ifdef DEBUGXEMUL_ENTRY
FunCount_Enter( XSETFONT, bInformFonts );
#endif
gc->values.font = font;
return(0);
}
//#else
//#endif
int
XTextWidth( XFontStruct* font_struct,
char* string,
int count )
{
struct TextFont *tf;
int len = 0;
#ifdef DEBUGXEMUL_ENTRY
FunCount_Enter( XTEXTWIDTH , bInformFonts );
#endif
if( !count )
return 0;
tf = ((sFont*)font_struct->fid)->tfont;
#if 0
{
int i;
for( i=0; i<count; i++ ){
char *addr = (char*)tf->tf_CharLoc+(string[i]-32)*4;
len += (*(unsigned long*)addr)&0xff;
}
}
#else
SetFont( &FontRP, tf );
#if 0
len = TextLength( &FontRP, string, count );
#else
{
struct TextExtent te;
struct TextAttr *tattr = (struct TextAttr*)((sFont*)font_struct->fid)->tattr;
SetSoftStyle( &FontRP, tattr->ta_Style ^ tf->tf_Style,(FSF_BOLD|FSF_UNDERLINED|FSF_ITALIC));
TextExtent( &FontRP, string, count, &te );
/*
len = max(te.te_Extent.MaxX-te.te_Extent.MinX,te.te_Width);
*/
}
#endif
#endif
#ifdef DEBUGXEMUL_EXIT
FunCount_Leave( XTEXTWIDTH , bInformFonts );
#endif
return(len);
}
char **
XListFonts( Display* display,
char* pattern,
int maxnames,
int* actual_count_return )
{
#ifdef DEBUGXEMUL_ENTRY
FunCount_Enter( XLISTFONTS, bInformFonts );
#endif
*actual_count_return = X11fontmapped;
return(X11fontname);
}
XFontStruct *
XQueryFont( Display* display,
XID font_ID )
{
#if (DEBUGXEMUL_ENTRY) || (DEBUGXEMUL_WARNING)
printf("WARNING: XQueryFont\n");
#endif
return (XFontStruct*)NULL;
}
XTextExtents( XFontStruct* font_struct,
char* string,
int nchars,
int* direction_return,
int* font_ascent_return,
int* font_descent_return,
XCharStruct* overall )
{
#ifdef DEBUGXEMUL
FunCount_Enter( XTEXTEXTENTS , bInformFonts );
#endif
if( !nchars ){
overall->rbearing = 0;
overall->ascent = 0;
overall->descent = 0;
overall->lbearing = 0;
overall->width = 0;
return 0;
}
overall->rbearing = XTextWidth(font_struct,string,nchars);
overall->ascent = font_struct->max_bounds.ascent;
overall->descent = font_struct->max_bounds.descent;
overall->lbearing = font_struct->max_bounds.lbearing;
overall->width = overall->rbearing;
return(0);
}
