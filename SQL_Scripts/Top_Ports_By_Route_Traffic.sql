-- Top Ports by Route Traffic

CREATE OR REPLACE PROCEDURE sp_top_ports_by_route_traffic IS
    CURSOR port_route_summary_cur IS
        SELECT 
            INITCAP(p.port_name) AS port,
            COUNT(DISTINCT rsa.route_id) AS total_routes,
            COUNT(DISTINCT cm.container_id) AS containers_handled,
            COUNT(cm.movement_id) AS total_movements,
            MIN(cm.timestamp) AS first_movement,
            MAX(cm.timestamp) AS last_movement
        FROM port p
        JOIN segment s ON p.port_id IN (s.dep_port, s.arrival_port)
        JOIN route_seg_assignment rsa ON rsa.segment_id = s.seg_id
        JOIN route r ON rsa.route_id = r.route_id
        LEFT JOIN container_movement cm ON cm.port_id = p.port_id
        GROUP BY p.port_name
        HAVING COUNT(DISTINCT rsa.route_id) > 1
        ORDER BY total_routes DESC, total_movements DESC;
BEGIN
    DBMS_OUTPUT.PUT_LINE('--- Top Ports by Route Coverage and Traffic ---');
    FOR rec IN port_route_summary_cur LOOP
        DBMS_OUTPUT.PUT_LINE('Port: ' || rec.port);
        DBMS_OUTPUT.PUT_LINE('  Routes Involved: ' || rec.total_routes);
        DBMS_OUTPUT.PUT_LINE('  Containers Handled: ' || rec.containers_handled);
        DBMS_OUTPUT.PUT_LINE('  Total Movements: ' || rec.total_movements);
        DBMS_OUTPUT.PUT_LINE('  First Movement: ' || rec.first_movement);
        DBMS_OUTPUT.PUT_LINE('  Last Movement: ' || rec.last_movement);
        DBMS_OUTPUT.PUT_LINE('----------------------------------------------');
    END LOOP;
END;
/