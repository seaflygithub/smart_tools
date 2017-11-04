src_file:=DQQ.mp3
tst1file:=test.1.mp3
tst2file:=test.2.mp3
tstID:=123456789012345678	#<Your ID number>

ifeq (${UID}, 0)
	SUDO=""
else
	SUDO="sudo"
endif
%.o:%.c
	gcc -g -c -Wall $^ -o $@
all: main.o
	gcc -g -Os -Wall $^ -o ckey.elf
install:
	mkdir -p ${HOME}/bin 2>/dev/null 1>/dev/null
	source ${HOME}/.profile
	chmod 755 ckey.sh
	cp -v ckey.sh	${HOME}/bin/ckey
	cp -v ckey.elf	${HOME}/bin
.PHONY		:clean distclean
clean		:
		rm -rf *.elf *.o core.*
distclean	:
	make clean
	rm -rf *.elf
uninstall:
	rm -rf ${HOME}/bin/ckey
	rm -rf ${HOME}/bin/ckey.elf
test:
	ckey ${src_file} ${tst1file} ${tstID}
	ckey ${tst1file} ${tst2file} ${tstID}

