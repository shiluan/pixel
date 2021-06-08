-- usage: 
--		select dbo.ufn_tool_refdep('CESS_UW_METHOD', 'MODE','KOR-LNL')
-- drop function ufn_tool_refdep
create function ufn_tool_refdep(
  @refcode1 nvarchar(510), 
  @refcode2 nvarchar(510), 
  @mapcode nvarchar(510)
)
returns bit
as
begin
	-- 'KOR-LNL': 'CESS_UW_METHOD' depends_on 'MODE'
	-- 
	return 
		case when exists(
			select top 100 * from AssumedDataMapping
			where charindex(@refcode1, IncomingData)>0
			and MappingCode = @mapcode
			and ReferenceCode = @refcode2) 
		then 1
		else 0
	end 
end