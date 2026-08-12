CREATE DATABASE IF NOT EXISTS hospital;
USE hospital;

CREATE TABLE IF NOT EXISTS Especialidades (
	id_especialidade INT PRIMARY KEY,
	nome_especialidade VARCHAR(100) NOT NULL,
	valor_consulta DECIMAL(10,2) NOT NULL
);

CREATE TABLE IF NOT EXISTS Medicos (
	id_medico INT PRIMARY KEY,
	nome_medico VARCHAR(100) NOT NULL,
	crm VARCHAR(20) UNIQUE NOT NULL,
	id_especialidade INT,
	FOREIGN KEY (id_especialidade) REFERENCES Especialidades(id_especialidade)
);

CREATE TABLE IF NOT EXISTS Pacientes (
	id_paciente INT PRIMARY KEY,
	nome_paciente VARCHAR(100) NOT NULL,
	data_nascimento DATE NOT NULL,
	cpf VARCHAR(14) UNIQUE NOT NULL
);

CREATE TABLE IF NOT EXISTS Consultas (
	id_consulta INT PRIMARY KEY,
	id_paciente INT,
	id_medico INT,
	data_consulta DATE NOT NULL,
	status VARCHAR(20), -- 'Realizada', 'Cancelada'
	FOREIGN KEY (id_paciente) REFERENCES Pacientes(id_paciente),
	FOREIGN KEY (id_medico) REFERENCES Medicos(id_medico)
);


INSERT INTO Especialidades VALUES
(1, 'Cardiologia', 350.00),
(2, 'Pediatria', 250.00),
(3, 'Ortopedia', 300.00);

INSERT INTO Medicos VALUES
(101, 'Dr. Arnaldo Silva', 'CRM123', 1),
(102, 'Dra. Beatriz Souza', 'CRM456', 2),
(103, 'Dr. Carlos Lira', 'CRM789', 1),
(104, 'Dra. Daniela Meirelles', 'CRM012', 3);

INSERT INTO Pacientes VALUES
(1, 'João Guedes', '1985-05-20', '111.111.111-11'),
(2, 'Maria Oliveira', '1992-10-12', '222.222.222-22'),
(3, 'Carlos Alberto', '1970-01-15', '333.333.333-33');

INSERT INTO Consultas VALUES
(1, 1, 101, '2026-05-01', 'Realizada'),
(2, 2, 102, '2026-05-02', 'Realizada'),
(3, 1, 103, '2026-05-03', 'Realizada'),
(4, 3, 101, '2026-05-04', 'Cancelada');


-- Questão 01: Escreva uma consulta que retorne o nome do paciente, 
-- o nome do médico e a data da consulta para todas as consultas com status 'Realizada'.
SELECT 
    p.nome_paciente AS Pacientes, 
    m.nome_medico AS Medicos, 
    c.data_consulta AS Consultas 
FROM Consultas c 
INNER JOIN Pacientes p ON c.id_paciente = p.id_paciente 
INNER JOIN Medicos m ON c.id_medico = m.id_medico 
WHERE c.status = 'Realizada';


-- Questão 02: Liste todos os médicos cadastrados e a quantidade de consultas associadas a cada um, 
-- incluindo aqueles que ainda não realizaram nenhuma consulta.
SELECT 
    m.nome_medico AS Medicos, 
    COUNT(c.id_consulta) AS Total_Consultas
    
FROM Medicos m
LEFT JOIN Consultas c ON m.id_medico = c.id_medico
GROUP BY m.id_medico, m.nome_medico;


-- Questão 03: Recupere o nome do paciente, o nome do médico 
-- e o nome da especialidade de todas as consultas agendadas.
SELECT 
    p.nome_paciente AS Pacientes,
    m.nome_medico AS Medicos,
    e.nome_especialidade AS Especialidades
FROM Consultas c
INNER JOIN Pacientes p ON c.id_paciente = p.id_paciente
INNER JOIN Medicos m ON c.id_medico = m.id_medico
INNER JOIN Especialidades e ON m.id_especialidade = e.id_especialidade;

-- Questão 04: Liste os nomes de todos os pacientes que já passaram por consultas 
-- com a especialidade 'Cardiologia', evitando duplicidade de nomes
SELECT DISTINCT 
    p.nome_paciente AS Paciente
FROM Pacientes p
INNER JOIN Consultas c ON p.id_paciente = c.id_paciente
INNER JOIN Medicos m ON c.id_medico = m.id_medico
INNER JOIN Especialidades e ON m.id_especialidade = e.id_especialidade
WHERE e.nome_especialidade = 'Cardiologia';


-- Questão 05 (Subquery no WHERE): Escreva uma consulta para listar os nomes dos médicos 
-- que pertencem à especialidade que possui o maior valor de consulta do hospital
SELECT 
    m.nome_medico AS Medico,
    e.nome_especialidade AS Especialidade,
    e.valor_consulta AS Valor
FROM Medicos m
JOIN Especialidades e ON m.id_especialidade = e.id_especialidade
WHERE e.valor_consulta = (SELECT MAX(valor_consulta) FROM Especialidades);

-- Questão 06 (Subquery com NOT EXISTS): Identifique os pacientes que nunca 
-- realizaram uma consulta no sistema utilizando a cláusula NOT EXISTS.
SELECT 
    p.nome_paciente
FROM Pacientes p
WHERE NOT EXISTS (
    SELECT 1 
    FROM Consultas c 
    WHERE c.id_paciente = p.id_paciente
);


-- Questão 08 (COUNT & GROUP BY): Exiba o nome de cada especialidade 
-- e o número total de médicos vinculados a ela.
SELECT 
    e.nome_especialidade,
    COUNT(m.id_medico) AS total_medicos
FROM Especialidades e
LEFT JOIN Medicos m ON e.id_especialidade = m.id_especialidade
GROUP BY e.id_especialidade, e.nome_especialidade;



-- Questão 09 (SUM & INNER JOIN): Calcule o faturamento total bruto (soma dos valores das consultas) realizado por
-- cada médico, considerando apenas consultas com status 'Realizada'.
SELECT 
    m.nome_medico,
    SUM(e.valor_consulta) AS faturamento_total
FROM Consultas c
INNER JOIN Medicos m ON c.id_medico = m.id_medico
INNER JOIN Especialidades e ON m.id_especialidade = e.id_especialidade
WHERE c.status = 'Realizada'
GROUP BY m.id_medico, m.nome_medico;

-- Questão 10 (HAVING): Liste as especialidades que geraram um faturamento 
-- total superior a R$ 500,00 no período de maio de 2026.
SELECT 
    e.nome_especialidade, 
    SUM(E.valor_consulta) AS faturamento_total
FROM Consultas c
JOIN Medicos m ON c.id_medico = m.id_medico
JOIN Especialidades e ON m.id_especialidade = e.id_especialidade
WHERE 
    c.data_consulta BETWEEN '2026-05-01' AND '2026-05-31' 
    AND c.status = 'Realizada'
GROUP BY e.id_especialidade, e.nome_especialidade
HAVING SUM(E.valor_consulta) > 500.00;

-- Questão 11 (Cenário Complexo): A diretoria do hospital deseja premiar os médicos de alta performance. Escreva
-- uma única consulta SQL que retorne o nome do médico e o valor total arrecadado por ele, mas apenas para os
-- médicos que arrecadaram um valor superior à média de faturamento de todos os médicos do hospital no mês de
-- maio de 2026. Atenção: Para o cálculo da média global, utilize uma subconsulta. Considere apenas consultas com
SELECT 
    m.nome_medico,
    SUM(e.valor_consulta) AS total_arrecadado
FROM Medicos m
JOIN Consultas c ON m.id_medico = c.id_medico
JOIN Especialidades e ON m.id_especialidade = e.id_especialidade
WHERE 
    c.status = 'Realizada'
    AND c.data_consulta BETWEEN '2026-05-01' AND '2026-05-31'
GROUP BY m.id_medico, m.nome_medico
HAVING 
    SUM(e.valor_consulta) > (SELECT AVG(sub_total) FROM (
            SELECT SUM(e2.valor_consulta) AS sub_total
            FROM Consultas c2
            JOIN Medicos m2 ON c2.id_medico = m2.id_medico
            JOIN Especialidades e2 ON m2.id_especialidade = e2.id_especialidade
            WHERE c2.status = 'Realizada'
              AND c2.data_consulta BETWEEN '2026-05-01' AND '2026-05-31'
            GROUP BY c2.id_medico
        ) AS medias
    );
