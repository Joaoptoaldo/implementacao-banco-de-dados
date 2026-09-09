use EMPRESA;

GO


-- FUNÇÕES
CREATE OR ALTER FUNCTION fnDobro(@numero INT)
RETURNS DECIMAL(10,2)
AS 
BEGIN
	RETURN @numero*2;
END
GO

SELECT dbo.fnDobro(10) AS resultado;
GO

-- dobro do salario
SELECT 
	F.Pnome AS 'Nome', 
	F.Unome AS 'Sobrenome', 
	dbo.fnDobro(F.salario) AS 'Dobro'
FROM FUNCIONARIO AS F
GO



-- função que calcula a idade de um funcionario com base na data de nascimento
CREATE FUNCTION fnCalculaIdade(@data DATE)
RETURNS INT
AS
BEGIN
	DECLARE @idade INT;
	SET @idade = DATEDIFF(YEAR, @data, GETDATE());

	 IF (MONTH(@data) > MONTH(GETDATE()) 
        OR (MONTH(@data) = MONTH(GETDATE()) 
			AND DAY(@data) > DAY(GETDATE())))

			SET @idade = @idade-1;

	RETURN @idade;
END
GO

SELECT 
	F.Pnome AS 'Nome', 
	F.Unome AS 'Sobrenome', 
	F.Datanasc AS 'Data de nascimento', 
	dbo.fnCalculaIdade(F.Datanasc) AS 'Idade'
FROM FUNCIONARIO AS F
WHERE F.Sexo = 'M'
ORDER BY 'Idade' ASC
GO


-- função que retorna todos os funcionarios do departamento de pesquisa
CREATE FUNCTION fnFuncDpt(@nome VARCHAR(30))
RETURNS TABLE
RETURN(
	SELECT F.Pnome, F.Unome
	FROM FUNCIONARIO AS F
	JOIN DEPARTAMENTO AS D
	ON F.Dnr = D.Dnumero
	WHERE D.Dnome = @nome
);
GO

SELECT * FROM dbo.fnFuncDpt('Pesquisa');
GO



-- função que retorna o nome completo dos funcionarios e o valor do salario anual
-- com ferias e decimo terceiro;
CREATE OR ALTER FUNCTION fnSalarioAnual()
RETURNS @relacaoSalarial TABLE
(
    nomeCompleto VARCHAR(150),
    salarioMensal DECIMAL(10,2),
    salarioAnual DECIMAL(10,2)
)
AS 
BEGIN
    INSERT INTO @relacaoSalarial (nomeCompleto, salarioMensal, salarioAnual)
    SELECT 
        CONCAT(Pnome, ' ', Unome),
        Salario,
        Salario * 13 + (Salario * 0.3)
    FROM FUNCIONARIO;
    
    RETURN;
END
GO

SELECT * FROM dbo.fnSalarioAnual();
GO



-- função que calcula o salario anual de um funcionario (12 meses), 
-- mas tambem considerar um bônus variavel (%), passado como parâmetro
CREATE OR ALTER FUNCTION fnSalarioAnualComBonus(@bonusPorcentagem DECIMAL(5,2))
RETURNS @relacaoSalarial TABLE
(
    salarioAnual DECIMAL(10,2),
    bonus DECIMAL(10,2)
)
AS 
BEGIN
    INSERT INTO @relacaoSalarial (salarioAnual, bonus)
    SELECT 
        -- calculo: (salário * 12) aplicado o acréscimo do bônus percentual
        (Salario * 12) * (1 + (@bonusPorcentagem / 100.0)),
        -- valor isolado do bônus ganho sobre o salário mensal
        Salario * (@bonusPorcentagem / 100.0)
    FROM FUNCIONARIO;
    
    RETURN;
END
GO


SELECT 
    F.Pnome,
    F.Unome,
    F.Salario AS 'Salario mensal',
    R.salarioAnual AS 'Salario anual',
    R.bonus AS 'Valor do bonus'
FROM FUNCIONARIO AS F
CROSS APPLY dbo.fnSalarioAnualComBonus(10.0) AS R; -- passando 10% de bônus 
GO