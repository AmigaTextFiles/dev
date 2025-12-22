/* make sure we do not throw exceptions within exceptions! */
#define _NO_EXCEPTIONS

#include <sps/sps_exception.h>
#include <sps/sps_types.h>

#include <exec/memory.h>
#include <exec/types.h>
#include <intuition/intuition.h>

#include <proto/exec.h>
#include <proto/intuition.h>
#include <proto/utility.h>

#include <string.h>

struct err
{
    const char* code;
    const char* text;
} static cErrMsg[] = {
    { "ERR_UNKNOWN",          "Unknown Error" },
    { "ERR_APP_EXISTS",       "Application exists" },
    { "ERR_OPEN_LIB",         "Library <%s> open failed" },
    { "ERR_OPEN_IFACE",       "Interface <%s> not available" },
    { "ERR_OPEN_CATALOG",     "Catalog <%s> cannot be opened" },
    { "ERR_FILE_NOT_FOUND",   "File <%s> not found" },
    { "ERR_GUI",              "General GUI exception" },
    { "ERR_GUI",              NULL },
    { "ERR_CX_IGNORE",        NULL },
    { "ERR_CX_EXCEPTION",     "%s\nCommodity not available." }
};

SPS_Exception::SPS_Exception(const char *src_file, int src_line, 
                             int code, const char* message, 
                             const char* bt_text )
    :  IntuitionBase(NULL)
    , IIntuition(NULL)
    
    ,  UtilityBase(NULL)
    , IUtility(NULL)
     
    , m_Title(NULL)
    , m_File(NULL)
    , m_Line(src_line)
    , m_Message(NULL)
    , m_Code(code)
    , m_ButtonText(NULL)
{
    OPEN_IFACE( Utility,   UTILITYNAME, 50 );
    OPEN_IFACE( Intuition, "intuition.library", 50 );
    
    if ( message ) {
        m_Message = IUtility->ASPrintf( "%s", message );
    }
    if ( src_file ) {
        m_File = IUtility->ASPrintf( "%s", src_file );
    }
    SetTitle("SPS Error");
    SetButtonText( bt_text );
}

SPS_Exception::~SPS_Exception()
{
    if (m_Message   ) IExec->FreeVec( m_Message );
    if (m_ButtonText) IExec->FreeVec( m_ButtonText );
    
    CLOSE_IFACE( Utility );
    CLOSE_IFACE( Intuition );
}

void SPS_Exception::GetErrorText( int code, char* buffer, int len )
{
    IUtility->Strlcpy( buffer, GetErrorText( code ), len );
}

const char* SPS_Exception::GetErrorText( int code )
{
    if ( code >= 0 && code < ERR_MAX_CODE && cErrMsg[code].text)
    {
        return cErrMsg[code].text;
    }
    return "%s";
}

const char* SPS_Exception::GetError( int code )
{
    if ( code >= 0 && code < ERR_MAX_CODE && cErrMsg[code].code )
    {
        return cErrMsg[code].code;
    }
    return "ERR_USER";
}

void SPS_Exception::SetTitle( const char* title )
{
    if ( title ) {
        if ( m_Title) IExec->FreeVec( m_Title );
        m_Title = IUtility->ASPrintf( "%s", title );
    }
}

void SPS_Exception::SetButtonText( const char *bt_text )
{
    if ( bt_text ) {
        if ( m_ButtonText ) {
            IExec->FreeVec( m_ButtonText );
        }
        m_ButtonText = IUtility->ASPrintf( "%s", bt_text );
    }
}

void SPS_Exception::FPrintF( FILE* io )
{
    char *buffer = IUtility->ASPrintf( GetErrorText( m_Code ), m_Message );
    if ( buffer ) {
	    fprintf(io, "File: %s@ Line: %d\nException: %s\nError Code %d (%s)\n",m_File,m_Line,buffer,m_Code, GetError(m_Code));
        IExec->FreeVec( buffer );
    }
}
    
void SPS_Exception::PrintF( )
{
    char *buffer = IUtility->ASPrintf( GetErrorText( m_Code ), m_Message );
    if ( buffer ) {
	    IExec->DebugPrintF( "File: %s@ Line: %d\nException: %s\nError Code %d (%s)\n",m_File,m_Line,buffer,m_Code, GetError(m_Code));
        IExec->FreeVec( buffer );
    }
}

int SPS_Exception::Warn( const char* title, const char* button_text ) 
{
    int result = 0;
    const char *fmt = GetErrorText( m_Code );
    char *buffer = IUtility->ASPrintf( fmt, m_Message );
    if ( buffer == NULL ) {
        return 0;
    }
    fmt = "File: %s @ Line: %d\n"\
          "Exception: %s\nError Code: %d (%s)";
    const char *err = GetError( m_Code );
//    char *msg = IUtility->ASPrintf( fmt, m_File, m_Line, buffer, 
//                                         m_Code, err );
    char msg[1024];
    sprintf( msg, fmt, m_File, m_Line, buffer, m_Code, err);
    IExec->FreeVec( buffer );
    if ( msg == NULL ) {
        return 0;
    }
    if (title)       SetTitle( title );
    if (button_text) SetButtonText( button_text );
	struct EasyStruct easyReq =
   	{
   	    sizeof(struct EasyStruct),
        ESF_EVENSIZE,
   	    (STRPTR)m_Title,
        (STRPTR)msg,
   	    (STRPTR)m_ButtonText,
        NULL,
        NULL 
   	};   
    result = IIntuition->EasyRequest(NULL,&easyReq,NULL);
//    IExec->FreeVec( msg );
    
    return result;
}
