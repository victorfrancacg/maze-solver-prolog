% Logica do jogo de pega-pega no labirinto.
% Dois jogadores IA: o perseguidor (playerA) tenta capturar o perseguido (playerB),
% O perseguido tenta chegar na saida (exit) antes de ser pego.
% Ambos se movem usando BFS para encontrar o menor caminho até o seu objetivo.

:- module(game_logic, [
    initial_game_state/2,
    initial_game_state/3,
    check_result/2
]).

:- use_module(types).
:- use_module(utils).
:- use_module(generate).

% Cria o estado inicial do jogo.
% Gera o labirinto, coloca exit, e posiciona os dois jogadores
% em celulas vazias aleatorias (distintas entre si e do exit).
initial_game_state(NumLinhas, NumColunas, GameState) :-
    generate_maze(NumLinhas, NumColunas, false, Grid0),

    % Coloca a saida em uma posicao vazia aleatoria
    random_empty_pos(Grid0, (EL, EC)),
    set_cell(Grid0, EL, EC, exit, Grid),

    random_empty_pos(Grid, PosA),
    random_empty_pos_excluding(Grid, PosA, PosB),

    GameState = game_state(Grid, PosA, PosB, playerA, in_progress).

% Versao que recebe o grid ja pronto.
initial_game_state(Grid, GameState) :-
    random_empty_pos(Grid, PosA),
    random_empty_pos_excluding(Grid, PosA, PosB),
    GameState = game_state(Grid, PosA, PosB, playerA, in_progress).

% Verifica se o jogo acabou e qual o resultado.
check_result(game_state(_Grid, PosA, PosB, _Turno, _), playerA_wins) :-
    PosA == PosB, !.

check_result(game_state(Grid, _PosA, PosB, _Turno, _), playerB_wins) :-
    get_cell(Grid, L, C, exit),
    PosB == (L, C), !.

check_result(game_state(_Grid, _PosA, _PosB, _Turno, _), in_progress).

% Movimentacao dos jogadores (é regida por uma "inteligencia artificial", simulada através do algoritmo de busca em largura

% O perseguidor (A) se move em direcao ao fugitivo (B).
ai_move_chaser(game_state(Grid, PosA, PosB, _, _), NovaPosA) :-
    bfs_next_move(Grid, PosA, PosB, NovaPosA), !.

% Se nao encontrou caminho, fica parado
ai_move_chaser(game_state(_, PosA, _, _, _), PosA).

% O perseguido (B) se move em direcao a saida (exit).
ai_move_runner(game_state(Grid, _PosA, PosB, _, _), NovaPosB) :-
    find_exit(Grid, PosExit),
    bfs_next_move(Grid, PosB, PosExit, NovaPosB), !.
% Se nao encontrou caminho, fica parado
ai_move_runner(game_state(_, _, PosB, _, _), PosB).

% Encontra a posicao da saida no grid.
find_exit(Grid, (L, C)) :-
    grid_dimensions(Grid, NumLinhas, NumColunas),
    MaxL is NumLinhas - 1,
    MaxC is NumColunas - 1,
    between(0, MaxL, L),
    between(0, MaxC, C),
    get_cell(Grid, L, C, exit), !.

% BFS generica para encontrar o proximo passo

bfs_next_move(Grid, Origem, Destino, ProximoPasso) :-
    Origem \= Destino,
    bfs_game([Origem], [Origem], [], Grid, Destino, Pais),
    reconstruct_path_game(Pais, Destino, Origem, Caminho),
    % Caminho = [Origem, ProximoPasso, ...]
    Caminho = [_, ProximoPasso | _].

% Se ja esta no destino, nao precisa se mover.
bfs_next_move(_, Pos, Pos, Pos).

% Caso base: encontrou o destino.
bfs_game([Destino|_], _Visitados, Pais, _Grid, Destino, Pais).

% Caso recursivo: expande o primeiro da fila.
bfs_game([Atual|Resto], Visitados, Pais, Grid, Destino, PaisFinal) :-
    Atual \= Destino,
    get_game_neighbors(Grid, Atual, Vizinhos),
    filter_not_visited_game(Vizinhos, Visitados, NovosVizinhos),
    maplist(make_parent_game(Atual), NovosVizinhos, NovosPais),
    append(Pais, NovosPais, PaisAtualizado),
    append(Resto, NovosVizinhos, NovaFila),
    append(Visitados, NovosVizinhos, NovosVisitados),
    bfs_game(NovaFila, NovosVisitados, PaisAtualizado, Grid, Destino, PaisFinal).

% Fila vazia = nao encontrou caminho.
bfs_game([], _, _, _, _, _) :- fail.

% Retorna vizinhos validos (adjacentes, nao-parede, dentro dos limites).
get_game_neighbors(Grid, (L, C), Vizinhos) :-
    findall(
        (NL, NC),
        (   member((DL, DC), [(-1, 0), (1, 0), (0, -1), (0, 1)]),
            NL is L + DL,
            NC is C + DC,
            in_bounds(Grid, NL, NC),
            get_cell(Grid, NL, NC, Celula),
            Celula \= wall
        ),
        Vizinhos
    ).

make_parent_game(Pai, Filho, parent(Filho, Pai)).

% Filtra posicoes ja visitadas.
filter_not_visited_game([], _, []).
filter_not_visited_game([Pos|Resto], Visitados, Resultado) :-
    (   member(Pos, Visitados)
    ->  filter_not_visited_game(Resto, Visitados, Resultado)
    ;   Resultado = [Pos|RestoFiltrado],
        filter_not_visited_game(Resto, Visitados, RestoFiltrado)
    ).

% Reconstroi o caminho do destino ate a origem.
reconstruct_path_game(_Pais, Pos, Pos, [Pos]).
reconstruct_path_game(Pais, PosAtual, PosOrigem, Caminho) :-
    PosAtual \= PosOrigem,
    member(parent(PosAtual, Pai), Pais),
    reconstruct_path_game(Pais, Pai, PosOrigem, CaminhoAnterior),
    append(CaminhoAnterior, [PosAtual], Caminho).

