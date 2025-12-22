/* $VER: Stringclass V1.2 © by Matthias Meixner  */


#ifndef __STRINGCLASS
#define __STRINGCLASS

#include <stdlib.h>
#include <stdio.h>
#include <string.h>
#include <ctype.h>

class ostream;
class istream;

class String {

   struct shared {
      int strlen;
      int maxlen; // Maximale Länge ohne Nullbyte (d.h. reine Stringlänge !)
      int refcnt;
      char str[2];
   };


   static shared *AllocShared(int size) {
         shared *r;
         r=(shared *)new char[sizeof(shared)-1+size];

         r->refcnt=1;
         r->strlen=r->maxlen=size;
         return r;
   };
   static void FreeShared(shared *o) { if(--o->refcnt<=0) {delete[] (char *)o;}}

  // Schneller neue Strings zu erzeugen + weniger Speicher
   static shared NullString;

   shared *str;

   void Unique(); /* sicherstellen, daß str->refcnt=1 */

 public:

   /* Konstruktoren */

   String();
   String(char);
   String(const char *s);
   String(const unsigned char *s);
   String(const String &l);
   ~String();
   String &operator=(const String &string);


   /* modifizierende Funktionen */

   void SetLength(int);  // setzt Länge des Strings (auch für Speicherallokation geeignet)
   void Trim();      // entfernt führenden + abschließenden whitespace
   void Skip(int n); // überspringe n Zeichen
   void Trunc(int n); // hinten n Zeichen abschneiden
   String &operator+=(const String &string); // anhängen von einem String
   String &operator+=(char c);
   int ReadLn(FILE *); // String aus Datei lesen, ->Ret=Anzahl Zeichen, -1: Fehler
                       //  '\n' wird entfernt
   void Remove(int pos,int len=1);
   void Insert(int pos,const String &string);
   void Insert(int pos,char c,int repeat=1);
   void ToUpper(); // Wandelt String in Großschreibung
   void ToLower(); // Wandelt String in Kleinschreibung

   /* nicht modifizierende Funktionen */

   int Length() const {return str->strlen;}
   int Len() const {return str->strlen;}
   char *Str()  {return str->str;}
   const char *Str() const {return str->str;}
   operator char * () {return str->str;}
   operator unsigned char* () {return (unsigned char *)str->str;}
   operator const char * () const {return str->str;}
   operator const unsigned char* () const {return (unsigned char *)str->str;}

   String Uppercase() const;  // Uppercase-String erzeugen
   String Lowercase() const;  // Lowercase-String erzeugen
   String Left(int l) const;      // Left$
   String Right(int l) const;     // Right$
   String Mid(int s,int l) const; // Mid$

   int Index(char c,int start=0) const;
            //    {char *p=strchr(str->str+start,c);return p?int(p-str->str):-1;}
   int RIndex(char c,int start=-1) const;
            //    {char *p=strrchr(str->str,c);return p?int(p-str->str):-1;}
   int StrIndex(const String &s,int start=0) const;
            // int StrIndex(char *s,int start=0) const;
            //      {char *p=strstr(str->str+start,s);return p?int(p-str->str):-1;}

   int StrRIndex(const String &s,int start=-1) const;


   /* Zugriffsfunktion */
   char & operator[](int p);
   char operator[](int p) const;


   /* Friend functions */

   friend String operator+(const String &,const String &);
   friend ostream &operator<<(ostream &,const String &);
   friend istream &operator>>(istream &,String &);

   friend int operator==(const String &,const String &);
   friend int operator>(const String &,const String &);
   friend int operator<(const String &,const String &);
   friend int operator>=(const String &,const String &);
   friend int operator<=(const String &,const String &);
   friend int operator!=(const String &,const String &);

   friend int operator==(const String &,const char *);
   friend int operator>(const String &,const char *);
   friend int operator<(const String &,const char *);
   friend int operator>=(const String &,const char *);
   friend int operator<=(const String &,const char *);
   friend int operator!=(const String &,const char *);

   friend int operator==(const char *,const String &);
   friend int operator>(const char *,const String &);
   friend int operator<(const char *,const String &);
   friend int operator>=(const char *,const String &);
   friend int operator<=(const char *,const String &);
   friend int operator!=(const char *,const String &);
};

#endif
