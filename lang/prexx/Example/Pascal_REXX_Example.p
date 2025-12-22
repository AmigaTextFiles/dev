{                In the name of Allah                 }
{  Example program to test Pascal_Rexx_Support.unit   }
{                                                     }
{Programmed by:                                       }
{     HOSSEIN SHIRDASHTZADEH                          }
{     All rights reserved (c) 1376-77 (1997-98)       }
{                                                     }
{Copyright notice:                                    }
{     You are NOT free to include this code in  your  }
{     software. Please read the PascalRexx.readme in  }
{     this archive for more information.              }
{                                                     }
{Email:                                               }
{       Shirdash@www.dci.co.ir                        }
{Snail:                                               }
{       No. 132                                       }
{       Kerdabad,Jey st.,                             }
{       Isfahan,                                      }
{       Iran                                          }
{       Zip code: 81599                               }
(*****************************************************)
{Compile notice:

        Please compile this example by
                Kick-Pascal or Maxon-Pascal
        Also note that you must have the unit:
             "Pascal_Rexx_Support"
        in correct unit path. (i.e. "Pascal_Rexx_Support.o"
        and "Pascal_Rexx_Support.u" files in "Kp:unit/".
}
(*****************************************************)
uses Pascal_Rexx_Support;


{$incl"rexxsyslib.lib"}

var
        rx_port,rx_port1:p_msgport;
        rx_msg:p_rexxmsg;
        stop:boolean;
        dummy:char;

begin
        reset(output,"Con:");
        input:=output;
        stop:=false;
        rx_port1:=Findport("SHIRDASHT");
        if rx_port1<>nil then
                begin
                {Sample rexx command to stop the privious rexx port}
                {and exit. Note: "STOP" is only for this program.}
                RX_msg:=CreateREXXMsg(RX_port1," "," ");
                RX_msg^.rm_ARGS[0]:="STOP";
                PUTMSG(RX_PORT1,p_message(RX_MSG));
                exit;
                end;

        rx_port:=rx_OpenPort("SHIRDASHT");

        writeln("Salaum!, I am now ready to get commands  through");
        writeln("         AREXX. Please run a rexx program  which");
        writeln("         addresses to 'SHIRDASHT' port and emits");
        writeln("         commands to me. I will stop if you send");
        writeln("         me 'STOP' or run another copy  of  this");
        writeln("         Program. Good lock!");

        if rx_port<>nil then
          begin
             while not stop do
             begin
             RX_msg:=wait_rexx_port(rx_port);
                if rx_msg<>nil then
                begin
                writeln("Salaum!, you wrote: ",RX_msg^.rm_args[0]);

                IF RX_msg^.rm_args[0]="STOP" then
                        Begin
                        writeln("END of you JOB!");
                        Stop:=true;
                        end;
                Reply_rexx_port(RX_msg);
                end;
             end;
          end;

        writeln("Press Return to exit...");
        read(dummy);
        rx_ClosePort(RX_Port);
        close(output);
end.







