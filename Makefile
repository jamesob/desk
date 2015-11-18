.PHONY: install
install:
	cp ./desk /usr/local/bin/desk

.PHONY: uninstall
uninstall:
	rm /usr/local/bin/desk
	
.PHONY: oh-my-zsh
oh-my-zsh: 
	ln -s $(shell pwd)/shell_plugins/zsh $(HOME)/.oh-my-zsh/custom/plugins/desk


# Test targets
# ------------

.PHONY: dockerbuild
dockerbuild:
	docker build -t desk/desk .

SHELL_CMD?=

.PHONY: bash
bash: dockerbuild
	docker run -it desk/desk /bin/bash $(SHELL_CMD)
 
.PHONY: zsh
zsh: dockerbuild
	docker run -it desk/desk /usr/bin/zsh $(SHELL_CMD)
 
.PHONY: fish
fish: dockerbuild
	docker run -it desk/desk /usr/bin/fish $(SHELL_CMD)

.PHONY: lint
lint:
	shellcheck -e SC2155 desk
