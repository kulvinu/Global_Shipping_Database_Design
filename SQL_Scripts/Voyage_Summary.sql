-- Voyage Summary

CREATE OR REPLACE VIEW v_voyage_summary AS
SELECT 
    v.voyage_id AS voyage_code,
    INITCAP(vs.vessel_name) AS vessel,
    rs.schedule_id AS schedule,
    INITCAP(r.route_name) AS route,
    v.actual_departure_date AS departed_on,
    v.actual_arrival_date AS arrived_on,
    CASE 
        WHEN v.actual_arrival_date IS NULL THEN 'In Progress'
        ELSE 'Completed'
    END AS voyage_status,
    COUNT(DISTINCT cm.container_id) AS containers_delivered
FROM voyage v
JOIN route_schedule rs ON v.schedule_id = rs.schedule_id
JOIN vessel vs ON v.vessel_id = vs.imo_no
JOIN route r ON rs.route_id = r.route_id
LEFT JOIN container_movement cm 
    ON v.voyage_id = cm.voyage_id AND cm.movement_type = 'Unloaded'
GROUP BY v.voyage_id, vs.vessel_name, rs.schedule_id, r.route_name, v.actual_departure_date, v.actual_arrival_date;