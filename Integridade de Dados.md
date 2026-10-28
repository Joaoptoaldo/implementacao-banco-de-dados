# Reumo: Integridade de Dados

A **integridade de dados** garante a consistência, precisão e correção das informações armazenadas em um banco de dados ao longo do tempo, o que é alcançado por meio da aplicação de restrições específicas.

---

## Tipos de Restrições de Integridade

### 1. Integridade de Domínio

Garante que o valor de cada atributo seja válido e pertença a um domínio específico (por exemplo, aceitar apenas números em um campo de preço).

```sql
CREATE TABLE Produtos (
    id_produto INT PRIMARY KEY,
    nome_produto VARCHAR(100),
    preco DECIMAL(10, 2) CHECK (preco > 0)
);

```

### 2. Integridade Referencial

Assegura que as relações entre tabelas permaneçam consistentes através de chaves estrangeiras, vinculando dados a registros existentes em outra tabela.

```sql
CREATE TABLE Vendas (
    id_venda INT PRIMARY KEY,
    id_produto INT,
    CONSTRAINT fk_produto FOREIGN KEY (id_produto) REFERENCES Produtos(id_produto)
);

```

### 3. Integridade de Vazio (NULL)

Define se uma coluna aceita ou não valores nulos, sendo indispensável para campos obrigatórios.

```sql
CREATE TABLE Funcionarios (
    id_funcionario INT PRIMARY KEY,
    nome_funcionario VARCHAR(100) NOT NULL,
    salario DECIMAL(10, 2) NOT NULL
);

```

### 4. Integridade de Chave

Assegura que os valores de uma chave primária sejam totalmente únicos em toda a tabela e nunca aceitem valores nulos.

```sql
CREATE TABLE Departamentos (
    id_departamento INT PRIMARY KEY,
    nome_departamento VARCHAR(100) NOT NULL
);

```

### 5. Integridade Definida pelo Usuário

Permite criar regras e restrições personalizadas para atender a requisitos específicos de negócio (como limitar valores permitidos em uma coluna).

```sql
CREATE TABLE Funcionarios (
    id_funcionario INT PRIMARY KEY,
    nome_funcionario VARCHAR(100),
    cargo VARCHAR(50) CHECK (cargo IN ('Gerente', 'Analista', 'Desenvolvedor'))
);

```