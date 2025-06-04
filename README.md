# Chesskeeper Cloud Setup

This package includes:
- `cloud-config.yaml`: A minimal cloud-init setup for Hetzner Cloud servers
- A central `Makefile` to orchestrate installation
- `docker-compose.yml` for Caddy and PHP-FPM setup
- `Caddyfile` for HTTPS and PHP routing

## Usage

1. When creating a new Hetzner Cloud server, in the "User Data" section, enter:

```
#include
https://raw.githubusercontent.com/14code/chesskeeper-infra/main/cloud-config.yaml
```

2. Ensure your public SSH key is included in `cloud-config.yaml`.

3. The server will install system dependencies and download the `Makefile`.

4. You can then run:

```bash
make install
```

## Notes

- This setup uses Caddy for automatic HTTPS via Let's Encrypt.
- All files are managed through the `infra` repository.
- No private keys or tokens are exposed through cloud-init.



## Volume Setup

To attach persistent data (e.g., uploads, SQLite DBs):

1. Create a Hetzner Cloud Volume (e.g., 10–50 GB)
2. Attach it to your server (usually as `/dev/sdb`)
3. SSH into your server and run:

```bash
make volume
```

This will:
- Format the volume as ext4 (if no filesystem is detected)
- Set the label to `chessdata`
- Mount it to `/mnt/chesskeeper-data`
- Add it to `/etc/fstab`
- Ensure it's owned by `chesskeeper:chesskeeper`

To force a reformat (e.g., after reassigning a reused volume):

```bash
FORCE_FORMAT=1 make volume
```
