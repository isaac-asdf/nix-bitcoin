{ config, pkgs, lib, ... }: {
  imports = [
    <nix-bitcoin/modules/presets/secure-node.nix>
    <nix-bitcoin/modules/presets/wireguard.nix>
    ./hardware-configuration.nix
  ];
  nix-bitcoin.onionServices.bitcoind.public = true;
  # You can add options that are not defined in modules/bitcoind.nix as follows
  # services.bitcoind.extraConfig = ''
  #   maxorphantx=110
  # '';
  ### CLIGHTNING
  # Enable clightning, a Lightning Network implementation in C.
  services.clightning.enable = true;
  nix-bitcoin.onionServices.clightning.public = true;
  # == Plugins
  # See ../README.md (Features → clightning) for the list of available plugins.
  # services.clightning.plugins.prometheus.enable = true;
  # == REST server
  # Set this to create a clightning REST onion service.
  # This also adds binary `lndconnect-clightning` to the system environment.
  # This binary creates QR codes or URLs for connecting applications to clightning
  # via the REST onion service.
  # You can also connect via WireGuard instead of Tor.
  # See ../docs/services.md for details.
  #
  services.clightning-rest = {
    enable = true;
    lndconnect = {
      enable = true;
    };
  };

  ### RIDE THE LIGHTNING
  # Set this to enable RTL, a web interface for lnd and clightning.
  services.rtl.enable = true;
  #
  # Set this to add a clightning node interface.
  # Automatically enables clightning.
  services.rtl.nodes.clightning.enable = true;

  ### MEMPOOL
  # Set this to enable mempool, a fully featured Bitcoin visualizer, explorer,
  # and API service.
  #
  # services.mempool.enable = true;

  ### ELECTRS
  # Set this to enable electrs, an Electrum server implemented in Rust.
  services.electrs.enable = true;

  ### Backups
  # Set this to enable nix-bitcoin's own backup service. By default, it
  # uses duplicity to incrementally back up all important files in /var/lib to
  # /var/lib/localBackups once a day.
  services.backups.enable = true;
  #
  # You can pull the localBackups folder with
  # `scp -r bitcoin-node:/var/lib/localBackups /my-backup-path/`
  networking.hostName = "bitcoin-node";
  time.timeZone = "UTC";

  services.openssh = {
    enable = true;
    settings.PasswordAuthentication = false;
  };
  users.users.root = {
    openssh.authorizedKeys.keys = [
	"ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIG1vVXat0bwBiNe1057RIqUW62Wnh4/qg8E+KIx7qqJR"
    ];
  };

  environment.systemPackages = with pkgs; [
    vim
  ];
  system.stateVersion = "23.05"; # Did you read the comment?

  # The nix-bitcoin release version that your config is compatible with.
  # When upgrading to a backwards-incompatible release, nix-bitcoin will display an
  # an error and provide instructions for migrating your config to the new release.
  nix-bitcoin.configVersion = "0.0.85";
}
