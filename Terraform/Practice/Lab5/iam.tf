data "azuread_user" "nick" {
  user_principal_name = "nick@satona.co.uk"
}

resource "azuread_group" "remote_access_users" {
  display_name     = "${var.application_name}${var.environment_name}-remote-access-users"
  owners           = [data.azuread_user.nick.object_id]
  security_enabled = true
}

resource "azuread_group_member" "nick_remote_access" {
  group_object_id  = azuread_group.remote_access_users.object_id
  member_object_id = data.azuread_user.nick.object_id
}