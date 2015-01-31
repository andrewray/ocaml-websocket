open Js

let log s = Firebug.console##log(string s)

let get n t = 
  Opt.get 
    (Opt.bind (Dom_html.document##getElementById(string n)) t)
    (fun () -> log ("failed to get " ^ n); failwith n)

let _ = Dom_html.window##onload <- Dom_html.handler (fun _ ->
  let input = get "message" Dom_html.CoerceTo.input in
  let send = get "send" Dom_html.CoerceTo.input in
  let response = get "response" Dom_html.CoerceTo.div in
  let ws = jsnew WebSockets.webSocket(string "ws://localhost:8888") in
  let _ = ws##onopen <- Dom.handler (fun _ ->
    response##innerHTML <- string "Connection open";
    send##onclick <- Dom.handler (fun _ ->
      let data = input##value in
      ws##send(data);
      response##innerHTML <- data;
      _false
    );
    _false)
  in
  let _ = ws##onmessage <- Dom.handler (fun message -> 
    response##innerHTML <- (string "received: <b>")##concat_2( message##data, string "</b>" );
    _false)
  in
  _false)

