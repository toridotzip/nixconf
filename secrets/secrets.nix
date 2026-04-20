let
  etcvi = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIFyWaqTtRMyMRzVDv5ajodRegEDhqTWfOvE399omleF0 etcvi";
in
{
  "syncthing-gui.age".publicKeys = [ etcvi ];
}
