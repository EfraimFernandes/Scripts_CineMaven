CREATE OR ALTER PROCEDURE [dbo].[sp_GetUserRecommendations]
    @UserId INT
AS
BEGIN
    SET NOCOUNT ON;
    
    -- Buscar a data da recomendação mais recente
    DECLARE @LatestDate DATETIME2;
    SELECT TOP 1 @LatestDate = CreatedAt
    FROM Recommendations
    WHERE UserId = @UserId
    ORDER BY CreatedAt DESC;
    
    -- Se não houver recomendações, retornar vazio
    IF @LatestDate IS NULL
        RETURN;
    
    -- Buscar os filmes recomendados ordenados por score
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
        r.Score
    FROM Recommendations r
    INNER JOIN Movies m ON r.MovieId = m.IdFilme
    WHERE r.UserId = @UserId 
        AND r.CreatedAt = @LatestDate
    ORDER BY r.Score DESC;
END
GO