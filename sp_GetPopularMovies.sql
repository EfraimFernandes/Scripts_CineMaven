-- Stored Procedure para buscar filmes mais populares
-- Usado na seleção inicial de filmes durante o cadastro

CREATE OR ALTER PROCEDURE [dbo].[sp_GetPopularMovies]
    @Count INT = 10
AS
BEGIN
    SET NOCOUNT ON;
    
    SELECT TOP (@Count)
        IdFilme,
        Generos,
        Lingua,
        Titulo,
        Sinopse,
        Popularidade,
        PosterPath,
        DataLancamento,
        Duracao,
        VoteAverage,
        VoteCount
    FROM Movies
    WHERE Popularidade IS NOT NULL
    ORDER BY Popularidade DESC;
END
GO