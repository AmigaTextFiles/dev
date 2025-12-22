/*
	Global.h
	
	Global Classes, Variables, Definitions ...
	Uros Platise, 1998
*/

#ifndef __Global
#define __Global

#include <stdio.h>
#include <assert.h>

/*
  Global Settings 
   * full path to main architecture file and 
   * default include directory
  AVA_BASE_LIB can be overriden externally.
*/
#ifndef AVA_LIB
#  define AVA_LIB		"/usr/local/uTools/ava"
#endif

/* 
   arch.inc is seeked in the AVA_BASE_LIB directory 
*/
#define AVA_ARCH		"arch.inc"
#define AVA_TARGET		"target.inc"
#define AVA_NULL_DEVICE		"/dev/null"

/* 
  Smart Pointer Class 
*/
template <class TRec>
class TPt{
private:
  TRec* Addr;
  void MkRef(){if (Addr!=NULL){Addr->CRef++;}}
  void UnRef(){if (Addr!=NULL){Addr->CRef--;if (Addr->CRef==0){delete Addr;}}}
public:
  TPt():Addr(NULL){}
  TPt(TRec* _Addr): Addr(_Addr){MkRef();}
  TPt(const TPt& Pt): Addr(Pt.Addr){MkRef();}
  ~TPt(){UnRef();}

  TPt& operator=(const TPt& Pt){
    if (this!=&Pt){UnRef(); Addr=Pt.Addr; MkRef();} return *this;}
  TPt& operator=(TRec* _Addr){
    if (Addr!=_Addr){UnRef();Addr=_Addr;MkRef();} return *this;}
  bool operator==(const TPt& Pt) const {return Addr==Pt.Addr;}

  TRec* operator->() const {assert(Addr!=NULL); return Addr;}
  TRec& operator*() const {assert(Addr!=NULL); return *Addr;}
  TRec& operator[](int RecN) const {assert(Addr!=NULL); return Addr[RecN];}
  TRec* operator()() const {return Addr;}
  
  /* think once more! */
  bool operator<(const TPt& Pt){return Addr < Pt.Addr;}
};

/* 
  Target - Architecture Virtual Class 
*/
class TArch {
public:
  virtual char* Device(char* buf)=0; /* tell device ID for obj... 
                                   (should be the same as in arch.inc) */
  virtual void IsSameDevice()=0;				   
  virtual int is_Arch()=0;	/* returns non-zero if current token is
                                   a part of architecture reserved words. */				   
  virtual void Parse()=0;	/* Parse assembler instructions */
  virtual void Translate(int instruction)=0;
  virtual ~TArch(){}
  TArch():CRef(0){}  
private:
  int CRef;
public:
  friend TPt<TArch>;
};

typedef TPt<TArch> PArch;
extern PArch archp;

/*
  Fixed Stack
  
  Vector realisation with STD:
    stack<bool, vector<bool> >
*/
template<class Container>
class TMicroStack{
private:
  Container* cp;
  long idx, _size;
public:
  TMicroStack(int fixed_length=128):idx(0){
    assert(fixed_length>=0); cp=new Container[_size=fixed_length];}
  ~TMicroStack(){delete[] cp;}
    
  inline void push(const Container& x){assert(idx<_size); cp[idx++]=x;}
  inline Container& pop(){assert(idx>0); return cp[--idx];}
  void clear(){idx=0;}
  Container operator[](int RecN) const {
    assert(RecN>=0&&RecN<_size);return cp[RecN];}
  
  inline long capacity(){return idx;}
  inline long size(){return idx;}
  inline bool empty(){return idx==0;}
  inline bool full(){return idx==_size;}
  inline Container& top(){assert(idx>0);return cp[idx-1];}
  inline Container& bottom(){assert(idx>0);return cp[0];}
  
  /* special non-standard functions */
  void rotateUp(){
    assert(idx>0);
    Container buf = cp[idx-1];
    for (int i=idx-1; i>0; i--){cp[i]=cp[i-1];}
    cp[0]=buf;
  }  
  void sort(){
    bool update=true;
    while(update==true){
      update=false; for(int i=0; i<(idx-1); i++){
        if (cp[i+1]<cp[i]){	  
	  Container buf=cp[i]; cp[i]=cp[i+1]; cp[i+1]=buf; update=true;}}}}
};

/* AVA General Information */
extern const char* version;

#endif

