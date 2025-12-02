{ config, lib, pkgs, ... }:

{
  # Declarative git repository management
  systemd.services.setup-projects-repo = {
    description = "Setup projects git repository";
    wantedBy = [ "multi-user.target" ];
    after = [ "network.target" ];
    wants = [ "network.target" ];
    
    serviceConfig = {
      Type = "oneshot";
      RemainAfterExit = true;
      User = "jboe";
      Group = "users";
      # Restart on failure with backoff
      Restart = "on-failure";
      RestartSec = "30s";
    };
    
    path = [ pkgs.git pkgs.openssh pkgs.coreutils ];
    
    script = ''
      REPO_PATH="/home/jboe/projects"
      REPO_URL="git@github.com:JBoeCodes/projects.git"
      
      # Wait for network connectivity with timeout
      echo "Waiting for network connectivity..."
      for i in {1..30}; do
        if ping -c 1 -W 5 github.com >/dev/null 2>&1; then
          echo "Network is available"
          break
        fi
        if [ $i -eq 30 ]; then
          echo "Network timeout - skipping git operations"
          exit 0
        fi
        sleep 2
      done
      
      # Check if the directory exists and is a git repository
      if [ ! -d "$REPO_PATH/.git" ]; then
        echo "Cloning repository to $REPO_PATH..."
        git clone --recursive "$REPO_URL" "$REPO_PATH" || {
          echo "Failed to clone repository, will retry later"
          exit 1
        }
      else
        echo "Repository already exists at $REPO_PATH"
        
        # Optionally update the repository
        cd "$REPO_PATH"
        echo "Fetching latest changes..."
        git fetch || {
          echo "Failed to fetch updates, skipping"
          exit 0
        }
        
        # Update submodules
        echo "Updating submodules..."
        git submodule update --init --recursive || {
          echo "Failed to update submodules, skipping"
          exit 0
        }
      fi
      
      # Ensure correct permissions
      chmod 755 "$REPO_PATH"
    '';
  };
  
  # Ensure the parent directory exists with correct permissions
  systemd.tmpfiles.rules = [
    "d /home/jboe 0755 jboe users -"
  ];
}