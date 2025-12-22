ira >NIL: -a -M68040 c:AddBuffers
echo >>error "AddBuffers"
phxass >>error1 -n AddBuffers.asm
phxlnk AddBuffers.o
ira >NIL: -a -M68040 AddBuffers AddBuffers.s
fdiff >>error AddBuffers.asm AddBuffers.s
del >NIL: AddBuffers#?

ira >NIL: -a -M68040 c:Assign
echo >>error "Assign"
phxass >>error1 -n Assign.asm
phxlnk Assign.o
ira >NIL: -a -M68040 Assign Assign.s
fdiff >>error Assign.asm Assign.s
del >NIL: Assign#?

ira >NIL: -a -M68040 c:BindDrivers
echo >>error "BindDrivers"
phxass >>error1 -n BindDrivers.asm
phxlnk BindDrivers.o
ira >NIL: -a -M68040 BindDrivers BindDrivers.s
fdiff >>error BindDrivers.asm BindDrivers.s
del >NIL: BindDrivers#?

ira >NIL: -a -M68040 c:ChangeTaskPri
echo >>error "ChangeTaskPri"
phxass >>error1 -n ChangeTaskPri.asm
phxlnk ChangeTaskPri.o
ira >NIL: -a -M68040 ChangeTaskPri ChangeTaskPri.s
fdiff >>error ChangeTaskPri.asm ChangeTaskPri.s
del >NIL: ChangeTaskPri#?

ira >NIL: -a -M68040 c:Copy
echo >>error "Copy"
phxass >>error1 -n Copy.asm
phxlnk Copy.o
ira >NIL: -a -M68040 Copy Copy.s
fdiff >>error Copy.asm Copy.s
del >NIL: Copy#?

ira >NIL: -a -M68040 c:Date
echo >>error "Date"
phxass >>error1 -n Date.asm
phxlnk Date.o
ira >NIL: -a -M68040 Date Date.s
fdiff >>error Date.asm Date.s
del >NIL: Date#?

ira >NIL: -a -M68040 c:Dir
echo >>error "Dir"
phxass >>error1 -n Dir.asm
phxlnk Dir.o
ira >NIL: -a -M68040 Dir Dir.s
fdiff >>error Dir.asm Dir.s
del >NIL: Dir#?

ira >NIL: -a -M68040 c:DiskDoctor
echo >>error "DiskDoctor"
phxass >>error1 -n DiskDoctor.asm
phxlnk DiskDoctor.o
ira >NIL: -a -M68040 DiskDoctor DiskDoctor.s
fdiff >>error DiskDoctor.asm DiskDoctor.s
del >NIL: DiskDoctor#?

ira >NIL: -a -M68040 c:Edit
echo >>error "Edit"
phxass >>error1 -n Edit.asm
phxlnk Edit.o
ira >NIL: -a -M68040 Edit Edit.s
fdiff >>error Edit.asm Edit.s
del >NIL: Edit#?

ira >NIL: -a -M68040 c:Execute
echo >>error "Execute"
phxass >>error1 -n Execute.asm
phxlnk Execute.o
ira >NIL: -a -M68040 Execute Execute.s
fdiff >>error Execute.asm Execute.s
del >NIL: Execute#?

ira >NIL: -a -M68040 c:IconX
echo >>error "IconX"
phxass >>error1 -n IconX.asm
phxlnk IconX.o
ira >NIL: -a -M68040 IconX IconX.s
fdiff >>error IconX.asm IconX.s
del >NIL: IconX#?

ira >NIL: -a -M68040 c:Install
echo >>error "Install"
phxass >>error1 -n Install.asm
phxlnk Install.o
ira >NIL: -a -M68040 Install Install.s
fdiff >>error Install.asm Install.s
del >NIL: Install#?

ira >NIL: -a -M68040 c:Join
echo >>error "Join"
phxass >>error1 -n Join.asm
phxlnk Join.o
ira >NIL: -a -M68040 Join Join.s
fdiff >>error Join.asm Join.s
del >NIL: Join#?

ira >NIL: -a -M68040 c:LoadWB
echo >>error "LoadWB"
phxass >>error1 -n LoadWB.asm
phxlnk LoadWB.o
ira >NIL: -a -M68040 LoadWB LoadWB.s
fdiff >>error LoadWB.asm LoadWB.s
del >NIL: LoadWB#?

ira >NIL: -a -M68040 c:MagTape
echo >>error "MagTape"
phxass >>error1 -n MagTape.asm
phxlnk MagTape.o
ira >NIL: -a -M68040 MagTape MagTape.s
fdiff >>error MagTape.asm MagTape.s
del >NIL: MagTape#?

ira >NIL: -a -M68040 c:MakeLink
echo >>error "MakeLink"
phxass >>error1 -n MakeLink.asm
phxlnk MakeLink.o
ira >NIL: -a -M68040 MakeLink MakeLink.s
fdiff >>error MakeLink.asm MakeLink.s
del >NIL: MakeLink#?

ira >NIL: -a -M68040 c:muchmore
echo >>error "muchmore"
phxass >>error1 -n muchmore.asm
phxlnk muchmore.o
ira >NIL: -a -M68040 muchmore muchmore.s
fdiff >>error muchmore.asm muchmore.s
del >NIL: muchmore#?

ira >NIL: -a -M68040 c:Relabel
echo >>error "Relabel"
phxass >>error1 -n Relabel.asm
phxlnk Relabel.o
ira >NIL: -a -M68040 Relabel Relabel.s
fdiff >>error Relabel.asm Relabel.s
del >NIL: Relabel#?

ira >NIL: -a -M68040 c:Rename
echo >>error "Rename"
phxass >>error1 -n Rename.asm
phxlnk Rename.o
ira >NIL: -a -M68040 Rename Rename.s
fdiff >>error Rename.asm Rename.s
del >NIL: Rename#?

ira >NIL: -a -M68040 c:RequestFile
echo >>error "RequestFile"
phxass >>error1 -n RequestFile.asm
phxlnk RequestFile.o
ira >NIL: -a -M68040 RequestFile RequestFile.s
fdiff >>error RequestFile.asm RequestFile.s
del >NIL: RequestFile#?

ira >NIL: -a -M68040 c:SetClock
echo >>error "SetClock"
phxass >>error1 -n SetClock.asm
phxlnk SetClock.o
ira >NIL: -a -M68040 SetClock SetClock.s
fdiff >>error SetClock.asm SetClock.s
del >NIL: SetClock#?

ira >NIL: -a -M68040 c:SetFont
echo >>error "SetFont"
phxass >>error1 -n SetFont.asm
phxlnk SetFont.o
ira >NIL: -a -M68040 SetFont SetFont.s
fdiff >>error SetFont.asm SetFont.s
del >NIL: SetFont#?

ira >NIL: -a -M68040 c:SetPatch
echo >>error "SetPatch"
phxass >>error1 -n SetPatch.asm
phxlnk SetPatch.o
ira >NIL: -a -M68040 SetPatch SetPatch.s
fdiff >>error SetPatch.asm SetPatch.s
del >NIL: SetPatch#?

ira >NIL: -a -M68040 c:Status
echo >>error "Status"
phxass >>error1 -n Status.asm
phxlnk Status.o
ira >NIL: -a -M68040 Status Status.s
fdiff >>error Status.asm Status.s
del >NIL: Status#?

ira >NIL: -a -M68040 c:Version
echo >>error "Version"
phxass >>error1 -n Version.asm
phxlnk Version.o
ira >NIL: -a -M68040 Version Version.s
fdiff >>error Version.asm Version.s
del >NIL: Version#?

ira >NIL: -a -M68040 c:Which
echo >>error "Which"
phxass >>error1 -n Which.asm
phxlnk Which.o
ira >NIL: -a -M68040 Which Which.s
fdiff >>error Which.asm Which.s
del >NIL: Which#?

ira >NIL: -a -M68040 c:AddDataTypes
echo >>error "AddDataTypes"
phxass >>error1 -n AddDataTypes.asm
phxlnk AddDataTypes.o
ira >NIL: -a -M68040 AddDataTypes AddDataTypes.s
fdiff >>error AddDataTypes.asm AddDataTypes.s
del >NIL: AddDataTypes#?

ira >NIL: -a -M68040 c:Avail
echo >>error "Avail"
phxass >>error1 -n Avail.asm
phxlnk Avail.o
ira >NIL: -a -M68040 Avail Avail.s
fdiff >>error Avail.asm Avail.s
del >NIL: Avail#?

ira >NIL: -a -M68040 c:Break
echo >>error "Break"
phxass >>error1 -n Break.asm
phxlnk Break.o
ira >NIL: -a -M68040 Break Break.s
fdiff >>error Break.asm Break.s
del >NIL: Break#?

ira >NIL: -a -M68040 c:ConClip
echo >>error "ConClip"
phxass >>error1 -n ConClip.asm
phxlnk ConClip.o
ira >NIL: -a -M68040 ConClip ConClip.s
fdiff >>error ConClip.asm ConClip.s
del >NIL: ConClip#?

ira >NIL: -a -M68040 c:CPU
echo >>error "CPU"
phxass >>error1 -n CPU.asm
phxlnk CPU.o
ira >NIL: -a -M68040 CPU CPU.s
fdiff >>error CPU.asm CPU.s
del >NIL: CPU#?

ira >NIL: -a -M68040 c:delete
echo >>error "delete"
phxass >>error1 -n delete.asm
phxlnk delete.o
ira >NIL: -a -M68040 delete delete.s
fdiff >>error delete.asm delete.s
del >NIL: delete#?

ira >NIL: -a -M68040 c:DiskChange
echo >>error "DiskChange"
phxass >>error1 -n DiskChange.asm
phxlnk DiskChange.o
ira >NIL: -a -M68040 DiskChange DiskChange.s
fdiff >>error DiskChange.asm DiskChange.s
del >NIL: DiskChange#?

ira >NIL: -a -M68040 c:Ed
echo >>error "Ed"
phxass >>error1 -n Ed.asm
phxlnk Ed.o
ira >NIL: -a -M68040 Ed Ed.s
fdiff >>error Ed.asm Ed.s
del >NIL: Ed#?

ira >NIL: -a -M68040 c:Eval
echo >>error "Eval"
phxass >>error1 -n Eval.asm
phxlnk Eval.o
ira >NIL: -a -M68040 Eval Eval.s
fdiff >>error Eval.asm Eval.s
del >NIL: Eval#?

ira >NIL: -a -M68040 c:Filenote
echo >>error "Filenote"
phxass >>error1 -n Filenote.asm
phxlnk Filenote.o
ira >NIL: -a -M68040 Filenote Filenote.s
fdiff >>error Filenote.asm Filenote.s
del >NIL: Filenote#?

ira >NIL: -a -M68040 c:Info
echo >>error "Info"
phxass >>error1 -n Info.asm
phxlnk Info.o
ira >NIL: -a -M68040 Info Info.s
fdiff >>error Info.asm Info.s
del >NIL: Info#?

ira >NIL: -a -M68040 c:IPrefs
echo >>error "IPrefs"
phxass >>error1 -n IPrefs.asm
phxlnk IPrefs.o
ira >NIL: -a -M68040 IPrefs IPrefs.s
fdiff >>error IPrefs.asm IPrefs.s
del >NIL: IPrefs#?

ira >NIL: -a -M68040 c:List
echo >>error "List"
phxass >>error1 -n List.asm
phxlnk List.o
ira >NIL: -a -M68040 List List.s
fdiff >>error List.asm List.s
del >NIL: List#?

ira >NIL: -a -M68040 c:Lock
echo >>error "Lock"
phxass >>error1 -n Lock.asm
phxlnk Lock.o
ira >NIL: -a -M68040 Lock Lock.s
fdiff >>error Lock.asm Lock.s
del >NIL: Lock#?

ira >NIL: -a -M68040 c:MakeDir
echo >>error "MakeDir"
phxass >>error1 -n MakeDir.asm
phxlnk MakeDir.o
ira >NIL: -a -M68040 MakeDir MakeDir.s
fdiff >>error MakeDir.asm MakeDir.s
del >NIL: MakeDir#?

ira >NIL: -a -M68040 c:Mount
echo >>error "Mount"
phxass >>error1 -n Mount.asm
phxlnk Mount.o
ira >NIL: -a -M68040 Mount Mount.s
fdiff >>error Mount.asm Mount.s
del >NIL: Mount#?

ira >NIL: -a -M68040 c:Protect
echo >>error "Protect"
phxass >>error1 -n Protect.asm
phxlnk Protect.o
ira >NIL: -a -M68040 Protect Protect.s
fdiff >>error Protect.asm Protect.s
del >NIL: Protect#?

ira >NIL: -a -M68040 c:RemRAD
echo >>error "RemRAD"
phxass >>error1 -n RemRAD.asm
phxlnk RemRAD.o
ira >NIL: -a -M68040 RemRAD RemRAD.s
fdiff >>error RemRAD.asm RemRAD.s
del >NIL: RemRAD#?

ira >NIL: -a -M68040 c:RequestChoice
echo >>error "RequestChoice"
phxass >>error1 -n RequestChoice.asm
phxlnk RequestChoice.o
ira >NIL: -a -M68040 RequestChoice RequestChoice.s
fdiff >>error RequestChoice.asm RequestChoice.s
del >NIL: RequestChoice#?

ira >NIL: -a -M68040 c:Search
echo >>error "Search"
phxass >>error1 -n Search.asm
phxlnk Search.o
ira >NIL: -a -M68040 Search Search.s
fdiff >>error Search.asm Search.s
del >NIL: Search#?

ira >NIL: -a -M68040 c:SetDate
echo >>error "SetDate"
phxass >>error1 -n SetDate.asm
phxlnk SetDate.o
ira >NIL: -a -M68040 SetDate SetDate.s
fdiff >>error SetDate.asm SetDate.s
del >NIL: SetDate#?

ira >NIL: -a -M68040 c:SetKeyboard
echo >>error "SetKeyboard"
phxass >>error1 -n SetKeyboard.asm
phxlnk SetKeyboard.o
ira >NIL: -a -M68040 SetKeyboard SetKeyboard.s
fdiff >>error SetKeyboard.asm SetKeyboard.s
del >NIL: SetKeyboard#?

ira >NIL: -a -M68040 c:Sort
echo >>error "Sort"
phxass >>error1 -n Sort.asm
phxlnk Sort.o
ira >NIL: -a -M68040 Sort Sort.s
fdiff >>error Sort.asm Sort.s
del >NIL: Sort#?

ira >NIL: -a -M68040 c:Type
echo >>error "Type"
phxass >>error1 -n Type.asm
phxlnk Type.o
ira >NIL: -a -M68040 Type Type.s
fdiff >>error Type.asm Type.s
del >NIL: Type#?

ira >NIL: -a -M68040 c:Wait
echo >>error "Wait"
phxass >>error1 -n Wait.asm
phxlnk Wait.o
ira >NIL: -a -M68040 Wait Wait.s
fdiff >>error Wait.asm Wait.s
del >NIL: Wait#?

