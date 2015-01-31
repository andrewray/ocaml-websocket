PKG=websocket
PREFIX=`opam config var prefix`
BUILDOPTS=native=true native-dynlink=true

all: build

build:
	ocaml pkg/build.ml $(BUILDOPTS)

js: build
	js_of_ocaml wsclient.byte -o tests/wsclient.js

install: build
	opam-installer --prefix=$(PREFIX) $(PKG).install

uninstall: $(PKG).install
	opam-installer -u --prefix=$(PREFIX) $(PKG).install

PHONY: clean

clean:
	ocamlbuild -clean
