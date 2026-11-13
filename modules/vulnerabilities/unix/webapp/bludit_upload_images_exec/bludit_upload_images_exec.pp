# require bludit_upload_images_exec::install
# require bludit_upload_images_exec::apache
# require bludit_upload_images_exec::configure
contain bludit_upload_images_exec::install
contain bludit_upload_images_exec::apache
contain bludit_upload_images_exec::configure
Class['bludit_upload_images_exec::install'] ->
Class['bludit_upload_images_exec::apache'] ->
Class['bludit_upload_images_exec::configure']
