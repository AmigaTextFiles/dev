 {      File format for serial preferences }


{$I "Include:Libraries/IffParse.i"}

const
 ID_SERL = 1397051980;


Type
 SerialPrefs = Record
    sp_Reserved     : Array[0..2] of Integer;               { System reserved                  }
    sp_Unit0Map,                  { What unit 0 really refers to     }
    sp_BaudRate,                  { Baud rate                        }

    sp_InputBuffer,               { Input buffer: 0 - 65536          }
    sp_OutputBuffer : Integer;    { Future: Output: 0 - 65536        }

    sp_InputHandshake,            { Input handshaking                }
    sp_OutputHandshake,           { Future: Output handshaking       }

    sp_Parity,                    { Parity                           }
    sp_BitsPerChar,               { I/O bits per character           }
    sp_StopBits     : Byte;       { Stop bits                        }
 end;
 SerialPrefsPtr = ^SerialPrefs;

const
{ constants for SerialPrefs.sp_Parity }
 PARITY_NONE     = 0;
 PARITY_EVEN     = 1;
 PARITY_ODD      = 2;
 PARITY_MARK     = 3;               { Future enhancement }
 PARITY_SPACE    = 4;               { Future enhancement }

{ constants for SerialPrefs.sp_Input/OutputHandshaking }
 HSHAKE_XON      = 0;
 HSHAKE_RTS      = 1;
 HSHAKE_NONE     = 2;


