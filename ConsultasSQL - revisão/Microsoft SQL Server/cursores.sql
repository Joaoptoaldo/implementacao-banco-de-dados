use EMPRESA;

GO


-- Cursores

DECLARE @nome VARCHAR(50);

DECLARE cursorFuncionario CURSOR FOR
SELECT Pnome FROM FUNCIONARIO;
OPEN cursorFuncionario;
FETCH NEXT FROM cursorFuncionario INTO @nome;


WHILE @@FETCH_STATUS = 0
BEGIN 
	PRINT @nome
	FETCH NEXT FROM cursorFuncionario INTO @nome;
END
CLOSE cursorFuncionario;
DEALLOCATE cursorFuncionario;

GO