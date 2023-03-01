-- QUESTION 1
select distinct(category) as distinctCategories
from greenhouse_gas_inventory_data_data;

-- QUESTION 2
select sum(value) as sumTotal
from greenhouse_gas_inventory_data_data
where year between 2010 and 2014
and country_or_area = "European Union"
and category not in ("greenhouse_gas_ghgs_emissions_including_indirect_co2_without_lulucf_in_kilotonne_co2_equivalent", "greenhouse_gas_ghgs_emissions_without_land_use_land_use_change_and_forestry_lulucf_in_kilotonne_co2_equivalent");

-- QUESTION 3
select  year, category, value
from greenhouse_gas_inventory_data_data
where value > 530000
and country_or_area="Australia";

-- QUESTION 4  Have to check which join to use
SELECT s.year as Year, avg(Extent) as avg_extent, max(extent) as max_extent, min(extent) as min_extent, sum(value) as total_emission  FROM seaice as s
left join greenhouse_gas_inventory_data_data as g
on s.year = g.year
where s.year between 2010 and 2014
group by s.year;


-- Question 5
select CAST((substring(recordedDate, 1,4)) as double) as year, round(avg(LandAverageTemperature), 3) as avgLandTemperature, round(min(LandAverageTemperature), 3) as minLandTemperature, round(max(LandAverageTemperature),3) as maxLandTemperature
from globaltemperatures
left join (
		select *, avg(extent)
		from seaice
		where year between 2010 and 2014
		group by year
) as t2
on CAST((substring(recordedDate, 1,4)) as double) = t2.year
where CAST((substring(recordedDate, 1,4)) as double) between 2010 and 2014
group by CAST((substring(recordedDate, 1,4)) as double);

-- QUESTION 6

create view australia_temp_change as
select *, avg(Value) as avgTempChange, min(Value) as minTempChange, max(Value) as MaxTempChange
from temperaturechangebycountry
where area = "Australia"
and year between 2010 and 2014
and months not like "%-%"
group by year;

create view australia_emissions as 
select *, sum(value) as totalEmissions
from greenhouse_gas_inventory_data_data
where country_or_area = "Australia"
and category not in ("greenhouse_gas_ghgs_emissions_including_indirect_co2_without_lulucf_in_kilotonne_co2_equivalent", "greenhouse_gas_ghgs_emissions_without_land_use_land_use_change_and_forestry_lulucf_in_kilotonne_co2_equivalent")
and year between 2010 and 2014
group by year;

select * from australia_temp_change
join australia_emissions
on australia_temp_change.year = australia_emissions.year;

-- QUESTION 7
select name,  investigator, count(SURVEY_DATE) as surveyedAmt
from mass_balance_data
group by (concat(name, investigator))
having count(*) > 11
order by NAME asc;

-- QUESTION 8
CREATE VIEW asean as 
select * 
from temperaturechangebycountry
where area in ('Brunei Darussalam','Cambodia','Indonesia', "Lao People's Democratic Republic",'Malaysia','Myanmar','Philippines','Singapore','Thailand','Viet Nam');

select area, year, avg(value) as avgValueChange 
from asean
where year between 2010 and 2014
group by area;


-- QUESTION 9
CREATE VIEW  AVERAGE_T as
select country_or_area, avg(value) as avgValue
from greenhouse_gas_inventory_data_data
group by country_or_area;

select *
from greenhouse_gas_inventory_data_data as gdd
left outer join AVERAGE_T as tdd
on gdd.country_or_area = tdd.country_or_area
where value < tdd.avgValue;



-- question 10
select * from temperaturechangebycountry;


