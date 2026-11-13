# TODO: merge this ruby version into SecGen -- should be working now

require 'ovirtsdk4'

affinitygroup_opt = "secgen_affinity_group_4"
ovirt_vm_name = "p-37-317-0-fkRZ"

conn_attr = {}
conn_attr[:url] = "XXX"
conn_attr[:username] = "XXX"
conn_attr[:password] = "XXX"
conn_attr[:debug] = true
# conn_attr[:proxy_url] = "XXX"


begin
  connection = OvirtSDK4::Connection.new(conn_attr)


  # # Get the reference to the affinity labels service:
  # affinity_labels_service = connection.system_service.affinity_labels_service
  #
  # # Use the "add" method to create a affinity label:
  # affinity_labels_service.add(
  #   OvirtSDK4::AffinityLabel.new(
  #     name: 'my_affinity_label'
  #   )
  # )

  begin
    affinity_group_name = "affinity_group_test123"
    puts "Creating affinity group: #{affinity_group_name}"

    # cluster_affinitygroups_service.add(OvirtSDK4::AffinityGroup.new(
    #   name: affinity_group_name,
    #   description: 'a description',
    #   vms_rule: OvirtSDK4::AffinityRule.new(
    #   enabled: true,
    #   positive: true,
    #   enforcing: true
    #   )
    # ))
  rescue Exception => e
    warn "Failed to create affinity group"
    warn e.message
  end

  vms_service = connection.system_service.vms_service

  clusters_service = connection.system_service.clusters_service
  cluster = clusters_service.list(search: 'name=Default')
  cluster.each do |cluster_instance|
    cluster_service = clusters_service.cluster_service(cluster_instance.id)
    cluster_affinitygroups_service = cluster_service.affinity_groups_service

    # cluster_affinitygroups_service.add(OvirtSDK4::AffinityGroup.new(
    #   name: affinity_group_name,
    #   description: 'a description',
    #   vms_rule: OvirtSDK4::AffinityRule.new(
    #   enabled: true,
    #   positive: true,
    #   enforcing: true
    #   )
    # ))

    vms = vms_service.list(search: "name=#{ovirt_vm_name}*")

    affinitygroups = cluster_affinitygroups_service.list

    affinitygroups.each do |affinitygroup|

      puts affinitygroup.name
      # + '--' + args.affinitygroup)
      if affinitygroup.name == affinitygroup_opt
        puts ("Using Affinity_Group: " + affinitygroup.name + " Affinity_Group ID: " + affinitygroup.id)
        group_service = cluster_affinitygroups_service.group_service(affinitygroup.id)
        puts group_service
        group_vms_service = group_service.vms_service
        puts group_vms_service

        vms.each do |vm|
          puts ("Adding VM: " + vm.name)
          # vm_service = vms_service.vm_service(vm.id)
          vm_to_add =  OvirtSDK4::Vm.new(
            id: vm.id,
            name: vm.name
          )
          puts vm_to_add.id
          group_vms_service.add(vm_to_add)

        end
      end
    end
  end
# rescue Exception => e
#   puts "Failed to control VM: #{e.message}"
end
