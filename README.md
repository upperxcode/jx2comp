# jx2comp

## Sobre o Projeto

**jx2comp** é uma biblioteca de componentes e um framework de gerenciamento de dados para Flutter, projetado para acelerar o desenvolvimento de aplicações ricas em dados, como painéis administrativos, sistemas de gestão (ERP) e interfaces de CRUD.

A arquitetura separa claramente a lógica de negócio da interface do usuário, promovendo um código limpo, reutilizável e de fácil manutenção.

### Principais Funcionalidades

*   **Store Reativo (`BaseStore`)**: Um sistema de gerenciamento de estado centralizado, baseado em `ChangeNotifier`, que gerencia o ciclo de vida dos dados (CRUD), a navegação entre registros e a reatividade da UI.
*   **Componentes de UI Ricos**: Uma coleção de widgets de alto nível e prontos para uso, incluindo:
    *   `DataGrid`: Uma grade de dados poderosa para exibição e interação com dados tabulares.
    *   `JxSearchDropdown`: Um dropdown com busca inteligente, capaz de carregar dados de fontes externas (`lookup`) e com interações de usuário avançadas.
    *   `FormButton`: Uma barra de botões de formulário com lógica embutida para salvar, cancelar e fornecer feedback ao usuário via `snackMessage`.
*   **Motor de Filtragem Avançado**: Um `mixin` que adiciona uma capacidade de filtragem flexível e poderosa aos `Stores`, permitindo a criação de consultas complexas nos dados.
*   **Infraestrutura Robusta**:
    *   **Cliente HTTP**: Um cliente HTTP baseado em `Dio` com interceptadores para logging e enriquecimento automático de requisições.
    *   **Tratamento de Exceções**: Um conjunto de exceções customizadas para um tratamento de erros claro e específico (`Jx2NetworkException`, `Jx2ValidationException`, etc.).
    *   **Logging Detalhado (`JxLog`)**: Um utilitário de log que substitui o `print()`, oferecendo níveis de severidade, cores e rastreamento da origem do código.

## Getting Started

This project is a starting point for a Flutter application.

