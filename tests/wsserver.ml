(* serve html and websockets *)
open Lwt
open Websocket

let server ?certificate sockaddr =
  let rec echo_fun uri (stream, push) =
    Lwt_stream.next stream >>= fun frame ->
    Lwt.wrap (fun () -> push (Some frame)) >>= fun () ->
    echo_fun uri (stream, push) in
  establish_server ?certificate sockaddr echo_fun

let rec wait_forever () =
  Lwt_unix.sleep 1000.0 >>= wait_forever

(* websocket thread *)
let ws () = 
  Lwt_io_ext.sockaddr_of_dns "localhost" "8888" >>= fun sa ->
  (ignore (server sa); wait_forever ())
  
(*let () = Lwt_main.run ws*)

open Cohttp
open Cohttp_lwt_unix

let http () = 

  let callback (_,conn_id) req body = 
    let uri = Request.uri req in
    let path = Uri.path uri in
    let path = if path = "/" then "/index.html" else path in
    Server.respond_file ~fname:("tests" ^ path) ()
  in

  let conn_closed (_,_) = () in
  Conduit_lwt_unix.init ~src:"127.0.0.1" () >>= fun ctx ->
  let ctx = Cohttp_lwt_unix_net.init ~ctx () in
  let mode = `TCP (`Port 8887) in
  let config = Cohttp_lwt_unix.Server.make ~callback ~conn_closed () in
  Cohttp_lwt_unix.Server.create ~ctx ~mode config

let () = Lwt_main.run (http () <&> ws ())

