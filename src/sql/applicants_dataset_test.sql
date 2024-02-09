SELECT id,
       customerId,
       projectId,
       applicantId,
       dateRegistered,
       x.controls ->> '$.txtActName'      as txtActName,
       x.controls ->> '$.txtEmailAddress' as txtEmailAddress,
       x.controls ->> '$.cmbCastBy'       as cmbCastBy,
       x.controls ->> '$.dateFinalized' as dateFinalized,
       registrationMethod
FROM applicants.zzz2_apps_001 x 
LIMIT 100
