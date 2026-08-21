# Hyper-V Web Server Setup & DNS Configuration

This guide details the setup of a two-server environment in Hyper-V, specifically focusing on the network configuration and how Domain Name System (DNS) connects the two machines.

## Server Architecture

| Server | Role | IPv4 Address | Preferred DNS Server |
| :--- | :--- | :--- | :--- |
| **Server 1** | Active Directory Domain Controller (`dylaas.com`) & DNS Host | 200.1.1.1 | 127.0.0.1 (Itself) |
| **Server 2** | IIS Web Server (Joined to `dylaas.com`) | 200.1.1.2 | 200.1.1.1 (Server 1) |

---

## Phase 1: How DNS Connects Server 1 and Server 2

In an Active Directory environment, DNS is the glue that holds the network together. Without it, Server 2 would never be able to find Server 1 to join the `dylaas.com` domain.

### 1. The Role of Server 1 (The Directory)
When you promote Server 1 to a Domain Controller, it automatically installs the DNS Server role and creates a **Forward Lookup Zone** for `dylaas.com`. 
* It acts as the authoritative "phonebook" for your local network.
* It contains an **A Record** that maps its own hostname to the IP address `200.1.1.1`.
* It generates hidden **SRV (Service) records**. These advertise to the network that Server 1 handles user logins and security policies.

### 2. The Configuration of Server 2 (The Client)
For Server 2 to communicate with the domain, its network adapter must be explicitly told who holds the map of the network. 
* You must set the **Preferred DNS** on Server 2 to `200.1.1.1`. 
* If you skip this, Server 2 will search the global internet for `dylaas.com`, fail to find your local Domain Controller, and block you from joining the domain.

### 3. The Connection Process in Action
1. **The Query:** You type `dylaas.com` into the domain join prompt on Server 2.
2. **The Request:** Server 2 checks its network settings, sees `200.1.1.1` as its Preferred DNS, and asks Server 1, "Which IP address handles Active Directory for `dylaas.com`?"
3. **The Response:** Server 1 checks its DNS zone, finds the SRV records, and replies confirming that it handles those services at `200.1.1.1`.
4. **The Authentication:** Server 2 sends your administrator credentials to `200.1.1.1` to authenticate the domain join.
5. **Dynamic Registration:** Once joined, Server 2 registers its own hostname (e.g., `WEB01`) and IP address (`200.1.1.2`) back into Server 1's DNS zone. Now, any computer on the domain can reach the web server by name.

---

## Phase 2: Setup Instructions

### 1. Configure Server 1 (Domain Controller)
1. Install Windows Server and set the hostname (e.g., `DC01`).
2. Go to **Network Connections** > **IPv4 Properties**.
   * IP Address: `200.1.1.1`
   * Subnet Mask: `255.255.255.0`
   * Preferred DNS: `127.0.0.1`
3. Open **Server Manager** > **Add roles and features**.
4. Install **Active Directory Domain Services (AD DS)** and **DNS Server**.
5. Click the notification flag and select **Promote this server to a domain controller**.
6. Select **Add a new forest** and set the root domain name to `dylaas.com`.
7. Complete the wizard and reboot.

### 2. Configure Server 2 (Web Server)
1. Install Windows Server and set the hostname (e.g., `WEB01`).
2. Go to **Network Connections** > **IPv4 Properties**.
   * IP Address: `200.1.1.2`
   * Subnet Mask: `255.255.255.0`
   * **Preferred DNS: `200.1.1.1`** (Critical for domain join).
3. Open **Server Manager** > **Local Server**.
4. Click on the Workgroup name, click **Change...**, select **Domain**, and type `dylaas.com`.
5. Authenticate using the Domain Administrator credentials and restart the server.
6. Open **Server Manager** > **Add roles and features**.
7. Install the **Web Server (IIS)** role.

### 3. Final DNS Routing for the Web Server
To ensure clients can reach your website by typing `www.dylaas.com`:
1. Log into **Server 1**.
2. Open **DNS Manager** from the Server Manager Tools menu.
3. Expand your server name > **Forward Lookup Zones** > **dylaas.com**.
4. Right-click the empty space and select **New Host (A or AAAA)...**
5. Name: `www`
6. IP address: `200.1.1.2`
7. Click **Add Host**.
