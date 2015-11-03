
.PHONY: default
default:
	@echo "Desk doesn't need to be compiled. Please run \"sudo make install\" to install desk."

.PHONY: install
install:
	@cp ./desk /usr/bin/desk ||:
	@echo "Installing desk to /usr/bin/desk"

.PHONY: uninstall
uninstall:
	@rm /usr/bin/desk ||:
	@echo "Removing desk from /usr/bin"

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
