$(path)foo : ; @echo cp $^ $@

foo\ bar: ; @echo 'touch "$@"'

sharp: foo\#bar.ext
foo\#bar.ext: ; @echo foo\#bar.ext = '$@'
