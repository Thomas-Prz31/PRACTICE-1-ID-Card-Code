divisor(N, D) :-
    N1 is N - 1,
    between(1, N1, D),
    N mod D =:= 0.
    
suma_divisores(N, Suma) :-
    findall(D, divisor(N, D), Divisores),
    sum_list(Divisores, Suma).
    
nicomaco(N, abundant) :- suma_divisores(N, Suma), Suma > N.
nicomaco(N, perfect)  :- suma_divisores(N, Suma), Suma =:= N.
nicomaco(N, deficient):- suma_divisores(N, Suma), Suma < N.

categoria(abundant, 'Administrative').
categoria(perfect, 'Engineering').
categoria(deficient, 'Humanities').

periodo(262, '2026-2').
periodo(271, '2027-1').
periodo(272, '2027-2').
periodo(281, '2028-1').
periodo(282, '2028-2').
periodo(291, '2029-1').
periodo(292, '2029-2').

paridad(Codigo, even) :- Codigo mod 2 =:= 0.
paridad(Codigo, odd)  :- Codigo mod 2 =:= 1.

codigo_carnet(Codigo, Periodo, Categoria, Consecutivo, Paridad) :-
    integer(Codigo),
    Codigo >= 10000000,
    Codigo =< 99999999,
    NumPeriodo is Codigo // 100000,
    NumCategoria is (Codigo // 1000) mod 100,
    NumCategoria >= 1,
    NumConsecutivo is Codigo mod 1000,
    NumConsecutivo >= 1,
    periodo(NumPeriodo, Periodo),
    nicomaco(NumCategoria, Clasificacion),
    categoria(Clasificacion, Categoria),
    atom_concat(num, NumConsecutivo, Consecutivo),
    paridad(Codigo, Paridad).
    
codigo_engineering_2029_2(Codigo) :-
    between(1, 99, Categoria),
    nicomaco(Categoria, perfect),
    between(1, 999, Consecutivo),
    Codigo is 292 * 100000 + Categoria * 1000 + Consecutivo.
    
codigo_administrative_2026_2(Codigo) :-
    between(1, 99, Categoria),
    nicomaco(Categoria, abundant),
    between(1, 999, Consecutivo),
    Codigo is 262 * 100000 + Categoria * 1000 + Consecutivo.

demostracion :-

    nl(user_error),
    write(user_error, '-- Modo generar --'), nl(user_error),
    findall(Codigo, codigo_engineering_2029_2(Codigo), Todos),
    length(Todos, Total),
    length(Primeros, 10),
    append(Primeros, _, Todos),
    write(user_error, 'Primeros 10 codigos de Enginnering en 2029-2: '), nl(user_error),
    write(user_error, Primeros), nl(user_error),
    write(user_error, 'Total de codigos de Engineering en 2029-2: '),
    write(user_error, Total), nl(user_error),
    
    nl(user_error),
    findall(Codigo2, codigo_administrative_2026_2(Codigo2), Todos2),
    length(Todos2, Total2),
    length(Primeros2, 10),
    append(Primeros2, _, Todos2),
    write(user_error, 'Primeros 10 codigos de Administrative en 2026-2: '), nl(user_error),
    write(user_error, Primeros2), nl(user_error),
    write(user_error, 'Total de codigos de Administrative en 2026-2: '),
    write(user_error, Total2), nl(user_error),
    
    nl(user_error),
    write(user_error, '-- Escribe un codigo para probarlo --'), nl(user_error).
    
leer_codigos :-
    ( at_end_of_stream(user_input)
    -> true
    ; read_line_to_string(user_input, Linea),
        ( Linea == ""
        -> true
        ; ( catch(number_string(Codigo, Linea), _, fail)
          -> ( codigo_carnet(Codigo, P, C, N, Par)
             -> write(P), write(' '), write(C), write(' '), write(N), write(' '), write(Par), nl
             ;  write('Invalid code: '), write(Codigo), nl
             )
           ; write('Invalid code: '), write(Linea), nl
           ),
           leer_codigos
        )
    ).
    
main :-
    demostracion,
    leer_codigos.
    
:- initialization(main, main).
