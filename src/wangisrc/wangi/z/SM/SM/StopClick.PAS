{ stop the annoying drive clicks }
Procedure ToggleClick;

VAR
	td   : pIOExtTD;
	po   : pMsgPort;
	tpu  : pTDU_PublicUnit;
	uni  : byte;

Begin	
	if NOT state Then
		Exit;
	{ create a port }
	po := CreateMsgPort;
	if po <> NIL then Begin
		{ for each drive 0-3 }
		for uni := 0 to 4 do begin
			{ create an IORequest }
			td := pIOExtTD(CreateIORequest(po, sizeof(tIOExtTD)));
			if td <> NIL then begin
				{ IOrequest valid }
				if OpenDevice('trackdisk.device', uni, pIORequest(td), 0) = 0 then begin
					{ valid unit, so tell it to shut up }
					tpu := pTDU_PublicUnit(td^.iotd_Req.io_Unit);
					{ Stop Clicking NOW ! }
					tpu^.tdu_PubFlags := tpu^.tdu_PubFlags | TDPF_NOCLICK;
					CloseDevice(pIORequest(td));
				end;
				DeleteIORequest(pIORequest(td));
			end;
		end;
		DeleteMsgPort(po);
   end;
end;





