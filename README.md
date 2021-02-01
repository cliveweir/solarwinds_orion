# solarwinds_orion module

#### Table of Contents

1. [Description](#description)
2. [Setup](#setup)
3. [Usage](#usage)
4. [Limitations](#limitations)
5. [Reference](#reference)
6. [Development](#development)

## Description

Puppet module for the managing the SolarWinds Orion Platform.

## Setup

## Usage

This module contains a single task for detecting the version of the Orion platform.

## Limitations

This module uses powershell and therefore only runs on Windows.

## Reference

### `solarwinds_orion::version`

Detects if the SolarWinds Orion Platform is installed and reports the version and hotfix version.

#### Output

Not installed:
<pre>
{
    "status": "SolarWinds Orion is not installed",
    "version": "",
    "hotfix": 0
}
</pre>

Installed and version detected successfully:
<pre>
{
  "status": "SolarWinds Orion 2020.2.1 HF2 detected",
  "version": "2020.2.1",
  "hotfix": 2
}
or:
{
  "status": "SolarWinds Orion 2020.2.4 (no hotfix) detected",
  "version": "2020.2.4",
  "hotfix": 0
}
</pre>

Installed and version not detected:
<pre>
{
  "status": "SolarWinds Orion detected, login to check the hotfix version",
  "version": "",
  "hotfix": 0
}
</pre>

Installed and version partially detected:
<pre>
{
  "status": "SolarWinds Orion 2020.2.4 detected, login to check the hotfix version",
  "version": "2020.2.4",
  "hotfix": 0
}
</pre>

## Development

TBD.