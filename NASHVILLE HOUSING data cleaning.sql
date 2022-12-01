SELECT * 
FROM [Portfolio Project]..[Nashville Housing]


-- Standardize Date Format -- 

SELECT SaleDate , CONVERT(Date, SaleDate)
FROM [Portfolio Project]..[Nashville Housing]

UPDATE [Nashville Housing]
SET SaleDate = CONVERT(Date, SaleDate)

Alter table [Nashville Housing]
Add SaleDateConverted Date;

Update [Nashville Housing]
SET SaleDateConverted = CONVERT(Date, SaleDate)


-- Populate Property Address data -- 

SELECT *
FROM  [Portfolio Project]..[Nashville Housing]
ORDER BY ParcelID

SELECT a.ParcelID, a.PropertyAddress, b.ParcelID, b.PropertyAddress , ISNULL(a.PropertyAddress,b.PropertyAddress)
FROM  [Portfolio Project]..[Nashville Housing] a
JOIN [Portfolio Project]..[Nashville Housing] b
ON a.ParcelID = b.ParcelID
AND a.[UniqueID ] <> b.[UniqueID ]
WHERE a.PropertyAddress is null



UPDATE a 
SET PropertyAddress = ISNULL(a.PropertyAddress,b.PropertyAddress)
FROM [Portfolio Project]..[Nashville Housing] a 
JOIN [Portfolio Project]..[Nashville Housing] b
ON a.ParcelID = b.ParcelID
AND a.[UniqueID ] <> b.[UniqueID ]
WHERE a.PropertyAddress is null 

-- Breaking out Address into Individual Columns (Address, City, State) -- 

SELECT PropertyAddress
FROM  [Portfolio Project]..[Nashville Housing]
--ORDER BY ParcelID

SELECT 
SUBSTRING(PropertyAddress, 1, CHARINDEX(',', PropertyAddress) -1) AS Address,
SUBSTRING(PropertyAddress, CHARINDEX(',', PropertyAddress) +1, LEN(PropertyAddress)) AS Address
FROM [Portfolio Project]..[Nashville Housing]


Alter table [Nashville Housing]
Add PropertySplitAddress nvarchar(255);

Update [Nashville Housing]
SET PropertySplitAddress = SUBSTRING(PropertyAddress, 1, CHARINDEX(',', PropertyAddress) -1)

Alter table [Nashville Housing]
Add PropertySplitCity nvarchar(255);

UPDATE [Nashville Housing]
SET PropertySplitCity = SUBSTRING(PropertyAddress, CHARINDEX(',', PropertyAddress) +1, LEN(PropertyAddress))


SELECT *
FROM [Portfolio Project]..[Nashville Housing]


SELECT OwnerAddress
FROM [Portfolio Project]..[Nashville Housing]

SELECT 
 PARSENAME(REPLACE(OwnerAddress,',','.'),3),
  PARSENAME(REPLACE(OwnerAddress,',','.'),2),
   PARSENAME(REPLACE(OwnerAddress,',','.'),1)
 FROM [Portfolio Project]..[Nashville Housing]


Alter table [Nashville Housing]
Add OwnerSplitAddress nvarchar(255);

Update [Nashville Housing]
SET OwnerSplitAddress = PARSENAME(REPLACE(OwnerAddress,',','.'),3)

Alter table [Nashville Housing]
Add OwnerSplitCity nvarchar(255);

Update [Nashville Housing]
SET OwnerSplitCity = PARSENAME(REPLACE(OwnerAddress,',','.'),2)

ALTER TABLE [Nashville Housing]
ADD OwnerSplitState nvarchar(255)

Update [Nashville Housing]
SET OwnerSplitState = PARSENAME(REPLACE(OwnerAddress,',','.'),1)

SELECT *
FROM [Portfolio Project]..[Nashville Housing]

-- Change Y and N to Yes and No in "Sold as Vacant" field -- 

SELECT DISTINCT(SoldAsVacant),COUNT(SoldAsVacant)
FROM [Portfolio Project]..[Nashville Housing]
GROUP BY SoldAsVacant
ORDER BY 2

SELECT SoldAsVacant, 
CASE When SoldAsVacant = 'Y'  THEN 'YES'
When SoldAsVacant = 'N' THEN 'NO'
ELSE SoldAsVacant 
END 
FROM [Portfolio Project]..[Nashville Housing]

Update [Nashville Housing]
SET SoldAsVacant = Case When SoldAsVacant = 'Y' Then 'YES'
When SoldAsVacant = 'N' Then 'NO'
ELSE SoldAsVacant
END 

-- Remove Duplicates -- 

With RowNumCTE AS (
SELECT *,
ROW_NUMBER() over (
PARTITION BY ParcelID,
PropertyAddress,
SalePrice,
SaleDate,
LegalReference
ORDER BY UniqueID
) row_num
FROM [Portfolio Project]..[Nashville Housing]
--ORDER BY ParcelID
)
SELECT *
FROM RowNumCTE
WHERE row_num > 1
--ORDER BY PropertyAddress


SELECT *
FROM [Portfolio Project]..[Nashville Housing]

-- Delete unused columns -- 

SELECT *
FROM [Portfolio Project]..[Nashville Housing]


ALTER TABLE [Portfolio Project]..[Nashville Housing]
DROP COLUMN OwnerAddress, TaxDistrict, PropertyAddress

ALTER TABLE [Portfolio Project]..[Nashville Housing]
DROP COLUMN SaleDate
