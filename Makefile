
.PHONY: dockerbuild
dockerbuild:
	docker build -t desk/desk .

.PHONY: bash
bash: dockerbuild
	docker run -it desk/desk /bin/bash
	
.PHONY: lint
lint:
	shellcheck desk
