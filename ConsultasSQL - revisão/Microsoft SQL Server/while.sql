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

GO



DECLARE @contador INT = 1;


WHILE @contador <= 10
BEGIN
	PRINT 'Contador: ' + CAST(@contador AS VARCHAR);
	SET @contador = @contador+1;
END

GO


-- BREAK

DECLARE @contador INT = 1;


WHILE @contador <= 10
BEGIN
	PRINT 'Contador: ' + CAST(@contador AS VARCHAR);
	IF @contador = 5
	BREAK;
	SET @contador = @contador+1;
END

GO

-- CONTINUE

DECLARE @contador INT = 0;


WHILE @contador < 10
BEGIN
	SET @contador = @contador+1;
	IF @contador%2 = 0
		CONTINUE;
	PRINT 'Contador: ' + CAST(@contador AS VARCHAR);
END

GO