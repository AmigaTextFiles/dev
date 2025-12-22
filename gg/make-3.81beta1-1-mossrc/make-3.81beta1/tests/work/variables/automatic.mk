dir = ../tests
.SUFFIXES:
.SUFFIXES: .x .y .z
$(dir)/foo.x : baz.z $(dir)/bar.y baz.z
	@echo '$$@ = $@, $$(@D) = $(@D), $$(@F) = $(@F)'
	@echo '$$* = $*, $$(*D) = $(*D), $$(*F) = $(*F)'
	@echo '$$< = $<, $$(<D) = $(<D), $$(<F) = $(<F)'
	@echo '$$^ = $^, $$(^D) = $(^D), $$(^F) = $(^F)'
	@echo '$$+ = $+, $$(+D) = $(+D), $$(+F) = $(+F)'
	@echo '$$? = $?, $$(?D) = $(?D), $$(?F) = $(?F)'
	touch $@

$(dir)/bar.y baz.z : ; touch $@
