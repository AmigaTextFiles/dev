$i=int(0);
$x=0,$y=0.1,$z=0.11,$w=0.0;
$s="";
while($i++<100000)
{
    $w=$w+$x+$y+$z;
    $s.="ab";
}
print "hello, world. w=$w strlen(s)=".length($s)."\n";
