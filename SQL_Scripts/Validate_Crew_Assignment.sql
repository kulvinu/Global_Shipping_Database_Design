-- Validating Crew Assignment

CREATE OR REPLACE TRIGGER trg_check_minimum_crew
BEFORE INSERT ON crew_assignment
FOR EACH ROW
DECLARE
    v_required NUMBER;
    v_existing NUMBER;
BEGIN
    SELECT vt.typical_crew_required INTO v_required
    FROM route_schedule rs
    JOIN vessel v ON rs.vessel_id = v.imo_no
    JOIN vessel_type vt ON v.vessel_type_id = vt.vessel_type_id
    WHERE rs.schedule_id = :NEW.schedule_id;

    SELECT COUNT(*) INTO v_existing
    FROM crew_assignment
    WHERE schedule_id = :NEW.schedule_id;

    IF v_existing >= v_required THEN
        RAISE_APPLICATION_ERROR(-20001, 'Cannot exceed typical crew requirement (' || v_required || ')');
    END IF;

    IF v_existing BETWEEN 0 AND v_required - 2 THEN
        DBMS_OUTPUT.PUT_LINE('Less than expected crew assigned.');
    END IF;
END;
/