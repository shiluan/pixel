-- usage:
--	select * from ufn_tool_refdep_all() where dep >0 and MappingCode = 'TOA-PRU'

create function ufn_tool_refdep_all()
returns TABLE
AS
return(
	with m1 as
	(select MappingCode, ReferenceCode
	from AssumedDataMapping
	group by MappingCode, ReferenceCode
	),
	m2 as 
	(select MappingCode, ReferenceCode
	from AssumedDataMapping
	group by MappingCode, ReferenceCode
	)

	select m1.MappingCode, m1.ReferenceCode RefCode1, m2.ReferenceCode RefCode2, 
	dbo.ufn_tool_refdep(m1.ReferenceCode, m2.ReferenceCode,m1.MappingCode) as Dep
	
	from m1 join m2 on m1.MappingCode = m2.MappingCode
		and m1.ReferenceCode <> m2.ReferenceCode
	--order by m1.MappingCode, m1.ReferenceCode
)
