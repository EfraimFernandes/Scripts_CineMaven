-- Script SQL para criar as tabelas do CineMaven
-- Execute este script no SQL Server Management Studio ou Azure Data Studio

USE CineMaven;
GO

-- Tabela de Usuários
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Users]') AND type in (N'U'))
BEGIN
    CREATE TABLE [dbo].[Users] (
        [Id] INT IDENTITY(1,1) PRIMARY KEY,
        [Email] NVARCHAR(255) NOT NULL UNIQUE,
        [Name] NVARCHAR(255) NOT NULL,
        [PasswordHash] NVARCHAR(MAX) NOT NULL,
        [CreatedAt] DATETIME2 NOT NULL DEFAULT GETUTCDATE()
    );
    
    CREATE INDEX IX_Users_Email ON [dbo].[Users]([Email]);
END
GO

-- Tabela de Avaliações
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Ratings]') AND type in (N'U'))
BEGIN
    CREATE TABLE [dbo].[Ratings] (
        [Id] INT IDENTITY(1,1) PRIMARY KEY,
        [UserId] INT NOT NULL,
        [MovieId] INT NOT NULL,
        [Nota] DECIMAL(5,2) NOT NULL CHECK ([Nota] >= 0.5 AND [Nota] <= 100),
        [CreatedAt] DATETIME2 NOT NULL DEFAULT GETUTCDATE(),
        CONSTRAINT FK_Ratings_Users FOREIGN KEY ([UserId]) REFERENCES [dbo].[Users]([Id]) ON DELETE CASCADE,
        CONSTRAINT FK_Ratings_Movies FOREIGN KEY ([MovieId]) REFERENCES [dbo].[Movies]([IdFilme]) ON DELETE CASCADE,
        CONSTRAINT UQ_Ratings_User_Movie UNIQUE ([UserId], [MovieId])
    );
    
    CREATE INDEX IX_Ratings_UserId ON [dbo].[Ratings]([UserId]);
    CREATE INDEX IX_Ratings_MovieId ON [dbo].[Ratings]([MovieId]);
END
GO

-- Tabela de Recomendações
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Recommendations]') AND type in (N'U'))
BEGIN
    CREATE TABLE [dbo].[Recommendations] (
        [Id] INT IDENTITY(1,1) PRIMARY KEY,
        [UserId] INT NOT NULL,
        [MovieId] INT NOT NULL,
        [Score] DECIMAL(18,2) NOT NULL,
        [CreatedAt] DATETIME2 NOT NULL DEFAULT GETUTCDATE(),
        CONSTRAINT FK_Recommendations_Users FOREIGN KEY ([UserId]) REFERENCES [dbo].[Users]([Id]) ON DELETE CASCADE,
        CONSTRAINT FK_Recommendations_Movies FOREIGN KEY ([MovieId]) REFERENCES [dbo].[Movies]([IdFilme]) ON DELETE CASCADE
    );
    
    CREATE INDEX IX_Recommendations_UserId ON [dbo].[Recommendations]([UserId]);
    CREATE INDEX IX_Recommendations_MovieId ON [dbo].[Recommendations]([MovieId]);
    CREATE INDEX IX_Recommendations_User_Created ON [dbo].[Recommendations]([UserId], [CreatedAt]);
END
GO

PRINT 'Tabelas criadas com sucesso!';
GO

