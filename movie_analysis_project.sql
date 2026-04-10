/* Project: Multi-dimensional Profitability Analysis of Movie Data
Technical Stack: Multiple Joins, Correlated Subqueries, Aggregate Functions, Grouping Logic
Objective: Identify high-yield directors by calculating revenue efficiency per minute of screen time.
*/

SELECT 
    m.Director,
    COUNT(m.Id) AS Movie_Count,
    -- Calculate Average Revenue Efficiency (Domestic + International Sales / Duration)
    ROUND(AVG((b.Domestic_sales + b.International_sales) / m.Length_minutes), 2) AS Avg_Revenue_Efficiency
FROM Movies AS m
JOIN Boxoffice AS b ON m.Id = b.Movie_id
GROUP BY m.Director
-- Filter: Include directors with at least 2 films whose efficiency exceeds the global average
HAVING Movie_Count >= 2 
   AND Avg_Revenue_Efficiency > (
       -- Subquery: Calculate the global average efficiency across the entire database
       SELECT AVG((Domestic_sales + International_sales) / Length_minutes)
       FROM Movies
       JOIN Boxoffice ON Movies.Id = Boxoffice.Movie_id
   )
ORDER BY Avg_Revenue_Efficiency DESC;
