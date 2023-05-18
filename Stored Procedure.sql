--

create proc sp_GetDate

as
begin
select GETDATE()
end

execute sp_GetDate
-- yada exec sp_GetDate

use AdventureWorks2014
go

create proc usersp_UrunDetay
@ProductId int
as
begin
select Name,ListPrice from Production.Product
where ProductId=@ProductId
end

alter proc usersp_UrunDetay
@ProductId int,
@Name nvarchar(50) out,
@ListPrice Money out
as
begin
select @Name=Name,@ListPrice=ListPrice from Production.Product
where ProductID=@ProductId
end



-- De�i�kene De�er Atamak
-- 1.Y�ntem
declare @Sayi int
set @Sayi=5

-- 2. Y�ntem
--  Declare ile de�i�keni olu�turduk. set veya select ile de�er at�yoruz..Select kullan�lmas�n�n avantaj� vard�r.
-- altta Product tablosundaki sat�r say�s�n� de�i�kene atad�k.
select @Sayi=count(*) from Production.Product


declare @UrunAdi nvarchar(50)
declare @ListeFiyati money
exec usersp_UrunDetay 514,@UrunAdi out,@Listefiyati out
select @UrunAdi,@ListeFiyati

--------------------------------------
use NORTHWND
go

/*
Geli�tirilecek Stored Procedure ile bir kategori ad� ve �r�n ad� parametre g�nderilerek kay�t i�lemi yap�lmas� ama�lanmaktad�r.

1. Kategorilerin insert edilmesi
  a.E�er ayn� isimde bir kategori mevcut ise var olan�n id si al�ns�n
  b. �lgili kategori yok ise insert edilip id si al�ns�n
2. �r�n insert edilmesi : kategori ad� ve �r�n ad�n�n verildi�i bir sp
�nce kategoriyi ekler sonra ilgili kategori id si ile �r�n� ekler

*/

-- 1. KATEGOR� EKLEME

create proc UserSp_AddCategory
@CategoryName nvarchar(15),
@CategoryId int out
as
begin
  if exists (select CategoryName from Categories where CategoryName=@CategoryName)

    begin
	  select @CategoryId=CategoryId from Categories where CategoryName=@CategoryName
	end
	else
	begin
	    insert into Categories (CategoryName) values (@CategoryName)
		select @CategoryId=SCOPE_IDENTITY()
		--@@IDENTITY  connection seviyesinde �retilen son id de�erini verir
		-- SCOPE_IDENTITY()  connection ve scope seviyesinde �retilen en son id de�erini verir
		--IDENT_CURRENT(TableName) connection ve scope e bakmaks�z�n parametre verilen tablodaki son id de�erini verir.
	end
end

--2. �R�N EKLEME

create proc UserSp_AddProduct
@ProductName nvarchar(40),
@CategoryName nvarchar(15)
as
begin

   declare @CatId int
   exec UserSp_AddCategory @CategoryName,@CatId out
   insert into Products (ProductName,CategoryID) values (@ProductName,@CatId)
end

exec UserSp_AddProduct 'Bah�e Hortumu','Bah�e'

select * from Categories
select * from Products where CategoryID=1009

exec UserSp_AddProduct 'F�skiye','Bah�e'

-- Bah�e kategoriden f�skiye �r�n� eklendi. Bah�e kategorisi oldu�u i�in Category tablosunda de�i�me olmad�.
-- Bah�e Category sinde F�skiye �r�n� Product tablosuna eklendi.



