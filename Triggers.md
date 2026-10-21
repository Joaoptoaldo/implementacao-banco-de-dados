# Resumo: Triggers


## 1. O que são Triggers (Gatílhos)

* **Definição:** Objetos de banco de dados associados a tabelas ou visões que **executam automaticamente** em resposta a eventos de DML (`INSERT`, `UPDATE`, `DELETE`).
* **Benefícios:** Validação automática de dados, auditoria de alterações e automação de processos.
* **Tabelas Mágicas Internas:**
* `inserted`: Armazena cópias das linhas afetadas por comandos `INSERT` ou `UPDATE`.
* `deleted`: Armazena cópias das linhas afetadas por comandos `DELETE` ou `UPDATE` (dados antigos).

---

## 2. Tipos de Triggers

* **AFTER Triggers (ou FOR):** Executados **depois** que a operação é concluída com sucesso. Úteis para validações e auditorias pós-evento.
```sql
CREATE TRIGGER trg_check_salary
ON FUNCIONARIO
AFTER INSERT, UPDATE
AS
BEGIN
    IF (SELECT Salario FROM inserted) < 1000.00
    BEGIN
        RAISERROR('Salário mínimo não atingido.', 16, 1);
        ROLLBACK TRANSACTION;
    END
END;

```

* **INSTEAD OF Triggers:** Executados **em vez** da operação solicitada. Substituem completamente o comportamento padrão, permitindo controle customizado.
```sql
CREATE TRIGGER trg_instead_insert
ON FUNCIONARIO
INSTEAD OF INSERT
AS
BEGIN
    -- Lógica customizada de inserção ou bloqueio
END;

```
