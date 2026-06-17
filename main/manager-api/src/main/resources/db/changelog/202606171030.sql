UPDATE sys_user
SET username = 'slump',
    password = '$2a$10$Mir1iaTnWau6R49.e2X43OFD2u1Cpqg0hDB9ZEBgotzFyKxBS80ia',
    update_date = NOW()
WHERE super_admin = 1
  AND username <> 'slump'
  AND NOT EXISTS (
      SELECT 1
      FROM (
          SELECT id
          FROM sys_user
          WHERE username = 'slump'
      ) AS existing_user
  );

UPDATE sys_user
SET password = '$2a$10$Mir1iaTnWau6R49.e2X43OFD2u1Cpqg0hDB9ZEBgotzFyKxBS80ia',
    update_date = NOW()
WHERE username = 'slump';
