USE INDICES_LOJA;
GO

SET STATISTICS IO ON;
SET STATISTICS TIME ON;
GO

SELECT PedidoID, DataPedido, ValorTotal
FROM Pedido
WHERE DataPedido = '20240115';

CREATE NONCLUSTERED INDEX ix_pedido_data
ON pedido(DataPedido)

SELECT PedidoID, DataPedido, ValorTotal
FROM Pedido
WHERE PedidoID = 15000;

SELECT PedidoID, ClienteID, DataPedido, StatusPedido, ValorTotal
FROM Pedido
WHERE ClienteID = 1234
	AND DataPedido >= '20240101'
	AND DataPedido <= '20250101'


CREATE NONCLUSTERED INDEX ix_pedido_cliente_data
ON PEDIDO(ClienteID, DataPedido)
INCLUDE (StatusPedido, ValorTotal)
GO

CREATE VIEW vw_venda_cidade
AS
SELECT C.Cidade, C.Estado, C.Nome, P.DataPedido, P.StatusPedido, P.ValorTotal, PROD.Descricao, PROD.Preco
FROM Cliente AS C
LEFT JOIN Pedido AS P
	ON P.ClienteID = C.ClienteID
JOIN Produto AS PROD
	ON PROD.ProdutoID = P.ProdutoID
GO

SELECT *
FROM vw_venda_cidade