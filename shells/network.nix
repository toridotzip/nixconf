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
    echo ""
    echo -e "\033[0;32mNetwork diagnostics environment\033[0m"
    echo "---"
    echo "nmap | tcpdump | dnsutils | mtr | iperf | iproute"
  '';
}
