#ifndef UTILITY_TAGITEM_H
#define UTILITY_TAGITEM_H


#ifndef EXEC_TYPES_H
MODULE  'exec/types'
#endif


  


OBJECT TagItem

    Tag:LONG
    Data:LONG  
ENDOBJECT


#define TAG_DONE   0    
#define TAG_END      0   
#define  TAG_IGNORE 1   
#define  TAG_MORE   2   
#define  TAG_SKIP   3   

#define TAG_USER   $80000000->1<<31



#define TAGFILTER_AND 0    
#define TAGFILTER_NOT 1    


#define MAP_REMOVE_NOT_FOUND 0   
#define MAP_KEEP_NOT_FOUND   1   

#endif 
