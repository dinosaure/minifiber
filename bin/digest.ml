open Fiber

let io_buffer_size = 65536

let ( <.> ) f g = fun x -> f (g x)

let digest_file : string -> unit -> (string * Digestif.SHA1.t, [> Rresult.R.msg ]) result
  = fun filename () ->
  try
    let tp = Bytes.create io_buffer_size in
    let fd = Unix.openfile filename Unix.[ O_RDONLY ] 0o600 in
    let rec go ctx =
      let len = Unix.read fd tp 0 io_buffer_size in
      if len = 0 then ctx
      else
        let ctx = Digestif.SHA1.feed_bytes ctx tp ~off:0 ~len in
        go ctx in
    let ctx = go Digestif.SHA1.empty in
    Unix.close fd ; Rresult.R.ok (filename, Digestif.SHA1.get ctx)
  with Unix.Unix_error (err, _, _) ->
    Rresult.R.error_msgf "%s: %s" filename (Unix.error_message err)

let print = function
  | Ok (Ok (filename, hash)) -> Format.printf "%a  %s\n%!" Digestif.SHA1.pp hash filename
  | Ok (Error (`Msg err)) -> Format.eprintf "%s\n%!" err
  | Error exit_code -> Format.eprintf "%s: %d\n%!" Sys.argv.(0) exit_code

let run filenames =
  let fiber = parallel_map filenames ~f:(run_process <.> digest_file) in
  List.iter print (run fiber)

let () = match Sys.argv with
  | [| _ |] -> Format.eprintf "%s [<file> ...]\n%!" Sys.argv.(0)
  | [||] -> assert false
  | _ ->
    let[@warning "-8"] _ :: filenames = Array.to_list Sys.argv in
    run filenames
