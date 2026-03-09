% Animacao da resolucao do labirinto no terminal.
% Recebe uma lista de frames (grids) e exibe cada um
% com um pequeno delay, criando o efeito de animacao.

:- module(animate, [
    animate_solve/1,
    animate_solve/2
]).

:- use_module(render).

% delay de 200ms.
animate_solve(Frames) :-
    animate_solve(Frames, 0.2).

% Anima a lista de frames.
animate_solve([], _).
animate_solve([Frame|Resto], Delay) :-
    move_cursor_home,
    render_grid_colored(Frame),
    sleep(Delay),
    animate_solve(Resto, Delay).
