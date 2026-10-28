USE EMPRESA_2026
GO


-- triggers

CREATE TRIGGER trg_after_insert_departamento
ON DEPARTAMENTO
AFTER INSERT
AS
BEGIN
	PRINT 'Hello'
END;
GO


CREATE OR ALTER TRIGGER trg_io_insert_departamento
ON DEPARTAMENTO
INSTEAD OF INSERT
AS
BEGIN
	-- recuperar nome do departamento
	DECLARE @nome varchar(40), @numero AS INT;
	SELECT @nome = I.Dnome, @numero = I.Dnumero
	FROM inserted AS I
	IF EXISTS (SELECT 1 FROM DEPARTAMENTO WHERE Dnome = @nome)
		RAISERROR('Esse departamento já existe!',16,1) -- nivel 16 = violação da regra de negócio
	ELSE
		INSERT INTO DEPARTAMENTO (Dnome, Dnumero)
		SELECT I.Dnome, I.Dnumero
		FROM inserted AS I;
END;
GO

-- desabilitar/habilitar trigger => DISABLE/ENABLE
ALTER TABLE DEPARTAMENTO
DISABLE TRIGGER trg_after_insert_departamento


INSERT INTO DEPARTAMENTO (Dnome, Dnumero)
VALUES ('Expedição', 55);

SELECT * FROM DEPARTAMENTO;

-- verificar triggers em uma tabela
EXEC sp_helptrigger DEPARTAMENTO

-- verificar triggers no banco de dados
SELECT *
FROM sys.triggers
WHERE is_disabled = 0 OR is_disabled = 1;
GO


-- função UPDATE()

CREATE OR ALTER TRIGGER trg_after_update_nome
ON DEPARTAMENTO
FOR UPDATE
AS
BEGIN
	DECLARE @antigo VARCHAR(50),  
			@novo VARCHAR(50);

	SELECT @antigo = D.Dnome FROM deleted AS D
	SELECT @novo = I.Dnome FROM inserted AS I;

	IF UPDATE(Dnome)
	BEGIN
		PRINT 'O nome foi alterado! O nome antigo era: ' + @antigo;
		PRINT 'O nome novo é: ' + @novo;
	END
	ELSE 
		PRINT 'O nome não foi alterado'
END
GO


UPDATE DEPARTAMENTO
SET Dnome = 'Recursos Humanos'
WHERE Dnome = 'RH';

UPDATE DEPARTAMENTO
SET Dnumero = 9
WHERE Dnome = 'Expedição';

UPDATE DEPARTAMENTO
SET Dnome = 'Informática'
WHERE Dnome = 'TI';
GO


CREATE OR ALTER TRIGGER trg_insert_salario_funcionario
ON FUNCIONARIO
AFTER INSERT, 
UPDATE
AS
BEGIN
    DECLARE @salario DECIMAL(10,2);
    
    -- obtém o salário que foi inserido ou atualizado
    SELECT @salario = I.Salario 
	FROM inserted I;
    
    -- verifica se o salário é menor que o mínimo permitido
    IF (@salario < 1000.00)
    BEGIN
        RAISERROR('O salário não pode ser menor que R$ 1.000,00!', 16, 1);
        ROLLBACK TRANSACTION;
    END
END;
GO

INSERT INTO FUNCIONARIO (Pnome, Unome, Cpf, Datanasc, Endereco, Sexo, Salario, Bonus, Data_Admissao, Dnr)
VALUES ('João Pedro', 'Toaldo', '25326700000', '2004-03-14', 'Rua sete', 'M', 100.00, 150.00, '2026-10-20', 9);

SELECT * FROM FUNCIONARIO;



-- TABELA DE LOG
CREATE TABLE log_salario_funcionario (
	log_id INT IDENTITY(100,1) PRIMARY KEY,
	cpf CHAR(11),
	operacao VARCHAR(10),
	data_hora DATETIME DEFAULT GETDATE()
)
GO

-- TRIGGER DE INSERT
CREATE TRIGGER trg_for_insert_funcionario
ON FUNCIONARIO
FOR INSERT
AS
BEGIN
	INSERT INTO log_salario_funcionario (cpf, operacao)
	SELECT Cpf, 'INSERT'
	FROM inserted
END
GO


-- TRIGGER DE UPDATE
CREATE TRIGGER trg_for_update_funcionario
ON FUNCIONARIO
FOR UPDATE
AS
BEGIN
	INSERT INTO log_salario_funcionario (cpf, operacao)
	SELECT Cpf, 'UPDATE'
	FROM inserted
END
GO

-- TRIGGER DE DELETE
CREATE TRIGGER trg_for_delete_funcionario
ON FUNCIONARIO
FOR DELETE
AS
BEGIN
	INSERT INTO log_salario_funcionario (cpf, operacao)
	SELECT Cpf, 'DELETE'
	FROM deleted
END
GO

INSERT INTO FUNCIONARIO (Pnome, Unome, Cpf, Datanasc, Endereco, Sexo, Salario, Bonus, Data_Admissao, Dnr)
VALUES ('Juca', 'Da Silva', '25326700001', '2005-03-14', 'Rua cinco', 'M', 1000.00, 150.00, '2026-10-20', 9);

SELECT * FROM FUNCIONARIO;
SELECT * FROM log_salario_funcionario


UPDATE FUNCIONARIO
SET Salario = 500
WHERE Cpf = '25326700001'

DELETE FROM FUNCIONARIO
WHERE Cpf = '55346790000'


-- Desafios:

-- 1) Criar uma tabela para guardar todas as alterações 
-- de salário sofridas por um funcionário. E em seguida
-- crie triggers para guardar nesta tabela informações 
-- sobre essas alterações (id, cpf, salario anterior, data e hora)


-- 2) Crie uma nova coluna na tabela departamento chamada status
-- agora crie uma trigger que impeça o usuario de deletar um departamento
-- já existe. Ou seja, ao invés de deletar o departamento altere o valor da coluna
-- de status para '0'


--3 Crie um trigger que seja disparado depois que uma operação de inserção, 
-- update ou deleção ocorra na tabela FUNCIONARIO. 
-- Esse trigger deve registrar o CPF do novo funcionário 
--inserido, alterado ou deletado e a operação realizada ("INSERT, DELETE, UPDATE") 
-- em uma tabela de log (Log_Funcionario), juntamente com a data e hora da inserção. Esse trigger ajudará a manter um histórico 
-- das inserções realizadas na tabela de funcionários.


-- 1)
CREATE TABLE historico_salario_funcionario (
    id INT IDENTITY(1,1) PRIMARY KEY,
    cpf CHAR(11),
    salario_anterior DECIMAL(10,2),
    data_hora DATETIME DEFAULT GETDATE()
);
GO

-- trigger para registrar alterações de salário
CREATE OR ALTER TRIGGER trg_historico_salario
ON FUNCIONARIO
AFTER UPDATE
AS
BEGIN
    IF UPDATE(Salario)
    BEGIN
        INSERT INTO historico_salario_funcionario (cpf, salario_anterior)
        SELECT D.Cpf, D.Salario
        FROM deleted AS D;
    END
END;
GO


-- 2) add coluna de status na tabela DEPARTAMENTO (1 = Ativo, 0 = Inativo)
ALTER TABLE DEPARTAMENTO
ADD status INT DEFAULT 1;
GO

-- Criando o trigger para realizar exclusão lógica
CREATE OR ALTER TRIGGER trg_io_delete_departamento
ON DEPARTAMENTO
INSTEAD OF DELETE
AS
BEGIN
    -- Ao invés de deletar, atualiza o status para '0' (Inativo)
    UPDATE DEPARTAMENTO
    SET status = 0
    FROM DEPARTAMENTO AS D
    INNER JOIN deleted AS Del ON D.Dnumero = Del.Dnumero;
END;
GO



-- 3) tabela de log unificada
CREATE TABLE Log_Funcionario (
    log_id INT IDENTITY(1,1) PRIMARY KEY,
    cpf CHAR(11),
    operacao VARCHAR(10),
    data_hora DATETIME DEFAULT GETDATE()
);
GO

-- trigger unificado para INSERT, UPDATE e DELETE
CREATE OR ALTER TRIGGER trg_log_unificado_funcionario
ON FUNCIONARIO
AFTER INSERT, UPDATE, DELETE
AS
BEGIN
    -- verifica se ocorreu INSERT
    IF EXISTS (SELECT 1 FROM inserted) AND NOT EXISTS (SELECT 1 FROM deleted)
    BEGIN
        INSERT INTO Log_Funcionario (cpf, operacao)
        SELECT Cpf, 'INSERT' FROM inserted;
    END

    -- verifica se ocorreu UPDATE
    IF EXISTS (SELECT 1 FROM inserted) AND EXISTS (SELECT 1 FROM deleted)
    BEGIN
        INSERT INTO Log_Funcionario (cpf, operacao)
        SELECT Cpf, 'UPDATE' FROM inserted;
    END

    -- verifica se ocorreu DELETE
    IF EXISTS (SELECT 1 FROM deleted) AND NOT EXISTS (SELECT 1 FROM inserted)
    BEGIN
        INSERT INTO Log_Funcionario (cpf, operacao)
        SELECT Cpf, 'DELETE' FROM deleted;
    END
END;
GO