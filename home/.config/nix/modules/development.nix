{pkgs, ...}: {
  environment.systemPackages = with pkgs;
    [
      bash-language-server
      clang
      clang-tools
      gcc
      gdb
      ghidra
      lua-language-server
      nix-output-monitor
      nixd
      nixfmt-rfc-style
      pyright
      rustup
      shellcheck
      shfmt
      stylua
      tombi
    ]
    ++ (lib.optionals (pkgs.system == "x86_64-linux") [
      aflplusplus
    ]);
}
