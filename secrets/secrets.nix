let
  etcvi = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIFyWaqTtRMyMRzVDv5ajodRegEDhqTWfOvE399omleF0 etcvi";
  thyme = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAINYbRl2BFAlM3MjitV0F01FNjfvRG29IMau1yniLCm7n";
in
{
  "syncthing-gui.age".publicKeys = [ etcvi ];
}
