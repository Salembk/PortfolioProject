--Cleaning Data in SQL Queries

select *
from [dbo].[Nashville housing] ;

-- Standardize Date Format


Select saleDate, CONVERT(Date,SaleDate)
From [dbo].[Nashville housing]

Update [dbo].[Nashville housing]
SET SaleDate = CONVERT(Date,SaleDate)


--- If it doesn't Update properly

ALTER TABLE [dbo].[Nashville housing]
Add [SaleDate] Date;

Update [dbo].[Nashville housing]
SET [SaleDate] = CONVERT(Date,SaleDate)


-- Populate Property Address data

Select *
From [dbo].[Nashville housing]
--Where PropertyAddress is null
order by [ParcelID]



Select a.ParcelID, a.PropertyAddress, b.ParcelID, b.PropertyAddress, ISNULL(a.PropertyAddress,b.PropertyAddress)
From [dbo].[Nashville housing] a
JOIN -- Populate Property Address data

Select *
From PortfolioProject.dbo.NashvilleHousing
--Where PropertyAddress is null
order by ParcelID



Select a.ParcelID, a.PropertyAddress, b.ParcelID, b.PropertyAddress, ISNULL(a.PropertyAddress,b.PropertyAddress)
From PortfolioProject.dbo.NashvilleHousing a
JOIN PortfolioProject.dbo.NashvilleHousing b
	on a.ParcelID = b.ParcelID
	AND a.[UniqueID ] <> b.[UniqueID ]
Where a.PropertyAddress is null


Select a.ParcelID, a.PropertyAddress, b.ParcelID, b.PropertyAddress, ISNULL(a.PropertyAddress,b.PropertyAddress)
From [dbo].[Nashville housing]  a
JOIN [dbo].[Nashville housing]  b
	on a.ParcelID = b.ParcelID
	AND a.[UniqueID ] <> b.[UniqueID ]
Where a.PropertyAddress is null


Update a
SET PropertyAddress = ISNULL(a.PropertyAddress,b.PropertyAddress)
From [dbo].[Nashville housing] a
JOIN [dbo].[Nashville housing] b
	on a.ParcelID = b.ParcelID
	AND a.[UniqueID ] <> b.[UniqueID ]
Where a.PropertyAddress is null


-- Breaking out Address into Individual Columns (Address, City, State)


Select PropertyAddress
From [dbo].[Nashville housing]
--Where PropertyAddress is null
--order by ParcelID

SELECT
SUBSTRING(PropertyAddress, 1, CHARINDEX(',', PropertyAddress) -1 ) as Address
, SUBSTRING(PropertyAddress, CHARINDEX(',', PropertyAddress) + 1 , LEN(PropertyAddress)) as Address

From [dbo].[Nashville housing]


ALTER TABLE [dbo].[Nashville housing]
Add PropertySplitAddress Nvarchar(255);

Update [dbo].[Nashville housing]
SET PropertySplitAddress = SUBSTRING(PropertyAddress, 1, CHARINDEX(',', PropertyAddress) -1 )


ALTER TABLE [dbo].[Nashville housing]
Add PropertySplitCity Nvarchar(255);

Update [dbo].[Nashville housing]
SET PropertySplitCity = SUBSTRING(PropertyAddress, CHARINDEX(',', PropertyAddress) + 1 , LEN(PropertyAddress))


Select *
From [dbo].[Nashville housing]




Select OwnerAddress
From [dbo].[Nashville housing]


Select
PARSENAME(REPLACE(OwnerAddress, ',', '.') , 3)
,PARSENAME(REPLACE(OwnerAddress, ',', '.') , 2)
,PARSENAME(REPLACE(OwnerAddress, ',', '.') , 1)
From [dbo].[Nashville housing]



ALTER TABLE [dbo].[Nashville housing]
Add OwnerSplitAddress Nvarchar(255);

Update [dbo].[Nashville housing]
SET OwnerSplitAddress = PARSENAME(REPLACE(OwnerAddress, ',', '.') , 3)


ALTER TABLE [dbo].[Nashville housing]
Add OwnerSplitCity Nvarchar(255);

Update [dbo].[Nashville housing]
SET OwnerSplitCity = PARSENAME(REPLACE(OwnerAddress, ',', '.') , 2)



ALTER TABLE [dbo].[Nashville housing]
Add OwnerSplitState Nvarchar(255);

Update [dbo].[Nashville housing]
SET OwnerSplitState = PARSENAME(REPLACE(OwnerAddress, ',', '.') , 1)



Select *
From [dbo].[Nashville housing]



-- Change Y and N to Yes and No in "Sold as Vacant" field


Select Distinct(SoldAsVacant), Count(SoldAsVacant)
From [dbo].[Nashville housing]
Group by SoldAsVacant
order by 2




Select SoldAsVacant
, CASE When SoldAsVacant = 'Y' THEN 'Yes'
	   When SoldAsVacant = 'N' THEN 'No'
	   ELSE SoldAsVacant
	   END
From [dbo].[Nashville housing]


Update [dbo].[Nashville housing]
SET SoldAsVacant = CASE When SoldAsVacant = 'Y' THEN 'Yes'
	   When SoldAsVacant = 'N' THEN 'No'
	   ELSE SoldAsVacant
	   END






-----------------------------------------------------------------------------------------------------------------------------------------------------------

-- Remove Duplicates

WITH RowNumCTE AS (
Select *,
	ROW_NUMBER() OVER (
	PARTITION BY ParcelID,
				 PropertyAddress,
				 SalePrice,
				 SaleDate,
				 LegalReference
				 ORDER BY
					UniqueID
					) row_num
From [dbo].[Nashville housing]

--order by ParcelID



Select *
From RowNumCTE
Where row_num > 1
Order by PropertyAddress



Select *
From [dbo].[Nashville housing]




---------------------------------------------------------------------------------------------------------

-- Delete Unused Columns



Select *
From [dbo].[Nashville housing]


ALTER TABLE [dbo].[Nashville housing]
DROP COLUMN OwnerAddress, TaxDistrict, PropertyAddress, SaleDate











