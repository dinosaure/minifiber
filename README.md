# MiniFiber

By `Marshal` module and with `Unix.fork`, I think it's possible to launch real
parallel computation with OCaml. This library wants to provide the simplest way
to execute in parallel (such as hash algorithm) computation without a huge
code-base (currently, only `Unix` and `Marshal` are needed).

It's the OCaml _multicore_ for poor people - because we use `Unix.fork`.

The code comes from `dune` and some of my knowledge but I'm not sure about the
ready-to-production aspect - guy, `fork` ... and shared data are limited to the
size of used pipe.

## An example

In `bin/` an example is to launch SHA1 on multiple files. The program should
take the advantage of multiple cores (one per files).

```sh
$ dune exec bin/digest.exe -- file1 file2 file3
```
