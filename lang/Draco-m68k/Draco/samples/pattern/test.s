copy pattern.g       drinc:
copy pattern.lib     drlib:
copy pattern.library libs:

draco test.d
BLink WITH test.w
delete test.r
