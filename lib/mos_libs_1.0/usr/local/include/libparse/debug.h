/** 
 * @author Riccardo Manfrin [namesurname at gmail dot com]
 * 
 * @brief  Debug features for verbose output\n
 * Example:\n
 * ...\n
 * dbg_verbose(5);printf("set dbg level to 5 (only dbg messages with dbg level >= 5 are printed)\n");\n
 * dbg_print(4,"debug level 4\n");\n
 * dbg_print(5,"debug level 5\n");\n
 * dbg_print(6,"debug level 6\n");\n
 * dbg_ploc();\n
 * dbg_print(7,"debug level 7 WITH localization\n");\n
 * dbg_hloc();\n
 * dbg_print(8,"debug level 8 WITHOUT localization\n");\n
 * ...
 */
  
#ifndef DEBUG_H
#define DEBUG_H

#include <stdio.h>

///Specify verbosity level
void dbg_verbose(int lev);

///Check if verbosity level lev is active
unsigned int dbg_isverbose(int lev);

///Enable code localization printing
void dbg_printloc();

///Enable code localization hiding (default)
void dbg_hideloc();

///Enable timestamp
void dbg_printtime();

///Disable timestamp (default)
void dbg_hidetime();

///Check if code localization is enabled
unsigned int dbg_islocalized();

///Check if timestamp is enabled
unsigned int dbg_istimestamp();

///Print timestamp
void dbg_time_print(int lev);

///Print code localization information
void dbg_loc_print(int lev, char *file, int line);

///Print data
void dbg_data_print(int lev, const void *data, ...);

#define dbg_print(lev, ...)\
	do{\
		if(dbg_istimestamp())\
			dbg_time_print(lev);\
		if(dbg_islocalized())\
			dbg_loc_print(lev, __FILE__, __LINE__);\
		dbg_data_print(lev, __VA_ARGS__);\
	}while(0)

#endif
