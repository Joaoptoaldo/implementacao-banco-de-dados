USE [master]
GO
CREATE LOGIN [joao] WITH PASSWORD=N'joao123', DEFAULT_DATABASE=[LOJA], CHECK_EXPIRATION=OFF, CHECK_POLICY=OFF
GO
use [master];
GO
USE [LOJA]
GO
CREATE USER [joao] FOR LOGIN [joao]
GO


GRANT SELECT, INSERT ON PRODUTO TO joao; -- PERMITE O USUARIO INSERIR DADOS NA TABELA
GO

DENY INSERT ON PRODUTO TO joao; -- RETIRA PERMISÃO
GO

REVOKE INSERT ON PRODUTO FROM joao; -- RETIRA AS RESTRIÇÕES DO USUARIO
GO


--Query para retonar as permissões que são dadas a nível de objetos
SELECT	state_desc, prmsn.permission_name as [Permission], sp.type_desc, sp.name,
		grantor_principal.name AS [Grantor], grantee_principal.name as [Grantee]
FROM sys.all_objects AS sp
	INNER JOIN sys.database_permissions AS prmsn 
	ON prmsn.major_id = sp.object_id AND prmsn.minor_id=0 AND prmsn.class = 1
	INNER JOIN sys.database_principals AS grantor_principal
	ON grantor_principal.principal_id = prmsn.grantor_principal_id
	INNER JOIN sys.database_principals AS grantee_principal 
	ON grantee_principal.principal_id = prmsn.grantee_principal_id
WHERE grantee_principal.name = 'joao'

-- Query para visualizar as Database Roles
SELECT p.name, p.type_desc, pp.name, pp.type_desc, pp.is_fixed_role
FROM sys.database_role_members roles
	JOIN sys.database_principals p ON roles.member_principal_id = p.principal_id
	JOIN sys.database_principals pp ON roles.role_principal_id = pp.principal_id
ORDER BY 1
