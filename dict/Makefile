SUDO="sudo"
all: main.o dict.o
ifeq (${UID}, 0)
	SUDO=""
else
	SUDO="sudo"
endif
	gcc -g -Os $^ -o main.exe
./%.o:./%.c
	gcc -g -c $^
.PHONY:clean distclean install uninstall
clean:
	rm -rf *.o *.elf *.exe
distclean:
	make clean
install:
	${SUDO} cp -v main.exe /usr/bin/dict
	chmod 777 dict.txt
	${SUDO} cp -v dict.txt /etc
uninstall:
	${SUDO} rm -rf /usr/bin/dict /etc/dict.txt
