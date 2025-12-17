variable "vms" {
  type = map(object(
    {
      vm_name                = string
      kv_name                = string
    #   admin_username         = string
    #   admin_password         = string
      rg_name                = string
      location               = string
      nic_name               = string
      pip_name               = string
      vnet_name              = string
      subnet_name            = string
      size                   = string
      source_image_reference = map(string)
    }
  ))
}
