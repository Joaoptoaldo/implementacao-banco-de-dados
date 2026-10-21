# Resumo: Banco de Dados Ativos

## 1. Introdução a Bancos de Dados Ativos

* **O que são:** Sistemas que reagem automaticamente a eventos ou condições, incorporando lógica de negócios diretamente no SGBD.
* **Mecanismos de Reatividade:**
1. **Gatilhos (Triggers):** Ações executadas automaticamente em resposta a inserções, atualizações ou exclusões.
2. **Regras Ativas (ECA):** Estrutura de **Evento $\rightarrow$ Condição $\rightarrow$ Ação**.
3. **Restrições e Validações:** Garantia automática de integridade.


* **Benefícios:** Automação, consistência de regras de negócio, maior eficiência e segurança.

---

## 2. Variáveis no SQL Server

* **Declaração:** Usa-se a palavra-chave `DECLARE`.
```sql
DECLARE @NomeVariavel TipoDeDado;

```


* **Tabelas Temporárias em Memória:** Úteis para armazenar resultados intermediários.
```sql
DECLARE @TabelaAlunos TABLE (Id INT, Nome VARCHAR(50));

```


* **Atribuição:** Utiliza-se `SET` ou `SELECT`.
```sql
SET @Nome = 'João';
SELECT @Nome = 'Maria';

```


* **Exibição:** Comandos `PRINT` ou `SELECT`.

---

## 3. Conversão de Dados

* **`CAST`:** Converte um tipo de dado em outro de forma padrão.
```sql
SELECT CAST('2024-08-12' AS DATETIME);

```

* **`CONVERT`:** Similar ao `CAST`, mas oferece maior flexibilidade na formatação (especialmente útil para datas com estilos específicos).
```sql
SELECT CONVERT(VARCHAR(10), GETDATE(), 103); -- Formato DD/MM/YYYY

```
---

## 4. Estruturas Condicionais

* **`IF / ELSE`:** Executa blocos de código com base em condições booleanas. Muito utilizado para verificar a existência de bancos de dados (`sys.databases`) ou tabelas (`sys.objects`) antes de criá-los.
* **`CASE`:** Avalia múltiplas condições e retorna valores específicos (equivalente a uma estrutura de decisão dentro de consultas).
```sql
SELECT CASE 
    WHEN Salario > 5000 THEN 'Alto'
    ELSE 'Baixo'
END FROM Funcionarios;

```

---

## 5. Loops e Laços de Repetição

* **`WHILE`:** Repete um bloco de comandos enquanto uma condição for verdadeira.
* **`BREAK`:** Interrompe e sai imediatamente do laço.
* **`CONTINUE`:** Pula a iteração atual e avança para a próxima.


* **Cursores (Cursors):** Permitem percorrer e processar um conjunto de resultados **linha por linha**.
* **`@@FETCH_STATUS`:** Função global que controla o fluxo do cursor (`0` = sucesso, `-1` = fim do cursor ou erro, `-2` = linha excluída).

---

## 6. Procedimentos Armazenados (Stored Procedures)

* Bloco de código SQL reutilizável que pode receber parâmetros de entrada e retornar valores de saída (`OUTPUT`).