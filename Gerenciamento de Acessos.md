# Resumo: Gerenciamento de Usuários e Permissões

O gerenciamento de usuários e permissões é fundamental para garantir a segurança e controlar o acesso aos dados. No SQL Server, esse processo envolve a criação de logins/usuários e o uso de comandos específicos de controle de acesso.

---

### 1. Criação de Usuário

O processo de acesso é dividido em duas etapas principais:

1. **Criar o Login (nível de servidor):**
```sql
CREATE LOGIN MeuLogin WITH PASSWORD = 'MinhaSenhaForte';

```


2. **Criar o Usuário no Banco de Dados:**
```sql
USE MeuBancoDeDados;
CREATE USER MeuUsuario FOR LOGIN MeuLogin;

```



---

### 2. Comandos de Controle de Permissões

As permissões são gerenciadas utilizando três comandos principais:

* **`GRANT`**: Concede permissões específicas a um usuário ou função.
```sql
GRANT SELECT ON dbo.MinhaTabela TO MeuUsuario;

```


* **`DENY`**: Nega explicitamente uma permissão, tendo precedência sobre quaisquer outras permissões concedidas.
```sql
DENY DELETE ON dbo.MinhaTabela TO MeuUsuario;

```


* **`REVOKE`**: Remove uma permissão que havia sido concedida ou negada anteriormente, retornando ao estado padrão.
```sql
REVOKE SELECT ON dbo.MinhaTabela FROM MeuUsuario;

```



---

### 3. Exemplos Práticos

* **Conceder leitura e escrita:**
```sql
GRANT SELECT, INSERT ON dbo.MinhaTabela TO MeuUsuario;

```


* **Negar exclusão de dados:**
```sql
DENY DELETE ON dbo.MinhaTabela TO MeuUsuario;

```


* **Revogar permissão de inserção:**
```sql
REVOKE INSERT ON dbo.MinhaTabela FROM MeuUsuario;

```