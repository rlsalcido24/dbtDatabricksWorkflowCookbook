select *
from {{ ref('raw_audit_logs') }}
where action_name in ('executeAdhocQuery', 'submitRun', 'create', 'createTable', 'delete', 'update', 'edit', 'attachNotebook', 'detachNotebook', 'fileCreate', 'startUpdate'
  ,'createResult', 'createQuery', 'runStart', 'executeSavedQuery', 'runSucceeded', 'updateQuery', 'runTriggered', 'runNow', 'createNotebook', 'restartResult', 'startResult'
)
