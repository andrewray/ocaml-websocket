#!/usr/bin/env ocaml
#directory "pkg"
#use "topkg.ml"

let () =
  Pkg.describe "websocket" ~builder:`OCamlbuild [
    Pkg.lib "pkg/META";
    Pkg.lib ~exts:Exts.module_library "lib/websocket";
    Pkg.bin ~auto:true "tests/wscat";
    Pkg.bin "tests/wsclient.byte";
    Pkg.bin ~auto:true "tests/wsserver";
  ]
