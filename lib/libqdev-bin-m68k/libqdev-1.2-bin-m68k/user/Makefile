#
# 'qdev'
# by Burnt Chip Dominators
#
LOCALTARGETS =                         \
               template-0.0

ALLTARGETS = $(LOCALTARGETS)


all: targets

$(ALLTARGETS):
	make -C $@

targets: $(ALLTARGETS)

.PHONY: targets $(ALLTARGETS)

clean:
	@for x in $(LOCALTARGETS); do  \
	make -C $$x clean;             \
	done

cleanall:
	@for x in $(LOCALTARGETS); do  \
	make -C $$x cleanall;          \
	done
