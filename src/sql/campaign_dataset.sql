SELECT c.liveprojectid                                AS project_id,
       cust.name                                      AS client_name,
       cast(coalesce(c.customerid, 0) AS signed)      AS client_id,
       cast(coalesce(account_admin.cnt, 0) AS signed) AS numof_admins_account,
       p.name                                         AS project_name,
       c.urlpart                                      AS campaign_url,
       p.campaignid                                   AS campaign_id,
       p.datecreated                                  AS campaign_created,
       cast(coalesce(cadmin.cnt, 0) AS signed)        AS numof_admins_campaign
FROM etribez.project p
         JOIN etribez.campaign c ON p.campaignid = c.id
         LEFT JOIN etribez.customer cust ON p.customerid = cust.id
         LEFT JOIN (SELECT cu.customerid,
                           count(DISTINCT cu.userid) AS cnt
                    FROM etribez.customer_user cu
                             JOIN etribez.role r ON cu.roleid = r.id AND cu.customerid = r.customerid
                    WHERE 1 = 1
                      AND datedeleted IS NULL
                      AND datedisabled IS NULL
                    GROUP BY cu.customerid) AS account_admin ON account_admin.customerid = cust.id
         LEFT JOIN (SELECT c.projectid, count(DISTINCT userid) AS cnt
                    FROM etribez.user_project c
                    WHERE c.enabled = 1
                    GROUP BY c.projectid) AS cadmin ON cadmin.projectid = c.liveprojectid
WHERE p.type = 'campaign'
  AND p.usagetype = 'live'
  AND c.customerid IS NOT NULL
  AND c.customerid > 0
