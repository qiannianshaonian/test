%%%-------------------------------------------------------------------
%%% @author cyy
%%% @copyright (C) 2017, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 29. 三月 2017 下午5:02
%%%-------------------------------------------------------------------
-module(app_ctl).
-author("cyy").

-behaviour(gen_server).

%% API
-export([
  start_link/0,
  start_link/2,
  start_link/3,
  child_spec/2,
  child_spec/3,
  get_config/1,
  reload_config/0,
  stop/0
]).

%% gen_server callbacks
-export([init/1,
  handle_call/3,
  handle_cast/2,
  handle_info/2,
  terminate/2,
  code_change/3]).

-define(SERVER, ?MODULE).
-define(AppConfig, app_config).

-record(state, {
  config_path :: string(),
  mod :: module()
}).

%%%===================================================================
%%% API
%%%===================================================================

%%--------------------------------------------------------------------
%% @doc
%% Starts the server
%%
%% @end
%%--------------------------------------------------------------------

-spec(start_link() ->
  {ok, Pid :: pid()} | ignore | {error, Reason :: term()}).
start_link() ->
  gen_server:start_link({local, ?SERVER}, ?MODULE, [], []).

-spec(start_link(string(), atom()) ->
  {ok, Pid :: pid()} | ignore | {error, Reason :: term()}).
start_link(ConfigPath, Mod) ->
  gen_server:start_link({local, ?SERVER}, ?MODULE, [ConfigPath, Mod], []).

-spec(start_link(string(), atom(), integer()) ->
  {ok, Pid :: pid()} | ignore | {error, Reason :: term()}).
start_link(ConfigPath, Mod, Timeout) ->
  gen_server:start_link({local, ?SERVER}, ?MODULE, [ConfigPath, Mod, Timeout], []).

-spec child_spec(string(), atom()) ->
  supervisor:child_spec().
child_spec(ConfigPath, Mod) ->
  #{
    id => ?MODULE,
    start => {?MODULE, start_link, [ConfigPath, Mod]},
    restart => permanent,
    shutdown => 2000,
    type => worker,
    modules => [?MODULE]
  }.

-spec child_spec(string(), atom(), integer()) ->
  supervisor:child_spec().
child_spec(ConfigPath, Mod, Timeout) ->
  #{
    id => ?MODULE,
    start => {?MODULE, start_link, [ConfigPath, Mod, Timeout]},
    restart => permanent,
    shutdown => 2000,
    type => worker,
    modules => [?MODULE]
  }.

-spec reload_config() ->
  ok.
reload_config() ->
  gen_server:cast(?MODULE, reload_config).

stop() ->
  error_logger:info_msg("mod_ctl stop = ~p  ~n", [1]),
  gen_server:call(?MODULE, stop).

-spec get_config(atom()) ->
  any().
get_config(Key) ->
  [{_, Value}] = ets:lookup(?AppConfig, Key),
  Value.
%%%===================================================================
%%% gen_server callbacks
%%%===================================================================

%%--------------------------------------------------------------------
%% @private
%% @doc
%% Initializes the server
%%
%% @spec init(Args) -> {ok, State} |
%%                     {ok, State, Timeout} |
%%                     ignore |
%%                     {stop, Reason}
%% @end
%%--------------------------------------------------------------------
-spec(init(Args :: term()) ->
  {ok, State :: #state{}} | {ok, State :: #state{}, timeout() | hibernate} |
  {stop, Reason :: term()} | ignore).
init(Args) ->
  lager:info("111111111111~p~n",[Args]),
  [ConfigPath, Mod, Timeout] = case Args of
                                 [_, _, _] -> Args;
                                 [C, M] -> [C, M, 100]
                               end,
  init_config(ConfigPath),
  erlang:start_timer(Timeout, self(), init),
  case code:is_loaded(Mod) of
    false -> code:load_file(Mod);
    _ -> ok
  end,
  mysql_poolboy:query(pool1, "SELECT * FROM game_server WHERE status=?", [1]),
  true = erlang:function_exported(Mod, init, 0),
  true = erlang:function_exported(Mod, stop, 0),
  {ok, #state{config_path = ConfigPath, mod = Mod}}.

%%--------------------------------------------------------------------
%% @private
%% @doc
%% Handling call messages
%%
%% @end
%%--------------------------------------------------------------------
-spec(handle_call(Request :: term(), From :: {pid(), Tag :: term()},
    State :: #state{}) ->
  {reply, Reply :: term(), NewState :: #state{}} |
  {reply, Reply :: term(), NewState :: #state{}, timeout() | hibernate} |
  {noreply, NewState :: #state{}} |
  {noreply, NewState :: #state{}, timeout() | hibernate} |
  {stop, Reason :: term(), Reply :: term(), NewState :: #state{}} |
  {stop, Reason :: term(), NewState :: #state{}}).

handle_call(stop, _, State) ->
  Mod = State#state.mod,
  Mod:stop(),
  {reply, ok, State};

handle_call(_Request, _From, State) ->
  {reply, ok, State}.

%%--------------------------------------------------------------------
%% @private
%% @doc
%% Handling cast messages
%%
%% @end
%%--------------------------------------------------------------------
-spec(handle_cast(Request :: term(), State :: #state{}) ->
  {noreply, NewState :: #state{}} |
  {noreply, NewState :: #state{}, timeout() | hibernate} |
  {stop, Reason :: term(), NewState :: #state{}}).

handle_cast(reload_config, State) ->
  init_config(State#state.config_path),
  {noreply, State};

handle_cast(_Request, State) ->
  {noreply, State}.

%%--------------------------------------------------------------------
%% @private
%% @doc
%% Handling all non call/cast messages
%%
%% @spec handle_info(Info, State) -> {noreply, State} |
%%                                   {noreply, State, Timeout} |
%%                                   {stop, Reason, State}
%% @end
%%--------------------------------------------------------------------
-spec(handle_info(Info :: timeout() | term(), State :: #state{}) ->
  {noreply, NewState :: #state{}} |
  {noreply, NewState :: #state{}, timeout() | hibernate} |
  {stop, Reason :: term(), NewState :: #state{}}).

handle_info({timeout, _, init}, State) ->
  Mod = State#state.mod,
  Mod:init(),
  {noreply, State};

handle_info(_Info, State) ->
  {noreply, State}.

%%--------------------------------------------------------------------
%% @private
%% @doc
%% This function is called by a gen_server when it is about to
%% terminate. It should be the opposite of Module:init/1 and do any
%% necessary cleaning up. When it returns, the gen_server terminates
%% with Reason. The return value is ignored.
%%
%% @spec terminate(Reason, State) -> void()
%% @end
%%--------------------------------------------------------------------
-spec(terminate(Reason :: (normal | shutdown | {shutdown, term()} | term()),
    State :: #state{}) -> term()).
terminate(_Reason, State) ->
  Mod = State#state.mod,
  Mod:stop(),
  ok.

%%--------------------------------------------------------------------
%% @private
%% @doc
%% Convert process state when code is changed
%%
%% @spec code_change(OldVsn, State, Extra) -> {ok, NewState}
%% @end
%%--------------------------------------------------------------------
-spec(code_change(OldVsn :: term() | {down, term()}, State :: #state{},
    Extra :: term()) ->
  {ok, NewState :: #state{}} | {error, Reason :: term()}).
code_change(_OldVsn, State, _Extra) ->
  {ok, State}.

%%%===================================================================
%%% Internal functions
%%%===================================================================
init_config(ConfigPath) ->
  io:format("ConfigPath ~p~n", [ConfigPath]),
  {ok, Configs} = file:consult(ConfigPath),
  io:format("Configs ~p~n", [Configs]),
  lager:info("app config: ~p", [Configs]),
  case ets:info(?AppConfig) of
    undefined ->
      ets:new(?AppConfig, [named_table, protected, set, {read_concurrency, true}]),
      [ets:insert(?AppConfig, Config) || Config <- Configs];
    _ ->
      lager:info("app config exists, new : ~p", [Configs]),
      [ets:insert(?AppConfig, Config) || Config <- Configs]
  end.
