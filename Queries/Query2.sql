SELECT DISTINCT
    p.id       projectobjectid,
    p.id       projectid,
    r.uid      resourceobjectid,
    r.initials resourceid,
    r.name     resourcename
FROM
    project p,
    prj_res r
WHERE
        p.id = r.prjid
    AND p.isactive = 'Active'