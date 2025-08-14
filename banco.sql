create database BancoImobiliaria;
-- Este script é compatível com MySQL.

-- Desativa a verificação de chaves estrangeiras para remover as tabelas na ordem correta sem erros.
SET FOREIGN_KEY_CHECKS = 0;

-- Remove tabelas existentes para evitar conflitos durante a recriação.
DROP TABLE IF EXISTS transacoes;
DROP TABLE IF EXISTS contratos_venda;
DROP TABLE IF EXISTS contratos_aluguel;
DROP TABLE IF EXISTS visitas;
DROP TABLE IF EXISTS proprietarios_imoveis;
DROP TABLE IF EXISTS imoveis;
DROP TABLE IF EXISTS corretores;
DROP TABLE IF EXISTS pessoas;

-- Reativa a verificação de chaves estrangeiras.
SET FOREIGN_KEY_CHECKS = 1;

-- ========= TABELAS PRINCIPAIS =========

-- Tabela para armazenar informações de todas as pessoas envolvidas (proprietários, inquilinos, compradores).
CREATE TABLE pessoas (
    id_pessoa INT PRIMARY KEY AUTO_INCREMENT,
    retrato JSON, -- adicionar not null posteriormente, deixando sem nada aqui pra facilitar os testes--
    nome_completo VARCHAR(255) NOT NULL,
    cpf VARCHAR(14) UNIQUE NOT NULL, -- Formato: XXX.XXX.XXX-XX
    telefone VARCHAR(20),
    email VARCHAR(100) UNIQUE NOT NULL,
    data_nascimento DATE NOT NULL,
    data_cadastro DATETIME DEFAULT CURRENT_TIMESTAMP
) COMMENT 'Armazena dados de todos os indivíduos: proprietários, inquilinos e compradores.';

-- Tabela para armazenar informações dos corretores da imobiliária.
CREATE TABLE corretores (
    id_corretor INT PRIMARY KEY AUTO_INCREMENT,
    id_pessoa INT UNIQUE NOT NULL,
    id_pessoa INT UNIQUE NOT NULL,
    retrato JSON, -- adicionar not null posteriormente, deixando sem nada aqui pra facilitar os testes--
    creci VARCHAR(20) UNIQUE NOT NULL, -- Registro profissional do corretor
    data_admissao DATE NOT NULL,
    data_nascimento DATE NOT NULL,
    ativo TINYINT(1) DEFAULT 1, -- 1 para TRUE, 0 para FALSE
    FOREIGN KEY (id_pessoa) REFERENCES pessoas(id_pessoa) ON DELETE CASCADE
) COMMENT 'Dados dos corretores da imobiliária, com referência à tabela de pessoas.';

-- Tabela para armazenar os detalhes dos imóveis.
CREATE TABLE imoveis (
    id_imovel INT PRIMARY KEY AUTO_INCREMENT,
    titulo VARCHAR(255) NOT NULL,
    descricao TEXT,
    endereco VARCHAR(255) NOT NULL,
    cidade VARCHAR(100) NOT NULL,
    estado VARCHAR(2) NOT NULL, -- Sigla do estado, ex: SP
    cep VARCHAR(9) NOT NULL, -- Formato: XXXXX-XXX
    cep VARCHAR(9) NOT NULL, -- Formato: XXXXX-XXX
    tipo VARCHAR(50) NOT NULL, -- Ex: Apartamento, Casa, Terreno
    area_m2 DECIMAL(10, 2) NOT NULL,
    quartos INT,
    imagens JSON,
    banheiros INT,
    vagas_garagem INT,
    valor_venda DECIMAL(12, 2),
    valor_aluguel DECIMAL(10, 2),
    status VARCHAR(50) NOT NULL DEFAULT 'Disponível', -- Ex: Disponível, Alugado, Vendido
    data_cadastro DATETIME DEFAULT CURRENT_TIMESTAMP
) COMMENT 'Catálogo de todos os imóveis gerenciados pela imobiliária.';


-- ========= TABELAS DE RELACIONAMENTO =========

-- Tabela de associação para ligar proprietários (pessoas) aos seus imóveis.
CREATE TABLE proprietarios_imoveis (
    id_proprietario INT NOT NULL,
    id_imovel INT NOT NULL,
    PRIMARY KEY (id_proprietario, id_imovel),
    FOREIGN KEY (id_proprietario) REFERENCES pessoas(id_pessoa) ON DELETE CASCADE,
    FOREIGN KEY (id_imovel) REFERENCES imoveis(id_imovel) ON DELETE CASCADE
) COMMENT 'Associa proprietários (pessoas) aos imóveis que possuem.';

-- Tabela para registrar visitas aos imóveis.
CREATE TABLE visitas (
    id_visita INT PRIMARY KEY AUTO_INCREMENT,
    id_imovel INT NOT NULL,
    id_potencial_cliente INT NOT NULL, -- ID da pessoa interessada
    id_corretor INT NOT NULL,
    data_visita DATETIME NOT NULL,
    feedback TEXT,
    FOREIGN KEY (id_imovel) REFERENCES imoveis(id_imovel),
    FOREIGN KEY (id_potencial_cliente) REFERENCES pessoas(id_pessoa),
    FOREIGN KEY (id_corretor) REFERENCES corretores(id_corretor)
) COMMENT 'Agenda e registro de visitas aos imóveis.';

-- Tabela para os contratos de aluguel.
CREATE TABLE contratos_aluguel (
    id_contrato_aluguel INT PRIMARY KEY AUTO_INCREMENT,
    id_imovel INT UNIQUE NOT NULL, -- Um imóvel só pode ter um contrato de aluguel ativo
    id_inquilino INT NOT NULL,
    data_inicio DATE NOT NULL,
    data_fim DATE NOT NULL,
    valor_mensal DECIMAL(10, 2) NOT NULL,
    ativo TINYINT(1) DEFAULT 1,
    FOREIGN KEY (id_imovel) REFERENCES imoveis(id_imovel),
    FOREIGN KEY (id_inquilino) REFERENCES pessoas(id_pessoa)
) COMMENT 'Gerencia os contratos de locação.';

-- Tabela para os contratos de venda.
CREATE TABLE contratos_venda (
    id_contrato_venda INT PRIMARY KEY AUTO_INCREMENT,
    id_imovel INT UNIQUE NOT NULL, -- Um imóvel só pode ser vendido uma vez
    id_comprador INT NOT NULL,
    data_venda DATE NOT NULL,
    valor_final DECIMAL(12, 2) NOT NULL,
    FOREIGN KEY (id_imovel) REFERENCES imoveis(id_imovel),
    FOREIGN KEY (id_comprador) REFERENCES pessoas(id_pessoa)
) COMMENT 'Gerencia os contratos de venda.';

-- Tabela para registrar a participação do corretor em uma transação (venda ou aluguel).
CREATE TABLE transacoes (
    id_transacao INT PRIMARY KEY AUTO_INCREMENT,
    id_corretor INT NOT NULL,
    id_contrato_aluguel INT,
    id_contrato_venda INT,
    tipo_transacao VARCHAR(10) NOT NULL, -- 'Aluguel' ou 'Venda'
    comissao DECIMAL(10, 2) NOT NULL,
    data_transacao DATETIME DEFAULT CURRENT_TIMESTAMP,
    comissao DECIMAL(10, 2) NOT NULL,
    data_transacao DATETIME DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT chk_contrato_unico CHECK (
        (id_contrato_aluguel IS NOT NULL AND id_contrato_venda IS NULL) OR
        (id_contrato_aluguel IS NULL AND id_contrato_venda IS NOT NULL)
    ),
    FOREIGN KEY (id_corretor) REFERENCES corretores(id_corretor),
    FOREIGN KEY (id_contrato_aluguel) REFERENCES contratos_aluguel(id_contrato_aluguel),
    FOREIGN KEY (id_contrato_venda) REFERENCES contratos_venda(id_contrato_venda)
) COMMENT 'Registra a comissão do corretor por cada venda ou aluguel realizado.';

-- ========= INSERINDO DADOS DE EXEMPLO =========

-- Inserindo Pessoas
INSERT INTO pessoas (nome_completo, cpf, telefone, email) VALUES
('Carlos Silva', '111.111.111-11', '(11) 98765-4321', 'carlos.silva@email.com'), -- Proprietário
('Ana Pereira', '222.222.222-22', '(21) 91234-5678', 'ana.pereira@email.com'), -- Inquilino
('João Santos', '333.333.333-33', '(31) 95555-4444', 'joao.santos@email.com'), -- Comprador
('Mariana Costa', '444.444.444-44', '(41) 94321-8765', 'mariana.costa@email.com'); -- Corretora

-- Inserindo Corretor
INSERT INTO corretores (id_pessoa, creci, data_admissao) VALUES
((SELECT id_pessoa FROM pessoas WHERE email = 'mariana.costa@email.com'), 'CRECI-SP 12345', '2023-01-15');

-- Inserindo Imóveis
INSERT INTO imoveis (titulo, endereco, cidade, estado, cep, tipo, area_m2, quartos, banheiros, vagas_garagem, valor_venda, valor_aluguel, status) VALUES
('Apartamento Aconchegante no Centro', 'Rua das Flores, 123', 'São Paulo', 'SP', '01000-000', 'Apartamento', 75.5, 2, 2, 1, 600000.00, 2500.00, 'Disponível'),
('Casa com Piscina em Condomínio', 'Avenida das Árvores, 456', 'Campinas', 'SP', '13000-000', 'Casa', 220.0, 4, 3, 3, 1200000.00, NULL, 'Disponível'),
('Studio Moderno perto do Metrô', 'Rua da Consolação, 789', 'São Paulo', 'SP', '01301-000', 'Apartamento', 40.0, 1, 1, 0, 450000.00, 1800.00, 'Alugado');

-- Associando Proprietário ao Imóvel
INSERT INTO proprietarios_imoveis (id_proprietario, id_imovel) VALUES
((SELECT id_pessoa FROM pessoas WHERE email = 'carlos.silva@email.com'), (SELECT id_imovel FROM imoveis WHERE cep = '01000-000')),
((SELECT id_pessoa FROM pessoas WHERE email = 'carlos.silva@email.com'), (SELECT id_imovel FROM imoveis WHERE cep = '13000-000')),
((SELECT id_pessoa FROM pessoas WHERE email = 'ana.pereira@email.com'), (SELECT id_imovel FROM imoveis WHERE cep = '01301-000'));

-- Inserindo um contrato de aluguel de exemplo para o imóvel já alugado
INSERT INTO contratos_aluguel (id_imovel, id_inquilino, data_inicio, data_fim, valor_mensal, ativo) VALUES
((SELECT id_imovel FROM imoveis WHERE cep = '01301-000'), (SELECT id_pessoa FROM pessoas WHERE email = 'ana.pereira@email.com'), '2024-05-01', '2026-11-01', 1800.00, 1);
