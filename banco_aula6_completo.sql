-- ============================================================================
-- SCRIPT UNIFICADO DE BANCO DE DADOS (DDL & DML)
-- SGBD Alvo: MySQL 8.0+ / MariaDB 10.5+
-- Engine: InnoDB | Charset: utf8mb4 | Collation: utf8mb4_unicode_ci
-- ============================================================================

SET NAMES utf8mb4;
SET FOREIGN_KEY_CHECKS = 0;

-- ----------------------------------------------------------------------------
-- 1. LIMPEZA DE OBJETOS EXISTENTES (Ordem inversa de dependência)
-- ----------------------------------------------------------------------------
DROP TABLE IF EXISTS log_auditoria;
DROP TABLE IF EXISTS projetos;
DROP TABLE IF EXISTS vendas;
DROP TABLE IF EXISTS produtos;
DROP TABLE IF EXISTS funcionarios;
DROP TABLE IF EXISTS departamentos;

-- ----------------------------------------------------------------------------
-- 2. DEFINIÇÃO DAS ESTRUTURAS (DDL)
-- ----------------------------------------------------------------------------

-- Tabela: Departamentos
CREATE TABLE departamentos (
    id INT AUTO_INCREMENT PRIMARY KEY,
    nome VARCHAR(50) NOT NULL,
    CONSTRAINT uq_departamentos_nome UNIQUE (nome)
) ENGINE = InnoDB DEFAULT CHARSET = utf8mb4 COLLATE = utf8mb4_unicode_ci;

-- Tabela: Funcionários (com auto-relacionamento hierárquico)
CREATE TABLE funcionarios (
    id INT AUTO_INCREMENT PRIMARY KEY,
    nome VARCHAR(100) NOT NULL,
    cargo VARCHAR(50) NOT NULL,
    salario DECIMAL(10, 2) NOT NULL,
    departamento_id INT NULL,
    supervisor_id INT NULL,
    CONSTRAINT fk_funcionarios_departamento
        FOREIGN KEY (departamento_id) REFERENCES departamentos(id)
        ON UPDATE CASCADE
        ON DELETE SET NULL,
    CONSTRAINT fk_funcionarios_supervisor
        FOREIGN KEY (supervisor_id) REFERENCES funcionarios(id)
        ON UPDATE CASCADE
        ON DELETE SET NULL
) ENGINE = InnoDB DEFAULT CHARSET = utf8mb4 COLLATE = utf8mb4_unicode_ci;

-- Tabela: Produtos
CREATE TABLE produtos (
    id INT AUTO_INCREMENT PRIMARY KEY,
    nome VARCHAR(100) NOT NULL,
    categoria VARCHAR(50) NOT NULL,
    preco DECIMAL(10, 2) NOT NULL
) ENGINE = InnoDB DEFAULT CHARSET = utf8mb4 COLLATE = utf8mb4_unicode_ci;

-- Tabela: Vendas
CREATE TABLE vendas (
    id INT AUTO_INCREMENT PRIMARY KEY,
    funcionario_id INT NOT NULL,
    produto_id INT NOT NULL,
    quantidade INT NOT NULL,
    valor_total DECIMAL(10, 2) NOT NULL,
    data_venda DATE NOT NULL,
    CONSTRAINT fk_vendas_funcionario
        FOREIGN KEY (funcionario_id) REFERENCES funcionarios(id)
        ON UPDATE CASCADE
        ON DELETE RESTRICT,
    CONSTRAINT fk_vendas_produto
        FOREIGN KEY (produto_id) REFERENCES produtos(id)
        ON UPDATE CASCADE
        ON DELETE RESTRICT
) ENGINE = InnoDB DEFAULT CHARSET = utf8mb4 COLLATE = utf8mb4_unicode_ci;

-- Tabela: Projetos (Padronizada a partir do script complementar)
CREATE TABLE projetos (
    id INT AUTO_INCREMENT PRIMARY KEY,
    nome VARCHAR(50) NOT NULL,
    departamento_id INT NOT NULL,
    CONSTRAINT fk_projetos_departamento
        FOREIGN KEY (departamento_id) REFERENCES departamentos(id)
        ON UPDATE CASCADE
        ON DELETE RESTRICT
) ENGINE = InnoDB DEFAULT CHARSET = utf8mb4 COLLATE = utf8mb4_unicode_ci;

-- Tabela: Log de Auditoria (Para triggers e rotinas de monitoramento)
CREATE TABLE log_auditoria (
    id INT AUTO_INCREMENT PRIMARY KEY,
    tabela_afetada VARCHAR(50) NOT NULL,
    acao VARCHAR(20) NOT NULL,
    descricao VARCHAR(255) NOT NULL,
    data_hora DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP
) ENGINE = InnoDB DEFAULT CHARSET = utf8mb4 COLLATE = utf8mb4_unicode_ci;

-- ----------------------------------------------------------------------------
-- 3. CARGA INICIAL DE DADOS PARA TESTES (DML)
-- ----------------------------------------------------------------------------

-- Departamentos
INSERT INTO departamentos (id, nome) VALUES 
    (1, 'Tecnologia da Informação'),
    (2, 'Vendas Comercial'),
    (3, 'Recursos Humanos'),
    (4, 'Marketing & Expansão'); -- Departamento sem funcionários alocados

-- Funcionários
INSERT INTO funcionarios (id, nome, cargo, salario, departamento_id, supervisor_id) VALUES 
    (1, 'Carlos Silva', 'Diretor Geral', 15000.00, 1, NULL),
    (2, 'Ana Costa', 'Gerente de Vendas', 9000.00, 2, 1),
    (3, 'Roberto Rocha', 'Vendedor Senior', 6000.00, 2, 2),
    (4, 'Mariana Souza', 'Vendedora Junior', 3500.00, 2, 2),
    (5, 'Fernanda Lima', 'Analista de TI', 7000.00, 1, 1),
    (6, 'Paulo Mendes', 'Estagiário de RH', 2000.00, 3, NULL),
    (7, 'Beatriz Ramos', 'Analista de RH', 4500.00, 3, 6);

-- Produtos
INSERT INTO produtos (id, nome, categoria, preco) VALUES 
    (101, 'Notebook Dell Vostro', 'Eletrônicos', 4500.00),
    (102, 'Monitor UltraWide 27', 'Eletrônicos', 1200.00),
    (103, 'Teclado Mecânico RGB', 'Acessórios', 350.00),
    (104, 'Cadeira Ergonômica', 'Móveis', 1500.00),
    (105, 'Mesa de Escritório', 'Móveis', 900.00); -- Produto nunca vendido

-- Vendas
INSERT INTO vendas (id, funcionario_id, produto_id, quantidade, valor_total, data_venda) VALUES 
    (1, 3, 101, 2, 9000.00, '2026-08-01'),
    (2, 3, 102, 1, 1200.00, '2026-08-02'),
    (3, 4, 103, 4, 1400.00, '2026-08-03'),
    (4, 2, 101, 1, 4500.00, '2026-08-05'),
    (5, 3, 104, 1, 1500.00, '2026-08-10'),
    (6, 5, 102, 2, 2400.00, '2026-08-12');

SET FOREIGN_KEY_CHECKS = 1;
