/******a Script for SelectTopNRows command from SSMS  ******/
SELECT TOP (1000) [UniqueID ]
      ,[ParcelID]
      ,[LandUse]
      ,[PropertyAddress]
      ,[SaleDate]
      ,[SalePrice]
      ,[LegalReference]
      ,[SoldAsVacant]
      ,[OwnerName]
      ,[OwnerAddress]
      ,[Acreage]
      ,[TaxDistrict]
      ,[LandValue]
      ,[BuildingValue]
      ,[TotalValue]
      N
--------------------------------------------------------------------------------------------------------------------------
SELECT *
FROM PortfolioProjectN..NashvilleHousing$



-- Standardize Date Format


SELECT SaleDate, CONVERT(Date, SaleDate)
FROM PortfolioProjectN..NashvilleHousing$


UPDATE NashvilleHousing$
SET SaleDate = CONVERT(Date, SaleDate)


ALTER TABLE NashvilleHousing$
ADD SaleDateConverted Date

UPDATE NashvilleHousing$
SET SaleDateconverted = CONVERT(Date, SaleDate)


----------------------------------------------------------------------------------------------
--Checking to view if the SaleDateConverted have updated


SELECT SaleDateconverted, CONVERT(Date, SaleDate)
FROM PortfolioProjectN..NashvilleHousing$



-----------------------------------------------------------------------------------------------

--BY Populating Property Address data


SELECT PropertyAddress
FROM PortfolioProjectN..NashvilleHousing$

SELECT *
FROM PortfolioProjectN..NashvilleHousing$
--WHERE PropertyAddress is NULL
ORDER BY ParcelID


--BY Joining the Address


SELECT a.ParcelID, a.PropertyAddress, b.ParcelID, b.PropertyAddress
FROM PortfolioProjectN..NashvilleHousing$ a
JOIN PortfolioProjectN..NashvilleHousing$ b
     ON a.ParcelID = b.ParcelID
	 AND a.[UniqueID ] <> b.[UniqueID ]
WHERE a.PropertyAddress is NULL
     

SELECT a.ParcelID, a.PropertyAddress, b.ParcelID, b.PropertyAddress, ISNULL(a.PropertyAddress, b.PropertyAddress)
FROM PortfolioProjectN..NashvilleHousing$ a
JOIN PortfolioProjectN..NashvilleHousing$ b
     ON a.ParcelID = b.ParcelID
	 AND a.[UniqueID ] <> b.[UniqueID ]
WHERE a.PropertyAddress is NULL


UPDATE a
SET PropertyAddress =  ISNULL(a.PropertyAddress, b.PropertyAddress)
FROM PortfolioProjectN..NashvilleHousing$ a
JOIN PortfolioProjectN..NashvilleHousing$ b
     ON a.ParcelID = b.ParcelID()
	 AND a.[UniqueID ] <> b.[UniqueID ]
WHERE a.PropertyAddress is NULL


-------------------------------------------------------------------------------------

--Breakingdown Address into individual columns(Address, City, State)

SELECT PropertyAddress
FROM PortfolioProjectN..NashvilleHousing$
--WHERE PropertyAddress is NULL

SELECT
SUBSTRING(PropertyAddress, 1,CHARINDEX(',', PropertyAddress)-1) AS Address
FROM PortfolioProjectN..NashvilleHousing$

SELECT
SUBSTRING(PropertyAddress, 1,CHARINDEX(',', PropertyAddress)-1) AS Address
,SUBSTRING(PropertyAddress, CHARINDEX(',', PropertyAddress)+1, LEN(PropertyAddress)) AS Address

FROM PortfolioProjectN..NashvilleHousing$


--Adding two more Columns


ALTER TABLE NashvilleHousing$
ADD PropertySplitAddress Nvarchar(255)

UPDATE NashvilleHousing$
SET PropertySplitAddress = SUBSTRING(PropertyAddress, 1,CHARINDEX(',', PropertyAddress)-1)

ALTER TABLE NashvilleHousing$
ADD PropertySplitCity Nvarchar(255)

UPDATE NashvilleHousing$
SET PropertySplitCity = SUBSTRING(PropertyAddress, CHARINDEX(',', PropertyAddress)+1, LEN(PropertyAddress))


--Rechecking the Additional Columns

SELECT *
FROM PortfolioProjectN..NashvilleHousing$


--Checking the Owners Address

SELECT OwnerAddress
FROM PortfolioProjectN..NashvilleHousing$


--BreakingDown Owners Address using ParseName Method


SELECT OwnerAddress
FROM PortfolioProjectN..NashvilleHousing$


SELECT
PARSENAME(REPLACE(OwnerAddress,',','.'), 1)
,PARSENAME(REPLACE(OwnerAddress,',','.'), 2)
,PARSENAME(REPLACE(OwnerAddress,',','.'), 3)
FROM PortfolioProjectN..NashvilleHousing$

SELECT
PARSENAME(REPLACE(OwnerAddress,',','.'), 3)
,PARSENAME(REPLACE(OwnerAddress,',','.'), 2)
,PARSENAME(REPLACE(OwnerAddress,',','.'), 1)
FROM PortfolioProjectN..NashvilleHousing$


--Updating Owners Address

ALTER TABLE NashvilleHousing$
ADD OwnerSplitAddress Nvarchar(255)

UPDATE NashvilleHousing$
SET OwnerSplitAddress = PARSENAME(REPLACE(OwnerAddress,',','.'), 3)

ALTER TABLE NashvilleHousing$
ADD OwnerSplitCity Nvarchar(255)

UPDATE NashvilleHousing$
SET OwnerSplitCity = PARSENAME(REPLACE(OwnerAddress,',','.'), 2)

ALTER TABLE NashvilleHousing$
ADD OwnerSplitState Nvarchar(255)

UPDATE NashvilleHousing$
SET OwnerSplitState = PARSENAME(REPLACE(OwnerAddress,',','.'), 1)


SELECT *
FROM PortfolioProjectN..NashvilleHousing$

--------------------------------------------------------------------------------------------------

--By Changing Y and N to Yes and No in "Sold as Vacant" field

SELECT DISTINCT( SoldAsVacant), COUNT(SoldAsVacant)
FROM PortfolioProjectN..NashvilleHousing$
GROUP BY SoldAsVacant


--By Using a Case statement


SELECT SoldAsVacant,
CASE WHEN SoldAsVacant = 'Y' THEN 'YES'
     WHEN SoldAsVacant = 'N' THEN 'NO'
	 ELSE SoldAsVacant
	 END
FROM PortfolioProjectN..NashvilleHousing$

UPDATE NashvilleHousing$
SET SoldAsVacant = CASE WHEN SoldAsVacant = 'Y' THEN 'YES'
     WHEN SoldAsVacant = 'N' THEN 'NO'
	 ELSE SoldAsVacant
	 END


--By Checking the Update on SoldAsVacant 

SELECT DISTINCT( SoldAsVacant), COUNT(SoldAsVacant)
FROM PortfolioProjectN..NashvilleHousing$
GROUP BY SoldAsVacant


-----------------------------------------------------------------------------------------------

--Removing Duplicate Columns

WITH RowNumCTE AS(
SELECT *,
	ROW_NUMBER() OVER (
	PARTITION BY ParcelID,
				 PropertyAddress,
				 SalePrice,
				 SaleDate,
				 LegalReference
				 ORDER BY
					UniqueID
					) row_num

FROM PortfolioProjectN..NashvilleHousing$
--ORDER BY ParcelID
)
SELECT *
FROM RowNumCTE
WHERE row_num > 1
--ORDER BY PropertyAddress


WITH RowNumCTE AS(
SELECT *,
	ROW_NUMBER() OVER (
	PARTITION BY ParcelID,
				 PropertyAddress,
				 SalePrice,
				 SaleDate,
				 LegalReference
				 ORDER BY
					UniqueID
					) row_num

FROM PortfolioProjectN..NashvilleHousing$
--ORDER BY ParcelID
)
SELECT* 
FROM RowNumCTE
WHERE row_num > 1
--ORDER BY PropertyAddress

-------------------------------------------------------------------------------------------------------
--By Delecting the Unused Columns


SELECT *
FROM PortfolioProjectN..NashvilleHousing$


ALTER TABLE PortfolioProjectN..NashvilleHousing$
DROP COLUMN OwnerAddress, TaxDistrict, PropertyAddress, SaleDate

