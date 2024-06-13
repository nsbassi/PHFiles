SELECT
    dj.*,
    replace(lower(projectmanager),
            ' ',
            '.')                                                                                                                              user_pm
            ,
    replace(lower(fddgl),
            ' ',
            '.')                                                                                                                              user_gl
            ,
    replace(lower(fddfh),
            ' ',
            '.')                                                                                                                              user_fh
            ,
    'ashish.paliwal,deepak.kanyal,ganesh.jadhav,gopal.patel,gurmit.kabani,harmish.patel,hetalkumar.patel,
ishverdas.patwa,jinal.patel,jithu.krishnan,kaushal.jani,krishna.sharma,mahesh.soni,manish.mardhekar,manishkumar.jayswal,manju.jena,
megha.kulkarni,milan.vasoya,mukesh.sharma,naveen.kumar,nischalkumar.patel,prashant.kane,prateek.agnihotri,ratilal.kasela,samir.shah,
subhas.bhowmik,sunil.vaswani,vaishali.rampurkar,vignesh.hegde,vijay.kashyap,vikas.parekh,e32809,
vipulkumar.patel,nilesh.patel,vishwanath.kenkare,yogesh.jaiswal,
,sapan.parikh,aalok.shanghvi,pradeep.sanghvi,arul.mervin,tapan.buch1,tapan.buch,
subhas.bhowmick,rajeev.mathur,mohan.prasad,shruti.agarwal,e45003,anvita.dwivedi,e79843,dilip.singh,e09698' user_all
FROM
    (
        SELECT
            p.id                projectobjectid,
            p.id                projectid,
            p.name              projectname,
            p.startdate         projectstart,
            p.finishdate        projectfinish,
            (
                SELECT
                    SUM(duration)
                FROM
                    task
                WHERE
                    prjid = p.id
            )                   sumplannedduration,
            a.uid               activityobjectid,
            a.id                activityid,
            a.name              activityname,
            a.remainingduration remainingduration,
            a.duration          plannedduration,
            a.start             startdate,
            a.finish            finishdate,
            a.wbs               wbsobjectid,
            a.wbs               wbscode,
            a.wbsname           wbsname,
            (
                SELECT
                    name
                FROM
                    prj_res
                WHERE
                        uid = (
                            SELECT
                                resourceuid
                            FROM
                                assignments
                            WHERE
                                    taskid = a.id
                                AND prjid = p.id
                        )
                    AND prjid = p.id
            )                   primaryresourcename,
            CASE
                WHEN a.milestone = 1 THEN
                    a.start
                ELSE
                    NULL
            END                 milestone,
            CASE
                WHEN a.remainingduration = 0          THEN
                    'Blue'
                WHEN a.remainingduration = a.duration THEN
                    'Green'
                ELSE
                    'Yellow'
            END                 activitystatus,
            (
                SELECT
                    value
                FROM
                    ext_attr
                WHERE
                        prjid = p.id
                    AND taskid = a.id
                    AND fieldname = 'Number1'
            )                   urgency,
            p.pm                projectmanager,
            p.isactive          projectstatus,
            p.fddfh             fddfh,
            p.fddgl             fddgl,
            p.dossagetype       dosagetype,
            p.mfgsite           mfgsite,
            p.opportunity       priority,
            p.devsite           devesite,
            p.lastupdate        lastupdatedate,
            (
                SELECT
                    value
                FROM
                    ext_attr
                WHERE
                        prjid = p.id
                    AND taskid = a.id
                    AND fieldname = 'Number9'
            )                   impactchain
        FROM
            project p,
            task    a
    ) dj