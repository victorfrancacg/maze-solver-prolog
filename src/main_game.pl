% Gera um labirinto, posiciona os jogadores e a saida,
% roda o jogo completo e anima no terminal.

:- use_module(types).
:- use_module(utils).
:- use_module(generate).
:- use_module(render).
:- use_module(game_logic).
:- use_module(game_simulate).

main :-
    % Gera labirinto 15x21
    generate_maze(15, 21, false, Grid0),

    % Coloca a saida em posicao vazia aleatoria
    random_empty_pos(Grid0, (EL, EC)),
    set_cell(Grid0, EL, EC, exit, Grid),

    % Cria o estado inicial (posiciona jogadores aleatoriamente)
    initial_game_state(Grid, GameState),

    % Exibe estado inicial
    clear_screen,
    move_cursor_home,
    writeln('Pega-pega no labirinto!'),
    writeln('A (vermelho) = perseguidor | B (azul) = fugitivo | E (amarelo) = saida'),
    nl,
    render_game_state_colored(GameState),

    % Espera o usuario pressionar Enter
    writeln('Pressione Enter para comecar...'),
    read_line_to_string(user_input, _),

    % Roda o jogo completo e coleta todos os estados
    run_game(GameState, Estados),

    % Anima o jogo
    clear_screen,
    animate_game(Estados, 0.3),

    nl.

:- initialization(main, main).
