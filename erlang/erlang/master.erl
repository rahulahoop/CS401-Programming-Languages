
%% @doc @todo Add description to master.


-module(master).

%% ====================================================================
%% API functions
%% ====================================================================
-compile(export_all).


%% ====================================================================
%% Internal functions
%% ====================================================================


start() -> spawn(master, init, []).

init() -> loop([]).



loop(Users) ->
	receive
		%% See USER FRIENDLY functions for descriptions. %%
        
		{send, From, To, Msg} ->			
			To_User   = lists:keysearch(To, 1, Users),
			From_User = lists:keysearch(From, 1, Users),
			
			if
				%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
                %% Err msg if sender DNE   %%
                %%%%%%%%%%%%%%%%%%%%%%%%%%%%%
				From_User =:= false -> 
					io:format("Username: ~p Does Not Exist~n", [From]),
					loop(Users);

				%%%%%%%%%%%%%%%%%%%%%%%%%%%%%			
				%% Err msg if receiver DNE %%
				%%%%%%%%%%%%%%%%%%%%%%%%%%%%%		
				To_User   =:= false ->
					io:format("Username: ~p Does Not Exist~n", [To]),
					loop(Users);

				%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
				%% This should be the default case assuming the receving user is real. %%
                %%  -Checks signal of both users.                                      %%
                %%    -if both on updates each users convo list                        %%
                %%    -replaces old user profile with updated one                      %%
                %%    -sends new profiles to recieve loop                              %%
                %%  -else goes back to receive loop, unchanged                         %%
				%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
				To  =:= element(1, element(2, To_User)) ->
					X = element(2, element(2, From_User)),
					Y = element(2, element(2, To_User)),
					OffFromName = element(1, element(2, From_User)),
                    OffToName   = element(1, element(2, To_User)),
					if
                        (X =:= off) or (Y =:= off) ->
							if 
								X =:= off ->
                                    io:format("~p is offline. Message failed to send.~n",[OffFromName]),
                                    loop(Users);
								Y =:= off ->
									io:format("~p is offline. Message failed to send.~n", [OffToName]),
									loop(Users)
							end;
						(X =:= on) and (Y =:= on) ->
							ToMsgs = element(3, element(2, To_User)),
							Temp   = ['From:', From, Msg],
							New_ToMsg = lists:append(ToMsgs, Temp),
							FromMsgs = element(3, element(2, From_User)),
							Temp2  = ['To:', To, Msg],
							New_FromMsg = lists:append(FromMsgs, Temp2),
							Update_To = lists:keyreplace(To, 1, Users, {To, on, New_ToMsg}),
							Update_Fin = lists:keyreplace(From, 1, Update_To, {From, on, 
                                                                               New_FromMsg}),
							loop(Update_Fin)	
					end
			end,
			
			loop(Users);

		% This function switches a user from on to off and vice versa.
		{switch, Name} ->
			Temp = lists:keysearch(Name, 1, Users), %this returns {value, userTuple}
			Msgs = element(3, element(2, Temp)),	%gets the Users Msgs
			if 
				element(2, element(2, Temp)) =:= on ->
					X = lists:keyreplace(Name, 1, Users, {Name, off, Msgs}),
					io:format("~p is now off.~n", [Name]);
				element(2, element(2, Temp)) =:= off ->
					io:format("~p is now on.~n", [Name]),
					X = lists:keyreplace(Name, 1, Users, {Name, on, Msgs})
			end,	
			loop(X);
		{create, Name} ->
			L = [{Name, on, [] }],
			Y = lists:append(Users, L),
			io:format("~p was created~n", [Name]),
			loop(Y);
		{getUser, Name} ->
			U = lists:keysearch(Name, 1, Users),
            if
                U =:= false ->
                    io:format("User: ~p DNE~n", [Name]),
                    loop(Users);
                U =/= false ->
                    if 
                        element(2, element(2, U)) =:= on ->
                            Ret = element(2, U),
			                io:format("~p~n", [Ret]),
			                loop(Users);
                        element(2, element(2, U)) =:= off ->
                            io:format("~p is offline. Please go online to see profile.~n", [Name]),
                            loop(Users)
                    end
            end,
			loop(Users);
		{Pid, anonSend, To, Msg} ->
			Rand = random:uniform(100) * 8,
			From = list_to_atom(lists:flatten(io_lib:format("anon~B", [Rand]))),
			Pid ! {create, From},
			Pid ! {send, From, To, Msg},
			loop(Users);

		showUsers ->
			io:format("~p~n", [Users]),
			loop(Users)

	end.
%%%%%%%%%%%%%%%%%%%%%%%%%%%
% User Friendly Functions %
%%%%%%%%%%%%%%%%%%%%%%%%%%%

%% Specified Sender and Receiver users %%
sendMessage(Pid, From, To, Msg) ->
	Pid ! {send, From, To, Msg}.

%%% anon Sender %%%
sendMessage(Pid, To, Msg) ->
	Pid ! {Pid, anonSend, To, Msg}.

%% create a user %%
createUser(Pid, Name) ->
	Pid ! {create, Name}.

%% returns user profile IFF user exists %%
getUser(Pid, Name) ->
	Pid ! {getUser, Name}.
%% shows all assigned to server. On OR Off %%
showUsers(Pid) ->
	Pid ! showUsers.

%% turns given user opposite of what they were %%
switch(Pid, Name) ->
	Pid ! {switch, Name}.

%%%%%%%%%%%%%%%%%%%%%
%% Some Unit Tests %%
%%%%%%%%%%%%%%%%%%%%%
testOne() ->
	io:format(" This unit test will:
		   ---- Spawn the Pid~n
		   ---- Create user: jack.~n
		   ---- Create user: bill.~n
		   ---- Send a message to bill from jack.~n
		   ---- Display jack's user profile.~n
	"),
	Pid = start(),
	createUser(Pid, jack),
	createUser(Pid, bill),
	sendMessage(Pid,jack,bill,"hi buddy"),
	getUser(Pid, jack),
	unit_Test_Finished.

testTwo() ->
	io:format("This test will test signal~n"),
	Pid = start(),
	createUser(Pid, jim),
	switch(Pid, jim),
	sendMessage(Pid, jim, bob, "Im off"),
	end_test2.

testThree() ->
	Pid = start(),
	createUser(Pid, jim),
	sendMessage(Pid, jim, "halo"),
	showUsers(Pid),
	switch(Pid, jim),
	sendMessage(Pid, jim, "nope"),
	showUsers(Pid).


