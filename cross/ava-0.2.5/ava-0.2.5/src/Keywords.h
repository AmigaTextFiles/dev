/* Keywords.h, Uros Platise, dec. 1998 */

#ifndef __Keywords
#define __Keywords

class TKeywords{
  enum TSize{S_Byte=1,S_Word=2,S_Long=4,A_BigEndian=8}; 
  static const char* help_keyformat;
  
  TSize getType();
  long GetSize(TSize type){return (long)(type & (S_Byte+S_Word+S_Long));}
  void outArg(TSize sizeType, long val);
  void ds();
  void dc();
  void cref();  
public:
  TKeywords(){}
  ~TKeywords(){}
  
  bool parse();	/* return true if keyword was found and parsed */
  void Translate(int keyNo);
  void Device();  
};

extern TKeywords keywords;

#endif

