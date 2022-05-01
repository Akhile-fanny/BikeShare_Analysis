USE portfolio

---CREATING TEMPORARY TABLE TO HOUSE ALL THE 4 QUARTERS DATA
CREATE TABLE #Temp_Divvy_Trips_2019( trip_id FLOAT, 
									start_time DATETIME,
									end_time DATETIME,
									bikeid FLOAT,
									tripduration FLOAT,
									from_station_id FLOAT, 
									from_station_name NVARCHAR(255),
									to_station_id FLOAT,
									to_station_name NVARCHAR (255),
									usertype NVARCHAR(255), 
									gender NVARCHAR(255), 
									birthyear FLOAT)


--INSERTING DATA INTO THE TEMP TABLE
INSERT INTO #Temp_Divvy_Trips_2019
SELECT * FROM Divvy_Trips_2019_Q1
	UNION
	SELECT * FROM Divvy_Trips_2019_Q2
	UNION
	SELECT *  FROM Divvy_Trips_2019_Q3
	UNION
	SELECT * FROM Divvy_Trips_2019_Q4



	



SELECT TOP 2 * FROM #Temp_Divvy_Trips_2019






	--- MONTHS BY MONTHLY USERS
	SELECT DISTINCT( DATENAME(Month, start_time)) AS MONTH, COUNT(DATENAME(Month, start_time))
		OVER( PARTITION BY DATENAME(Month, start_time)) AS Monthly_users
	FROM #Temp_Divvy_Trips_2019
	WHERE start_time < end_time
	ORDER BY Monthly_users DESC

















	-- WHO ARE THE USER TYPE
	SELECT  DISTINCT usertype
	FROM #Temp_Divvy_Trips_2019


	
	--HOW MANY CUSTOMERS RIDE ON A MONTHLY BASIS?
	SELECT DISTINCT( DATENAME(Month, start_time)) AS MONTH,
					COUNT(DATENAME(Month, start_time))
					OVER( PARTITION BY DATENAME(Month, start_time)) AS Monthly_Customer
	FROM #Temp_Divvy_Trips_2019
	WHERE start_time < end_time AND usertype = 'customer'
	ORDER BY Monthly_Customer DESC





	--HOW MANY CUSTOMERS RIDE ON A MONTHLY BASIS?
	SELECT DISTINCT( DATENAME(Month, start_time)) AS MONTH, COUNT(DATENAME(Month, start_time))
		OVER( PARTITION BY DATENAME(Month, start_time)) AS Monthly_Subscriber
	FROM #Temp_Divvy_Trips_2019
	WHERE start_time < end_time AND usertype = 'subscriber'
	ORDER BY Monthly_Subscriber DESC







	--TOTAL BIKE USERS IN 2019
	SELECT COUNT(trip_id) AS Total_bike_users
	FROM #Temp_Divvy_Trips_2019

	
	
	
	-- TOTAL CUSTOMERS
SELECT COUNT(trip_id) AS TotalCustomers
	FROM #Temp_Divvy_Trips_2019
	WHERE usertype = 'customer'






-- TOTAL SUBSCRIBERS
SELECT COUNT(trip_id) AS TotalSubscriber
	FROM #Temp_Divvy_Trips_2019
	WHERE usertype = 'subscriber'


	   --- AVERAGE TRIP DURATION IN MINUTES
   	SELECT ROUND(AVG(tripduration/ 60), 0) AS Average_trip_duration
	FROM #Temp_Divvy_Trips_2019


	   -- count of gender 
SELECT Gender, count(gender)  AS Total_of_gender
FROM #Temp_Divvy_Trips_2019
WHERE gender IS NOT NULL
GROUP BY gender

 --USERTYPE BY AVERAGE RIDE DURATION IN MINUTES
SELECT   usertype, ROUND(AVG (tripduration)/ 60,0) AS Average_trip_duration
FROM #Temp_Divvy_Trips_2019
   GROUP BY usertype
   ORDER BY Average_trip_duration DESC



   ---TEMP TABLE
   CREATE TABLE #Temp_weeklyRide( usertype NVARCHAR (255),
									Weekday VARCHAR(20)) 


    --weekly ride
	INSERT INTO #Temp_weeklyRide
 SELECT  usertype, DATENAME(WEEKDAY, start_TIME) AS Weekday
 FROM #Temp_Divvy_Trips_2019



 SELECT * FROM #Temp_weeklyRide

 ---WEEKLY RIDE BY WEEKDAY
 SELECT weekday, count(weekday) AS WeeklyRide
 FROM #Temp_weeklyRide
 GROUP BY  weekday
 ORDER BY WeeklyRide DESC

 -----HOW MANY CUSTOMER RIDE DURING THE WEEK?
  SELECT weekday,
		count(weekday) AS CustomerWeeklyRide
 FROM #Temp_weeklyRide
  WHERE usertype = 'customer'
 GROUP BY  weekday
 ORDER BY CustomerWeeklyRide DESC


 ---HOW MANY SUBSCRIBERS RIDE DURING THE WEEK?
   SELECT weekday, 
   count(weekday) AS SubscriberWeeklyRide
 FROM #Temp_weeklyRide
  WHERE usertype = 'subscriber'
 GROUP BY  weekday
 ORDER BY SubscriberWeeklyRide DESC


  	---Minimum ride duration by usertype
	SELECT Usertype,  MIN(CAST(end_time - start_time AS time)) AS Min_Ride_duration
   FROM #Temp_Divvy_Trips_2019
   WHERE start_time < end_time
   GROUP BY usertype

   ----- CONFIRMATION
  -- SELECT  CAST(end_time - start_time AS TIME)  AS Ride_duration,usertype,
  -- end_time, start_time 
  -- FROM #Temp_Divvy_Trips_2019
  -- WHERE start_time < end_time
  --ORDER BY Ride_duration
    
   
   --SELECT end_time, start_time, CAST(end_time - start_time AS TIME)  AS Ride_duration
   --FROM  #Temp_Divvy_Trips_2019
			--WHERE start_time > end_time
  














    	---MAXIMUM RIDE DURATION BY USERTRYPE
	SELECT Usertype,  MAX (CAST(end_time - start_time AS TIME)) AS Max_Ride_duration
   FROM #Temp_Divvy_Trips_2019
   WHERE start_time < end_time
   GROUP BY usertype
   ORDER BY Max_Ride_duration DESC




   ---USER RIDE DURATION 
   --SELECT usertype, CAST(end_time - start_time AS TIME) AS ride_duration
   --FROM #Temp_Divvy_Trips_2019
   --ORDER BY ride_duration DESC

   ---USER RIDE DURATION 
   SELECT usertype,CAST(end_time - start_time AS TIME) AS ride_duration
   FROM #Temp_Divvy_Trips_2019
    WHERE start_time < end_time
   ORDER BY ride_duration DESC


   -- SELECT usertype,CAST(end_time - start_time AS nvarchar (255)) AS ride_duration
   --FROM #Temp_Divvy_Trips_2019
   --ORDER BY ride_duration DESC


   --SELECT DATENAME(YEAR, start_time) - birthyear AS Age
   --FROM #Temp_Divvy_Trips_2019

 ---CREATING A TEMP TABLE
 
 CREATE TABLE #Temp_AgeOfRider ( usertype NVARCHAR(255), Age float, Ride_duration TIME)

 INSERT INTO #Temp_AgeOfRider
 SELECT  usertype, 
		DATENAME(YEAR, start_time) - birthyear AS Age,
		CAST(end_time - start_time AS TIME) AS ride_duration
		FROM #Temp_Divvy_Trips_2019
	 WHERE birthyear >= 1939 AND birthyear IS NOT NULL AND birthyear <> 2014 AND start_time < end_time
	 ORDER BY Age





	 -- USERTYPE BY AGE RANGE
   SELECT  usertype, age,
   CASE WHEN age <= 20 THEN '16-20'
		WHEN age <= 30 THEN '21-30'
		WHEN age <= 40 THEN '31-40'
		WHEN age <= 50 THEN '41-50'
		WHEN age <= 60 THEN '51-60'
		WHEN age <= 70 THEN '61-70'
		WHEN age <= 80 THEN '71-80'
		ELSE 'Above 80'
		END AS Age_Range
   FROM #Temp_AgeOfRider


   --	AGE BY TRIP DURATION
   SELECT temp.age Age, ROUND(divvy.tripduration / 60,0) AS TripDuration 
   FROM #Temp_AgeOfRider AS temp JOIN #Temp_Divvy_Trips_2019 AS Divvy ON temp.usertype = divvy.usertype

   --- WHAT IS THE AVEGERAGE AGEOF THE USER TYPE
SELECT usertype, ROUND(AVG(Age), 0) AS Average_Age
 FROM #Temp_AgeOfRider
GROUP BY usertype


   
   --- USERTYPE BY  MAX RIDE DURATION AND MAX  AGE  DURATION
  SELECT usertype, MAX(age)  AS Max_age ,
			MAX(ride_duration)AS Max_ride_duration,MIN(age)  AS Min_age , MIN(ride_duration)AS Min_ride_duration
   FROM #Temp_AgeOfRider
  GROUP BY usertype

  -------months by avg trip duration
  SELECT  DATENAME(MONTH, start_time) AS Months, ROUND(AVG(tripduration) / 60,0) AS Avg_trip_duration
   FROM #Temp_Divvy_Trips_2019
  GROUP BY   DATENAME(MONTH, start_time)
   ORDER BY  CASE WHEN DATENAME(MONTH, start_time) = 'January' THEN 1
					WHEN DATENAME(MONTH, start_time) = 'February' THEN 2
					WHEN DATENAME(MONTH, start_time) = 'March' THEN 3
					WHEN DATENAME(MONTH, start_time) = 'April' THEN 4
					WHEN DATENAME(MONTH, start_time) = 'May' THEN 5
					WHEN DATENAME(MONTH, start_time) = 'June' THEN 6
					WHEN DATENAME(MONTH, start_time) = 'July' THEN 7
					WHEN DATENAME(MONTH, start_time) = 'August' THEN 8
					WHEN DATENAME(MONTH, start_time) = 'September' THEN 9
					WHEN DATENAME(MONTH, start_time) = 'October' THEN 10
					WHEN DATENAME(MONTH, start_time) = 'November' THEN 11
					WHEN DATENAME(MONTH, start_time) = 'December' THEN 12
					ELSE NULL END 






--- WHAT IS THE MONTHLY AVERAGE TRIP DURATION OF CUSTOMER IN MINUTES?
    SELECT  DATENAME(MONTH, start_time) AS Months, 
			ROUND(AVG(tripduration) / 60,0) AS CustomerAvg_trip_duration
   FROM #Temp_Divvy_Trips_2019
   WHERE usertype ='customer'
   GROUP BY   DATENAME(MONTH, start_time)
   ORDER BY CustomerAvg_trip_duration DESC   


   ---  WHAT IS THE MONTHLY AVERAGE TRIP DURATION OF SUBSCRIBER IN MINUTES?
SELECT  DATENAME(MONTH, start_time) AS Months,
		ROUND(AVG(tripduration) / 60,0) AS subscriberAvg_trip_duration
   FROM #Temp_Divvy_Trips_2019
   WHERE usertype ='subscriber'
   GROUP BY   DATENAME(MONTH, start_time)
   ORDER BY subscriberAvg_trip_duration DESC 









   --CREATING A TEMP TABLE FOR  WEEKDAY

--CREATE TABLE #Temp_week( Day_of_the_week varchar(10), Total_sales float, week_no int)
--INSERT INTO #Temp_week 
--SELECT  DISTINCT DATENAME(WEEKDAY, date) AS Day_of_the_week, Total_sales,
--				CASE WHEN DATENAME(WEEKDAY, date) = 'Monday' THEN 1
--						WHEN DATENAME(WEEKDAY, date) = 'Tuesday' THEN 2
--						WHEN DATENAME(WEEKDAY, date) = 'wednesday' THEN 3
--						WHEN DATENAME(WEEKDAY, date) = 'thursday' THEN 4
--						WHEN DATENAME(WEEKDAY, date) = 'friday' THEN 5
--						WHEN DATENAME(WEEKDAY, date) = 'saturday' THEN 6
--						WHEN DATENAME(WEEKDAY, date) = 'sunday' THEN 7
--						ELSE NULL END AS WEEK_no 		
--FROM TEMP_Transaction 
--GROUP BY DATENAME(WEEKDAY, date),Total_sales