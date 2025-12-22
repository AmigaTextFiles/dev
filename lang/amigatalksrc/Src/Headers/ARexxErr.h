/****h* AmigaTalk/ARexxErr.h [1.5] ***************************************
*
* NAME
*    ARexxErr.h 
*
* DESCRIPTION
*    The include for the Translation of error numbers into strings.
**************************************************************************
*
*/

/*
 * $Log$
*/

#if      !(_AREXX_ERRORS_H)
# define   _AREXX_ERRORS_H  1

struct err {

   LONG  Num;
   char *Str;
};

# ifdef   ALLOC

struct err Errors[] = {

   { 201, "Couldn't find the given class.\n"  },
   { 202, "Couldn't find the given method.\n" },
   { 205, "Couldn't open file for reading.\n" },
   { 206, "Couldn't open file for writing.\n" },
         
   { 1000, ".\n" },   

   { -1L, "End of Table Marker.\n" }

};

# else
extern struct err Errors[];
# endif

#endif

/* ------------------ END of ARexxErr.h file! -------------------- */