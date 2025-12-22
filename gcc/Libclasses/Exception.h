

#ifndef EXCEPTION_H
#define EXCEPTION_H

class Exception
{
public:
	Exception(const char *message);
	~Exception();

	const char * GetMessage();

private:
	char *message;
};

#endif

