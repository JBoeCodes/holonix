{ config, lib, pkgs, ... }:

{
  # Declarative git repository management
  systemd.services.setup-projects-repo = {
    description = "Setup projects git repository";
    wantedBy = [ "multi-user.target" ];
    after = [ "network-online.target" ];
    wants = [ "network-online.target" ];
    
    serviceConfig = {
      Type = "oneshot";
      RemainAfterExit = true;
      User = "jboe";
      Group = "users";
    };
    
    path = [ pkgs.git pkgs.openssh ];
    
    script = ''
      REPO_PATH="/home/jboe/projects"
      REPO_URL="git@github.com:JBoeCodes/projects.git"
      
      # Check if the directory exists and is a git repository
      if [ ! -d "$REPO_PATH/.git" ]; then
        echo "Cloning repository to $REPO_PATH..."
        git clone --recursive "$REPO_URL" "$REPO_PATH"
      else
        echo "Repository already exists at $REPO_PATH"
        
        # Optionally update the repository
        cd "$REPO_PATH"
        echo "Fetching latest changes..."
        git fetch
        
        # Update submodules
        echo "Updating submodules..."
        git submodule update --init --recursive
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