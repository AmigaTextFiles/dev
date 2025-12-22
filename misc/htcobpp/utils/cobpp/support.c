
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <errno.h>
#include <assert.h>

#include <sys/types.h>
#include <sys/stat.h>

//#ifndef INCLUDED_COBPP_H
#include "cobpp.h"
//#endif

#include "opt_util.h"

#ifdef DEBUG
#include "dmalloc.h"
#endif


/* 
 *  Initalize the Env struct passed to this fucntion 
 */
int setDefaults( Env* gEnv ) {

	gEnv->fixedFormat  = 0; /* off */
	gEnv->freeFormat = 1; /* X/Open by default */
	gEnv->format    = 0; /* free == 0, fixed == 1 */
	gEnv->debug     = 0; /* off  -delete "^D.*" lines */
	gEnv->errFlag   = 0;  /* no error state by default */
	gEnv->tab2space = 1;  /* expand tabs to one space */
	gEnv->progName  = NULL;
	gEnv->filename = NULL;
#if 0
	gEnv->fnList    = NULL ;
#endif
	return atexit(CleanUp);
};
/*
 *  Function to clean up memory allocated in program.
 * 
 */
void CleanUp( void ) {
	
	Env *gEnv = globalEnvPtr;
#if 0
	int i;
	void * tempItem;
#endif


	globalEnvPtr = NULL;
	if ( gEnv->progName != NULL )
		free(gEnv->progName);

	if ( gEnv->filename != NULL )
		free( gEnv->filename );
#if 0 
/* #ifdef DEBUG */
	fprintf(stderr,"Dealloc list memory\n");
	for( i = listLength( gEnv->fnList ); 0<i; i-- ) {
		tempItem = listDelete( &(gEnv->fnList), i );
		if( tempItem != NULL )
			free( tempItem );
	}
#endif
	
}

/* Duh, print out the version in the strin cobppVersion as 
 * defined in cobpp.h
 */
void printVersion( char* pname ) {

//	fprintf(stdout, "%s\n", cobppVersion);
	fprintf(stdout, "%s: %s %s\n%s\n\n", 
	                globalEnvPtr->progName, 
	                cobppVersion0, 
	                cobppVersion, 
	                cobppVersion1); 
}




/*
 * Read in command line options and set up the Env struct passed in
 * Alloc memory for program name string in Env struct.
 * 
 */
int setOptions( Env* gEnv, int argc, char** argv ) {
	
	/*  Read in args for option settings. */

	char *argument;
	int option ;
	int temp;
	char * tempChar;
	struct stat tempbuf;
	


	/* command line options */

	static char *option_list[] = { 
		"{-help}", "{h}",  		/* 1,2 */
		"{-version}", "{v}",		/* 3,4 */
		"{-tab:}", "{t:}",		/* 5,6 */
		"{-free-format}", "{x}",	/* 7,8 */
		"{-fixed-format}", "{f}",	/* 9,10 */
/* 15,16 */
/* 17,18 */
/* 19,20 */
		/* reserved for future use */ /* 21,22 */
                NULL
	};

	/*
         * Check argc for number of args equal to zero 
         *  don't bother to check options, just error out.
         */
	if ( argc < 2 ) {
		gEnv->errFlag++;
	}

	tempChar = strdup( (char*)argv[0] );
	if( tempChar != NULL )
	    gEnv->progName = tempChar;
	else
	    gEnv->progName = "cobpp";

	opt_init (argc, argv, 1, option_list, NULL) ;

   while ( (option = opt_get(NULL, &argument)) ) {

       switch (option) {
	case 1:                 
	case 2:  /* help */
		printVersion(argv[0]);
		printHelp( 1 );
		return 1;
		break;
	case 3:
	case 4: /* version */
		printVersion(argv[0]);
		return 1;
		break;
	case 5:
	case 6: /* tabs */
		if ( gEnv->tab2space != 0 ) {
			gEnv->tab2space= atoi(argument);
		}
		break;
	case 7:
// 	case 8: /* free-format */
// 		gEnv->format    = 0; /* free == 0, fixed == 1 */
// 		gEnv->freeFormat = 1;
// 		break;
	case 8: /* fixed format */
		gEnv->format    = 1; /* free == 0, fixed == 1 */
		gEnv->fixedFormat = 1;
		break;
	case 9:
// 	case 10: /* fixed format */
// 		gEnv->format    = 1; /* free == 0, fixed == 1 */
// 		gEnv->fixedFormat = 1;
// 		break;
	case 10: /* free-format */
		gEnv->format    = 0; /* free == 0, fixed == 1 */
		gEnv->freeFormat = 1;
		break;
// 	case 11:
// 	case 12: /* ansi85 type checking */
// 		gEnv->format    = 1; /* free == 0, fixed == 1 */
// 		gEnv->fixedFormat = 1;
// 		gEnv->tab2space=0;
// 		break;
// 	case 13:
// 	case 14: /* turn on debug statements */
// 		gEnv->debug = 1;
// 		break;
#if 0 
	/* reserved for future */
	case 15:
	case 14: /*  */
		break;
#endif
	case NONOPT: /* Handle filenames */
		if ( gEnv->filename != NULL ) {
			fprintf(stderr,
				"Invaild argument: %s.\n"
				,argument
			);
			break;
		}
		temp = stat( argument, &tempbuf );
		if ( strcmp(argument,"-") == 0 ) {
			gEnv->filename = strdup(" ");
			if( tempChar == NULL ) {
			      	fprintf(stderr,
			 	"Unable to alloc memory for strdup: %s.\n"
				, argument );
		      		gEnv->errFlag++;
			}
			break;
		}else if ( temp != 0 && errno == ENOENT ) {
			fprintf(stderr,"Invalid filename: %s.\n", argument );
			break;
		}
		/* vaild file */
		tempChar = strdup( argument );
		if( tempChar == NULL ) {
		      	fprintf(stderr,
		 	"Unable to alloc memory for strdup: %s.\n", argument );
		      	gEnv->errFlag++;
			break;
		}
		gEnv->filename = tempChar;
		
		break;
		
		
	#if 0
		#ifdef DEBUG
			fprintf(stderr, "DEBUG: nonopt arg: %s \n", argument);
		#endif
		temp = 0; 
		tempChar = NULL;
		temp = stat( argument, &tempbuf );
		if ( temp != 0 && errno == ENOENT ) {
			fprintf(stderr,"Invalid filename: %s.\n", argument );
		} else  {
		     temp = strlen( (char*)argument );
		     tempChar = strndup( (char*)argument, (size_t) temp );
		     if( tempChar == NULL ) {
		       	fprintf(stderr,
		 	"Unable to alloc memory for strndup: %s.\n", argument );
		       gEnv->errFlag++;
		     } else {
			temp = listAdd( &(gEnv->fnList), -1, tempChar );
			if ( temp ){
				   gEnv->errFlag++;
				   free(tempChar);
			}
		     }
		 
		}
	#endif
		break;
	case OPTERR:
		gEnv->errFlag++;
		break;
	default:
		assert(1); /* should never be here right? */
		break;
	}
   }
#if 0
	if ( listLength(gEnv->fnList) == 0  )
#endif
	
	if ( gEnv->filename == NULL  )
	{

		fprintf(stderr,"%s: No input files\n", gEnv->progName);
		gEnv->errFlag++;
	}

#ifdef DEBUG
	fprintf(stderr,"SetOptions function: \n");
#endif

   return 0;

}


/* 
 *  Print out extended help and mini help based on
 *  command line switches 
 */
void printHelp( int flag ){

    if (flag) {
        fprintf (stderr,
#if 0 
		/* future to handle multi files */
		"Usage: %s  [<options>] [<input_file(s)>]\n"
#endif
		/* handle only one file right now */
		"Usage: %s  [<options>] [<input_file>] <output is to standard output>\n"
                "where <options> are:\n"
	"      -h, --help              This help screen\n"
	"      -v, --version           Print out version\n"
	"      -t, --tab <num>         Expand tabs to <num> space(s)\n"
	"      -x, --free-format       Convert source to X/Open free source format\n"
	"      -f, --fixed-format      Convert source to Standard fixed column format\n"
// 	"      -a, --ansi85            Strict Ansi '85 checking(no tabs\n"
// 	"      -d, --debug             Turns on debuging of source\n"
#if 0
/*      Reserved for future use         */
	"      -W0, --ignore                  Ignore errors\n"
	"      -W1, -W, --warn                Warn on compliance failure\n"
	"      -W2, --strict                  Error on compliance failure\n"
#endif
 	"\n"
	, globalEnvPtr->progName) ;
    }
    else {
	fprintf(stderr, "%s --help for a complete listing of options.\n",
			globalEnvPtr->progName);
    }
}

