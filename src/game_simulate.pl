% Simulacao e animacao do jogo de pega-pega.
% Renderiza o estado do jogo (com os jogadores A e B no grid)
% e anima a sequencia de estados.

:- module(game_simulate, [
    render_game_state/1,
    render_game_state_colored/1,
    animate_game/1,
    animate_game/2
]).

:- use_module(types).
:- use_module(render).

% Codigos ANSI para cores dos jogadores.
ansi_red('\033[31m').
ansi_blue('\033[34m').
ansi_yellow('\033[33m').
ansi_reset('\033[0m').

% Renderiza o estado do jogo no terminal.
% Sobrepoe os jogadores A e B no grid antes de imprimir.
render_game_state(game_state(Grid, PosA, PosB, _Turno, _Resultado)) :-
    overlay_players(Grid, PosA, PosB, GridComJogadores),
    render_grid(GridComJogadores).

render_game_state_colored(game_state(Grid, PosA, PosB, _Turno, _Resultado)) :-
    overlay_players(Grid, PosA, PosB, GridComJogadores),
    render_grid_game_colored(GridComJogadores).

% Sobrepoe os jogadores no grid.
% Coloca players A e B nas posicoes dos jogadores.
overlay_players(Grid, (LA, CA), (LB, CB), GridFinal) :-
    set_cell(Grid, LA, CA, playerA, Grid1),
    set_cell(Grid1, LB, CB, playerB, GridFinal).

% Renderiza o grid do jogo com cores.
render_grid_game_colored(Grid) :-
    maplist(render_row_game_colored, Grid),
    nl.

render_row_game_colored(Linha) :-
    maplist(render_cell_game_colored, Linha),
    nl.

% Celulas especificas do jogo: playerA (vermelho), playerB (azul).
render_cell_game_colored(playerA) :-
    ansi_red(R), ansi_reset(Reset),
    write(R), write('A'), write(Reset).
render_cell_game_colored(playerB) :-
    ansi_blue(B), ansi_reset(Reset),
    write(B), write('B'), write(Reset).
render_cell_game_colored(exit) :-
    ansi_yellow(Y), ansi_reset(Reset),
    write(Y), write('E'), write(Reset).
% Para as demais celulas, usa a renderizacao padrao.
render_cell_game_colored(wall) :- write('#').
render_cell_game_colored(empty) :- write('.').
render_cell_game_colored(start) :- write('S').
render_cell_game_colored(path) :- write('@').
render_cell_game_colored(visited) :- write('o').

% Anima a lista de estados do jogo com delay padrao de 300ms.
animate_game(Estados) :-
    animate_game(Estados, 0.3).

% Anima a lista de estados do jogo.
animate_game([], _).
animate_game([Estado|Resto], Delay) :-
    move_cursor_home,
    render_game_state_colored(Estado),
    Estado = game_state(_, _, _, _, Resultado),
    print_status(Resultado),
    sleep(Delay),
    animate_game(Resto, Delay).

% Mostra o status atual do jogo.
print_status(in_progress) :-
    writeln('Jogo em andamento...').
print_status(playerA_wins) :-
    writeln('(A) capturou o fugitivo!!!').
print_status(playerB_wins) :-
    writeln('(B) alcancou a saida!!!').
