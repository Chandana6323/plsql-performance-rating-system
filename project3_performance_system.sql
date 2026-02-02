CREATE TABLE employee_performance (
    emp_id        NUMBER,
    performance_score NUMBER,
    review_date   DATE
);


INSERT INTO employee_performance VALUES (1, 85, SYSDATE);
INSERT INTO employee_performance VALUES (2, 60, SYSDATE);
INSERT INTO employee_performance VALUES (3, 92, SYSDATE);
COMMIT;


CREATE OR REPLACE FUNCTION get_performance_rating (
    p_score NUMBER
)
RETURN VARCHAR2
IS
BEGIN
    IF p_score >= 85 THEN
        RETURN 'Excellent';
    ELSIF p_score >= 70 THEN
        RETURN 'Good';
    ELSE
        RETURN 'Needs Improvement';
    END IF;
END;
/


SELECT emp_id,
       performance_score,
       get_performance_rating(performance_score) AS rating
FROM employee_performance;


CREATE OR REPLACE PROCEDURE apply_bonus (
    p_emp_id NUMBER
)
AS
    v_score NUMBER;
    v_bonus NUMBER := 0;
BEGIN
    SELECT performance_score
    INTO v_score
    FROM employee_performance
    WHERE emp_id = p_emp_id;

    IF v_score >= 85 THEN
        v_bonus := 0.20;
    ELSIF v_score >= 70 THEN
        v_bonus := 0.10;
    ELSE
        v_bonus := 0;
    END IF;

    UPDATE employees
    SET salary = salary + (salary * v_bonus)
    WHERE emp_id = p_emp_id;

    COMMIT;
END;
/


BEGIN
    apply_bonus(1);
END;
/


SELECT emp_id, salary FROM employees WHERE emp_id = 1;
