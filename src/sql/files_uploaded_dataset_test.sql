select vif.id        as videoInstanceFileId,
       vif.videoId,
       v.id          as source_video_id,
       v.currentVideoInstanceId,
       vif.isOriginal,
       vi.id         as video_instance_id,
       vi.videoid    as video_instance_video_id,
       vi.originalProviderVideoId,
       vi.lastAssignedJobId,
       vi.dateTranscoded,
       vif.provider,
       vif.hosting,
       vif.fileFormat,
       vif.s3Bucket,
       vif.path,
       vif.dateCreated,
       v.dateCreated as video_created,
       v.dateUpdated as video_updated,
       vif.dateDeleted,
       v.customerId,
       v.projectId,
       v.applicantId,
       v.controlId
FROM applicants.videoInstanceFile vif
         join applicants.video v on vif.videoid = v.id
         left join applicants.videoInstance vi on vi.id = v.currentVideoInstanceId
LIMIT 100