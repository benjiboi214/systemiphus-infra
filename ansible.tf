# Example ansible config block to bring the ansible provider into config.
# resource "ansible_host" "example" {
#     inventory_hostname = "example.com"
#     groups = ["web"]
#     vars {
#         ansible_user = "admin"
#     }
# }