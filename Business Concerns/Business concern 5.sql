

-- Time irregularity and potential time theft analysis
SELECT 
    CONCAT(s.First_Name, ' ', s.Last_Name) AS Staff_Name,
    s.Role,
    o.Outlet_Name,
    sh.Shift_Date,
    sh.Start_Time AS Scheduled_Start,
    sh.End_Time AS Scheduled_End,
    TIME(ss.Check_In_Time) AS Actual_Check_In,
    TIME(ss.Check_Out_Time) AS Actual_Check_Out,
    -- Calculate time discrepancies
    ROUND(TIME_TO_SEC(TIMEDIFF(TIME(ss.Check_In_Time), sh.Start_Time)) / 60.0, 1) AS Minutes_Late,
    ROUND(TIME_TO_SEC(TIMEDIFF(sh.End_Time, TIME(ss.Check_Out_Time))) / 60.0, 1) AS Minutes_Early_Leave,
    ss.Hours_Worked,
    ROUND(TIME_TO_SEC(TIMEDIFF(sh.End_Time, sh.Start_Time)) / 3600.0, 2) AS Scheduled_Hours,
    ROUND(ss.Hours_Worked - TIME_TO_SEC(TIMEDIFF(sh.End_Time, sh.Start_Time)) / 3600.0, 2) AS Hours_Variance,
    ROUND((ss.Hours_Worked - TIME_TO_SEC(TIMEDIFF(sh.End_Time, sh.Start_Time)) / 3600.0) * s.Hourly_Rate, 2) AS Wage_Impact,
    CASE 
        WHEN TIME_TO_SEC(TIMEDIFF(TIME(ss.Check_In_Time), sh.Start_Time)) > 300 THEN 'CHRONIC LATENESS'
        WHEN TIME_TO_SEC(TIMEDIFF(sh.End_Time, TIME(ss.Check_Out_Time))) > 300 THEN 'EARLY DEPARTURE'
        WHEN ss.Hours_Worked > TIME_TO_SEC(TIMEDIFF(sh.End_Time, sh.Start_Time)) / 3600.0 + 0.5 THEN 'OVERTIME CONCERN'
        ELSE 'NORMAL'
    END AS Time_Flag
FROM STAFF_SHIFT ss
JOIN STAFF s ON ss.Staff_ID = s.Staff_ID
JOIN SHIFT sh ON ss.Shift_ID = sh.Shift_ID
JOIN OUTLET o ON s.Home_Outlet_ID = o.Outlet_ID
WHERE ss.Check_In_Time IS NOT NULL AND ss.Check_Out_Time IS NOT NULL
HAVING Time_Flag != 'NORMAL'
ORDER BY ABS(Wage_Impact) DESC;