% Aqui estamos definindo os tipos de celula e operacoes sobre o grid
% O labirinto e representado como uma matriz,
% onde cada elemento representa o tipo da celula.

:- module(types, [
    cell_char/2,
    create_grid/4,
    get_cell/4,
    set_cell/5,
    grid_dimensions/3
]).

% Mapeia cada tipo de celula ao caractere que sera exibido no terminal.
cell_char(wall, '#').
cell_char(empty, '.').
cell_char(start, 'S').
cell_char(exit, 'E').
cell_char(path, '@').
cell_char(visited, 'o').

% Cria um grid n x m preenchido com 'CelulaDefault'.
% Exemplo: create_grid(3, 4, wall, G) cria um grid 3x4 de paredes.
create_grid(NumLinhas, NumColunas, CelulaDefault, Grid) :-
    length(Linha, NumColunas),
    maplist(=(CelulaDefault), Linha),
    length(Grid, NumLinhas),
    maplist(=(Linha), Grid).

% Retorna a celula na posicao (i, j) do grid (0-indexado).
get_cell(Grid, Linha, Col, Celula) :-
    nth0(Linha, Grid, LinhaLista),
    nth0(Col, LinhaLista, Celula).

% Retorna um novo grid identico ao original, mas com a celula
% na posicao (i, j) substituida por NovaCelula.
set_cell(Grid, Linha, Col, NovaCelula, NovoGrid) :-
    nth0(Linha, Grid, LinhaAntiga),
    replace_nth0(Col, LinhaAntiga, NovaCelula, LinhaNova),
    replace_nth0(Linha, Grid, LinhaNova, NovoGrid).

% Substitui o elemento na posicao I da Lista por NovoElemento.
replace_nth0(0, [_|T], Novo, [Novo|T]).
replace_nth0(I, [H|T], Novo, [H|R]) :-
    I > 0,
    I1 is I - 1,
    replace_nth0(I1, T, Novo, R).

% Retorna as dimensoes do grid.
grid_dimensions(Grid, NumLinhas, NumColunas) :-
    length(Grid, NumLinhas),
    Grid = [PrimeiraLinha|_],
    length(PrimeiraLinha, NumColunas).
