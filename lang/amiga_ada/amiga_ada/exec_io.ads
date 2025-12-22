with Interfaces; use Interfaces;

with exec_Ports; use exec_Ports;

with Incomplete_type; use Incomplete_type;

package exec_io is

type IORequest;
type IORequest_Ptr is access IORequest;
type IORequest is record
 io_Message : Message ;
 io_Device : Device_Ptr; 
 io_Unit : Unit_Ptr;	 
 io_Command : Unsigned_16;	 
 io_Flags : Unsigned_8;
 io_Error : Integer_8;
end record;

type IOStdReq;
type IOStdReq_Ptr is access IOStdReq;
type IOStdReq is record
  io_Message : Message;
  io_Device : Device_Ptr; 
 io_Unit : Unit_Ptr;	 
 io_Command : Unsigned_16;
 io_Flags : Unsigned_8;
 io_Error : Integer_8;
 io_Actual : Unsigned_32;
 io_Length : Unsigned_32;
 io_Data : Integer_Ptr;
 io_Offset : Unsigned_32;
end record;

DEV_BEGINIO : constant Integer := (-30);
DEV_ABORTIO : constant Integer := (-36);
IOB_QUICK : constant Integer := 0;
IOF_QUICK : constant Integer := (2**0);
CMD_INVALID : constant Integer := 0;
CMD_RESET : constant Integer := 1;
CMD_READ : constant Integer := 2;
CMD_WRITE : constant Integer := 3;
CMD_UPDATE : constant Integer := 4;
CMD_CLEAR : constant Integer := 5;
CMD_STOP : constant Integer := 6;
CMD_START : constant Integer := 7;
CMD_FLUSH : constant Integer := 8;
CMD_NONSTD : constant Integer := 9;

end exec_io;