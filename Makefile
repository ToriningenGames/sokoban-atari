
OBJSRC := init.asm kernel.asm
LIBSRC := logic.asm graphics.asm levels.asm

bin/sokoban.a26 : $(addprefix obj/,$(OBJSRC:.asm=.obj)) $(addprefix lib/,$(LIBSRC:.asm=.lib)) link.link | bin
	wlalink -S -v -A -L lib link.link $@

clean :
	$(RM) -r dep obj lib bin link.link levels/*.ask src/levels.asm

link.link : $(addprefix src/,$(OBJSRC) $(LIBSRC))
	{ \
		echo [objects] > $@ ;\
		for f in $(addprefix obj/,$(OBJSRC:.asm=.obj)) ; do \
			echo $$f >> $@ ;\
		done ;\
		echo [libraries] >> $@ ;\
		for f in $(addprefix lib/,$(LIBSRC:.asm=.lib)) ; do \
			echo bank 0 slot 0 $$f >> $@ ;\
		done ;\
	}

levels/%.ask : levels/%.sok bin/pack bin/unpack
	bin/pack < $< > $@

obj/%.obj : src/%.asm dep/%.d | src dep obj
	wla-6502 -M -I inc -I src $< > $(word 2,$^)
	wla-6502 -v -I inc -I src -o $@ $<
lib/%.lib : src/%.asm dep/%.d | src dep lib
	wla-6502 -M -I inc -I src -l $@ $< > $(word 2,$^)
	wla-6502 -v -I inc -I src -l $@ $<

bin/pack : src/converter/pack.c | bin
	$(CC) $(CPPFLAGS) $(CFLAGS) $^ -o $@
bin/unpack : src/converter/unpack.c | bin
	$(CC) $(CPPFLAGS) $(CFLAGS) $^ -o $@

src/levels.asm : $(patsubst %.sok,%.ask,$(wildcard levels/*.sok))
	{ \
		echo .SECTION \"Leveldata\" FREE > $@ ;\
		echo LevelData: >> $@ ;\
		for f in $^ ; do \
			echo .INCBIN "$$f" SKIP 1 >> $@ ;\
		done ;\
		echo .ENDS >> $@ ;\
		echo .SECTION \"Levelplayer\" FREE >> $@ ;\
		echo LevelPlayer: >> $@ ;\
		for f in $^ ; do \
			echo .INCBIN "$$f" READ 1 >> $@ ;\
		done ;\
		echo .ENDS >> $@ ;\
	}

dep obj lib bin:
	mkdir -p $@

DEPFILES := $(OBJSRC:%.asm=dep/%.d) $(LIBSRC:%.asm=dep/%.d)
$(DEPFILES):
include $(wildcard $(DEPFILES))

.PHONY = clean
