
FD3(41,void,SendPkt,struct DosPacket *packet,D1,struct Msgport *port,D2,struct MsgPort *replyport,D3)
{
  packet->dp_Port=replyport;
  PutMsg(port,packet->dp_Link);
}

typedef struct __2 { LONG L0,L1 } LONG2;

FD7(40,DLONG,DoPkt,struct MsgPort *port,D1,LONG action,D2,LONG arg1,D3,LONG arg2,D4,LONG arg3,D5,LONG arg4,D6,LONG arg5,D7)
{
  struct DosPacket *dp;
  struct TagItem nt[1];
  unsigned long r1,r2;

  nt[0].ti_Tag=TAG_END;
  if(!(dp=AllocDosObject(DOS_STDPKT,nt)))
  {
    RETURN_DLONG(DOSFALSE,ERROR_NO_FREE_STORE);
  }
  dp->dp_Type=action;
  dp->dp_Arg1=arg1;
  dp->dp_Arg2=arg2;
  dp->dp_Arg3=arg3;
  dp->dp_Arg4=arg4;
  dp->dp_Arg5=arg5;
  if(SysBase->ThisTask->tc_Node.ln_Type==NT_PROCESS)
    dp->Res2=IoErr();
  if(SysBase->ThisTask->tc_Node.ln_Type==NT_TASK)
  {
    struct MsgPort *rp;
    if(!(rp=CreateMsgPort()))
    {
      dp->dp_Res1=DOSFALSE;
      dp->dp_Res2=ERROR_NO_FREE_STORE;
    }else
    {
      SendPkt(dp,port,rp);
      WaitPort(rp);
      GetMsg(rp);
      DeleteMsgPort(rp);
    }
  }else
  {
    SendPkt(dp,port,&((struct Process *)SysBase->ThisTask)->pr_MsgPort);
    WaitPkt();
  }
  r1=dp->dp_Res1;
  r2=dp->dp_Res2;
  if(SysBase->ThisTask->tc_Node.ln_Type==NT_PROCESS)
    SetIoErr(dp->Res2);
  FreeDosObject(DOS_STDPKT,dp);
  RETURN_DLONG(r1,r2);
}
