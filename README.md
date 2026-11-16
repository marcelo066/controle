# Banco de Dados Corporativo — Aula de TCL & DCL

Este repositório contém o script SQL unificado (`banco_aula6_completo.sql`) desenvolvido como base prática para o estudo de **Controle de Transações (TCL)** e **Controle de Acesso a Dados (DCL)** em bancos de dados relacionais (MySQL / MariaDB).

---

## 📋 Visão Geral do Schema

O banco de dados simula um ambiente corporativo com controle de departamentos, hierarquia de funcionários, catálogo de produtos, registro de vendas, alocação de projetos e auditoria de operações.

Todas as tabelas utilizam o motor **`InnoDB`** com codificação **`utf8mb4`**, garantindo suporte completo a **propriedades ACID**, chaves estrangeiras e transações.

### Estrutura das Tabelas

| Tabela | Descrição | Relacionamentos Principais |
| :--- | :--- | :--- |
| **`departamentos`** | Setores da empresa (TI, Vendas, RH, Marketing). | — |
| **`funcionarios`** | Colaboradores, cargos, salários e hierarquia. | `departamento_id` → `departamentos(id)`<br>`supervisor_id` → `funcionarios(id)` *(auto-relacionamento)* |
| **`produtos`** | Catálogo de itens comercializados e preços. | — |
| **`vendas`** | Histórico de vendas realizadas pelos colaboradores. | `funcionario_id` → `funcionarios(id)`<br>`produto_id` → `produtos(id)` |
| **`projetos`** | Projetos corporativos sob responsabilidade de um setor. | `departamento_id` → `departamentos(id)` |
| **`log_auditoria`** | Registro histórico de ações e alterações críticas. | Tabela independente para logs e triggers. |

---

## 🚀 Como Executar

1. Crie um banco de dados limpo no seu SGBD (MySQL Workbench, DBeaver, CLI ou phpMyAdmin):
   ```sql
   CREATE DATABASE empresa_aula CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
   USE empresa_aula;
   ```
2. Execute o arquivo **`banco_aula6_completo.sql`**.
   * *Nota:* O script é idempotente — ele limpa tabelas anteriores (`DROP TABLE IF EXISTS`) na ordem correta de dependência antes de recriar e popular os dados.

---

## 🛠️ Exemplos Práticos para a Aula

### 1. TCL — Transaction Control Language (`START TRANSACTION`, `COMMIT`, `ROLLBACK`, `SAVEPOINT`)

Como todas as tabelas utilizam `ENGINE = InnoDB`, é possível testar cenários de atomicidade e isolamento:

```sql
-- Exemplo: Reajuste salarial com ponto de salvamento e auditoria
START TRANSACTION;

UPDATE funcionarios 
SET salario = salario * 1.10 
WHERE departamento_id = 2;

SAVEPOINT apos_reajuste_vendas;

-- Simulação de erro ou alteração indevida
DELETE FROM projetos WHERE id = 1;

-- Desfaz apenas até o savepoint, mantendo o reajuste
ROLLBACK TO SAVEPOINT apos_reajuste_vendas;

INSERT INTO log_auditoria (tabela_afetada, acao, descricao)
VALUES ('funcionarios', 'UPDATE', 'Reajuste de 10% aplicado ao departamento de Vendas');

-- Efetiva definitivamente as alterações
COMMIT;
```

### 2. DCL — Data Control Language (`CREATE USER`, `GRANT`, `REVOKE`)

Exemplos de criação de perfis de acesso distintos sobre o schema:

```sql
-- Criação de usuário analista (apenas leitura) e operador (leitura e escrita)
CREATE USER 'analista_bi'@'localhost' IDENTIFIED BY 'SenhaForte@123';
CREATE USER 'operador_vendas'@'localhost' IDENTIFIED BY 'SenhaForte@456';

-- Concedendo permissões específicas
GRANT SELECT ON empresa_aula.* TO 'analista_bi'@'localhost';
GRANT SELECT, INSERT, UPDATE ON empresa_aula.vendas TO 'operador_vendas'@'localhost';
GRANT SELECT ON empresa_aula.produtos TO 'operador_vendas'@'localhost';

-- Revogando permissão de atualização
REVOKE UPDATE ON empresa_aula.vendas FROM 'operador_vendas'@'localhost';

-- Aplicando privilégios
FLUSH PRIVILEGES;
```

---

## 📂 Arquivos do Repositório

* `banco_aula6_completo.sql` — Script DDL e DML unificado e padronizado.
* `README.md` — Documentação da estrutura e guia rápido de comandos TCL/DCL.
