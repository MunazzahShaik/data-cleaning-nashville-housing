--CLEANING DATA IN SQL QUERIES
SELECT * FROM MyProjectPortfolio..NashvilleHousing 

--Converting Datetime format to Date
SELECT SaleDate, convert(date,saledate) as SalesDate from MyProjectPortfolio..NashvilleHousing

ALTER TABLE NashvilleHousing
Add SalesDateConverted Date;

UPDATE NashvilleHousing
SET SalesDateConverted = convert(date,saledate)

--Populating PropertyAddressData for null values
UPDATE NashvilleHousing
SET PropertyAddress= null
where [UniqueID ]= 14670;

Select a.ParcelID, a.PropertyAddress, b.ParcelID, b.PropertyAddress,ISNULL(a.PropertyAddress,b.PropertyAddress)
From MyProjectPortfolio..NashvilleHousing a
JOIN MyProjectPortfolio..NashvilleHousing b
	on a.ParcelID = b.ParcelID
	AND a.[UniqueID ] <> b.[UniqueID ]
Where a.PropertyAddress is null

Update a
SET PropertyAddress = ISNULL(a.PropertyAddress,b.PropertyAddress)
From MyProjectPortfolio..NashvilleHousing a
JOIN MyProjectPortfolio..NashvilleHousing b
	on a.ParcelID = b.ParcelID
	AND a.[UniqueID ] <> b.[UniqueID ]
Where a.PropertyAddress is null



--Breaking down the Address into Individual Columns (State,City,etc)

Select OwnerAddress from MyProjectPortfolio..NashvilleHousing

Select
PARSENAME(REPLACE(OwnerAddress, ',','.'),3) 
,PARSENAME(REPLACE(OwnerAddress, ',','.'),2) 
,PARSENAME(REPLACE(OwnerAddress, ',','.'),1) 
from MyProjectPortfolio..NashvilleHousing

ALTER TABLE NashvilleHousing
Add OwnerAddressSplit nvarchar(255);
UPDATE NashvilleHousing
SET OwnerAddressSplit = PARSENAME(REPLACE(OwnerAddress, ',','.'),3) 

ALTER TABLE NashvilleHousing
Add OwnerCity nvarchar(255);
UPDATE NashvilleHousing
SET OwnerCity = PARSENAME(REPLACE(OwnerAddress, ',','.'),2) 

ALTER TABLE NashvilleHousing
Add OwnerState nvarchar(255);
UPDATE NashvilleHousing
SET OwnerState = PARSENAME(REPLACE(OwnerAddress, ',','.'),1) 

--Replacing column values (Ex : Y to Yes and N to No in "Sold as Vacant Field")
Select Distinct(SoldAsVacant), count(SoldAsVacant) from MyProjectPortfolio..NashvilleHousing 
Group by SoldAsVacant

Select SoldAsVacant
 , Case when SoldAsVacant = 'Y' then 'Yes'
       when SoldAsVacant = 'N' then 'No'
	   Else SoldAsVacant
	   End
From MyProjectPortfolio..NashvilleHousing

Update NashvilleHousing 
SET SoldAsVacant = Case when SoldAsVacant = 'Y' then 'Yes'
       when SoldAsVacant = 'N' then 'No'
	   Else SoldAsVacant
	   End 

-- Removing Duplicates from Data
WITH Duplicate AS(
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

From MyProjectPortfolio.dbo.NashvilleHousing
--order by ParcelID
)
Delete 
From Duplicate
Where row_num > 1
--Order by PropertyAddress

--Delete Unused Columns

alter table myprojectportfolio..nashvillehousing
drop column taxdistrict

