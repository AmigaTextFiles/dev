#ifndef FEELIN_XMLAPPLICATION_H
#define FEELIN_XMLAPPLICATION_H

#include <feelin/xmlobject.h>

/*
**  feelin/xmlapplication.h
**
**  © 2001-2005 Olivier LAVIALE (gofromiel@gofromiel.com)
**
*************************************************************************************************

$VER: 02.01 (2005/09/05)

	Added FV_XMLAPPLICATION_ID_FEELIN_STYLE

*/

#define FC_XMLApplication                       "XMLApplication"
#define XMLApplicationObject                    IFEELIN F_NewObj(FC_XMLApplication

#define FV_XMLApplication_Version               1

#define F_XMLAPPLICATION_APPLICATION            "Application"
#define F_XMLAPPLICATION_ATTRIBUTE              "attribute"
#define F_XMLAPPLICATION_MESSAGE                "message"
#define F_XMLAPPLICATION_METHOD                 "method"
#define F_XMLAPPLICATION_NOTIFY                 "notify"
#define F_XMLAPPLICATION_OBJ                    "obj"
#define F_XMLAPPLICATION_ROOT                   "feelin:application"
#define F_XMLAPPLICATION_TARGET                 "target"
#define F_XMLAPPLICATION_VALUE                  "value"
#define F_XMLAPPLICATION_STYLESHEET             "xml-stylesheet"

#endif
