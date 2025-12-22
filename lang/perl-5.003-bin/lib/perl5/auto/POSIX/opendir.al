# NOTE: Derived from ../../lib/POSIX.pm.  Changes made here will be lost.
package POSIX;

sub opendir {
    usage "opendir(directory)" if @_ != 1;
    my $dirhandle = gensym;
    opendir($dirhandle, $_[0])
	? $dirhandle
	: undef;
}

1;
