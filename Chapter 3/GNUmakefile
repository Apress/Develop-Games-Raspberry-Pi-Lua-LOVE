clean:
	@rm blackjack.love || true
	@echo "Clean."

game:
	@zip blackjack.love -r *.lua font img || false

play: game.love
	@love ./blackjack.love

all:	clean game play

help:
	@echo "make clean: remove game.love"
	@echo "make game:  make a fresh game.love file"
	@echo "make play:  play game.love"
	@echo ""
	@echo "make all:   make clean game play"
