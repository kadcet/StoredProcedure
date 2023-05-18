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



-- Deðiþkene Deðer Atamak
-- 1.Yöntem
declare @Sayi int
set @Sayi=5

-- 2. Yöntem
--  Declare ile deðiþkeni oluþturduk. set veya select ile deðer atýyoruz..Select kullanýlmasýnýn avantajý vardýr.
-- altta Product tablosundaki satýr sayýsýný deðiþkene atadýk.
select @Sayi=count(*) from Production.Product


declare @UrunAdi nvarchar(50)
declare @ListeFiyati money
exec usersp_UrunDetay 514,@UrunAdi out,@Listefiyati out
select @UrunAdi,@ListeFiyati

--------------------------------------
use NORTHWND
go

/*
Geliþtirilecek Stored Procedure ile bir kategori adý ve ürün adý parametre gönderilerek kayýt iþlemi yapýlmasý amaçlanmaktadýr.

1. Kategorilerin insert edilmesi
  a.Eðer ayný isimde bir kategori mevcut ise var olanýn id si alýnsýn
  b. Ýlgili kategori yok ise insert edilip id si alýnsýn
2. Ürün insert edilmesi : kategori adý ve ürün adýnýn verildiði bir sp
önce kategoriyi ekler sonra ilgili kategori id si ile ürünü ekler

*/

-- 1. KATEGORÝ EKLEME

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
		--@@IDENTITY  connection seviyesinde üretilen son id deðerini verir
		-- SCOPE_IDENTITY()  connection ve scope seviyesinde üretilen en son id deðerini verir
		--IDENT_CURRENT(TableName) connection ve scope e bakmaksýzýn parametre verilen tablodaki son id deðerini verir.
	end
end

--2. ÜRÜN EKLEME

create proc UserSp_AddProduct
@ProductName nvarchar(40),
@CategoryName nvarchar(15)
as
begin

   declare @CatId int
   exec UserSp_AddCategory @CategoryName,@CatId out
   insert into Products (ProductName,CategoryID) values (@ProductName,@CatId)
end

exec UserSp_AddProduct 'Bahçe Hortumu','Bahçe'

select * from Categories
select * from Products where CategoryID=1009

exec UserSp_AddProduct 'Fýskiye','Bahçe'

-- Bahçe kategoriden fýskiye ürünü eklendi. Bahçe kategorisi olduðu için Category tablosunda deðiþme olmadý.
-- Bahçe Category sinde Fýskiye ürünü Product tablosuna eklendi.



