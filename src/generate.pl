% Geraçao do labirinto usando "DFS com backtracking recursivo".
% Começa com um grid todo de paredes e vai "cavando" caminhos,
% garantindo que o labirinto gerado seja totalmente conectado.

:- module(generate, [
    generate_maze/4
]).

:- use_module(types).
:- use_module(utils).

% Gera um labirinto com as dimensoes dadas.
% As dimensoes sao ajustadas para serem impares (requisito do algoritmo).
generate_maze(NumLinhas, NumColunas, PlaceMarkers, GridFinal) :-
    ensure_odd(NumLinhas, Linhas),
    ensure_odd(NumColunas, Colunas),
    create_grid(Linhas, Colunas, wall, GridInicial),
    carve_maze(GridInicial, 1, 1, GridCavado),
    place_markers_if_needed(PlaceMarkers, GridCavado, GridFinal).

% Se N ja eh impar, mantem. Se eh par, soma 1.
% O algoritmo de DFS precisa de dimensoes impares pra funcionar.
ensure_odd(N, N) :-
    N >= 5,
    N mod 2 =:= 1, !.
ensure_odd(N, NOdd) :-
    N < 5, !,
    NOdd = 5.
ensure_odd(N, NOdd) :-
    N mod 2 =:= 0,
    NOdd is N + 1.

% DFS: marca a posicao atual como 'empty',
% pega os vizinhos a 2 celulas de distancia, embaralha,
% e para cada vizinho nao visitado, remove a parede entre eles e recursa.
carve_maze(Grid, Linha, Col, NovoGrid) :-
    set_cell(Grid, Linha, Col, empty, Grid1),
    get_carve_neighbors(Grid1, Linha, Col, Vizinhos),
    shuffle(Vizinhos, VizinhosEmbaralhados),
    carve_neighbors(Grid1, Linha, Col, VizinhosEmbaralhados, NovoGrid).

% Processa cada vizinho, remove a parede intermediaria e continua o DFS a partir dele.
carve_neighbors(Grid, _, _, [], Grid).
carve_neighbors(Grid, Linha, Col, [(VL, VC)|Resto], NovoGrid) :-
    get_cell(Grid, VL, VC, wall), !,
    % Calcula a posicao da parede entre a celula atual e o vizinho
    MeioL is (Linha + VL) // 2,
    MeioC is (Col + VC) // 2,
    set_cell(Grid, MeioL, MeioC, empty, Grid1),
    carve_maze(Grid1, VL, VC, Grid2),
    carve_neighbors(Grid2, Linha, Col, Resto, NovoGrid).
carve_neighbors(Grid, Linha, Col, [_|Resto], NovoGrid) :-
    carve_neighbors(Grid, Linha, Col, Resto, NovoGrid).

% Retorna os vizinhos a 2 celulas de distancia
% que estejam dentro dos limites do grid.
% A distancia de 2 eh necessaria para manter as paredes entre os caminhos.
get_carve_neighbors(Grid, Linha, Col, Vizinhos) :-
    grid_dimensions(Grid, NumLinhas, NumColunas),
    MaxL is NumLinhas - 1,
    MaxC is NumColunas - 1,
    findall(
        (NL, NC),
        (   member((DL, DC), [(-2, 0), (2, 0), (0, -2), (0, 2)]),
            NL is Linha + DL,
            NC is Col + DC,
            NL >= 0, NL =< MaxL,
            NC >= 0, NC =< MaxC
        ),
        Vizinhos
    ).

place_markers_if_needed(false, Grid, Grid).
place_markers_if_needed(true, Grid, GridFinal) :-
    random_empty_pos(Grid, (SL, SC)),
    set_cell(Grid, SL, SC, start, Grid1),
    random_empty_pos_excluding(Grid1, (SL, SC), (EL, EC)),
    set_cell(Grid1, EL, EC, exit, GridFinal).
