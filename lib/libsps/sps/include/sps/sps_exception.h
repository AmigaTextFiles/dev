/*!
 *  @addtogroup <sps>
 *  @{ pointdesign DOT com
 *
 *  Copyright (c) 2006 Jürgen Schober
 *  This code herein is freeware and provided AS IS.
 *  Use at your own risk. No waranty!
 */

/*!
 *  @file sps_exception.h
 *
 *  Generic exception class and macros.
 *
 *  SPS_Exceptions are used within the libsps++ to handle various
 *  errors. It provides a simple __FILE__, __LINE__ dependet
 *  error message handling and allows the user to show an intuition
 *  requester or dump a warning to the serial console or a FILE.
 * 
 *  This is thread safe and can be used within threads.
 * 
 *  Macros are included to make it easier to create/throw exceptions.
 *  
 *  @author Jürgen Schober
 *
 *  @date
 *      - 08/21/2006 initial
 *
 *  @changes
 *      - 08/21/2006 -js-
 */

#ifndef SPS_EXCEPTION_H_
#define SPS_EXCEPTION_H_

#include <stdio.h>

enum enErrCodes
{
    ERR_USER = 0x10000, // or for user errors 
    
    ERR_UNKNOWN = 0,    // undefined
    ERR_APP_EXISTS,     // application is already running
    ERR_OPEN_LIB,       // opening a library failed
    ERR_OPEN_IFACE,     // opening an interface failed
    ERR_OPEN_CATALOG,   // opening a locale catalog failed
    ERR_FILE_NOT_FOUND, // DOS error. file does not exist
    ERR_GUI,            // generic gui error
    ERR_GUI_MSG,        // gui error msg
    ERR_CX_IGNORE,      // commodity error
    ERR_CX_EXCEPTION,   // commodity error
    
    ERR_MAX_CODE        // max codes available
};

class SPS_Exception
{
    /* exceptions use their own ifaces to be thread safe */
    struct Library        * IntuitionBase;
    struct IntuitionIFace *IIntuition;
    
    struct Library        * UtilityBase;
    struct UtilityIFace   *IUtility;
    
protected:
    char *m_Title;
	char *m_File;
    int   m_Line;
	char *m_Message;
    int   m_Code;
    char *m_ButtonText;
public:
    /*! */
	SPS_Exception(const char *src_file, int src_line, int code, const char* message, const char* bt_text = NULL );
    /*! */
    ~SPS_Exception();

    /*! */
    void SetTitle( const char* title );
    
    /*! */
    void SetButtonText( const char *bt_text );

    /*! get the error message */
	void GetErrorText( int code, char *buffer, int len );
    /*! */
    const char* GetErrorText( int code  );
    /*! */
    const char* GetError( int code  );
    
    /*! */
    int GetErrorCode() { return m_Code; }
    
    /* print the error message to a give output stream */
	void  FPrintF( FILE* io = stderr );
    /*! */
	void  PrintF( );

    /*! show error dialog */
	int  Warn( const char* title = "SPS Error", const char* button_text = "Quit" );
};

#define Exc0( i, a )    SPS_Exception( __FILE__, __LINE__, i, a )
#define Exc1( a )       SPS_Exception( __FILE__, __LINE__, ERR_USER, a )
#define Exc2( a, b )    SPS_Exception( __FILE__, __LINE__, ERR_USER, a, b )
#define Exc3( i, a, b ) SPS_Exception( __FILE__, __LINE__, i, a, b )

#define Throw0()    throw SPS_Exception( __FILE__, __LINE__, ERR_UNKNOWN, "General Error" )
#define Throw1(a)   throw SPS_Exception( __FILE__, __LINE__, ERR_USER, a )
#define Throw2(i,a) throw SPS_Exception( __FILE__, __LINE__, i, a )

#endif /* SPS_EXCEPTION_H_ */

/*! @} sps */
