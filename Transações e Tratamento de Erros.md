# Resumo: Transações e Tratamento de Erros


## 1. Conceitos de Transações

* **O que é:** Unidade de trabalho indivisível que agrupa operações (INSERT, UPDATE, DELETE, SELECT). Deve ser **completamente concluída ou totalmente revertida**.
* **Comandos Principais:**
* `BEGIN TRANSACTION`: Inicia a transação.
* `COMMIT TRANSACTION`: Salva permanentemente as alterações.
* `ROLLBACK TRANSACTION`: Desfaz todas as operações feitas desde o início.
* `SAVEPOINT` / `SAVE TRANSACTION`: Cria um ponto de salvamento para permitir rollbacks parciais.

---

## 2. Propriedades ACID

* **A (Atomicidade):** Tudo ou nada; se uma parte falha, tudo é desfeito.
* **C (Consistência):** O banco passa de um estado válido para outro, respeitando regras e restrições (chaves, integridade referencial).
* **Isolamento:** Controla a visibilidade e concorrência entre transações simultâneas (ex: `SET TRANSACTION ISOLATION LEVEL`).
* **D (Durabilidade):** Uma vez confirmadas (`COMMIT`), as alterações persistem mesmo diante de falhas do sistema.

---

## 3. Tratamento de Erros com `TRY...CATCH`

* **Estrutura:** Protege blocos de código contra falhas inesperadas e centraliza a tomada de decisão.
```sql
BEGIN TRY
    BEGIN TRAN;
    -- Operações DML
    COMMIT;
END TRY
BEGIN CATCH
    IF XACT_STATE() <> 0 
        ROLLBACK;
    -- Tratamento do erro
END CATCH;

```

* **Funções Úteis no `CATCH`:**
* `ERROR_NUMBER()`, `ERROR_MESSAGE()`, `ERROR_LINE()`: Retornam detalhes do erro.
* `XACT_STATE()`: Indica o estado da transação (`1` = ativa/comitável, `-1` = incomitável/corrompida, `0` = sem transação ativa).