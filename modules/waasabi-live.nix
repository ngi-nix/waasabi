{ config, lib, pkgs, ... }:

let
  cfg = config.services.waasabi-live;
in
{
  options.services.waasabi-live = with lib; {
    enable = mkEnableOption "Automatically configure nginx to host the waasabi frontend on this machine"; 
    package = mkOption {
      type = types.package;
      description = "The static-files to serve on nginx, may be changed";
      default = pkgs.waasabi-live;
    };
    url = mkOption {
      type = types.str;
      description = "The URL (nginx' server_name) of this instance e.g. \"localhost\" or \"example.org\"";
    };
    backendUrl = mkOption {
      type = types.str;
      description = "The URL where the waasabi backend is running, this is needed for waasabi-live to work correctly";
      default = "http://localhost:1337";
    };
  };

  config = with lib; mkIf cfg.enable {
    services.nginx = {
      enable = true;
      virtualHosts.${cfg.url} = {
        root = "${cfg.package}"; # TODO: configure package accordingly
        
        locations."/waasabi/" = {
          proxyPass = cfg.backendUrl;
          extraConfig = ''
            proxy_set_header        Host $host;
            proxy_set_header        X-Real-IP $remote_addr;
            proxy_set_header        X-Forwarded-For $proxy_add_x_forwarded_for;
            proxy_set_header        X-Forwarded-Proto $scheme;
            proxy_read_timeout  90;

            client_max_body_size 100M;
          '';
        };

        locations."/graphql/" = {
          proxyPass = cfg.backendUrl;
          extraConfig = ''
            add_header Access-Control-Allow-Origin "*";
            add_header Access-Control-Allow-Methods "GET,POST";
            add_header Access-Control-Allow-Headers "apollo-query-plan-experimental,authorization,content-type,x-apollo-tracing";
            add_header Access-Control-Expose-Headers "Authorization, *";

            proxy_set_header X-Real-IP $remote_addr;
            proxy_set_header Host $host;
            proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
            proxy_read_timeout 1d;

            proxy_http_version 1.1;
            proxy_set_header Upgrade $http_upgrade;
            proxy_set_header Connection "upgrade";
          '';
        };
      };
    };
  };
}
