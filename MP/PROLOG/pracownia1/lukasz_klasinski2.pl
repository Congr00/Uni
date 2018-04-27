% Definiujemy moduł zawierający rozwiązanie.
% Należy zmienić nazwę modułu na {imie}_{nazwisko} gdzie za
% {imie} i {nazwisko} należy podstawić odpowiednio swoje imię
% i nazwisko bez znaków diakrytycznych
:- module(lukasz_klasinski, [solve/2]).

% definiujemy operatory ~/1 oraz v/2
:- op(200, fx, ~).
:- op(500, xfy, v).

% Główny predykat rozwiązujący zadanie.
% UWAGA: to nie jest jeszcze rozwiązanie; należy zmienić jego
% definicję.
solve(Clauses, Solution):-
		%prosta konversja Klauzul - [p v q] -> ['p',' ','v',' ','q']
		convert_to_chars(Clauses, RawClauses),
		%zamiana charow na atomy - ['p',' ','v',' ','~','q'] -> [p,~q]
		convert_to_variables(RawClauses, ParsedClauses),
		%falsz jesli wystepuje klauzula pusta - [[],p] -> fail
		check_empty(ParsedClauses),
		%tworzy liste zmiennych bez powtorzen - [p,~p] -> [p]
		list_singles(ParsedClauses, SingleRev),
		reverse(SingleRev, Singles),
		%usuwa podwojne zmienne z klauzul - [p,p] -> [p]
		eliminate_dups(ParsedClauses, FreeDBClauses),
		%usuwa takie same znienne ale z odwrotna negacja z klauzul, dodaje 1 aby sygnalizowac klauzule zawsze prawdziwa - [p,~p] -> [1]
		eliminate_negs(FreeDBClauses, CleanClauses),
		%sprawdza, czy nie ma klauzul 'odwrotnych' - [[p,q],[~p,~q]] -> fail
		check_neg_clauses(CleanClauses),
		%tworzy tablice stalych, czyli takich co musza miec dana wartosc - [[p]],[~q]] -> (p,t),(q,f)
		get_const_singles(CleanClauses, Singles, FreshSingles,Consts),
		%patrzy, ktore zmienne juz nie istnieja w klauzulach - przypisuje im x - zmienne([x,y]), klauzule([]) -> (x,x),(y,x)
		create_x_result(FreshSingles,CleanClauses, Result_X, CleanSingles),
		%tworzy zmienne z x na podstawie tego czy sa w klauzuli z '1', usuwa je z nich
		eliminate_ones(CleanSingles, CleanClauses, Result_X2, TrueSingles, PCleanClauses),
		%przypisuje wartosci pozostalym zmiennym w postaci (p,t),(q,f)...
		next_val(TrueSingles, Res),
		%laczenie stalych z wynikiem
		append(Res,Consts,Res2),
		%sprawdzenie czy klauzule sa spelnione przy danym wartosciowaniu
		parse_values(Res2, PCleanClauses),
		%dolaczenie wartosci z x w celu utworzenia finalnego wyniku
		append(Result_X,Result_X2, RX),
		append(Res2,RX, Solution).


get_const_singles(CleanClauses, Singles, FreshSingles,Consts):-
		get_const_singles(CleanClauses, Singles, FreshSingles,Consts, [],[]).
get_const_singles([], _, Res, Res2, Res, Res2).
get_const_singles([[1]|T], Singles, AccF, AccC, _, Consts):-
		!,get_const_singles(T, Singles, AccF, AccC, Singles, Consts).

get_const_singles([[H]|T], Singles, AccF, AccC, _, Consts):-
		\+ is_neg(H,_),!,
		delete(Singles, H, NSingl),
		get_const_singles(T, NSingl, AccF, AccC, NSingl, [(H,t)|Consts]).
get_const_singles([[H]|T], Singles, AccF, AccC, _, Consts):-
		is_neg(H, NH),!,
		delete(Singles, NH, NSingl),
		get_const_singles(T, NSingl, AccF, AccC, NSingl, [(NH,f)|Consts]).
get_const_singles([_|T],Singles, AccF,AccC,_,Consts):-
		get_const_singles(T, Singles, AccF, AccC, Singles, Consts).




check_neg_clauses(Clauses):-
		check_neg_clauses(Clauses,Clauses).

check_neg_clauses([],[]).
check_neg_clauses([_|T],[]):-
		check_neg_clauses(T, T).
check_neg_clauses([H|_], [CH|_]):-
		neg_list(H,NH),
		NH == CH,!,
		fail.
check_neg_clauses(L, [_|T]):-
		check_neg_clauses(L, T).

neg_list(In, Res):-
		neg_list(In, Res, []).
neg_list([],Acc,Res):-reverse(Res,Acc).
neg_list([H|T],Acc,Res):-
		is_neg(H, NH),!,
		neg_list(T, Acc,[NH|Res]).
neg_list([H|T],Acc,Res):-
		NH = ~H,
		neg_list(T, Acc,[NH|Res]).

check_empty([]).
check_empty([[H|_]|_]):-
	H == '[]',!,
	fail.
check_empty([_|T]):-check_empty(T).

eliminate_ones(Singles,CleanClauses, Results_X,ResSingl, ResCl):-
		eliminate_ones(Singles,CleanClauses, Results_X,ResSingl,ResCl,[],[],CleanClauses).

eliminate_ones([],[_|T], AccX, AccS, AccC, ResX, Singl, Clauses):-!,
		eliminate_ones(Singl, T, AccX, AccS, AccC, ResX,[], Clauses).
eliminate_ones([],[], Res, Res2, Res3, Res, Res2, Res3).
eliminate_ones([H|T],[HC|_],AccX, AccS, AccC,ResX, Singl,Clauses):-
		\+exists_in([HC],1),
		member(H,HC),
		exists_in2(Clauses, H),
		delete_all(Clauses, H, Cl2),!,
		eliminate_ones(T, Cl2,AccX, AccS,AccC, [(H,x)|ResX],Singl, Cl2).
eliminate_ones([H|T],C, AccX, AccS,AccC, ResX, Singl, Clauses):-
		eliminate_ones(T, C, AccX, AccS,AccC, ResX, [H|Singl], Clauses).

delete_all(X, Y, Res):-
		delete_all(X,Y,Res,[]).
delete_all([],_,Acc, Res):-reverse(Res,Acc).
delete_all([H|T],El,Acc, Res):-
		delete(H, El, H2),
		delete_all(T, El, Acc, [H2|Res]).


not_empty([_|_]).
parse_values(Res, CleanClauses):-
	parse_values(Res, CleanClauses, Res).
parse_values(_, [[]|T], Res):-
	parse_values(Res, T, Res),!.
parse_values(_, [[1]|T],Res):-
	parse_values(Res, T, Res),!.
parse_values(_, [], _).

parse_values([_|T], [HL|TL], Res):-
		member(1,HL),!,
		parse_values(T, [[]|TL],Res).

parse_values([(H,V)|T], [HL|TL], Res):-
		V == t,
		member(H, HL),!,
		parse_values(T, [[]|TL], Res).
parse_values([(H,V)|T], [HL|TL], Res):-
		V == f,
		HN = ~H,
		member(HN, HL),!,
		parse_values(T, [[]|TL], Res).

parse_values([_|T],L,Res):-
		parse_values(T, L, Res).


create_x_result(Singles,CleanClauses, Result,CleanSingles):-
		create_x_result(Singles, CleanClauses, Result,CleanSingles, [], []).
create_x_result([], _, Result, Result2,Result,Result2).


create_x_result([H|TSingles],CleanClauses, Acc, Acc2, Result, Result2):-
		\+ exists_in(CleanClauses, H),!,
		create_x_result(TSingles, CleanClauses, Acc, Acc2, Result, [H|Result2]).

create_x_result([H|TSingles],CleanClauses, Acc,Acc2, Result,Result2):-
		create_x_result(TSingles, CleanClauses, Acc,Acc2, [(H,x)|Result],Result2).

member_neg(E, [E|_]):-!.
member_neg(E, [H|_]):-
		H == ~E;~H == E,!.
member_neg(E,[_|R]):- member_neg(E,R).


exists_in([],_).
exists_in([H|T],Val):-
		\+member_neg(Val, H),
		exists_in(T,Val).

exists_in2([],_).
exists_in2([H|_],Val):-
		member_neg(Val,H),
		\+member(1, H),
		!,
		fail.
exists_in2([_|T],Val):-
		exists_in2(T,Val).

next_val(List,Res):-
		next_val(List,Res,[]).
next_val([],Acc, Res):-reverse(Res,Acc).
next_val([H|T],Acc,Res):-
		next_val(T,Acc,[(H,t)|Res]).
next_val([H|T],Acc,Res):-
		next_val(T,Acc,[(H,f)|Res]).

take_n_first(Src, N, Res):- findall(E, (nth1(I,Src,E), I =< N),Res).

set_values(Singles, SinglesX, Res, Len):-
		set_values(Singles,[[]|SinglesX],Res,[],Len,0).
set_values(_,_,Res, Res, _,_):- length(Res,V),V =\= 0.
set_values(Singles,[_|SinglesXT],Acc, _, N, El):-
		N >= 0,
		take_n_first(Singles, El, Setter),
		next_val(Setter, Values),
		N2 is N - 1,
		El2 is El + 1,
		append(Values, SinglesXT, Result),
		set_values(Singles,SinglesXT,Acc, Result, N2, El2).

eliminate_negs(Clauses, Res):-
		eliminate_negs(Clauses, Res, []).
eliminate_negs([], Res, Res).
eliminate_negs([HClause|TClause], Acc, Res):-
		eliminate_negs_chars(HClause, FreeClause),
		eliminate_negs(TClause, Acc, [FreeClause|Res]).

eliminate_negs_chars(List, Res):-
		eliminate_negs_chars(List, Res,[]).
eliminate_negs_chars([], Acc, Res):-
		reverse(Res, Acc).
eliminate_negs_chars([H|T], Acc, Res):-
		remove_negs(T, H, Free),
		eliminate_negs_chars_h([H|T],Free, Acc, Res).

eliminate_negs_chars_h([H|T],[H|T], Acc, Res):- !,
		eliminate_negs_chars(T, Acc, [H|Res]).
eliminate_negs_chars_h(_,Free, Acc, Res):-
		append([1],Free, FreeR),
		eliminate_negs_chars(FreeR, Acc, Res).


eliminate_dups(ParsedClauses, FreePClauses):-
		eliminate_dups(ParsedClauses, FreePClauses, []).
eliminate_dups([], Res, Res).
eliminate_dups([HClause|TClause], Acc, Res):-
		eliminate_dups_chars(HClause, FreeClause),
		eliminate_dups(TClause, Acc, [FreeClause|Res]).

eliminate_dups_chars(List, Res):-
		eliminate_dups_chars(List, Res, []).
eliminate_dups_chars([], Acc, Res):-
		reverse(Res, Acc).
eliminate_dups_chars([H|T], Acc, Res):-
		remove_duplicates(T, H, Free),
		eliminate_dups_chars(Free, Acc, [H|Res]).

remove_negs(List, Val, Res):-
		remove_negs(List, Val, Res, [], 0).
remove_negs([], _, Acc, Res, 1):- 
		reverse(Res, Acc),!.
remove_negs([], Val, Acc, Res, 0):-
		reverse(Res, Rev),
		append([Val], Rev, Acc).

remove_negs([H|T], Val, Acc, Res,_):-
		H == ~Val,
		append(T, Res, Res2),!,
		remove_negs([], _, Acc, Res2,1).
remove_negs([H|T], Val, Acc, Res, _):-
		~H  == Val,
		append(T, Res, Res2),!,
		remove_negs([], _, Acc, Res2, 1).
remove_negs([H|T], Val, Acc, Res,C):-
		remove_negs(T, Val, Acc, [H|Res],C).


remove_duplicates(List, Val, Res):-
		remove_duplicates(List, Val, Res, []).
remove_duplicates([], _, Acc, Res):-
		reverse(Res, Acc).
remove_duplicates([H|T], Val, Acc, Res):-
		H == Val -> remove_duplicates(T, Val, Acc, Res); remove_duplicates(T, Val, Acc, [H|Res]).

is_neg(X, Res):-
		term_string(X, String),
		string_chars(String, C_Str),
		get_next(C_Str, El, C_StrT),
		El == '~',
		get_till_empty(C_StrT, Res).
get_till_empty(C_Str, Res):-
	get_till_empty(C_Str, Res, []).
get_till_empty([],Acc, Res):-reverse(Res,RRes),atom_chars(Acc,RRes).
get_till_empty([H|T],Acc, Res):-
		get_till_empty(T,Acc,[H|Res]).

list_singles(ParsedClauses, Singles):-
		list_singles(ParsedClauses, Singles, []).
list_singles([], Res,Res).
list_singles([HParsed|TParsed], Acc, Res):-
		list_chars(HParsed, Res, Y),
		list_singles(TParsed, Acc, Y).

list_chars([] ,Res, Res).
list_chars([H|List], Res, X):-
		is_neg(H, H2),
		\+ member(H2, Res),!,
		list_chars(List, [H2|Res], X).
list_chars([Char|List], Res, X):-
		\+is_neg(Char,_),
		\+ member(Char,Res),
		list_chars(List, [Char|Res], X),!.
list_chars([_|List], Res, X):-
		list_chars(List, Res, X).

%get next element from list, Return Tail for new getting next el		
get_next([], [], []):-!.
get_next([H|T], H, T).


%convert from ['p',' ','v',' ','~','q'] -> [p,~,q]
convert_to_variables(RawClauses, ParsedClauses):-
		convert_to_variables(RawClauses, ParsedClauses, []).

convert_to_variables([], Result, Result).
convert_to_variables([H|T], Acc, Result):-
		parse_chars(H, HParsed),
		reverse(HParsed, HREVParsed),
		convert_to_variables(T, Acc, [HREVParsed|Result]).
char_till_space(List, Res,NList):-
		char_till_space(List, Res, NList,[]).
char_till_space([],	Acc, [],Res):-reverse(Res,Acc),!.
char_till_space([' '|T], Acc,T,Res):-reverse(Res,Acc),!.
char_till_space([H|T], Acc,AccL, Res):-
		char_till_space(T,Acc,AccL,[H|Res]).

parse_chars(CharList, Result):-
		parse_chars(CharList, Result, []).
parse_chars([], Result, Result).
parse_chars([Char|List], Acc, Result):-
		ignore(Char, Res, List, NL),
		char_till_space(NL,Char_List,NList2),
		is_neg(Res,Res2),!,
		append([Res2], Char_List, C_Str),
		atom_chars(String,C_Str),
		parse_chars(NList2, Acc, [~String|Result]).

parse_chars([Char|List], Acc, Result):-
		ignore(Char, Res, List, NL),
		char_till_space(NL,Char_List,NList2),
		\+is_neg(Res,_),!,
		append([Res], Char_List, C_Str),
		atom_chars(String,C_Str),
		parse_chars(NList2, Acc, [String|Result]).

ignore('v', Res, List, NList):-
		get_next(List, _, T),
		get_next(T, Res2, NT),
		ignore(Res2, Res, NT, NList),
		!.
ignore(' ', Res, List, NList):-
		get_next(List, El, T),
		ignore(El, Res, T, NList),!.
ignore('~', Res, List, NList):-
		get_next(List, El, T),
		ignore(~El, Res, T, NList),!.
ignore(Char, Char, List, List):-!.

% convert from [p v ~q] -> ['p', ' ', 'v', ' ', '~', 'q']
convert_to_chars(Clauses, Result):-
		convert_to_chars(Clauses, Result, []).
convert_to_chars([], Result, Result).
convert_to_chars([HClauses|TClauses], Acc, Result):-
		term_string(HClauses, SHClauses),
		string_chars(SHClauses, X),
		convert_to_chars(TClauses, Acc, [X|Result]).
