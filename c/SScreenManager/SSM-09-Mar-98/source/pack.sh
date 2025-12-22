
failat 20
echo "xxx" >t:temp
set dest ram:SSM-`list t:temp dates lformat "%d"`
delete >nil: t:temp
makedir $dest

copy StormScreenManager $dest
copy StormScreenManager.info $dest

copy Catalogs $dest/Catalogs all quiet

makedir $dest/source
copy StormScreenManager.¶ $dest/source
copy StormScreenManager.¶.info $dest/source
copy #?.(c|cpp|h|wizard|cd|ct|srx|sh) $dest/source
copy #?_ver.txt $dest/source
copy #?_rev.rev $dest/source
copy ToDo.txt $dest/source
copy Developer.readme $dest/source

delete ram:$dest.lha quiet
lha -r a $dest.lha $dest
