CC = cc
INCLUDE = -I./3rdparty/include
LIBS = $(shell pkg-config --cflags --libs raylib) -lm
CFLAGS = -O2 -Wall -Wpedantic -march=native -flto=auto $(INCLUDE) $(LIBS)
OBJ = brickout.o

brickout: deps mksettings $(OBJ)
	$(CC) $(CFLAGS) -o brickout $(OBJ)

mksettings:
	test -f settings.h || make defaults

brickout.o: settings.h

deps:
	mkdir -p 3rdparty/include
	test -f 3rdparty/include/raygui.h || curl -fL -o 3rdparty/include/raygui.h https://raw.githubusercontent.com/raysan5/raygui/25c8c65a6e5f0f4d4b564a0343861898c6f2778b/src/raygui.h

updatedeps:
	rm -f 3rdparty/include/raygui.h 
	make deps

tarball:
	mkdir brickout
	cp LICENSE.md README.md brickout.c settings.h brickout/
	tar czvf brickout.tar.gz brickout
	rm -rf brickout

defaults:
	rm -f settings.h
	cp settings.def.h settings.h

clean:
	rm -rf brickout brickout.tar.gz brickout $(OBJ)
	rm -f 3rdparty/include/*

cleanall: clean defaults

.PHONY: clean cleanall
