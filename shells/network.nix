{ pkgs ? import <nixpkgs> {} }:

pkgs.mkShell {
  name = "network-tools";
  buildInputs = with pkgs; [
    iproute2
    nmap
    cope
    mtr
    tcpdump
    dnsutils
    iperf3
  ];
  shellHook = ''
    echo "Network diagnostics environment"
  '';
}
