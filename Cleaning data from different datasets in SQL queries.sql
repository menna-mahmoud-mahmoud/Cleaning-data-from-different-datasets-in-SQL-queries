/*

  Cleaning data from different datasets in SQL queries

*/







-- using the trim function to remove extra spaces in columns
-- LTRIM function to remove the leading space(before the value)
-- RTRIM function to remove the trailing space(after the value)



UPDATE austin_waste
SET  route_type = LTRIM(RTRIM(route_type))







-- Standardize Date Format
-- converting data types



ALTER TABLE cycle_hire
ADD start_date_modified Date;

UPDATE cycle_hire
SET start_date_modified = CAST(start_date AS DATE)



ALTER TABLE cycle_hire
ADD end_date_modified Date;

UPDATE cycle_hire
SET end_date_modified = CAST(end_date AS DATE)



ALTER TABLE cycle_hire
ADD end_time_modified Time;

UPDATE cycle_hire
SET end_time_modified = CAST(end_date AS time)







-- Breaking out address into individual columns (street_name, area)



ALTER TABLE cycle_stations
ADD street_name nvarchar(255);

UPDATE cycle_stations
SET street_name = SUBSTRING(name, 1, CHARINDEX(',', name)-1);



ALTER TABLE cycle_stations
ADD area nvarchar(255);

UPDATE cycle_stations
SET area = SUBSTRING(name, CHARINDEX(',', name)+ 1, LEN(name));





-- another way to break out address into individual columns



ALTER TABLE cycle_stations
ADD street_name nvarchar(255);

UPDATE cycle_stations
SET street_name = PARSENAME(REPLACE(name, ',', '.'), 2)



ALTER TABLE cycle_stations
ADD area nvarchar(255);

UPDATE cycle_stations
SET area = PARSENAME(REPLACE(name, ',', '.'), 1)







-- Populate null values according to other related values



SELECT * 
FROM sales_train
WHERE store_name = 'Thriftway'



UPDATE sales_train
SET city = 'La Porte City',
    county = 'BLACK HAWK'
WHERE store_name = 'Thriftway'







-- Change Y and N to Yes and No in "Sold as Vacant" field



SELECT Distinct(SoldAsVacant), COUNT(SoldAsVacant) as boolean_count
FROM nashville_housing 
GROUP BY SoldAsVacant
ORDER BY boolean_count



SELECT SoldAsVacant
, CASE WHEN SoldAsVacant = 'Y' THEN 'Yes'
	   WHEN SoldAsVacant = 'N' THEN 'No'
	   ELSE SoldAsVacant
	   END

FROM nashville_housing




UPDATE nashville_housing
SET SoldAsVacant = CASE WHEN SoldAsVacant = 'Y' THEN 'Yes'
	   WHEN SoldAsVacant = 'N' THEN 'No'
	   ELSE SoldAsVacant
	   END

SELECT * FROM nashville_housing







-- remove duplicate rows



WITH duplicate_rows AS(
SELECT *,
	ROW_NUMBER() OVER (
	 PARTITION BY load_id,
	             load_time
	 ORDER BY  load_time) as row_num

FROM austin_waste
)
DELETE
FROM duplicate_rows
WHERE row_num > 1







-- Delete empty unused columns that has only null values



ALTER TABLE cycle_hire
DROP COLUMN start_station_id, end_station_id, bike_model




