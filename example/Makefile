OCB = ocamlbuild
OCB_FLAGS = -use-ocamlfind -plugin-tag "package(js_of_ocaml.ocamlbuild)"

.PHONY: all clean

all:
	$(OCB) $(OCB_FLAGS) app.js

clean:
	$(OCB) -clean
