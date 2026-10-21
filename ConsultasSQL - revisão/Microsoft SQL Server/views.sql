USE EMPRESA_2026
GO

-- VIEWS

CREATE VIEW vw_rh_funcionario_DPT
AS
SELECT 
	CONCAT(Pnome,' ',Minicial,'.',Unome) AS 'Nome',
	DATEDIFF(YEAR, Datanasc, GETDATE()) AS 'Idade',
	Endereco AS 'Endereço',
	D.Dnome AS 'Departamento'
FROM FUNCIONARIO AS F
INNER JOIN DEPARTAMENTO AS D
	 ON F.Dnr = D.Dnumero;
GO


SELECT *
FROM vw_rh_funcionario_DPT
WHERE Nome LIKE '%B.%';