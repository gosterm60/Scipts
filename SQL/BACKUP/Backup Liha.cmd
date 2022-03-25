sqlcmd -E -S APP01 -d master -Q "EXECUTE [dbo].[DatabaseBackup] @Databases = 'USER_DATABASES', @Directory = 'D:\admin\Backup\Liha', @BackupType = 'FULL', @Verify = 'Y', @CleanupTime = 24" -b -o C:\Admin\logs\sql\FinesaDatabaseBackup.txt