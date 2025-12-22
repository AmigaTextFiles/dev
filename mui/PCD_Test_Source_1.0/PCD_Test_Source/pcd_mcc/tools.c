/* Tools*/

 #include <clib/alib_protos.h>
 #include <clib/graphics_protos.h>
 #include <clib/utility_protos.h>
 #include <clib/muimaster_protos.h>
 #include <proto/exec.h>
 #include <proto/dos.h>
 #include <clib/debug_protos.h>
 
 #include "structs.c"  


/*--------------------------------------*/

ULONG _strlen(char *in)
{
ULONG x = 0;

  while(in[x] != 0)
  {
  ++x;
  }

return x;
}

/*------------------------------------*/

void *memcpy(void *dst, const void *src, size_t len)
{
  CopyMem((APTR)src,(APTR)dst,len);
return dst;
}

/*----------------------------------------*/

size_t strlen ( const char * str )
{
  return _strlen((char*)str)-1;
}

/*-----------------------------------------*/

void *memset( char* ptr, int value, size_t num )
{
int i = 0;
  while(i < num)
  {
    ptr[i] = value;
  ++i;
  }

return ptr;
}

/*------------------------------------------*/

void* malloc (size_t size)
{
return AllocVec(size,MEMF_ANY | MEMF_CLEAR);
}

/*------------------------------------------*/

void free (void* ptr)
{
 FreeVec(ptr);
}

/*-------------------------------------------*/

void* calloc (size_t num, size_t size)
{
return AllocVec(num * size,MEMF_ANY | MEMF_CLEAR);
} 

/*-----------------------------------------------*/

double floor(double x)
{
return floor(x);
}

/*-----------------------------------------------*/

char *strcpy( char * destination, const char * source)
{
CopyMem((APTR)source,(APTR)destination,_strlen((char*)source));
return destination;
}

/*-----------------------------------------------*/

void* realloc(void* ptr, size_t size)
{

  if(ptr == NULL) return AllocVec(size,MEMF_ANY | MEMF_CLEAR);
  else return AllocAbs(size,ptr);
 
}

/*------------------------------------------------*/

char *strncpy( char * destination, const char * source, size_t num )
{
 CopyMem((APTR)source,(APTR)destination,num);  
return destination;
}

/*----------------------------------------------------*/

double sqrt(double x)
{
return sqrt(x);
}

/*----------------------------------------------*/

double cos (double x)
{
return cos(x);
}

/*--------------------------------------------*/

double sin(double x)
{
return sin(x);
}

/*--------------------------------------------*/

int memcmp( const void * ptr1, const void * ptr2, size_t num )
{
  return Strnicmp(ptr1,ptr2,num);
}

/*--------------------------------------------*/

void *memchr(const void * ptr,int value, size_t num)
{
char *x = (char*)ptr;
int i = 0;
   while(i < num)
   {
    if(x[0] == value) break;
    ++x;
    ++i;
    }

if( i == num) return NULL;
else return x;
}

/*------------------------------------------------*/



/*---------------------------------------------------*/

char *getenv(const char *name)
{
char *x =  (char*)AllocVec(500,MEMF_ANY | MEMF_CLEAR);

  if(GetVar(name, x, 450, GVB_GLOBAL_ONLY) == -1) return NULL;
  else return x;

}


/*-----------------------------------------------------*/

char *strchr(const char *s, int c)
{
char *x = (char*)s;

   while(x[0] != 0)
   {
    if(x[0] == c) break;
    ++x;
   }

if( x[0] == 0) return NULL;
else return x;

}

/*----------------------------------------------------*/

int strcmp( const char * str1, const char * str2)
{
  return Stricmp(str1,str2);
}

/*-----------------------------------------------------*/

char *strrchr(const char *s, int c)
{
char *x = (char*)s;
int size = _strlen((char*)s) - 1;
int i = size;
 x += size;

   while(i > 0)
   {
    if(x[0] == c) break;
    --x;
    --i;
   }

if( x[0] == 0) return NULL;
else return x;

}

/*----------------------------------------------------*/

int strcasecmp(const char *s1, const char *s2)
{
  return Stricmp(s1,s2);
}

/*--------------------------------------------------*/

int isspace(int c)
{

   if((c == ' ') || (c == '\t') || (c == '\n') || (c == '\v') || (c == '\f') || (c == '\r')) return 1;
   else return 0;

}

/*-------------------------------------------------------*/

int isdigit( int c )
{
  if((c >= 0x30) && (c <= 0x39)) return 1;
  else return 0;
}

/*---------------------------------------------------*/

int isalnum( int c )
{
  if(((c >= 0x30) && (c <= 0x39)) || ((c >= 0x41) && (c <= 0x5A)) || ((c >= 0x61) && (c <= 0x7A))) return 1;
  else return 0;

}

/*-----------------------------------------------------*/

void __eprintf (const char *format, const char *file, unsigned int line, const char *expression)
{
  KPrintF(format, file, line, expression);
}

/*-----------------------------------------------------*/

int __lshrdi3(int a, int b)
{
    return a >> b;
}

/*---------------------------------------*/

int __ashldi3(int u, int b)
{
	return u << b;
}

/*---------------------------------------*/

 unsigned int __udivsi3 (unsigned int a, unsigned int b)
 {
  if( b == 0) return a;
  else return 0 - a;
 }

/*---------------------------------------*/

 unsigned long __udivdi3 (unsigned long a, unsigned long b)
 {
  if( b == 0) return a;
  else return 0 - a;
 }
 
 /*----------------------------------------*/
 
 double log(double x)
 {
 return log(x);
 }
 
 /*----------------------------------------*/
 
 void *memmove(void *dst, const void *src, size_t len)
 {
   CopyMem((APTR)src,(APTR)dst,len);  
   return dst;
 }

 /*---------------------------------------------*/
 
 VOID VSPrintf(STRPTR buffer, STRPTR formatString, va_list varArgs)
{
	RawDoFmt(formatString,varArgs,(VOID (*)())"\x16\xC0\x4E\x75",buffer);
}

/*------------------------------------------------*/

int Sprintf(STRPTR buffer, STRPTR formatString, ...)
{
	va_list varArgs;

	va_start(varArgs,formatString);
	VSPrintf(buffer, formatString, varArgs);
	va_end(varArgs);
	return _strlen(buffer);
}

/*-----------------------------------------------*/

int tolower ( int c )
{
	return ToLower(c);
}	

/*-----------------------------------------------*/

int toupper ( int c )
{
	return ToUpper(c);
}

/*-------------------------------------------------*/

/*unsigned char switch_byte(unsigned char x)
{
  unsigned char z = 0;
	
	if((x & 1) == 1) z += 128;
	if((x & 2) == 2) z += 64;
	if((x & 4) == 4) z += 32;
	if((x & 8) == 8) z += 16;
	if((x & 16) == 16) z += 8;
	if((x & 32) == 32) z += 4;
    if((x & 64) == 64) z += 2;	
    if((x & 128) == 128) z += 1;
	
return z;	
}*/
