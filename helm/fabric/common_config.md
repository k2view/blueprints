# Common Fabric Configurations

## Logical Unit Storage

### Local
```ini
[fabric]
DEFAULT_GLOBAL_STORAGE_TYPE=SYSTEM_DB
[fabricdb]
MDB_DEFAULT_SCHEMA_CACHE_STORAGE_TYPE=SYSTEM_DB
MDB_DEFAULT_CACHE_PATH=/opt/apps/fabric/pod_tmp/fdb_cache
```

### AWS S3 Bucket
```ini
[fabric]
DEFAULT_GLOBAL_STORAGE_TYPE=S3

[fabricdb]
MDB_DEFAULT_SCHEMA_CACHE_STORAGE_TYPE=S3

[s3_storage]
REGION={S3_BUCKET_REGION}
BUCKET_NAME={S3_BUCKET_NAME}
# Auth
# For regular authentication, specify these parameters; for IAM-based authentication, leave them blank
ACCESS_KEY_ID={AWS_ACCESS_KEY}
SECRET_ACCESS_KEY={AWS_ACCESS_SECRET_KEY}
```

### GCS Bucket
```ini
[fabric]
DEFAULT_GLOBAL_STORAGE_TYPE=GCS

[fabricdb]
MDB_DEFAULT_SCHEMA_CACHE_STORAGE_TYPE=GCS

[gcs_storage]
LOCATION_ID={BUCKET_LOCATION_ID}
PROJECT_ID={GCP_PROJECT_ID}
BUCKET_NAME={GCP_BUCKET_NAME}
# Auth
# For regular authentication, specify the CREDENTIAL_FILE parameter; for IAM-based authentication, leave this blank
CREDENTIAL_FILE={GCP_CREDENTIAL_FILE_PATH}
```

### Azure Blob Store
```ini
[fabric]
DEFAULT_GLOBAL_STORAGE_TYPE=AZURE_BLOB_STORE

[fabricdb]
MDB_DEFAULT_SCHEMA_CACHE_STORAGE_TYPE=AZURE_BLOB_STORE

[azure_blob_storage]
ACCOUNT_NAME={STORAGE_ACCOUNT_NAME}
CONTAINER_NAME={STORAGE_ACCOUNT_CONTAINER_NAME}
ENDPOINT_TEMPLATE={STORAGE_ACCOUNT_ENDPOINT} # Example: https://{STORAGE_ACCOUNT_NAME}.blob.core.windows.net"

## Azure authentication type: SHARED_KEY for StorageSharedKeyCredential(accountName,accountKey), SAS for AzureSasCredential(accountKey), SERVICE_PRINCIPAL for service principal auth (using client secret), MANAGED_IDENTITY for managed identity or DEFAULT for Azure default credentials
CREDENTIALS_TYPE={AZURE_CREDENTIALS_TYPE} # SHARED_KEY, SAS, SERVICE_PRINCIPAL, MANAGED_IDENTITY, DEFAULT

## Azure blob account name in case of SHARED_KEY
#ACCOUNT_NAME=

## Azure blob secret account key (SHARED_KEY) or signature (in case of SAS)
#ACCOUNT_KEY=
```

## Fabric System DB

### Local (SQLite)

```ini
[system_db]
SYSTEM_DB_TYPE=SQLITE
```

### Postgresql
```ini
[system_db]
SYSTEM_DB_TYPE=POSTGRESQL
SYSTEM_DB_HOST={PG_HOST} # For local PG pod use "posgres-service", otherwise specify the host IP address
SYSTEM_DB_PORT=5432
SYSTEM_DB_USER={PG_USER}
SYSTEM_DB_PASSWORD={PG_PASSWORD}
SYSTEM_DB_DATABASE={PG_DB}
```
