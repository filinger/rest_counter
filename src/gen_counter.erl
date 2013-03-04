%% Copyright
-module(gen_counter).
-author("Filinger").

-behaviour(gen_server).

%% API
-export([start_link/0, process/1]).
%%  inc/0,
%%  dec/0,
%%  stat/0]).

%% gen_server
-export([init/1, handle_call/3, handle_cast/2, handle_info/2,
  terminate/2, code_change/3]).

-define(SERVER, ?MODULE).

start_link() ->
  gen_server:start_link({local, ?SERVER}, ?MODULE, [], []).

process(Op) ->
  gen_server:call(?SERVER, Op).

init([]) ->
  process_flag(trap_exit, true),
  State = 0,
  {ok, State}.

handle_call(_Op, _From, State) ->
  NewState = State + 1,
  {reply, NewState}.

handle_cast(_Msg, State) ->
  {noreply, State}.

handle_info(_Info, State) ->
  {noreply, State}.

terminate(_Reason, _State) ->
  ok.

code_change(_OldVsn, State, _Extra) ->
  {ok, State}.

