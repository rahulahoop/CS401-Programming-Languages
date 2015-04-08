start :-
	write('What is your problem?'),nl,
	take_input.

take_input :-
	read_line_to_codes(user_input,Cs),
	atom_codes(A,Cs),
	atomic_list_concat(L,' ', A),
	match(L).

match([pass|_]):-
	write('Okay, Lets move on.'),nl,
	take_input.

match([i,X|_]) :-
	write('Hm, I see. '),
	write(X),
	write(' is a strong word, care to explain?'),nl,
	take_input.
match([this, is|Rest]) :-
	write('What else do you regard as '),
	write(Rest),
	write('?'),nl,take_input.
match([bye|_]) :-
        write('goodbye'),nl.
match(List) :-
	member('mom',List) -> write('Tell me about your mother.'),nl,take_input;
	member('mother',List) -> write('Sounds JUST like your mother, Trebek!'),nl,take_input;
	member('moms',List) -> write('Well, she did give birth to you'),nl,take_input;
	member('dads',List) -> write('I can tell he never loved you.'),nl,take_input;
	member('fathers',List) -> write('Atleast you have a dad ....'),nl,take_input;
	member('dad',List) -> write('WAHHH, white girl and daddy problems.'),nl,take_input;
	member('father',List) -> write('Show me on the doll where he touched you'),nl,take_input;
	write('well lets move on'),nl,take_input.

