-- Procedure para buscar catálogo de filmes
CREATE OR ALTER PROCEDURE [dbo].[sp_GetMovieCatalog]
    @UserId INT = NULL
AS
BEGIN
    SET NOCOUNT ON;
    
    SELECT 
        m.IdFilme,
        m.Generos,
        m.Lingua,
        m.Titulo,
        m.Sinopse,
        m.Popularidade,
        m.PosterPath,
        m.DataLancamento,
        m.Duracao,
        m.VoteAverage,
        m.VoteCount,
        CASE 
            WHEN @UserId IS NOT NULL THEN r.Nota
            ELSE NULL
        END AS UserRating
    FROM Movies m
    LEFT JOIN Ratings r ON m.IdFilme = r.MovieId AND r.UserId = @UserId
    ORDER BY m.Popularidade DESC;
END
GO