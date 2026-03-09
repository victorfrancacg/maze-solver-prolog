% Ponto de entrada do resolvedor de labirintos.
% Gera um labirinto, exibe no terminal, espera o usuario,
% anima a busca BFS e mostra o caminho final.

:- use_module(types).
:- use_module(utils).
:- use_module(generate).
:- use_module(render).
:- use_module(solve).
:- use_module(animate).

main :-
    % Gera um labirinto 15x21 com start e exit. Esse labirinto sempre é resolvível, isso é garantido por nossa heurística de geração.
    generate_maze(15, 21, true, Grid),

    % Exibe o labirinto inicial
    clear_screen,
    move_cursor_home,
    writeln('Labirinto gerado:'),
    nl,
    render_grid_colored(Grid),

    % Espera o usuario pressionar Enter para comecar
    writeln('Pressione Enter para resolver...'),
    read_line_to_string(user_input, _),

    % Calcula os passos da BFS (frames para animacao)
    solve_steps(Grid, Frames),

    % Limpa a tela e anima a exploracao
    clear_screen,
    animate_solve(Frames, 0.15),

    writeln('Caminho encontrado!'),
    nl.

% Carrega o arquivo e executa o main
:- initialization(main, main).
