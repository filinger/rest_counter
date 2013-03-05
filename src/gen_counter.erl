%% Copyright
-module(gen_counter).
-author("Firingeru").

-behaviour(gen_server).

%% API
-export([start_link/0, inc/0, dec/0, stat/0]).

%% gen_server
-export([init/1, handle_call/3, handle_cast/2, handle_info/2, terminate/2,
  code_change/3]).

%% API
start_link() ->
  gen_server:start_link({local, ?MODULE}, ?MODULE, [], []).

inc() ->
  gen_server:call(?MODULE, fun(Count) -> Count + 1 end).

dec() ->
  gen_server:call(?MODULE, fun(Count) -> Count - 1 end).

stat() ->
  gen_server:call(?MODULE, fun(Count) -> Count end).

%% gen_server callbacks
-record(state, {counter = 0}).

init(_Args) ->
  process_flag(trap_exit, true),
  {ok, #state{}}.

handle_call(OpFunction, _From, State) ->
  NewState = State#state{counter = OpFunction(State#state.counter)},
  {reply, NewState#state.counter, NewState}.

handle_cast(_Request, State) ->
  {noreply, State}.

handle_info(_Info, State) ->
  {noreply, State}.

terminate(_Reason, _State) ->
  ok.

code_change(_OldVsn, State, _Extra) ->
  {ok, State}.
