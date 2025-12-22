/************************************************************/
/*  	Parallel interface function (D0-D7) 		          **/
/************************************************************/
#pragma libcall IOBase io_AllocParPort 1e 0
#pragma libcall IOBase io_FreeParPort 24 0
#pragma libcall IOBase io_SetParDirA 2a 1002
#pragma libcall IOBase io_SetParDir 30 001
#pragma libcall IOBase io_WriteParA 36 1002
#pragma libcall IOBase io_WritePar 3c 001
#pragma libcall IOBase io_ReadParA 42 001
#pragma libcall IOBase io_ReadPar 48 0
#pragma libcall IOBase io_ResetPar 4e 0
/************************************************************/
/*	Parallel interface function (BUSY, POUT, SEL) 	      **/
/************************************************************/
#pragma libcall IOBase io_SetExtParDirA 54 1002
#pragma libcall IOBase io_SetExtParDir 5a 001
#pragma libcall IOBase io_WriteExtParA 60 1002
#pragma libcall IOBase io_WriteExtPar 66 001
#pragma libcall IOBase io_ReadExtParA 6c 001
#pragma libcall IOBase io_ResetExtPar 72 0
/************************************************************/
/*	Joyports interface functions (I/O)		              **/
/************************************************************/
#pragma libcall IOBase io_AllocJoyPort 78 0
#pragma libcall IOBase io_ReadJoy1A 7e 001
#pragma libcall IOBase io_ReadJoy2A 84 001
#pragma libcall IOBase io_ResetJoy1 8a 0
#pragma libcall IOBase io_ResetJoy2 90 0
#pragma libcall IOBase io_WriteJoy1A 96 1002
#pragma libcall IOBase io_WriteJoy2A 9c 1002
#pragma libcall IOBase io_WriteJoy1 a2 001
#pragma libcall IOBase io_WriteJoy2 a8 001
#pragma libcall IOBase io_SetJoy1DirA ae 1002
#pragma libcall IOBase io_SetJoy1Dir b4 001
#pragma libcall IOBase io_SetJoy2DirA ba 1002
#pragma libcall IOBase io_SetJoy2Dir c0 001
/************************************************************/
/*       Joyport interface functions (Joystick)		      **/
/************************************************************/
#pragma libcall IOBase io_ReadExtJoy1A c6 001
#pragma libcall IOBase io_ReadExtJoy1 cc 0
#pragma libcall IOBase io_ReadExtJoy2A d2 001
#pragma libcall IOBase io_ReadExtJoy2 d8 0
/************************************************************/
/*       Joyport interface functions (Mouse)		  		  **/
/************************************************************/
#pragma libcall IOBase io_ReadExtMouse1A de 001
#pragma libcall IOBase io_ReadExtMouse1 e4 0
#pragma libcall IOBase io_ReadExtMouse2A ea 001
#pragma libcall IOBase io_ReadExtMouse2 f0 0
/************************************************************/
/*	Serial interface functions			  				  **/
/************************************************************/
#pragma libcall IOBase io_SetSerBaud f6 21003
#pragma libcall IOBase io_ReadSer fc 0
#pragma libcall IOBase io_WriteSer 102 001
/**/
/* !WARNING! Not yet functionally!*/
/**/
/************************************************************/
/*	DrivePort interface functions			  			  **/
/************************************************************/
/**/
/* Reserved for the future :)*/
/**/
/************************************************************/
/*       Misc                                              **/
/************************************************************/
#pragma libcall IOBase io_WriteLed 108 001
/************************************************************/
