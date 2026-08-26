use EMPRESA;

GO


-- Contar o número de funcionários por departamento
SELECT D.Dnome AS 'Nome', COUNT(F.Pnome) AS 'Total de funcionários'
FROM FUNCIONARIO AS F
INNER JOIN 
	DEPARTAMENTO AS D 
	ON F.Dnr = D.Dnumero
GROUP BY D.Dnome
ORDER BY D.Dnome;



-- HAVING


-- Encontrar departamentos com mais de 3 funcionários
SELECT D.Dnome AS 'Nome', COUNT(F.Pnome) AS 'Total de funcionários'
FROM FUNCIONARIO AS F
INNER JOIN 
	DEPARTAMENTO AS D 
	ON F.Dnr = D.Dnumero
GROUP BY D.Dnome
HAVING COUNT(F.Pnome) > 3 -- CHAMA A FUNÇÃO COMO UM PONTO COMPARATIVO
ORDER BY D.Dnome;


-- Listar projetos que exigem no mínimo 50 horas de trabalho no total
SELECT P.Projnome AS 'Projeto', SUM(T.Horas) AS 'Total de horas'
FROM PROJETO AS P
INNER JOIN TRABALHA_EM AS T
    ON P.Projnumero = T.Pnr
GROUP BY P.Projnumero, P.Projnome
HAVING SUM(T.Horas) >= 50
ORDER BY 'Total de horas';



-- EXISTS


-- Listar funcionários que são gerentes de algum departamento
SELECT F.Pnome AS 'Nome', F.Unome AS 'Sobrenome', F.Cpf
FROM FUNCIONARIO AS F
WHERE 
	EXISTS (
		SELECT 1
		FROM DEPARTAMENTO AS D
		WHERE D.Cpf_gerente = F.Cpf
	);


-- Listar departamentos que possuem projetos associados
SELECT * 
FROM DEPARTAMENTO AS D 
WHERE 
	EXISTS (
		SELECT 1 
		FROM PROJETO AS P 
		WHERE P.Dnum = D.Dnumero
	);




-- ANY


-- Encontrar funcionários que ganham mais do que qualquer 
-- funcionário do departamento de 'Administração'
SELECT Pnome, Salario 
FROM FUNCIONARIO 
WHERE Salario > ANY (
    SELECT F.Salario 
    FROM FUNCIONARIO AS F 
    INNER JOIN DEPARTAMENTO AS D ON F.Dnr = D.Dnumero 
    WHERE D.Dnome = 'Administração'
) 
AND Dnr <> 4;


-- Encontrar projetos que exigem mais horas do que todos os projetos no local 'São Paulo
SELECT Projnome AS 'Projeto', SUM(Horas) AS 'Horas'
FROM PROJETO
INNER JOIN 
	TRABALHA_EM 
	ON Pnr = Projnumero
GROUP BY Projnome
HAVING SUM(Horas) > ALL (
	SELECT SUM(T.Horas) AS 'Total de horas'
	FROM PROJETO AS P
	INNER JOIN 
		TRABALHA_EM AS T
		ON T.Pnr = P.Projnumero
	WHERE P.Projlocal = 'São Paulo'
	GROUP BY P.Projnome
);

