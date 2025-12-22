//header
/* $VER: Stringclass V1.2 © by Matthias Meixner  */


// Teilweise wurden Funktionen zum Speichersparen mit #if0 ausgeklammert,
// da sie für MakeDepend nicht benötigt wurden

#include "stringclass.h"
#include <ctype.h>

#define MIN(x,y) ((x)<(y)?(x):(y))

//end
//auto
/* private: */

static int ToUpper(int c)
{
   if(c<0) c+=256;
   if('a'<=c && c<='z') return c+'A'-'a';
   if(224<=c && c<=254) return c+192-224;
   return c;
}

String::shared String::NullString={0,0,1,""};

void String::Unique()
{
   if(str->refcnt<=0) {
      fprintf(stderr,"Using already freed memory\n");
   }

   if(str->refcnt>1) {
      shared *str2=AllocShared(str->strlen);

      memcpy(str2->str,str->str,str->strlen+1);
      str->refcnt--;
      str=str2;
   }
}

/* Konstruktoren */


       // inline: String(int size)
String::String()
{
   NullString.refcnt++;
   str = &NullString;
}
String::String(char c)
{
   str = AllocShared(1);
   str->str[0]=c;
   str->str[1]=0;
}
String::String(const char *s)
{
   int l=strlen(s);
   if(l) {
      str = AllocShared(l);
      strcpy(str->str,s);
   } else { // Bei Länge Null auf NullString referenzieren
      NullString.refcnt++;
      str=&NullString;
   }
}
String::String(const unsigned char *s)
{

   int l=strlen((const char *)s);
   if(l) {
      str = AllocShared(l);
      strcpy(str->str,(const char *)s);
   } else { // Bei Länge Null auf NullString referenzieren
      NullString.refcnt++;
      str=&NullString;
   }
}
String::String(const String &l)
{
   l.str->refcnt++;
   str=l.str;
}
String::~String()
{
   FreeShared(str);
}
String &String::operator=(const String &l)
{
   l.str->refcnt++;
   FreeShared(str);
   str=l.str;
   return *this;
}

/* modifizierende Funktionen */
void String::SetLength(int size)
{
   if(size==0) {
      FreeShared(str);
      NullString.refcnt++;
      str=&NullString;
   } else if(str->refcnt==1 && size<=str->maxlen) {
      str->strlen=size;

      str->str[size]=0; // Nullbyte neu erzeugen (vor allen falls size<strlen)
   } else {

      shared *str2=AllocShared(size);

      memcpy(str2->str,str->str,str->strlen+1);
      str2->str[size]=0;
      str2->strlen=size;
      FreeShared(str);
      str=str2;
   }
}
void String::Trim()
{
   Unique();

   while(str->strlen && isspace(str->str[str->strlen-1]))
         str->str[--str->strlen]=0;

   const char *p=str->str;

   while(*p && isspace(*p)) {p++;str->strlen--;}
   if(p!=str->str) {

      memmove(str->str,p,str->strlen+1);
   }
}
void String::Skip(int n)
{
   Unique();

   if(n>=str->strlen) {
      str->strlen=0;
      str->str[0]=0;
   } else if(n>0) {
      str->strlen-=n;

      memmove(str->str,str->str+n,str->strlen+1);
   }
}
void String::Trunc(int n)
{
   Unique();

   if(n>str->strlen) {
      n=str->strlen;
   } else if(n<0) {
      n=0;
   }

   str->strlen-=n;
   str->str[str->strlen]=0;
}
String &String::operator+=(const String &string)
{
   if(str->refcnt==1 && str->strlen + string.str->strlen <= str->maxlen) {
      memmove(str->str+str->strlen, string.str->str, string.str->strlen+1);
      str->strlen+=string.str->strlen;
   } else {
      int len=str->strlen+string.str->strlen;

      len+=len>>2;
      len=(len+3) & ~3; /* vielfaches von 8 */

      shared *str2=AllocShared(len);
      memmove(str2->str,str->str,str->strlen);
      memmove(str2->str+str->strlen, string.str->str, string.str->strlen+1);
      str2->strlen = str->strlen + string.str->strlen;

      FreeShared(str);
      str=str2;
   }
   return *this;
}
String &String::operator+=(char c)
{
   if(str->refcnt==1 && str->strlen + 1 <= str->maxlen) {
      str->str[str->strlen]=c;
      str->str[str->strlen+1]=0;
      str->strlen++;
   } else {
      int len=str->strlen+1;

      len+=len>>2;
      len=(len+3) & ~3; /* vielfaches von 8 */

      shared *str2=AllocShared(len);
      memmove(str2->str,str->str,str->strlen);
      str2->str[str->strlen]=c;
      str2->str[str->strlen+1]=0;
      str2->strlen=str->strlen+1;

      FreeShared(str);
      str=str2;
   }
   return *this;
}

#if 0
void String::Remove(int pos,int len)
{
   Unique();

   if(pos<str->strlen) {
      if(len>str->strlen-pos) len=str->strlen-pos;

      str->strlen-=len;

      memmove(str->str+pos,str->str+pos+len,str->strlen-pos+1);
   }
}
void String::Insert(int pos,const String &string)
// String nach Position pos einfügen, oder am Zeilenende, falls pos>=strlen
{
   if(string.Length()<=0) return;

   // Achtung: Nullbyte muß erhalten bleiben

   if(pos<str->strlen) {
      if(str->refcnt==1 && str->strlen + string.str->strlen <= str->maxlen) {

         memmove(str->str+pos+string.str->strlen,str->str+pos,str->strlen-pos+1);
         memmove(str->str+pos, string.str->str, string.str->strlen);
         str->strlen+=string.str->strlen;

      } else {
         int len=str->strlen+string.str->strlen;
         len+=len>>2;
         len=(len+3) & ~3; /* vielfaches von 4 */

         shared *str2=AllocShared(len);
         memcpy(str2->str,str->str,pos);
         memcpy(str2->str+pos,string.str->str, string.str->strlen);
         memcpy(str2->str+pos+string.str->strlen,str->str+pos,str->strlen-pos+1);
         str2->strlen = str->strlen + string.str->strlen;

         FreeShared(str);
         str=str2;
      }
   } else {

#if 0
      if(str->refcnt==1 && str->strlen+string.str->strlen<=str->maxlen) {
         memcpy(str->str+str->strlen,string.str->str,string.str->strlen+1);
         str->strlen+=string.str->strlen;

      } else {
         int len=str->strlen+string.str->strlen;
         len+=len>>2;
         len=(len+3) & ~3; /* vielfaches von 4 */

         shared *str2=AllocShared(len);

         memcpy(str2->str, str->str, str->strlen);
         memcpy(str2->str+str->strlen, string.str->str, string.str->strlen+1);
         str2->strlen=str->strlen+string.str->strlen;

         FreeShared(str);
         str=str2;

      }
#endif


      *this+=string;


   }
}
void String::Insert(int pos,char c,int repeat)
// String nach Position pos einfügen, oder am Zeilenende, falls pos>=strlen
{

   if(repeat<=0) return;
   // Achtung: Nullbyte muß erhalten bleiben

   if(pos<str->strlen) {
      if(str->refcnt==1 && str->strlen + repeat <= str->maxlen) {
         memmove(str->str+pos+repeat,str->str+pos,str->strlen-pos+1);
         memset(str->str+pos, c, repeat);
         str->strlen+=repeat;

      } else {
         int len=str->strlen+repeat;
         len+=len>>2;
         len=(len+3) & ~3; /* vielfaches von 4 */

         shared *str2=AllocShared(len);
         memcpy(str2->str,str->str,pos);
         memset(str2->str+pos, c, repeat);
         memcpy(str2->str+pos+repeat,str->str+pos,str->strlen-pos+1);
         str2->strlen = str->strlen + repeat;

         FreeShared(str);
         str=str2;
      }
   } else {
      int l=str->strlen;

      SetLength(Length()+repeat);
      while(repeat--) str->str[l++]=c;

   }
}
#endif

int String::ReadLn(FILE *fp)
/*
 * Liefert durch '\n' oder EOF begrenzte Zeile
 *
 * falls vorherige Zeile durch '\n' begrenzt war, so wird mindestens noch
 * eine Zeile zurueckgeliefert.
 * war eine Zeile durch EOF begrenzt, so ist beim nächsten ReadLn
 * feof(fp)=TRUE gesetzt und es wird -1 zurückgeliefert
 *
 * Ist das letzte Zeichen einer Datei ein '\n', so wird am Schluß eine
 * Leerzeile zurückgeliefert, ansonsten eine Zeile mit den verbleibenden
 * Zeichen
 */
{

   SetLength(0);  // Speicher freigeben (hat ausserdem den Effekt von Unique()

   if(feof(fp)) return -1;

   int c;

   int maxlen=16,len=0;

   SetLength(maxlen);


   while((c=getc(fp))!=EOF && c!='\n') {

      if(len>=maxlen) {
         maxlen<<=1;
         SetLength(maxlen);
      }

      str->str[len++]=(char)c;
   }

   SetLength(len);

   return(len);
}

#if 0
void String::ToUpper()
{
   Unique();

   char *p=str->str;
   int l=str->strlen;

   while(l--) {*p=(char)::ToUpper(*p);p++;}
}
void String::ToLower()
{
   Unique();

   char *p=str->str;
   int l=str->strlen;

   while(l--) {*p=(char)tolower(*p);p++;}
}

/* nicht modifizierende Funktionen */
      // inline: int Length()
      // inline: char *Str()

String String::Uppercase() const
{
   String other=*this;

   other.Unique();

   for(int a=0;a<str->strlen;a++) other.str->str[a]=(char)::ToUpper(other.str->str[a]);
   return(other);
}
String String::Lowercase() const

{
   String other=*this;

   other.Unique();

   for(int a=0;a<str->strlen;a++) other.str->str[a]=(char)tolower(other.str->str[a]);
   return(other);
}
#endif

String String::Left(int l) const
{
   String s2=*this;

   if(s2.str->strlen>l) {
      s2.Trunc(s2.str->strlen-l);
   }
   return(s2);
}
String String::Right(int l) const
{
   String other=*this;

   int n=str->strlen-l;

   if(n>0) other.Skip(n);

   return other;
}
String String::Mid(int s,int l) const
{
   String other=*this;

   other.Skip(s);
   if(other.str->strlen > l) {
      other.Trunc(other.str->strlen-l);
   }

   return other;
}

int String::Index(char c,int start) const
{
   int l;

   for(l=start;l<str->strlen;l++) if(str->str[l]==c) break;

   if(l>=str->strlen) return -1;
   return l;
}
int String::StrIndex(const String &s,int start) const
{
   int l;

   for(l=start;l<=str->strlen-s.str->strlen;l++) {
      if(!memcmp(str->str+l,s.str->str,s.str->strlen)) break;
   }

   if(l>str->strlen-s.str->strlen) return -1;
   return l;
}
int String::RIndex(char c,int start) const // Startet Suche rückwärts ab s[start]
// negative Werte von Start geben die Position relativ zum Stringende an
{
   int l;

   if(start<0) start+=str->strlen;

   for(l=start;l>=0;l--) if(str->str[l]==c) break;

   if(l<0) return -1;
   return l;
}

#if 0
int String::StrRIndex(const String &s,int start) const // Startet Suche rückwärts ab s[start]
// negative Werte von start geben die Position relativ zum Stringende an
{
   int l;

   if(start<0) start+=str->strlen;
   if(start+s.str->strlen>str->strlen) start=str->strlen-s.str->strlen;

   for(l=start;l>=0;l--) {
      if(!memcmp(str->str+l,s.str->str,s.str->strlen)) break;
   }

   if(l<0) return -1;
   return l;
}
#endif

/* Zugriffsfunktion */

char & String::operator[](int p)
{
   static char dummy=0;
   if(p<0 || p>=str->strlen) {
      dummy=0;
      return dummy;
   }

   Unique();
   return str->str[p];
}
char String::operator[](int p) const
{
   if(p<0 || p>=str->strlen) return 0;

   return str->str[p];
}

/* Friend functions */
String operator+(const String &string1,const String &string2)
{
   String r=string1;

   r+=string2;

   return r;
}


int operator==(const String &s1,const String &s2)
{
   if(s1.str->strlen!=s2.str->strlen) return 0;
   return memcmp(s1.str->str,s2.str->str,s1.str->strlen)==0;
}
#if 0
int operator>(const String &s1,const String &s2)
{
   return memcmp(s1.str->str,s2.str->str,MIN(s1.str->strlen,s2.str->strlen)+1)>0;
}
int operator<(const String &s1,const String &s2)
{
   return memcmp(s1.str->str,s2.str->str,MIN(s1.str->strlen,s2.str->strlen)+1)<0;
}
int operator>=(const String &s1,const String &s2)
{
   return memcmp(s1.str->str,s2.str->str,MIN(s1.str->strlen,s2.str->strlen)+1)>=0;
}
int operator<=(const String &s1,const String &s2)
{
   return memcmp(s1.str->str,s2.str->str,MIN(s1.str->strlen,s2.str->strlen)+1)<=0;
}
#endif
int operator!=(const String &s1,const String &s2)
{
   if(s1.str->strlen!=s2.str->strlen) return 1;
   return memcmp(s1.str->str,s2.str->str,s1.str->strlen)!=0;
}

int operator==(const String &s1,const char *s2)
{
   int l=strlen(s2);
   if(l!=s1.str->strlen) return 0;
   return memcmp(s1.str->str,s2,l)==0;
}
#if 0
int operator>(const String &s1,const char *s2)
{
   int l=strlen(s2);
   return memcmp(s1.str->str,s2,MIN(s1.str->strlen,l)+1)>0;
}
int operator<(const String &s1,const char *s2)
{
   int l=strlen(s2);
   return memcmp(s1.str->str,s2,MIN(s1.str->strlen,l)+1)<0;
}
int operator>=(const String &s1,const char *s2)
{
   int l=strlen(s2);
   return memcmp(s1.str->str,s2,MIN(s1.str->strlen,l)+1)>=0;
}
int operator<=(const String &s1,const char *s2)
{
   int l=strlen(s2);
   return memcmp(s1.str->str,s2,MIN(s1.str->strlen,l)+1)<=0;
}
#endif
int operator!=(const String &s1,const char *s2)
{
   int l=strlen(s2);
   if(l!=s1.str->strlen) return 1;
   return memcmp(s1.str->str,s2,l)!=0;
}


int operator==(const char *s1,const String &s2)
{
   int l=strlen(s1);
   if(l!=s2.str->strlen) return 0;
   return memcmp(s1,s2.str->str,l)==0;
}
#if 0
int operator>(const char *s1,const String &s2)
{
   int l=strlen(s1);
   return memcmp(s1,s2.str->str,MIN(l,s2.str->strlen)+1)>0;
}
int operator<(const char *s1,const String &s2)
{
   int l=strlen(s1);
   return memcmp(s1,s2.str->str,MIN(l,s2.str->strlen)+1)<0;
}
int operator>=(const char *s1,const String &s2)
{
   int l=strlen(s1);
   return memcmp(s1,s2.str->str,MIN(l,s2.str->strlen)+1)>=0;
}
int operator<=(const char *s1,const String &s2)
{
   int l=strlen(s1);
   return memcmp(s1,s2.str->str,MIN(l,s2.str->strlen)+1)<=0;
}
#endif
int operator!=(const char *s1,const String &s2)
{
   int l=strlen(s1);
   if(l!=s2.str->strlen) return 1;
   return memcmp(s1,s2.str->str,l)!=0;
}



#define NO_IOSTREAM
#ifndef NO_IOSTREAM
//header
#include <iostream.h>
//end

ostream &operator<<(ostream &s,const String &string)
{
   return s<<string.str->str;
}
istream &operator>>(istream &s,String &string)
{
   String::FreeShared(string.str);

   int maxlen=16;
   int last=0;
   int done;

   String::shared *str=String::AllocShared(maxlen);

   do {
      done=1;

      s.get(str->str + last,maxlen-last+1);

      char c;

      s.get(c);

      if(c!='\n' && s.good()) {
         s.putback(c);
         done=0;

         last=maxlen;
         maxlen<<=1;

         String::shared *str2=String::AllocShared(maxlen);

         memmove(str2->str,str->str,last+1);

         str->refcnt=0;
         String::FreeShared(str);
         str=str2;
      }
   } while(!done);

   string.str=str;

   string.str->strlen=(int)strlen(str->str);

   if(string.str->strlen>0 && string.str->str[string.str->strlen-1]=='\n')
      string.str->str[--string.str->strlen]=0;

   return(s);
}
#endif
