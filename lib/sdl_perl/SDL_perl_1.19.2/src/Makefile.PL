#!/usr/bin/env perl

#
# Supported OSes
#

%OS = (
	linux 	=> "Makefile.linux",
	win 	=> "Makefile.os4",
	freebsd => "Makefile.freebsd",
);

#
# Load applicable makefile
#

for (keys %OS ) {
	my $k = lc($_);
	require "$OS{$k}" && last if ($^O =~ /$k/);
}
