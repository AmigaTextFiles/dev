
  { ********************************** }
  { * Includefile f. Pointer.library * }
  { ********************************** }

Const
	PointerName = "pointer.library";

Var
	PointerBase : Address;

Type
MousePointer = record
	Data : Address;
	Height,
	Width,
	XOff,
	YOff,
	Size : Integer;
End;
MousePointerPtr = ^MousePointer;


Procedure SetBusyPointer( Win : WindowPtr );
	External;

Function  LoadPointer( filename : String ): MousePointerPtr;
	External;

Procedure FreePointer( OldPointer : MousePointerPtr );
	External;

