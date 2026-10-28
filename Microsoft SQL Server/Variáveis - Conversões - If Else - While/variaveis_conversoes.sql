use EMPRESA;

GO


-- Variáveis

DECLARE @nome VARCHAR(100),
		@idade INT,
		@valor INT,
		@data DATE,
		@salario MONEY;

SET @nome = 'João Pedro';
SET @idade = '22';
SET @data = GETDATE();
SET @salario = '3750.00';

SELECT	@nome AS 'Nome',
		@idade AS 'Idade',
		@data AS 'Hoje',
		@salario AS 'Salario';


GO
-- Recupere o nome do departamento com Dnumero = 4
DECLARE @nomeDpt VARCHAR(100);

SELECT @nomeDpt = D.Dnome
FROM DEPARTAMENTO AS D
WHERE D.Dnumero = 4;
PRINT @nomeDpt

GO

-- Calculando o novo salário com um aumento de 10%, para a Jennifer
DECLARE @novoSalario DECIMAL(10,2),
		@salario DECIMAL(10,2)

SELECT @novoSalario = F.Salario * 1.10
FROM FUNCIONARIO AS F
WHERE F.Pnome = 'Jennifer';

PRINT 'Novo salario: ' + CAST(@novoSalario AS VARCHAR(10)) + 
      'Antigo salario: ' + CAST(@salario AS VARCHAR(10));

GO

-- Calculando a idade da Jennifer
DECLARE @idadeJennifer INT;

SELECT @idadeJennifer = DATEDIFF(YEAR, F.Datanasc, GETDATE())
FROM FUNCIONARIO AS F
WHERE F.Pnome = 'Jennifer';

PRINT 'Idade da Jennifer: ' + CAST(@idadeJennifer AS VARCHAR(3));

GO

-- OU
DECLARE @anoAtual INT = YEAR(GETDATE())
DECLARE @anoNascimento INT

SELECT @anoNascimento = YEAR(F.Datanasc) 
FROM FUNCIONARIO AS F 
WHERE F.Pnome = 'Jennifer'

PRINT 'Idade da Jennifer: ' + CAST((@anoAtual - @anoNascimento) AS VARCHAR(3))

GO




-- Conversão de dados


-- CAST
SELECT 'O funcionario '
		+ Pnome 
		+ ' tem o salario de: R$ '
		+ CAST(Salario AS VARCHAR(10)) AS 'Nome + Salario'
FROM FUNCIONARIO;

GO


-- CONVERT
SELECT 'O funcionario '
		+ Pnome 
		+ ' tem o salario de: R$ '
		+ CONVERT(VARCHAR(10), Salario) AS 'Nome + Salario'
FROM FUNCIONARIO;

GO


-- converte a data de nascimento para padrão brasileiro: dd/mm/aaaa
DECLARE @date DATE;

SELECT @date = Datanasc
FROM FUNCIONARIO 
WHERE Pnome = 'Jennifer'

PRINT 'Formato padrão:  ' + CAST(@date AS VARCHAR(10))
PRINT 'Formato francês: ' + CONVERT(VARCHAR(10), @date, 103);

GO



