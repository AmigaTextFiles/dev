; install new presets (%0%: language)

INSTALL PRESET="presets/hollywood.context"
INSTALL PRESET="presets/hollywood.dictionary"
INSTALL PRESET="presets/hollywood.keyboard"
INSTALL PRESET="presets/hollywood.templates"
INSTALL PRESET="presets/hollywood.syntax"
INSTALL PRESET="presets/hollywood.structure"
INSTALL PRESET="presets/hollywood.references"
INSTALL PRESET="presets/hollywood.misc"
INSTALL PRESET="presets/hollywood.interface"
INSTALL PRESET="presets/%0%/hollywood.api"
INSTALL PRESET="presets/%0%/hollywood.menu"
INSTALL PRESET="presets/%0%/hollywood.gadgets"
INSTALL PRESET="presets/%0%/hollywood.mouse"

; install new filetype

FILETYPE ADD="#?.hws" PRI=127 PRESETS "hollywood.context" "hollywood.dictionary" "hollywood.keyboard" "hollywood.templates" "hollywood.syntax" "hollywood.structure" "hollywood.references" "hollywood.misc" "hollywood.api" "hollywood.gadgets" "hollywood.menu" "hollywood.mouse" "hollywood.interface" NAME="Hollywood" ACTIVATION="SET TYPE VALUE=*".hws*""

:uninstall

UNINSTALL FILETYPE="Hollywood"

UNINSTALL BASEDIR="golded:add-ons/hollywood"
