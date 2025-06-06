-- Top 3 most frequently used container for each customer in the past year, alongside the usage frequency, type, average weight and usage classification

WITH CustomerContainerUsage AS (
    SELECT 
        c.customer_id,
        INITCAP(c.customer_name) AS customer,
        con.container_id,
        con.container_name,
        ct.container_type,
        COUNT(*) AS usage_count,
        ROUND(AVG(g.weight), 2) AS avg_weight,
        RANK() OVER (
            PARTITION BY c.customer_id
            ORDER BY COUNT(*) DESC
        ) AS usage_rank
    FROM booking b
    JOIN customer c ON b.customer_id = c.customer_id
    JOIN container con ON b.container_id = con.container_id
    JOIN container_type ct ON con.container_type_id = ct.container_type_id
    LEFT JOIN goods g ON con.container_id = g.container_id
    WHERE b.booking_date >= ADD_MONTHS(SYSDATE, -12)
    GROUP BY c.customer_id, c.customer_name, con.container_id, con.container_name, ct.container_type
)
SELECT 
    customer,
    container_id,
    container_name,
    container_type,
    usage_count,
    avg_weight,
    CASE 
        WHEN usage_count >= 10 THEN 'Heavy Use'
        WHEN usage_count BETWEEN 5 AND 9 THEN 'Moderate Use'
        ELSE 'Light Use'
    END AS usage_category
FROM CustomerContainerUsage
WHERE usage_rank <= 3
ORDER BY customer, usage_count DESC;