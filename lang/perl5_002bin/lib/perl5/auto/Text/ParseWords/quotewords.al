# NOTE: Derived from lib/Text/ParseWords.pm.  Changes made here will be lost.
package Text::ParseWords;

sub quotewords {
    local($delim, $keep, @lines) = @_;
    local(@words,$snippet,$field,$_);

    $_ = join('', @lines);
    while ($_) {
	$field = '';
	for (;;) {
            $snippet = '';
	    if (s/^"(([^"\\]|\\[\\"])*)"//) {
		$snippet = $1;
                $snippet = "\"$snippet\"" if ($keep);
	    }
	    elsif (s/^'(([^'\\]|\\[\\'])*)'//) {
		$snippet = $1;
                $snippet = "'$snippet'" if ($keep);
	    }
	    elsif (/^["']/) {
		croak "Unmatched quote";
	    }
            elsif (s/^\\(.)//) {
                $snippet = $1;
                $snippet = "\\$snippet" if ($keep);
            }
	    elsif (!$_ || s/^$delim//) {
               last;
	    }
	    else {
                while ($_ && !(/^$delim/ || /^['"\\]/)) {
		   $snippet .=  substr($_, 0, 1);
                   substr($_, 0, 1) = '';
                }
	    }
	    $field .= $snippet;
	}
	push(@words, $field);
    }
    @words;
}


1;
