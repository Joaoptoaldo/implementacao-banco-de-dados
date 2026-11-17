CREATE DATABASE DB_TEMPORAL;
GO

USE DB_TEMPORAL;
GO


CREATE TABLE dbo.HistoricoInventarioCarros (
    carroId INT NOT NULL,
    ano INT NULL,
    marca VARCHAR(40) NULL,
    modelo VARCHAR(40) NULL,
    cor VARCHAR(40) NULL,
    quilometragem INT NULL,
    disponivel BIT NOT NULL,
    SysStartTime DATETIME2 NOT NULL,
    SysEndTime DATETIME2 NOT NULL
);
GO

CREATE CLUSTERED COLUMNSTORE INDEX IX_HistoricoInventarioCarros 
ON dbo.HistoricoInventarioCarros;
GO


CREATE TABLE dbo.InventarioCarros (
    carroId INT IDENTITY PRIMARY KEY,
    ano INT,
    marca VARCHAR(40),
    modelo VARCHAR(40),
    cor VARCHAR(40),
    quilometragem INT,
    disponivel BIT NOT NULL DEFAULT 1,
    SysStartTime DATETIME2 GENERATED ALWAYS AS ROW START NOT NULL,
    SysEndTime DATETIME2 GENERATED ALWAYS AS ROW END NOT NULL,
    PERIOD FOR SYSTEM_TIME (SysStartTime, SysEndTime)
)
WITH
(
    SYSTEM_VERSIONING = ON (HISTORY_TABLE = dbo.HistoricoInventarioCarros)
);
GO

SELECT * FROM [dbo].[InventarioCarros];
GO

USE DB_TEMPORAL;
GO

INSERT INTO dbo.InventarioCarros (ano, marca, modelo, cor, quilometragem, disponivel)
VALUES 
    (2023, 'Toyota', 'Corolla', 'Prata', 15000, 1),
    (2022, 'Honda', 'Civic', 'Preto', 28500, 1),
    (2024, 'Volkswagen', 'Nivus', 'Cinza', 5200, 1),
    (2021, 'Chevrolet', 'Onix', 'Branco', 42000, 0);
GO
INSERT INTO dbo.InventarioCarros (ano, marca, modelo, cor, quilometragem, disponivel)
VALUES 
    (2023, 'Ford', 'Ka', 'Preto', 15000, 1)
INSERT INTO dbo.InventarioCarros (ano, marca, modelo, cor, quilometragem, disponivel)
VALUES 
    (2023, 'Fiat', 'Uno', 'Preto', 15000, 1)
GO;

UPDATE InventarioCarros 
SET disponivel = 0 
WHERE carroId = 6;

UPDATE InventarioCarros 
SET disponivel = 0 
WHERE carroId = 5;

SELECT * FROM dbo.HistoricoInventarioCarros;
GO;

UPDATE InventarioCarros 
SET disponivel = 1, quilometragem = 20000
WHERE carroId = 6;

UPDATE InventarioCarros 
SET disponivel = 1, quilometragem = 500
WHERE carroId = 5;

SELECT * FROM dbo.HistoricoInventarioCarros;
GO;

DELETE FROM InventarioCarros
WHERE carroId = 6;

SELECT * FROM dbo.HistoricoInventarioCarros;
GO;

SELECT * FROM InventarioCarros
FOR SYSTEM_TIME AS OF '2026-11-17 22:50:00'
ORDER BY carroId;


SELECT DISTINCT
	H.carroId,H.marca, H.modelo, H.cor
FROM InventarioCarros AS T
RIGHT JOIN HistoricoInventarioCarros AS H
	ON T.carroId = H.carroId
WHERE T.carroId IS NULL;