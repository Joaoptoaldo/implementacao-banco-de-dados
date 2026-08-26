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
