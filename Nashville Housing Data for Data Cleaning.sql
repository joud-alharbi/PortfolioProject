

select * from PortfolioProject.dbo.NashvilleHousing

--standardize date format

select SaleDateConverted,convert(date,SaleDate)
from PortfolioProject.dbo.NashvilleHousing

--update NashvilleHousing
--set SaleDate=convert(date,SaleDate)

alter table NashvilleHousing
add SaleDateConverted date;

update NashvilleHousing
set SaleDateConverted =convert(date,SaleDate)

--populate property address date

select *
from PortfolioProject.dbo.NashvilleHousing
--where PropertyAddress is null
order by ParcelID
  
  select a.ParcelID,a.PropertyAddress,b.ParcelID,b.PropertyAddress,isnull(a.PropertyAddress,b.PropertyAddress)
from PortfolioProject.dbo.NashvilleHousing a
join PortfolioProject.dbo.NashvilleHousing b
on a.ParcelID=b.ParcelID
and a.[UniqueID ]<>b.[UniqueID ]
where a.PropertyAddress is null

update a
set PropertyAddress=isnull(a.PropertyAddress,b.PropertyAddress)
from PortfolioProject.dbo.NashvilleHousing a
join PortfolioProject.dbo.NashvilleHousing b
on a.ParcelID=b.ParcelID
and a.[UniqueID ]<>b.[UniqueID ]
where a.PropertyAddress is null

--breaking out address into individual  columns (address,city,state)

select PropertyAddress
from PortfolioProject.dbo.NashvilleHousing
--where PropertyAddress is null
--order by ParcelID

select
SUBSTRING(PropertyAddress,1,CHARINDEX(',',PropertyAddress)-1) as Address
,SUBSTRING(PropertyAddress,CHARINDEX(',',PropertyAddress)+1,len(PropertyAddress)) as Address
from PortfolioProject.dbo.NashvilleHousing


alter table NashvilleHousing
add PropertySplitAddress nvarchar(255);

update NashvilleHousing
set PropertySplitAddress =SUBSTRING(PropertyAddress,1,CHARINDEX(',',PropertyAddress)-1)

alter table NashvilleHousing
add PropertySplitCity nvarchar(255);

update NashvilleHousing
set PropertySplitCity =SUBSTRING(PropertyAddress,CHARINDEX(',',PropertyAddress)+1,len(PropertyAddress))

select *
from PortfolioProject.dbo.NashvilleHousing

select OwnerAddress
from PortfolioProject.dbo.NashvilleHousing

select
PARSENAME(replace(OwnerAddress,',','.'), 3)
,PARSENAME(replace(OwnerAddress,',','.'), 2)
,PARSENAME(replace(OwnerAddress,',','.'), 1)
from PortfolioProject.dbo.NashvilleHousing


alter table NashvilleHousing
add OwnerSplitAddress nvarchar(255);

update NashvilleHousing
set OwnerSplitAddress =PARSENAME(replace(OwnerAddress,',','.'), 3)


alter table NashvilleHousing
add OwnerSplitCity nvarchar(255);

update NashvilleHousing
set  OwnerSplitCity=PARSENAME(replace(OwnerAddress,',','.'), 2)


alter table NashvilleHousing
add OwnerSplitCtate nvarchar(255);

update NashvilleHousing
set OwnerSplitCtate =PARSENAME(replace(OwnerAddress,',','.'), 1)

select *
from PortfolioProject.dbo.NashvilleHousing

--change Y and N to yes and no in "SoldAsVacant"

select distinct(SoldAsVacant),count(SoldAsVacant)
from PortfolioProject.dbo.NashvilleHousing
group by SoldAsVacant
order by 2

select SoldAsVacant
 ,case when SoldAsVacant='Y' then 'Yes'
       when SoldAsVacant='N' then 'No'
	   else SoldAsVacant
	   end
from PortfolioProject.dbo.NashvilleHousing

update NashvilleHousing
set SoldAsVacant=case when SoldAsVacant='Y' then 'Yes'
       when SoldAsVacant='N' then 'No'
	   else SoldAsVacant
	   end

--remove duplicates

with RowNumCTE as(
select *,
ROW_NUMBER()over (
partition by ParcelID,
                PropertyAddress,
				SalePrice,
				SaleDate,
				LegalReference
				order by 
				     UniqueID) row_num

from PortfolioProject.dbo.NashvilleHousing
--order by ParcelID
)
select
--delete
* from RowNumCTE
where row_num>1
order by PropertyAddress

select *
from PortfolioProject.dbo.NashvilleHousing



--delete unused columns

select *
from PortfolioProject.dbo.NashvilleHousing

alter table  PortfolioProject.dbo.NashvilleHousing
drop column OwnerAddress,TaxDistrict,PropertyAddress

alter table  PortfolioProject.dbo.NashvilleHousing
drop column SaleDate

