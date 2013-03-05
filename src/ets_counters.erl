%% Copyright
-module(ets_counters).
-author("Firingeru").

-behaviour(gen_server).

%% API
-export([start_link/0, inc/1, dec/1, stat/1]).

%% gen_server
-export([init/1, handle_call/3, handle_cast/2, handle_info/2, terminate/2,
  code_change/3]).

%% API
start_link() ->
  gen_server:start_link({local, ?MODULE}, ?MODULE, [], []).

inc(Id) ->
  gen_server:call(?MODULE, {Id, fun(Count) -> Count + 1 end}).

dec(Id) ->
  gen_server:call(?MODULE, {Id, fun(Count) -> Count - 1 end}).

stat(Id) ->
  gen_server:call(?MODULE, {Id, fun(Count) -> Count end}).

get_or_create(TabId, CounterId) ->
  Counter = ets:lookup(TabId, CounterId),
  if
    Counter /= [] -> Counter;
    Counter == [] -> ets:insert(TabId, {CounterId, 0}), [{CounterId, 0}]
  end.

%% gen_server callbacks
-record(state, {ets_counters = ets:new(counters, [])}).

init(_Args) ->
  process_flag(trap_exit, true),
  {ok, #state{}}.

handle_call({CounterId, OpFun}, _From, State) ->
  TabId = State#state.ets_counters,
  [{_, CurrentCount}] = get_or_create(TabId, CounterId),
  NewCount = OpFun(CurrentCount),
  ets:insert(TabId, {CounterId, NewCount}),
  {reply, NewCount, State}.

handle_cast(_Request, State) ->
  {noreply, State}.

handle_info(_Info, State) ->
  {noreply, State}.

terminate(_Reason, _State) ->
  ok.

code_change(_OldVsn, State, _Extra) ->
  {ok, State}.
