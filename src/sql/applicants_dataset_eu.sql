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
UNION ALL
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
FROM applicants.zzz2_apps_002 x
UNION ALL
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
FROM applicants.zzz2_apps_003 x
UNION ALL
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
FROM applicants.zzz2_apps_004 x
UNION ALL
SELECT id,
       customerId,
       projectId,
       applicantId,
       dateRegistered,
       x.controls ->> '$.txtActName'      as txtActName,
       x.controls ->> '$.txtEmailAddress' as txtEmailAddress,
       x.controls ->> '$.cmbCastBy'       as cmbCastBy,
       x.controls ->> '$.dateFinalized',
       registrationMethod
FROM applicants.zzz2_apps_005 x
UNION ALL
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
FROM applicants.zzz2_apps_006 x
UNION ALL
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
FROM applicants.zzz2_apps_007 x
UNION ALL
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
FROM applicants.zzz2_apps_008 x
UNION ALL
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
FROM applicants.zzz2_apps_aux_esg x
union ALL
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
FROM applicants.zzz2_apps_aux_floydtech x
