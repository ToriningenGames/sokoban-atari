
OBJSRC := init.asm kernel.asm
LIBSRC := logic.asm graphics.asm

bin/sokoban.a26 : $(addprefix obj/,$(OBJSRC:.asm=.obj)) $(addprefix lib/,$(LIBSRC:.asm=.lib)) link.link | bin
	wlalink -s -A -L lib link.link $@

clean :
	$(RM) -r dep obj lib bin link.link

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

obj/%.obj : src/%.asm dep/%.d | src dep obj
	wla-6502 -M -I inc -I src -o $@ $< > $(word 2,$^)
lib/%.lib : src/%.asm dep/%.d | src dep lib
	wla-6502 -M -I inc -I src -l $@ $< > $(word 2,$^)

bin/pack : src/converter/pack.c | bin
	$(CC) $(CPPFLAGS) $(CFLAGS) $^ -o $@
bin/unpack : src/converter/unpack.c | bin
	$(CC) $(CPPFLAGS) $(CFLAGS) $^ -o $@

dep obj lib bin:
	mkdir -p $@

DEPFILES := $(OBJSRC:%.asm=dep/%.d) $(LIBSRC:%.asm=dep/%.d)
$(DEPFILES):
include $(wildcard $(DEPFILES))

.PHONY = clean
