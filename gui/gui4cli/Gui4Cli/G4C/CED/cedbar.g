G4C

; Accompanying GUI to cedbar.gc
; This is the GUI for the small size of the cedbar


WinBig 600 0 30 14 ""
WinType 000010
usetopaz
varpath cedbar.gc/cedmark.g

xOnRMB
GuiClose cedbar.g
GuiOpen cedbar.gc

xIcon 0 1 :icons/left
GuiClose cedbar.g
GuiOpen cedbar.gc

xIcon 15 0 :icons/wnClose
GuiClose cedbar.g

