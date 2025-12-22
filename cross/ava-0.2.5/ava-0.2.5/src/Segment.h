/* Segment.h, Uros Platise Dec 1998 */

#ifndef __Segment
#define __Segment

#include <vector>
#include "Global.h"

#define SEG_ROOT	0

#define SEG_NOTPLACED	-1
#define SEG_UNKNOWNSIZE	-1

#define SEG_MAXNAMELEN	32
#define SEG_LABELLEN	256
#define MAX_SEGMENTS	512

/* All symbols that are defined as extern and have no prototype in
   current source, should point to segment 0 due to incRef func. */
#define SEGNUMBER_UNDEFINED 0

struct TSegmentRec{  
  enum TFlags  {None=0,Removable=1,Abstract=2};
  enum TStatus {Ok=0,OutofRange=1,Collision=2,Removed=4};
  enum TMirror {NoMirror=0, NoCompression, RLE1};

  char name [SEG_MAXNAMELEN];           /* original name of the segment */
  int  mirrorSegNo;		 	/* mirror segment */
  
  char label [SEG_LABELLEN];            /* label used for PC */
  vector< TSegmentRec* > segRef;        /* childs */
  TSegmentRec* parent;			/* parent */  
  long size;                            /* maximum segment size */
  long PC;                              /* running counter and tmp size */
  long sumSize;                         /* size of this and all sub segs. */
  long abs;                             /* when placed, this value is set.*/
  TFlags flags;                         /* segment attributes */
  TStatus status;			/* segment status */
  TMirror mirrorType;			/* mirror segments may be compressed */
  int refCount;				/* number of used labels within
  					    segment */
  int align;				/* alignment (default to one byte) */
					    
  /* note: addr and size are assigned -1 value to inform linker
     that these two values are to be calculated! */  
  TSegmentRec(){clear();}
      
  void clear(){
    parent=NULL; flags=None; status=Ok;
    size=SEG_UNKNOWNSIZE; abs=SEG_NOTPLACED; mirrorType=NoMirror;    
    PC=sumSize=0;
    refCount=0;
    align=1;    
    name[0]=label[0]=0;     
  }
   
  /* sort refs by ABSOLUTE number */
  void sortRefs();
  inline long start(){return abs+PC;}
  inline long end(){return abs+sumSize;}
};
  
class TSegTable{
private:
  int CRef;
  struct TSegTableRec{
    int newNo;		/* new segment number */
    long rel;		/* relative offset per file per segment */
    TSegTableRec():newNo(0),rel(0){}
  };  
public:
  TSegTableRec seg[MAX_SEGMENTS];
  TSegTable(){};
  ~TSegTable(){};
  friend TPt<TSegTable>;
};
typedef TPt<TSegTable> PSegTable;
  
struct TSSRec{
  TSegmentRec* ref;
  long start,size;

  TSSRec():ref(NULL),start(0){}  
  TSSRec(long _size, TSegmentRec* _ref):ref(_ref),size(_size){}
  TSSRec(long _start, long _end):start(_start){size=_end-start;}

  inline long end(){return start+size;}
  inline bool operator<(const TSSRec& ssrec){return size<ssrec.size;}
};    
  
class TSegment{
private:
  typedef vector< TSegmentRec* >::const_iterator TsegRecCI;
  typedef vector< TSegmentRec* >::iterator TsegRecI;

  TSegmentRec segRec [MAX_SEGMENTS];  /* segment entries */
  int segUsageCnt;                    /* segment usage counter */
  TSegmentRec* cseg;		      /* current segment in use */
  bool fitted;
  bool errorActive;
  
  void close();			      /* close current segment */
  bool set(const char* name);         /* set new segment (ret: true if new)*/
  void setPrevious();		      /* trace back */
  void update(const TSegmentRec& tmpSeg);
  void checkOBSOLETE(const TSegmentRec& segTemplate);
  long parseValue();
  void parseSegment(bool mirror=false);
  void removeUnused();
  void findSum(TSegmentRec* segp, int level=0);    
                                      /* stores info in .sumSize record */
  void CalcMirrors();		      /* calculate mirror sizes */
  void fit(TSegmentRec* segp);
  void saveSegmentTree(TSegmentRec* p);
  void ReportSegmentTree(TSegmentRec* p, int level);
  void ReportOverall(TSegmentRec* p);
public:
  TSegment();
  ~TSegment(){}
  
  bool parse();				/* return true, if sth was done */  
  void fitter();
  void adjustSegments();
  void saveSegments();
  void loadSegments(int segNo);
  void Report();
  
  char* getPC(char* PC_str);		/* returns pointer to PC_str */
  bool isEnabled(int segNo);		/* ret: true if segment is enabled */
  bool isAbstract(int segNo);
    
  void incPC(long relative);  
  int getSegNo(){return cseg-segRec;}	/* returns current segment number */
  void incRef(int segNo, int rel=1){
    if (segNo==SEGNUMBER_UNDEFINED){return;}
    assert(segNo<segUsageCnt && segNo>=0);segRec[segNo].refCount+=rel;
    assert(segRec[segNo].refCount>=0);
  }
      
  char* TellBaseSegment(int segNo); /* returns base segment; imm. after root */
  int TellNoSegments();		    
  long  TellSize(int segNo){return segRec[segNo].PC;}
  long  TellAbsolute(int segNo){return segRec[segNo].abs;}
  char* TellSegmentName(int segNo);
  int   TellMirror(int segNo);
  int   TellAlign(int segNo);
};
extern TSegment segment;

#endif

