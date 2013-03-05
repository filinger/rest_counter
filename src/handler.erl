-module(handler).

-behaviour(cowboy_http_handler).

-export([
  init/3,
  handle/2,
  terminate/3
]).

init(_Transport, Req, []) ->
  gen_counter:start_link(),
  ets_counters:start_link(),
  {ok, Req, undefined}.


handle(Req, State) ->
  {PathInfo, Req0} = cowboy_req:path_info(Req),
  {ok, Req1} = handle_http(PathInfo, Req0),
  {ok, Req1, State}.


to_binary(IntCount) ->
  list_to_binary(integer_to_list(IntCount)).


handle_http([], Req) ->
  cowboy_req:reply(200, [], <<
  "Usage: /{id}/inc, /{id}/dec, /{id}/stat \n"
  "Any unique key will act as id. \n"
  "Global counter is accessible without it. :3"
  >>, Req);

handle_http([Op], Req) ->
  Result = case Op of
    <<"inc">> -> to_binary(gen_counter:inc());
    <<"dec">> -> to_binary(gen_counter:dec());
    <<"stat">> -> to_binary(gen_counter:stat());
    _ -> <<"Available commands: /inc, /dec, /stat">>
  end,
  cowboy_req:reply(200, [], ["Global counter: ", Result], Req);

handle_http([Id, Op], Req) ->
  Result = case Op of
    <<"inc">> -> to_binary(ets_counters:inc(Id));
    <<"dec">> -> to_binary(ets_counters:dec(Id));
    <<"stat">> -> to_binary(ets_counters:stat(Id));
    _ -> <<"Available commands: id/inc, id/dec, id/stat">>
  end,
  cowboy_req:reply(200, [], ["Counter #", Id, ": " , Result], Req).


terminate(_Reason, _Req, _State) ->
  ok.
