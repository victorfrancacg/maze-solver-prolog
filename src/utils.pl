% Utilitarios necessários para o desenvolimento do código
% Funcoes auxiliares usadas por varios modulos no projeto:
% embaralhamento de listas, escolha aleatoria, verificacao de limites, etc.

:- module(utils, [
    shuffle/2,
    random_element/2,
    in_bounds/3,
    random_empty_pos/2,
    random_empty_pos_excluding/3
]).

:- use_module(types).

% Embaralha uma lista usando o metodo Fisher-Yates.
% Associa um valor aleatorio a cada elemento, ordena por esse valor,
% e extrai os elementos de volta.
shuffle([], []).
shuffle(Lista, Embaralhada) :-
    maplist(tag_random, Lista, Tagged),
    msort(Tagged, Sorted),
    maplist(untag, Sorted, Embaralhada).

% Associa uma chave aleatoria ao elemento para embaralhamento.
tag_random(Elem, Rand-Elem) :-
    random(Rand).

% Remove a chave aleatoria, retornando so o elemento.
untag(_-Elem, Elem).

% Escolhe um elemento aleatorio da lista.
random_element(Lista, Elemento) :-
    length(Lista, Len),
    Len > 0,
    Max is Len - 1,
    random_between(0, Max, Index),
    nth0(Index, Lista, Elemento).

% Verifica se a posicao (i, j) esta dentro dos limites do grid.
in_bounds(Grid, Linha, Col) :-
    grid_dimensions(Grid, NumLinhas, NumColunas),
    Linha >= 0, Linha < NumLinhas,
    Col >= 0, Col < NumColunas.

% Coleta todas as posicoes que contem celulas 'empty' no grid.
all_empty_positions(Grid, Posicoes) :-
    grid_dimensions(Grid, NumLinhas, NumColunas),
    MaxLinha is NumLinhas - 1,
    MaxCol is NumColunas - 1,
    findall(
        (L, C),
        (between(0, MaxLinha, L),
         between(0, MaxCol, C),
         get_cell(Grid, L, C, empty)),
        Posicoes
    ).

% Retorna uma posicao aleatoria que contenha uma celula 'empty'.
random_empty_pos(Grid, Pos) :-
    all_empty_positions(Grid, Posicoes),
    random_element(Posicoes, Pos).

% Retorna uma posicao aleatoria 'empty', excluindo uma posicao especifica.
random_empty_pos_excluding(Grid, PosExcluida, Pos) :-
    all_empty_positions(Grid, Todas),
    exclude(=(PosExcluida), Todas, Filtradas),
    random_element(Filtradas, Pos).
