SELECT
    dj.*,
    round((dj.originalchain - dj.chainleft) * 100 / dj.originalchain, 2) percentchainold,
    isnull(dj.percentchain1, 0)                                          percentchain,
    isnull(dj.bufferconsumed1, 0)                                        bufferconsumed,
    isnull(dj.buffercolor1, 0)                                           buffercolor
FROM
    (
        SELECT
            p.id                             projectobjectid,
            p.id                             projectid,
            p.name                           projectname,
            t.name,
            t.market,
            t.finish                         submissiondate,
            isnull((
                SELECT
                    description
                FROM
                    lookups
                WHERE
                        type = 'Market'
                    AND name = t.market
            ), t.market)                     activitycodedescription,
            t.market                         activitycodevalue,
            t.uid                            activityobjectid,
            t.percentcomplete                durationpercentcomplete,
            (
                SELECT top 1
                    taskuid
                FROM
                    delay_log
                WHERE
                        prjid = p.id
                    AND market = t.market
                ORDER BY
                    entrydate DESC
            )                                pred_task_id,
            isnull(t.actualfinish, t.finish) lbe,
            (
                SELECT top 1
                    entrydate
                FROM
                    delay_log
                WHERE
                        prjid = p.id
                    AND market = t.market
                ORDER BY
                    entrydate DESC
            )                                lastnoteupdated,
            (
                SELECT top 1
                    reason
                FROM
                    delay_log
                WHERE
                        prjid = p.id
                    AND market = t.market
                ORDER BY
                    entrydate DESC
            )                                note,
            (
                SELECT
                    TRY_CAST(phub.splitandreturnsegment(value, ',', 0) as float)
                FROM
                    ext_attr
                WHERE
                        prjid = p.id
                    AND taskid = t.uid
                    AND fieldname = 'Text15'
            )                                percentchain1,
            (
                SELECT
                    TRY_CAST(phub.splitandreturnsegment(value, ',', 1) as float)
                FROM
                    ext_attr
                WHERE
                        prjid = p.id
                    AND taskid = t.uid
                    AND fieldname = 'Text15'
            )                                bufferconsumed1,
            CASE (
                SELECT
                    phub.splitandreturnsegment(value, ',', 2)
                FROM
                    ext_attr
                WHERE
                        prjid = p.id
                    AND taskid = t.uid
                    AND fieldname = 'Text15'
            )
                WHEN '1' THEN
                    'Green'
                WHEN '2' THEN
                    'Yellow'
                WHEN '3' THEN
                    'Red'
                WHEN '4' THEN
                    'Black'
                WHEN '5' THEN
                    'Light Blue'
            END                              buffercolor1,
            (
                SELECT
                    TRY_CAST(phub.splitandreturnsegment(value, ' ', 0) as float)
                FROM
                    ext_attr
                WHERE
                        prjid = p.id
                    AND taskid = t.uid
                    AND fieldname = 'Text9'
            )                                originalchain,
            (
                SELECT
                    TRY_CAST(phub.splitandreturnsegment(value, ' ', 0) as float)
                FROM
                    ext_attr
                WHERE
                        prjid = p.id
                    AND taskid = t.uid
                    AND fieldname = 'Text8'
            )                                chainleft,
            m.mfiveycf                       fiveyearcashflow,
            m.projectstatus                  marketprojectstatus,
            (
                SELECT
                    value
                FROM
                    ext_attr
                WHERE
                        prjid = p.id
                    AND taskid = t.uid
                    AND fieldname = 'Number7'
            )                                angle,
            'India'                          country
        FROM
            project     p,
            task        t,
            market_info m
        WHERE
                t.prjid = p.id
            AND t.name LIKE 'PB|%'
            AND m.prjid = p.id
            AND m.marketname = t.market
            AND t.market <> 'N/A'
    ) dj;