# MiniFiber

By `Marshal` module and with `Unix.fork`, I think it's possible to launch real
parallel computation with OCaml. This library wants to provide the simplest way
to execute in parallel (such as hash algorithm) computation without a huge cost
(currently, only `Unix` and `Marshal` is needed).

Of course, creation of a fork is cost.

The code comes from `dune` and some of my knowledge but I'm not sure about the
ready-to-production aspect.

## An example

In `bin/` an example is to launch SHA1 on multiple files. The program should
take the advantage of multiple cores (one per files).
