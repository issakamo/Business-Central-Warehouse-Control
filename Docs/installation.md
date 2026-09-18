# Installation & Local Development Setup

## Prerequisites

- **Docker Desktop** (Windows/Linux containers, per your OS)
- **Visual Studio Code**
- **AL Language extension** (Microsoft, from the VS Code Marketplace)
- A Business Central **Docker artifact/on-premises sandbox image**
  (this project was developed against platform `28.0.53152.0`,
  application `28.3.52162.53166`, runtime `17.0`)

## 1. Start the Business Central container

Pull and run a sandbox artifact matching the versions above. Refer to
Microsoft's `bcartifacts` container documentation for the current
run command syntax, since image tags and helper scripts change
between releases.

Confirm the container is running and reachable (Web Client loads)
before proceeding.

## 2. Clone the repository

```bash
git clone https://github.com/issakamo/business-central-warehouse-control.git
cd business-central-warehouse-control
```

## 3. Configure your local launch settings

`launch.json` is intentionally **not** committed (it contains my
container's server URL and credentials). Copy the examplea, remane it launch.json and fill
in your own values:

```bash
cp launch.json.example .vscode/launch.json
```

Edit `.vscode/launch.json` with your container's server, port, tenant,
and authentication details.

## 4. Download symbols

With the container running and `launch.json` configured, in VS Code:

`Ctrl+Shift+P` → **AL: Download Symbols**

This pulls Base Application, System Application, and the Library
Assert test dependency (declared in `app.json`) from your running
container. Required before the project will compile with working
IntelliSense.

## 5. Publish the extension

`Ctrl+Shift+P` → **AL: Publish** (or F5)

This compiles and deploys the extension to your container.

## 6. Generate sample data (optional, development only)

Open **Inventory Exceptions** in the Business Central Web Client and
use the **Generate Sample Data (Dev Only)** action to populate
realistic exception records through the real detection codeunit
paths, for testing dashboards and reports. **Clear Sample Data (Dev
Only)** resets to zero first if you want a known clean baseline.

These actions live in `dev/` and are not part of the shippable
extension.

## 7. Run automated tests

Open any file under `test/Codeunits/` and use the **Run Test**
CodeLens above the codeunit or an individual test procedure or use
the **Test Tool** page inside the Business Central Web Client to run
the full suite.

## Troubleshooting

- **Compile errors referencing missing tables/codeunits after pulling
  changes** and re-run AL: Download Symbols; a dependency may have
  changed.
- **Event subscribers appear to have no effect**: event signatures
  are version-sensitive. Verify the subscriber's parameter list still
  matches the publisher's actual signature in your container's
  symbols (Go to Definition on the base app codeunit) before assuming
  application logic is at fault.
  