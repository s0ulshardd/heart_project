-- Q1 Общая статистика по датасету

SELECT 
    COUNT(*) AS total_patients,
    ROUND(AVG(age)::numeric, 1) AS avg_age,
    ROUND(AVG(chol)::numeric, 1) AS avg_chol,
    ROUND(AVG(trestbps)::numeric, 1) AS avg_bp,
    ROUND(AVG(thalach)::numeric, 1) AS avg_max_hr
FROM patients;

-- Q2 Больные vs здоровые

SELECT 
    disease,
    COUNT(*) AS count,
    ROUND(AVG(age)::numeric, 1) AS avg_age,
    ROUND(AVG(chol)::numeric, 1) AS avg_chol,
    ROUND(AVG(thalach)::numeric, 1) AS avg_thalach,
    ROUND(AVG(oldpeak)::numeric, 2) AS avg_oldpeak
FROM patients
GROUP BY disease
ORDER BY disease;

-- Q3 Заболеваемость по полу

SELECT 
    s.label AS sex,
    COUNT(*) AS total,
    SUM(p.disease) AS sick,
    ROUND(AVG(p.disease) * 100, 1) AS disease_percent
FROM patients p
JOIN sex_dict s ON p.sex = s.code
GROUP BY s.label
ORDER BY s.label;

-- Q4 Риск по возрастным группам

WITH age_groups AS (
    SELECT 
        *,
        CASE 
            WHEN age < 40 THEN '1. Under 40'
            WHEN age < 55 THEN '2. 40-54'
            WHEN age < 70 THEN '3. 55-69'
            ELSE '4. 70+'
        END AS age_group
    FROM patients
)
SELECT 
    age_group,
    COUNT(*) AS total,
    ROUND(AVG(disease) * 100, 1) AS disease_percent
FROM age_groups
GROUP BY age_group
ORDER BY age_group;

--Q5 Топ-10 по холестерину

SELECT 
    age, sex, chol, trestbps, disease,
    RANK() OVER (ORDER BY chol DESC) AS chol_rank
FROM patients
ORDER BY chol DESC
LIMIT 10;

--Q6 Заболеваемость по типу боли в груди

SELECT 
    c.label AS chest_pain,
    COUNT(*) AS total,
    ROUND(AVG(p.disease) * 100, 1) AS disease_percent
FROM patients p
JOIN cp_dict c ON p.cp = c.code
GROUP BY c.label
ORDER BY disease_percent DESC;

