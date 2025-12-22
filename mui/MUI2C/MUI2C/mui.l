/* Flex definition file.
 *
 * State description:
 *
 * <initial>    -- Before parsing the Class keyword
 * <predata>    -- After parsing the Class clause, before Data keyword
 * <maincode>   -- After parsing the Data clause, outside of any methods
 *
 *
 *      <initial> + "Class("   -> <cls>             -- Encountered start of Class clause
 *          <cls> + "<name>"   -> <postcls>         -- Encountered name of class
 *      <postcls> + "::"       -> <supercls>        -- Encountered start of Superclass section
 *     <supercls> + "<name>"   -> <postsupercls>    -- Encountered name of superclass
 * <postsupercls> + "):"       -> <basecode>        -- Encountered start of base code clause
 *     <basecode> + "<number>" -> <predata>         -- Encountered value of base code
 *
 *
 *      <predata> + "Data("    -> <predataname>     -- Encountered start of Data clause
 *  <predataname> + "<name>"   -> <postdataname>    -- Encountered name of data
 * <postdataname> + ")"        -> <maincode>        -- Encountered end of Data clause
 *
 *
 *     <maincode> + "Method("  -> <premethname>     -- Encountered start of Method clause
 *  <premethname> + "<name>"   -> <postmethname>    -- Encountered name of method
 * <postmethname> + "){"       -> <inmethcode>      -- Encountered start of method code
 *   <inmethcode> + "}"        -> <maincode>        -- Encountered end of method code
 *
 *
 *     <maincode> + "Method(OM_GET){" -> <ingmethcode>  -- Encountered start of OM_GET method code
 *  <ingmethcode> + "Attributes{"     -> <ingattname>   -- Encountered start of OM_GET attributes
 *   <ingattname> + "<name>"          -> <ingattblk>    -- Encountered name of an attribute
 *   <ingattblk>  + "{"               -> <ingattcode>   -- Encountered start of an attribute definition
 *   <ingattcode> + "}"               -> <ingattname>   -- Encountered end of an attribute definition
 *   <ingattname> + "}"               -> <ingmethcode>  -- Encountered end of OM_GET attributes
 *  <ingmethcode> + "}"               -> <maincode>     -- Encountered end of OM_GET method code
 *
 *
 *     <maincode> + "Method(OM_SET){" -> <insmethcode>  -- Encountered start of OM_SET method code
 *  <insmethcode> + "Attributes{"     -> <insattname>   -- Encountered start of OM_SET attributes
 *   <insattname> + "<name>"          -> <insattblk>    -- Encountered name of an attribute
 *   <insattblk>  + "{"               -> <insattcode>   -- Encountered start of an attribute definition
 *   <insattcode> + "}"               -> <insattname>   -- Encountered end of an attribute definition
 *   <insattname> + "}"               -> <insmethcode>  -- Encountered end of OM_SET attributes
 *  <insmethcode> + "}"               -> <maincode>     -- Encountered end of OM_SET method code
 *
 *
 */

%x comment
%x bracket
%x cppcomment
%x cls
%x postcls
%x supercls
%x postsupercls
%x basecode
%x predata
%x predataname
%x postdataname
%x maincode
%x premethname
%x postmethname
%x inmethcode
%x ingmethcode
%x insmethcode
%x ingattname
%x insattname
%x ingattblk
%x insattblk
%x ingattcode
%x insattcode
%option stack
%option noyywrap 

%{
#include <stdlib.h>
#include <string.h>
#include "id.h"

char outfilename[1024], headerfilename[1024], privheaderfilename[1024], tempname[1024];
unsigned long base, vars = 0, trailer = 0, atttrailer = 0;

const char version[]="$VER: mui2c 1.2 (22.06.96) ©1996 Jason Birch\0";
%}

SP      [ \t]*
NL      \n*
SPNL    [ \t\n]*
NAME    [A-Za-z0-9_]+
SPCNAME [A-Za-z0-9_ ]+
NUM     [0-9xa-fA-F]+
OPEN    {SP}"("{SP}
PUBLIC  ":"{SP}"public"{SP}
CLOSE   {SP}")"{SP}
CLOSEP  {CLOSE}{PUBLIC}
OPENBLK {SPNL}"{"{SP}{NL}
NOBRKT  [^"{}"]+
CLASS   ^{SP}Class{SP}{OPEN}
DATA    ^{SP}Data{SP}{OPEN}
METHOD  ^{SP}Method{SP}{OPEN}
METHODS ^{SP}"Method*"{SP}{OPEN}
ATTRIB  ^{SP}Attributes{SP}{OPENBLK}

%%

%{
/* Rules to handle the class definition.
 */
%}

{CLASS}                     BEGIN(cls);

<cls>{NAME}             {   SetClassName(yytext);
							MakeMainHeader(yyout,headerfilename,privheaderfilename);
							BEGIN(postcls);
						}

<postcls>{
		{SP}"::"{SP}        BEGIN(supercls);
		{CLOSE}         {   printf("Error: Superclass must be specified after class name.\n");
							exit(1);
						}
		{SP}[^"::"]     {   printf("Error: Class name must not contain spaces.\n");
							exit(1);
						}
}

<supercls>{NAME}        {   SetSuperClassName(yytext);
							BEGIN(postsupercls);
						}

<postsupercls>{
		{SP}[^")"]      {   printf("Error: Superclass name must not contain spaces.\n");
							exit(1);
						}
		{CLOSE}{SP}":"      BEGIN(basecode);
		{CLOSE}         {   printf("Error: Base tag value must follow superclass definition.\n");
							exit(1);
						}
}

<basecode>{
		{SP}{NUM}{SPNL} {   char *end;
							base = strtol(yytext,&end,0);
							BEGIN(predata);
						}
		.               {   printf("Error: Invalid base tag. Must be octal, decimal, or hexadecimal.\n");
							exit(1);
						}
		{SPNL}          {   printf("Error: Missing base tag.\n");
							exit(1);
						}
}

%{
/* Followed by rules to handle the data definition.
 */
%}

<predata>{DATA}             BEGIN(predataname);

<*>{DATA}               {   printf("Error: Data keyword found while Class undefined.\n");
							exit(1);
						}

<predataname>{SPCNAME}  {   SetDataName(yytext);
							BEGIN(postdataname);
						}

<postdataname>{CLOSE}{SPNL} {
							BEGIN(maincode);
							fprintf(yyout,messages[DEFINES]);
						}


%{
/* Ready to parse the main code now.
 * Method definitions are recognized and the state changed appropriately.
 * OM_GET and OM_SET are handled separately because they have nested Attribute
 * structures.
 */
%}

<maincode>{
		{METHOD}OM_GET{CLOSEP}{OPENBLK} |
		{METHOD}OM_GET{CLOSE}{OPENBLK} {
							fprintf(yyout,messages[GET_HEADER],clsname);
							Add("OM_GET",METHOD);
							BEGIN(ingmethcode);
							fprintf(yyout,messages[MTH_VARS],dataname);
							fprintf(yyout,messages[GET_VARS]);
						}

		{METHOD}OM_SET{CLOSEP}{OPENBLK} |
		{METHOD}OM_SET{CLOSE}{OPENBLK} {
							fprintf(yyout,messages[SET_HEADER],clsname);
							Add("OM_SET",METHOD);
							BEGIN(insmethcode);
							fprintf(yyout,messages[MTH_VARS],dataname);
							fprintf(yyout,messages[SET_VARS]);
						}

		{METHODS}       {   vars = MTH_VARS_SMALL;
							trailer = MTH_TRAILER_SMALL;
							BEGIN(premethname);
						}

		{METHOD}        {   vars = MTH_VARS;
							trailer = MTH_TRAILER;
							BEGIN(premethname);
						}
}

<*>{METHOD}             {   printf("Error: Method keyword found while instance data undefined.\n");
							exit(1);
						}


%{
/* Handle a standard method.
 */
%}

<premethname>{NAME}     {   Add(yytext, METHOD);
							fprintf(yyout,messages[MTH_HEADER],clsname,yytext);
							if (vars == MTH_VARS)
								CheckSpecialCases(yytext, &vars, &trailer);
							BEGIN(postmethname);
						}

<postmethname>{
		{CLOSEP}{OPENBLK} {
							MakePublic();   /* This method was flagged as public */
							BEGIN(inmethcode);
							if (vars == 0){
								printf("Panic: Internal error 'vars'!\n");
								exit(1);
							}
							fprintf(yyout,messages[vars],dataname);
							vars = 0;
						}
		{CLOSE}{OPENBLK} {
							BEGIN(inmethcode);
							if (vars == 0){
								printf("Panic: Internal error 'vars'!\n");
								exit(1);
							}
							fprintf(yyout,messages[vars],dataname);
							vars = 0;
						}

		[^")"]          {   printf("Error: Method name must not contain spaces.\n");
							exit(1);
						}
}

<inmethcode>{SP}"}"     {   if (trailer == 0){
								printf("Panic: Internal error 'trailer'!\n");
								exit(1);
							}
							fprintf(yyout,messages[trailer]);
							trailer = 0;
							BEGIN(maincode);
						}

%{
/* End of a standard method. Goes back to the main code now.
 */
%}

%{
/* Handle an OM_GET method.
 */
%}

<ingmethcode>{
		{ATTRIB}        {   fprintf(yyout,messages[INGETMETH]);
							BEGIN(ingattname);
						}
		{SP}"}"         {   fprintf(yyout,messages[GET_TRAILER]);
							BEGIN(maincode);
						}
}

<ingattname>{
		{SPNL}              ECHO;
		{NAME}/"*"      {   Add(yytext, ATTRIBUTE);
							fprintf(yyout,messages[CASE],yytext);
							BEGIN(ingattblk);
							atttrailer = ATT_TRAILER_SMALL;
							input();    /* Get rid of "*" */
						}             
		{NAME}          {   Add(yytext, ATTRIBUTE);
							fprintf(yyout,messages[CASE],yytext);
							BEGIN(ingattblk);
							atttrailer = GET_ATT_TRAILER;
						}
		{SP}"}"         {   fprintf(yyout,messages[GET_DEFS_TRAILER]);
							BEGIN(ingmethcode);
						}
}

<ingattblk>{
		{SP}{PUBLIC}        MakePublic();
		{OPENBLK}       {   ECHO;
							BEGIN(ingattcode);
						}
		.               {   printf("Error: No attribute definition.\n");
							exit(1);
						}
}

<ingattcode>{
		{SP}"}"         {   if ((atttrailer != GET_ATT_TRAILER) && (atttrailer != ATT_TRAILER_SMALL)){
								printf("Panic: Internal error 'atttrailer'.\n");
								exit(1);
							}
							fprintf(yyout,messages[atttrailer]);
							BEGIN(ingattname);
						}
		{NOBRKT}           ECHO;
}

%{
/* Handle an OM_SET method.
 */
%}

<insmethcode>{
		{ATTRIB}        {   fprintf(yyout,messages[INSETMETH]);
							BEGIN(insattname);
						}
		{SP}"}"         {   fprintf(yyout,messages[SET_TRAILER]);
							BEGIN(maincode);
						}
}

<insattname>{
		{SPNL}              ECHO;
		{NAME}/"*"      {   Add(yytext, ATTRIBUTE);
							fprintf(yyout,messages[CASE],yytext);
							BEGIN(insattblk);
							atttrailer = ATT_TRAILER_SMALL;
							input();    /* Get rid of "*" */
						}
		{NAME}          {   Add(yytext, ATTRIBUTE);
							fprintf(yyout,messages[CASE],yytext);
							BEGIN(insattblk);
							atttrailer = SET_ATT_TRAILER;
						}
		{SP}"}"         {   fprintf(yyout,messages[SET_DEFS_TRAILER]);
							BEGIN(insmethcode);
						}
}

<insattblk>{
		{SP}{PUBLIC}        MakePublic();
		{OPENBLK}       {   ECHO;
							BEGIN(insattcode);
						}
		.               {   printf("Error: No attribute definition.\n");
							exit(1);
						}
}

<insattcode>{
		{SP}"}"         {   if ((atttrailer != SET_ATT_TRAILER) && (atttrailer != ATT_TRAILER_SMALL)){
								printf("Panic: Internal error 'atttrailer'.\n");
								exit(1);
							}
							fprintf(yyout,messages[atttrailer]);
							BEGIN(insattname);
						}
		{NOBRKT}        ECHO;
}


<*>{ATTRIB}             {   printf("Error: Attributes keyword may only be used within OM_GET and OM_SET methods.\n");
							exit(1);
						}



%{
/* Handle nested brackets within other structures.
 * We don't want to mistakenly grab a "}" that belongs to another "{".
 */
%}

<*>"{"                  {   yy_push_state(bracket);
							ECHO;
						}

<bracket>{
		NOBRKT              ECHO;
		{SP}"}"         {   yy_pop_state();
							ECHO;
						}
		<<EOF>>         {   printf("Error: Unclosed bracket.\n");
							exit(1);
						}
}



%{
/* Handle the various forms of comment.
 */
%}

<*>"/*"                 {   yy_push_state(comment);
							ECHO;
						}
<comment>{
		[^"*/"]*            ECHO;
		"*/"            {   yy_pop_state();
							ECHO;
						}
		<<EOF>>         {   printf("Error: Unclosed comment.\n");
							exit(1);
						}
}

<cppcomment>{
		 [^\n]+             ECHO;
		\n              {   yy_pop_state();
							ECHO;
						}
}

<*>"//"                 {   yy_push_state(cppcomment);
							ECHO;
						}

<*>"}"                  {   printf("Error: Unexpected }.\n");
							ECHO;
						}


%%
main(int argc, char **argv)
{
	char *extension;
	int length;

	if (argc != 2){
		fprintf(stderr,"Usage: %s <filename>\n",argv[0]);
		exit(1);
	}

	length = strlen(argv[1]);
	extension = &(argv[1][length - 2]);

	if (strcmp(extension,".m") == 0 ||
		strcmp(extension,".M") == 0){
		strncpy(tempname,argv[1],length-2);
		tempname[length-2] = '\0';
	} else
		strcpy(tempname,argv[1]);

	sprintf(outfilename, "%s.c", tempname);
	sprintf(headerfilename, "%s.h", tempname);
	sprintf(privheaderfilename, "%sp.h", tempname);

	if (!(yyin = fopen(argv[1], "r"))){
		fprintf(stderr,messages[ERROPENR],tempname);
		exit(1);
	}

	if (!(yyout = fopen(outfilename, "w"))){
		fprintf(stderr,messages[ERROPENW],outfilename);
		exit(1);
	}

	yylex();
	MakeHeaders(headerfilename,privheaderfilename,base);
	MakeHousekeeping(yyout);
}
