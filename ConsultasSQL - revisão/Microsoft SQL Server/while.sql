use EMPRESA;

GO


-- LAÇOS DE REPETIÇÃO (WHILE)


DECLARE @valor INT
SET @valor = 0

WHILE @valor < 10
	BEGIN 
		PRINT 'Numero: ' + CAST(@valor AS VARCHAR(2))
		SET @valor = @valor+1
	END




