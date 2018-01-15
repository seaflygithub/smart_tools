.PHONY: all clean distclean install uninstall
all:
	make all -C binlock
	make all -C ckey
	make all -C dict
	make all -C scripts
install:
	make install -C binlock
	make install -C ckey
	make install -C dict
	-rm -rf ${HOME}/.oh-my-zsh
	-cp -rf oh-my-zsh ${HOME}/.oh-my-zsh
	-cp -rf ./oh-my-zsh/templates/zshrc.zsh-template $(HOME)/.zshrc
	make install -C scripts
clean:
	make clean -C binlock
	make clean -C ckey 
	make clean -C dict
	make clean -C scripts
distclean:
	make distclean -C binlock
	make distclean -C ckey
	make distclean -C dict
	make distclean -C scripts
uninstall:
	make uninstall -C binlock
	make uninstall -C ckey
	make uninstall -C dict
	-rm -rf ${HOME}/.oh-my-zsh
	make uninstall -C scripts
