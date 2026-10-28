use EMPRESA;

GO



-- CONDICIONAIS

DECLARE @nome VARCHAR(100),
		@idade INT;

SET @nome = 'João Pedro';
SET @idade = 22;

IF (@idade >= 18 AND @idade <= 150)
	PRINT 'O ' + @nome + ' é maior de idade';

ELSE IF (@idade <= 0 OR @idade > 150)
	PRINT 'valor incorreto';

ELSE
	PRINT 'O ' + @nome + ' é menor de idade';

GO


-- verificar se um funcionario recebe abaixo da média salarial
DECLARE @media DECIMAL(10,2),
		@salario DECIMAL(10,2);

SELECT @media = AVG(F.Salario)
FROM FUNCIONARIO AS F
WHERE F.Pnome = 'Pedro'

PRINT @media


IF (@salario < @media)
	PRINT 'Abaixo da média';
ELSE 
	PRINT 'Ta no lucro';

GO


-- verifica se um funcionario está proximo da aposentadoria, 
-- considera a idade para aponsentadoria de 60 anos
DECLARE @dataNasc DATE,
		@idade INT,
		@diaNasc INT,
		@dia INT,
		@mesNasc INT,
		@mes INT;


SELECT @dataNasc = F.Datanasc
FROM FUNCIONARIO AS F
WHERE F.Pnome = 'Ronaldo'

SET @mesNasc = MONTH(@dataNasc);
SET @mes = MONTH(GETDATE());
SET @diaNasc = DAY(@dataNasc);
SET @dia = DAY(GETDATE());

IF (@mesNasc > @mes OR (@mesNasc = @mes AND @diaNasc > @dia))
	SET @idade = DATEDIFF(YEAR, (@dataNasc), GETDATE()) -1;

ELSE 
	SET @idade = DATEDIFF(YEAR, (@dataNasc), GETDATE());


PRINT @dataNasc
PRINT @idade

IF (@idade >= 55 AND @idade < 60)
    PRINT 'O funcionário está próximo da aposentadoria';
ELSE IF (@idade >= 60)
    PRINT 'O funcionário já atingiu a idade para se aposentar';
ELSE
    PRINT 'O funcionário ainda não está próximo da aposentadoria';

GO


-- verifica se um funcionario já recebeu um bônus 
DECLARE @bonus DECIMAL(10,2);

SELECT @bonus = F.Bonus
FROM FUNCIONARIO AS F 
WHERE Pnome = 'Jorge'

PRINT @bonus

IF (@bonus IS NULL OR @bonus <= 0)
	PRINT 'Nunca recebeu um bônus';
ELSE 
	PRINT 'Recebeu: R$' + CAST(@bonus AS VARCHAR(10));

GO


-- classifica os funcionarios que ganham mais do que 30.000 => V && funcionarios que ganham menos do que 30.000 => F
SELECT 
	F.Pnome,
	F.Unome,
	F.Salario,
	IIF(F.Salario >= 30000, 'V', 'F') AS 'Class'
FROM FUNCIONARIO AS F;

GO

-- classifica que até: 
-- 8k => baixo
-- 8k - 30k => médio 
-- 30k+ => alto
SELECT F.Pnome, F.Unome, F.Salario,
	CASE
		WHEN F.Salario <= 8000 THEN 'Baixo'
		WHEN F.Salario > 8000 AND F.Salario < 30000 THEN 'Médio'
		WHEN F.Salario >= 30000 THEN 'Alto'
	END AS 'Categoria'
FROM FUNCIONARIO AS F

GO
