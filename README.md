RISC-V 32-bit Processor
Este projeto implementa um processador RISC-V de 32 bits, desenvolvido com o objetivo de proporcionar uma compreensão prática das operações básicas de um processador, incluindo loops e instruções de ramificação (branches). A arquitetura segue o conjunto de instruções RISC-V (Reduced Instruction Set Computing), um dos mais populares conjuntos de instruções de baixo nível, focado em simplicidade e eficiência.

Características do Processador
Arquitetura RISC-V de 32 bits: O processador segue a especificação RISC-V de 32 bits (RV32), implementando as principais instruções desse conjunto, como aritméticas, lógicas e de controle de fluxo.

Operações Aritméticas e Lógicas: O processador é capaz de realizar operações aritméticas básicas (como soma, subtração) e lógicas (AND, OR, XOR) entre registros e imediatos, essenciais para a execução de tarefas simples e complexas.

Suporte a Loops e Branches: Implementação de instruções de controle de fluxo, como saltos condicionais e incondicionais (jumps e branches), permitindo a execução de loops e estruturas de decisão típicas de programas em Assembly.

Registros de 32 bits: O processador contém 32 registros de 32 bits, que armazenam valores temporários usados em cálculos e operações lógicas.

Interface de Entrada e Saída Simples: Para fins de testes e simulação, o processador inclui uma interface simples de entrada e saída para interagir com o código executado.

Funcionalidades
O processador implementa as seguintes funcionalidades principais:

Execução de Instruções Aritméticas: Instruções como ADD, SUB, MUL são implementadas para suportar operações aritméticas fundamentais.

Operações Lógicas: Instruções como AND, OR, XOR e NOR permitem a manipulação de bits em operações de lógica binária.

Controle de Fluxo: O processador pode saltar para diferentes endereços de memória com base em condições específicas (exemplo: BEQ - branch if equal, BNE - branch if not equal), permitindo a criação de loops e decisões condicionais.

Instruções de Carga e Armazenamento: Instruções para carregar dados da memória para os registradores (LW, LH, LB) e armazenar dados dos registradores na memória (SW, SH, SB).

Execução de Loops: Capacidade de criar e executar loops em Assembly, usando combinações de instruções de salto condicional e incondicional.

Implementação
O processador foi implementado utilizando uma arquitetura modular, com cada unidade funcional responsável por um aspecto específico do processamento, como execução de ALU (Unidade Lógica e Aritmética), controle de fluxo, e gerenciamento de memória. A comunicação entre essas unidades é realizada por barramentos e registradores dedicados, conforme a arquitetura RISC-V.

Testes
O processador foi testado com uma série de programas simples escritos em Assembly RISC-V. Estes programas incluem operações aritméticas, loops e condições de ramificação, demonstrando a capacidade do processador de executar tarefas de controle de fluxo complexas.

Como Usar
Clone o repositório:

bash
Copiar código
git clone https://github.com/GustavoMarquardt/MIPS_CPU.git
Siga as instruções de compilação e simulação no arquivo README.md do repositório para rodar o processador em sua máquina local.

Contribuições
Contribuições são bem-vindas! Se você deseja melhorar o processador ou adicionar novos recursos, sinta-se à vontade para enviar um pull request ou abrir uma issue.
