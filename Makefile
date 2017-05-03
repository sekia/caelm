OCB_FLAGS = -use-ocamlfind -plugin-tag "package(js_of_ocaml.ocamlbuild)" -I lib
OCB = ocamlbuild

.PHONY: all clean example

all: example

clean:
	$(OCB) -clean

example:
	$(OCB) $(OCB_FLAGS) -I example app.js
