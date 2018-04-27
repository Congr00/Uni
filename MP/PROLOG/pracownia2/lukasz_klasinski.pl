% Definiujemy moduł zawierający rozwiązanie.
% Należy zmienić nazwę modułu na {imie}_{nazwisko} gdzie za
% {imie} i {nazwisko} należy podstawić odpowiednio swoje imię
% i nazwisko bez wielkich liter oraz znaków diakrytycznych
:- module(lukasz_klasinski, [resolve/4, prove/2]).

% definiujemy operatory ~/1 oraz v/2
:- op(200, fx, ~).
:- op(500, xfy, v).

% Szukanie rezolwenty.

resolve(_, R, L, Resolvent):-
		% zamiana na ['p',' ','v',' ','~','q']
		convert_to_chars([R,L], Parsed),
		% zamiana na [p v ~q]
		convert_to_variables(Parsed, VarList),
		% sortowanie alfabetycznie kazdej klauzuli
		sort_clauses(VarList, SortedList),
		% rozdzielenie wartosci z negacja oraz bez na 2 tablice -> [[p],[q],axiom]
		merge_and_list(SortedList, MSorted),
		% usuniecie tej samej zmiennej wystepujacej z neg i bez -> [[p],[p],axiom] -> [[],[],axiom]
		remove_dups(MSorted, Free),
		% dodanie zer do klauzul, potrzebne dla kompatybilnosci z resolve_parsed -> [[p],[q],axiom,0]
		fill_zero(Free, ZFree),
		% pobranie kolejnych klauzul (tutaj mamy tylko 2)
		get_next(ZFree, C1, T),
		get_next(T, C2, _),
		% rezolucja na klauzulach
		resolve_parsed(C1, C2, Resolvent_Raw),
		% zamiana postaci sparsowanej na czytelna
		raw_to_output(Resolvent_Raw, Res),
		%sprawdzanie czy nie uzyskalismy klauzuli pustej - wyjatki
		check_empty(Res,Resolvent).


check_empty('',[]):-!.
check_empty('[]',[]):-!.
check_empty(end_of_file,[]):-!.
check_empty(Res,Res).

% Główny predykat rozwiązujący zadanie.

prove([],_):-!,fail.
prove([[]],X):-
		X = [([],axiom)].
prove(Clauses, Proof) :-
		% to samo co w resolve
		convert_to_chars(Clauses, Res),
		% --||--
		convert_to_variables(Res, Res2),
		% --||--
		sort_clauses(Res2, Sorted),
		% --||--
		merge_and_list(Sorted, MSorted),
		% --||--
		remove_dups(MSorted, Clear),
		% patrzymy czy nie uzyskalismy klauzuli pustej -> oznacza to tautologie, wtedy zwraca falsz
		check_empty_clause(Clear),
		% ilosc klauzul
		length(Clear, ClausesSum),
		% --||--
		fill_zero(Clear,Ready),
		% predykat rekursywnie znajdujacy dowod
		prove_rec(Ready, ProofRaw,ClausesSum),
		Proof = ProofRaw.



prove_rec(Clauses, Proof, ClausesSum):-
		prove_rec(Clauses, Proof, [], ClausesSum, [], 1).

prove_rec(_,Proof,[H|T],_,_,_):-
		% patrzymy czy nie dostalismy klauzulu pustej
		check_end(H),
		reverse([H|T],Rev),
		% zamieniamy na czytelny output
		raw_to_output_rec(Rev, HalfRaw),
		% dodajemy (1,2) oraz axiom + zmienne do dowodu
		prepare_proof(HalfRaw,Rev,Proof),!.

prove_rec(Clauses, Proof, Acc,ClausesSum, Resolvents,Num):-
		% bierzemy numery kolejnych par do rezolucji -> (1,2),(1,3)...(2,3),(2,4)... dopoki nie przekroczymy liczby klauzul
		get_next_num_till(ClausesSum,Numbers),
		% pracujemy na klauzulach z rezolwentami
		append(Resolvents, Clauses, Merged),
		% pobieramy n-te klauzule z listy
		get_nth_clauses(Merged, Numbers, C1, C2),
		% patrzymy czy mozna wykonac rezolucje
		\+ check_possible(C1,C2),
		% nadajemy kolejnym klauzula dowodu odpowiedni numer 1,2,3...
		% jesli klauzula ma juz przypisany numer(inny niz 0, dlatego trzeba bylo zerowac wczesniej), to
		% give_number zwraca Num - 1, dzieki czemu nie musimy martwic ze wzrosnie za duzo
		give_number(C1, Num, C1N,NNum),
		Num2 is NNum + 1,
		give_number(C2, Num2, C2N, NNum2),
		Num3 is NNum2 + 1,
		% predykat rezolucyjny 2 klauzule
		resolve_parsed(C1, C2, ResolvU),
		% patrzymy czy nie ma w liscie rezolwent tego samego elementu co ResolvU, wtedy zwraca \+ true
		\+ check_for_doubles(ResolvU,Resolvents),
		% dajemy numer tak jak wczesniej tylko rezolwencie
		give_number(ResolvU, Num3, ResolvN, _),
		Num4 is Num3 + 1,
		% dajemy rezolwencie pare ktora mowi z czego powstala np (p,1,2) lub (p,2,1) zaleznie od tego gdzie byla
		% negacja
		give_pair(C1N, C2N, ResolvN, Resolv),
		% zwiekszamy liczba klauzul
		NSum is ClausesSum + 1,
		% Dodajemy klauzule do dowodu jesli jej wczesniej nie bylo
		append_z([C1N,C2N,Resolv], Acc, NAcc),
		% liczymy offset, poniewaz nasze pary sa na Clauses + Resolvents, a chcemy wymienic nr klauzuli w dowodzie
		% na nowy, dlatego aby wymienic je na nowe trzeba pracowac na liczbach z miejszego zbioru, jak mozna
		% zauwazyc Clauses sie nie zmienia jesli chodzi o liczbe elementow
		length(Resolvents, Offset),
		% odjecie od pary offsetu
		subs_offset(Offset, Numbers, ONumbers),
		% zastapienie, jesli C1N lub C2N nie sa axiom, nic z nimi nie robi
		replace_nth(Clauses, C1N, C2N, ONumbers, FClauses),
		% dodanie nowej rezolwenty do listy
		append([Resolv], Resolvents, ResolvR),
		% rekursja na nowej liscie klauzul
		prove_rec(FClauses, Proof, NAcc, NSum, ResolvR, Num4).


check_for_doubles((X,Y,_,_),[(X,Y,_,_)|_]):-!.
check_for_doubles(X,[_|T]):-
		check_for_doubles(X,T).

subs_offset(Offset, (X,Y),Res):-
		X1 is X - Offset,
		Y1 is Y - Offset,
		Res = (X1,Y1).

prepare_proof([],_,[]):-!.
prepare_proof([H|T],[(_,_,X,_)|T2], [(H,X)|Res]):-
		prepare_proof(T,T2,Res).

replace_nth(Clauses, C1, C2, (X1,X2),Res):-
		replace_nth_p(Clauses, C1,X1, Res1),
		replace_nth_p(Res1, C2,X2,Res).

replace_nth_p(Res,(_,_,(_,_),_),_,Res):-
		!.
replace_nth_p([_|T],Repl,1,Res):-
		Res = [Repl|T],!.
replace_nth_p([H|T],Repl,X,[H|Res]):-
		X1 is X - 1,
		replace_nth_p(T,Repl,X1,Res).

append_z([C1,C2,R],Acc, Result):-
		app_if_nmember(C1, Acc, Acc1),
		app_if_nmember(C2, Acc1, Acc2),
		append([R], Acc2, Result).

app_if_nmember(C1,Acc,Res):-
		\+ member(C1,Acc),
		append([C1],Acc,Res),!.
app_if_nmember(_,Acc,Acc).

check_end(([],[],_,_)).

give_pair((PX,PY,_,X),(_,_,_,Y),(P,N,_,Num), Pair):-
		get_missing(PX,P,M),
		get_missing(PY,P,M),
		insert_(PX,M,X,Y, X1,Y1),
		Pair = (P,N,(M,X1,Y1),Num).

insert_(PX,Val,X,Y, X1,Y1):-
		member(Val,PX),
		X1 = X,
		Y1 = Y,
		!.
insert_(_,_,X,Y,X1,Y1):-
		X1 = Y, Y1 = X.

get_missing(_,_,M):-
		\+ var(M),!.
get_missing([],_,_):-!.
get_missing([H|_],P,M):-
		\+member(H,P),!,
		M = H.
get_missing([_|T],P,M):-
		get_missing(T,P,M).

give_number((X,Y,Z,0),Num,(X,Y,Z,Num),Num):-!.
give_number(Cl,Num,Y, X):-
		X is Num - 1,
		Y = Cl.

fill_zero([], []):-!.
fill_zero([(X,Y,Z)|T],[(X,Y,Z,0)|Res]):-
		fill_zero(T,Res).

check_possible((X,Y,_,_), (X1,Y1,_,_)):-
		\+ check_possible_p(X,Y1),
		\+ check_possible_p(X1,Y).

check_possible_p(X,Y1):-
		check_possible_p(X,Y1,0).

check_possible_p(_,_,2):-!,fail.
check_possible_p([],_,1):-!.
check_possible_p([],_,0):-!,fail.
check_possible_p([H|T], X, Sum):-
		\+ member(H,X),!,
		check_possible_p(T,X, Sum).

check_possible_p([_|T],X,Sum):-
		Sum1 is Sum + 1,
		check_possible_p(T,X,Sum1).

get_nth_clauses(Clauses,(X1, X2), C1, C2):-
		get_nth(Clauses,X1, C1),
		get_nth(Clauses,X2, C2).

get_nth([H|_], Cnt, Res):-
		Cnt is 1,!,
		Res = H.
get_nth([_|T], Cnt, Res):-
		Cnt2 is Cnt - 1,
		get_nth(T, Cnt2, Res).

check_empty_clause([]):-!.
check_empty_clause([([],[],_)|_]):-!,fail.
check_empty_clause([_|T]):-
		check_empty_clause(T).

next_nat_dod_till(X,Limit,Res):-
		X is Limit,
		!,
		Res = X.
next_nat_dod_till(X,_,X).
next_nat_dod_till(X, Limit, Res):-
		X1 is X + 1,
		next_nat_dod_till(X1, Limit, Res).

get_next_num_till(Limit,Res):-
		next_nat_dod_till(1,Limit,X1),
		next_nat_dod_till(X1,Limit,Y1),
		\+ X1 is Y1,
		Res = (X1,Y1).


remove_dups(Clauses, Res):-
		remove_dups(Clauses, [], Res).

remove_dups([], Acc, Res):-reverse(Acc,Res),!.
remove_dups([(X,Y,Nr)|T],Acc, Res):-
		remove_dups_s((X,Y,_), X1),
		remove_dups_s((Y,X,_),X2),
		append([(X1,X2,Nr)], Acc, NAcc),
		remove_dups(T, NAcc,Res).
remove_dups_s(([],_,_),[]):-!.
remove_dups_s(([H|T],X,_), Res):-
		member(H,X),!,
		remove_dups_s((T,X,_),Res).
remove_dups_s(([H|T],X,_), [H|Res]):-
		remove_dups_s((T,X,_),Res).

raw_append(X, [], X):-!.
raw_append([], X, X):-!.
raw_append(X,Y,Z):-
		append(X, [' ','v',' '], X2),
		append(X2,Y,Z).

raw_to_output_rec([],[]):-!.
raw_to_output_rec([([],[],_,_)|T],[[]|Res]):-
		!,raw_to_output_rec(T,Res).
raw_to_output_rec([H|T],[X|Res]):-
		raw_to_output(H,X),
		raw_to_output_rec(T,Res).
		

raw_to_output(Clause, Res):-
		raw_to_output_pos(Clause, [],Res1),
		raw_to_output_neg(Clause, [],Res2),
		raw_append(Res1, Res2,Res3),
		string_chars(ResS,Res3),
		atom_string(ResA, ResS),
		term_to_atom(Res, ResA).

raw_to_output_neg((_,[],_,_),Acc, Res):-reverse(Acc, Res),!.
raw_to_output_neg((_,[H1,H2|T],_,_),Acc,Res):-!,
		string_chars(H1, H1C),
		reverse(H1C,RH1C),
		append(RH1C,['~'],H1CN),
		append([' ', 'v', ' '],H1CN,HRes),
		append(HRes, Acc, NAcc),
		raw_to_output_neg((_,[H2|T],_,_), NAcc, Res).
raw_to_output_neg((_,[H1|[]],_,_), Acc,Res):-
		string_chars(H1, H1C),
		reverse(H1C, RH1C),
		append(RH1C,['~'],HRes),
		append(HRes, Acc, NAcc),
		raw_to_output_neg((_,[],_),NAcc,Res).

raw_to_output_pos(([],_,_),Acc,Res):-reverse(Acc,Res),!.
raw_to_output_pos(([H1,H2|T],_,_),Acc,Res):-!,
		string_chars(H1,H1C),
		reverse(H1C,RH1C),
		append([' ', 'v', ' '],RH1C, HRes),
		append(HRes, Acc, NAcc),
		raw_to_output_pos(([H2|T],_,_),NAcc, Res).
raw_to_output_pos(([H1|[]],_,_),Acc,Res):-
		string_chars(H1,H1C),
		reverse(H1C,RH1C),
		append(RH1C, Acc, NAcc),
		raw_to_output_pos(([],_,_),NAcc,Res).

resolve_parsed((Clause_R,Clause_R_Neg,_, _), (Clause_L, Clause_L_Neg,_,_), Resolvent):-
		append(Clause_R, Clause_L, CMerged),
		sort(CMerged, CSorted),
		append(Clause_R_Neg, Clause_L_Neg, CMerged_Neg),
		sort(CMerged_Neg, CSorted_Neg),
		resolve_parsed_p(CSorted, CSorted_Neg, Resolvent_pos),
		resolve_parsed_p(CSorted_Neg, CSorted, Resolvent_neg),
		Resolvent = (Resolvent_pos, Resolvent_neg, r, 0).


resolve_parsed_p([], _, []):-!.
resolve_parsed_p([RH|T],X, Result):-
		member(RH, X),!,
		resolve_parsed_p(T, X, Result).
resolve_parsed_p([RH|T],X,[RH|Result]):-
		resolve_parsed_p(T,X,Result).

merge_and_list([], []):-!.
merge_and_list([Clause|T], [Listed|Result]):-
		merge(Clause, (Pos,Neg)),
		Listed = (Pos, Neg, axiom),
		merge_and_list(T, Result).

merge([], ([],[])):-!.
merge([~A|T],(Pos,[A|Neg])):-!,
		merge(T, (Pos,Neg)).
merge([A|T], ([A|Pos], Neg)):-
		merge(T, (Pos, Neg)).

sort_clauses([], []):-!.
sort_clauses([Clause|T], [Sorted|Result]):-
		sort(Clause, Sorted),
		sort_clauses(T, Result).

%import pracownia1
	
get_next([], [], []):-!.
get_next([H|T], H, T).

get_till_empty(C_Str, Res):-
	get_till_empty(C_Str, Res, []).
get_till_empty([],Acc, Res):-reverse(Res,RRes),atom_chars(Acc,RRes).
get_till_empty([H|T],Acc, Res):-
		get_till_empty(T,Acc,[H|Res]).

is_neg(X, Res):-
		term_string(X, String),
		string_chars(String, C_Str),
		get_next(C_Str, El, C_StrT),
		El == '~',
		get_till_empty(C_StrT, Res).

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


convert_to_chars(Clauses, Result):-
		convert_to_chars(Clauses, Result, []).
convert_to_chars([], Result, Result).
convert_to_chars([HClauses|TClauses], Acc, Result):-
		term_string(HClauses, SHClauses),
		string_chars(SHClauses, X),
		convert_to_chars(TClauses, Acc, [X|Result]).
