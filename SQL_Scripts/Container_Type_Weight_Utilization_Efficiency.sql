-- Weight Utilization Efficiency in Different Container Types

SELECT 
    ct.container_type_id,
    ct.container_type,
    ROUND(AVG(g.weight), 2) AS avg_goods_weight_kg,
    ct.weight AS container_max_weight_kg,
    COUNT(g.goods_id) AS total_goods_entries,
    COUNT(DISTINCT c.container_id) AS distinct_containers_used,
    ROUND((AVG(g.weight) / ct.weight) * 100, 2) AS avg_utilization_percent,
    CASE 
        WHEN (AVG(g.weight) / ct.weight) * 100 > 100 THEN 'Overloaded'
        WHEN (AVG(g.weight) / ct.weight) * 100 BETWEEN 80 AND 100 THEN 'Efficient'
        ELSE 'Underutilized'
    END AS usage_status
FROM goods g
JOIN container c ON g.container_id = c.container_id
JOIN container_type ct ON c.container_type_id = ct.container_type_id
GROUP BY ct.container_type_id, ct.container_type, ct.weight
ORDER BY avg_utilization_percent DESC;