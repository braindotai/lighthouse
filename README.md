# Lighthouse

Lighthouse is a modular, Docker-compose based self-hosted home server infrastructure. It centralizes services for media streaming, productivity, private cloud storage, network monitoring, security, local backups, and utilities under a unified administration framework.

The architecture isolates each service stack in its own directory, using a centralized Makefile for orchestrating single-stack, fleet-wide operations, and remote volume restoration.

## Application Directory

### Administration & Monitoring

<table>
  <tr>
    <td width="50%" valign="top">
      <br><strong>Beszel</strong><br>
      <a href="./beszel"><code>./beszel</code></a> &bull; Port <code>8090</code>
      <br>
      Lightweight host resource monitoring hub and agent.
      <br>
      <small><code>beszel</code>, <code>beszel-agent</code></small>
      <br><br>
    </td>
    <td width="50%" valign="top">
      <br><strong>Dockhand</strong><br>
      <a href="./dockhand"><code>./dockhand</code></a> &bull; Port <code>7070</code>
      <br>
      Direct Docker socket web management interface dashboard.
      <br>
      <small><code>dockhand</code></small>
      <br><br>
    </td>
  </tr>
  <tr>
    <td width="50%" valign="top">
      <br><strong>Uptime Kuma</strong><br>
      <a href="./uptimekuma"><code>./uptimekuma</code></a> &bull; Port <code>3001</code>
      <br>
      Service monitoring dashboard with AutoKuma integration.
      <br>
      <small><code>uptime-kuma</code>, <code>autokuma</code></small>
      <br><br>
    </td>
    <td width="50%" valign="top">
      <br><strong>Webmin</strong><br>
      <a href="./webmin"><code>./webmin</code></a> &bull; <em>Host-level</em>
      <br>
      Theme overrides and custom stylesheets for Webmin.
      <br>
      <small>Custom <code>style.css</code> theme</small>
      <br><br>
    </td>
  </tr>
</table>

### Data Sync & Productivity

<table>
  <tr>
    <td width="50%" valign="top">
      <br><strong>Nextcloud</strong><br>
      <a href="./nextcloud"><code>./nextcloud</code></a> &bull; Port <code>8080</code>
      <br>
      Private cloud storage, file sync, and collaboration suite.
      <br>
      <small><code>all-in-one</code> (AIO)</small>
      <br><br>
    </td>
    <td width="50%" valign="top">
      <br><strong>AFFiNE</strong><br>
      <a href="./affine"><code>./affine</code></a> &bull; Port <code>3010</code>
      <br>
      Collaborative workspace, canvas, and knowledge base.
      <br>
      <small><code>affine-stable</code>, <code>redis</code>, <code>pgvector</code></small>
      <br><br>
    </td>
  </tr>
  <tr>
    <td colspan="2" valign="top">
      <br><strong>BentoPDF</strong><br>
      <a href="./bentopdf"><code>./bentopdf</code></a> &bull; Port <code>3090</code>
      <br>
      Web-based PDF viewing, merging, and conversion utility.
      <br>
      <small><code>bentopdf-simple</code></small>
      <br><br>
    </td>
  </tr>
</table>

### Security & Privacy Utilities

<table>
  <tr>
    <td width="50%" valign="top">
      <br><strong>Vaultwarden</strong><br>
      <a href="./vaultwarden"><code>./vaultwarden</code></a> &bull; Port <code>8070</code>
      <br>
      Lightweight Bitwarden-compatible credentials backend.
      <br>
      <small><code>vaultwarden/server</code></small>
      <br><br>
    </td>
    <td width="50%" valign="top">
      <br><strong>Hemmelig</strong><br>
      <a href="./hemmelig"><code>./hemmelig</code></a> &bull; Port <code>3050</code>
      <br>
      Client-side encrypted notes and password sharing.
      <br>
      <small><code>hemmelig:v7</code></small>
      <br><br>
    </td>
  </tr>
  <tr>
    <td width="50%" valign="top">
      <br><strong>Karakeep</strong><br>
      <a href="./karakeep"><code>./karakeep</code></a> &bull; Port <code>3030</code>
      <br>
      Full-text bookmark archiver and snapshot manager.
      <br>
      <small><code>karakeep</code>, <code>alpine-chrome</code>, <code>meilisearch</code></small>
      <br><br>
    </td>
    <td width="50%" valign="top">
      <br><strong>Mazanoke</strong><br>
      <a href="./mazanoke"><code>./mazanoke</code></a> &bull; Port <code>3474</code>
      <br>
      Client-side, privacy-focused image optimizer.
      <br>
      <small><code>mazanoke</code></small>
      <br><br>
    </td>
  </tr>
</table>

### Media & Photos

<table>
  <tr>
    <td width="50%" valign="top">
      <br><strong>Theatre</strong><br>
      <a href="./theatre"><code>./theatre</code></a> &bull; <em>Multi-port</em>
      <br>
      Automated home media acquisition and streaming stack.
      <br>
      <small>Jellyfin, Seerr, Radarr, Sonarr, Bazarr, Prowlarr, qBittorrent, Gluetun</small>
      <br><br>
    </td>
    <td width="50%" valign="top">
      <br><strong>Immich</strong><br>
      <a href="./immich"><code>./immich</code></a> &bull; Port <code>2283</code>
      <br>
      High-performance self-hosted photo/video backup system.
      <br>
      <small><code>immich-server</code>, <code>immich-machine-learning</code>, <code>valkey</code>, <code>pgvecto-rs</code></small>
      <br><br>
    </td>
  </tr>
</table>

### Backups

<table>
  <tr>
    <td width="100%" valign="top">
      <br><strong>Backblaze</strong><br>
      <a href="./backblaze"><code>./backblaze</code></a> &bull; <em>Backup</em>
      <br>
      Encrypted remote backups to Backblaze B2 using Restic.
      <br>
      <small><code>restic-backup-docker</code></small>
      <br><br>
    </td>
  </tr>
</table>

### Theatre Port Allocations

The **Theatre** stack coordinates media management and secure downloads behind a Gluetun VPN container. Ports are allocated as follows:

<table>
  <thead>
    <tr>
      <th align="left">Service</th>
      <th align="left">Port</th>
      <th align="left">Routing Details / Purpose</th>
    </tr>
  </thead>
  <tbody>
    <tr>
      <td><strong>Jellyfin</strong></td>
      <td><code>8096</code></td>
      <td>Direct access media streaming server.</td>
    </tr>
    <tr>
      <td><strong>Seerr</strong></td>
      <td><code>5055</code></td>
      <td>Media request management dashboard.</td>
    </tr>
    <tr>
      <td><strong>Radarr</strong></td>
      <td><code>7878</code></td>
      <td>Automated movie manager.</td>
    </tr>
    <tr>
      <td><strong>Sonarr</strong></td>
      <td><code>8989</code></td>
      <td>Automated TV series manager.</td>
    </tr>
    <tr>
      <td><strong>Bazarr</strong></td>
      <td><code>6767</code></td>
      <td>Subtitles synchronization daemon.</td>
    </tr>
    <tr>
      <td><strong>Prowlarr</strong></td>
      <td><code>9696</code></td>
      <td>Torrent indexer proxy (routed via Gluetun VPN).</td>
    </tr>
    <tr>
      <td><strong>qBittorrent</strong></td>
      <td><code>8181</code></td>
      <td>Torrent client WebUI (routed via Gluetun VPN).</td>
    </tr>
    <tr>
      <td><strong>FlareSolverr</strong></td>
      <td><code>8191</code></td>
      <td>Cloudflare challenge bypass proxy (routed via Gluetun VPN).</td>
    </tr>
  </tbody>
</table>

---

## Makefile Workflows

A central [`Makefile`](./Makefile) handles automation, orchestration, security, and verification.

### Environment Management & Security
Executing `make setup-envs` scans the directory recursively for `.env` configuration files. For each file detected:
1. Applies strict file permissions (`chmod 600`) to secure credentials.
2. Extracts keys from the active `.env` file, stripping values and comment blocks, to generate a corresponding clean `env.example` file.
3. Minimizes configuration drift across stacks.

### Non-Destructive Data Restoration
The `make restore STACK=<stack_name>` workflow handles volume recoveries from Backblaze B2 using Restic. 

When invoked:
1. Validates stack folder existence.
2. Gracefully stops the running container stack to prevent file locks or database corruption.
3. Backs up the current local `./<STACK>/data` directory to `./<STACK>/data_backup_<timestamp>`.
4. Spins up a transient Restic container linked to the Backblaze stack.
5. Restores only the specific service subfolder `/data/<STACK>` into a temporary staging area.
6. Copies restored assets back into the stack volume with original permissions preserved (`cp -a`).
7. Removes temporary staging folders and restarts the target stack.

### Command Reference

#### Single-Stack Control
```bash
make up STACK=<stack_name>        # Spin up a specific service
make down STACK=<stack_name>      # Terminate a specific service
make restart STACK=<stack_name>   # Restart a specific service
make logs STACK=<stack_name>      # Tail container logs (limit 200 lines)
make ps STACK=<stack_name>        # Show active containers for a stack
```

#### Fleet-Wide Operations
```bash
make up-all                       # Spin up all configured stacks
make down-all                     # Stop all active stacks
make pull-all                     # Pull latest Docker images across all stacks
make update-all                   # Pull and recreate changed containers fleet-wide
```

#### Verification & Health Checks
```bash
make validate                     # Syntactically validate all docker-compose config files
make check-env-drift              # Compare .env with env.example to alert on missing keys
```
