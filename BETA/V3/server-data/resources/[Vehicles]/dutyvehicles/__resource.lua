resource_manifest_version '77731fab-63ca-442c-a67b-abc70f28dfa5'

files {
 -- Algemeen   
 'metas/Alle/handling.meta',
 'metas/Alle/vehicles.meta',
 'metas/Alle/carcols.meta',
 'metas/Alle/carvariations.meta',
 'metas/Alle/vehiclelayouts.meta',

 -- Jobs 
 'metas/jobs/handling.meta',
 'metas/jobs/vehicles.meta',
 'metas/jobs/carvariations.meta', 

-- DSIZulu
 'metas/DsiZulu/vehiclelayouts.meta',
}

-- Algemeen
data_file 'VEHICLE_LAYOUTS_FILE' 'metas/Alle/vehiclelayouts.meta'
data_file 'HANDLING_FILE' 'metas/Alle/handling.meta'
data_file 'CARCOLS_FILE' 'metas/Alle/carcols.meta'
data_file 'VEHICLE_METADATA_FILE' 'metas/Alle/vehicles.meta'
data_file 'VEHICLE_VARIATION_FILE' 'metas/Alle/carvariations.meta'

-- Jobs
data_file 'HANDLING_FILE' 'metas/jobs/handling.meta'
data_file 'VEHICLE_METADATA_FILE' 'metas/jobs/vehicles.meta'
data_file 'VEHICLE_VARIATION_FILE' 'metas/jobs/carvariations.meta'

-- DSIZulu
data_file 'VEHICLE_LAYOUTS_FILE' 'metas/DsiZulu/vehiclelayouts.meta'