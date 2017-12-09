SUDO="sudo"

all:
ifeq (${UID}, 0)
	SUDO=""
else
	SUDO="sudo"
endif
	chmod 755 *.sh
.PHONY:clean distclean install uninstall
clean:
	@echo ""
distclean:
	@echo ""
install:
	${SUDO} cp *.sh -v /usr/bin
uninstall:
	${SUDO} rm -rf /usr/bin/*.sh
