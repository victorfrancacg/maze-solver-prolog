% Renderizacao do grid no terminal.
% Exibe o labirinto celula por celula, 

:- module(render, [
    render_grid/1,
    render_grid_colored/1,
    clear_screen/0,
    move_cursor_home/0
]).

:- use_module(types).

% Limpa a tela do terminal.
clear_screen :-
    write('\033[2J').

% Move o cursor para o canto superior esquerdo.
move_cursor_home :-
    write('\033[H').

% Verde (para caminho '@').
ansi_green('\033[32m').

% Vermelho
ansi_red('\033[31m').

% Azul (para start).
ansi_blue('\033[34m').

% Amarelo (para exit).
ansi_yellow('\033[33m').

% Reseta a cor para o padrao do terminal.
ansi_reset('\033[0m').

% Imprime o grid no terminal
render_grid(Grid) :-
    maplist(render_row, Grid),
    nl.

% Imprime uma linha do grid: cada celula vira seu caractere, e pula linha no final.
render_row(Linha) :-
    maplist(render_cell, Linha),
    nl.

% Imprime o caractere correspondente a uma celula.
render_cell(Celula) :-
    cell_char(Celula, Char),
    write(Char).

% Imprime o grid inteiro com cores no terminal.
render_grid_colored(Grid) :-
    maplist(render_row_colored, Grid),
    nl.

% Imprime uma linha do grid com cores.
render_row_colored(Linha) :-
    maplist(render_cell_colored, Linha),
    nl.

% Imprime uma celula com a cor adequada ao seu tipo.
% Parede e empty ficam sem cor especial.
% Path fica verde, start azul, exit amarelo, visited vermelho.
render_cell_colored(wall) :-
    write('#').
render_cell_colored(empty) :-
    write('.').
render_cell_colored(path) :-
    ansi_green(G), ansi_reset(R),
    write(G), write('@'), write(R).
render_cell_colored(start) :-
    ansi_blue(B), ansi_reset(R),
    write(B), write('S'), write(R).
render_cell_colored(exit) :-
    ansi_yellow(Y), ansi_reset(R),
    write(Y), write('E'), write(R).
render_cell_colored(visited) :-
    ansi_red(Red), ansi_reset(R),
    write(Red), write('o'), write(R).
