OCB = ocamlbuild
OCB_FLAGS = -use-ocamlfind -plugin-tag "package(js_of_ocaml.ocamlbuild)"

NPM_BIN = $(shell npm bin)
BROWSERIFY = $(NPM_BIN)/browserify
UGLIFY = $(NPM_BIN)/uglifyjs

.PHONY: all clean

all: bundle.js

clean:
	$(OCB) -clean && rm -r bundle.js node_modules

bundle.js: _build/app.js node_modules
	NODE_ENV=production $(BROWSERIFY) $< -d -r react -r react-dom -t envify \
	| $(UGLIFY) -m -c -o $@ --source-map content=inline,url=$@.map

_build/app.js:
	$(OCB) $(OCB_FLAGS) app.js

node_modules: package.json
	npm install && touch $@
