-- lists all tables in SQL Server
SELECT so.name FROM sysobjects so WHERE so.xtype = 'U' ORDER BY so.name 

-- list of all SQL Server tables using schema tables
select TABLE_NAME AS TableName 
from {0}.information_schema.tables
where TABLE_TYPE = 'BASE TABLE'
and TABLE_SCHEMA = 'dbo' 
order by TABLE_NAME 

-- lists column definitions for the given database/table and primary/foreign key information in SQL Server
select c.COLUMN_NAME AS ColumnName
	, c.DATA_TYPE as DataType 
	, CASE WHEN c.DATA_TYPE IN ( 'varchar', 'char' )
		THEN c.CHARACTER_MAXIMUM_LENGTH 
		ELSE c.NUMERIC_PRECISION 
		END as Length
	, c.NUMERIC_SCALE AS Decimals
	, c.IS_NULLABLE AS Nullable
	, c.ORDINAL_POSITION AS Position
	, MAX( CASE WHEN uk.CONSTRAINT_TYPE = 'PRIMARY KEY'
			THEN 1 ELSE 0 END 
		) AS PrimaryKey 
	, ( CASE WHEN columnproperty(object_id(c.TABLE_NAME), c.COLUMN_NAME, 'IsIdentity') = 1 
		THEN 1 ELSE 0 END
		) AS IsIdentity 
	, MAX( ur.TABLE_NAME ) AS ForeignKeyTable 
	, MAX( ur.COLUMN_NAME ) AS ForeignKey 
from {0}.information_schema.columns AS c 
	LEFT OUTER JOIN ( 
		SELECT k.TABLE_NAME, u.COLUMN_NAME, k.CONSTRAINT_TYPE, u.CONSTRAINT_NAME 
		FROM {0}.information_schema.TABLE_CONSTRAINTS AS k 
			, {0}.information_schema.CONSTRAINT_COLUMN_USAGE AS u 
		WHERE k.CONSTRAINT_NAME = u.CONSTRAINT_NAME 
			AND k.CONSTRAINT_TYPE IN ( 'FOREIGN KEY', 'PRIMARY KEY' )
	) AS uk 
		ON uk.TABLE_NAME = c.TABLE_NAME 
		AND uk.COLUMN_NAME = c.COLUMN_NAME 
	LEFT OUTER JOIN ( 
		SELECT u2.TABLE_NAME, u2.COLUMN_NAME, r.CONSTRAINT_NAME 
		FROM {0}.information_schema.REFERENTIAL_CONSTRAINTS AS r 
			, {0}.information_schema.CONSTRAINT_COLUMN_USAGE AS u2 
		WHERE r.UNIQUE_CONSTRAINT_NAME = u2.CONSTRAINT_NAME 
	) AS ur 
		ON uk.CONSTRAINT_NAME = ur.CONSTRAINT_NAME 
where c.TABLE_NAME = '{1}' 
group by c.TABLE_NAME 
	, c.COLUMN_NAME
	, c.DATA_TYPE
	, CASE WHEN c.DATA_TYPE IN ( 'varchar', 'char' )
		THEN c.CHARACTER_MAXIMUM_LENGTH 
		ELSE c.NUMERIC_PRECISION 
		END
	, c.NUMERIC_SCALE
	, c.IS_NULLABLE
	, c.ORDINAL_POSITION
ORDER BY c.ORDINAL_POSITION 


-- Oracle Schemas
select username as SCHEMA
from all_users
order by username

-- Oracle tables
select owner || '/' || table_name as FULL_TABLE_NAME 
from all_tables 
where owner = '{0}'
order by owner, table_name

-- Oracle Columns detailed
select column_name || ' (' || data_type || ' ' || data_length || ')' AS FULL_COLUMN_INFO 
from all_tab_columns tbl 
where owner = '{0}' and table_name = '{1}'

-- Oracle Columns
SELECT * FROM ALL_TAB_COLUMNS where COLUMN_NAME like '%%'

-- Oracle Element Types
SELECT ELEMENT_NAME, REPORTING_NAME, DESCRIPTION, ELEMENT_TYPE_ID, * FROM HR.PAY_ELEMENT_TYPES_F WHERE ELEMENT_NAME LIKE '% *type your element here* %' 

-- Oracle Cost Segments
SELECT * FROM EMSC.EMSC_PAY_EMCOMP_COST_SEGMENTS 

-- Oracle Assignments
SELECT * FROM HR.PER_ALL_ASSIGNMENTS_F 

-- Oracle People
SELECT * FROM HR.PER_ALL_PEOPLE_F 

-- Oracle Input Values
SELECT piv.ELEMENT_TYPE_ID 
, pet.ELEMENT_NAME
, piv.DISPLAY_SEQUENCE 
, piv.NAME 
, piv.UOM 
, piv.LOOKUP_TYPE
, piv.GENERATE_DB_ITEMS_FLAG
, piv.MANDATORY_FLAG
, piv.DEFAULT_VALUE
FROM APPS.PAY_INPUT_VALUES_F piv
, HR.PAY_ELEMENT_TYPES_F pet
WHERE piv.ELEMENT_TYPE_ID = pet.ELEMENT_TYPE_ID
AND pet.ELEMENT_NAME = '*type your element here*'
ORDER BY piv.DISPLAY_SEQUENCE"});
			objDT.Rows.Add(new object[] { "All Assignments", @"SELECT DISTINCT 
	papf.NATIONAL_IDENTIFIER,
	paaf.ASSIGNMENT_NUMBER,
	paaf.EFFECTIVE_START_DATE,
	paaf.EFFECTIVE_END_DATE,
	paaf.PRIMARY_FLAG,
	apps.hr_person_type_usage_info.get_user_person_type(paaf.EFFECTIVE_START_DATE, papf.PERSON_ID) PERSON_TYPE,
	RTRIM(hla.DESCRIPTION) || ' (' || hla.ATTRIBUTE1 || ')' AS LOCATION,
	hla.ATTRIBUTE1 AS FACILITY_CD,
	papayf.PAYROLL_NAME ,
	pj.NAME AS JOB_NAME ,
	NVL(papf.KNOWN_AS, papf.FULL_NAME) AS PERSON_NAME
FROM   HR.PER_ALL_ASSIGNMENTS_F paaf,
	HR.PER_ALL_PEOPLE_F papf,
	HR.HR_LOCATIONS_ALL hla,
	HR.PAY_ALL_PAYROLLS_F papayf,
	HR.PER_JOBS pj
WHERE  papf.PERSON_ID = paaf.PERSON_ID
AND  paaf.LOCATION_ID = hla.LOCATION_ID
AND  paaf.PAYROLL_ID = papayf.PAYROLL_ID
AND  paaf.JOB_ID = pj.JOB_ID
AND  REPLACE(papf.NATIONAL_IDENTIFIER, '-', '') IN ('** @NationalID **', '** @FEIN **')
ORDER BY paaf.EFFECTIVE_START_DATE"});
