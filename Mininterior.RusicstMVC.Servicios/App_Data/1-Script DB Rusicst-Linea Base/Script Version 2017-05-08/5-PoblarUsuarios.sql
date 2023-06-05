--=====================================================
-- Inserta los usuarios a la tabla [dbo].[AspNetUsers]
--=====================================================
INSERT INTO [dbo].[AspNetUsers]([Id],[Email],[EmailConfirmed],[PasswordHash],[SecurityStamp],[PhoneNumber],[PhoneNumberConfirmed],[TwoFactorEnabled],[LockoutEndDateUtc],[LockoutEnabled],[AccessFailedCount],[UserName])
SELECT NEWID(),Email,1,'AMYTXNeikL+4n9z19zbQUPQo6vomo9l+vxca3JV8kRWgIBfyHFlPdcduekyw4dYd+g==','Usuario de Rusicst',TelefonoFijo + (CASE WHEN TelefonoFijoExtension = '' OR TelefonoFijoExtension IS NULL THEN '' ELSE ' Ext. ' + TelefonoFijoExtension END),
1,0,'01/01/2021',1,0,UserName FROM Usuario

GO

UPDATE US SET US.IdUser = AN.Id
FROM Usuario US, AspNetUsers AN
WHERE US.UserName = AN.UserName

GO

ALTER TABLE [dbo].[Usuario] ALTER COLUMN [IdUser] NVARCHAR(128) NULL
GO

ALTER TABLE [dbo].[Usuario]  WITH NOCHECK ADD  CONSTRAINT [FK_Usuario_AspNetUsers] FOREIGN KEY([IdUser])
REFERENCES [dbo].[AspNetUsers] ([Id])
GO

ALTER TABLE [dbo].[Usuario] CHECK CONSTRAINT [FK_Usuario_AspNetUsers]
GO

CREATE NONCLUSTERED INDEX [IDX_Usuario_AspNetUsers] ON [dbo].[Usuario] ([IdUser]) 
GO


