
#ifndef EXCEPTION_CPP
#define EXCEPTION_CPP

#include <Exception.h>
#include <string.h>

Exception::Exception(const char *message)
{
	int len = strlen(message);
	this->message = new char[len + 1];
	strcpy(this->message, message);
}

Exception::~Exception()
{
	if ( message != 0 )
	{
		delete message;
		message = 0;
	}
}

const char * Exception::GetMessage()
{
	return message;
}


#endif

