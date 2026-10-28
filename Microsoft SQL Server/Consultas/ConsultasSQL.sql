USE EMPRESA;

GO;

-- lista as diferentes faixas salariais 
SELECT DISTINCT F.Salario
FROM FUNCIONARIO AS F
WHERE F.Salario >= 30000;


-- encontra funcionarios que o primeiro nome é "João"
SELECT 
*
FROM FUNCIONARIO AS F
WHERE F.Pnome = 'João';

-- lista funcionarios sexo masculino com salario >= 30.000
SELECT 
*
FROM FUNCIONARIO AS F
WHERE F.Sexo = 'M' AND F.Salario >= 30000;


-- lista os funcionarios que residem em São Paulo ou Curitiba
SELECT 
*
FROM FUNCIONARIO AS F
WHERE 
	F.Endereco LIKE '%São Paulo%' 
	OR F.Endereco LIKE '%Curitiba%' 


-- lista todos os funcionarios que não residem em SP
SELECT 
*
FROM FUNCIONARIO AS F
WHERE F.Endereco NOT LIKE '%São Paulo%';


-- lista os funcinarios ordenados pelo salario decrescente 
SELECT F.Pnome, F.Salario
FROM FUNCIONARIO AS F
ORDER BY F.Salario DESC;


-- lista os funcionarios que não possuem um supervisor 
SELECT 
*
FROM FUNCIONARIO AS F
WHERE F.Cpf_supervisor IS NULL


-- lista os funcionarios que possuem um supervisor 
SELECT 
*
FROM FUNCIONARIO AS F
WHERE F.Cpf_supervisor IS NOT NULL


-- lista os os funcionarios com os 3 maiores salarios
SELECT TOP 3 *
FROM FUNCIONARIO AS F
ORDER BY F.Salario DESC


-- mostra o funcionario com o menor salario
SELECT
* 
FROM FUNCIONARIO AS F
WHERE 
	F.Salario = (SELECT MIN(Salario) FROM FUNCIONARIO);


-- mostra o funcionario com o maior salario
SELECT
* 
FROM FUNCIONARIO AS F
WHERE 
	F.Salario = (SELECT MAX(Salario) FROM FUNCIONARIO);


-- mostra o numero de funcionarios do sexo feminino
SELECT COUNT(F.Pnome) AS 'Quantidade'
FROM FUNCIONARIO AS F
WHERE F.Sexo = 'F'; 

-- mostra o numero de funcionarios
SELECT COUNT(F.Pnome) AS 'N. funcionarios'
FROM FUNCIONARIO AS F

-- mostra o numero de dependentes
SELECT COUNT(D.Nome_dependente) AS 'N. dependentes'
FROM DEPENDENTE AS D

-- mostra a quantidade de pessoas cadastradas no sistema
SELECT
	(SELECT COUNT(Cpf) FROM FUNCIONARIO) + 
	(SELECT COUNT(Nome_dependente) FROM DEPENDENTE)
	AS 'Total';


-- média salarial dos funcionarios
SELECT AVG(F.Salario)
FROM FUNCIONARIO AS F


-- valor total da folha de pagamento
SELECT SUM(F.Salario) AS 'Folha pgt'
FROM FUNCIONARIO AS F


-- recupera funcionarios nascidos no ano de 1972
SELECT 
*
FROM FUNCIONARIO AS F
WHERE F.Datanasc LIKE '__72%';


-- recupera o nome dos funcionarios que recebem 25000 e 30000 R$
SELECT F.Pnome, F.Salario
FROM FUNCIONARIO AS F
WHERE F.Salario IN (25000, 30000);


-- em quais projetos o Fernando trabalha
SELECT * FROM FUNCIONARIO AS F

SELECT T.Pnr
FROM TRABALHA_EM AS T
WHERE T.Fcpf = '33344555587';

SELECT DISTINCT T.Fcpf
FROM TRABALHA_EM AS T
WHERE Pnr IN (2, 3, 10, 20)
AND NOT Fcpf = '33344555587';


DECLARE @Cpf VARCHAR(11);
SET @Cpf = (SELECT Cpf FROM FUNCIONARIO WHERE Pnome = 'Fernando');

SELECT T.Pnr
FROM TRABALHA_EM AS T
WHERE T.Fcpf = @Cpf


SELECT T.Fcpf, F.Pnome AS 'Nome' , F.Unome AS 'Sobrenome'
FROM TRABALHA_EM AS T, FUNCIONARIO AS F
WHERE T.Pnr IN (
	SELECT Pnr
	FROM TRABALHA_EM
	WHERE Fcpf = @Cpf)
	AND
	Fcpf <> @Cpf
	AND 
	T.Fcpf = F.Cpf;


-- JOIN
SELECT 
	CONCAT(F.Pnome, ' ', F.Minicial, '. ', F.Unome) AS 'Nome',
	F.Endereco AS 'Endereço'
FROM FUNCIONARIO AS F
INNER JOIN 
DEPARTAMENTO AS D
ON F.Dnr = D.Dnumero
WHERE D.Dnome = 'Pesquisa'