# NOTE: Derived from ../../lib/POSIX.pm.  Changes made here will be lost.
package POSIX;

sub fstat {
    usage "fstat(fd)" if @_ != 1;
    local *TMP;
    open(TMP, "<&$_[0]");		# Gross.
    my @l = stat(TMP);
    close(TMP);
    @l;
}

1;
