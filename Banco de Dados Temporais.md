# Bancos de Dados Temporais (Temporal Tables) no SQL Server

Os **Bancos de Dados Temporais** (ou *System-Versioned Temporal Tables*) são um recurso introduzido no SQL Server 2016 (e padrão ANSI SQL:2011) projetado para manter um histórico completo de todas as alterações feitas nos dados ao longo do tempo, sem a necessidade de criar triggers ou código complexo na aplicação.

---

## 1. Como Funcionam?

Uma tabela temporal trabalha com um par de tabelas que operam em conjunto:

1. **Tabela Atual (Principal):** Armazena os dados vigentes no momento atual. Recebe comandos normais de `INSERT`, `UPDATE`, `DELETE` e `SELECT`.
2. **Tabela de Histórico:** Armazena automaticamente todas as versões anteriores de cada linha que foi atualizada ou excluída. É uma tabela somente leitura para o usuário enquanto o versionamento estiver ativo.

### Fluxo de Operações
* **`INSERT`:** O registro é adicionado apenas na tabela atual com a data/hora de início (`SysStartTime`) e fim máximo (`9999-12-31`).
* **`UPDATE`:** A versão antiga do registro é movida para a tabela de histórico com a data/hora exata em que deixou de valer (`SysEndTime`), e a tabela atual recebe os novos valores com um novo `SysStartTime`.
* **`DELETE`:** O registro é removido da tabela atual e movido para a tabela de histórico com o registro do momento da exclusão.

---

## 2. Requisitos Estruturais

Para que uma tabela seja temporal no SQL Server, ela precisa atender a alguns critérios obrigatórios:
* Possuir uma **Chave Primária (`PRIMARY KEY`)** na tabela principal.
* Possuir duas colunas do tipo `DATETIME2` definidas como `GENERATED ALWAYS AS ROW START` e `GENERATED ALWAYS AS ROW END` (não nulas).
* Definir a cláusula `PERIOD FOR SYSTEM_TIME` apontando para essas duas colunas.
* Ativar a opção `SYSTEM_VERSIONING = ON`.
* A tabela de histórico **não pode** conter chaves primárias, chaves estrangeiras, `IDENTITY`, colunas computadas ou restrições `DEFAULT`.

---

## 3. Exemplo Prático: Criação e Manipulação

### Passo 1: Criando a Tabela Temporal
Neste exemplo, o SQL Server criará automaticamente a tabela de histórico `dbo.HistoricoInventarioCarros`.

```sql
CREATE DATABASE DB_TEMPORAL;
GO

USE DB_TEMPORAL;
GO

CREATE TABLE dbo.InventarioCarros (
    carroId INT IDENTITY PRIMARY KEY,
    ano INT,
    marca VARCHAR(40),
    modelo VARCHAR(40),
    cor VARCHAR(40),
    quilometragem INT,
    disponivel BIT NOT NULL DEFAULT 1,
    -- Colunas obrigatórias de controle de período
    SysStartTime DATETIME2 GENERATED ALWAYS AS ROW START NOT NULL,
    SysEndTime DATETIME2 GENERATED ALWAYS AS ROW END NOT NULL,
    PERIOD FOR SYSTEM_TIME (SysStartTime, SysEndTime)
)
WITH (
    SYSTEM_VERSIONING = ON (HISTORY_TABLE = dbo.HistoricoInventarioCarros)
);
GO
```

### Passo 2: Inserindo, Atualizando e Excluindo Dados
As operações de escrita são feitas exclusivamente na tabela principal.

```sql
-- 1. Inserindo registros (vão apenas para a tabela principal)
INSERT INTO dbo.InventarioCarros (ano, marca, modelo, cor, quilometragem, disponivel)
VALUES 
    (2023, 'Toyota', 'Corolla', 'Prata', 15000, 1),
    (2022, 'Honda', 'Civic', 'Preto', 28500, 1);

-- 2. Atualizando um registro (gera a primeira entrada no histórico)
UPDATE dbo.InventarioCarros
SET quilometragem = 18500, cor = 'Cinza'
WHERE carroId = 1;

-- 3. Excluindo um registro (move o registro final para o histórico)
DELETE FROM dbo.InventarioCarros
WHERE carroId = 2;
```

---

## 4. Consultas Temporais (`FOR SYSTEM_TIME`)

A grande vantagem das tabelas temporais é a capacidade de "viajar no tempo" usando a cláusula `FOR SYSTEM_TIME` diretamente no `SELECT`.

> **Nota:** Os horários armazenados nas colunas `SysStartTime` e `SysEndTime` são sempre baseados no fuso horário **UTC**.

### A. Estado dos dados em um ponto específico (`AS OF`)
Retorna exatamente como a tabela estava em uma data e hora específicas.

```sql
SELECT * FROM dbo.InventarioCarros
FOR SYSTEM_TIME AS OF '2026-11-17 20:00:00';
```

### B. Todo o histórico de um registro (`ALL`)
Une automaticamente os dados da tabela atual e da tabela de histórico para mostrar a linha do tempo completa.

```sql
SELECT carroId, modelo, cor, quilometragem, SysStartTime, SysEndTime
FROM dbo.InventarioCarros
FOR SYSTEM_TIME ALL
WHERE carroId = 1
ORDER BY SysStartTime;
```

### C. Alterações ocorridas em um intervalo (`BETWEEN` / `FROM ... TO`)
Retorna todas as versões de linhas que estiveram ativas dentro de um período determinado.

```sql
-- Inclui registros ativos nos limites exatos das datas
SELECT * FROM dbo.InventarioCarros
FOR SYSTEM_TIME BETWEEN '2026-11-01 00:00:00' AND '2026-11-30 23:59:59';

-- Exclui registros que começaram exatamente na data final
SELECT * FROM dbo.InventarioCarros
FOR SYSTEM_TIME FROM '2026-11-01 00:00:00' TO '2026-11-30 23:59:59';
```

### D. Registros totalmente contidos no período (`CONTAINED IN`)
Retorna apenas as versões de linhas que foram abertas e fechadas dentro do intervalo especificado (útil para auditar apenas registros antigos já alterados/excluídos).

```sql
SELECT * FROM dbo.InventarioCarros
FOR SYSTEM_TIME CONTAINED IN ('2026-11-01 00:00:00', '2026-11-30 23:59:59');
```

---

## 5. Principais Casos de Uso

* **Auditoria e Conformidade (Compliance):** Rastrear quem alterou dados críticos e quando, atendendo a normas como LGPD, SOX ou auditorias financeiras.
* **Recuperação de Dados Acidentais:** Restaurar facilmente registros excluídos ou sobrescritos por engano sem precisar restaurar um backup completo do banco de dados.
* **Análise de Tendências (Time-Travel Analytics):** Comparar estados de estoque, preços ou métricas de negócio entre diferentes meses ou anos.
* **Slowly Changing Dimensions (SCD Tipo 2):** Simplificar o armazenamento de histórico em projetos de Data Warehouse e Business Intelligence.