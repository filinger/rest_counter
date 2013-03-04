-module(handler).

-behaviour(cowboy_http_handler).

-export([
	init/3,
	handle/2,
	terminate/3
]).


init(_Transport, Req, []) ->
	{ok, Req, undefined}.


handle(Req, State) ->
	{PathInfo, Req0} = cowboy_req:path_info(Req),
	{ok, Req1} = handle_http(PathInfo, Req0),
	{ok, Req1, State}.


handle_http([], Req) ->
	cowboy_req:reply(200, [], <<"Hello world! :3">>, Req);

handle_http([Op], Req) ->
	cowboy_req:reply(200, [], Op, Req);

handle_http([Id, Op], Req) ->
	cowboy_req:reply(200, [], [Id, $ , Op], Req).


terminate(_Reason, _Req, _State) ->
	ok.
