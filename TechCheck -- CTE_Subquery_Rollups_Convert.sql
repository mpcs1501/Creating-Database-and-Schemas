use AdventureWorksDW;
go

exec sys.sp_changedbowner 'sa'

--================================================================
--1ST QUERY TECH CHECK============================================
--================================================================
select dt.CalendarYear as 'Year'
	  ,(convert(decimal(10,2),(sum(ft.Amount)/1000000))) as 'Amount in Mils'
from DimDate dt left outer join FactFinance ft
	on dt.DateKey = ft.DateKey
group by dt.CalendarYear
having dt.CalendarYear between 2010 and 2013
order by 1 asc
;

--================================================================
--2ND QUERY TECH CHECK============================================
--================================================================
select top 9 og.OrganizationName as 'Organization Name'
	  ,convert(decimal(10,2),(SUM(ft.Amount)/1000000)) as 'Amount in Mils'
		
from dbo.DimOrganization og left outer join dbo.FactFinance ft
	on og.OrganizationKey = ft.OrganizationKey
group by og.OrganizationName
order by SUM(ft.Amount) desc
;

--================================================================
--3RD QUERY TECH CHECK============================================
--================================================================
select top 2 sc.ScenarioName as 'Scenario Name'
	  ,convert(decimal(10,2),(SUM(ft.Amount)/1000000)) as 'Amount in Mils'
from dbo.DimScenario sc left outer join dbo.FactFinance ft
	on sc.ScenarioKey = ft.ScenarioKey
group by sc.ScenarioName
;

--================================================================
--4RD QUERY TECH CHECK============================================
--================================================================
select * 
from dbo.DimAccount ot left outer join dbo.FactFinance ft
	on ot.AccountKey = ft.AccountKey
;



--================================================================
--5TH QUERY TECH CHECK============================================
--================================================================

select count(*)
from dbo.DimEmployee; --296

select *
from dbo.DimSalesTerritory; --11

--________________________________________________________________
--SUBQUERY--------------------------------------------------------


select year(frs.OrderDate) as 'OrderYear'
	  ,sales.SalesTerritoryCountry as 'Country'
	  ,sales.id
	  ,sales.FirstName
	  ,sales.LastName
	  ,sales.Title
	  ,convert(decimal(10,2),sum(frs.SalesAmount)) as 'TotalSales'
from dbo.FactResellerSales frs left outer join 


		(select	 de.EmployeeKey as 'id'
				,de.SalesTerritoryKey
				,de.FirstName
				,de.LastName
				,de.Title
				,dst.SalesTerritoryRegion
				,dst.SalesTerritoryCountry
				,dst.SalesTerritoryGroup
				,'AllGroups' as 'Top'
				,de.SalesPersonFlag
				,de.[Status]
		from dbo.DimEmployee de left join dbo.DimSalesTerritory dst
			on de.SalesTerritoryKey = dst.SalesTerritoryKey
		) sales
		on frs.EmployeeKey = sales.id
group by year(frs.OrderDate)
		,sales.SalesTerritoryCountry ,sales.id
	  ,sales.FirstName
	  ,sales.LastName
	  ,sales.Title
order by Country ASC, OrderYear DESC

;

--__________________________________________________________
--CTE

DECLARE @mytable TABLE (
    Id int NOT NULL,
	SalesTerritoryKey int not null,
	FirstName nvarchar(40),
	LastName nvarchar(40),
	Title nvarchar(40),
    SalesTerritoryRegion nvarchar(40),
    SalesTerritoryCountry nvarchar(40),
	SalesTerritoryGroup nvarchar(40),
	[Top] nvarchar(40),
	SalesPersonalFlag int not null,
	[Status] nvarchar(40)
)
;


INSERT INTO @mytable     
		
		select	 de.EmployeeKey as 'id'
				,de.SalesTerritoryKey
				,de.FirstName
				,de.LastName
				,de.Title
				,dst.SalesTerritoryRegion
				,dst.SalesTerritoryCountry
				,dst.SalesTerritoryGroup
				,'AllGroups' as 'Top'
				,de.SalesPersonFlag
				,de.[Status]
		from dbo.DimEmployee de left join dbo.DimSalesTerritory dst
			on de.SalesTerritoryKey = dst.SalesTerritoryKey
;

--SELECT * from @mytable;

select year(frs.OrderDate) as 'OrderYear'
	  ,sales.SalesTerritoryCountry as 'Country'
--	  ,sales.id
--	  ,sales.FirstName
--	  ,sales.LastName
--	  ,sales.Title
	  ,convert(decimal(10,2),sum(frs.SalesAmount)) as 'TotalSales'
from dbo.FactResellerSales frs left outer join @mytable sales
		on frs.EmployeeKey = sales.id
group by year(frs.OrderDate)
		,sales.SalesTerritoryCountry ,sales.id
	  ,sales.FirstName
	  ,sales.LastName
	  ,sales.Title
order by Country ASC, OrderYear DESC

;
