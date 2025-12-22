/*
 *   (C) COPYRIGHT International Business Machines Corp. 1993
 *   All Rights Reserved
 *   Licensed Materials - Property of IBM
 *   US Government Users Restricted Rights - Use, duplication or
 *   disclosure restricted by GSA ADP Schedule Contract with IBM Corp.
 */

/*
 * Permission to use, copy, modify, and distribute this software and its
 * documentation for any purpose and without fee is hereby granted, provided
 * that the above copyright notice appear in all copies and that both that
 * copyright notice and this permission notice appear in supporting
 * documentation, and that the name of I.B.M. not be used in advertising
 * or publicity pertaining to distribution of the software without specific,
 * written prior permission. I.B.M. makes no representations about the
 * suitability of this software for any purpose.  It is provided "as is"
 * without express or implied warranty.
 *
 * I.B.M. DISCLAIMS ALL WARRANTIES WITH REGARD TO THIS SOFTWARE, INCLUDING ALL
 * IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS, IN NO EVENT SHALL I.B.M.
 * BE LIABLE FOR ANY SPECIAL, INDIRECT OR CONSEQUENTIAL DAMAGES OR ANY DAMAGES
 * WHATSOEVER RESULTING FROM LOSS OF USE, DATA OR PROFITS, WHETHER IN AN ACTION
 * OF CONTRACT, NEGLIGENCE OR OTHER TORTIOUS ACTION, ARISING OUT OF OR IN
 * CONNECTION WITH THE USE OR PERFORMANCE OF THIS SOFTWARE.
 *
 * Author:  John Spitzer, IBM AWS Graphics Systems (Austin)
 */
%start PrintIt
%{
#ifndef WIN32
extern int yylineno;
#else
static int yylineno;
#endif
#if defined(WIN32)
#include <windows.h>
#elif defined( __OS2__)
#include <os2.h>
#ifdef YYBYACC
int yylex( void);
#endif
#endif
#include "stdio.h"
#include "stdlib.h"
#include "Global.h"
#include "PropName.h"
#include "TestName.h"
#include "Test.h"
#include "TestList.h"
#include "Attr.h"
#include "AttrList.h"
#include "Prop.h"
#include "PropList.h"
#include "NameList.h"
#include "Suite.h"
#include <malloc.h>
#include <math.h>

extern int printMode;
%}
%union {
  AttributePtr attr;
  AttributeListPtr attrList;
  PropertyPtr prop;
  PropertyListPtr propList;
  PropNameListPtr propNameList;
  TestPtr test;
  TestListPtr testList;
  SuitePtr suite;
  int ival;
  float fval;
  double dval;
  short sval;
  unsigned uval;
}

%token <ival> testName
%token <attr> attrName wildcard PropName errorName
%token <ival> openCurly closeCurly openBracket closeBracket openParen closeParen From To step Percent Printf comma

%type <attrList> AttrsDesc AttrListDesc RangeDesc PrintfDesc
%type <prop> PropDesc
%type <propList> PropListDesc
%type <propNameList> PropNameList CommaPropNameList
%type <suite> SuiteDesc PrintIt

%%
PrintIt		: SuiteDesc
		{
		    /* Suite__PrintOp($1); */ /* For Debugging */
		    Suite__Run($1, printMode);
		    delete_Suite($1);
		}
		;

SuiteDesc	: SuiteDesc PropDesc
		{
		    Suite__ParseGlobal($1, $2);
		    $$ = $1;
		}
		| SuiteDesc testName openCurly PropListDesc closeCurly
		{
		    Suite__ParseTest($1, $2, $4);
		    $$ = $1;
		}
		| SuiteDesc testName
		{
		    Suite__ParseTest($1, $2, NULL);
		    $$ = $1;
		}
		| SuiteDesc testName openCurly closeCurly
		{
		    Suite__ParseTest($1, $2, NULL);
		    $$ = $1;
		}
		| testName openCurly closeCurly
		{
		    SuitePtr suite = new_Suite();
		    Suite__ParseTest(suite, $1, NULL);
		    $$ = suite;
		}
		| testName openCurly PropListDesc closeCurly
		{
		    SuitePtr suite = new_Suite();
		    Suite__ParseTest(suite, $1, $3);
		    $$ = suite;
		}
		| testName
		{
		    SuitePtr suite = new_Suite();
		    Suite__ParseTest(suite, $1, NULL);
		    $$ = suite;
		}
		| PropDesc
		{
		    SuitePtr suite = new_Suite();
		    Suite__ParseGlobal(suite, $1);
		    $$ = suite;
		}
		| SuiteDesc errorName openCurly PropListDesc closeCurly
		{
		    char* buffer;
		    Attribute__StringOf($2, &buffer);
		    printf("GLperf: Line %d, Bad test name \"%s\"\n",
			   Attribute__GetLineNum($2), buffer);
		    exit(1);
		}
		| SuiteDesc errorName
		{
		    char* buffer;
		    Attribute__StringOf($2, &buffer);
		    printf("GLperf: Line %d, Bad test name \"%s\"\n",
			   Attribute__GetLineNum($2), buffer);
		    exit(1);
		}
		| SuiteDesc errorName openCurly closeCurly
		{
		    char* buffer;
		    Attribute__StringOf($2, &buffer);
		    printf("GLperf: Line %d, Bad test name \"%s\"\n",
			   Attribute__GetLineNum($2), buffer);
		    exit(1);
		}
		| errorName openCurly closeCurly
		{
		    char* buffer;
		    Attribute__StringOf($1, &buffer);
		    printf("GLperf: Line %d, Bad test name \"%s\"\n",
			   Attribute__GetLineNum($1), buffer);
		    exit(1);
		}
		| errorName openCurly PropListDesc closeCurly
		{
		    char* buffer;
		    Attribute__StringOf($1, &buffer);
		    printf("GLperf: Line %d, Bad test name \"%s\"\n",
			   Attribute__GetLineNum($1), buffer);
		    exit(1);
		}
		| errorName
		{
		    char* buffer;
		    Attribute__StringOf($1, &buffer);
		    printf("GLperf: Line %d, Bad test name \"%s\"\n",
			   Attribute__GetLineNum($1), buffer);
		    exit(1);
		}
		| SuiteDesc testName openCurly error
		{
		    printf("GLperf: Near line %d, missing \"}\"\n", yylineno);
		    exit(1);
		}
		| SuiteDesc testName openCurly PropListDesc error
		{
		    printf("GLperf: Near line %d, missing \"}\"\n", yylineno);
		    exit(1);
		}
		| testName openCurly error
		{
		    printf("GLperf: Near line %d, missing \"}\"\n", yylineno);
		    exit(1);
		}
		| testName openCurly PropListDesc error
		{
		    printf("GLperf: Near line %d, missing \"}\"\n", yylineno);
		    exit(1);
		}
		;

PropListDesc	: PropListDesc PropDesc
		{
		    PropertyList__AddProperty($1, $2);
		    $$ = $1;
		}
		| PropDesc
		{
		    PropertyListPtr propList = new_PropertyList();
		    PropertyList__AddProperty(propList, $1);
		    $$ = propList;
		}
		;

PropDesc	: openParen PropName AttrsDesc closeParen
		{
		    PropertyPtr prop;
		    PropNameListPtr propNameList = new_PropNameList();
		    int propName, propNameLineNum;
		    Attribute__IntOf($2, &propName);
		    propNameLineNum = Attribute__GetLineNum($2);
		    PropNameList__AddPropName(propNameList, propName, propNameLineNum);
		    prop = new_Property(propNameList, $3);
		    delete_Attribute($2);
		    $$ = prop;
		}
		| openParen errorName AttrsDesc closeParen
		{
		    char* buffer;
		    Attribute__StringOf($2, &buffer);
		    printf("GLperf: Line %d, Bad property name \"%s\"\n",
			   Attribute__GetLineNum($2), buffer);
		    exit(1);
		}
		| openParen testName AttrsDesc closeParen
		{
		    printf("GLperf: Near line %d, Test name erroneously used where a property should be\n",
			   yylineno);
		    exit(1);
		}
		| openParen attrName AttrsDesc closeParen
		{
		    printf("GLperf: Line %d, Attribute erroneously used where a property should be\n",
			   Attribute__GetLineNum($2));
		    exit(1);
		}
		| openParen openBracket PropNameList closeBracket AttrsDesc closeParen
		{
		    PropertyPtr prop = new_Property($3, $5);
		    $$ = prop;
		}
		| openParen openBracket errorName closeBracket AttrsDesc closeParen
		{
		    char* buffer;
		    Attribute__StringOf($3, &buffer);
		    printf("GLperf: Line %d, Bad property name \"%s\" in property list\n",
			   Attribute__GetLineNum($3), buffer);
		    exit(1);
		}
		| openParen openBracket testName closeBracket AttrsDesc closeParen
		{
		    printf("GLperf: Near line %d, Test name erroneously used in printf argument list, which must contain only property names\n",
			   yylineno);
		    exit(1);
		}
		| openParen openBracket attrName closeBracket AttrsDesc closeParen
		{
		    printf("GLperf: Line %d, Attribute erroneously used in printf argument list, which must contain only property names\n",
			   Attribute__GetLineNum($3));
		    exit(1);
		}
		;

PropNameList	: PropNameList PropName
		{
		    int propName, propNameLineNum;
		    Attribute__IntOf($2, &propName);
		    propNameLineNum = Attribute__GetLineNum($2);
		    PropNameList__AddPropName($1, propName, propNameLineNum);
		    delete_Attribute($2);
		    $$ = $1;
		}
		| PropNameList errorName
		{
		    char* buffer;
		    Attribute__StringOf($2, &buffer);
		    printf("GLperf: Line %d, Bad property name \"%s\" in property list\n",
			   Attribute__GetLineNum($2), buffer);
		    exit(1);
		}
		| PropNameList attrName
		{
		    printf("GLperf: Line %d, Attribute erroneously used in property list\n",
			   Attribute__GetLineNum($2));
		    exit(1);
		}
		| PropNameList testName
		{
		    printf("GLperf: Near line %d, Test name erroneously used in property list\n",
			   yylineno);
		    exit(1);
		}
		| PropName
		{
		    PropNameListPtr propNameList = new_PropNameList();
		    int propName, propNameLineNum;
		    Attribute__IntOf($1, &propName);
		    propNameLineNum = Attribute__GetLineNum($1);
		    PropNameList__AddPropName(propNameList, propName, propNameLineNum);
		    delete_Attribute($1);
		    $$ = propNameList;
		}
		;

CommaPropNameList	: CommaPropNameList comma PropName
		{
		    int propName, propNameLineNum;
		    Attribute__IntOf($3, &propName);
		    propNameLineNum = Attribute__GetLineNum($3);
		    PropNameList__AddPropName($1, propName, propNameLineNum);
		    delete_Attribute($3);
		    $$ = $1;
		}
		| CommaPropNameList comma errorName
		{
		    char* buffer;
		    Attribute__StringOf($3, &buffer);
		    printf("GLperf: Line %d, Bad property name \"%s\" in printf argument list, which must contain only property names\n",
			   Attribute__GetLineNum($3), buffer);
		    exit(1);
		}
		| CommaPropNameList comma testName
		{
		    printf("GLperf: Near line %d, Test name erroneously used in printf argument list, which must contain only property names\n",
			   yylineno);
		    exit(1);
		}
		| CommaPropNameList comma attrName
		{
		    printf("GLperf: Line %d, Attribute erroneously used in printf argument list, which must contain only property names\n",
			   Attribute__GetLineNum($3));
		    exit(1);
		}
		| PropName
		{
		    PropNameListPtr propNameList = new_PropNameList();
                    int propName, propNameLineNum;
                    Attribute__IntOf($1, &propName);
                    propNameLineNum = Attribute__GetLineNum($1);
		    PropNameList__AddPropName(propNameList, propName, propNameLineNum);
		    delete_Attribute($1);
		    $$ = propNameList;
		}
		;

AttrsDesc	: wildcard
		{
		    AttributeListPtr attrList = new_AttributeList();
		    AttributeList__AddAttribute(attrList, $1);
		    $$ = attrList;
		}
		| AttrListDesc
		{
		    $$ = $1;
		}
		| RangeDesc
		{
		    $$ = $1;
		}
		| PrintfDesc
		{
		    $$ = $1;
		}
		;

PrintfDesc	: Printf openParen attrName comma CommaPropNameList closeParen
		{
		    char* sval;
		    if (Attribute__StringOf($3, &sval)) {
			PrintfStringPtr printfString = new_PrintfString(sval, $5);
			AttributePtr attr = new_Attribute_PrintfString(printfString);
		        AttributeListPtr attrList = new_AttributeList();
		        AttributeList__AddAttribute(attrList, attr);
		        $$ = attrList;
		    } else {
			printf("GLperf: Line %d, Printf format must be a string\n", Attribute__GetLineNum($3));
			exit(1);
		    }
		}
		| Printf openParen attrName comma errorName closeParen
		{
		    char* buffer;
		    Attribute__StringOf($5, &buffer);
		    printf("GLperf: Line %d, Bad property name \"%s\" in printf argument list, which must contain only property names\n",
			   Attribute__GetLineNum($5), buffer);
		    exit(1);
		}
		;

RangeDesc	: From attrName To attrName
		{
		    int ival, fromival, toival;
		    float fval, fromfval, tofval;

		    if (Attribute__IntOf($2, &fromival) && Attribute__IntOf($4, &toival)) {
			if (fromival > toival) {
			    printf("GLperf: Line %d, Range invalid\n", Attribute__GetLineNum($2));
		   	    exit(1);
			} else {
			    AttributeListPtr attrList = new_AttributeList();
			    for (ival=fromival; ival<=toival; ival++) {
				AttributeList__AddAttribute(attrList, new_Attribute_Int(ival));
			    }
			    $$ = attrList;
			}
		    } else if (Attribute__FloatOf($2, &fromfval)) {
			if (Attribute__FloatOf($4, &tofval)) {
			    if (fromfval > tofval) {
				printf("GLperf: Line %d, Range invalid\n", Attribute__GetLineNum($2));
				exit(1);
			    } else {
				AttributeListPtr attrList = new_AttributeList();
				for (fval=fromfval; fval<=tofval; fval++) {
				    AttributeList__AddAttribute(attrList, new_Attribute_Float(fval));
				}
				$$ = attrList;
			    }
			} else {
			    printf("GLperf: Line %d, Range from/to values of different types\n", Attribute__GetLineNum($2));
			    exit(1);
			}
		    } else {
			printf("GLperf: Line %d, Range of an unsupported type\n", Attribute__GetLineNum($2));
			exit(1);
		    }
		}
		| From attrName To attrName step attrName
		{
		    int ival, fromival, toival, stepival;
		    float fval, fromfval, tofval, stepfval;

                    if (Attribute__IntOf($2, &fromival) && Attribute__IntOf($4, &toival) && Attribute__IntOf($6, &stepival)) {
			if ((toival - fromival) * stepival < 0) {
			    printf("GLperf: Line %d, Range invalid\n", Attribute__GetLineNum($2));
			    exit(1);
			} else {
			    AttributeListPtr attrList = new_AttributeList();
			    if (fromival < toival)
				for (ival=fromival; ival<=toival; ival+=stepival)
                                    AttributeList__AddAttribute(attrList, new_Attribute_Int(ival));
			    else
				for (ival=fromival; ival>=toival; ival+=stepival)
                                    AttributeList__AddAttribute(attrList, new_Attribute_Int(ival));
			    $$ = attrList;
			}
                    } else if (Attribute__FloatOf($2, &fromfval) &&
                               Attribute__FloatOf($4, &tofval) &&
			       Attribute__FloatOf($6, &stepfval)) {
			if ((tofval - fromfval) * stepfval < 0.0) {
                            printf("GLperf: Line %d, Range invalid\n", Attribute__GetLineNum($2));
			    exit(1);
			} else {
			    AttributeListPtr attrList = new_AttributeList();
			    if (fromfval < tofval)
				for (fval=fromfval; fval<=tofval; fval+=stepfval)
                                    AttributeList__AddAttribute(attrList, new_Attribute_Float(fval));
			    else
			        for (fval=fromfval; fval>=tofval; fval+=stepfval)
                                    AttributeList__AddAttribute(attrList, new_Attribute_Float(fval));
			    $$ = attrList;
			}
		    } else {
                        printf("Line %d: Range of unsupported or dissimilar types\n", Attribute__GetLineNum($2));
			exit(1);
		    } 
		}
		| From attrName To attrName step attrName Percent
		{
		    int ival, fromival, toival, stepival;
		    float fval, fromfval, tofval, stepfval;

                    if (Attribute__IntOf($2, &fromival) &&
                        Attribute__IntOf($4, &toival) &&
                        Attribute__IntOf($6, &stepival)) {
                        if ((toival - fromival) * stepival < 0 ||
                            fromival <= 0) {
                            printf("GLperf: Line %d, Range invalid\n", Attribute__GetLineNum($2));
                            exit(1);
                        } else {
                            float percentage = (float)stepival / 100.;
                            AttributeListPtr attrList = new_AttributeList();
                            if (fromival < toival)
                                for (ival=fromival; ival<=toival; ival += max(floor((float)ival * percentage + .5), 1))
                                    AttributeList__AddAttribute(attrList, new_Attribute_Int(ival));
                            else
                                for (ival=fromival; ival>=toival; ival += min(floor((float)ival * percentage + .5), -1))
                                    AttributeList__AddAttribute(attrList, new_Attribute_Int(ival));
                            $$ = attrList;
                        }
                    } else if (Attribute__FloatOf($2, &fromfval) &&
                               Attribute__FloatOf($4, &tofval) &&
                               Attribute__FloatOf($6, &stepfval)) {
                        if ((tofval - fromfval) * stepfval < 0.0 ||
                            fromival <= 0.) {
                            printf("GLperf: Line %d, Range invalid\n", Attribute__GetLineNum($2));
                            exit(1);
                        } else {
                            float percentage = stepfval / 100. + 1.;
                            AttributeListPtr attrList = new_AttributeList();
                            if (fromfval < tofval)
                                for (fval=fromfval; fval<=tofval; fval = fval * percentage)
                                    AttributeList__AddAttribute(attrList, new_Attribute_Float(fval));
                            else
                                for (fval=fromfval; fval>=tofval; fval = fval * percentage)
                                    AttributeList__AddAttribute(attrList, new_Attribute_Float(fval));
                            $$ = attrList;
                        }
                    } else {
                        printf("GLperf, Line %d: Range of unsupported or dissimilar types\n", Attribute__GetLineNum($2));
                        exit(1);
                    }
                }
                ;

AttrListDesc	: AttrListDesc attrName
		{
		    AttributeList__AddAttribute($1, $2);
		    $$ = $1;
		}
		| attrName
		{
		    AttributeListPtr attrList = new_AttributeList();
		    AttributeList__AddAttribute(attrList, $1);
		    $$ = attrList;
		}
		;

%%
yyerror(char* s)
{
     fprintf (stderr, "GLperf: Near line %d, %s\n", yylineno, s);
}
