
{
	exec/devices.i
}

{$I "Include:exec/libraries.i" }
{$I "Include:exec/ports.i"     }

TYPE

{***** Device *****************************************************}

  Device = record
    dd_Library : Library;
  end;
  DevicePtr = ^Device;

{***** Unit *******************************************************}

Unit = record
    unit_MsgPort : MsgPort;		{ queue for unprocessed messages }
					{ instance of msgport is recommended }
    unit_flags,
    unit_pad     : Byte;
    unit_OpenCnt : Short;		{ number of active opens }
end;

Const
  UNITF_ACTIVE	= %00000001;
  UNITF_INTASK	= %00000010;





Procedure AddDevice(device : DevicePtr);
    External;

Procedure CloseDevice(io : Address);	{ io is an IORequestPtr }
    External;

Function OpenDevice(devName : String; unitNumber : Integer;
			io : Address; flags : Integer) : Integer;
    External;	{ io is an IORequestPtr }

Procedure RemDevice(device : DevicePtr);
    External;



