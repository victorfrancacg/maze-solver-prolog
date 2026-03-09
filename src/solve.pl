% Resolucao do labirinto usando busca em largura.
% Garante encontrar o menor caminho entre 'start' e 'exit'.
% Tambem gera os frames intermediarios da busca para animacao.

:- module(solve, [
    solve/2,
    solve_path/2,
    solve_steps/2
]).

:- use_module(types).
:- use_module(utils).

% Resolve o labirinto e retorna o grid com o caminho marcado.
solve(Grid, GridResolvido) :-
    solve_path(Grid, Caminho),
    mark_path(Grid, Caminho, GridResolvido).

% Retorna a lista de posicoes do menor caminho (start -> exit).
solve_path(Grid, Caminho) :-
    find_cell(Grid, start, PosStart),
    find_cell(Grid, exit, PosExit),
    bfs([PosStart], [PosStart], [], Grid, PosExit, Pais),
    reconstruct_path(Pais, PosExit, PosStart, Caminho).

% Retorna uma lista de grids (frames), cada um representando
% um passo da BFS. Usado para animar a exploracao no terminal.
solve_steps(Grid, Frames) :-
    find_cell(Grid, start, PosStart),
    find_cell(Grid, exit, PosExit),
    bfs_steps([PosStart], [PosStart], [], Grid, PosExit, [], Pais, FramesExplor),
    reconstruct_path(Pais, PosExit, PosStart, Caminho),
    mark_path(Grid, Caminho, GridFinal),
    append(FramesExplor, [GridFinal], Frames).

% Caso base: o primeiro da fila eh o destino, terminou.
bfs([PosExit|_], _Visitados, Pais, _Grid, PosExit, Pais).

% Caso recursivo: expande o primeiro da fila, adiciona vizinhos nao visitados.
bfs([Atual|Resto], Visitados, Pais, Grid, PosExit, PaisFinal) :-
    Atual \= PosExit,
    get_bfs_neighbors(Grid, Atual, Vizinhos),
    filter_not_visited(Vizinhos, Visitados, NovosVizinhos),
    maplist(make_parent(Atual), NovosVizinhos, NovosPais),
    append(Pais, NovosPais, PaisAtualizado),
    append(Resto, NovosVizinhos, NovaFila),
    append(Visitados, NovosVizinhos, NovosVisitados),
    bfs(NovaFila, NovosVisitados, PaisAtualizado, Grid, PosExit, PaisFinal).

% Caso base: chegou no destino.
bfs_steps([PosExit|_], Visitados, Pais, Grid, PosExit, FramesAcc, Pais, Frames) :-
    % Gera o ultimo frame de exploracao
    mark_visited(Grid, Visitados, GridVisitado),
    append(FramesAcc, [GridVisitado], Frames).

% Caso recursivo: expande e gera um frame a cada passo.
bfs_steps([Atual|Resto], Visitados, Pais, Grid, PosExit, FramesAcc, PaisFinal, Frames) :-
    Atual \= PosExit,
    get_bfs_neighbors(Grid, Atual, Vizinhos),
    filter_not_visited(Vizinhos, Visitados, NovosVizinhos),
    maplist(make_parent(Atual), NovosVizinhos, NovosPais),
    append(Pais, NovosPais, PaisAtualizado),
    append(Resto, NovosVizinhos, NovaFila),
    append(Visitados, NovosVizinhos, NovosVisitados),
    mark_visited(Grid, NovosVisitados, GridVisitado),
    append(FramesAcc, [GridVisitado], NovosFrames),
    bfs_steps(NovaFila, NovosVisitados, PaisAtualizado, Grid, PosExit, NovosFrames, PaisFinal, Frames).

% Retorna os vizinhos validos (adjacentes, nao-parede, dentro dos limites).
get_bfs_neighbors(Grid, (L, C), Vizinhos) :-
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

% Cria um par pai-filho: parent(Filho, Pai).
make_parent(Pai, Filho, parent(Filho, Pai)).

% Filtra posicoes que ja foram visitadas.
filter_not_visited([], _, []).
filter_not_visited([Pos|Resto], Visitados, Resultado) :-
    (   member(Pos, Visitados)
    ->  filter_not_visited(Resto, Visitados, Resultado)
    ;   Resultado = [Pos|RestoFiltrado],
        filter_not_visited(Resto, Visitados, RestoFiltrado)
    ).

% Reconstroi o caminho do exit ate o start usando a lista de pais.
reconstruct_path(_Pais, Pos, Pos, [Pos]).
reconstruct_path(Pais, PosAtual, PosStart, Caminho) :-
    PosAtual \= PosStart,
    member(parent(PosAtual, Pai), Pais),
    reconstruct_path(Pais, Pai, PosStart, CaminhoAnterior),
    append(CaminhoAnterior, [PosAtual], Caminho).

% Marca as posicoes do caminho como 'path' no grid.
% Preserva start e exit.
mark_path(Grid, [], Grid).
mark_path(Grid, [(L, C)|Resto], GridFinal) :-
    get_cell(Grid, L, C, Celula),
    (   (Celula = start ; Celula = exit)
    ->  mark_path(Grid, Resto, GridFinal)
    ;   set_cell(Grid, L, C, path, Grid1),
        mark_path(Grid1, Resto, GridFinal)
    ).

% Marca as posicoes visitadas como 'visited' no grid.
% Preserva start e exit.
mark_visited(Grid, [], Grid).
mark_visited(Grid, [(L, C)|Resto], GridFinal) :-
    get_cell(Grid, L, C, Celula),
    (   (Celula = start ; Celula = exit)
    ->  mark_visited(Grid, Resto, GridFinal)
    ;   set_cell(Grid, L, C, visited, Grid1),
        mark_visited(Grid1, Resto, GridFinal)
    ).

% Encontra a posicao de uma celula especifica no grid.
find_cell(Grid, Tipo, (L, C)) :-
    grid_dimensions(Grid, NumLinhas, NumColunas),
    MaxL is NumLinhas - 1,
    MaxC is NumColunas - 1,
    between(0, MaxL, L),
    between(0, MaxC, C),
    get_cell(Grid, L, C, Tipo), !.
