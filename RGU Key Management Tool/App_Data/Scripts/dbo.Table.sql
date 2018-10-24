CREATE TABLE [dbo].[Keys]
(
	[KeyId] INT NOT NULL PRIMARY KEY,
	[KeyDesc] nvarchar(100) NOT NULL, 
    [KeyLocation] NVARCHAR(100) NOT NULL, 
    [CurrentRenter] NVARCHAR(100) NOT NULL, 
    [RentedFrom] DATETIME NULL, 
    [RentedTo] DATETIME NULL
)