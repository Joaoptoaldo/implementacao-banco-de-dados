USE EMPRESA;

GO;



-- Selecionar o primeiro nome, último nome, 
-- endereço dos funcionários que trabalham no departamento de “Pesquisa”
SELECT 
	F.Pnome AS 'Nome', 
	F.Unome AS 'Sobrenome', 
	F.Endereco AS 'Endereço',
	D.Dnome AS 'Departamento'
FROM FUNCIONARIO AS F
INNER JOIN 
	DEPARTAMENTO AS D
	ON F.Dnr = D.Dnumero
WHERE D.Dnome = 'Pesquisa';



-- Liste o nome dos funcionários que estão desenvolvendo o “ProdutoX”
SELECT F.Pnome, T.Pnr, P.Projnome
FROM FUNCIONARIO AS F
INNER JOIN 
	TRABALHA_EM AS T
	ON T.Fcpf = F.Cpf
INNER JOIN 
	PROJETO AS P
	ON T.Pnr = P.Projnumero
WHERE P.Projnome = 'ProdutoX';




-- Para cada projeto localizado em “Mauá”, liste o número do projeto, o número do departamento que o
-- controla e o sobrenome, endereço e data de nascimento do gerente do departamento
SELECT 
    P.Projnumero, 
    P.Dnum, 
	P.Projnome,
    F.Unome,
	F.Endereco,
    F.Datanasc
FROM 
    PROJETO AS P
INNER JOIN 
    DEPARTAMENTO AS D 
	ON P.Dnum = D.Dnumero
INNER JOIN 
    FUNCIONARIO F 
	ON D.Cpf_gerente = F.Cpf
WHERE 
    P.Projlocal = 'Mauá';



-- Liste o último nome de TODOS os funcionários e o último nome dos respectivos gerentes, caso possuam
SELECT 
    F.Pnome AS 'Funcionario',
	F.Unome AS 'Supervisor'
FROM 
    FUNCIONARIO AS F
LEFT JOIN 
    FUNCIONARIO AS S
	ON F.Cpf_supervisor = S.Cpf



-- Encontre os departamentos que não possuem funcionários a eles vinculados
SELECT D.Dnome, D.Dnumero
FROM 
	DEPARTAMENTO AS D
LEFT JOIN 
	FUNCIONARIO AS F
	ON D.Dnumero = F.Dnr
WHERE F.Dnr IS NULL;



-- Encontre os funcionarios que não possuem nenhum dependente
SELECT 
*
FROM DEPENDENTE AS D
RIGHT JOIN 
	FUNCIONARIO AS F
	ON D.Fcpf = F.Cpf
WHERE D.Fcpf IS NULL;


-- Encontre os funcionarios que possuem dependente
SELECT DISTINCT F.Pnome
FROM DEPENDENTE AS D
JOIN 
	FUNCIONARIO AS F
ON D.Fcpf =  F.Cpf;



-- Teste entre as relações Funcionários e Departamento
SELECT F.Pnome, D.Dnome
FROM FUNCIONARIO AS F
FULL JOIN 
	DEPARTAMENTO AS D
	ON F.Dnr = D.Dnumero
ORDER BY F.Dnr DESC;



-- UNION


-- Listar todos os nomes, sexo e data de nascimento de todas as pessoas do banco
SELECT 
	F.Pnome AS 'Nome', 
	F.Sexo AS 'Sexo',
	F.Datanasc AS 'Data de nascimento'
FROM FUNCIONARIO AS F
UNION
SELECT 
	D.Nome_dependente AS 'Nome', 
	D.Sexo AS 'Sexo',
	D.Datanasc AS 'Data de nasciemnto'
FROM DEPENDENTE AS D;



-- lista de todas as cidades onde a empresa possui alguma atividade, 
-- seja a localização de um departamento ou a localização de um projeto
SELECT L.Dlocal AS 'Cidade'
FROM LOCALIZACAO_DEP AS L
UNION ALL
SELECT P.Projlocal AS 'Cidade'
FROM PROJETO AS P


-- EXCEPT


-- Listar os CPFs dos funcionários que não são gerentes de nenhum departamento

SELECT F.Cpf AS 'CPF'
FROM FUNCIONARIO AS F
EXCEPT
SELECT D.Cpf_gerente AS 'CPF'
FROM DEPARTAMENTO AS D


-- INTERSECT


-- Encontre os Funcionários que são gerentes
SELECT F.Cpf AS 'CPF'
FROM FUNCIONARIO AS F
INTERSECT
SELECT D.Cpf_gerente AS 'CPF'
FROM DEPARTAMENTO AS D



-- GROUP BY


-- Contar o número de funcionários (masculinos) por departamento
SELECT 
	D.Dnome,
	COUNT(F.Cpf) AS 'Qtd de funcionarios'
FROM FUNCIONARIO AS F
INNER JOIN 
	DEPARTAMENTO AS D
	ON F.Dnr = D.Dnumero
WHERE F.Sexo = 'M'
GROUP BY D.Dnome
ORDER BY D.Dnome ASC;


-- Somar os salários por departamento
SELECT 
	D.Dnome,
	SUM(F.Salario)	
FROM FUNCIONARIO AS F
INNER JOIN 
	DEPARTAMENTO AS D
	ON F.Dnr = D.Dnumero
GROUP BY D.Dnome
ORDER BY D.Dnome ASC;


-- Maior salário em cada departamento
SELECT 
	D.Dnome,
	MAX(F.Salario)	
FROM FUNCIONARIO AS F
INNER JOIN 
	DEPARTAMENTO AS D
	ON F.Dnr = D.Dnumero
GROUP BY D.Dnome
ORDER BY D.Dnome ASC;


-- Quantidade de funcionários por sexo
SELECT 
	F.Sexo,
	COUNT(*) AS 'Qtd/sexo'
FROM FUNCIONARIO AS F
GROUP BY F.Sexo;


-- Número de projetos em cada local
SELECT 
	P.Projlocal,
	COUNT(*)
FROM PROJETO AS P
GROUP BY P.Projlocal;