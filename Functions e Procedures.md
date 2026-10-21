# Resumo: Functions e Stored Procedures

## 1. Conceitos Essenciais

* **UDF (User-Defined Functions):** Encapsulam lógica que retorna **um valor** (escalar) ou **uma tabela** (TVF). Podem ser usadas dentro de consultas (`SELECT`, `WHERE`, `JOIN`), mas **não** podem alterar o estado do banco (sem DML em tabelas reais).
* **Stored Procedures (Procedures):** Blocos de T-SQL **pré-compilados** executados via `EXEC`. Ideais para centralizar lógica de negócio, DML, controle transacional e segurança.

---

## 2. Funções (UDFs)

* **Padrões:** Sempre explicitar o schema (`dbo.fn_...`), usar `CREATE OR ALTER` e tratar nulos (`ISNULL`/`COALESCE`).
* **Funções Escalares:** Retornam um único valor.
```sql
CREATE OR ALTER FUNCTION dbo.fn_Dobro (@Numero INT)
RETURNS INT
AS
BEGIN
    RETURN @Numero * 2;
END;

```


* **Funções que Retornam Tabela (TVFs):**
* **Inline TVF (ITVF):** Possui uma única consulta (geralmente a opção mais rápida e recomendada).
```sql
CREATE OR ALTER FUNCTION dbo.fn_Depto (@Nome NVARCHAR(100))
RETURNS TABLE
AS
RETURN (SELECT * FROM FUNCIONARIO WHERE Dnr = 1);

```


* **Multi-Statement TVF (MSTVF):** Permite múltiplos passos utilizando uma variável de tabela interna.


* **Uso com `APPLY`:** Permite combinar funções do tipo tabela com consultas relacionais (`CROSS APPLY` / `OUTER APPLY`).

---

## 3. Stored Procedures

* **Definição e Benefícios:** Reuso de código, otimização de desempenho, segurança (controle de permissões) e facilidade de manutenção.
* **Criação e Execução Simples:**
```sql
CREATE OR ALTER PROCEDURE dbo.pr_ListarFuncionarios
AS
BEGIN
    SET NOCOUNT ON;
    SELECT * FROM dbo.FUNCIONARIO;
END;
GO

EXEC dbo.pr_ListarFuncionarios;

```


* **Parâmetros de Entrada e Saída (`OUTPUT`):**
```sql
CREATE OR ALTER PROCEDURE dbo.pr_ObterSalario
    @Cpf CHAR(11),
    @Salario DECIMAL(12,2) OUT
AS
BEGIN
    SELECT @Salario = Salario FROM FUNCIONARIO WHERE Cpf = @Cpf;
END;

```


* **Boas Práticas:** Usar parâmetros para evitar *SQL Injection*, validar entradas, centralizar regras de DML/transações e manter uma padronização de nomenclatura (ex: `dbo.pr_NomeVerbo`).