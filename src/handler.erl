-module(handler).

-behaviour(cowboy_http_handler).

-export([
  init/3,
  handle/2,
  terminate/3
]).

init(_Transport, Req, []) ->
  gen_counter:start_link(),
  {ok, Req, undefined}.


handle(Req, State) ->
  {PathInfo, Req0} = cowboy_req:path_info(Req),
  {ok, Req1} = handle_http(PathInfo, Req0),
  {ok, Req1, State}.


handle_http([], Req) ->
  cowboy_req:reply(200, [], <<"Hello world! :3">>, Req);

handle_http([Op], Req) ->
  ToBinary = fun(Count) -> list_to_binary(integer_to_list(Count)) end,
  Result = case Op of
    <<"inc">> -> ToBinary(gen_counter:inc());
    <<"dec">> -> ToBinary(gen_counter:dec());
    <<"stat">> -> ToBinary(gen_counter:stat());
    _ -> <<"Available commands: /inc, /dec, /stat">>
  end,
  cowboy_req:reply(200, [], Result, Req);

handle_http([Id, Op], Req) ->
  cowboy_req:reply(200, [], [Id, $ , Op], Req).


terminate(_Reason, _Req, _State) ->
  ok.
