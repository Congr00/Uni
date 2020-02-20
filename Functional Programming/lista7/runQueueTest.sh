#!/bin/bash

ocamlc -c QueueMut.mli
ocamlc -c QueueMut.ml
ocamlc -c queueTest.ml
ocamlc -o queueTest QueueMut.cmo queueTest.cmo
ocamlrun queueTest
