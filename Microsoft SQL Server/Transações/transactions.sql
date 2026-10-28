USE FACULDADE_2
GO

-- TRANSAÇÃO
-- BEGIN TRANSACTION
-- COMMIT TRANSACTION
-- ROLLBACK
-- SAVE POINT

BEGIN TRANSACTION;
DECLARE @nome VARCHAR(100);
SET @nome = 'Banco de Dados I';

IF EXISTS (SELECT 1 FROM DISCIPLINA WHERE Nome_disciplina = @nome)
BEGIN
	ROLLBACK TRANSACTION;
	PRINT 'Já existe uma disciplina com esse nome: ' + @nome;
END
ELSE
BEGIN 
	INSERT INTO DISCIPLINA 
	VALUES ('G0217', @nome, 4, 'SI');
	COMMIT TRANSACTION;
	PRINT 'Disciplina inserida com sucesso!'
END

GO


BEGIN TRANSACTION;
DECLARE @nome VARCHAR(100);
SET @nome = 'Banco de Dados I';

IF EXISTS (SELECT 1 FROM DISCIPLINA WHERE Nome_disciplina = @nome)
BEGIN
	ROLLBACK TRANSACTION;
	PRINT 'Já existe uma disciplina com esse nome: ' + @nome;
END
ELSE
BEGIN 
	INSERT INTO DISCIPLINA 
	VALUES ('G0217', @nome, 4, 'SI');
	COMMIT TRANSACTION;
	PRINT 'Disciplina inserida com sucesso!'
END

GO


-- EXEMPLO BANCARIO
CREATE TABLE CONTA (
	ID INT PRIMARY KEY,
	Nome VARCHAR (50),
	Saldo DECIMAL (10,2)
)

INSERT INTO CONTA
VALUES
(10, 'João', 5000),
(20, 'Maria', 500);


SELECT * FROM CONTA
-- REALIZAM UMA TRANSFERÊNCIA DE 1000 DO JOÃO PRA MARIA,
-- DE 200 DA MARIA PRO JOÃO. NÃO PERMITIDO NEGATIVAR CONTA.
GO

CREATE PROCEDURE usp_transferencia
	@origem INT,
	@destino INT,
	@valor DECIMAL (10,2)
AS 
BEGIN
	IF ((SELECT Saldo FROM CONTA WHERE id = @origem) >= @valor)
	BEGIN
		BEGIN TRANSACTION

			UPDATE CONTA
			SET Saldo = Saldo - @valor
			WHERE id = @origem;

			UPDATE CONTA
			SET Saldo = Saldo + @valor
			WHERE id = @destino;

		COMMIT TRAN;
		PRINT 'Transferência realizada com sucesso!';
	END
	ELSE
	BEGIN
		PRINT 'Saldo insuficiente para realizar a transferência';
	END
END;
GO

-- TESTES

-- Teste 1: João transfere 1000 para Maria 
EXEC usp_transferencia @origem = 10, @destino = 20, @valor = 1000;

-- Teste 2: Maria transfere 200 para João 
EXEC usp_transferencia @origem = 20, @destino = 10, @valor = 200;

-- Teste 3: Maria tenta transferir 2000 para João (bloqueado por saldo insuficiente)
EXEC usp_transferencia @origem = 20, @destino = 10, @valor = 2000;

-- Conferindo o resultado final
SELECT * FROM CONTA;
GO


-- COM TRY CATCH
ALTER PROCEDURE usp_transferencia 
    @origem INT, 
    @destino INT, 
    @valor DECIMAL (10,2) 
AS 
BEGIN
    IF ((SELECT Saldo FROM CONTA WHERE id = @origem) < @valor)
    BEGIN
        PRINT 'Saldo insuficiente para realizar a transferência';
        RETURN;
    END

    BEGIN TRY
        BEGIN TRANSACTION;

        UPDATE CONTA 
        SET Saldo = Saldo - @valor 
        WHERE id = @origem;

        UPDATE CONTA 
        SET Saldo = Saldo + @valor 
        WHERE id = @destino;

        COMMIT TRANSACTION;
        PRINT 'Transferência realizada com sucesso!';
    END TRY
    BEGIN CATCH
        -- Se ocorrer qualquer erro, desfaz a transação
        IF @@TRANCOUNT > 0
        BEGIN
            ROLLBACK TRANSACTION;
        END
    END CATCH
END;
GO
