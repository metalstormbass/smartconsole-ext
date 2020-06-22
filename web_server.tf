#Variable Processing
# Setup the userdata that will be used for the instance
data "template_file" "userdata_setup" {
  template = "${file("userdata_setup.template")}"

  vars  = {
    name       = "${var.username}"
    token     = "${var.token}"
    logic = "${file("web_bootstrap.sh")}"
  }
}

# Create Security Group to access web

resource "azurerm_network_security_group" "linux-nsg" {
  depends_on=[azurerm_resource_group.network-rg]
  name = "web-linux-vm-nsg"
  location            = azurerm_resource_group.network-rg.location
  resource_group_name = azurerm_resource_group.network-rg.name
  security_rule {
    name                       = "allow-ssh"
    description                = "allow-ssh"
    priority                   = 100
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "22"
    source_address_prefix      = "Internet"
    destination_address_prefix = "*"
  }
  security_rule {
    name                       = "allow-http"
    description                = "allow-http"
    priority                   = 110
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "80"
    source_address_prefix      = "Internet"
    destination_address_prefix = "*"
  }
    security_rule {
    name                       = "allow-https"
    description                = "allow-https"
    priority                   = 110
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "443"
    source_address_prefix      = "Internet"
    destination_address_prefix = "*"
  }
  tags = {
    environment = var.environment
  }
}

#Public IP Address

resource "azurerm_public_ip" "publicip" {
    name                         = "${var.\vm-name}-public-ip"
    location                     = azurerm_resource_group.network-rg.location
    resource_group_name          = azurerm_resource_group.network-rg.name
    allocation_method = "Static"
}

# Output the public ip of the gateway

output "Web_Server_IP" {
    value = azurerm_public_ip.publicip.ip_address
}


#Create Network Interface
resource "azurerm_network_interface" "ubuntu" {
  name                = "${var.vm-name}-nic"
  location            = azurerm_resource_group.network-rg.location
  resource_group_name = azurerm_resource_group.network-rg.name

  ip_configuration {
    name                          = "${var.vm-name}-ip"
    subnet_id                     = azurerm_subnet.network-subnet.id
    private_ip_address_allocation = "Static"
    private_ip_address = var.internal-private-ip
    primary = true
        public_ip_address_id = azurerm_public_ip.publicip.id
  }
}

#Associate Security Group with Internface

resource "azurerm_network_interface_security_group_association" "linux-nsg-int" {
  network_interface_id      = azurerm_network_interface.ubuntu.id
  network_security_group_id = azurerm_network_security_group.linux-nsg.id
  }


resource "azurerm_virtual_machine" "main" {
  name                  = var.vm-name
  location              = azurerm_resource_group.network-rg.location
  resource_group_name   = azurerm_resource_group.network-rg.name
  network_interface_ids = [azurerm_network_interface.ubuntu.id]
  vm_size               = "Standard_DS1_v2"

  delete_os_disk_on_termination = true
  delete_data_disks_on_termination = true

  storage_image_reference {
    publisher = "Canonical"
    offer     = "UbuntuServer"
    sku       = "18.04-LTS"
    version   = "latest"
  }
  storage_os_disk {
    name              = "${var.vm-name}-disk"
    caching           = "ReadWrite"
    create_option     = "FromImage"
    managed_disk_type = "Standard_LRS"
  }
  os_profile {
    computer_name  = var.vm-name
    admin_username = var.username
    admin_password = var.password
    custom_data = data.template_file.userdata_setup.rendered
  }
  os_profile_linux_config {
    disable_password_authentication = false
  }
  tags = {
    environment = var.environment
  }
}

