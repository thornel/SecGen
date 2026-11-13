# this is where the puppet code starts executing
# the filename has to be named module_name.pp, matching the directory name

# this simplified approach below forces sequential, install -> apache -> configure
# Note that puppet can ignore the ordering of directives, unless the order is made explicit
contain bludit_upload_images_exec::install
contain bludit_upload_images_exec::apache
contain bludit_upload_images_exec::configure
Class['bludit_upload_images_exec::install'] ->
Class['bludit_upload_images_exec::apache'] ->
Class['bludit_upload_images_exec::configure']
