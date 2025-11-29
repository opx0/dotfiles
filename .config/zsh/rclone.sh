# Offload Staging -> Cloud (Resumable)
alias cloud-push='rclone move ~/Staging gdrive-chunked:Staging --transfers 1 --progress'

# Backup Projects
# alias cloud-save='rclone sync ~/Projects gdrive-chunked:Backups/Projects --exclude "node_modules/**" --transfers 4 --progress'

# Toggle Speed Limit
alias cloud-boost='rclone rc core/bwlimit rate=off --rc-addr=localhost:5572'
alias cloud-chill='rclone rc core/bwlimit rate=1M --rc-addr=localhost:5572'
