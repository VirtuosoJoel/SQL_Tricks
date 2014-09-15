select distinct object_name(a.rsc_objid), a.req_spid, b.loginame
from master.dbo.syslockinfo a (nolock) join
master.dbo.sysprocesses b (nolock) on a.req_spid=b.spid
where object_name(a.rsc_objid) is not null

--EXEC sp_who2 72
