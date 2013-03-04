-module(rest_counter_app).
-behaviour(application).

-export([start/2]).
-export([stop/1]).

start(_Type, _Args) ->
	Dispatch = cowboy_router:compile([
		{'_', [
			{"/[...]", handler, []}
		]}
	]),
	{ok, _} = cowboy:start_http(http, 100, [{port, 9080}], [
		{env, [{dispatch, Dispatch}]}
	]),
	rest_counter_sup:start_link().

stop(_State) ->
	ok.
