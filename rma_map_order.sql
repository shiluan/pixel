--- Kahn's algorith

-- items(nodes) to be ordered
declare @n TABLE(
  refcode varchar(100),
  orderno int

)

-- dependencies (edges): ref1 depends-on ref2
declare @e TABLE(
  ref1 varchar(100),
  ref2 varchar(100)
)


insert into @n (refcode)
values ('a'), ('b'), ('c'), ('d'), ('e'), ('f'), ('g')

insert @e(ref1, ref2) 
values ('a','c'),('d','e'),('a','e'), ('e','c'),('g','d'),('c','f')


-- alg
update @n set orderno = 0

-- set of nodes that have no incoming-edge 
declare @s Table(
  ref varchar(100)
)

-- initialize @s
insert @s (ref)
select refcode ref from @n
	where refcode not in (select ref2 from @e)

declare @x varchar(100)
while exists (select 1 from @s) begin
  select top 1 @x = ref from @s
  update @n set orderno = (select max(orderno) + 1 from @n)
	where refcode = @x
  delete from @s where ref = @x
  
  delete from @e where ref1 = @x

	;with s1 as (
	select refcode ref from @n
	where orderno = 0 and refcode not in (select ref2 from @e)
	)
	merge @s as t using s1
	on t.ref = s1.ref
	when not matched then 
		insert (ref) values (s1.ref);

	--select count(1) from @s
	--select count(1) from @e
end


select * from @n
order by orderno


