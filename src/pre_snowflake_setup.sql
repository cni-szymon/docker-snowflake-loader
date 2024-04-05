/* STEP 1 - create S3 stage */
/*
CREATE OR REPLACE STAGE test_stage_s3
  URL='s3://s3_bucket_name/etl_tmp/'
  CREDENTIALS=(AWS_KEY_ID='aws_key_goes_here' AWS_SECRET_KEY='aws_secret_goes_here');

-- alternate with role
CREATE OR REPLACE STAGE your_stage_name
  URL='s3://your-bucket-name/path-to-csv/'
  STORAGE_INTEGRATION = your_storage_integration
  
*/

/* STEP 2 - create file format */
/*
CREATE OR REPLACE FILE FORMAT test_cni_stage_file_format
  TYPE = 'CSV'
  FIELD_DELIMITER = ','
  SKIP_HEADER = 1
  NULL_IF = ('NULL', 'null')
  EMPTY_FIELD_AS_NULL = true
  FIELD_OPTIONALLY_ENCLOSED_BY = '"';

*/
