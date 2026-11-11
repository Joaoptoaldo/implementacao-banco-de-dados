CREATE DATABASE DBINDICE;
GO

USE DBINDICE;
GO

CREATE TABLE funcionario (
	id INT PRIMARY KEY IDENTITY,
	nome VARCHAR(100),
	cargo VARCHAR(100),
	salario DECIMAL(10,2),
	dataAdmissao DATE
);
GO

SET STATISTICS IO ON;
SET STATISTICS TIME ON;
SELECT *
FROM funcionario
ORDER BY cargo, salario
SET STATISTICS IO OFF;
SET STATISTICS TIME OFF;

-- indice simples (uma coluna)
CREATE NONCLUSTERED INDEX ix_funcionario_salario
ON funcionario(salario);
GO

CREATE NONCLUSTERED INDEX ix_funcionario_cargo_salario
ON funcionario(cargo, salario);
GO


DECLARE @i INT = 10000;

WHILE @i <= 300000
BEGIN 
	INSERT INTO funcionario (nome, cargo, salario, dataAdmissao)
	VALUES (CONCAT('Funcionario', @i), 
		(SELECT TOP 1 valor FROM (
			VALUES ('TEC'), ('ADM'), ('venda'))
			AS Lista(valor) ORDER BY NEWID()),
		RAND()*10000,
		DATEADD(day, ABS(CHECKSUM(NEWID()))%365, '2026-01-01'));

		SET @i = @i + 1;
END
GO

SELECT * FROM funcionario;

TRUNCATE TABLE funcionario