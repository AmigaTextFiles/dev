FailAt 21
Cd Lib:
MakeDir LibStubs
MakeDir LibStubs/Gateway
MakeDir LibStubs/GateXpr
MakeDir LibStubs/IntuiSup
MakeDir LibStubs/ReqTools
MakeDir LibStubs/MMU
MakeDir LibStubs/PowerPC
MakeDir LibStubs/PPC
MakeDir LibStubs/PPCt

Execute Pmm:Batch/_Gateway_Fd_Script
Execute Pmm:Batch/MakeStubLib.s Gateway Proj:Library/Fd/Gateway_lib.FD
Execute Pmm:Batch/MakeStubLib.s GateXpr Proj:Library/Fd/GateXpr_lib.FD
Execute Pmm:Batch/MakeStubLib.s IntuiSup FD:IntuiSup.FD
Execute Pmm:Batch/MakeStubLib.s ReqTools FD:ReqTools_lib.FD
Execute Pmm:Batch/MakeStubLib.s MMU FD:MMU_lib.FD
Execute Pmm:Batch/MakeStubLib.s PowerPC FD:PowerPC_lib.FD
Execute Pmm:Batch/MakeStubLib.s PPC FD:PPC_lib.FD
Execute Pmm:Batch/MakeStubLib.s PPCt FD:PPCt_lib.FD
