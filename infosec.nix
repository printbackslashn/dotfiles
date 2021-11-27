{ pkgs ? import <nixpkgs> {} }:
  pkgs.mkShell {
    # nativeBuildInputs is usually what you want -- tools you need to run
    nativeBuildInputs = [ pkgs.netcat-gnu pkgs.openvpn pkgs.rustscan pkgs.nmap pkgs.aircrack-ng pkgs.john pkgs.hashcat pkgs.thc-hydra pkgs.zap pkgs.wireshark pkgs.ghidra-bin];
    #Metasploit is broken compiling :(
    
}
