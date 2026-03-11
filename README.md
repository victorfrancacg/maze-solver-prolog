# Maze Solver - Prolog Version

Projeto em Prolog que gera, resolve e anima labirintos, seguindo os princípios do paradigma lógico. O sistema permite encontrar o **caminho mais eficiente** em um labirinto e prepara a base para um jogo de **pega-pega** entre dois players.


O projeto é dividido em duas partes principais:
1. **Resolvedor de Labirintos**
2. **Jogo de Pega-Pega em Labirintos**

## Sumário
- [Sobre](#sobre)
- [Funcionalidades](#funcionalidades)
- [Como Executar](#como-executar)
- [Contribuidores](#contribuidores)

## Sobre

O projeto permite criar, visualizar e resolver labirintos de forma automática, garantindo que os caminhos encontrados sejam os mais curtos possíveis. Além disso, implementa um jogo de pega-pega dentro do labirinto, onde dois players se movimentam em tempo real sobre a estrutura do labirinto, com regras que determinam se o perseguido consegue escapar ou é capturado pelo perseguidor.

O sistema segue o paradigma **lógico**, utilizando Prolog e técnicas de **algoritmos de busca em grafos** para garantir que os caminhos encontrados sejam os **mais curtos possíveis**.

## Funcionalidades

### Resolvedor de Labirinto
- Gerar o labirinto → Representação matricial.
- Encontrar o caminho mais eficiente → Baseado no algoritmo de Busca em Largura.
- Retornar a animação de busca no terminal → Geração dos estados necessários para visualizar a busca.

### Pega-Pega no Labirinto
- Gerar o labirinto e definir as posições iniciais dos dois players → Cada player é colocado em uma célula específica do labirinto, garantindo que exista apenas uma saída, distinta das posições iniciais dos players.
- Determinar se o perseguido consegue escapar do labirinto antes do perseguidor o alcançar.
- Retornar a animação do jogo no terminal → Atualização passo a passo da movimentação dos players.


## Como Executar

1. Instale o SWI-Prolog:
   ```dif
   curl -O https://www.swi-prolog.org/download/stable/bin/swipl-<versao>.tar.gz
   ```
3. Clone o repositório e entre na pasta do projeto:
   ```dif
   git clone https://github.com/victorfrancacg/maze-solver-prolog.git
   cd maze-solver-prolog
   ```   
4. Execute o Maze solver:
   ```dif
   swapl src/main-mazesolver.pl
   ```
5. Execute o Maze game:
   ```dif
   swapl src/main-mazegame.pl
   ```

## Contribuidores

[@Brunnowxl - Brunno Weslley](https://github.com/Brunnowxl)

[@victorfrancacg - Victor França](https://github.com/victorfrancacg)

[@vitorh333 - Vitor Hugo](https://github.com/vitorh333)

Projeto feito como trabalho da terceira unidade da disciplina de Paradigmas de Linguagem de Programação (PLP), da graduação em Ciência da Computação, na Universidade Federal de Campina Grande (UFCG) (2025.2).
