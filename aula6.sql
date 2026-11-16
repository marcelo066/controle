CREATE TABLE departamentos (
    id INT PRIMARY KEY,
    nome VARCHAR(50) NOT NULL
);

CREATE TABLE funcionarios (
    id INT PRIMARY KEY,
    nome VARCHAR(100) NOT NULL,
    cargo VARCHAR(50) NOT NULL,
    salario DECIMAL(10,2) NOT NULL,
    departamento_id INT,
    supervisor_id INT,
    FOREIGN KEY (departamento_id) REFERENCES departamentos(id),
    FOREIGN KEY (supervisor_id) REFERENCES funcionarios(id)
);

CREATE TABLE produtos (
    id INT PRIMARY KEY,
    nome VARCHAR(100) NOT NULL,
    categoria VARCHAR(50) NOT NULL,
    preco DECIMAL(10,2) NOT NULL
);

CREATE TABLE vendas (
    id INT PRIMARY KEY,
    funcionario_id INT NOT NULL,
    produto_id INT NOT NULL,
    quantidade INT NOT NULL,
    valor_total DECIMAL(10,2) NOT NULL,
    data_venda DATE NOT NULL,
    FOREIGN KEY (funcionario_id) REFERENCES funcionarios(id),
    FOREIGN KEY (produto_id) REFERENCES produtos(id)
);
-- Script DML (População do Banco para Testes)
-- População da Tabela Departamentos
INSERT INTO departamentos (id, nome) VALUES 
(1, 'Tecnologia da Informação'),
(2, 'Vendas Comercial'),
(3, 'Recursos Humanos'),
(4, 'Marketing & Expansão'); -- Departamento sem funcionários alocados

-- População da Tabela Funcionários (com hierarquia de supervisão)
INSERT INTO funcionarios (id, nome, cargo, salario, departamento_id, supervisor_id) VALUES 
(1, 'Carlos Silva', 'Diretor Geral', 15000.00, 1, NULL),
(2, 'Ana Costa', 'Gerente de Vendas', 9000.00, 2, 1),
(3, 'Roberto Rocha', 'Vendedor Senior', 6000.00, 2, 2),
(4, 'Mariana Souza', 'Vendedora Junior', 3500.00, 2, 2),
(5, 'Fernanda Lima', 'Analista de TI', 7000.00, 1, 1),
(6, 'Paulo Mendes', 'Estagiário de RH', 2000.00, 3, NULL),
(7, 'Beatriz Ramos', 'Analista de RH', 4500.00, 3, 6);

-- População da Tabela Produtos
INSERT INTO produtos (id, nome, categoria, preco) VALUES 
(101, 'Notebook Dell Vostro', 'Eletrônicos', 4500.00),
(102, 'Monitor UltraWide 27', 'Eletrônicos', 1200.00),
(103, 'Teclado Mecânico RGB', 'Acessórios', 350.00),
(104, 'Cadeira Ergonômica', 'Móveis', 1500.00),
(105, 'Mesa de Escritório', 'Móveis', 900.00); -- Produto nunca vendido

-- População da Tabela Vendas
INSERT INTO vendas (id, funcionario_id, produto_id, quantidade, valor_total, data_venda) VALUES 
(1, 3, 101, 2, 9000.00, '2026-08-01'),
(2, 3, 102, 1, 1200.00, '2026-08-02'),
(3, 4, 103, 4, 1400.00, '2026-08-03'),
(4, 2, 101, 1, 4500.00, '2026-08-05'),
(5, 3, 104, 1, 1500.00, '2026-08-10'),
(6, 5, 102, 2, 2400.00, '2026-08-12');
