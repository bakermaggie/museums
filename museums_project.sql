SELECT *
FROM project.museums;
/*---------------------------------------------------------------------------------------*/
/*---Rename columns for ease of use------------------------------------------------------*/
/*---------------------------------------------------------------------------------------*/
ALTER TABLE museums
RENAME COLUMN `Museum ID` TO museum_ID;
ALTER TABLE museums
RENAME COLUMN `Museum Name` TO museum_name;
ALTER TABLE museums
RENAME COLUMN `Legal Name` TO legal_name;
ALTER TABLE museums
RENAME COLUMN `Alternate Name` TO alternate_name;
ALTER TABLE museums
RENAME COLUMN `Museum Type` TO museum_type;
ALTER TABLE museums
RENAME COLUMN `Institution Name` TO institution_name;
ALTER TABLE museums
RENAME COLUMN `Street Address (Administrative Location)` TO admin_address;
ALTER TABLE museums
RENAME COLUMN `City (Administrative Location)` TO admin_city;
ALTER TABLE museums
RENAME COLUMN `State (Administrative Location)` TO admin_state;
ALTER TABLE museums
RENAME COLUMN `Zip Code (Administrative Location)` TO admin_zip;
ALTER TABLE museums
RENAME COLUMN `Street Address (Physical Location)` TO physical_address;
ALTER TABLE museums
RENAME COLUMN `City (Physical Location)` TO physical_city;
ALTER TABLE museums
RENAME COLUMN `State (Physical Location)` TO physical_state;
ALTER TABLE museums
RENAME COLUMN `Zip Code (Physical Location)` TO physical_zip;
ALTER TABLE museums
RENAME COLUMN `Phone Number` TO phone_number;
ALTER TABLE museums
RENAME COLUMN `Income` TO income;
ALTER TABLE museums
RENAME COLUMN `Revenue` TO revenue;

ALTER TABLE state_populations
RENAME COLUMN `2018 Population` TO population;

/*---------------------------------------------------------------------------------------*/
/*---Top 5 states/districts with highest average revenue---------------------------------*/
/*---------------------------------------------------------------------------------------*/
SELECT
	COALESCE(NULLIF(physical_state, ''), admin_state) AS state, -- Clean state identifier of empty strings
    AVG(Revenue) AS avg_state_revenue
FROM project.museums
GROUP BY state
ORDER BY avg_state_revenue DESC
LIMIT 5;

/*---------------------------------------------------------------------------------------*/
/*---Top 5 states/districts with highest average expenses--------------------------------*/
/*---------------------------------------------------------------------------------------*/
SELECT
	COALESCE(NULLIF(physical_state, ''), admin_state) AS state, -- Clean state identifier of empty strings
    AVG(income-revenue) AS avg_state_expenses
FROM project.museums
GROUP BY state
ORDER BY avg_state_expenses DESC
LIMIT 5;

/*---------------------------------------------------------------------------------------*/
/*---Top 5 states/districts with highest expense to income ratio-------------------------*/
/*---------------------------------------------------------------------------------------*/
SELECT
	COALESCE(NULLIF(physical_state, ''), admin_state) AS state, -- Clean state identifier of empty strings
    AVG (income-revenue),
    AVG (income),
    AVG( (income-revenue)/income ) AS expense_ratio
FROM project.museums
GROUP BY state
ORDER BY expense_ratio DESC
LIMIT 5;

/*---------------------------------------------------------------------------------------*/
/*---Number of museums belonging to universities-----------------------------------------*/
/*---------------------------------------------------------------------------------------*/
SELECT COUNT(museum_ID)
FROM project.museums
WHERE museum_name LIKE '%university%'  OR institution_name LIKE '%university%';

/*---------------------------------------------------------------------------------------*/
/*---Add state abbreviation column to population table-----------------------------------*/
/*---------------------------------------------------------------------------------------*/    
ALTER TABLE state_populations
	ADD state_code VARCHAR (2) AS (CASE
	   WHEN State = 'Alabama' THEN 'AL' 
       WHEN State = 'Alaska' THEN 'AK'
       WHEN State = 'Arizona' THEN 'AZ'
       WHEN State = 'Arkansas' THEN 'AR'
       WHEN State = 'California' THEN 'CA'
       WHEN State = 'Colorado' THEN 'CO'
       WHEN State = 'Connecticut' THEN 'CT'
       WHEN State = 'District of Columbia' THEN 'DC'
       WHEN State = 'Delaware' THEN 'DE'
       WHEN State = 'Florida' THEN 'FL'
       WHEN State = 'Georgia' THEN 'GA'
       WHEN State = 'Hawaii' THEN 'HI'
       WHEN State = 'Idaho' THEN 'ID'
       WHEN State = 'Illinois' THEN 'IL'
       WHEN State = 'Indiana' THEN 'IN'
       WHEN State = 'Iowa' THEN 'IA'
       WHEN State = 'Kansas' THEN 'KS'
       WHEN State = 'Kentucky' THEN 'KY'
       WHEN State = 'Louisiana' THEN 'LA'
       WHEN State = 'Maine' THEN 'ME'
       WHEN State = 'Maryland' THEN 'MD'
       WHEN State = 'Massachusetts' THEN 'MA'
       WHEN State = 'Michigan' THEN 'MI'
	   WHEN State = 'Minnesota' THEN 'MN'
       WHEN State = 'Mississippi' THEN 'MS'
       WHEN State = 'Missouri' THEN 'MO'
	   WHEN State = 'Montana' THEN 'MT'
       WHEN State = 'Nebraska' THEN 'NE'
       WHEN State = 'Nevada' THEN 'NV'
	   WHEN State = 'New Hampshire' THEN 'NH'
       WHEN State = 'New Jersey' THEN 'NJ'
       WHEN State = 'New Mexico' THEN 'NM'
       WHEN State = 'New York' THEN 'NY'
	   WHEN State = 'North Carolina' THEN 'NC'
       WHEN State = 'North Dakota' THEN 'ND'
       WHEN State = 'Ohio' THEN 'OH'
       WHEN State = 'Oklahoma' THEN 'OK'
       WHEN State = 'Oregon' THEN 'OR'
       WHEN State = 'Pennsylvania' THEN 'PA'
       WHEN State = 'Rhode Island' THEN 'RI'
       WHEN State = 'South Carolina' THEN 'SC'
       WHEN State = 'South Dakota' THEN 'SD'
       WHEN State = 'Tennessee' THEN 'TN'
       WHEN State = 'Texas' THEN 'TX'
       WHEN State = 'Utah' THEN 'UT'
       WHEN State = 'Vermont' THEN 'VT'
       WHEN State = 'Virginia' THEN 'VA'
       WHEN State = 'Washington' THEN 'WA'
       WHEN State = 'West Virginia' THEN 'WV'
       WHEN State = 'Wisconsin' THEN 'WI'
       WHEN State = 'Wyoming' THEN 'WY'
       ELSE 'No State'
       END);

/*---------------------------------------------------------------------------------------*/
/*---Top 5 states by museum per 10,000 residents-----------------------------------------*/
/*---------------------------------------------------------------------------------------*/  
SELECT
    COALESCE(NULLIF(physical_state, ''), admin_state) AS state,
    COUNT(DISTINCT museums.museum_ID) AS num_museums,
    AVG(state_populations.population) AS population,
    COUNT(DISTINCT museums.museum_ID)/ (AVG(state_populations.population)/10000) AS per_capita
FROM museums
JOIN project.state_populations ON state_populations.state_code = COALESCE(NULLIF(physical_state, ''), admin_state)
GROUP BY COALESCE(NULLIF(physical_state, ''), admin_state)
ORDER BY per_capita DESC
LIMIT 5;

