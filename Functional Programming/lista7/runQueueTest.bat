ocamlc -c queue_mut.mli
ocamlc -c queue_mut.ml
ocamlc -c queueTest.ml
ocamlc -o queueTest queue_mut.cmo queueTest.cmo
ocamlrun queueTest
