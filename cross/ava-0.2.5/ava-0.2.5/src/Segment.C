/*
  Segment.C
  Uros Platise, Dec 1998
  
  Even more powerful segments are provided that in earilier uAsm.
  Any segment can now also be ref. as abstract segment or removable.
  
  * Abstract segments are those which are not put into executable file.
  
  * Removable segments allow additional feature on optimizing the size
    of the executable file. If there is no call to removable segment,
    it is simply removed.
*/

#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include "Global.h"
#include "Lexer.h"
#include "Symbol.h"
#include "Object.h"
#include "Segment.h"
#include "Reports.h"

TSegment::TSegment():segUsageCnt(1),fitted(false),errorActive(false){close();}
void TSegment::close(){cseg=&segRec[SEG_ROOT];}

/* return true on creation */
bool TSegment::set(const char* name){
  TsegRecCI refidx;
  TSegmentRec* cseg_bck=cseg;
  /* find segment within refs ... */
  for (refidx=cseg->segRef.begin();refidx!=cseg->segRef.end(); refidx++){
    if (strcmp(name,(*refidx)->name)==0){
      cseg=*refidx;
#ifdef DEBUG      
      reports.Info(TReports::VL_SEG4,"set=%s\n",cseg->name);
#endif      
      return false;
    }
  }
  if (refidx==cseg->segRef.end()){
    /* create child */
    cseg->segRef.push_back(&segRec[segUsageCnt]);
    cseg = &segRec[segUsageCnt++];
    cseg->parent = cseg_bck;
    
    /* If parent is removable, child is also removable and so abstract */
    cseg->flags |= cseg_bck->flags;
    strcpy(cseg->name,name);	/* assign name */
    strcat(cseg->label,cseg_bck->label);
    strcat(cseg->label,"_");strcat(cseg->label,name);
    
    /* if parent alignment size differs and our is not 1 report error.
       Otherwise if our is 1, take parents one */
    if (cseg->align==1){cseg->align=cseg_bck->align;}
    else if (cseg->align < cseg_bck->align){
      throw syntax_error("Align size missmatch with parent for: ",
        cseg->name);
    }    
    /* create external symbol (to satisfy macro check) */
    symbol.addInternalLabel(cseg->label);
  }
  return true;
}

void TSegment::setPrevious(){assert(cseg->parent!=NULL); cseg=cseg->parent;}

/* Update current segment attributes, size and abs */
void TSegment::update(const TSegmentRec& tmpSeg){
  /* if current size is bigger than new one, error! */
  /*
  if (cseg->size!=-1 && tmpSeg.size!=-1 && cseg->size > tmpSeg.size){  
    reports.Warnning("Segment `%s': previous size: $%lx  new size: $%lx",
      cseg->name, cseg->size, tmpSeg.size);
    throw syntax_error("Segment size already declared for: ",cseg->name);
  }
  */

  if (cseg->size < tmpSeg.size){cseg->size=tmpSeg.size;}
  
  cseg->PC += tmpSeg.PC;	  /* add current PC */
  
  /* absolute address */
  if (cseg->abs!=-1 && tmpSeg.abs!=-1 && cseg->abs!=tmpSeg.abs){
    throw syntax_error("Absolute address already declared for: ",cseg->name);}
  if (tmpSeg.abs!=-1){cseg->abs=tmpSeg.abs;}

  /* if stored segment is not yet abstract and segTmp is, make cseg too */
  cseg->flags |= tmpSeg.flags & TSegmentRec::Abstract;
  
  /* if stored segment is removable but this one is not, clear removable flag*/
  cseg->flags &= (0xff-TSegmentRec::Removable) |
    (tmpSeg.flags & TSegmentRec::Removable);  
  
  /* check align size - error only if new differs from 1 */
  if (cseg->align!=tmpSeg.align && tmpSeg.align>1){
    printf("cseg=%d, tmp=%d\n", cseg->align, tmpSeg.align);
    throw syntax_error("Align size missmatch for segment: ", cseg->name);
  }    
  /* mirror redeclaration check if and only if tmpSeg is not existing segment */
  if (cseg != &tmpSeg && cseg->mirrorType && tmpSeg.mirrorType){
    throw syntax_error("Mirror segment was already declared for: ",
      cseg->name);
  }
}

/*
  OBSOLETE FUNCTION --- TO BE REMOVED
*/
#ifdef CHECK_OBSOLTE
void TSegment::checkOBSOLETE(const TSegmentRec& segTemplate){
  /* if stored segment is not yet abstract and segTmp is, make cseg too */
  cseg->flags |= segTemplate.flags & TSegmentRec::Abstract;
  
  /* if stored segment is removable but this one is not, clear removable flag*/
  cseg->flags &= (0xff-TSegmentRec::Removable) |
    (segTemplate.flags & TSegmentRec::Removable);
		 
  /* Compare other attributes as size and abs */
  if (segTemplate.abs!=-1){
    if (cseg->abs==-1){cseg->abs=segTemplate.abs;}
    else if (cseg->abs!=segTemplate.abs){
      throw segment_error("Segment absolute address missmatch.");}
  }
  if (segTemplate.size!=-1){
    if (cseg->size==-1){cseg->size=segTemplate.size;}
    else if (cseg->size!=segTemplate.size){
      throw segment_error("Segment size missmatch.");}
  }
}
#endif

/*
  New segment is build upon segRec[segUsageCnt] what was suggested
  by the set function.
*/
bool TSegment::parse(){  
  TSegmentRec& segTemplate = segRec[segUsageCnt];  
  segTemplate.clear();
    
  if (segUsageCnt==MAX_SEGMENTS){
    throw generic_error("Maximum number of segments is reached.\n"
                        "Increase MAX_SEGMENTS variable in Segment.h file.");
  }  
  if (strcmp(lxP->string,"seg")!=0){return false;}
  /* parse flags */
  WHILE_TOKEN{
    if (lxP->type!=TlxData::STRING){
      throw syntax_error("Bad format",lxP->string);}
            
    if (strcmp(lxP->string,"removable")==0){
      segTemplate.flags|=TSegmentRec::Removable;}
    else if (strcmp(lxP->string,"abstract")==0){
      segTemplate.flags|=TSegmentRec::Abstract;}
    else if (strcmp(lxP->string,"abs")==0){segTemplate.abs=parseValue();}
    else if (strcmp(lxP->string,"size")==0){segTemplate.size=parseValue();}
    else if (strcmp(lxP->string,"align")==0){segTemplate.align=parseValue();}
    else if (strcmp(lxP->string,"mirror")==0){
      GET_TOKEN;
      if (strcmp(lxP->string,"=")){
        throw syntax_error("Bad format at ",lxP->string);}
      parseSegment(true);      
      segTemplate.mirrorType = TSegmentRec::NoCompression;
      segTemplate.mirrorSegNo = getSegNo();
    }
    else{break;}
  }
  PUT_TOKENBACK;
  
  /* parse segment name with its segTemplate */
  parseSegment();
  update(segTemplate);
  
  char buf [SEG_LABELLEN];  
  object.outSegment(cseg-segRec);
  object.outPCMarker(getPC(buf));  
  return true;
}

long TSegment::parseValue(){
  /* expecting = */
  GET_TOKEN;
  if (strcmp(lxP->string,"=")){
    throw syntax_error("Bad format at ",lxP->string);}
  GET_TOKEN;
  if (lxP->type!=TlxData::LVAL){
    throw syntax_error("Value expected at ",lxP->string);}
  return lxP->lval;
}

void TSegment::parseSegment(bool mirror=false){  
  close();			/* go to root first */
  do{
    lexer._gettoken();
    if (lxP->type!=TlxData::STRING){
      throw syntax_error("Segment line without segment name.");}
    bool newSeg = set(lxP->string);
    if (mirror && newSeg){
      throw segment_error("Mirror segment is not declared yet: ",lxP->string);}
    GET_TOKEN;	/* get delimiter - full stop, which seperates segments ... */
  }while(lxP->type==TlxData::CONTROL && lxP->string[0]=='.');  
  PUT_TOKENBACK;
}

/* 
  It returns current program counter relative to segment
*/
char* TSegment::getPC(char* PC_str){
  if (cseg==NULL || cseg==segRec)
    {throw segment_error("Code is present out of segment.");}
  sprintf(PC_str,"(%s+$%lx)",cseg->label,cseg->PC);
  /* increase segment reference count */
  return PC_str;
}

void TSegment::incPC(long relative){
  if (cseg==NULL || cseg==segRec){
    throw segment_error("Code is present out of segment.");}
  cseg->PC+=relative;
  if (cseg->size!=-1 && cseg->PC > cseg->size){
    throw segment_error("Segment full: ",cseg->name);}  
}

void TSegment::removeUnused(){
  for (int si=1;si<segUsageCnt;si++){
    if (segRec[si].refCount==0 && segRec[si].flags==TSegmentRec::Removable){
      segRec[si].status|=TSegmentRec::Removed;
      symbol.undefine(segRec[si].label);}}
}

bool TSegment::isEnabled(int segNo){
  return !(segRec[segNo].status & TSegmentRec::Removed);
}

bool TSegment::isAbstract(int segNo){
  return (segRec[segNo].flags & TSegmentRec::Abstract);
}


/* FITTER and its FACILITIES */

/* segment own size plus size of all childs
   check for badly removed segments! 
   level=0 (ROOT_SEG), level=1 (BASE_SEGMENTS), level=2 (CHILDS of BASE_SEG)
*/
void TSegment::findSum(TSegmentRec* segp, int level=0){
#ifdef DEBUG
  reports.Info(TReports::VL_SEG4,"findSum()\n");
#endif  

  if (segp->status & TSegmentRec::Removed){segp->sumSize=0;return;}
  
  /* For all childs flash.ch1, flash.ch2, ... do the following:
     if segment is fixed size, add ->size parameter otherwise PC */
  if (segp->size!=SEG_UNKNOWNSIZE && level>=2){
    segp->sumSize+=segp->size;}else{segp->sumSize += segp->PC;}  
  
  TsegRecCI segRecCI;
  for (segRecCI=segp->segRef.begin();segRecCI!=segp->segRef.end();segRecCI++){
    findSum(*segRecCI, level+1); segp->sumSize += (*segRecCI)->sumSize;}

  /* align size */
  int alignBytes = segp->sumSize % segp->align;
  if (alignBytes>0){
    alignBytes = segp->align - alignBytes;
    reports.Info(TReports::VL_SEG1,
      "Extending segment `%s' for %d extra byte(s) to align it.\n",
      segp->name, alignBytes);
    segp->sumSize += alignBytes;
    if (segp->size != SEG_UNKNOWNSIZE){
      throw segment_error("Cannot resize fixed size segment: ",
        segp->name);
    }
  }           
  
  /* if segment's maximum size is not defined, let's define it */
  if (segp->size==SEG_UNKNOWNSIZE){segp->size=segp->sumSize;}   
        
  /* check range */
  if (segp->sumSize > segp->size){
    segp->status |= TSegmentRec::OutofRange;errorActive=true;
    reports.Info(TReports::VL_ALL,"Not enough space for `%s': "
      "req=%ld avail=%ld bytes\n",
      segp->name, segp->sumSize, segp->size);
  }
#ifdef DEBUG
  reports.Info(TReports::VL_SEG4," %s: sum = %ld, size= %ld\n", 
    segp->name, segp->sumSize, segp->size);
#endif    
}

/*
  Before calling findsum function, mirror segment must
  be declared.
*/
void TSegment::CalcMirrors(){
  /* set mirrors */
  for (int i=0; i < segUsageCnt; i++){
    if (segRec[i].mirrorType & TSegmentRec::NoCompression){
      /* get new segment number and set PC */
      segRec[i].mirrorSegNo = 
        preproc.csrc->segP->seg[segRec[i].mirrorSegNo].newNo;
      segRec[segRec[i].mirrorSegNo].PC = segRec[i].PC;
    }
    if (segRec[i].mirrorType & TSegmentRec::RLE1){
      throw generic_error("RLE1 is not supported yet.\n");}
  }
}

/* Segment Child Sort Function

   - Abstract segments are pushed after non-Abstract segs.
   - and higher absolute value to the bottom
*/
#define RFS_FUNC(abs, ntype, type)	((!(ntype) & (abs)) | (type))

void TSegmentRec::sortRefs(){
  vector< TSegmentRec* >::iterator ri;
  bool update=true;
  bool ntype;
  while(update==true){
    update=false; 
    for (ri=segRef.begin(); (ri+1) < segRef.end(); ri++){
    
      ntype = ((*ri)->flags&TSegmentRec::Abstract) <
	            ((*(ri+1))->flags&TSegmentRec::Abstract);
/*		    
      printf("%s,%lx,%d / %s,%lx,%d  (ntype=%d)\n", 
        (*ri)->name, (*ri)->abs, (*ri)->flags, 
	(*(ri+1))->name, (*(ri+1))->abs, (*(ri+1))->flags, ntype);
*/	
      if (RFS_FUNC( (*ri)->abs > ((*(ri+1))->abs),
      		    ntype,
      		    ((*ri)->flags&TSegmentRec::Abstract) >
	            ((*(ri+1))->flags&TSegmentRec::Abstract) )){
        update=true; TSegmentRec* buf=*ri; *ri=*(ri+1); *(ri+1)=buf;
//	printf("swap\n");
      }
    }
  }
}

void TSegment::fit(TSegmentRec* segp){
  /* if removed, skip it! */
  if (segp->status & TSegmentRec::Removed){return;}
#ifdef DEBUG
  reports.Info(TReports::VL_SEG4,"\nfitting `%s'\n", segp->name);
#endif  
  TMicroStack<TSSRec> notPlaced(segp->segRef.size());
  TMicroStack<TSSRec> freeArea(segp->segRef.size()+1);
  TsegRecI sgci;
  
  /* sort already fixed segments by its absolute address */  
  segp->sortRefs();
 
  /* get starting address */
  long stAddr, stEnd;
  if (segp->abs==SEG_NOTPLACED){
    throw syntax_error("Absolute address of the base segment not defined: ",
      segp->name);}
  stAddr = segp->start();
  
  /* get free area and fixed (already placed) segments
     Since refs are sorted by abs, not placed segments will come first */
  for(sgci=segp->segRef.begin(); sgci != segp->segRef.end(); sgci++){  
    if ((*sgci)->abs==SEG_NOTPLACED){
    
      if (!((*sgci)->status & TSegmentRec::Removed)){      
        /* remove zero bytes segments and set their offset to the end
	   of the parent code */
	if ((*sgci)->sumSize==0){
	  (*sgci)->abs = stAddr;
	} else {
          notPlaced.push(TSSRec((*sgci)->sumSize,*sgci));	 
	}
      }
    }	
    else{
      stEnd = (*sgci)->abs;
      if ((stEnd-stAddr) > 0){freeArea.push(TSSRec(stAddr,stEnd));}
      else if ((stEnd-stAddr)<0){
        (*sgci)->status |= TSegmentRec::Collision;errorActive=true;}
      stAddr = (*sgci)->end();
      if ((segp->size-stAddr)<0){
        (*sgci)->status |= TSegmentRec::OutofRange;errorActive=true;}
    }
  }  
  /* add free tail */  
  stEnd = segp->abs + segp->size;
  if ((stEnd-stAddr) > 0){freeArea.push(TSSRec(stAddr,stEnd));}

#ifdef DEBUG    
  /* print free space */
  for(int i=0;i<freeArea.size();i++){
    reports.Info(TReports::VL_SEG4,"free: [$%lx,$%lx]\n",
      freeArea[i].start,freeArea[i].end());
  }      
#endif     
  
  /* fit floating segments - bigger to bigger holes in the front */
  notPlaced.sort();
  TSSRec *freeSeg, *npSeg;	/* ref to: free and notplaced segment */
  while(notPlaced.size()>0){  
    freeArea.sort();
    if (freeArea.size()==0){
      errorActive=true;
      while(notPlaced.size()>0){
        notPlaced.top().ref->status|=TSegmentRec::OutofRange;notPlaced.pop();}
      break;
    }
    freeSeg = &freeArea.top(); npSeg = &notPlaced.top();
        
    /* take top one and put into top free space -
       if operation fails, mark all remaining segments OutofRange */
#ifdef DEBUG       
    reports.Info(TReports::VL_SEG4,"alloc: [$%lx,$%lx] $%lx, $%lx\n", 
      freeSeg->start,freeSeg->end(),freeSeg->size, npSeg->size);
#endif      
    if (freeSeg->size < npSeg->size){
      errorActive=true;
      while(notPlaced.size()>0){
        notPlaced.top().ref->status|=TSegmentRec::OutofRange;notPlaced.pop();}
    }else{
#ifdef DEBUG    
      reports.Info(TReports::VL_SEG4,"setting seg: `%s' with size = $%lx\n", 
                   npSeg->ref->name, npSeg->ref->sumSize);
#endif		   
      npSeg->ref->abs = freeSeg->start;
      freeSeg->start += npSeg->ref->sumSize;
      freeSeg->size  -= npSeg->ref->sumSize; /*decrease size of the free area*/
      notPlaced.pop();
    }
  }  
  /* Fit all childs too */
  for(sgci=segp->segRef.begin();sgci!=segp->segRef.end();sgci++){fit(*sgci);}
}

void TSegment::fitter(){
  removeUnused();
  CalcMirrors();
  findSum(segRec);
  if (!errorActive){
    /* fit every sub-segment of the root segment separately */
    TsegRecCI segRecCI=segRec[SEG_ROOT].segRef.begin();
    for (;segRecCI!=segRec[SEG_ROOT].segRef.end(); segRecCI++){fit(*segRecCI);}
    fitted=true;
  }
  Report();
  if (errorActive==true){
    throw generic_error("Cannot fit all segments."
      " See segment tree for details.");
  }
}

/* Adjust Segment Labels to Current File */
void TSegment::adjustSegments(){
  char labelValue [LX_STRLEN];
  for (int si=1; si<segUsageCnt; si++){
    if (segRec[si].status & TSegmentRec::Removed){continue;}
    sprintf(labelValue,"$%lx",segRec[si].abs+preproc.csrc->segP->seg[si].rel);
    symbol.modifyValue(segRec[si].label, labelValue);
  }
}


#define SAVE_NONE	0
#define SAVE_ROOTINFO	1
#define SAVE_GOBACK	2

void TSegment::saveSegments(){
  if (cseg==NULL){
    reports.Warnning(TReports::Segments,"File does not contain program code.");
    return;
  }
  saveSegmentTree(&segRec[SEG_ROOT]);
} 

void TSegment::saveSegmentTree(TSegmentRec* p){
  if (p!=segRec){
    
    object.outOperand(p->PC);
    object.outOperand(p->size);
    object.outOperand(p->abs);
    object.outOperand(p->flags);
    object.outOperand(p->mirrorType);
    object.outOperand(p->mirrorSegNo);
    object.outOperand(p->align);
    object.outOperand(p-segRec); 		/* report segment number! */
    object.outStringOperand(p->name);;
    object.outSegmentData(SAVE_ROOTINFO);	/* root information */
  }
  TsegRecCI segRecCI;
  for (segRecCI=p->segRef.begin(); segRecCI != p->segRef.end(); segRecCI++){
    if (!((*segRecCI)->status & TSegmentRec::Removed)){
      saveSegmentTree(*segRecCI);}}
  if (p!=segRec){object.outSegmentData(SAVE_GOBACK);}	/* one back ... */
}

void TSegment::loadSegments(int segNo){
  TSegmentRec& segTemplate = segRec[segUsageCnt];
  if (segNo==SAVE_GOBACK){setPrevious();return;}
  if (segNo!=SAVE_ROOTINFO){
    throw syntax_error("Invalid segment direction. Object file corrupted.");}  

  int objSegNo            =      object.popOperand();
  segTemplate.align       = (int)object.popOperand();
  segTemplate.mirrorSegNo = (int)object.popOperand();
  segTemplate.mirrorType  = (int)object.popOperand();
  segTemplate.flags       = (int)object.popOperand();
  segTemplate.abs         =      object.popOperand();
  segTemplate.size        =      object.popOperand();
  segTemplate.PC          =      object.popOperand();
  
  if (set(object.popStringOperand())==false){
    preproc.csrc->segP->seg[cseg-segRec].rel = cseg->PC;
    update(segTemplate);
  }
  preproc.csrc->segP->seg[objSegNo].newNo = cseg-segRec;
/* 
  printf("`%s' PC=$%lx, nN=%d, cPx=%d, mirror=%d\n", cseg->name, 
    preproc.csrc->segP->seg[objSegNo].rel,
    preproc.csrc->segP->seg[objSegNo].newNo,
    segTemplate.mirrorType, segTemplate.mirrorSegNo);
*/
}

void TSegment::Report(){
  /* Print Segment Tree */
  reports.Info(TReports::VL_SEG1, "\n%-30.30s   %8.8s   %8.8s %8.8s\n", 
    "SEGMENT TREE:", "ABS", "SIZE", "FLAGS");
  ReportSegmentTree(segRec,0);
  reports.Info(TReports::VL_SEG1, "\n");
  
  /* Overall Segment Information */
  if (fitted==false){return;}
  reports.Info(TReports::VL_SEG1, "%-30.30s   %10.10s %10.10s %10.10s\n", 
    "OVERALL SEGMENT INFO:", "SUM SIZE", "MAX SIZE", "USAGE [%]");
  
  TsegRecCI segRecCI;
  for (segRecCI=segRec[SEG_ROOT].segRef.begin(); 
       segRecCI!=segRec[SEG_ROOT].segRef.end(); segRecCI++){
         ReportOverall(*segRecCI);}
  reports.Info(TReports::VL_SEG1, "\n");
}

void TSegment::ReportSegmentTree(TSegmentRec* p, int level){
  if (p!=&segRec[SEG_ROOT]){
    reports.Info(TReports::VL_SEG1, 
      "%*.0s%c %-*.*s", level, "", (level==2)?'+':'*',
      SEG_MAXNAMELEN-level, SEG_MAXNAMELEN-level, p->name);      
      
    if (p->abs==-1 || fitted==false){
      reports.Info(TReports::VL_SEG1, "     -     ");
    }
    else{reports.Info(TReports::VL_SEG1, " $%8.8lx ",p->abs);}
    if (p->PC==0){reports.Info(TReports::VL_SEG1, "     .     ");}
    else{reports.Info(TReports::VL_SEG1, " $%8.8lx ",p->PC);}

    if (p->flags&TSegmentRec::Abstract){
      reports.Info(TReports::VL_SEG1, "Abstract ");
    }
    if (p->flags&TSegmentRec::Removable){
      if (p->status & TSegmentRec::Removed){
        reports.Info(TReports::VL_SEG1, "*REMOVED*");
      }
      else{reports.Info(TReports::VL_SEG1, "Removable ");}
    }
    reports.Info(TReports::VL_SEG1, "\n");
    if (p->status!=TSegmentRec::Ok && p->status!=TSegmentRec::Removed){
      reports.Info(TReports::VL_SEG1, "%*.0s  ^ STATUS: ", level, "");
      if (p->status & TSegmentRec::OutofRange){
        reports.Info(TReports::VL_SEG1, "Overflown ");
      }
      if (p->status & TSegmentRec::Collision){
        reports.Info(TReports::VL_SEG1, "Collision ");
      }
      reports.Info(TReports::VL_SEG1, "\n");
    }
  }
  TsegRecCI segRecCI;
  p->sortRefs();
  for (segRecCI=p->segRef.begin(); segRecCI != p->segRef.end(); segRecCI++){
    ReportSegmentTree(*segRecCI, level+2);}
}

void TSegment::ReportOverall(TSegmentRec* p){
  float usage;
  if (p->size==0){usage=0;}
  else{usage=(100.0*(float)p->sumSize)/(float)(p->size);}
  reports.Info(TReports::VL_SEG1, "  + %-30.30s $%8.8lx  $%8.8lx   %.1f\n", 
    p->name, p->sumSize, p->size, usage);
}

char* TSegment::TellBaseSegment(int segNo){
  assert(segNo>0);
  TSegmentRec* p = &segRec[segNo];  
  while(p->parent != segRec){p=p->parent;} /*go up and find parent=segrec*/
  return p->name;
}

char* TSegment::TellSegmentName(int segNo){
  assert(segNo>0);
  return segRec[segNo].name;
}

int TSegment::TellNoSegments(){
  return segUsageCnt;
}

int TSegment::TellMirror(int segNo){
  if (segRec[segNo].mirrorType==TSegmentRec::NoMirror){return -1;}
  return segRec[segNo].mirrorSegNo;
}

int TSegment::TellAlign(int segNo){
  return segRec[segNo].align;
}

