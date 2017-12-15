#Get all objects (*.o)  (usage): make
%.o:%.c
	gcc -g -c -Wall $^ -o $@

#Configure program depended .o files
SHARE:=contents.o strnum.o
LOCK:=${SHARE} lock.o
UNLOCK:=${SHARE} unlock.o
SUDO="sudo"

all: ${LOCK} ${UNLOCK}
ifeq (${UID}, 0)
	SUDO=""
else
	SUDO="sudo"
endif
	gcc -g -Os -Wall ${LOCK} -o blv2
	gcc -g -Os -Wall ${UNLOCK} -o ublv2
	@-echo "File be ready: $(PWD)/blv2,ublv2"

install: blv2 ublv2
ifeq (${SUDO},"sudo")
	sudo cp -av $^ /usr/bin
else
	sudo cp -av $^ /usr/bin
endif
	@-echo "programs: /usr/bin/blv2 /usr/bin/ublv2"

.PHONY:clean distclean uninstall
clean:
	rm -rf *.o *.out *.elf *.bin *.dat
	-echo "clean up!"
distclean:
	rm -rf *.o *.out *.elf *.bin *.dat blv2 ublv2
	-echo "clean up!"
uninstall:
	make distclean
	${SUDO} rm -rf /usr/bin/blv2 /usr/bin/ublv2
