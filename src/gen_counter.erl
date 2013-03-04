%% Copyright
-module(gen_counter).
-author("Filinger").

-behaviour(gen_server).

%% API
-export([start_link/0, process/1]).

%% gen_server
-export([init/1, handle_call/3, handle_cast/2, handle_info/2,
  terminate/2, code_change/3]).

-define(SERVER, ?MODULE).

start_link() ->
  gen_server:start_link({local, ?SERVER}, ?MODULE, [], []).


process(Op) ->
  case Op of
    <<"inc">> -> list_to_binary(integer_to_list(inc()));
    <<"dec">> -> list_to_binary(integer_to_list(dec()));
    <<"stat">> -> list_to_binary(integer_to_list(stat()));
    _ -> <<"Available commands: /inc, /dec, /stat">>
  end.

inc() ->
  gen_server:call(?SERVER, inc).

dec() ->
  gen_server:call(?SERVER, dec).

stat() ->
  gen_server:call(?SERVER, stat).


init([]) ->
  process_flag(trap_exit, true),
  State = 0,
  {ok, State}.


handle_call(inc, _From, State) ->
  NewState = State + 1,
  {reply, NewState, NewState};

handle_call(dec, _From, State) ->
  NewState = State - 1,
  {reply, NewState, NewState};

handle_call(stat, _From, State) ->
  {reply, State, State}.


handle_cast(_Msg, State) ->
  {noreply, State}.


handle_info(_Info, State) ->
  {noreply, State}.


terminate(_Reason, _State) ->
  ok.


code_change(_OldVsn, State, _Extra) ->
  {ok, State}.

