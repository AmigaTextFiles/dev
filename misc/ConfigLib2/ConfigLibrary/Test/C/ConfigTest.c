/*
** ConfigTest.c
**
** $VER: ConfigTest.c 2.0 (7.9.96)
**
** Copyright (C) 1996, Adam Dawes
**
** Refer to accompanying documentation for further details
*/


#include <clib/exec_protos.h>

#include <stdio.h>
#include <stdlib.h>

#include <libraries/config.h>
#include <proto/config.h>


void main()
{
	struct ConfigBase *ConfigBase = NULL;
	long result;
	char prefbuffer[50];
	char filename[] = {"RAM:ConfigTest.cfg"};


	ConfigBase = OpenLibrary("config.library", 2);
	if (!ConfigBase)
	{
		printf("Unable to open config.library v2.0\n");
		exit(20);
	}



	printf("Writing some data to the config file (%s)...\n",filename);

	result = WriteConfig(filename,"Test section","Name","Adam Dawes");
	result = WriteConfig(filename,"Test section","Town","Brighton");
	result = WriteConfig(filename,"Test section","Country","England");

	result = WriteConfig(filename,"Load file","Path","SYS:");
	result = WriteConfig(filename,"Load file","Name","Test.dat");
	result = WriteConfigNumber(filename,"Load file","Access count",17);

	result = WriteConfig(filename,"Save file","Path","RAM:");
	result = WriteConfig(filename,"Save file","Name","Test2.dat");
	result = WriteConfigNumber(filename,"Save file","Access count",4);


	printf("\nReading the data back...\n\n");

	result = ReadConfig(filename,"Test section","Name",prefbuffer,50,"(unknown)");
	printf("Name: %s\n",prefbuffer);
	result = ReadConfig(filename,"Test section","Town",prefbuffer,50,"(unknown)");
	printf("Town: %s\n",prefbuffer);
	result = ReadConfig(filename,"Test section","Country",prefbuffer,50,"(unknown)");
	printf("Country: %s\n",prefbuffer);
	result = ReadConfig(filename,"Test section","Telephone number",prefbuffer,50,"(unknown)");
	printf("Telephone: %s\n",prefbuffer);

	printf("\nLoad file:\n");
	result = ReadConfig(filename,"Load file","Path",prefbuffer,50,"");
	printf("  Path: %s\n",prefbuffer);
	result = ReadConfig(filename,"Load file","Name",prefbuffer,50,"");
	printf("  Name: %s\n",prefbuffer);
	result = ReadConfigNumber(filename,"Load file","Access count",0);
	printf("  Access count: %d\n",result);

	printf("\nSave file:\n");
	result = ReadConfig(filename,"Save file","Path",prefbuffer,50,"");
	printf("  Path: %s\n",prefbuffer);
	result = ReadConfig(filename,"Save file","Name",prefbuffer,50,"");
	printf("  Name: %s\n",prefbuffer);
	result = ReadConfigNumber(filename,"Save file","Access count",0);
	printf("  Access count: %d\n",result);


	printf("\nChanging the data...\n");

	result = WriteConfig(filename,"Save file","Path","T:");
	result = WriteConfig(filename,"Save file","Name","AnotherTest.dat");


	printf("\nReading the data again...\n");

	printf("\nSave file:\n");
	result = ReadConfig(filename,"Save file","Path",prefbuffer,50,"");
	printf("  Path: %s\n",prefbuffer);
	result = ReadConfig(filename,"Save file","Name",prefbuffer,50,"");
	printf("  Name: %s\n",prefbuffer);
	result = ReadConfigNumber(filename,"Save file","Access count",0);
	printf("  Access count: %d\n",result);


	printf("\nFinished.\n");


	CloseLibrary(ConfigBase);
}

