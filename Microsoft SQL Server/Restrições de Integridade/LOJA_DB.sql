CREATE DATABASE LOJA;

USE LOJA;

CREATE TABLE CATEGORIA (
	id_categoria INT PRIMARY KEY, -- restrição de dominio
	nome VARCHAR(60) NULL, -- restrição: não pode ser nulo
	CONSTRAINT uq_catrgoria_nome UNIQUE(nome) 
);
GO

CREATE TABLE FORNECEDOR (
	id_fornecedor INT IDENTITY(100,1) PRIMARY KEY,
	nome VARCHAR(100) NOT NULL,
	telefone VARCHAR(20)
);
GO

CREATE TABLE PRODUTO (
	id_produto INT PRIMARY KEY,
	nome VARCHAR(80) NOT NULL,
	preco DECIMAL(10,2) NOT NULL,
	quantidade INT NOT NULL DEFAULT 0,
	situacao VARCHAR(10) NOT NULL CONSTRAINT df_prod_sit DEFAULT 'Ativo',
	id_categoria INT NOT NULL,
	id_fornecedor INT,

	CONSTRAINT ck_prod_preco CHECK (preco > 0), -- RESTRINGIR PARA O PREÇO SER SEMPRE MAIOR QUE ZERO
	CONSTRAINT ck_prod_qtd CHECK (quantidade >= 0), -- RESTRINGIR PARA A QUANTIDADE SER SEMPRE MAIOR OU IGUAL A ZERO
	CONSTRAINT ck_prod_situacao CHECK (situacao IN ('Ativo','Inativo')),

	CONSTRAINT fk_produto_categoria 
		FOREIGN KEY (id_categoria) REFERENCES CATEGORIA(id_categoria)
		ON DELETE CASCADE
		ON UPDATE CASCADE
);
GO

-- EXEMPLO DE INCLUIR RESTRIÇÃO POSTERIOR (DEPOIS DA CRIAÇÃO DA TABELA)
ALTER TABLE PRODUTO
ADD CONSTRAINT fk_produto_fornecedor 
	FOREIGN KEY (id_fornecedor) REFERENCES FORNECEDOR(id_fornecedor)
	ON DELETE SET NULL
	ON UPDATE CASCADE
GO


INSERT INTO CATEGORIA (id_categoria, nome)
VALUES 
(10, 'Informatica'),
(20, 'Papelaria'),
(30, 'Acessórios');


INSERT INTO FORNECEDOR (nome, telefone)
VALUES
('Amazon', '5555-1111'),
('Moura', NULL);

INSERT INTO PRODUTO (id_produto, nome, preco, quantidade, situacao, id_categoria, id_fornecedor)
VALUES
(1001, 'Mause sem fio',249.99,15,'Ativo',10,100),
(1002, 'Teclado',419.80, 10,'Ativo',10,100),
(1003, 'Caderno',25.00,100,'Ativo',20,100),
(1004, 'Caneta',2.50,500,'Ativo',20,100),
(1005, 'Bateria M60GD',392.80,5,'Ativo',30,101);

SELECT * FROM CATEGORIA
SELECT * FROM FORNECEDOR
SELECT * FROM PRODUTO


-- ON UPDATE CASCADE
UPDATE CATEGORIA 
SET id_categoria = 99
WHERE id_categoria = 30;

-- ON DELETE SET NULL
DELETE FROM FORNECEDOR 
WHERE id_fornecedor = 100;

-- ON DELETE CASCADE
DELETE FROM CATEGORIA 
WHERE id_categoria = 20; 