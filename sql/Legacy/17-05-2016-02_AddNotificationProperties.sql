use Valeant
go

  -- approve request
  update [Valeant].[valeant].[node_properties_version_3] set [notification] = 1 
  where [state] = 3 and token = 2 and document = 1 

  update [Valeant].[valeant].[node_properties_version_3] set [notification] = 1
  where [state] = 8 and token = 3 and document = 1

  update [Valeant].[valeant].[node_properties_version_3] set [notification] = 1
  where [state] = 9 and token = 9 and document = 1 

  --approved
  update [Valeant].[valeant].[node_properties_version_3] set [notification] = 9
  where [state] = 6 and token = 1 and document = 1

  -- revision
  update [Valeant].[valeant].[node_properties_version_3] set [notification] = 6
  where [state] = 5 and token = 1 and document = 1

  -- Отклонена
    update [Valeant].[valeant].[node_properties_version_3] set [notification] = 7
  where [state] = 4 and token = 1 and document = 1

  go