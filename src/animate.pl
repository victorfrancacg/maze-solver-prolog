% Animacao da resolucao do labirinto no terminal.

:- module(animate, [
    animate_solve/1,
    animate_solve/2
]).

:- use_module(render).

% 200ms delay.
animate_solve(Frames) :-
    animate_solve(Frames, 0.2).

% Anima a lista de frames.
animate_solve([], _).
animate_solve([Frame|Resto], Delay) :-
    move_cursor_home,
    render_grid_colored(Frame),
    sleep(Delay),
    animate_solve(Resto, Delay).
