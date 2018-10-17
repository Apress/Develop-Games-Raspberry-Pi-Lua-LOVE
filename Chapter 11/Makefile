date := $(shell date +%Y.%m.%d)

release:
	zip battlejack-$(date).love -r *.lua deck.ini font img local snd || false

.PHONY:	release
