# Resumo: Índices em Banco de Dados (SQL Server)

## 1. O que são e para que servem os Índices?

* **O que são?** Estruturas que otimizam o acesso e a recuperação de dados em tabelas, funcionando de forma similar ao índice remissivo de um livro.
* **Para que servem?** Melhorar a performance de consultas (`SELECT`) e acelerar operações com cláusulas como `WHERE`, `JOIN`, `ORDER BY` e `GROUP BY`.
* **Quando NÃO usar?**
* Em tabelas com poucas linhas.
* Quando há alta frequência de operações de escrita (`INSERT`, `UPDATE`, `DELETE`), pois os índices precisam ser atualizados a cada alteração.



---

## 2. Tipos de Índices

1. **Índice Clustered (Clusterizado):**
* Organiza fisicamente os dados da tabela com base na chave do índice.
* Limite de **um** índice clusterizado por tabela (geralmente criado automaticamente na `PRIMARY KEY`).


2. **Índice Non-clustered (Não Clusterizado):**
* Cria uma estrutura separada (um "ponteiro") que aponta para as linhas da tabela original.
* Uma tabela pode ter **múltiplos** índices não clusterizados.



---

## 3. Criação e Uso de Índices (Exemplos de Código)

### Criando uma tabela de exemplo

```sql
CREATE TABLE Funcionarios (
    FuncionarioID INT PRIMARY KEY,
    Nome NVARCHAR(100),
    Cargo NVARCHAR(50),
    Salario DECIMAL(10, 2),
    DataAdmissao DATE
);

```

### Criando índices não clusterizados e exclusivos

```sql
-- Índice simples em uma coluna
CREATE NONCLUSTERED INDEX IX_Funcionarios_Nome 
ON Funcionarios (Nome);

-- Índice em múltiplas colunas
CREATE NONCLUSTERED INDEX IX_Funcionarios_Cargo_Salario
ON Funcionarios (Cargo, Salario);

-- Índice Único
CREATE UNIQUE INDEX IX_Funcionarios_CPF
ON Funcionarios (FuncionarioID);

```

---

## 4. Otimização de Consultas

* **Sem Índices:** O SQL Server faz um **Full Scan** (varre a tabela inteira linha por linha).
* **Com Índices:** A busca vai direto ao ponto utilizando a estrutura do índice.

Para medir o impacto de performance, utilize o comando de estatísticas:

```sql
SET STATISTICS IO ON;
SET STATISTICS TIME ON;

SELECT * 
FROM Funcionarios
WHERE Nome = 'João da Silva';

SET STATISTICS IO OFF;
SET STATISTICS TIME OFF;

```

---

## 5. Atividade Prática: Importação de JSON e Índices

Esta atividade simula um cenário real com um grande volume de dados (`Pessoa` / `PessoasResumo`) importados a partir de um arquivo **JSON**.

### Criando a tabela de trabalho

```sql
CREATE TABLE Pessoa (
    Id       INT IDENTITY(1,1) PRIMARY KEY,
    Nome     VARCHAR(150),
    Cidade   VARCHAR(100),
    Estado   CHAR(2),
    CPF      VARCHAR(14)
);

```

### Importando dados do JSON via `OPENROWSET` e `OPENJSON`

```sql
DECLARE @json NVARCHAR(MAX);

SELECT @json = BulkColumn
FROM OPENROWSET(
        BULK 'C:\dados\pessoas.json', -- ajuste o caminho conforme o ambiente
        SINGLE_CLOB,
        CODEPAGE = '65001'           -- UTF-8
     ) AS j;

INSERT INTO Pessoa (Nome, Cidade, Estado, CPF)
SELECT 
    Nome, Cidade, Estado, CPF
FROM OPENJSON(@json)
WITH (
    Nome     VARCHAR(150) '$.nome',
    Cidade   VARCHAR(100) '$.cidade',
    Estado   CHAR(2)      '$.estado',
    CPF      VARCHAR(14)  '$.cpf'
);

```

### Criando índices para otimizar ordenação e filtros

Se o objetivo for otimizar consultas que filtram por `Estado` e ordenam por `Nome`:

```sql
CREATE NONCLUSTERED INDEX IX_Pessoas_Estado_Nome
ON Pessoa (Estado, Nome);

```
