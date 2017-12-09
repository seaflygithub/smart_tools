src_file:=DQQ.mp3
tst1file:=test.1.mp3
tst2file:=test.2.mp3
tstID:=123456789012345678	#<Your ID number>
SUDO="sudo"


%.o:%.c
	gcc -g -c -Wall $^ -o $@
all: main.o
ifeq (${UID}, 0)
	SUDO=""
else
	SUDO="sudo"
endif
	gcc -g -Os -Wall $^ -o ckey.elf
install:
	chmod 755 ckey.sh
	${SUDO} cp -v ckey.sh	/usr/bin/ckey
	${SUDO} cp -v ckey.elf	/usr/bin
.PHONY		:clean distclean
clean		:
		rm -rf *.elf *.o core.*
distclean	:
	make clean
	rm -rf *.elf
uninstall:
	${SUDO} rm -rf /usr/bin/ckey
	${SUDO} rm -rf /usr/bin/ckey.elf
