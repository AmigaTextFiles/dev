--
-- Tests the dynamic library loading feature
--
local path = "amigalua.library"
local f = assert( package.loadlib(path, "luaopen_amiga") )
f();

amiga.print("List of processes:")
total = amiga.processList()
io.write(total," total processes\n")
