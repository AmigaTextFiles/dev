print "OBJS= ";
for ($i = $#ARGV; $i >= 0; $i--)
{
    ($objs[$i] = $ARGV[$i]) =~ s/\.\w*$/\.o/;
}
&colprint(6, " ", @objs);
print "\n\n";

if (-f "lmkfile.base")
{
    open(BASE, "lmkfile.base");
    print while (<BASE>);
    close(BASE);
}

foreach $file (@ARGV)
{
    $dest = $file;
    $dest =~ s/\.\w*$/\.o/;
    if ($file =~ /\.c$/)
    {
	printf("%s: %s", $dest, $file);
	$colto = length($dest) + length($file) + 2;
	# Search for included files
	%seen = ();
	&included($file, 0);
	&colprint($colto, " ", keys(%seen));
	print "\n";
    }
    else
    {
	printf("%s: %s\n\n", $dest, $file);
    }
}

sub colprint
{
    local($colto, $sep, @names) = @_;
    $col = $colto;
    $sl = length($sep);
    foreach $name (@names)
    {
	$nl = length($name);
	if ($col + $nl + $sl > 78)
	{
	    print " \\\n", " " x $colto;
	    $col = $colto;
	}
	print $sep, $name;
	$col += $sl + $nl;
    }
}

sub included
{
    local($file, $input) = @_;
    $input++;
    if (!open($input, $file))
    {
	print STDERR "Can't open $file: $!\n";
	return;
    }
    while (<$input>)
    {
	if (/^#\s*include\s*"([^"]*)"/ && !$seen{$1} && -e $1)
        {
	    $seen{$1} = 1;
	    &included($1, $input);
	}
    }
    close($input);
}
